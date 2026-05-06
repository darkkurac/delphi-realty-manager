unit frmObjectCardUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.Mask, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.DB, Data.Win.ADODB,
  dmMainUnit;

type
  TfrmObjectCard = class(TForm)
    pButtons: TPanel;
    btnPost: TButton;
    btnCancel: TButton;
    pMain: TPanel;
    gbMain: TGroupBox;
    lblName: TLabel;
    lblStatus: TLabel;
    lblPrice: TLabel;
    lblArea: TLabel;
    lblFloors: TLabel;
    lblPlace: TLabel;
    pcDetails: TPageControl;
    tsPhoto: TTabSheet;
    tsChar: TTabSheet;
    tsUtil: TTabSheet;
    tsMat: TTabSheet;
    grdPhoto: TDBGrid;
    grdChar: TDBGrid;
    grdUtil: TDBGrid;
    grdMat: TDBGrid;
    edPrice: TEdit;
    edArea: TEdit;
    edFloors: TEdit;
    edName: TEdit;
    cbStatus: TDBLookupComboBox;
    cbPlace: TDBLookupComboBox;
    OpenDialog1: TOpenDialog;
    btnAddPhoto: TButton;
    chkMain: TCheckBox;
    imgMainPhoto: TDBImage;
    btnDeletePhoto: TButton;
    btnSetMainPhoto: TButton;

    btnAddChar: TButton;
    btnEditChar: TButton;
    btnDeleteChar: TButton;

    btnAddUtil: TButton;
    btnEditUtil: TButton;
    btnDeleteUtil: TButton;

    btnAddMat: TButton;
    btnEditMat: TButton;
    btnDeleteMat: TButton;

    procedure btnCancelClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnAddPhotoClick(Sender: TObject);
    procedure btnDeletePhotoClick(Sender: TObject);
    procedure btnSetMainPhotoClick(Sender: TObject);

    procedure btnAddCharClick(Sender: TObject);
    procedure btnEditCharClick(Sender: TObject);
    procedure btnDeleteCharClick(Sender: TObject);

    procedure btnAddUtilClick(Sender: TObject);
    procedure btnEditUtilClick(Sender: TObject);
    procedure btnDeleteUtilClick(Sender: TObject);

    procedure btnAddMatClick(Sender: TObject);
    procedure btnEditMatClick(Sender: TObject);
    procedure btnDeleteMatClick(Sender: TObject);
  private
    FMode: string;
    FObjectId: Integer;

    function CanEditObject: Boolean;
    function CurrentObjectId: Integer;
    function CurrentPhotoId: Integer;
    procedure ApplyRolePermissions;
    procedure StartView(const AObjectId: Integer);
    procedure ConfigureDetailViews;
    procedure RefreshMainPhoto;
    procedure RefreshPhotoControls;
    procedure RefreshDetailButtons;
    procedure ClearMainPhoto;
    procedure OpenDetailsFor(const AObjectId: Integer);
    procedure CloseDetails;
    procedure ClearObjectControls;
    procedure LoadObjectControls;
    procedure SaveObject;
    procedure SetObjectEditParamValue(const AValue: Variant);
    procedure StartInsert;
    procedure StartEdit(const AObjectId: Integer);

    function BuildLookupList(ADataSet: TDataSet; const AIdField, ANameField: string;
      const AExtraField: string = ''): string;
    function PromptTypeId(const ACaption, APrompt, AListText: string; out ATypeId: Integer): Boolean;

    function PromptCharacteristicValue(const ATypeName, AValueType: string;
      const ACurrentNum, ACurrentText, ACurrentBool: Variant;
      out ANum, AText, ABool: Variant): Boolean;

    function PromptUtilityValue(const ATypeName, AUnit: string;
      const ACurrentAvailable, ACurrentTariff, ACurrentComment: Variant;
      out AAvailable, ATariff, AComment: Variant): Boolean;

    function PromptMaterialValue(const ATypeName: string;
      const ACurrentNote: Variant; out ANote: Variant): Boolean;

    procedure SaveObjectCharacteristic(const ATypeId: Integer;
      const ANum, AText, ABool: Variant);
    procedure DeleteObjectCharacteristic(const ATypeId: Integer);

    procedure SaveObjectUtility(const ATypeId: Integer;
      const AAvailable, ATariff, AComment: Variant);
    procedure DeleteObjectUtility(const ATypeId: Integer);

    procedure SaveObjectMaterial(const ATypeId: Integer;
      const ANote: Variant);
    procedure DeleteObjectMaterial(const ATypeId: Integer);
  public
    procedure OpenForMode(const AMode: string; const AObjectId: Integer);
  end;

var
  frmObjectCard: TfrmObjectCard;

implementation

{$R *.dfm}

procedure PrepareQueryParams(Q: TADOQuery);
begin
  try
    Q.Parameters.Refresh;
  except
  end;

  if dmMain <> nil then
    dmMain.FixParamTypes(Q);
end;

procedure EnsureQueryParam(Q: TADOQuery; const ParamName: string;
  ADataType: TDataType; const ASize: Integer = 0);
begin
  if Q = nil then Exit;

  if Q.Parameters.FindParam(ParamName) = nil then
    Q.Parameters.CreateParameter(ParamName, ADataType, pdInput, ASize, Null);
end;

function VariantIsTrue(const V: Variant): Boolean;
var
  S: string;
begin
  Result := False;
  if VarIsNull(V) then
    Exit;

  S := Trim(VarToStr(V));
  Result :=
    SameText(S, '1') or
    SameText(S, 'TRUE') or
    SameText(S, 'YES') or
    SameText(S, 'ДА');
end;

function NullIfEmpty(const S: string): Variant;
begin
  if Trim(S) = '' then
    Result := Null
  else
    Result := Trim(S);
end;

function TryTextToFloatEx(const S: string; out AValue: Double): Boolean;
var
  FS: TFormatSettings;
  T: string;
begin
  FS := FormatSettings;
  T := Trim(S);
  T := StringReplace(T, '.', FS.DecimalSeparator, [rfReplaceAll]);
  T := StringReplace(T, ',', FS.DecimalSeparator, [rfReplaceAll]);
  Result := TryStrToFloat(T, AValue, FS);
end;

function TfrmObjectCard.CanEditObject: Boolean;
begin
  Result := (dmMain <> nil) and (dmMain.Role = urObjectAdmin);
end;

function TfrmObjectCard.CurrentObjectId: Integer;
begin
  Result := FObjectId;

  if (dmMain <> nil) and dmMain.qObjectCard.Active and
     (not dmMain.qObjectCard.IsEmpty) and
     (dmMain.qObjectCard.FindField('IDob') <> nil) and
     (not dmMain.qObjectCard.FieldByName('IDob').IsNull) then
    Result := dmMain.qObjectCard.FieldByName('IDob').AsInteger;
end;

