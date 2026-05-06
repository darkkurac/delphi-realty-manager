unit frmDirSntUnit;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBGrids, Vcl.Grids,
  Data.DB,
  dmMainUnit;

type
  TfrmDirSnt = class(TForm)
    pSetTop: TPanel;
    btnSetInsert: TButton;
    btnSetEdit: TButton;
    btnSetDelete: TButton;
    btnSetPost: TButton;
    btnSetCancel: TButton;
    btnSetRefresh: TButton;
    grdSettlement: TDBGrid;

    Splitter1: TSplitter;

    pPlaceTop: TPanel;
    btnPlInsert: TButton;
    btnPlEdit: TButton;
    btnPlDelete: TButton;
    btnPlPost: TButton;
    btnPlCancel: TButton;
    btnPlRefresh: TButton;
    grdPlace: TDBGrid;

    procedure FormShow(Sender: TObject);
    procedure grdSettlementCellClick(Column: TColumn);
    procedure btnSetRefreshClick(Sender: TObject);
    procedure btnPlRefreshClick(Sender: TObject);

    procedure btnSetInsertClick(Sender: TObject);
    procedure btnSetEditClick(Sender: TObject);
    procedure btnSetDeleteClick(Sender: TObject);
    procedure btnSetPostClick(Sender: TObject);
    procedure btnSetCancelClick(Sender: TObject);

    procedure btnPlInsertClick(Sender: TObject);
    procedure btnPlEditClick(Sender: TObject);
    procedure btnPlDeleteClick(Sender: TObject);
    procedure btnPlPostClick(Sender: TObject);
    procedure btnPlCancelClick(Sender: TObject);

    procedure grdSettlementTitleClick(Column: TColumn);
    procedure grdPlaceTitleClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ApplyRoleUI;
    procedure ApplySettlementCaptions;
    procedure ApplyPlaceCaptions;
    function CurrentSettlementId: Integer;
    procedure OpenPlacesForSettlement(const AId: Integer);
  end;

var
  frmDirSnt: TfrmDirSnt;

implementation

{$R *.dfm}

uses
  uDBGridSortUnit;

procedure TfrmDirSnt.ApplyRoleUI;
var
  CanEdit: Boolean;
begin
  CanEdit := (dmMain.Role = urObjectAdmin);

  btnSetInsert.Enabled := CanEdit;
  btnSetEdit.Enabled := CanEdit;
  btnSetDelete.Enabled := CanEdit;
  btnSetPost.Enabled := CanEdit;
  btnSetCancel.Enabled := CanEdit;
  grdSettlement.ReadOnly := not CanEdit;

  btnPlInsert.Enabled := CanEdit;
  btnPlEdit.Enabled := CanEdit;
  btnPlDelete.Enabled := CanEdit;
  btnPlPost.Enabled := CanEdit;
  btnPlCancel.Enabled := CanEdit;
  grdPlace.ReadOnly := not CanEdit;
end;

procedure TfrmDirSnt.ApplySettlementCaptions;
var
  I: Integer;
  C: TColumn;
  FN: string;
begin
  if dmMain.qSettlementEdit.FindField('IDsns') <> nil then
    dmMain.qSettlementEdit.FieldByName('IDsns').DisplayLabel := #1050#1086#1076;

  if dmMain.qSettlementEdit.FindField('snsName') <> nil then
    dmMain.qSettlementEdit.FieldByName('snsName').DisplayLabel := #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077;

  for I := 0 to grdSettlement.Columns.Count - 1 do
  begin
    C := grdSettlement.Columns[I];
    if C.Field = nil then Continue;

    FN := C.Field.FieldName;
    C.Title.Caption := C.Field.DisplayLabel;

    if SameText(FN, 'IDsns') then
      C.Width := 60
    else if SameText(FN, 'snsName') then
      C.Width := 420;
  end;
end;

procedure TfrmDirSnt.ApplyPlaceCaptions;
var
  I: Integer;
  C: TColumn;
  FN: string;
begin
  if dmMain.qPlaceEdit.FindField('IDsp') <> nil then
    dmMain.qPlaceEdit.FieldByName('IDsp').DisplayLabel := #1050#1086#1076;

  if dmMain.qPlaceEdit.FindField('spAddress') <> nil then
    dmMain.qPlaceEdit.FieldByName('spAddress').DisplayLabel := #1040#1076#1088#1077#1089;

  if dmMain.qPlaceEdit.FindField('spSettlementID') <> nil then
    dmMain.qPlaceEdit.FieldByName('spSettlementID').DisplayLabel := #1048#1044' '#1087#1086#1089#1077#1083#1105#1082#1072;

  for I := 0 to grdPlace.Columns.Count - 1 do
  begin
    C := grdPlace.Columns[I];
    if C.Field = nil then Continue;

    FN := C.Field.FieldName;
    C.Title.Caption := C.Field.DisplayLabel;

    if SameText(FN, 'IDsp') then
    begin
      C.Width := 60;
      C.Visible := True;
    end
    else if SameText(FN, 'spAddress') then
    begin
      C.Width := 520;
      C.Visible := True;
    end
    else
    begin
      C.Visible := False;
    end;
  end;
