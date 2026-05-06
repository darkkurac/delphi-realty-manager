unit frmChartSalesDynUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Variants,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.ComCtrls,
  dmMainUnit, uChartUtilsUnit;

type
  TfrmChartSalesDyn = class(TForm)
    pTop: TPanel;
    lblFrom: TLabel;
    lblTo: TLabel;
    lblSnt: TLabel;
    lblStatus: TLabel;
    dtFrom: TDateTimePicker;
    dtTo: TDateTimePicker;
    chkNoDates: TCheckBox;
    lcbSnt: TDBLookupComboBox;
    lcbStatus: TDBLookupComboBox;
    btnApply: TButton;
    btnClose: TButton;
    pbChart: TPaintBox;
    procedure FormShow(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkNoDatesClick(Sender: TObject);
    procedure pbChartPaint(Sender: TObject);
  private
    FPts: TChartPoints;
    FOptions: TChartRenderOptions;
    procedure Bind;
    function VDate(const D: TDateTime; const Use: Boolean): Variant;
    function VStatus: Variant;
    function BuildSubtitle: string;
    procedure Build;
  end;

var
  frmChartSalesDyn: TfrmChartSalesDyn;

implementation

{$R *.dfm}

procedure TfrmChartSalesDyn.Bind;
begin
  lcbSnt.ListSource := dmMain.dsSettlement;
  lcbSnt.ListField  := 'snsName';
  lcbSnt.KeyField   := 'snsName';

  lcbStatus.ListSource := dmMain.dsStatus;
  lcbStatus.ListField  := 'osName';
  lcbStatus.KeyField   := 'osName';
end;

function TfrmChartSalesDyn.VDate(const D: TDateTime; const Use: Boolean): Variant;
begin
  if Use then
    Result := D
  else
    Result := Null;
end;

function TfrmChartSalesDyn.VStatus: Variant;
var
  S: string;
begin
  S := Trim(lcbStatus.Text);
  if S = '' then
    Result := Null
  else
    Result := S;
end;

function TfrmChartSalesDyn.BuildSubtitle: string;
var
  SDate, SSnt, SStatus: string;
begin
  if chkNoDates.Checked then
    SDate := 'Период: весь'
  else
    SDate := 'Период: ' + FormatDateTime('dd.mm.yyyy', dtFrom.Date) + ' — ' +
      FormatDateTime('dd.mm.yyyy', dtTo.Date);

  if Trim(lcbSnt.Text) = '' then
    SSnt := 'СНТ: все'
  else
    SSnt := 'СНТ: ' + Trim(lcbSnt.Text);

  if Trim(lcbStatus.Text) = '' then
    SStatus := 'Статус: все'
  else
    SStatus := 'Статус: ' + Trim(lcbStatus.Text);

  Result := SDate + '; ' + SSnt + '; ' + SStatus;
end;

procedure TfrmChartSalesDyn.Build;
begin
  CollectChartPointsFromDS(dmMain.qChartSalesDyn, 'ym', 'sum_sales', FPts);

  FOptions := NewChartOptions(
    'Динамика продаж',
    'Сумма продаж',
    BuildSubtitle,
    'Сумма, руб.',
    '#,##0',
    True
  );

  pbChart.Invalidate;
end;

procedure TfrmChartSalesDyn.pbChartPaint(Sender: TObject);
begin
  DrawLineChart(pbChart, FPts, FOptions);
end;

procedure TfrmChartSalesDyn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmChartSalesDyn := nil;
end;

procedure TfrmChartSalesDyn.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  Caption := 'График: продажи (динамика, фильтры)';

  dmMain.OpenLookups;
  Bind;

  dtFrom.Date := Date;
  dtTo.Date := Date;
  chkNoDates.Checked := True;
  dtFrom.Enabled := False;
  dtTo.Enabled := False;

  dmMain.PrepareChartSalesDynParams;
  dmMain.ApplyChartSalesDynFilter(Null, Null, Null, Null);

  Build;
end;

procedure TfrmChartSalesDyn.chkNoDatesClick(Sender: TObject);
begin
  dtFrom.Enabled := not chkNoDates.Checked;
  dtTo.Enabled := not chkNoDates.Checked;
end;

procedure TfrmChartSalesDyn.btnApplyClick(Sender: TObject);
var
  AFrom, ATo: Variant;
begin
  AFrom := VDate(dtFrom.Date, not chkNoDates.Checked);
  ATo := VDate(dtTo.Date, not chkNoDates.Checked);

  dmMain.ApplyChartSalesDynFilter(lcbSnt.KeyValue, VStatus, AFrom, ATo);
  Build;
end;

procedure TfrmChartSalesDyn.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.