unit frmObjectsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls,
  Data.DB, Data.Win.ADODB,
  dmMainUnit;

type
  TfrmObjects = class(TForm)
    pFilter: TPanel;
    lblFStatus: TLabel;
    lblFSnt: TLabel;
    lblPriceMin: TLabel;
    lblPriceMax: TLabel;
    cbFStatus: TDBLookupComboBox;
    cbFSnt: TDBLookupComboBox;
    edPriceMin: TEdit;
    edPriceMax: TEdit;
    chkOnlyFree: TCheckBox;
    btnApplyFilter: TButton;
    btnClearFilter: TButton;
    pTop: TPanel;
    btnInsert: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    btnCard: TButton;
    grdObjects: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCardClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure grdObjectsDblClick(Sender: TObject);
    procedure btnApplyFilterClick(Sender: TObject);
    procedure btnClearFilterClick(Sender: TObject);
    procedure grdObjectsTitleClick(Column: TColumn);
  private
    procedure BindFilterLookups;
    procedure ApplyGridCaptions;
    procedure OpenCard(const AMode: string); // 'INS' | 'EDIT'
    function CurrentObjectId: Integer;
    function VNum(const S: string): Variant;
  end;

var
  frmObjects: TfrmObjects;

implementation

{$R *.dfm}

uses
  frmObjectCardUnit, uDBGridSortUnit;

function TfrmObjects.VNum(const S: string): Variant;
var
  T: string;
  D: Double;
begin
  T := Trim(S);
  if T = '' then Exit(Null);

  T := StringReplace(T, ',', '.', [rfReplaceAll]);
  D := StrToFloatDef(T, 0);
  if D = 0 then
    Result := Null
  else
    Result := D;
end;

procedure TfrmObjects.BindFilterLookups;
begin
  cbFStatus.ListSource := dmMain.dsStatus;
  cbFStatus.ListField := 'osName';
  cbFStatus.KeyField := 'osName';

  cbFSnt.ListSource := dmMain.dsSettlement;
  cbFSnt.ListField := 'snsName';
  cbFSnt.KeyField := 'snsName';
end;

procedure TfrmObjects.ApplyGridCaptions;
var
  I: Integer;
  C: TColumn;
  FN: string;
begin
  if dmMain.qObjectList.FindField('IDob') <> nil then
    dmMain.qObjectList.FieldByName('IDob').DisplayLabel := 'ID';

  if dmMain.qObjectList.FindField('obCode') <> nil then
    dmMain.qObjectList.FieldByName('obCode').DisplayLabel := #1050#1086#1076;

  if dmMain.qObjectList.FindField('obName') <> nil then
    dmMain.qObjectList.FieldByName('obName').DisplayLabel := #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077;

  if dmMain.qObjectList.FindField('obPrice') <> nil then
    dmMain.qObjectList.FieldByName('obPrice').DisplayLabel := #1062#1077#1085#1072;

  if dmMain.qObjectList.FindField('obStatus') <> nil then
    dmMain.qObjectList.FieldByName('obStatus').DisplayLabel := #1057#1090#1072#1090#1091#1089;

  if dmMain.qObjectList.FindField('sntName') <> nil then
    dmMain.qObjectList.FieldByName('sntName').DisplayLabel := #1057#1053#1058;

  for I := 0 to grdObjects.Columns.Count - 1 do
  begin
    C := grdObjects.Columns[I];
    if C.Field = nil then Continue;

    FN := C.Field.FieldName;
    C.Title.Caption := C.Field.DisplayLabel;

    if SameText(FN, 'IDob') then
    begin
      C.Width := 55;
      C.Visible := True;
    end
    else if SameText(FN, 'obCode') then
    begin
      C.Width := 90;
      C.Visible := True;
    end
    else if SameText(FN, 'obName') then
    begin
      C.Width := 250;
      C.Visible := True;
    end
    else if SameText(FN, 'obPrice') then
    begin
      C.Width := 90;
      C.Visible := True;
    end
    else if SameText(FN, 'obStatus') then
    begin
      C.Width := 130;
      C.Visible := True;
    end
    else if SameText(FN, 'sntName') then
    begin
      C.Width := 160;
      C.Visible := True;
    end
    else
    begin
      C.Visible := False;
    end;
  end;
end;

