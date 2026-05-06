unit frmLoginUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls,
  dmMainUnit, System.Win.Registry;

type
  TfrmLogin = class(TForm)
    lblUser: TLabel;
    edtUser: TEdit;
    lblPass: TLabel;
    edtPass: TEdit;
    lblDsn: TLabel;
    cbDsn: TComboBox;
    btnLogin: TButton;
    btnExit: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure LoadOdbcDsnToCombo(ACombo: TComboBox);
  private
    function BuildConnStrFromDsn(const ADsn, AUser, APass: string): string;
    function IsKairosDsn(const ADsn: string): Boolean;
  public
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

function TfrmLogin.BuildConnStrFromDsn(const ADsn, AUser, APass: string): string;
begin
  Result :=
    'Provider=MSDASQL.1;' +
    'Persist Security Info=False;' +
    'Extended Properties="DSN=' + Trim(ADsn) + ';' +
    'UID=' + Trim(AUser) + ';';

  if APass <> '' then
    Result := Result + 'PWD=' + APass + ';';

  Result := Result + 'CHARSET=utf8mb4;COLUMN_SIZE_S32=1";';
end;

function TfrmLogin.IsKairosDsn(const ADsn: string): Boolean;
var
  S: string;
begin
  S := LowerCase(Trim(ADsn));
  Result := (S <> '') and (Pos('kairos_realty_', S) = 1);
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  edtPass.PasswordChar := '*';

  LoadOdbcDsnToCombo(cbDsn);
  if cbDsn.Items.Count > 0 then
    cbDsn.ItemIndex := 0;
end;

procedure TfrmLogin.btnExitClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  Err: string;
begin
  if cbDsn.ItemIndex < 0 then
  begin
    MessageDlg('Выберите источник данных (DSN).', mtWarning, [mbOK], 0);
    Exit;
  end;

  if not IsKairosDsn(cbDsn.Text) then
  begin
    MessageDlg('Выбран источник данных вне проекта Kairos Home. Выберите kairos_realty_....', mtWarning, [mbOK], 0);
    Exit;
  end;

  if Trim(edtUser.Text) = '' then
  begin
    MessageDlg('Введите имя пользователя.', mtWarning, [mbOK], 0);
    Exit;
  end;

    try
    dmMain.Disconnect;
    dmMain.conMain.ConnectionString :=
      BuildConnStrFromDsn(Trim(cbDsn.Text), Trim(edtUser.Text), edtPass.Text);

    if not dmMain.Connect(Trim(edtUser.Text), edtPass.Text, Err) then
      raise Exception.Create('Ошибка подключения:' + sLineBreak + Err);

    if not dmMain.CheckPrivileges(Err) then
      raise Exception.Create('Права/роль не соответствуют требованиям:' + sLineBreak + Err);

    dmMain.OpenLookups;
    dmMain.OpenMainData;

    ModalResult := mrOk;
  except
    on E: Exception do
    begin
      dmMain.Disconnect;
      MessageDlg(E.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;
end;

procedure TfrmLogin.LoadOdbcDsnToCombo(ACombo: TComboBox);
  procedure LoadFromRoot(Root: HKEY);
  var
    R: TRegistry;
    SL: TStringList;
    I: Integer;
    Name: string;
  begin
    R := TRegistry.Create(KEY_READ);
    SL := TStringList.Create;
    try
      R.RootKey := Root;
      if R.OpenKeyReadOnly('\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources') then
      begin
        R.GetValueNames(SL);
        for I := 0 to SL.Count - 1 do
        begin
          Name := SL[I];
          if IsKairosDsn(Name) then
            if ACombo.Items.IndexOf(Name) < 0 then
              ACombo.Items.Add(Name);
        end;
      end;
    finally
      SL.Free;
      R.Free;
    end;
  end;
begin
  ACombo.Items.BeginUpdate;
  try
    ACombo.Items.Clear;
    LoadFromRoot(HKEY_CURRENT_USER);
    LoadFromRoot(HKEY_LOCAL_MACHINE);
  finally
    ACombo.Items.EndUpdate;
  end;
end;

end.