unit frmRepObjectListUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs,
  Vcl.Grids, Vcl.DBGrids, Data.DB,
  dmMainUnit, uReportUtilsUnit;

type
  TfrmRepObjectList = class(TForm)
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
  frmRepObjectList: TfrmRepObjectList;

implementation

{$R *.dfm}

procedure TfrmRepObjectList.Bind;
begin
  grd.DataSource := dmMain.dsRepObjectList;
end;

procedure TfrmRepObjectList.ConfigureReportGrid;
begin
  if not dmMain.qRepObjectList.Active then Exit;

  if dmMain.qRepObjectList.FindField('IDob') <> nil then
    dmMain.qRepObjectList.FieldByName('IDob').Visible := False;

  if dmMain.qRepObjectList.FindField('obCode') <> nil then
    dmMain.qRepObjectList.FieldByName('obCode').DisplayLabel := 'Код объекта';
  if dmMain.qRepObjectList.FindField('obName') <> nil then
    dmMain.qRepObjectList.FieldByName('obName').DisplayLabel := 'Наименование';
  if dmMain.qRepObjectList.FindField('osName') <> nil then
    dmMain.qRepObjectList.FieldByName('osName').DisplayLabel := 'Статус';
  if dmMain.qRepObjectList.FindField('obPrice') <> nil then
    dmMain.qRepObjectList.FieldByName('obPrice').DisplayLabel := 'Цена';
  if dmMain.qRepObjectList.FindField('snsRegion') <> nil then
    dmMain.qRepObjectList.FieldByName('snsRegion').DisplayLabel := 'Регион';
  if dmMain.qRepObjectList.FindField('snsDistrict') <> nil then
    dmMain.qRepObjectList.FieldByName('snsDistrict').DisplayLabel := 'Район';
  if dmMain.qRepObjectList.FindField('snsName') <> nil then
    dmMain.qRepObjectList.FieldByName('snsName').DisplayLabel := 'СНТ';
  if dmMain.qRepObjectList.FindField('spStreet') <> nil then
    dmMain.qRepObjectList.FieldByName('spStreet').DisplayLabel := 'Улица';
  if dmMain.qRepObjectList.FindField('spPlotNo') <> nil then
    dmMain.qRepObjectList.FieldByName('spPlotNo').DisplayLabel := 'Участок';
  if dmMain.qRepObjectList.FindField('obShortAddress') <> nil then
    dmMain.qRepObjectList.FieldByName('obShortAddress').DisplayLabel := 'Краткий адрес';
end;

procedure TfrmRepObjectList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmRepObjectList := nil;
end;

procedure TfrmRepObjectList.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  Caption := 'Отчёт: список объектов';
  Bind;
  dmMain.OpenRepObjectList;
  ConfigureReportGrid;
end;

procedure TfrmRepObjectList.btnRefreshClick(Sender: TObject);
begin
  dmMain.RefreshRepObjectList;
  ConfigureReportGrid;
end;

procedure TfrmRepObjectList.btnExportClick(Sender: TObject);
begin
  sd.Filter := 'CSV (*.csv)|*.csv';
  sd.DefaultExt := 'csv';
  sd.FileName := 'rep_object_list.csv';
  if sd.Execute then
    ExportDataSetToCSV(dmMain.qRepObjectList, sd.FileName, ';');
end;

procedure TfrmRepObjectList.btnPrintClick(Sender: TObject);
begin
  PrintDataSetTable(
    dmMain.qRepObjectList,
    'Список объектов недвижимости',
    True,
    ['obCode', 'obName', 'osName', 'obPrice', 'snsName', 'spStreet', 'spPlotNo']
  );
end;

procedure TfrmRepObjectList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.