function TfrmObjectCard.CurrentPhotoId: Integer;
begin
  Result := 0;
  if (dmMain <> nil) and dmMain.qObjectPhoto.Active and (not dmMain.qObjectPhoto.IsEmpty) and
     (dmMain.qObjectPhoto.FindField('IDph') <> nil) and
     (not dmMain.qObjectPhoto.FieldByName('IDph').IsNull) then
    Result := dmMain.qObjectPhoto.FieldByName('IDph').AsInteger;
end;

procedure TfrmObjectCard.ClearMainPhoto;
begin
  imgMainPhoto.Picture.Assign(nil);
end;

procedure TfrmObjectCard.RefreshMainPhoto;
var
  ObjId: Integer;
begin
  ClearMainPhoto;
  ObjId := CurrentObjectId;
  if ObjId <= 0 then
    Exit;

  try
    dmMain.LoadMainObjectPhotoToImage(ObjId, imgMainPhoto.Picture);
  except
    on E: Exception do
    begin
      ClearMainPhoto;
      // временно можно показать сообщение:
      // ShowMessage(E.Message);
    end;
  end;
end;

procedure TfrmObjectCard.RefreshPhotoControls;
var
  CanEdit: Boolean;
  HasObject: Boolean;
  HasPhoto: Boolean;
begin
  CanEdit := CanEditObject;
  HasObject := CurrentObjectId > 0;
  HasPhoto := (dmMain <> nil) and dmMain.qObjectPhoto.Active and (not dmMain.qObjectPhoto.IsEmpty);

  btnAddPhoto.Enabled := CanEdit and HasObject;
  btnDeletePhoto.Enabled := CanEdit and HasPhoto;
  btnSetMainPhoto.Enabled := CanEdit and HasPhoto;
  chkMain.Enabled := CanEdit and HasObject;

  if not chkMain.Enabled then
    chkMain.Checked := False;
end;

procedure TfrmObjectCard.ApplyRolePermissions;
var
  CanEdit: Boolean;
begin
  CanEdit := CanEditObject;

  btnPost.Enabled := CanEdit;

  edName.ReadOnly := not CanEdit;
  edPrice.ReadOnly := not CanEdit;
  edArea.ReadOnly := not CanEdit;
  edFloors.ReadOnly := not CanEdit;

  cbStatus.Enabled := CanEdit;
  cbPlace.Enabled := CanEdit;

  grdPhoto.ReadOnly := True;
  grdChar.ReadOnly := True;
  grdUtil.ReadOnly := True;
  grdMat.ReadOnly := True;

  if CanEdit then
    btnCancel.Caption := 'Отмена'
  else
    btnCancel.Caption := 'Закрыть';

  RefreshPhotoControls;
  RefreshDetailButtons;
end;

procedure TfrmObjectCard.StartView(const AObjectId: Integer);
begin
  FObjectId := AObjectId;

  dmMain.qObjectCard.Close;
  dmMain.qObjectCard.Parameters.ParamByName('IDob').Value := AObjectId;
  dmMain.qObjectCard.Open;

  if dmMain.qObjectCard.IsEmpty then
    raise Exception.Create('Объект не найден (ID=' + IntToStr(AObjectId) + ').');

  LoadObjectControls;
  OpenDetailsFor(AObjectId);
end;

procedure TfrmObjectCard.CloseDetails;
begin
  if dmMain.qObjectPhoto.Active then dmMain.qObjectPhoto.Close;
  if dmMain.qObjectChar.Active then dmMain.qObjectChar.Close;
  if dmMain.qObjectUtility.Active then dmMain.qObjectUtility.Close;
  if dmMain.qObjectMaterial.Active then dmMain.qObjectMaterial.Close;
  ClearMainPhoto;
  RefreshPhotoControls;
end;