end;

function TfrmDirSnt.CurrentSettlementId: Integer;
begin
  Result := 0;
  if dmMain.qSettlementEdit.Active and (not dmMain.qSettlementEdit.IsEmpty) then
    Result := dmMain.qSettlementEdit.FieldByName('IDsns').AsInteger;
end;

procedure TfrmDirSnt.OpenPlacesForSettlement(const AId: Integer);
begin
  dmMain.qPlaceEdit.Close;
  dmMain.qPlaceEdit.Parameters.ParamByName('IDsns').Value := AId;
  dmMain.qPlaceEdit.Open;
  ApplyPlaceCaptions;
end;

procedure TfrmDirSnt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmDirSnt := nil;
end;

procedure TfrmDirSnt.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  grdSettlement.DataSource := dmMain.dsSettlementEdit;
  grdPlace.DataSource := dmMain.dsPlaceEdit;

  if not dmMain.qSettlementEdit.Active then
    dmMain.qSettlementEdit.Open;

  ApplySettlementCaptions;

  if CurrentSettlementId <> 0 then
    OpenPlacesForSettlement(CurrentSettlementId);

  ApplyRoleUI;
end;

procedure TfrmDirSnt.grdSettlementCellClick(Column: TColumn);
var
  ID: Integer;
begin
  ID := CurrentSettlementId;
  if ID <> 0 then
    OpenPlacesForSettlement(ID);
end;

procedure TfrmDirSnt.btnSetRefreshClick(Sender: TObject);
begin
  dmMain.qSettlementEdit.Requery;
  ApplySettlementCaptions;

  if CurrentSettlementId <> 0 then
    OpenPlacesForSettlement(CurrentSettlementId);
end;

procedure TfrmDirSnt.btnPlRefreshClick(Sender: TObject);
begin
  if CurrentSettlementId <> 0 then
    OpenPlacesForSettlement(CurrentSettlementId);
end;

procedure TfrmDirSnt.btnSetInsertClick(Sender: TObject);
begin
  dmMain.qSettlementEdit.Append;
end;

procedure TfrmDirSnt.btnSetEditClick(Sender: TObject);
begin
  dmMain.qSettlementEdit.Edit;
end;

procedure TfrmDirSnt.btnSetDeleteClick(Sender: TObject);
begin
  dmMain.qSettlementEdit.Delete;
end;

procedure TfrmDirSnt.btnSetPostClick(Sender: TObject);
begin
  if dmMain.qSettlementEdit.State in [dsInsert, dsEdit] then
    dmMain.qSettlementEdit.Post;
end;

procedure TfrmDirSnt.btnSetCancelClick(Sender: TObject);
begin
  if dmMain.qSettlementEdit.State in [dsInsert, dsEdit] then
    dmMain.qSettlementEdit.Cancel;
end;

procedure TfrmDirSnt.btnPlInsertClick(Sender: TObject);
var
  ID: Integer;
begin
  ID := CurrentSettlementId;
  if ID = 0 then Exit;

  dmMain.qPlaceEdit.Append;
  if dmMain.qPlaceEdit.FindField('spSettlementID') <> nil then
    dmMain.qPlaceEdit.FieldByName('spSettlementID').AsInteger := ID;
end;

procedure TfrmDirSnt.btnPlEditClick(Sender: TObject);
begin
  dmMain.qPlaceEdit.Edit;
end;

procedure TfrmDirSnt.btnPlDeleteClick(Sender: TObject);
begin
  dmMain.qPlaceEdit.Delete;
end;

procedure TfrmDirSnt.btnPlPostClick(Sender: TObject);
begin
  if dmMain.qPlaceEdit.State in [dsInsert, dsEdit] then
    dmMain.qPlaceEdit.Post;
end;

procedure TfrmDirSnt.btnPlCancelClick(Sender: TObject);
begin
  if dmMain.qPlaceEdit.State in [dsInsert, dsEdit] then
    dmMain.qPlaceEdit.Cancel;
end;

procedure TfrmDirSnt.grdSettlementTitleClick(Column: TColumn);
var
  ID: Integer;
begin
  ID := CurrentSettlementId;
  DBGridTitleClickSort(grdSettlement, Column);
  ApplySettlementCaptions;

  if ID <> 0 then
  begin
    dmMain.qSettlementEdit.Locate('IDsns', ID, []);
    OpenPlacesForSettlement(CurrentSettlementId);
  end;
end;

procedure TfrmDirSnt.grdPlaceTitleClick(Column: TColumn);
begin
  DBGridTitleClickSort(grdPlace, Column);
  ApplyPlaceCaptions;
end;

end.