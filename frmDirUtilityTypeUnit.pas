unit frmDirUtilityTypeUnit;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBGrids, Vcl.Grids,
  Data.DB,
  dmMainUnit;

type
  TfrmDirUtilityType = class(TForm)
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
  frmDirUtilityType: TfrmDirUtilityType;

implementation

{$R *.dfm}

uses
  uDBGridSortUnit;

procedure TfrmDirUtilityType.ApplyRoleUI;
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

procedure TfrmDirUtilityType.ApplyGridCaptions;
var
  I: Integer;
  C: TColumn;
  FN: string;
begin
  if dmMain.qUtilityTypeEdit.FindField('IDut') <> nil then
    dmMain.qUtilityTypeEdit.FieldByName('IDut').DisplayLabel := #1050#1086#1076;

  if dmMain.qUtilityTypeEdit.FindField('utName') <> nil then
    dmMain.qUtilityTypeEdit.FieldByName('utName').DisplayLabel := #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077;

  for I := 0 to grd.Columns.Count - 1 do
  begin
    C := grd.Columns[I];
    if C.Field = nil then Continue;

    FN := C.Field.FieldName;
    C.Title.Caption := C.Field.DisplayLabel;

    if SameText(FN, 'IDut') then
      C.Width := 60
    else if SameText(FN, 'utName') then
      C.Width := 480;
  end;
end;

procedure TfrmDirUtilityType.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmDirUtilityType := nil;
end;

procedure TfrmDirUtilityType.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  grd.DataSource := dmMain.dsUtilityTypeEdit;

  if not dmMain.qUtilityTypeEdit.Active then
    dmMain.qUtilityTypeEdit.Open;

  ApplyGridCaptions;
  ApplyRoleUI;
end;

procedure TfrmDirUtilityType.btnRefreshClick(Sender: TObject);
begin
  dmMain.qUtilityTypeEdit.Requery;
  ApplyGridCaptions;
end;

procedure TfrmDirUtilityType.btnInsertClick(Sender: TObject);
begin
  dmMain.qUtilityTypeEdit.Append;
end;

procedure TfrmDirUtilityType.btnEditClick(Sender: TObject);
begin
  dmMain.qUtilityTypeEdit.Edit;
end;

procedure TfrmDirUtilityType.btnDeleteClick(Sender: TObject);
begin
  dmMain.qUtilityTypeEdit.Delete;
end;

procedure TfrmDirUtilityType.btnPostClick(Sender: TObject);
begin
  if dmMain.qUtilityTypeEdit.State in [dsInsert, dsEdit] then
    dmMain.qUtilityTypeEdit.Post;
end;

procedure TfrmDirUtilityType.btnCancelClick(Sender: TObject);
begin
  if dmMain.qUtilityTypeEdit.State in [dsInsert, dsEdit] then
    dmMain.qUtilityTypeEdit.Cancel;
end;

procedure TfrmDirUtilityType.grdTitleClick(Column: TColumn);
begin
  DBGridTitleClickSort(grd, Column);
  ApplyGridCaptions;
end;

end.