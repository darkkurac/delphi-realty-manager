unit uReportUtilsUnit;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes, System.Variants, System.Types, System.Math,
  Data.DB,
  Vcl.Printers, Vcl.Graphics;

procedure ExportDataSetToCSV(ADs: TDataSet; const AFileName: string; ADelimiter: Char = ';');
procedure PrintDataSetTable(ADs: TDataSet; const ATitle: string); overload;
procedure PrintDataSetTable(ADs: TDataSet; const ATitle: string;
  ALandscape: Boolean; const AFieldNames: array of string); overload;

implementation

type
  TFieldArray = array of TField;

function CsvEscape(const S: string; Delim: Char): string;
var
  T: string;
begin
  T := S;
  if Pos('"', T) > 0 then
    T := StringReplace(T, '"', '""', [rfReplaceAll]);

  if (Pos(Delim, T) > 0) or (Pos(#10, T) > 0) or (Pos(#13, T) > 0) or (Pos('"', T) > 0) then
    Result := '"' + T + '"'
  else
    Result := T;
end;

function FieldAlreadyAdded(const AFields: TFieldArray; AField: TField): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to High(AFields) do
    if AFields[I] = AField then
      Exit(True);
end;

procedure AppendField(var AFields: TFieldArray; AField: TField);
begin
  if AField = nil then Exit;
  if FieldAlreadyAdded(AFields, AField) then Exit;
  SetLength(AFields, Length(AFields) + 1);
  AFields[High(AFields)] := AField;
end;

function BuildPrintFieldList(ADs: TDataSet; const AFieldNames: array of string): TFieldArray;
var
  I: Integer;
  F: TField;
begin
  SetLength(Result, 0);

  if (ADs = nil) or (not ADs.Active) then Exit;

  if Length(AFieldNames) > 0 then
  begin
    for I := 0 to High(AFieldNames) do
    begin
      F := ADs.FindField(AFieldNames[I]);
      if F <> nil then
        AppendField(Result, F);
    end;
  end;

  if Length(Result) = 0 then
    for I := 0 to ADs.FieldCount - 1 do
      if ADs.Fields[I].Visible then
        AppendField(Result, ADs.Fields[I]);

  if Length(Result) = 0 then
    for I := 0 to ADs.FieldCount - 1 do
      if not (ADs.Fields[I].DataType in [ftBlob, ftGraphic, ftStream, ftOraBlob, ftOraClob]) then
        AppendField(Result, ADs.Fields[I]);
end;

procedure ExportDataSetToCSV(ADs: TDataSet; const AFileName: string; ADelimiter: Char);
var
  W: TStreamWriter;
  I: Integer;
  Line: string;
  Bmk: TBookmark;
  Enc: TEncoding;
  Fields: TFieldArray;
begin
  if (ADs = nil) or (not ADs.Active) then Exit;

  Fields := BuildPrintFieldList(ADs, []);
  if Length(Fields) = 0 then Exit;

  Enc := TUTF8Encoding.Create(True);
  W := TStreamWriter.Create(AFileName, False, Enc);
  try
    Line := '';
    for I := 0 to High(Fields) do
    begin
      if I > 0 then Line := Line + ADelimiter;
      Line := Line + CsvEscape(Fields[I].DisplayLabel, ADelimiter);
    end;
    W.WriteLine(Line);

    ADs.DisableControls;
    Bmk := ADs.GetBookmark;
    try
      ADs.First;
      while not ADs.Eof do
      begin
        Line := '';
        for I := 0 to High(Fields) do
        begin
          if I > 0 then Line := Line + ADelimiter;
          if Fields[I].IsNull then
            Line := Line + ''
          else
            Line := Line + CsvEscape(Fields[I].DisplayText, ADelimiter);
        end;
        W.WriteLine(Line);
        ADs.Next;
      end;
    finally
      if ADs.BookmarkValid(Bmk) then
        ADs.GotoBookmark(Bmk);
      ADs.FreeBookmark(Bmk);
      ADs.EnableControls;
    end;
  finally
    W.Free;
    Enc.Free;
  end;
end;

procedure PrintDataSetTable(ADs: TDataSet; const ATitle: string);
begin
  PrintDataSetTable(ADs, ATitle, False, []);
end;

procedure PrintDataSetTable(ADs: TDataSet; const ATitle: string;
  ALandscape: Boolean; const AFieldNames: array of string);
const
  MARGIN_L_MM = 12;
  MARGIN_T_MM = 12;
  MARGIN_R_MM = 12;
  MARGIN_B_MM = 12;

  CELL_PAD_X = 4;
  CELL_PAD_Y = 2;

  MAX_SCAN_ROWS = 60;
  MAX_CELL_LINES = 3;
var
  P: TPrinter;
  PageW, PageH: Integer;
  LM, TM, RM, BM: Integer;
  DpiX, DpiY: Integer;
  TitleH, HeaderH, FooterH: Integer;
  Y, X: Integer;
  PageNo: Integer;
  RecordCount: Integer;
  HasDataRows: Boolean;
  Fields: TFieldArray;
  ColW: array of Integer;
  MinW: array of Integer;
  NeedW: array of Integer;
  Bmk: TBookmark;
  I, J: Integer;

  function MmToPxX(const Mm: Double): Integer;
  begin
    Result := Round(DpiX * (Mm / 25.4));
  end;

  function MmToPxY(const Mm: Double): Integer;
  begin
    Result := Round(DpiY * (Mm / 25.4));
  end;

  function FieldText(F: TField): string;
  begin
    if (F = nil) or F.IsNull then
      Result := ''
    else
      Result := Trim(F.DisplayText);
  end;

  function GetMinColWidth(AField: TField): Integer;
  begin
    case AField.DataType of
      ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint:
        Result := MmToPxX(18);
      ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftSingle, ftExtended:
        Result := MmToPxX(24);
      ftDate, ftTime, ftDateTime, ftTimeStamp:
        Result := MmToPxX(22);
      ftBoolean:
        Result := MmToPxX(16);
    else
      Result := MmToPxX(26);
    end;
  end;

  function GetMaxColWidth(AField: TField): Integer;
  begin
    case AField.DataType of
      ftString, ftWideString, ftMemo, ftWideMemo:
        if ALandscape then
          Result := MmToPxX(55)
        else
          Result := MmToPxX(42);
      ftDate, ftTime, ftDateTime, ftTimeStamp:
        Result := MmToPxX(28);
      ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftSingle, ftExtended:
        Result := MmToPxX(30);
    else
      Result := MmToPxX(34);
    end;
  end;

  function CalcCellHeight(const S: string; W: Integer): Integer;
  var
    R: TRect;
    LineH: Integer;
  begin
    if W < 12 then
      W := 12;

    LineH := P.Canvas.TextHeight('Wg');

    R := Rect(0, 0, W - (CELL_PAD_X * 2), 0);
    DrawText(P.Canvas.Handle, PChar(S), Length(S), R,
      DT_CALCRECT or DT_WORDBREAK or DT_NOPREFIX or DT_EDITCONTROL);

    Result := (R.Bottom - R.Top) + (CELL_PAD_Y * 2);

    if Result < (LineH + (CELL_PAD_Y * 2)) then
      Result := LineH + (CELL_PAD_Y * 2);

    if Result > ((LineH * MAX_CELL_LINES) + (CELL_PAD_Y * 2)) then
      Result := (LineH * MAX_CELL_LINES) + (CELL_PAD_Y * 2);
  end;

  procedure DrawCell(const RCell: TRect; const S: string; const IsHeader: Boolean);
  var
    RText: TRect;
    Flags: Cardinal;
  begin
    P.Canvas.Brush.Style := bsSolid;
    if IsHeader then
      P.Canvas.Brush.Color := $00E7E7E7
    else
      P.Canvas.Brush.Color := clWhite;

    P.Canvas.Pen.Color := $00B5B5B5;
    P.Canvas.Rectangle(RCell);

    RText := Rect(
      RCell.Left + CELL_PAD_X,
      RCell.Top + CELL_PAD_Y,
      RCell.Right - CELL_PAD_X,
      RCell.Bottom - CELL_PAD_Y
    );

    P.Canvas.Brush.Style := bsClear;
    if IsHeader then
      P.Canvas.Font.Style := [fsBold]
    else
      P.Canvas.Font.Style := [];

    Flags := DT_WORDBREAK or DT_NOPREFIX or DT_EDITCONTROL;

    SaveDC(P.Canvas.Handle);
    try
      IntersectClipRect(P.Canvas.Handle, RCell.Left, RCell.Top, RCell.Right, RCell.Bottom);
      DrawText(P.Canvas.Handle, PChar(S), Length(S), RText, Flags);
    finally
      RestoreDC(P.Canvas.Handle, -1);
    end;
  end;

  procedure CalcRecordCount;
  begin
    if ADs.RecordCount >= 0 then
    begin
      RecordCount := ADs.RecordCount;
      Exit;
    end;

    RecordCount := 0;
    ADs.DisableControls;
    Bmk := ADs.GetBookmark;
    try
      ADs.First;
      while not ADs.Eof do
      begin
        Inc(RecordCount);
        ADs.Next;
      end;
    finally
      if ADs.BookmarkValid(Bmk) then
        ADs.GotoBookmark(Bmk);
      ADs.FreeBookmark(Bmk);
      ADs.EnableControls;
    end;
  end;

  procedure NormalizeColWidths;
  var
    AvailW, SumW, Excess, Shrinkable, DecW, ExtraW: Integer;
    K: Integer;
  begin
    AvailW := PageW - LM - RM;
    if AvailW < MmToPxX(100) then
      AvailW := MmToPxX(100);

    SumW := 0;
    for K := 0 to High(Fields) do
    begin
      NeedW[K] := EnsureRange(NeedW[K], MinW[K], GetMaxColWidth(Fields[K]));
      ColW[K] := NeedW[K];
      Inc(SumW, ColW[K]);
    end;

    while SumW > AvailW do
    begin
      Excess := SumW - AvailW;
      Shrinkable := 0;
      for K := 0 to High(ColW) do
        Inc(Shrinkable, Max(0, ColW[K] - MinW[K]));

      if Shrinkable <= 0 then Break;

      for K := 0 to High(ColW) do
      begin
        if ColW[K] > MinW[K] then
        begin
          DecW := MulDiv(Excess, ColW[K] - MinW[K], Shrinkable);
          ColW[K] := Max(MinW[K], ColW[K] - DecW);
        end;
      end;

      SumW := 0;
      for K := 0 to High(ColW) do
        Inc(SumW, ColW[K]);
    end;

    if SumW < AvailW then
    begin
      ExtraW := AvailW - SumW;
      if Length(ColW) > 0 then
        ColW[High(ColW)] := ColW[High(ColW)] + ExtraW;
    end;
  end;

  procedure PrintPageHeader;
  var
    SRight, SInfo: string;
    WRight: Integer;
  begin
    P.Canvas.Font.Name := 'Arial';
    P.Canvas.Font.Charset := RUSSIAN_CHARSET;
    P.Canvas.Font.Size := 11;
    P.Canvas.Font.Style := [fsBold];
    P.Canvas.TextOut(LM, Y, ATitle);

    P.Canvas.Font.Name := 'Arial';
    P.Canvas.Font.Charset := RUSSIAN_CHARSET;
    P.Canvas.Font.Size := 8;
    P.Canvas.Font.Style := [];
    SRight := FormatDateTime('dd.mm.yyyy hh:nn', Now);
    WRight := P.Canvas.TextWidth(SRight);
    P.Canvas.TextOut(PageW - RM - WRight, Y + 2, SRight);

    Inc(Y, P.Canvas.TextHeight('Wg') + MmToPxY(2));

    SInfo := #1047#1072#1087#1080#1089#1077#1081 + ': ' + IntToStr(RecordCount);
    P.Canvas.TextOut(LM, Y, SInfo);

    Inc(Y, P.Canvas.TextHeight('Wg') + MmToPxY(3));
    P.Canvas.Pen.Color := $00B5B5B5;
    P.Canvas.MoveTo(LM, Y);
    P.Canvas.LineTo(PageW - RM, Y);
    Inc(Y, MmToPxY(2));
  end;

  procedure PrintPageFooter;
  var
    SLeft, SRight: string;
    WRight, Yf: Integer;
  begin
    P.Canvas.Font.Name := 'Arial';
    P.Canvas.Font.Charset := RUSSIAN_CHARSET;
    P.Canvas.Font.Size := 8;
    P.Canvas.Font.Style := [];
    SLeft := #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1086' '#1080#1079' Kairos Home';
    SRight := #1057#1090#1088'. ' + IntToStr(PageNo);
    WRight := P.Canvas.TextWidth(SRight);
    Yf := PageH - BM + MmToPxY(3);
    P.Canvas.TextOut(LM, Yf, SLeft);
    P.Canvas.TextOut(PageW - RM - WRight, Yf, SRight);
  end;

  procedure PrintHeaderRow;
  var
    H: Integer;
    K: Integer;
    RCell: TRect;
    S: string;
  begin
    HeaderH := 0;
    for K := 0 to High(Fields) do
    begin
      S := Fields[K].DisplayLabel;
      H := CalcCellHeight(S, ColW[K]);
      if H > HeaderH then
        HeaderH := H;
    end;

    X := LM;
    for K := 0 to High(Fields) do
    begin
      RCell := Rect(X, Y, X + ColW[K], Y + HeaderH);
      DrawCell(RCell, Fields[K].DisplayLabel, True);
      Inc(X, ColW[K]);
    end;
    Inc(Y, HeaderH);
  end;

  procedure StartPage;
  begin
    if PageNo > 0 then
    begin
      PrintPageFooter;
      P.NewPage;
    end;

    Inc(PageNo);
    Y := TM;
    PrintPageHeader;
    PrintHeaderRow;
  end;

  procedure PrintEmptyDataMessage;
  begin
    P.Canvas.Font.Name := 'Arial';
    P.Canvas.Font.Charset := RUSSIAN_CHARSET;
    P.Canvas.Font.Size := 10;
    P.Canvas.Font.Style := [];
    P.Canvas.TextOut(LM, Y + MmToPxY(8), #1044#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080' '#1086#1090#1089#1091#1090#1089#1090#1074#1091#1102#1090'.');
  end;

var
  SampleRows, RowH, H, MaxColW: Integer;
  RCell: TRect;
  S: string;
begin
  if (ADs = nil) or (not ADs.Active) then Exit;

  Fields := BuildPrintFieldList(ADs, AFieldNames);
  if Length(Fields) = 0 then Exit;

  P := Printer;
  if ALandscape then
    P.Orientation := poLandscape
  else
    P.Orientation := poPortrait;
  P.Title := ATitle;
  P.BeginDoc;
  try
    PageW := P.PageWidth;
    PageH := P.PageHeight;

    DpiX := GetDeviceCaps(P.Canvas.Handle, LOGPIXELSX);
    DpiY := GetDeviceCaps(P.Canvas.Handle, LOGPIXELSY);
    if DpiX <= 0 then DpiX := 96;
    if DpiY <= 0 then DpiY := 96;

    LM := MmToPxX(MARGIN_L_MM);
    TM := MmToPxY(MARGIN_T_MM);
    RM := MmToPxX(MARGIN_R_MM);
    BM := MmToPxY(MARGIN_B_MM);

    P.Canvas.Font.Name := 'Arial';
    P.Canvas.Font.Charset := RUSSIAN_CHARSET;
    P.Canvas.Font.Size := 8;

    TitleH := P.Canvas.TextHeight('Wg') * 2 + MmToPxY(8);
    FooterH := P.Canvas.TextHeight('Wg') + MmToPxY(8);

    SetLength(ColW, Length(Fields));
    SetLength(MinW, Length(Fields));
    SetLength(NeedW, Length(Fields));

    for J := 0 to High(Fields) do
    begin
      MinW[J] := GetMinColWidth(Fields[J]);
      NeedW[J] := P.Canvas.TextWidth(Fields[J].DisplayLabel) + (CELL_PAD_X * 2) + MmToPxX(2);
      NeedW[J] := Max(NeedW[J], MinW[J]);
    end;

    ADs.DisableControls;
    Bmk := ADs.GetBookmark;
    try
      SampleRows := 0;
      ADs.First;
      while (not ADs.Eof) and (SampleRows < MAX_SCAN_ROWS) do
      begin
        for J := 0 to High(Fields) do
        begin
          S := FieldText(Fields[J]);
          H := P.Canvas.TextWidth(S) + (CELL_PAD_X * 2) + MmToPxX(2);
          MaxColW := GetMaxColWidth(Fields[J]);
          if H > MaxColW then
            H := MaxColW;
          if H > NeedW[J] then
            NeedW[J] := H;
        end;
        Inc(SampleRows);
        ADs.Next;
      end;
    finally
      if ADs.BookmarkValid(Bmk) then
        ADs.GotoBookmark(Bmk);
      ADs.FreeBookmark(Bmk);
      ADs.EnableControls;
    end;

    NormalizeColWidths;
    CalcRecordCount;

    PageNo := 0;
    HasDataRows := not ADs.IsEmpty;
    StartPage;

    if not HasDataRows then
    begin
      PrintEmptyDataMessage;
      PrintPageFooter;
      Exit;
    end;

    ADs.DisableControls;
    Bmk := ADs.GetBookmark;
    try
      ADs.First;
      while not ADs.Eof do
      begin
        RowH := 0;
        for J := 0 to High(Fields) do
        begin
          H := CalcCellHeight(FieldText(Fields[J]), ColW[J]);
          if H > RowH then
            RowH := H;
        end;

        if (Y + RowH + FooterH) > (PageH - BM) then
          StartPage;

        X := LM;
        for J := 0 to High(Fields) do
        begin
          RCell := Rect(X, Y, X + ColW[J], Y + RowH);
          DrawCell(RCell, FieldText(Fields[J]), False);
          Inc(X, ColW[J]);
        end;

        Inc(Y, RowH);
        ADs.Next;
      end;
    finally
      if ADs.BookmarkValid(Bmk) then
        ADs.GotoBookmark(Bmk);
      ADs.FreeBookmark(Bmk);
      ADs.EnableControls;
    end;

    PrintPageFooter;
  finally
    P.EndDoc;
  end;
end;

end.