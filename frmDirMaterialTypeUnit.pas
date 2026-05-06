unit frmDirMaterialTypeUnit;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBGrids, Vcl.Grids,
  Data.DB,
  dmMainUnit;

type
  TfrmDirMaterialType = class(TForm)
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
  frmDirMaterialType: TfrmDirMaterialType;

implementation

{$R *.dfm}

uses
  uDBGridSortUnit;

procedure TfrmDirMaterialType.ApplyRoleUI;
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

procedure TfrmDirMaterialType.ApplyGridCaptions;
var
  I: Integer;
  C: TColumn;
  FN: string;
begin
  if dmMain.qMaterialTypeEdit.FindField('IDmt') <> nil then
    dmMain.qMaterialTypeEdit.FieldByName('IDmt').DisplayLabel := #1050#1086#1076;

  if dmMain.qMaterialTypeEdit.FindField('mtName') <> nil then
    dmMain.qMaterialTypeEdit.FieldByName('mtName').DisplayLabel := #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077;

  for I := 0 to grd.Columns.Count - 1 do
  begin
    C := grd.Columns[I];
    if C.Field = nil then Continue;

    FN := C.Field.FieldName;
    C.Title.Caption := C.Field.DisplayLabel;

    if SameText(FN, 'IDmt') then
      C.Width := 60
    else if SameText(FN, 'mtName') then
      C.Width := 480;
  end;
end;

procedure TfrmDirMaterialType.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmDirMaterialType := nil;
end;

procedure TfrmDirMaterialType.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  grd.DataSource := dmMain.dsMaterialTypeEdit;

  if not dmMain.qMaterialTypeEdit.Active then
    dmMain.qMaterialTypeEdit.Open;

  ApplyGridCaptions;
  ApplyRoleUI;
end;

procedure TfrmDirMaterialType.btnRefreshClick(Sender: TObject);
begin
  dmMain.qMaterialTypeEdit.Requery;
  ApplyGridCaptions;
end;

procedure TfrmDirMaterialType.btnInsertClick(Sender: TObject);
begin
  dmMain.qMaterialTypeEdit.Append;
end;

procedure TfrmDirMaterialType.btnEditClick(Sender: TObject);
begin
  dmMain.qMaterialTypeEdit.Edit;
end;

procedure TfrmDirMaterialType.btnDeleteClick(Sender: TObject);
begin
  dmMain.qMaterialTypeEdit.Delete;
end;

procedure TfrmDirMaterialType.btnPostClick(Sender: TObject);
begin
  if dmMain.qMaterialTypeEdit.State in [dsInsert, dsEdit] then
    dmMain.qMaterialTypeEdit.Post;
end;

procedure TfrmDirMaterialType.btnCancelClick(Sender: TObject);
begin
  if dmMain.qMaterialTypeEdit.State in [dsInsert, dsEdit] then
    dmMain.qMaterialTypeEdit.Cancel;
end;

procedure TfrmDirMaterialType.grdTitleClick(Column: TColumn);
begin
  DBGridTitleClickSort(grd, Column);
  ApplyGridCaptions;
end;

end.