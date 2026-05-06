unit frmClientsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, dmMainUnit;

type
  TfrmClients = class(TForm)
    pTop: TPanel;
    btnInsert: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    btnCard: TButton;
    grdClients: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCardClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure grdClientsDblClick(Sender: TObject);
    procedure grdClientsTitleClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function CurrentClientId: Integer;
    procedure OpenCard(const AMode: string); // INS / EDIT
    procedure ConfigureClientGrid;
  end;

var
  frmClients: TfrmClients;

implementation

{$R *.dfm}

uses
  frmClientCardUnit, uDBGridSortUnit;

procedure TfrmClients.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmClients := nil;
end;

procedure TfrmClients.ConfigureClientGrid;
begin
  if not dmMain.qClient.Active then Exit;

  if dmMain.qClient.FindField('IDcl') <> nil then
    dmMain.qClient.FieldByName('IDcl').Visible := False;

  if dmMain.qClient.FindField('clFIO') <> nil then
    dmMain.qClient.FieldByName('clFIO').DisplayLabel := 'ФИО клиента';
  if dmMain.qClient.FindField('clPhone') <> nil then
    dmMain.qClient.FieldByName('clPhone').DisplayLabel := 'Телефон';
  if dmMain.qClient.FindField('clEmail') <> nil then
    dmMain.qClient.FieldByName('clEmail').DisplayLabel := 'Эл. почта';
  if dmMain.qClient.FindField('clPassport') <> nil then
    dmMain.qClient.FieldByName('clPassport').DisplayLabel := 'Паспорт';
  if dmMain.qClient.FindField('clAddress') <> nil then
    dmMain.qClient.FieldByName('clAddress').DisplayLabel := 'Адрес';
  if dmMain.qClient.FindField('clNote') <> nil then
    dmMain.qClient.FieldByName('clNote').DisplayLabel := 'Примечание';
end;

procedure TfrmClients.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  if not dmMain.qClient.Active then
    dmMain.qClient.Open;
  ConfigureClientGrid;
end;

function TfrmClients.CurrentClientId: Integer;
begin
  Result := 0;
  if dmMain.qClient.Active and (not dmMain.qClient.IsEmpty) then
    Result := dmMain.qClient.FieldByName('IDcl').AsInteger;
end;

procedure TfrmClients.btnRefreshClick(Sender: TObject);
begin
  if dmMain.qClient.Active then
    dmMain.qClient.Requery
  else
    dmMain.qClient.Open;
  ConfigureClientGrid;
end;

procedure TfrmClients.OpenCard(const AMode: string);
begin
  if frmClientCard = nil then
    frmClientCard := TfrmClientCard.Create(Application);

  frmClientCard.OpenForMode(AMode, CurrentClientId);
  frmClientCard.ShowModal;

  if dmMain.qClient.Active then dmMain.qClient.Requery;
end;

procedure TfrmClients.btnInsertClick(Sender: TObject);
begin
  OpenCard('INS');
end;

procedure TfrmClients.btnEditClick(Sender: TObject);
begin
  if CurrentClientId = 0 then Exit;
  OpenCard('EDIT');
end;

procedure TfrmClients.btnCardClick(Sender: TObject);
begin
  btnEditClick(nil);
end;

procedure TfrmClients.grdClientsDblClick(Sender: TObject);
begin
  btnEditClick(nil);
end;

procedure TfrmClients.btnDeleteClick(Sender: TObject);
var
  ID: Integer;
begin
  ID := CurrentClientId;
  if ID = 0 then Exit;

  if MessageDlg('Удалить клиента (ID=' + IntToStr(ID) + ')?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  dmMain.qExec.SQL.Text := 'DELETE FROM client WHERE IDcl = :pID';
  dmMain.qExec.Parameters.ParamByName('pID').Value := ID;
  dmMain.qExec.ExecSQL;

  dmMain.qClient.Requery;
  ConfigureClientGrid;
end;

procedure TfrmClients.grdClientsTitleClick(Column: TColumn);
begin
  DBGridTitleClickSort(grdClients, Column);
end;

end.

