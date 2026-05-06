unit uChartUtilsUnit;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes, System.Variants, System.Math, System.Types,
  Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls,
  Data.DB;

type
  TChartPoint = record
    LabelText: string;
    Value: Double;
  end;

  TChartPoints = array of TChartPoint;

  TChartRenderOptions = record
    Title: string;
    Subtitle: string;
    SeriesName: string;
    YAxisTitle: string;
    ValueFormat: string;
    EmptyText: string;
    ShowDataLabels: Boolean;
  end;

procedure CollectChartPointsFromDS(ADs: TDataSet; const ALabelField, AValueField: string; out Pts: TChartPoints);

function NewChartOptions(
  const ATitle, ASeriesName, ASubtitle, AYAxisTitle, AValueFormat: string;
  AShowDataLabels: Boolean = True
): TChartRenderOptions;

procedure DrawBarChart(APaintBox: TPaintBox; const Pts: TChartPoints; const ATitle: string); overload;
procedure DrawBarChart(APaintBox: TPaintBox; const Pts: TChartPoints; const AOptions: TChartRenderOptions); overload;

procedure DrawLineChart(APaintBox: TPaintBox; const Pts: TChartPoints; const ATitle: string); overload;
procedure DrawLineChart(APaintBox: TPaintBox; const Pts: TChartPoints; const AOptions: TChartRenderOptions); overload;

procedure DrawPieChart(APaintBox: TPaintBox; const Pts: TChartPoints; const ATitle: string); overload;
procedure DrawPieChart(APaintBox: TPaintBox; const Pts: TChartPoints; const AOptions: TChartRenderOptions); overload;

implementation

const
  CHART_BG = $00F7F8FA;
  PANEL_BG = clWhite;
  BORDER_CLR = $00D8DEE7;
  GRID_CLR = $00E8EDF3;
  AXIS_CLR = $00808B98;
  TITLE_CLR = $002B2F33;
  SUBTITLE_CLR = $00677380;
  LABEL_CLR = $003C4652;

function PaletteColor(AIndex: Integer): TColor;
const
  Palette: array[0..7] of TColor = (
    $00D9B38C,
    $00A9C5A0,
    $00C6A0D8,
    $009AB7E3,
    $00B5A08C,
    $00D9C38C,
    $00A0C9C1,
    $00B7B7D9
  );
begin
  Result := Palette[AIndex mod Length(Palette)];
end;

function RectWidth(const R: TRect): Integer;
begin
  Result := R.Right - R.Left;
end;

function RectHeight(const R: TRect): Integer;
begin
  Result := R.Bottom - R.Top;
end;

function ShortenTextToFit(ACanvas: TCanvas; const S: string; AMaxWidth: Integer): string;
var
  T: string;
begin
  Result := S;
  if (S = '') or (AMaxWidth <= 0) then Exit;
  if ACanvas.TextWidth(S) <= AMaxWidth then Exit;

  T := S;
  while (T <> '') and (ACanvas.TextWidth(T + '...') > AMaxWidth) do
    Delete(T, Length(T), 1);

  if T = '' then
    Result := S
  else
    Result := T + '...';
end;

function FormatChartValue(AValue: Double; const AFormat: string): string;
begin
  if Trim(AFormat) <> '' then
    Result := FormatFloat(AFormat, AValue)
  else if Frac(AValue) = 0 then
    Result := FormatFloat('#,##0', AValue)
  else
    Result := FormatFloat('#,##0.##', AValue);
end;

function MaxValueOf(const Pts: TChartPoints): Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(Pts) do
    if Pts[I].Value > Result then
      Result := Pts[I].Value;
end;

function SumValueOf(const Pts: TChartPoints): Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(Pts) do
    if Pts[I].Value > 0 then
      Result := Result + Pts[I].Value;
end;

function NiceAxisMax(const AValue: Double): Double;
var
  Base, Scaled: Double;
begin
  if AValue <= 0 then
    Exit(1);

  Base := Power(10, Floor(Log10(AValue)));
  Scaled := AValue / Base;

  if Scaled <= 1 then
    Result := 1 * Base
  else if Scaled <= 2 then
    Result := 2 * Base
  else if Scaled <= 5 then
    Result := 5 * Base
  else
    Result := 10 * Base;

  if Result < AValue then
    Result := Result * 1.2;
