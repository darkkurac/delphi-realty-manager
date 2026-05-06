unit frmRepContractListUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs,
  Vcl.Grids, Vcl.DBGrids, Data.DB,
  dmMainUnit, uReportUtilsUnit;

type
  TfrmRepContractList = class(TForm)
    pTop: TPanel;
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
  end;

var
  frmRepContractList: TfrmRepContractList;

implementation

{$R *.dfm}

procedure TfrmRepContractList.Bind;
begin
  grd.DataSource := dmMain.dsRepContractList;
end;

procedure TfrmRepContractList.ConfigureReportGrid;
begin
  if not dmMain.qRepContractList.Active then Exit;

  if dmMain.qRepContractList.FindField('IDcon') <> nil then
    dmMain.qRepContractList.FieldByName('IDcon').Visible := False;
  if dmMain.qRepContractList.FindField('IDcl') <> nil then
    dmMain.qRepContractList.FieldByName('IDcl').Visible := False;
  if dmMain.qRepContractList.FindField('IDemp') <> nil then
    dmMain.qRepContractList.FieldByName('IDemp').Visible := False;
  if dmMain.qRepContractList.FindField('IDob') <> nil then
    dmMain.qRepContractList.FieldByName('IDob').Visible := False;
  if dmMain.qRepContractList.FindField('clPhone') <> nil then
    dmMain.qRepContractList.FieldByName('clPhone').Visible := False;
  if dmMain.qRepContractList.FindField('clEmail') <> nil then
    dmMain.qRepContractList.FieldByName('clEmail').Visible := False;
  if dmMain.qRepContractList.FindField('empPhone') <> nil then
    dmMain.qRepContractList.FieldByName('empPhone').Visible := False;
  if dmMain.qRepContractList.FindField('empEmail') <> nil then
    dmMain.qRepContractList.FieldByName('empEmail').Visible := False;
  if dmMain.qRepContractList.FindField('conStatusCode') <> nil then
    dmMain.qRepContractList.FieldByName('conStatusCode').Visible := False;

  if dmMain.qRepContractList.FindField('conNumber') <> nil then
    dmMain.qRepContractList.FieldByName('conNumber').DisplayLabel := 'Номер договора';
  if dmMain.qRepContractList.FindField('conDate') <> nil then
    dmMain.qRepContractList.FieldByName('conDate').DisplayLabel := 'Дата';
  if dmMain.qRepContractList.FindField('conStatus') <> nil then
    dmMain.qRepContractList.FieldByName('conStatus').DisplayLabel := 'Статус';
  if dmMain.qRepContractList.FindField('conSum') <> nil then
    dmMain.qRepContractList.FieldByName('conSum').DisplayLabel := 'Сумма';
  if dmMain.qRepContractList.FindField('conPrepay') <> nil then
    dmMain.qRepContractList.FieldByName('conPrepay').DisplayLabel := 'Предоплата';
  if dmMain.qRepContractList.FindField('conDebt') <> nil then
    dmMain.qRepContractList.FieldByName('conDebt').DisplayLabel := 'Долг';
  if dmMain.qRepContractList.FindField('conComment') <> nil then
    dmMain.qRepContractList.FieldByName('conComment').DisplayLabel := 'Комментарий';
  if dmMain.qRepContractList.FindField('clFIO') <> nil then
    dmMain.qRepContractList.FieldByName('clFIO').DisplayLabel := 'Клиент';
  if dmMain.qRepContractList.FindField('empFIO') <> nil then
    dmMain.qRepContractList.FieldByName('empFIO').DisplayLabel := 'Сотрудник';
  if dmMain.qRepContractList.FindField('obCode') <> nil then
    dmMain.qRepContractList.FieldByName('obCode').DisplayLabel := 'Код объекта';
  if dmMain.qRepContractList.FindField('obName') <> nil then
    dmMain.qRepContractList.FieldByName('obName').DisplayLabel := 'Объект';
  if dmMain.qRepContractList.FindField('osName') <> nil then
    dmMain.qRepContractList.FieldByName('osName').DisplayLabel := 'Статус объекта';
  if dmMain.qRepContractList.FindField('snsName') <> nil then
    dmMain.qRepContractList.FieldByName('snsName').DisplayLabel := 'СНТ';
  if dmMain.qRepContractList.FindField('spStreet') <> nil then
    dmMain.qRepContractList.FieldByName('spStreet').DisplayLabel := 'Улица';
  if dmMain.qRepContractList.FindField('spPlotNo') <> nil then
    dmMain.qRepContractList.FieldByName('spPlotNo').DisplayLabel := 'Участок';
end;

procedure TfrmRepContractList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmRepContractList := nil;
end;

procedure TfrmRepContractList.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  Caption := 'Отчёт: список договоров';
  Bind;
  dmMain.OpenRepContractList;
  ConfigureReportGrid;
end;

procedure TfrmRepContractList.btnRefreshClick(Sender: TObject);
begin
  dmMain.RefreshRepContractList;
  ConfigureReportGrid;
end;

procedure TfrmRepContractList.btnExportClick(Sender: TObject);
begin
  sd.Filter := 'CSV (*.csv)|*.csv';
  sd.DefaultExt := 'csv';
  sd.FileName := 'rep_contract_list.csv';
  if sd.Execute then
    ExportDataSetToCSV(dmMain.qRepContractList, sd.FileName, ';');
end;

procedure TfrmRepContractList.btnPrintClick(Sender: TObject);
begin
  PrintDataSetTable(
    dmMain.qRepContractList,
    'Список договоров',
    True,
    ['conNumber', 'conDate', 'conStatus', 'conSum', 'clFIO', 'empFIO', 'obCode', 'obName']
  );
end;

procedure TfrmRepContractList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.

