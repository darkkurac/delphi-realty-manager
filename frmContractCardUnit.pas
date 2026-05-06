unit frmContractCardUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.Mask, Data.DB, Data.Win.ADODB, dmMainUnit;

type
  TfrmContractCard = class(TForm)
    pButtons: TPanel;
    btnPost: TButton;
    btnCancel: TButton;

    lblNumber: TLabel;
    lblDate: TLabel;
    lblClient: TLabel;
    lblEmployee: TLabel;
    lblObject: TLabel;
    lblSum: TLabel;
    lblPrepay: TLabel;
    lblStatus: TLabel;
    lblComment: TLabel;

    edNumber: TDBEdit;
    edDate: TDBEdit;
    cbClient: TDBLookupComboBox;
    cbEmployee: TDBLookupComboBox;
    cbObject: TDBLookupComboBox;
    edSum: TDBEdit;
    edPrepay: TDBEdit;
    cbStatus: TComboBox;
    edComment: TDBEdit;

    procedure btnCancelClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FMode: string;
    FContractId: Integer;
    FOriginalObjectID: Integer;
    procedure StartInsert;
    procedure StartEdit(const AContractId: Integer);
    function FindContractStatusId(const AStatusCode: string): Integer;
    function SelectedStatusId: Integer;
    procedure SelectStatusById(const AStatusID: Integer);
    procedure ValidateBeforePost;
  public
    procedure OpenForMode(const AMode: string; const AContractId: Integer);
  end;

var
  frmContractCard: TfrmContractCard;

implementation

{$R *.dfm}

function ContractStatusDbToRu(const AValue: string): string;
begin
  if SameText(AValue, 'Active') then
    Result := 'Активен'
  else if SameText(AValue, 'Closed') then
    Result := 'Закрыт'
  else if SameText(AValue, 'Canceled') then
    Result := 'Отменен'
  else
    Result := AValue;
end;

function TfrmContractCard.FindContractStatusId(const AStatusCode: string): Integer;
var
  Q: TADOQuery;
begin
  Result := 0;

  if (dmMain = nil) or (not dmMain.conMain.Connected) then
    Exit;

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := dmMain.conMain;
    Q.SQL.Text :=
      'SELECT IDcs ' +
      'FROM contract_status ' +
      'WHERE csName = :pStatusCode ' +
      'LIMIT 1';
    Q.Parameters.ParamByName('pStatusCode').Value := AStatusCode;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('IDcs').AsInteger;
  finally
    Q.Free;
  end;
end;

function TfrmContractCard.SelectedStatusId: Integer;
begin
  Result := 0;
  if cbStatus.ItemIndex >= 0 then
    Result := NativeInt(cbStatus.Items.Objects[cbStatus.ItemIndex]);
end;

procedure TfrmContractCard.SelectStatusById(const AStatusID: Integer);
var
  I: Integer;
begin
  cbStatus.ItemIndex := -1;
  for I := 0 to cbStatus.Items.Count - 1 do
    if NativeInt(cbStatus.Items.Objects[I]) = AStatusID then
    begin
      cbStatus.ItemIndex := I;
      Exit;
    end;
end;

procedure TfrmContractCard.ValidateBeforePost;
begin
  if Trim(edNumber.Text) = '' then
    raise Exception.Create('Не заполнен номер договора.');

  if VarIsNull(cbClient.KeyValue) then
    raise Exception.Create('Не выбран клиент.');

  if VarIsNull(cbEmployee.KeyValue) then
    raise Exception.Create('Не выбран сотрудник.');

  if VarIsNull(cbObject.KeyValue) then
    raise Exception.Create('Не выбран объект.');

  if SelectedStatusId <= 0 then
    raise Exception.Create('Не выбран статус договора.');
end;

procedure TfrmContractCard.FormShow(Sender: TObject);
var
  Q: TADOQuery;
begin
  cbStatus.Items.Clear;

  if (dmMain <> nil) and dmMain.conMain.Connected then
  begin
    Q := TADOQuery.Create(nil);
    try
      Q.Connection := dmMain.conMain;
      Q.SQL.Text := 'SELECT IDcs, csName FROM contract_status ORDER BY IDcs';
      Q.Open;
      while not Q.Eof do
      begin
        cbStatus.Items.AddObject(
          ContractStatusDbToRu(Q.FieldByName('csName').AsString),
          TObject(NativeInt(Q.FieldByName('IDcs').AsInteger))
        );
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  end;

  if cbStatus.Items.Count = 0 then
  begin
    cbStatus.Items.AddObject('Активен', TObject(NativeInt(1)));
    cbStatus.Items.AddObject('Закрыт', TObject(NativeInt(2)));
    cbStatus.Items.AddObject('Отменен', TObject(NativeInt(3)));
  end;
end;

procedure TfrmContractCard.StartInsert;
var
  StatusID: Integer;