end;

function NewChartOptions(
  const ATitle, ASeriesName, ASubtitle, AYAxisTitle, AValueFormat: string;
  AShowDataLabels: Boolean
): TChartRenderOptions;
begin
  Result.Title := ATitle;
  Result.Subtitle := ASubtitle;
  Result.SeriesName := ASeriesName;
  Result.YAxisTitle := AYAxisTitle;
  Result.ValueFormat := AValueFormat;
  Result.EmptyText := 'Нет данных для построения графика.';
  Result.ShowDataLabels := AShowDataLabels;
end;

procedure CollectChartPointsFromDS(ADs: TDataSet; const ALabelField, AValueField: string; out Pts: TChartPoints);
var
  Bmk: TBookmark;
  I: Integer;
begin
  SetLength(Pts, 0);

  if (ADs = nil) or (not ADs.Active) then Exit;
  if (ADs.FindField(ALabelField) = nil) or (ADs.FindField(AValueField) = nil) then Exit;

  ADs.DisableControls;
  Bmk := ADs.GetBookmark;
  try
    ADs.First;
    I := 0;
    while not ADs.Eof do
    begin
      SetLength(Pts, I + 1);
      Pts[I].LabelText := Trim(ADs.FieldByName(ALabelField).AsString);
      Pts[I].Value := ADs.FieldByName(AValueField).AsFloat;
      Inc(I);
      ADs.Next;
    end;
  finally
    if ADs.BookmarkValid(Bmk) then
      ADs.GotoBookmark(Bmk);
    ADs.FreeBookmark(Bmk);
    ADs.EnableControls;
  end;
end;

procedure PrepareCanvas(ACanvas: TCanvas; const R: TRect);
begin
  ACanvas.Brush.Style := bsSolid;
  ACanvas.Brush.Color := CHART_BG;
  ACanvas.FillRect(R);

  ACanvas.Font.Name := 'Arial';
  ACanvas.Font.Charset := RUSSIAN_CHARSET;
  ACanvas.Font.Color := LABEL_CLR;
  ACanvas.Font.Size := 9;
  ACanvas.Pen.Color := BORDER_CLR;
end;

procedure DrawPanel(ACanvas: TCanvas; const R: TRect; AFillColor: TColor = PANEL_BG);
begin
  ACanvas.Brush.Color := AFillColor;
  ACanvas.Pen.Color := BORDER_CLR;
  ACanvas.Rectangle(R);
end;

procedure DrawLegendSingle(ACanvas: TCanvas; const R: TRect; const ASeriesName: string; AColor: TColor);
var
  TextR: TRect;
begin
  if Trim(ASeriesName) = '' then Exit;

  DrawPanel(ACanvas, R, PANEL_BG);

  ACanvas.Brush.Color := AColor;
  ACanvas.Pen.Color := AColor;
  ACanvas.Rectangle(R.Left + 10, R.Top + 10, R.Left + 24, R.Top + 24);

  ACanvas.Brush.Style := bsClear;
  ACanvas.Font.Style := [];
  ACanvas.Font.Color := LABEL_CLR;

  TextR := Rect(R.Left + 32, R.Top + 8, R.Right - 8, R.Bottom - 8);
  DrawText(ACanvas.Handle, PChar(ASeriesName), Length(ASeriesName), TextR,
    DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS);
end;

procedure DrawTitleBlock(
  ACanvas: TCanvas;
  const R: TRect;
  const AOptions: TChartRenderOptions;
  out APlotTop: Integer
);
var
  Y: Integer;
begin
  Y := R.Top + 14;

  ACanvas.Brush.Style := bsClear;
  ACanvas.Font.Name := 'Arial';
  ACanvas.Font.Charset := RUSSIAN_CHARSET;
  ACanvas.Font.Color := TITLE_CLR;
  ACanvas.Font.Size := 13;
  ACanvas.Font.Style := [fsBold];
  ACanvas.TextOut(R.Left + 18, Y, AOptions.Title);

  Inc(Y, ACanvas.TextHeight('Wy') + 4);

  if Trim(AOptions.Subtitle) <> '' then
  begin
    ACanvas.Font.Size := 9;
    ACanvas.Font.Style := [];
    ACanvas.Font.Color := SUBTITLE_CLR;
    ACanvas.TextOut(R.Left + 18, Y, AOptions.Subtitle);
    Inc(Y, ACanvas.TextHeight('Wy') + 8);
  end
  else
    Inc(Y, 8);

  APlotTop := Y;
