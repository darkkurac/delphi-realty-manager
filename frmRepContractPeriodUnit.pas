unit frmRepContractPeriodUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Variants,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Data.DB,
  dmMainUnit, uReportUtilsUnit;

type
  TfrmRepContractPeriod = class(TForm)
    pTop: TPanel;
    lblFrom: TLabel;
    lblTo: TLabel;
    dtFrom: TDateTimePicker;
    dtTo: TDateTimePicker;
    chkNoDates: TCheckBox;
    btnRefresh: TButton;
    btnExport: TButton;
    btnPrint: TButton;
    btnClose: TButton;
    grd: TDBGrid;
    sd: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure Bind;
    procedure ConfigureReportGrid;
    function VDate(const D: TDateTime; const Use: Boolean): Variant;
    procedure ContractStatusGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

var
  frmRepContractPeriod: TfrmRepContractPeriod;

implementation

{$R *.dfm}

procedure TfrmRepContractPeriod.Bind;
begin
  grd.DataSource := dmMain.dsRepContractPeriod;
end;

procedure TfrmRepContractPeriod.ConfigureReportGrid;
begin
  if not dmMain.qRepContractPeriod.Active then Exit;

  if dmMain.qRepContractPeriod.FindField('y') <> nil then
    dmMain.qRepContractPeriod.FieldByName('y').DisplayLabel := 'Год';
  if dmMain.qRepContractPeriod.FindField('m') <> nil then
    dmMain.qRepContractPeriod.FieldByName('m').DisplayLabel := 'Месяц';
  if dmMain.qRepContractPeriod.FindField('conStatus') <> nil then
    dmMain.qRepContractPeriod.FieldByName('conStatus').DisplayLabel := 'Статус договора';
  if dmMain.qRepContractPeriod.FindField('cnt_contracts') <> nil then
    dmMain.qRepContractPeriod.FieldByName('cnt_contracts').DisplayLabel := 'Количество договоров';
  if dmMain.qRepContractPeriod.FindField('sum_contracts') <> nil then
    dmMain.qRepContractPeriod.FieldByName('sum_contracts').DisplayLabel := 'Сумма договоров';
  if dmMain.qRepContractPeriod.FindField('conStatusCode') <> nil then
    dmMain.qRepContractPeriod.FieldByName('conStatusCode').Visible := False;
  if dmMain.qRepContractPeriod.FindField('conStatus') <> nil then
  begin
    dmMain.qRepContractPeriod.FieldByName('conStatus').DisplayLabel := 'Статус договора';
    dmMain.qRepContractPeriod.FieldByName('conStatus').OnGetText := ContractStatusGetText;
  end;
end;

function TfrmRepContractPeriod.VDate(const D: TDateTime; const Use: Boolean): Variant;
begin
  if Use then Result := D else Result := Null;
end;

procedure TfrmRepContractPeriod.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmRepContractPeriod := nil;
end;

procedure TfrmRepContractPeriod.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  Caption := 'Отчёт: договоры по периоду';
  Bind;
  dtFrom.Date := Date;
  dtTo.Date := Date;
  chkNoDates.Checked := True;
  dmMain.OpenRepContractGroupPeriod;
  ConfigureReportGrid;
end;

procedure TfrmRepContractPeriod.btnRefreshClick(Sender: TObject);
var
  AFrom, ATo: Variant;
begin
  AFrom := VDate(dtFrom.Date, not chkNoDates.Checked);
  ATo   := VDate(dtTo.Date,   not chkNoDates.Checked);
  dmMain.ApplyRepContractGroupPeriodFilter(AFrom, ATo);
  ConfigureReportGrid;
end;

procedure TfrmRepContractPeriod.btnExportClick(Sender: TObject);
begin
  sd.Filter := 'CSV (*.csv)|*.csv';
  sd.DefaultExt := 'csv';
  sd.FileName := 'rep_contracts_period.csv';
  if sd.Execute then
  ExportDataSetToCSV(dmMain.qRepContractPeriod, sd.FileName, ';');
end;

procedure TfrmRepContractPeriod.btnPrintClick(Sender: TObject);
begin
  PrintDataSetTable(
    dmMain.qRepContractPeriod,
    'Договоры по периоду',
    False,
    ['y', 'm', 'conStatus', 'cnt_contracts', 'sum_contracts']
  );
end;

procedure TfrmRepContractPeriod.btnCloseClick(Sender: TObject);
begin
  Close;
end;

function ContractStatusDbToRu(const AValue: string): string;
begin
  if SameText(AValue, 'Active') then
    Result := 'Активен'
  else if SameText(AValue, 'Closed') then
    Result := 'Закрыт'
  else if SameText(AValue, 'Canceled') then
    Result := 'Отменен'
  else
    Result := AValue;
end;

procedure TfrmRepContractPeriod.ContractStatusGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := ContractStatusDbToRu(Sender.AsString);
end;

end.