begin
  FOriginalObjectID := 0;

  dmMain.qContractEdit.Close;
  dmMain.qContractEdit.SQL.Text := 'SELECT * FROM contract LIMIT 0';
  dmMain.qContractEdit.Parameters.Clear;
  dmMain.qContractEdit.Open;
  dmMain.qContractEdit.Append;

  dmMain.qContractEdit.FieldByName('conDate').AsDateTime := Date;

  StatusID := FindContractStatusId('Active');
  if StatusID <= 0 then
    StatusID := 1;

  if dmMain.qContractEdit.FindField('conStatusID') <> nil then
    dmMain.qContractEdit.FieldByName('conStatusID').AsInteger := StatusID;

  SelectStatusById(StatusID);
end;

procedure TfrmContractCard.StartEdit(const AContractId: Integer);
var
  StatusID: Integer;
begin
  dmMain.qContractEdit.Close;
  dmMain.qContractEdit.SQL.Text :=
    'SELECT * FROM contract WHERE IDcon = :pID LIMIT 1';
  dmMain.qContractEdit.Parameters.Clear;
  dmMain.qContractEdit.Parameters.CreateParameter('pID', ftInteger, pdInput, 0, AContractId);
  dmMain.qContractEdit.Open;

  if dmMain.qContractEdit.IsEmpty then
    raise Exception.Create('Договор не найден (ID=' + IntToStr(AContractId) + ').');

  if dmMain.qContractEdit.FindField('conObjectID') <> nil then
    FOriginalObjectID := dmMain.qContractEdit.FieldByName('conObjectID').AsInteger
  else
    FOriginalObjectID := 0;

  if dmMain.qContractEdit.FindField('conStatusID') <> nil then
    StatusID := dmMain.qContractEdit.FieldByName('conStatusID').AsInteger
  else
    StatusID := 0;

  SelectStatusById(StatusID);
  dmMain.qContractEdit.Edit;
end;

procedure TfrmContractCard.OpenForMode(const AMode: string; const AContractId: Integer);
begin
  FMode := UpperCase(Trim(AMode));
  FContractId := AContractId;
  FOriginalObjectID := 0;

  edNumber.DataSource := dmMain.dsContractEdit;
  edNumber.DataField := 'conNumber';

  edDate.DataSource := dmMain.dsContractEdit;
  edDate.DataField := 'conDate';

  edSum.DataSource := dmMain.dsContractEdit;
  edSum.DataField := 'conSum';

  edPrepay.DataSource := dmMain.dsContractEdit;
  edPrepay.DataField := 'conPrepay';

  edComment.DataSource := dmMain.dsContractEdit;
  edComment.DataField := 'conComment';

  cbClient.DataSource := dmMain.dsContractEdit;
  cbClient.DataField := 'conClientID';
  cbClient.ListSource := dmMain.dsClient;
  cbClient.KeyField := 'IDcl';
  cbClient.ListField := 'clFIO';

  cbEmployee.DataSource := dmMain.dsContractEdit;
  cbEmployee.DataField := 'conEmployeeID';
  cbEmployee.ListSource := dmMain.dsEmployee;
  cbEmployee.KeyField := 'IDemp';
  cbEmployee.ListField := 'empFIO';

  cbObject.DataSource := dmMain.dsContractEdit;
  cbObject.DataField := 'conObjectID';
  cbObject.ListSource := dmMain.dsObjectPick;
  cbObject.KeyField := 'IDob';
  cbObject.ListField := 'obDisplay';

  if FMode = 'INS' then
    StartInsert
  else
    StartEdit(FContractId);
end;

procedure TfrmContractCard.btnPostClick(Sender: TObject);
var
  NewObjectID: Integer;
  StatusID: Integer;
begin
  if not (dmMain.qContractEdit.State in [dsInsert, dsEdit]) then
  begin
    ModalResult := mrOk;
    Exit;
  end;

  ValidateBeforePost;

  StatusID := SelectedStatusId;
  dmMain.qContractEdit.FieldByName('conStatusID').AsInteger := StatusID;
  NewObjectID := dmMain.qContractEdit.FieldByName('conObjectID').AsInteger;

  dmMain.qContractEdit.Post;

  try
    if (FOriginalObjectID > 0) and (FOriginalObjectID <> NewObjectID) then
      dmMain.RecalcObjectStatus(FOriginalObjectID);

    if NewObjectID > 0 then
      dmMain.RecalcObjectStatus(NewObjectID);
  except
    on E: Exception do
      MessageDlg(
        'Договор сохранён, но пересчёт статуса объекта не выполнен.' + sLineBreak +
        'Причина: ' + E.Message,
        mtWarning, [mbOK], 0
      );
  end;

  FOriginalObjectID := NewObjectID;
  ModalResult := mrOk;
end;

procedure TfrmContractCard.btnCancelClick(Sender: TObject);
begin
  if dmMain.qContractEdit.State in [dsInsert, dsEdit] then
    dmMain.qContractEdit.Cancel;
  ModalResult := mrCancel;
end;

procedure TfrmContractCard.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
  if dmMain.qContractEdit.State in [dsInsert, dsEdit] then
  begin
    case MessageDlg('Сохранить изменения договора?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes: btnPostClick(nil);
      mrNo: dmMain.qContractEdit.Cancel;
      mrCancel: CanClose := False;
    end;
  end;
end;

end.