end;

procedure DrawEmptyState(ACanvas: TCanvas; const R: TRect; const AMessage: string);
var
  MsgRect: TRect;
begin
  DrawPanel(ACanvas, R, PANEL_BG);

  ACanvas.Brush.Style := bsClear;
  ACanvas.Font.Name := 'Arial';
  ACanvas.Font.Charset := RUSSIAN_CHARSET;
  ACanvas.Font.Size := 11;
  ACanvas.Font.Style := [];
  ACanvas.Font.Color := SUBTITLE_CLR;

  MsgRect := Rect(R.Left + 16, R.Top + 16, R.Right - 16, R.Bottom - 16);
  DrawText(ACanvas.Handle, PChar(AMessage), Length(AMessage), MsgRect,
    DT_CENTER or DT_VCENTER or DT_WORDBREAK or DT_NOPREFIX);
end;

procedure DrawBarChart(APaintBox: TPaintBox; const Pts: TChartPoints; const ATitle: string);
begin
  DrawBarChart(APaintBox, Pts, NewChartOptions(ATitle, 'Значение', '', '', '#,##0', True));
end;

procedure DrawLineChart(APaintBox: TPaintBox; const Pts: TChartPoints; const ATitle: string);
begin
  DrawLineChart(APaintBox, Pts, NewChartOptions(ATitle, 'Значение', '', '', '#,##0', True));
end;

procedure DrawPieChart(APaintBox: TPaintBox; const Pts: TChartPoints; const ATitle: string);
begin
  DrawPieChart(APaintBox, Pts, NewChartOptions(ATitle, 'Распределение', '', '', '#,##0', True));
end;

procedure DrawBarChart(APaintBox: TPaintBox; const Pts: TChartPoints; const AOptions: TChartRenderOptions);
var
  C: TCanvas;
  R, PlotR, LegendR: TRect;
  PlotTop: Integer;
  PlotW, PlotH: Integer;
  AxisMax, TickValue, Scale: Double;
  TickCount: Integer;
  I, StepLbl, BarW, Gap, X, Y, H, BaseY, LabelY: Integer;
  S, DataText: string;
  TextW: Integer;