procedure TfrmObjects.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  grdObjects.DataSource := dmMain.dsObjectList;

  dmMain.OpenLookups;
  BindFilterLookups;

  btnInsert.Enabled := (dmMain.Role = urObjectAdmin);
  btnEdit.Enabled := (dmMain.Role = urObjectAdmin);
  btnDelete.Enabled := (dmMain.Role = urObjectAdmin);

  if not dmMain.qObjectList.Active then
    dmMain.OpenMainData
  else if dmMain.qObjectList.IsEmpty then
    dmMain.ResetObjectListFilter;

  ApplyGridCaptions;
end;

procedure TfrmObjects.btnRefreshClick(Sender: TObject);
begin
  if dmMain.qObjectList.State in [dsEdit, dsInsert] then
    dmMain.qObjectList.Cancel;

  dmMain.qObjectList.DisableControls;
  try
    dmMain.ResetObjectListFilter;
  finally
    dmMain.qObjectList.EnableControls;
  end;

  ApplyGridCaptions;
end;

procedure TfrmObjects.OpenCard(const AMode: string);
var
  F: TfrmObjectCard;
begin
  F := TfrmObjectCard.Create(nil);
  try
    if SameText(AMode, 'INS') then
      F.OpenForMode('INS', 0)
    else
      F.OpenForMode('EDIT', CurrentObjectId);

    F.ShowModal;
  finally
    F.Free;
  end;
end;

function TfrmObjects.CurrentObjectId: Integer;
begin
  Result := 0;
  if (dmMain.qObjectList.Active) and (not dmMain.qObjectList.IsEmpty) then
    Result := dmMain.qObjectList.FieldByName('IDob').AsInteger;
end;

procedure TfrmObjects.btnInsertClick(Sender: TObject);
begin
  if dmMain.Role <> urObjectAdmin then Exit;
  OpenCard('INS');
end;

procedure TfrmObjects.btnEditClick(Sender: TObject);
begin
  if dmMain.Role <> urObjectAdmin then Exit;
  if CurrentObjectId = 0 then Exit;
  OpenCard('EDIT');
end;

procedure TfrmObjects.btnCardClick(Sender: TObject);
begin
  if CurrentObjectId = 0 then Exit;
  OpenCard('EDIT');
end;

procedure TfrmObjects.grdObjectsDblClick(Sender: TObject);
begin
  btnCardClick(nil);
end;

procedure TfrmObjects.btnDeleteClick(Sender: TObject);
var
  ID: Integer;
begin
  if dmMain.Role <> urObjectAdmin then Exit;

  if CurrentObjectId = 0 then Exit;
  ID := CurrentObjectId;

  if MessageDlg(#1059#1076#1072#1083#1080#1090#1100' '#1086#1073#1098#1077#1082#1090' (ID=' + IntToStr(ID) + ')?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  dmMain.qExec.SQL.Text := 'DELETE FROM `object` WHERE IDob = ?';
  dmMain.qExec.Parameters.Refresh;
  if dmMain.qExec.Parameters.Count = 0 then
    dmMain.qExec.Parameters.CreateParameter('IDob', ftInteger, pdInput, 0, Null);
  dmMain.qExec.Parameters[0].Value := ID;
  dmMain.qExec.ExecSQL;

  dmMain.qObjectList.Requery;
  ApplyGridCaptions;
end;

procedure TfrmObjects.btnApplyFilterClick(Sender: TObject);
var
  VStatus: Variant;
  VSnt: Variant;
  S: string;
begin
  S := Trim(cbFStatus.Text);
  if S = '' then
    VStatus := Null
  else
    VStatus := S;

  S := Trim(cbFSnt.Text);
  if S = '' then
    VSnt := Null
  else
    VSnt := S;

  dmMain.ApplyObjectListFilter(
    VStatus,
    VSnt,
    VNum(edPriceMin.Text),
    VNum(edPriceMax.Text),
    chkOnlyFree.Checked
  );

  ApplyGridCaptions;
end;

procedure TfrmObjects.btnClearFilterClick(Sender: TObject);
begin
  cbFStatus.KeyValue := Null;
  cbFSnt.KeyValue := Null;
  edPriceMin.Text := '';
  edPriceMax.Text := '';
  chkOnlyFree.Checked := False;
  dmMain.ResetObjectListFilter;
  ApplyGridCaptions;
end;

procedure TfrmObjects.grdObjectsTitleClick(Column: TColumn);
begin
  DBGridTitleClickSort(grdObjects, Column);
  ApplyGridCaptions;
end;

procedure TfrmObjects.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmObjects := nil;
end;

end.