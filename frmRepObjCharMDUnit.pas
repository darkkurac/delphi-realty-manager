unit frmRepObjCharMDUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Variants,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, Data.DB,
  dmMainUnit, uReportUtilsUnit;

type
  TfrmRepObjCharMD = class(TForm)
    pTop: TPanel;
    lblSnt: TLabel;
    lblStatus: TLabel;
    lblMin: TLabel;
    lblMax: TLabel;
    lcbSnt: TDBLookupComboBox;
    lcbStatus: TDBLookupComboBox;
    edMin: TEdit;
    edMax: TEdit;
    chkOnlyFree: TCheckBox;
    btnApply: TButton;
    btnExportMaster: TButton;
    btnPrintMaster: TButton;
    btnClose: TButton;
    spl: TSplitter;
    grdMaster: TDBGrid;
    grdDetail: TDBGrid;
    sd: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnExportMasterClick(Sender: TObject);
    procedure btnPrintMasterClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure Bind;
    procedure ConfigureMasterGrid;
    procedure ConfigureDetailGrid;
    function VNum(const S: string): Variant;
  end;

var
  frmRepObjCharMD: TfrmRepObjCharMD;

implementation

{$R *.dfm}

procedure TfrmRepObjCharMD.Bind;
begin
  grdMaster.DataSource := dmMain.dsRepObjMaster;
  grdDetail.DataSource := dmMain.dsRepObjCharDetail;

  lcbSnt.ListSource := dmMain.dsSettlement;
  lcbSnt.ListField  := 'snsName';
  lcbSnt.KeyField   := 'snsName';

  lcbStatus.ListSource := dmMain.dsStatus;
  lcbStatus.ListField  := 'osName';
  lcbStatus.KeyField   := 'osName';
end;

procedure TfrmRepObjCharMD.ConfigureMasterGrid;
begin
  if not dmMain.qRepObjMaster.Active then Exit;

  if dmMain.qRepObjMaster.FindField('IDob') <> nil then
    dmMain.qRepObjMaster.FieldByName('IDob').Visible := False;

  if dmMain.qRepObjMaster.FindField('obCode') <> nil then
    dmMain.qRepObjMaster.FieldByName('obCode').DisplayLabel := 'Код объекта';
  if dmMain.qRepObjMaster.FindField('obName') <> nil then
    dmMain.qRepObjMaster.FieldByName('obName').DisplayLabel := 'Наименование';
  if dmMain.qRepObjMaster.FindField('obPrice') <> nil then
    dmMain.qRepObjMaster.FieldByName('obPrice').DisplayLabel := 'Цена';
  if dmMain.qRepObjMaster.FindField('obStatus') <> nil then
    dmMain.qRepObjMaster.FieldByName('obStatus').DisplayLabel := 'Статус';
  if dmMain.qRepObjMaster.FindField('osName') <> nil then
    dmMain.qRepObjMaster.FieldByName('osName').DisplayLabel := 'Статус';
  if dmMain.qRepObjMaster.FindField('sntName') <> nil then
    dmMain.qRepObjMaster.FieldByName('sntName').DisplayLabel := 'СНТ';
  if dmMain.qRepObjMaster.FindField('snsName') <> nil then
    dmMain.qRepObjMaster.FieldByName('snsName').DisplayLabel := 'СНТ';
  if dmMain.qRepObjMaster.FindField('obTotalArea') <> nil then
    dmMain.qRepObjMaster.FieldByName('obTotalArea').DisplayLabel := 'Площадь';
  if dmMain.qRepObjMaster.FindField('obRooms') <> nil then
    dmMain.qRepObjMaster.FieldByName('obRooms').DisplayLabel := 'Комнаты';
  if dmMain.qRepObjMaster.FindField('obFloors') <> nil then
    dmMain.qRepObjMaster.FieldByName('obFloors').DisplayLabel := 'Этажей';
  if dmMain.qRepObjMaster.FindField('snsRegion') <> nil then
    dmMain.qRepObjMaster.FieldByName('snsRegion').DisplayLabel := 'Регион';
  if dmMain.qRepObjMaster.FindField('snsDistrict') <> nil then
    dmMain.qRepObjMaster.FieldByName('snsDistrict').DisplayLabel := 'Район';
  if dmMain.qRepObjMaster.FindField('spStreet') <> nil then
    dmMain.qRepObjMaster.FieldByName('spStreet').DisplayLabel := 'Улица';
  if dmMain.qRepObjMaster.FindField('spPlotNo') <> nil then
    dmMain.qRepObjMaster.FieldByName('spPlotNo').DisplayLabel := 'Участок';
  if dmMain.qRepObjMaster.FindField('obShortAddress') <> nil then
    dmMain.qRepObjMaster.FieldByName('obShortAddress').DisplayLabel := 'Краткий адрес';