procedure TfrmObjectCard.ConfigureDetailViews;
begin
  if dmMain.qObjectPhoto.Active then
  begin
    if dmMain.qObjectPhoto.FindField('IDph') <> nil then
      dmMain.qObjectPhoto.FieldByName('IDph').Visible := False;
    if dmMain.qObjectPhoto.FindField('phObjectID') <> nil then
      dmMain.qObjectPhoto.FieldByName('phObjectID').Visible := False;
    if dmMain.qObjectPhoto.FindField('phBlob') <> nil then
      dmMain.qObjectPhoto.FieldByName('phBlob').Visible := False;

    if dmMain.qObjectPhoto.FindField('phIsMain') <> nil then
      dmMain.qObjectPhoto.FieldByName('phIsMain').DisplayLabel := 'Главное';
    if dmMain.qObjectPhoto.FindField('phFileName') <> nil then
      dmMain.qObjectPhoto.FieldByName('phFileName').DisplayLabel := 'Файл';
    if dmMain.qObjectPhoto.FindField('phMime') <> nil then
      dmMain.qObjectPhoto.FieldByName('phMime').DisplayLabel := 'Тип';
    if dmMain.qObjectPhoto.FindField('phSize') <> nil then
      dmMain.qObjectPhoto.FieldByName('phSize').DisplayLabel := 'Размер, байт';
    if dmMain.qObjectPhoto.FindField('phCreatedAt') <> nil then
      dmMain.qObjectPhoto.FieldByName('phCreatedAt').DisplayLabel := 'Добавлено';

    if grdPhoto.Columns.Count >= 5 then
    begin
      grdPhoto.Columns[0].Title.Caption := 'Главное';
      grdPhoto.Columns[1].Title.Caption := 'Файл';
      grdPhoto.Columns[2].Title.Caption := 'Тип';
      grdPhoto.Columns[3].Title.Caption := 'Размер, байт';
      grdPhoto.Columns[4].Title.Caption := 'Добавлено';
    end;
  end;

  if dmMain.qObjectChar.Active then
  begin
    if dmMain.qObjectChar.FindField('IDoc') <> nil then
      dmMain.qObjectChar.FieldByName('IDoc').Visible := False;
    if dmMain.qObjectChar.FindField('IDob') <> nil then
      dmMain.qObjectChar.FieldByName('IDob').Visible := False;
    if dmMain.qObjectChar.FindField('IDct') <> nil then
      dmMain.qObjectChar.FieldByName('IDct').Visible := False;
    if dmMain.qObjectChar.FindField('ctValueType') <> nil then
      dmMain.qObjectChar.FieldByName('ctValueType').Visible := False;

    if dmMain.qObjectChar.FindField('ctName') <> nil then
      dmMain.qObjectChar.FieldByName('ctName').DisplayLabel := 'Характеристика';
    if dmMain.qObjectChar.FindField('ctUnit') <> nil then
      dmMain.qObjectChar.FieldByName('ctUnit').DisplayLabel := 'Ед. изм.';
    if dmMain.qObjectChar.FindField('ocValueNum') <> nil then
      dmMain.qObjectChar.FieldByName('ocValueNum').DisplayLabel := 'Числовое значение';
    if dmMain.qObjectChar.FindField('ocValueText') <> nil then
      dmMain.qObjectChar.FieldByName('ocValueText').DisplayLabel := 'Текстовое значение';
    if dmMain.qObjectChar.FindField('ocValueBool') <> nil then
      dmMain.qObjectChar.FieldByName('ocValueBool').DisplayLabel := 'Логическое значение';

    if grdChar.Columns.Count >= 5 then
    begin
      grdChar.Columns[0].Title.Caption := 'Характеристика';
      grdChar.Columns[1].Title.Caption := 'Ед. изм.';
      grdChar.Columns[2].Title.Caption := 'Числовое значение';
      grdChar.Columns[3].Title.Caption := 'Текстовое значение';
      grdChar.Columns[4].Title.Caption := 'Логическое значение';
    end;
  end;

  if dmMain.qObjectUtility.Active then
  begin
    if dmMain.qObjectUtility.FindField('IDou') <> nil then
      dmMain.qObjectUtility.FieldByName('IDou').Visible := False;
    if dmMain.qObjectUtility.FindField('IDob') <> nil then
      dmMain.qObjectUtility.FieldByName('IDob').Visible := False;
    if dmMain.qObjectUtility.FindField('IDut') <> nil then
      dmMain.qObjectUtility.FieldByName('IDut').Visible := False;

    if dmMain.qObjectUtility.FindField('utName') <> nil then
      dmMain.qObjectUtility.FieldByName('utName').DisplayLabel := 'Коммунальная услуга';
    if dmMain.qObjectUtility.FindField('utUnit') <> nil then
      dmMain.qObjectUtility.FieldByName('utUnit').DisplayLabel := 'Ед. изм.';
    if dmMain.qObjectUtility.FindField('ouAvailable') <> nil then
      dmMain.qObjectUtility.FieldByName('ouAvailable').DisplayLabel := 'Доступна';
    if dmMain.qObjectUtility.FindField('ouTariff') <> nil then
      dmMain.qObjectUtility.FieldByName('ouTariff').DisplayLabel := 'Тариф';
    if dmMain.qObjectUtility.FindField('ouComment') <> nil then
      dmMain.qObjectUtility.FieldByName('ouComment').DisplayLabel := 'Комментарий';

    if grdUtil.Columns.Count >= 5 then
    begin
      grdUtil.Columns[0].Title.Caption := 'Коммунальная услуга';
      grdUtil.Columns[1].Title.Caption := 'Ед. изм.';
      grdUtil.Columns[2].Title.Caption := 'Доступна';
      grdUtil.Columns[3].Title.Caption := 'Тариф';
      grdUtil.Columns[4].Title.Caption := 'Комментарий';
    end;
  end;

  if dmMain.qObjectMaterial.Active then
  begin
    if dmMain.qObjectMaterial.FindField('IDom') <> nil then
      dmMain.qObjectMaterial.FieldByName('IDom').Visible := False;
    if dmMain.qObjectMaterial.FindField('IDob') <> nil then
      dmMain.qObjectMaterial.FieldByName('IDob').Visible := False;
    if dmMain.qObjectMaterial.FindField('IDmt') <> nil then
      dmMain.qObjectMaterial.FieldByName('IDmt').Visible := False;

    if dmMain.qObjectMaterial.FindField('mtName') <> nil then
      dmMain.qObjectMaterial.FieldByName('mtName').DisplayLabel := 'Материал';
    if dmMain.qObjectMaterial.FindField('omNote') <> nil then
      dmMain.qObjectMaterial.FieldByName('omNote').DisplayLabel := 'Примечание';

    if grdMat.Columns.Count >= 2 then
    begin
      grdMat.Columns[0].Title.Caption := 'Материал';
      grdMat.Columns[1].Title.Caption := 'Примечание';
    end;
  end;
end;

procedure TfrmObjectCard.OpenDetailsFor(const AObjectId: Integer);
begin
  FObjectId := AObjectId;

  try
    dmMain.qObjectPhoto.Close;
    dmMain.qObjectPhoto.Parameters.ParamByName('IDob').Value := AObjectId;
    dmMain.qObjectPhoto.Open;
  except
    on E: Exception do
      raise Exception.Create('qObjectPhoto.Open: ' + E.Message);
  end;

  try
    dmMain.qObjectChar.Close;
    dmMain.qObjectChar.Parameters.ParamByName('IDob').Value := AObjectId;
    dmMain.qObjectChar.Open;
  except
    on E: Exception do
      raise Exception.Create('qObjectChar.Open: ' + E.Message);
  end;

  try
    dmMain.qObjectUtility.Close;
    dmMain.qObjectUtility.Parameters.ParamByName('IDob').Value := AObjectId;
    dmMain.qObjectUtility.Open;
  except
    on E: Exception do
      raise Exception.Create('qObjectUtility.Open: ' + E.Message);
  end;

  try
    dmMain.qObjectMaterial.Close;
    dmMain.qObjectMaterial.Parameters.ParamByName('IDob').Value := AObjectId;
    dmMain.qObjectMaterial.Open;
  except
    on E: Exception do
      raise Exception.Create('qObjectMaterial.Open: ' + E.Message);
  end;

  try
    ConfigureDetailViews;
  except
    on E: Exception do
      raise Exception.Create('ConfigureDetailViews: ' + E.Message);
  end;

  try
    RefreshMainPhoto;
  except
    on E: Exception do
      raise Exception.Create('RefreshMainPhoto: ' + E.Message);
  end;

  RefreshPhotoControls;
end;

procedure TfrmObjectCard.StartInsert;
begin
  FObjectId := 0;
  dmMain.qObjectEdit.Close;
  ClearObjectControls;
  ClearMainPhoto;
  CloseDetails;
end;

procedure TfrmObjectCard.StartEdit(const AObjectId: Integer);
begin
  FObjectId := AObjectId;

  if not CanEditObject then
  begin
    StartView(AObjectId);
    Exit;
  end;

  dmMain.qObjectCard.Close;
  dmMain.qObjectCard.Parameters.ParamByName('IDob').Value := AObjectId;
  dmMain.qObjectCard.Open;

  if dmMain.qObjectCard.IsEmpty then
    raise Exception.Create('Объект не найден (ID=' + IntToStr(AObjectId) + ').');

  LoadObjectControls;
  OpenDetailsFor(AObjectId);
end;

procedure TfrmObjectCard.ClearObjectControls;
begin
  edName.Text := '';
  edPrice.Text := '';
  edArea.Text := '';
  edFloors.Text := '';
  cbStatus.KeyValue := Null;
  cbPlace.KeyValue := Null;
end;

