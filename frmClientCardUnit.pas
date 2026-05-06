unit frmClientCardUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.Mask, Data.DB, dmMainUnit;

type
  TfrmClientCard = class(TForm)
    pButtons: TPanel;
    btnPost: TButton;
    btnCancel: TButton;

    lblFIO: TLabel;
    lblPhone: TLabel;
    lblEmail: TLabel;
    lblPassport: TLabel;
    lblAddress: TLabel;
    lblNote: TLabel;

    edFIO: TDBEdit;
    edPhone: TDBEdit;
    edEmail: TDBEdit;
    edPassport: TDBEdit;
    edAddress: TDBEdit;
    edNote: TDBEdit;

    procedure btnCancelClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FMode: string;
    FClientId: Integer;
    procedure StartInsert;
    procedure StartEdit(const AClientId: Integer);
  public
    procedure OpenForMode(const AMode: string; const AClientId: Integer);
  end;

var
  frmClientCard: TfrmClientCard;

implementation

{$R *.dfm}

procedure TfrmClientCard.StartInsert;
begin
  dmMain.qClientEdit.Close;
  dmMain.qClientEdit.Open;
  dmMain.qClientEdit.Append;
end;

procedure TfrmClientCard.StartEdit(const AClientId: Integer);
begin
  dmMain.qClientEdit.Close;
  dmMain.qClientEdit.Open;

  if not dmMain.qClientEdit.Locate('IDcl', AClientId, []) then
    raise Exception.Create('Клиент не найден (ID=' + IntToStr(AClientId) + ').');

  dmMain.qClientEdit.Edit;
end;

procedure TfrmClientCard.OpenForMode(const AMode: string; const AClientId: Integer);
begin
  FMode := UpperCase(Trim(AMode));
  FClientId := AClientId;

  edFIO.DataSource := dmMain.dsClientEdit;
  edFIO.DataField := 'clFIO';

  edPhone.DataSource := dmMain.dsClientEdit;
  edPhone.DataField := 'clPhone';

  edEmail.DataSource := dmMain.dsClientEdit;
  edEmail.DataField := 'clEmail';

  edPassport.DataSource := dmMain.dsClientEdit;
  edPassport.DataField := 'clPassport';

  edAddress.DataSource := dmMain.dsClientEdit;
  edAddress.DataField := 'clAddress';

  edNote.DataSource := dmMain.dsClientEdit;
  edNote.DataField := 'clNote';

  if FMode = 'INS' then
    StartInsert
  else
    StartEdit(FClientId);
end;

procedure TfrmClientCard.btnPostClick(Sender: TObject);
begin
  if dmMain.qClientEdit.State in [dsInsert, dsEdit] then
    dmMain.qClientEdit.Post;
  ModalResult := mrOk;
end;

procedure TfrmClientCard.btnCancelClick(Sender: TObject);
begin
  if dmMain.qClientEdit.State in [dsInsert, dsEdit] then
    dmMain.qClientEdit.Cancel;
  ModalResult := mrCancel;
end;

procedure TfrmClientCard.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
  if dmMain.qClientEdit.State in [dsInsert, dsEdit] then
  begin
    case MessageDlg('Сохранить изменения клиента?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes: btnPostClick(nil);
      mrNo:  dmMain.qClientEdit.Cancel;
      mrCancel: CanClose := False;
    end;
  end;
end;

end.