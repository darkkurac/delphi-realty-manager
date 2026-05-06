unit frmDirCharacteristicTypeUnit;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBGrids, Vcl.Grids,
  Data.DB,
  dmMainUnit;

type
  TfrmDirCharacteristicType = class(TForm)
    pTop: TPanel;
    btnInsert: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnPost: TButton;
    btnCancel: TButton;
    btnRefresh: TButton;
    grd: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure grdTitleClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ApplyRoleUI;
    procedure ApplyGridCaptions;
  end;

var
  frmDirCharacteristicType: TfrmDirCharacteristicType;

implementation

{$R *.dfm}

uses
  uDBGridSortUnit;

procedure TfrmDirCharacteristicType.ApplyRoleUI;
var
  CanEdit: Boolean;
begin
  CanEdit := (dmMain.Role = urObjectAdmin);

  btnInsert.Enabled := CanEdit;
  btnEdit.Enabled := CanEdit;
  btnDelete.Enabled := CanEdit;
  btnPost.Enabled := CanEdit;
  btnCancel.Enabled := CanEdit;
  grd.ReadOnly := not CanEdit;
end;

procedure TfrmDirCharacteristicType.ApplyGridCaptions;
var
  I: Integer;
  C: TColumn;
  FN: string;
begin
  if dmMain.qCharacteristicTypeEdit.FindField('IDct') <> nil then
    dmMain.qCharacteristicTypeEdit.FieldByName('IDct').DisplayLabel := #1050#1086#1076;

  if dmMain.qCharacteristicTypeEdit.FindField('ctName') <> nil then
    dmMain.qCharacteristicTypeEdit.FieldByName('ctName').DisplayLabel := #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077;

  if dmMain.qCharacteristicTypeEdit.FindField('ctValueType') <> nil then
    dmMain.qCharacteristicTypeEdit.FieldByName('ctValueType').DisplayLabel := #1058#1080#1087;

  for I := 0 to grd.Columns.Count - 1 do
  begin
    C := grd.Columns[I];
    if C.Field = nil then Continue;

    FN := C.Field.FieldName;
    C.Title.Caption := C.Field.DisplayLabel;

    if SameText(FN, 'IDct') then
      C.Width := 60
    else if SameText(FN, 'ctName') then
      C.Width := 420
    else if SameText(FN, 'ctValueType') then
      C.Width := 90;
  end;
end;

procedure TfrmDirCharacteristicType.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmDirCharacteristicType := nil;
end;

procedure TfrmDirCharacteristicType.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  grd.DataSource := dmMain.dsCharacteristicTypeEdit;

  if not dmMain.qCharacteristicTypeEdit.Active then
    dmMain.qCharacteristicTypeEdit.Open;

  ApplyGridCaptions;
  ApplyRoleUI;
end;

procedure TfrmDirCharacteristicType.btnRefreshClick(Sender: TObject);
begin
  dmMain.qCharacteristicTypeEdit.Requery;
  ApplyGridCaptions;
end;

procedure TfrmDirCharacteristicType.btnInsertClick(Sender: TObject);
begin
  dmMain.qCharacteristicTypeEdit.Append;
end;

procedure TfrmDirCharacteristicType.btnEditClick(Sender: TObject);
begin
  dmMain.qCharacteristicTypeEdit.Edit;
end;

procedure TfrmDirCharacteristicType.btnDeleteClick(Sender: TObject);
begin
  dmMain.qCharacteristicTypeEdit.Delete;
end;

procedure TfrmDirCharacteristicType.btnPostClick(Sender: TObject);
begin
  if dmMain.qCharacteristicTypeEdit.State in [dsInsert, dsEdit] then
    dmMain.qCharacteristicTypeEdit.Post;
end;

procedure TfrmDirCharacteristicType.btnCancelClick(Sender: TObject);
begin
  if dmMain.qCharacteristicTypeEdit.State in [dsInsert, dsEdit] then
    dmMain.qCharacteristicTypeEdit.Cancel;
end;

procedure TfrmDirCharacteristicType.grdTitleClick(Column: TColumn);
begin
  DBGridTitleClickSort(grd, Column);
  ApplyGridCaptions;
end;

end.