procedure TfrmObjectCard.LoadObjectControls;
begin
  ClearObjectControls;

  if (dmMain = nil) or (not dmMain.qObjectCard.Active) or dmMain.qObjectCard.IsEmpty then
    Exit;

  if dmMain.qObjectCard.FindField('obName') <> nil then
    edName.Text := dmMain.qObjectCard.FieldByName('obName').AsString;

  if (dmMain.qObjectCard.FindField('obPrice') <> nil) and
     (not dmMain.qObjectCard.FieldByName('obPrice').IsNull) then
    edPrice.Text := dmMain.qObjectCard.FieldByName('obPrice').AsString;

  if (dmMain.qObjectCard.FindField('obTotalArea') <> nil) and
     (not dmMain.qObjectCard.FieldByName('obTotalArea').IsNull) then
    edArea.Text := dmMain.qObjectCard.FieldByName('obTotalArea').AsString;

  if (dmMain.qObjectCard.FindField('obFloors') <> nil) and
     (not dmMain.qObjectCard.FieldByName('obFloors').IsNull) then
    edFloors.Text := dmMain.qObjectCard.FieldByName('obFloors').AsString;

  if (dmMain.qObjectCard.FindField('obStatusID') <> nil) and
     (not dmMain.qObjectCard.FieldByName('obStatusID').IsNull) then
    cbStatus.KeyValue := dmMain.qObjectCard.FieldByName('obStatusID').AsInteger;

  if (dmMain.qObjectCard.FindField('obPlaceID') <> nil) and
     (not dmMain.qObjectCard.FieldByName('obPlaceID').IsNull) then
    cbPlace.KeyValue := dmMain.qObjectCard.FieldByName('obPlaceID').AsInteger;
end;

procedure TfrmObjectCard.SaveObject;
var
  Q: TADOQuery;
  VStatus: Variant;
  VPlace: Variant;
  VPrice: Variant;
  VArea: Variant;
  VFloors: Variant;
  S: string;
  D: Double;
  I: Integer;

  function ParseFloatOrNull(const AText: string): Variant;
  var
    T: string;
  begin
    T := Trim(AText);
    if T = '' then
      Exit(Null);
    T := StringReplace(T, ',', '.', [rfReplaceAll]);
    if not TryStrToFloat(T, D) then
      raise Exception.Create('Некорректное числовое значение.');
    Result := D;
  end;

  function ParseIntOrNull(const AText: string): Variant;
  var
    T: string;
  begin
    T := Trim(AText);
    if T = '' then
      Exit(Null);
    if not TryStrToInt(T, I) then
      raise Exception.Create('Некорректное целочисленное значение.');
    Result := I;
  end;

  procedure PutParam(const AName: string; AType: TDataType; const AValue: Variant; const ASize: Integer = 0);
  begin
    if Q.Parameters.FindParam(AName) = nil then
      Q.Parameters.CreateParameter(AName, AType, pdInput, ASize, AValue);
    Q.Parameters.ParamByName(AName).Value := AValue;
  end;

begin
  S := Trim(edName.Text);
  if S = '' then
    raise Exception.Create('Не заполнено наименование.');

  VStatus := cbStatus.KeyValue;
  if VarIsEmpty(VStatus) or VarIsNull(VStatus) then
    raise Exception.Create('Не выбран статус.');

  VPlace := cbPlace.KeyValue;
  if VarIsEmpty(VPlace) or VarIsNull(VPlace) then
    raise Exception.Create('Не выбран участок/адрес.');

  VPrice := ParseFloatOrNull(edPrice.Text);
  VArea := ParseFloatOrNull(edArea.Text);
  VFloors := ParseIntOrNull(edFloors.Text);

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := dmMain.conMain;

    if (FMode = 'INS') or (FObjectId <= 0) then
    begin
      Q.SQL.Text :=
        'INSERT INTO `object` ' +
        '(obName, obPrice, obStatusID, obPlaceID, obTotalArea, obFloors, obCreatedAt, obUpdatedAt) ' +
        'VALUES ' +
        '(:pName, :pPrice, :pStatusID, :pPlaceID, :pArea, :pFloors, NOW(), NOW())';
      Q.Parameters.Clear;
      PutParam('pName', ftWideString, S, 255);
      PutParam('pPrice', ftFloat, VPrice);
      PutParam('pStatusID', ftInteger, VStatus);
      PutParam('pPlaceID', ftInteger, VPlace);
      PutParam('pArea', ftFloat, VArea);
      PutParam('pFloors', ftInteger, VFloors);
      Q.ExecSQL;

      Q.Close;
      Q.SQL.Text := 'SELECT LAST_INSERT_ID() AS IDob';
      Q.Parameters.Clear;
      Q.Open;
      if not Q.IsEmpty then
        FObjectId := Q.FieldByName('IDob').AsInteger;
      FMode := 'EDIT';
    end
    else
    begin
      Q.SQL.Text :=
        'UPDATE `object` SET ' +
        '  obName = :pName, ' +
        '  obPrice = :pPrice, ' +
        '  obStatusID = :pStatusID, ' +
        '  obPlaceID = :pPlaceID, ' +
        '  obTotalArea = :pArea, ' +
        '  obFloors = :pFloors, ' +
        '  obUpdatedAt = NOW() ' +
        'WHERE IDob = :pID';
      Q.Parameters.Clear;
      PutParam('pName', ftWideString, S, 255);
      PutParam('pPrice', ftFloat, VPrice);
      PutParam('pStatusID', ftInteger, VStatus);
      PutParam('pPlaceID', ftInteger, VPlace);
      PutParam('pArea', ftFloat, VArea);
      PutParam('pFloors', ftInteger, VFloors);
      PutParam('pID', ftInteger, FObjectId);
      Q.ExecSQL;
    end;
  finally
    Q.Free;
  end;

  if FObjectId > 0 then
  begin
    dmMain.qObjectCard.Close;
    dmMain.qObjectCard.Parameters.ParamByName('IDob').Value := FObjectId;
    dmMain.qObjectCard.Open;
    LoadObjectControls;
  end;
end;

procedure TfrmObjectCard.SetObjectEditParamValue(const AValue: Variant);
var
  I: Integer;
begin
  if dmMain.qObjectEdit.Parameters.Count = 0 then
  begin
    try
      dmMain.qObjectEdit.Parameters.Refresh;
    except
    end;
  end;

  for I := 0 to dmMain.qObjectEdit.Parameters.Count - 1 do
    dmMain.qObjectEdit.Parameters[I].Value := AValue;

  if dmMain.qObjectEdit.Parameters.FindParam('pID') <> nil then
    dmMain.qObjectEdit.Parameters.ParamByName('pID').Value := AValue;
end;