end;

procedure TfrmRepObjCharMD.ConfigureDetailGrid;
begin
  if not dmMain.qRepObjCharDetail.Active then Exit;

  if dmMain.qRepObjCharDetail.FindField('IDoc') <> nil then
    dmMain.qRepObjCharDetail.FieldByName('IDoc').Visible := False;
  if dmMain.qRepObjCharDetail.FindField('IDob') <> nil then
    dmMain.qRepObjCharDetail.FieldByName('IDob').Visible := False;
  if dmMain.qRepObjCharDetail.FindField('IDct') <> nil then
    dmMain.qRepObjCharDetail.FieldByName('IDct').Visible := False;
  if dmMain.qRepObjCharDetail.FindField('ctValueType') <> nil then
    dmMain.qRepObjCharDetail.FieldByName('ctValueType').Visible := False;

  if dmMain.qRepObjCharDetail.FindField('ctName') <> nil then
    dmMain.qRepObjCharDetail.FieldByName('ctName').DisplayLabel := 'Характеристика';
  if dmMain.qRepObjCharDetail.FindField('ctUnit') <> nil then
    dmMain.qRepObjCharDetail.FieldByName('ctUnit').DisplayLabel := 'Ед. изм.';
  if dmMain.qRepObjCharDetail.FindField('ocValueNum') <> nil then
    dmMain.qRepObjCharDetail.FieldByName('ocValueNum').DisplayLabel := 'Числовое значение';
  if dmMain.qRepObjCharDetail.FindField('ocValueText') <> nil then
    dmMain.qRepObjCharDetail.FieldByName('ocValueText').DisplayLabel := 'Текстовое значение';
  if dmMain.qRepObjCharDetail.FindField('ocValueBool') <> nil then
    dmMain.qRepObjCharDetail.FieldByName('ocValueBool').DisplayLabel := 'Логическое значение';
end;

function TfrmRepObjCharMD.VNum(const S: string): Variant;
var T: string;
begin
  T := Trim(S);
  if T = '' then Exit(Null);
  Result := StrToFloat(StringReplace(T, ',', '.', [rfReplaceAll]));
end;

procedure TfrmRepObjCharMD.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmRepObjCharMD := nil;
end;

procedure TfrmRepObjCharMD.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  Caption := 'Отчёт: характеристики объекта (главное-подчиненное)';

  dmMain.OpenLookups;
  Bind;
  dmMain.OpenRepObjCharMD;
  ConfigureMasterGrid;
  ConfigureDetailGrid;
end;

procedure TfrmRepObjCharMD.btnApplyClick(Sender: TObject);
begin
  dmMain.ApplyRepObjMasterFilter(
    lcbSnt.KeyValue,
    lcbStatus.KeyValue,
    VNum(edMin.Text),
    VNum(edMax.Text),
    chkOnlyFree.Checked
  );
  ConfigureMasterGrid;
  ConfigureDetailGrid;
end;

procedure TfrmRepObjCharMD.btnExportMasterClick(Sender: TObject);
begin
  sd.Filter := 'CSV (*.csv)|*.csv';
  sd.DefaultExt := 'csv';
  sd.FileName := 'rep_objects_master.csv';
  if sd.Execute then
    ExportDataSetToCSV(dmMain.qRepObjMaster, sd.FileName, ';');
end;

procedure TfrmRepObjCharMD.btnPrintMasterClick(Sender: TObject);
begin
  PrintDataSetTable(
    dmMain.qRepObjMaster,
    'Список объектов по фильтру',
    True,
    ['obCode', 'obName', 'obStatus', 'sntName', 'obPrice', 'obTotalArea', 'obRooms', 'obFloors']
  );
end;

procedure TfrmRepObjCharMD.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.