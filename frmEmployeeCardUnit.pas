unit frmEmployeeCardUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.DBCtrls, Data.DB, dmMainUnit, Vcl.Mask;

type
  TfrmEmployeeCard = class(TForm)
    lblFIO: TLabel;
    lblPhone: TLabel;
    lblEmail: TLabel;
    lblPosition: TLabel;
    edtFIO: TDBEdit;
    edtPhone: TDBEdit;
    edtEmail: TDBEdit;
    cbPosition: TDBLookupComboBox;
    chkActive: TDBCheckBox;
    pBottom: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FMode: string;
    procedure BindControls;
  public
    procedure OpenEmployee(const AMode: string; const AEmployeeID: Integer);
  end;

var
  frmEmployeeCard: TfrmEmployeeCard;

implementation

{$R *.dfm}

procedure TfrmEmployeeCard.BindControls;
begin
  edtFIO.DataSource := dmMain.dsEmployeeEditOne;
  edtFIO.DataField := 'empFIO';

  edtPhone.DataSource := dmMain.dsEmployeeEditOne;
  edtPhone.DataField := 'empPhone';

  edtEmail.DataSource := dmMain.dsEmployeeEditOne;
  edtEmail.DataField := 'empEmail';

  cbPosition.DataSource := dmMain.dsEmployeeEditOne;
  cbPosition.DataField := 'empPositionID';
  cbPosition.ListSource := dmMain.dsEmployeePositionDir;
  cbPosition.ListField := 'epName';
  cbPosition.KeyField := 'IDep';

  chkActive.DataSource := dmMain.dsEmployeeEditOne;
  chkActive.DataField := 'empIsActive';
  chkActive.ValueChecked := '1';
  chkActive.ValueUnchecked := '0';
end;

procedure TfrmEmployeeCard.OpenEmployee(const AMode: string; const AEmployeeID: Integer);
begin
  FMode := UpperCase(Trim(AMode));

  BindControls;

  if not dmMain.qEmployeePositionDir.Active then
    dmMain.qEmployeePositionDir.Open;

  dmMain.qEmployeeEditOne.Close;

  if FMode = 'INS' then
  begin
    Caption := 'Добавление сотрудника';

    dmMain.qEmployeeEditOne.SQL.Text :=
      'SELECT ' +
      '  IDemp, ' +
      '  empFIO, ' +
      '  empPhone, ' +
      '  empEmail, ' +
      '  empPositionID, ' +
      '  empIsActive ' +
      'FROM employee ' +
      'WHERE 1 = 0';

    dmMain.qEmployeeEditOne.Open;
    dmMain.qEmployeeEditOne.Append;
    dmMain.qEmployeeEditOne.FieldByName('empIsActive').AsInteger := 1;
  end
  else
  begin
    Caption := 'Карточка сотрудника';

    dmMain.qEmployeeEditOne.SQL.Text :=
      'SELECT ' +
      '  IDemp, ' +
      '  empFIO, ' +
      '  empPhone, ' +
      '  empEmail, ' +
      '  empPositionID, ' +
      '  empIsActive ' +
      'FROM employee ' +
      'WHERE IDemp = ' + IntToStr(AEmployeeID) + ' ' +
      'LIMIT 1';

    dmMain.qEmployeeEditOne.Open;

    if dmMain.qEmployeeEditOne.IsEmpty then
      raise Exception.Create('Сотрудник не найден.');

    dmMain.qEmployeeEditOne.Edit;
  end;

  ShowModal;
end;

procedure TfrmEmployeeCard.btnSaveClick(Sender: TObject);
begin
  if Trim(dmMain.qEmployeeEditOne.FieldByName('empFIO').AsString) = '' then
  begin
    MessageDlg('Заполните ФИО сотрудника.', mtWarning, [mbOK], 0);
    Exit;
  end;

  if dmMain.qEmployeeEditOne.FieldByName('empPositionID').IsNull then
  begin
    MessageDlg('Выберите должность.', mtWarning, [mbOK], 0);
    Exit;
  end;

  try
    dmMain.qEmployeeEditOne.Post;

    if dmMain.qEmployeeDir.Active then
      dmMain.qEmployeeDir.Requery;

    ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg('Ошибка сохранения:' + sLineBreak + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmEmployeeCard.btnCancelClick(Sender: TObject);
begin
  if dmMain.qEmployeeEditOne.Active and (dmMain.qEmployeeEditOne.State in dsEditModes) then
    dmMain.qEmployeeEditOne.Cancel;

  ModalResult := mrCancel;
end;

procedure TfrmEmployeeCard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmEmployeeCard := nil;
end;

end.