procedure TfrmObjectCard.OpenForMode(const AMode: string; const AObjectId: Integer);
begin
  FMode := UpperCase(Trim(AMode));
  FObjectId := AObjectId;

  cbStatus.DataSource := nil;
  cbStatus.DataField := '';
  cbStatus.ListSource := dmMain.dsStatus;
  cbStatus.KeyField := 'IDos';
  cbStatus.ListField := 'osName';

  cbPlace.DataSource := nil;
  cbPlace.DataField := '';
  cbPlace.ListSource := dmMain.dsPlace;
  cbPlace.KeyField := 'IDsp';
  cbPlace.ListField := 'spAddress';

  imgMainPhoto.DataSource := nil;
  imgMainPhoto.DataField := '';

  grdPhoto.DataSource := dmMain.dsObjectPhoto;
  grdChar.DataSource := dmMain.dsObjectChar;
  grdUtil.DataSource := dmMain.dsObjectUtility;
  grdMat.DataSource := dmMain.dsObjectMaterial;

  chkMain.Checked := False;

  if CanEditObject then
  begin
    if FMode = 'INS' then
      StartInsert
    else
      StartEdit(FObjectId);
  end
  else
  begin
    if FObjectId > 0 then
      StartView(FObjectId)
    else
    begin
      dmMain.qObjectEdit.Close;
      ClearObjectControls;
      CloseDetails;
    end;
  end;

  ApplyRolePermissions;
end;

procedure TfrmObjectCard.btnCancelClick(Sender: TObject);
begin
  CloseDetails;
  ModalResult := mrCancel;
end;

procedure TfrmObjectCard.btnPostClick(Sender: TObject);
begin
  if not CanEditObject then Exit;

  SaveObject;

  if FObjectId > 0 then
  begin
    OpenDetailsFor(FObjectId);
    if dmMain.qObjectList.Active then
    begin
      dmMain.qObjectList.Requery;
      dmMain.qObjectList.Locate('IDob', FObjectId, []);
    end;
  end;

  FMode := 'EDIT';
  RefreshPhotoControls;
  ModalResult := mrOk;
end;

procedure TfrmObjectCard.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CloseDetails;
  CanClose := True;
end;

procedure TfrmObjectCard.btnAddPhotoClick(Sender: TObject);
var
  ObjId: Integer;
begin
  if not CanEditObject then
    Exit;

  ObjId := CurrentObjectId;
  if ObjId <= 0 then
    Exit;

  if OpenDialog1.Execute then
  begin
    try
      dmMain.AddObjectPhotoBlob(ObjId, OpenDialog1.FileName, chkMain.Checked);
      chkMain.Checked := False;
      RefreshMainPhoto;
      RefreshPhotoControls;
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmObjectCard.btnDeletePhotoClick(Sender: TObject);
var
  PhotoId: Integer;
  ObjId: Integer;
begin
  if not CanEditObject then
    Exit;

  ObjId := CurrentObjectId;
  PhotoId := CurrentPhotoId;

  if (ObjId <= 0) or (PhotoId <= 0) then
    Exit;

  try
    dmMain.DeleteObjectPhoto(PhotoId);
    chkMain.Checked := False;
    RefreshMainPhoto;
    RefreshPhotoControls;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmObjectCard.btnSetMainPhotoClick(Sender: TObject);
var
  PhotoId: Integer;
  ObjId: Integer;
begin
  if not CanEditObject then
    Exit;

  ObjId := CurrentObjectId;
  PhotoId := CurrentPhotoId;

  if (ObjId <= 0) or (PhotoId <= 0) then
    Exit;

  if (dmMain.qObjectPhoto.Active) and (not dmMain.qObjectPhoto.IsEmpty) and
     (dmMain.qObjectPhoto.FindField('phIsMain') <> nil) and
     (dmMain.qObjectPhoto.FieldByName('phIsMain').AsInteger <> 0) then
    Exit;

  try
    dmMain.SetMainObjectPhoto(ObjId, PhotoId);
    chkMain.Checked := False;
    RefreshMainPhoto;
    RefreshPhotoControls;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmObjectCard.RefreshDetailButtons;
var
  CanEdit: Boolean;
  HasObject: Boolean;
  HasChar: Boolean;
  HasUtil: Boolean;
  HasMat: Boolean;
begin
  CanEdit := CanEditObject;
  HasObject := CurrentObjectId > 0;

  HasChar := (dmMain <> nil) and dmMain.qObjectChar.Active and (not dmMain.qObjectChar.IsEmpty);
  HasUtil := (dmMain <> nil) and dmMain.qObjectUtility.Active and (not dmMain.qObjectUtility.IsEmpty);
  HasMat := (dmMain <> nil) and dmMain.qObjectMaterial.Active and (not dmMain.qObjectMaterial.IsEmpty);

  btnAddChar.Enabled := CanEdit and HasObject;
  btnEditChar.Enabled := CanEdit and HasChar;
  btnDeleteChar.Enabled := CanEdit and HasChar;

  btnAddUtil.Enabled := CanEdit and HasObject;
  btnEditUtil.Enabled := CanEdit and HasUtil;
  btnDeleteUtil.Enabled := CanEdit and HasUtil;

  btnAddMat.Enabled := CanEdit and HasObject;
  btnEditMat.Enabled := CanEdit and HasMat;
  btnDeleteMat.Enabled := CanEdit and HasMat;
end;

function TfrmObjectCard.BuildLookupList(ADataSet: TDataSet; const AIdField,
  ANameField: string; const AExtraField: string): string;
var
  SL: TStringList;
  Line: string;
begin
  Result := '';
  if (ADataSet = nil) or (not ADataSet.Active) or ADataSet.IsEmpty then
    Exit;

  SL := TStringList.Create;
  try
    ADataSet.DisableControls;
    try
      ADataSet.First;
      while not ADataSet.Eof do
      begin
        Line := ADataSet.FieldByName(AIdField).AsString + ' - ' +
                ADataSet.FieldByName(ANameField).AsString;

        if (AExtraField <> '') and (ADataSet.FindField(AExtraField) <> nil) and
           (not ADataSet.FieldByName(AExtraField).IsNull) and
           (Trim(ADataSet.FieldByName(AExtraField).AsString) <> '') then
          Line := Line + ' [' + ADataSet.FieldByName(AExtraField).AsString + ']';

        SL.Add(Line);
        ADataSet.Next;
      end;
    finally
      ADataSet.EnableControls;
    end;
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

function TfrmObjectCard.PromptTypeId(const ACaption, APrompt,
  AListText: string; out ATypeId: Integer): Boolean;
var
  S: string;
begin
  Result := False;
  ATypeId := 0;

  if Trim(AListText) <> '' then
    ShowMessage(AListText);

  S := '';
  if not InputQuery(ACaption, APrompt, S) then
    Exit;

  S := Trim(S);
  if (S = '') or (not TryStrToInt(S, ATypeId)) or (ATypeId <= 0) then
    raise Exception.Create('Неверно указан ID.');

  Result := True;
end;