begin
  if APaintBox = nil then Exit;

  C := APaintBox.Canvas;
  R := APaintBox.ClientRect;

  PrepareCanvas(C, R);
  DrawTitleBlock(C, R, AOptions, PlotTop);

  LegendR := Rect(R.Right - 190, PlotTop - 40, R.Right - 18, PlotTop - 8);
  DrawLegendSingle(C, LegendR, AOptions.SeriesName, PaletteColor(0));

  PlotR := Rect(R.Left + 82, PlotTop + 12, R.Right - 24, R.Bottom - 72);
  if (RectWidth(PlotR) < 160) or (RectHeight(PlotR) < 120) then Exit;

  if Length(Pts) = 0 then
  begin
    DrawEmptyState(C, PlotR, AOptions.EmptyText);
    Exit;
  end;

  DrawPanel(C, PlotR, PANEL_BG);

  C.Brush.Style := bsClear;
  C.Font.Name := 'Arial';
  C.Font.Charset := RUSSIAN_CHARSET;
  C.Font.Size := 8;
  C.Font.Style := [];

  PlotW := RectWidth(PlotR);
  PlotH := RectHeight(PlotR);

  AxisMax := NiceAxisMax(MaxValueOf(Pts));
  if AxisMax <= 0 then AxisMax := 1;
  TickCount := 5;
  Scale := (PlotH - 28) / AxisMax;
  BaseY := PlotR.Bottom - 24;

  C.Pen.Color := GRID_CLR;
  for I := 0 to TickCount do
  begin
    Y := BaseY - Round((PlotH - 28) * I / TickCount);
    C.MoveTo(PlotR.Left + 1, Y);
    C.LineTo(PlotR.Right - 1, Y);

    TickValue := AxisMax * I / TickCount;
    S := FormatChartValue(TickValue, AOptions.ValueFormat);
    C.Font.Color := SUBTITLE_CLR;
    C.TextOut(PlotR.Left - C.TextWidth(S) - 10, Y - (C.TextHeight('Wy') div 2), S);
  end;

  C.Pen.Color := AXIS_CLR;
  C.MoveTo(PlotR.Left, PlotR.Top + 8);
  C.LineTo(PlotR.Left, BaseY);
  C.LineTo(PlotR.Right - 4, BaseY);

  if Trim(AOptions.YAxisTitle) <> '' then
  begin
    C.Font.Color := SUBTITLE_CLR;
    C.Font.Style := [fsBold];
    C.TextOut(PlotR.Left, PlotR.Top - 18, AOptions.YAxisTitle);
    C.Font.Style := [];
  end;

  Gap := Max(8, PlotW div Max(Length(Pts) * 5, 20));
  BarW := Max(18, (PlotW - Gap * (Length(Pts) + 1)) div Max(1, Length(Pts)));
  if BarW > 54 then
    BarW := 54;

  StepLbl := Max(1, Ceil(Length(Pts) / 8));
  X := PlotR.Left + Gap;

  for I := 0 to High(Pts) do
  begin
    H := Round(Pts[I].Value * Scale);
    Y := BaseY - H;

    C.Brush.Style := bsSolid;
    C.Brush.Color := PaletteColor(I);
    C.Pen.Color := $008A98A8;
    C.Rectangle(X, Y, X + BarW, BaseY);

    if AOptions.ShowDataLabels and (Length(Pts) <= 14) then
    begin
      DataText := FormatChartValue(Pts[I].Value, AOptions.ValueFormat);
      C.Brush.Style := bsClear;
      C.Font.Color := LABEL_CLR;
      TextW := C.TextWidth(DataText);
      C.TextOut(X + (BarW div 2) - (TextW div 2), Y - C.TextHeight('Wy') - 3, DataText);
    end;

    if (I mod StepLbl) = 0 then
    begin
      S := ShortenTextToFit(C, Pts[I].LabelText, Max(BarW + Gap, 70));
      TextW := C.TextWidth(S);
      LabelY := BaseY + 6;
      C.Font.Color := LABEL_CLR;
      C.TextOut(X + (BarW div 2) - (TextW div 2), LabelY, S);
    end;

    Inc(X, BarW + Gap);
  end;
end;

procedure DrawLineChart(APaintBox: TPaintBox; const Pts: TChartPoints; const AOptions: TChartRenderOptions);
var
  C: TCanvas;
  R, PlotR, LegendR: TRect;
  PlotTop: Integer;
  PlotW, PlotH: Integer;
  AxisMax, TickValue, Scale: Double;
  TickCount: Integer;
  I, StepLbl, X0, Y0, XStep, X, Y, LabelY: Integer;
  S, DataText: string;
  TextW: Integer;
