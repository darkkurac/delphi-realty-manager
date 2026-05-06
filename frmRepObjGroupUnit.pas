unit frmRepObjGroupUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Variants,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, Data.DB,
  dmMainUnit, uReportUtilsUnit;

type
  TfrmRepObjGroup = class(TForm)
    pTop: TPanel;
    btnRefresh: TButton;
    btnExport: TButton;
    btnPrint: TButton;
    btnClose: TButton;
    grd: TDBGrid;
    sd: TSaveDialog;
    lblSnt: TLabel;
    lblStatus: TLabel;
    lcbSnt: TDBLookupComboBox;
    lcbStatus: TDBLookupComboBox;
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
  frmRepObjGroup: TfrmRepObjGroup;

implementation

{$R *.dfm}

procedure TfrmRepObjGroup.Bind;
begin
  grd.DataSource := dmMain.dsRepObjGroup;

  lcbSnt.ListSource := dmMain.dsSettlement;
  lcbSnt.ListField  := 'snsName';
  lcbSnt.KeyField   := 'snsName';

  lcbStatus.ListSource := dmMain.dsStatus;
  lcbStatus.ListField  := 'osName';
  lcbStatus.KeyField   := 'osName';
end;

procedure TfrmRepObjGroup.ConfigureReportGrid;
begin
  if not dmMain.qRepObjGroup.Active then Exit;

  if dmMain.qRepObjGroup.FindField('snt_name') <> nil then
    dmMain.qRepObjGroup.FieldByName('snt_name').DisplayLabel := 'СНТ';
  if dmMain.qRepObjGroup.FindField('status_name') <> nil then
    dmMain.qRepObjGroup.FieldByName('status_name').DisplayLabel := 'Статус';
  if dmMain.qRepObjGroup.FindField('cnt_objects') <> nil then
    dmMain.qRepObjGroup.FieldByName('cnt_objects').DisplayLabel := 'Количество объектов';
  if dmMain.qRepObjGroup.FindField('price_min') <> nil then
    dmMain.qRepObjGroup.FieldByName('price_min').DisplayLabel := 'Мин. цена';
  if dmMain.qRepObjGroup.FindField('price_max') <> nil then
    dmMain.qRepObjGroup.FieldByName('price_max').DisplayLabel := 'Макс. цена';
  if dmMain.qRepObjGroup.FindField('price_avg') <> nil then
    dmMain.qRepObjGroup.FieldByName('price_avg').DisplayLabel := 'Средняя цена';
end;

procedure TfrmRepObjGroup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmRepObjGroup := nil;
end;

procedure TfrmRepObjGroup.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  Caption := 'Отчёт: группировка объектов (СНТ/статус)';
  dmMain.OpenLookups;
  Bind;
  dmMain.OpenRepObjGroupSntStatus;
  ConfigureReportGrid;
end;

procedure TfrmRepObjGroup.btnRefreshClick(Sender: TObject);
begin
  dmMain.ApplyRepObjGroupSntStatusFilter(lcbSnt.KeyValue, lcbStatus.KeyValue);
  ConfigureReportGrid;
end;

procedure TfrmRepObjGroup.btnExportClick(Sender: TObject);
begin
  sd.Filter := 'CSV (*.csv)|*.csv';
  sd.DefaultExt := 'csv';
  sd.FileName := 'rep_obj_group_snt_status.csv';
  if sd.Execute then
    ExportDataSetToCSV(dmMain.qRepObjGroup, sd.FileName, ';');
end;
procedure TfrmRepObjGroup.btnPrintClick(Sender: TObject);
begin
  PrintDataSetTable(
    dmMain.qRepObjGroup,
    'Группировка объектов: СНТ / Статус',
    False,
    ['snt_name', 'status_name', 'cnt_objects', 'price_min', 'price_max', 'price_avg']
  );
end;

procedure TfrmRepObjGroup.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.