function TfrmObjectCard.PromptCharacteristicValue(const ATypeName,
  AValueType: string; const ACurrentNum, ACurrentText,
  ACurrentBool: Variant; out ANum, AText, ABool: Variant): Boolean;
var
  S: string;
  D: Double;
begin
  Result := False;
  ANum := Null;
  AText := Null;
  ABool := Null;

  if SameText(Trim(AValueType), 'NUM') then
  begin
    S := '';
    if not VarIsNull(ACurrentNum) then
      S := VarToStr(ACurrentNum);

    if not InputQuery('Характеристика', ATypeName + sLineBreak +
      'Введите числовое значение:', S) then
      Exit;

    if Trim(S) = '' then
      ANum := Null
    else
    begin
      if not TryTextToFloatEx(S, D) then
        raise Exception.Create('Введите корректное число.');
      ANum := D;
    end;
  end
  else if SameText(Trim(AValueType), 'TEXT') then
  begin
    S := '';
    if not VarIsNull(ACurrentText) then
      S := VarToStr(ACurrentText);

    if not InputQuery('Характеристика', ATypeName + sLineBreak +
      'Введите текстовое значение:', S) then
      Exit;

    AText := NullIfEmpty(S);
  end
  else if SameText(Trim(AValueType), 'BOOL') then
  begin
    if VariantIsTrue(ACurrentBool) then
      S := '1'
    else
      S := '0';

    if not InputQuery('Характеристика', ATypeName + sLineBreak +
      'Введите 1/0 или Да/Нет:', S) then
      Exit;

    S := UpperCase(Trim(S));
    if (S = '1') or (S = 'ДА') or (S = 'TRUE') or (S = 'YES') then
      ABool := 1
    else if (S = '0') or (S = 'НЕТ') or (S = 'FALSE') or (S = 'NO') then
      ABool := 0
    else
      raise Exception.Create('Для логического значения используйте 1/0 или Да/Нет.');
  end
  else
    raise Exception.Create('Неизвестный тип значения характеристики: ' + AValueType);

  Result := True;
end;

function TfrmObjectCard.PromptUtilityValue(const ATypeName, AUnit: string;
  const ACurrentAvailable, ACurrentTariff, ACurrentComment: Variant;
  out AAvailable, ATariff, AComment: Variant): Boolean;
var
  SAvail: string;
  STariff: string;
  SComment: string;
  D: Double;
begin
  Result := False;
  AAvailable := 1;
  ATariff := Null;
  AComment := Null;

  if VariantIsTrue(ACurrentAvailable) then
    SAvail := '1'
  else
    SAvail := '0';

  if not VarIsNull(ACurrentTariff) then
    STariff := VarToStr(ACurrentTariff)
  else
    STariff := '';

  if not VarIsNull(ACurrentComment) then
    SComment := VarToStr(ACurrentComment)
  else
    SComment := '';

  if not InputQuery('Коммунальная услуга',
    ATypeName + sLineBreak + 'Подключено? Введите 1/0 или Да/Нет:', SAvail) then
    Exit;

  SAvail := UpperCase(Trim(SAvail));
  if (SAvail = '1') or (SAvail = 'ДА') or (SAvail = 'TRUE') or (SAvail = 'YES') then
    AAvailable := 1
  else if (SAvail = '0') or (SAvail = 'НЕТ') or (SAvail = 'FALSE') or (SAvail = 'NO') then
    AAvailable := 0
  else
    raise Exception.Create('Для признака подключения используйте 1/0 или Да/Нет.');

  if not InputQuery('Коммунальная услуга',
    ATypeName + sLineBreak + 'Тариф (' + AUnit + '). Можно оставить пустым:', STariff) then
    Exit;

  if Trim(STariff) = '' then
    ATariff := Null
  else
  begin
    if not TryTextToFloatEx(STariff, D) then
      raise Exception.Create('Введите корректный тариф.');
    ATariff := D;
  end;

  if not InputQuery('Коммунальная услуга',
    ATypeName + sLineBreak + 'Комментарий. Можно оставить пустым:', SComment) then
    Exit;

  AComment := NullIfEmpty(SComment);
  Result := True;
end;

function TfrmObjectCard.PromptMaterialValue(const ATypeName: string;
  const ACurrentNote: Variant; out ANote: Variant): Boolean;
var
  S: string;
begin
  if not VarIsNull(ACurrentNote) then
    S := VarToStr(ACurrentNote)
  else
    S := '';

  Result := InputQuery('Материал',
    ATypeName + sLineBreak + 'Примечание (например: Стены, Кровля). Можно оставить пустым:', S);

  if Result then
    ANote := NullIfEmpty(S);
end;

procedure TfrmObjectCard.SaveObjectCharacteristic(const ATypeId: Integer;
  const ANum, AText, ABool: Variant);
var
  Q: TADOQuery;
  ObjId: Integer;
begin
  ObjId := CurrentObjectId;
  if ObjId <= 0 then
    raise Exception.Create('Сначала сохраните объект.');

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := dmMain.conMain;
    Q.SQL.Text :=
      'INSERT INTO object_characteristic ' +
      '  (ocObjectID, ocTypeID, ocValueNum, ocValueText, ocValueBool) ' +
      'VALUES ' +
      '  (:pObjectID, :pTypeID, :pNum, :pText, :pBool) ' +
      'ON DUPLICATE KEY UPDATE ' +
      '  ocValueNum = VALUES(ocValueNum), ' +
      '  ocValueText = VALUES(ocValueText), ' +
      '  ocValueBool = VALUES(ocValueBool)';

    PrepareQueryParams(Q);
    EnsureQueryParam(Q, 'pObjectID', ftInteger);
    EnsureQueryParam(Q, 'pTypeID', ftInteger);
    EnsureQueryParam(Q, 'pNum', ftFloat);
    EnsureQueryParam(Q, 'pText', ftWideString, 255);
    EnsureQueryParam(Q, 'pBool', ftSmallint);

    Q.Parameters.ParamByName('pObjectID').Value := ObjId;
    Q.Parameters.ParamByName('pTypeID').Value := ATypeId;
    Q.Parameters.ParamByName('pNum').Value := ANum;
    Q.Parameters.ParamByName('pText').Value := AText;
    Q.Parameters.ParamByName('pBool').Value := ABool;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TfrmObjectCard.DeleteObjectCharacteristic(const ATypeId: Integer);
var
  Q: TADOQuery;
  ObjId: Integer;
begin
  ObjId := CurrentObjectId;
  if ObjId <= 0 then
    Exit;

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := dmMain.conMain;
    Q.SQL.Text :=
      'DELETE FROM object_characteristic ' +
      'WHERE ocObjectID = :pObjectID AND ocTypeID = :pTypeID';

    PrepareQueryParams(Q);
    EnsureQueryParam(Q, 'pObjectID', ftInteger);
    EnsureQueryParam(Q, 'pTypeID', ftInteger);

    Q.Parameters.ParamByName('pObjectID').Value := ObjId;
    Q.Parameters.ParamByName('pTypeID').Value := ATypeId;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TfrmObjectCard.SaveObjectUtility(const ATypeId: Integer;
  const AAvailable, ATariff, AComment: Variant);