begin
  if APaintBox = nil then Exit;

  C := APaintBox.Canvas;
  R := APaintBox.ClientRect;

  PrepareCanvas(C, R);
  DrawTitleBlock(C, R, AOptions, PlotTop);

  LegendR := Rect(R.Right - 190, PlotTop - 40, R.Right - 18, PlotTop - 8);
  DrawLegendSingle(C, LegendR, AOptions.SeriesName, PaletteColor(3));

  PlotR := Rect(R.Left + 82, PlotTop + 12, R.Right - 24, R.Bottom - 72);
  if (RectWidth(PlotR) < 160) or (RectHeight(PlotR) < 120) then Exit;

  if Length(Pts) = 0 then
  begin
    DrawEmptyState(C, PlotR, AOptions.EmptyText);
    Exit;
  end;

  DrawPanel(C, PlotR, PANEL_BG);

  C.Brush.Style := bsClear;
  C.Font.Name := 'Arial';
  C.Font.Charset := RUSSIAN_CHARSET;
  C.Font.Size := 8;
  C.Font.Style := [];

  PlotW := RectWidth(PlotR);
  PlotH := RectHeight(PlotR);

  AxisMax := NiceAxisMax(MaxValueOf(Pts));
  if AxisMax <= 0 then AxisMax := 1;
  TickCount := 5;
  Scale := (PlotH - 28) / AxisMax;
  Y0 := PlotR.Bottom - 24;

  C.Pen.Color := GRID_CLR;
  for I := 0 to TickCount do
  begin
    Y := Y0 - Round((PlotH - 28) * I / TickCount);
    C.MoveTo(PlotR.Left + 1, Y);
    C.LineTo(PlotR.Right - 1, Y);

    TickValue := AxisMax * I / TickCount;
    S := FormatChartValue(TickValue, AOptions.ValueFormat);
    C.Font.Color := SUBTITLE_CLR;
    C.TextOut(PlotR.Left - C.TextWidth(S) - 10, Y - (C.TextHeight('Wy') div 2), S);
  end;

  C.Pen.Color := AXIS_CLR;
  C.MoveTo(PlotR.Left, PlotR.Top + 8);
  C.LineTo(PlotR.Left, Y0);
  C.LineTo(PlotR.Right - 4, Y0);

  if Trim(AOptions.YAxisTitle) <> '' then
  begin
    C.Font.Color := SUBTITLE_CLR;
    C.Font.Style := [fsBold];
    C.TextOut(PlotR.Left, PlotR.Top - 18, AOptions.YAxisTitle);
    C.Font.Style := [];
  end;

  X0 := PlotR.Left + 14;
  if Length(Pts) > 1 then
    XStep := (PlotW - 28) div (Length(Pts) - 1)
  else
    XStep := 0;

  StepLbl := Max(1, Ceil(Length(Pts) / 8));

  C.Pen.Color := PaletteColor(3);
  C.Pen.Width := 2;
  for I := 0 to High(Pts) do
  begin
    X := X0 + I * XStep;
    Y := Y0 - Round(Pts[I].Value * Scale);

    if I = 0 then
      C.MoveTo(X, Y)
    else
      C.LineTo(X, Y);
  end;

  C.Pen.Width := 1;
  for I := 0 to High(Pts) do
  begin
    X := X0 + I * XStep;
    Y := Y0 - Round(Pts[I].Value * Scale);

    C.Brush.Style := bsSolid;
    C.Brush.Color := PaletteColor(3);
    C.Pen.Color := clWhite;
    C.Ellipse(X - 4, Y - 4, X + 5, Y + 5);

    if AOptions.ShowDataLabels and (Length(Pts) <= 18) then
    begin
      DataText := FormatChartValue(Pts[I].Value, AOptions.ValueFormat);
      C.Brush.Style := bsClear;
      C.Font.Color := LABEL_CLR;
      TextW := C.TextWidth(DataText);
      C.TextOut(X - (TextW div 2), Y - C.TextHeight('Wy') - 5, DataText);
    end;

    if (I mod StepLbl) = 0 then
    begin
      S := ShortenTextToFit(C, Pts[I].LabelText, 80);
      TextW := C.TextWidth(S);
      LabelY := Y0 + 6;
      C.Font.Color := LABEL_CLR;
      C.TextOut(X - (TextW div 2), LabelY, S);
    end;
  end;
end;

procedure DrawPieChart(APaintBox: TPaintBox; const Pts: TChartPoints; const AOptions: TChartRenderOptions);
var
  C: TCanvas;
  R, PieR, LegendR: TRect;
  PlotTop: Integer;
  SumV, A0, A1, MidA, Pct: Double;
  I, CX, CY, Rad, BoxSize, RowH, TextY: Integer;
  S: string;