var
  Q: TADOQuery;
  ObjId: Integer;
begin
  ObjId := CurrentObjectId;
  if ObjId <= 0 then
    raise Exception.Create('Сначала сохраните объект.');

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := dmMain.conMain;
    Q.SQL.Text :=
      'INSERT INTO object_utility ' +
      '  (ouObjectID, ouTypeID, ouAvailable, ouTariff, ouComment) ' +
      'VALUES ' +
      '  (:pObjectID, :pTypeID, :pAvailable, :pTariff, :pComment) ' +
      'ON DUPLICATE KEY UPDATE ' +
      '  ouAvailable = VALUES(ouAvailable), ' +
      '  ouTariff = VALUES(ouTariff), ' +
      '  ouComment = VALUES(ouComment)';

    PrepareQueryParams(Q);
    EnsureQueryParam(Q, 'pObjectID', ftInteger);
    EnsureQueryParam(Q, 'pTypeID', ftInteger);
    EnsureQueryParam(Q, 'pAvailable', ftSmallint);
    EnsureQueryParam(Q, 'pTariff', ftFloat);
    EnsureQueryParam(Q, 'pComment', ftWideString, 255);

    Q.Parameters.ParamByName('pObjectID').Value := ObjId;
    Q.Parameters.ParamByName('pTypeID').Value := ATypeId;
    Q.Parameters.ParamByName('pAvailable').Value := AAvailable;
    Q.Parameters.ParamByName('pTariff').Value := ATariff;
    Q.Parameters.ParamByName('pComment').Value := AComment;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TfrmObjectCard.DeleteObjectUtility(const ATypeId: Integer);
var
  Q: TADOQuery;
  ObjId: Integer;
begin
  ObjId := CurrentObjectId;
  if ObjId <= 0 then
    Exit;

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := dmMain.conMain;
    Q.SQL.Text :=
      'DELETE FROM object_utility ' +
      'WHERE ouObjectID = :pObjectID AND ouTypeID = :pTypeID';

    PrepareQueryParams(Q);
    EnsureQueryParam(Q, 'pObjectID', ftInteger);
    EnsureQueryParam(Q, 'pTypeID', ftInteger);

    Q.Parameters.ParamByName('pObjectID').Value := ObjId;
    Q.Parameters.ParamByName('pTypeID').Value := ATypeId;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TfrmObjectCard.SaveObjectMaterial(const ATypeId: Integer;
  const ANote: Variant);
var
  Q: TADOQuery;
  ObjId: Integer;
begin
  ObjId := CurrentObjectId;
  if ObjId <= 0 then
    raise Exception.Create('Сначала сохраните объект.');

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := dmMain.conMain;
    Q.SQL.Text :=
      'INSERT INTO object_material ' +
      '  (omObjectID, omTypeID, omNote) ' +
      'VALUES ' +
      '  (:pObjectID, :pTypeID, :pNote) ' +
      'ON DUPLICATE KEY UPDATE ' +
      '  omNote = VALUES(omNote)';

    PrepareQueryParams(Q);
    EnsureQueryParam(Q, 'pObjectID', ftInteger);
    EnsureQueryParam(Q, 'pTypeID', ftInteger);
    EnsureQueryParam(Q, 'pNote', ftWideString, 255);

    Q.Parameters.ParamByName('pObjectID').Value := ObjId;
    Q.Parameters.ParamByName('pTypeID').Value := ATypeId;
    Q.Parameters.ParamByName('pNote').Value := ANote;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TfrmObjectCard.DeleteObjectMaterial(const ATypeId: Integer);
var
  Q: TADOQuery;
  ObjId: Integer;
begin
  ObjId := CurrentObjectId;
  if ObjId <= 0 then
    Exit;

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := dmMain.conMain;
    Q.SQL.Text :=
      'DELETE FROM object_material ' +
      'WHERE omObjectID = :pObjectID AND omTypeID = :pTypeID';

    PrepareQueryParams(Q);
    EnsureQueryParam(Q, 'pObjectID', ftInteger);
    EnsureQueryParam(Q, 'pTypeID', ftInteger);

    Q.Parameters.ParamByName('pObjectID').Value := ObjId;
    Q.Parameters.ParamByName('pTypeID').Value := ATypeId;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TfrmObjectCard.btnAddCharClick(Sender: TObject);
var
  TypeId: Integer;
  VNum, VText, VBool: Variant;
  TypeName, ValueType: string;
begin
  if not CanEditObject then Exit;
  if CurrentObjectId <= 0 then
    raise Exception.Create('Сначала сохраните карточку объекта.');

  if not dmMain.qCharacteristicType.Active then
    dmMain.qCharacteristicType.Open;

  if not PromptTypeId(
      'Добавление характеристики',
      'Введите ID характеристики из списка.',
      BuildLookupList(dmMain.qCharacteristicType, 'IDct', 'ctName', 'ctValueType'),
      TypeId) then
    Exit;

  if not dmMain.qCharacteristicType.Locate('IDct', TypeId, []) then
    raise Exception.Create('Характеристика с таким ID не найдена.');

  TypeName := dmMain.qCharacteristicType.FieldByName('ctName').AsString;
  ValueType := dmMain.qCharacteristicType.FieldByName('ctValueType').AsString;

  if not PromptCharacteristicValue(TypeName, ValueType, Null, Null, Null, VNum, VText, VBool) then
    Exit;

  SaveObjectCharacteristic(TypeId, VNum, VText, VBool);
  OpenDetailsFor(CurrentObjectId);
  RefreshDetailButtons;
end;

procedure TfrmObjectCard.btnEditCharClick(Sender: TObject);
var
  TypeId: Integer;
  VNum, VText, VBool: Variant;
  TypeName, ValueType: string;
begin
  if not CanEditObject then Exit;
  if (dmMain = nil) or (not dmMain.qObjectChar.Active) or dmMain.qObjectChar.IsEmpty then Exit;

  TypeId := dmMain.qObjectChar.FieldByName('IDct').AsInteger;
  TypeName := dmMain.qObjectChar.FieldByName('ctName').AsString;
  ValueType := dmMain.qObjectChar.FieldByName('ctValueType').AsString;

  if not PromptCharacteristicValue(
      TypeName,
      ValueType,
      dmMain.qObjectChar.FieldByName('ocValueNum').Value,
      dmMain.qObjectChar.FieldByName('ocValueText').Value,
      dmMain.qObjectChar.FieldByName('ocValueBool').Value,
      VNum, VText, VBool) then
    Exit;

  SaveObjectCharacteristic(TypeId, VNum, VText, VBool);
  OpenDetailsFor(CurrentObjectId);
  RefreshDetailButtons;