begin
  if APaintBox = nil then Exit;

  C := APaintBox.Canvas;
  R := APaintBox.ClientRect;

  PrepareCanvas(C, R);
  DrawTitleBlock(C, R, AOptions, PlotTop);

  LegendR := Rect(R.Right - 260, PlotTop + 8, R.Right - 18, R.Bottom - 24);
  PieR := Rect(R.Left + 24, PlotTop + 18, LegendR.Left - 16, R.Bottom - 24);

  if Length(Pts) = 0 then
  begin
    DrawEmptyState(C, PieR, AOptions.EmptyText);
    Exit;
  end;

  DrawPanel(C, PieR, PANEL_BG);
  DrawPanel(C, LegendR, PANEL_BG);

  SumV := SumValueOf(Pts);
  if SumV <= 0 then
  begin
    DrawEmptyState(C, PieR, AOptions.EmptyText);
    Exit;
  end;

  CX := (PieR.Left + PieR.Right) div 2;
  CY := (PieR.Top + PieR.Bottom) div 2;
  Rad := Min(RectWidth(PieR), RectHeight(PieR)) div 2 - 18;
  if Rad < 40 then Exit;

  A0 := -Pi / 2;
  for I := 0 to High(Pts) do
  begin
    if Pts[I].Value <= 0 then Continue;

    A1 := A0 + (2 * Pi * (Pts[I].Value / SumV));

    C.Brush.Style := bsSolid;
    C.Brush.Color := PaletteColor(I);
    C.Pen.Color := clWhite;
    C.Pie(CX - Rad, CY - Rad, CX + Rad, CY + Rad,
      CX + Round(Rad * Cos(A1)), CY + Round(Rad * Sin(A1)),
      CX + Round(Rad * Cos(A0)), CY + Round(Rad * Sin(A0)));

    MidA := (A0 + A1) / 2;
    if AOptions.ShowDataLabels and (Length(Pts) <= 8) then
    begin
      Pct := (Pts[I].Value / SumV) * 100;
      S := FormatFloat('0.0', Pct) + '%';
      C.Brush.Style := bsClear;
      C.Font.Name := 'Arial';
      C.Font.Charset := RUSSIAN_CHARSET;
      C.Font.Size := 8;
      C.Font.Color := LABEL_CLR;
      C.TextOut(
        CX + Round((Rad * 0.60) * Cos(MidA)) - (C.TextWidth(S) div 2),
        CY + Round((Rad * 0.60) * Sin(MidA)) - (C.TextHeight('Wy') div 2),
        S
      );
    end;

    A0 := A1;
  end;

  C.Brush.Style := bsClear;
  C.Font.Name := 'Arial';
  C.Font.Charset := RUSSIAN_CHARSET;
  C.Font.Size := 10;
  C.Font.Style := [fsBold];
  C.Font.Color := TITLE_CLR;
  S := #1042#1089#1077#1075#1086;
  C.TextOut(CX - (C.TextWidth(S) div 2), CY - 14, S);
  C.Font.Size := 11;
  C.TextOut(CX - (C.TextWidth(FormatChartValue(SumV, '#,##0')) div 2), CY + 2, FormatChartValue(SumV, '#,##0'));

  C.Font.Style := [];
  C.Font.Size := 9;
  RowH := 24;
  BoxSize := 14;
  TextY := LegendR.Top + 14;

  if Trim(AOptions.SeriesName) <> '' then
  begin
    C.Font.Style := [fsBold];
    C.Font.Color := TITLE_CLR;
    C.TextOut(LegendR.Left + 12, TextY, AOptions.SeriesName);
    C.Font.Style := [];
    Inc(TextY, 24);
  end;

  for I := 0 to High(Pts) do
  begin
    if TextY + RowH > LegendR.Bottom - 10 then Break;

    C.Brush.Style := bsSolid;
    C.Brush.Color := PaletteColor(I);
    C.Pen.Color := PaletteColor(I);
    C.Rectangle(LegendR.Left + 12, TextY + 2, LegendR.Left + 12 + BoxSize, TextY + 2 + BoxSize);

    Pct := 0;
    if SumV > 0 then
      Pct := (Pts[I].Value / SumV) * 100;

    C.Brush.Style := bsClear;
    C.Font.Name := 'Arial';
    C.Font.Charset := RUSSIAN_CHARSET;
    C.Font.Size := 9;
    C.Font.Color := LABEL_CLR;

    S := ShortenTextToFit(C, Pts[I].LabelText, 118);
    C.TextOut(LegendR.Left + 34, TextY, S);

    S := FormatChartValue(Pts[I].Value, AOptions.ValueFormat) + ' (' + FormatFloat('0.0', Pct) + '%)';
    C.Font.Color := SUBTITLE_CLR;
    C.TextOut(LegendR.Left + 34, TextY + 11, S);

    Inc(TextY, RowH);
  end;
end;

end.