end;

procedure TfrmObjectCard.btnDeleteCharClick(Sender: TObject);
var
  TypeId: Integer;
  TypeName: string;
begin
  if not CanEditObject then Exit;
  if (dmMain = nil) or (not dmMain.qObjectChar.Active) or dmMain.qObjectChar.IsEmpty then Exit;

  TypeId := dmMain.qObjectChar.FieldByName('IDct').AsInteger;
  TypeName := dmMain.qObjectChar.FieldByName('ctName').AsString;

  if MessageDlg('Удалить характеристику "' + TypeName + '"?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  DeleteObjectCharacteristic(TypeId);
  OpenDetailsFor(CurrentObjectId);
  RefreshDetailButtons;
end;

procedure TfrmObjectCard.btnAddUtilClick(Sender: TObject);
var
  TypeId: Integer;
  VAvailable, VTariff, VComment: Variant;
  TypeName, UnitName: string;
begin
  if not CanEditObject then Exit;
  if CurrentObjectId <= 0 then
    raise Exception.Create('Сначала сохраните карточку объекта.');

  if not dmMain.qUtilityType.Active then
    dmMain.qUtilityType.Open;

  if not PromptTypeId(
      'Добавление услуги',
      'Введите ID услуги из списка.',
      BuildLookupList(dmMain.qUtilityType, 'IDut', 'utName', 'utName'),
      TypeId) then
    Exit;

  if not dmMain.qUtilityType.Locate('IDut', TypeId, []) then
    raise Exception.Create('Услуга с таким ID не найдена.');

  TypeName := dmMain.qUtilityType.FieldByName('utName').AsString;
  if dmMain.qUtilityType.FindField('utUnit') <> nil then
    UnitName := dmMain.qUtilityType.FieldByName('utUnit').AsString
  else
    UnitName := '';

  if not PromptUtilityValue(TypeName, UnitName, 1, Null, Null, VAvailable, VTariff, VComment) then
    Exit;

  SaveObjectUtility(TypeId, VAvailable, VTariff, VComment);
  OpenDetailsFor(CurrentObjectId);
  RefreshDetailButtons;
end;

procedure TfrmObjectCard.btnEditUtilClick(Sender: TObject);
var
  TypeId: Integer;
  VAvailable, VTariff, VComment: Variant;
  TypeName, UnitName: string;
begin
  if not CanEditObject then Exit;
  if (dmMain = nil) or (not dmMain.qObjectUtility.Active) or dmMain.qObjectUtility.IsEmpty then Exit;

  TypeId := dmMain.qObjectUtility.FieldByName('IDut').AsInteger;
  TypeName := dmMain.qObjectUtility.FieldByName('utName').AsString;
  if dmMain.qObjectUtility.FindField('utUnit') <> nil then
    UnitName := dmMain.qObjectUtility.FieldByName('utUnit').AsString
  else
    UnitName := '';

  if not PromptUtilityValue(
      TypeName, UnitName,
      dmMain.qObjectUtility.FieldByName('ouAvailable').Value,
      dmMain.qObjectUtility.FieldByName('ouTariff').Value,
      dmMain.qObjectUtility.FieldByName('ouComment').Value,
      VAvailable, VTariff, VComment) then
    Exit;

  SaveObjectUtility(TypeId, VAvailable, VTariff, VComment);
  OpenDetailsFor(CurrentObjectId);
  RefreshDetailButtons;
end;

procedure TfrmObjectCard.btnDeleteUtilClick(Sender: TObject);
var
  TypeId: Integer;
  TypeName: string;
begin
  if not CanEditObject then Exit;
  if (dmMain = nil) or (not dmMain.qObjectUtility.Active) or dmMain.qObjectUtility.IsEmpty then Exit;

  TypeId := dmMain.qObjectUtility.FieldByName('IDut').AsInteger;
  TypeName := dmMain.qObjectUtility.FieldByName('utName').AsString;

  if MessageDlg('Удалить услугу "' + TypeName + '"?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  DeleteObjectUtility(TypeId);
  OpenDetailsFor(CurrentObjectId);
  RefreshDetailButtons;
end;

procedure TfrmObjectCard.btnAddMatClick(Sender: TObject);
var
  TypeId: Integer;
  VNote: Variant;
  TypeName: string;
begin
  if not CanEditObject then Exit;
  if CurrentObjectId <= 0 then
    raise Exception.Create('Сначала сохраните карточку объекта.');

  if not dmMain.qMaterialType.Active then
    dmMain.qMaterialType.Open;

  if not PromptTypeId(
      'Добавление материала',
      'Введите ID материала из списка.',
      BuildLookupList(dmMain.qMaterialType, 'IDmt', 'mtName'),
      TypeId) then
    Exit;

  if not dmMain.qMaterialType.Locate('IDmt', TypeId, []) then
    raise Exception.Create('Материал с таким ID не найден.');

  TypeName := dmMain.qMaterialType.FieldByName('mtName').AsString;

  if not PromptMaterialValue(TypeName, Null, VNote) then
    Exit;

  SaveObjectMaterial(TypeId, VNote);
  OpenDetailsFor(CurrentObjectId);
  RefreshDetailButtons;
end;

procedure TfrmObjectCard.btnEditMatClick(Sender: TObject);
var
  TypeId: Integer;
  VNote: Variant;
  TypeName: string;
begin
  if not CanEditObject then Exit;
  if (dmMain = nil) or (not dmMain.qObjectMaterial.Active) or dmMain.qObjectMaterial.IsEmpty then Exit;

  TypeId := dmMain.qObjectMaterial.FieldByName('IDmt').AsInteger;
  TypeName := dmMain.qObjectMaterial.FieldByName('mtName').AsString;

  if not PromptMaterialValue(
      TypeName,
      dmMain.qObjectMaterial.FieldByName('omNote').Value,
      VNote) then
    Exit;

  SaveObjectMaterial(TypeId, VNote);
  OpenDetailsFor(CurrentObjectId);
  RefreshDetailButtons;
end;

procedure TfrmObjectCard.btnDeleteMatClick(Sender: TObject);
var
  TypeId: Integer;
  TypeName: string;
begin
  if not CanEditObject then Exit;
  if (dmMain = nil) or (not dmMain.qObjectMaterial.Active) or dmMain.qObjectMaterial.IsEmpty then Exit;

  TypeId := dmMain.qObjectMaterial.FieldByName('IDmt').AsInteger;
  TypeName := dmMain.qObjectMaterial.FieldByName('mtName').AsString;

  if MessageDlg('Удалить материал "' + TypeName + '"?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  DeleteObjectMaterial(TypeId);
  OpenDetailsFor(CurrentObjectId);
  RefreshDetailButtons;
end;

end.