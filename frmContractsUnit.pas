unit frmContractsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, Data.Win.ADODB, dmMainUnit, Vcl.ComCtrls;

type
  TfrmContracts = class(TForm)
    pTop: TPanel;
    btnInsert: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    btnCard: TButton;
    btnCloseContract: TButton;
    btnCancelContract: TButton;
    grdContracts: TDBGrid;
    pFilter: TPanel;
    dtFrom: TDateTimePicker;
    dtTo: TDateTimePicker;
    chkUseFrom: TCheckBox;
    chkUseTo: TCheckBox;
    cbConStatus: TComboBox;
    btnApplyFilter: TButton;
    btnClearFilter: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCardClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCloseContractClick(Sender: TObject);
    procedure btnCancelContractClick(Sender: TObject);
    procedure grdContractsDblClick(Sender: TObject);
    procedure btnApplyFilterClick(Sender: TObject);
    procedure btnClearFilterClick(Sender: TObject);
    procedure grdContractsTitleClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function CurrentContractId: Integer;
    function CurrentObjectId: Integer;
    function FindContractStatusId(const AStatusCode: string): Integer;
    procedure OpenCard(const AMode: string);
    procedure SetContractStatus(const ANewStatus: string);
    procedure ConfigureContractGrid;
    procedure RefreshContractData;
    procedure ContractStatusGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

var
  frmContracts: TfrmContracts;

implementation

{$R *.dfm}

uses
  frmContractCardUnit, uDBGridSortUnit;

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

function ContractStatusRuToDb(const AValue: string): string;
begin
  if SameText(AValue, 'Активен') then
    Result := 'Active'
  else if SameText(AValue, 'Закрыт') then
    Result := 'Closed'
  else if SameText(AValue, 'Отменен') or SameText(AValue, 'Отменён') then
    Result := 'Canceled'
  else
    Result := AValue;
end;

procedure TfrmContracts.ContractStatusGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := ContractStatusDbToRu(Sender.AsString);
end;

procedure TfrmContracts.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmContracts := nil;
end;

procedure TfrmContracts.ConfigureContractGrid;
begin
  if not dmMain.qContractList.Active then Exit;

  if dmMain.qContractList.FindField('IDcon') <> nil then
    dmMain.qContractList.FieldByName('IDcon').Visible := False;
  if dmMain.qContractList.FindField('IDcl') <> nil then
    dmMain.qContractList.FieldByName('IDcl').Visible := False;
  if dmMain.qContractList.FindField('IDemp') <> nil then
    dmMain.qContractList.FieldByName('IDemp').Visible := False;
  if dmMain.qContractList.FindField('IDob') <> nil then
    dmMain.qContractList.FieldByName('IDob').Visible := False;
  if dmMain.qContractList.FindField('conStatusCode') <> nil then
    dmMain.qContractList.FieldByName('conStatusCode').Visible := False;
  if dmMain.qContractList.FindField('clPhone') <> nil then
    dmMain.qContractList.FieldByName('clPhone').Visible := False;
  if dmMain.qContractList.FindField('clEmail') <> nil then
    dmMain.qContractList.FieldByName('clEmail').Visible := False;
  if dmMain.qContractList.FindField('empPhone') <> nil then
    dmMain.qContractList.FieldByName('empPhone').Visible := False;
  if dmMain.qContractList.FindField('empEmail') <> nil then
    dmMain.qContractList.FieldByName('empEmail').Visible := False;

  if dmMain.qContractList.FindField('conNumber') <> nil then
    dmMain.qContractList.FieldByName('conNumber').DisplayLabel := 'Номер договора';
  if dmMain.qContractList.FindField('conDate') <> nil then
    dmMain.qContractList.FieldByName('conDate').DisplayLabel := 'Дата';
  if dmMain.qContractList.FindField('conStatus') <> nil then
  begin
    dmMain.qContractList.FieldByName('conStatus').DisplayLabel := 'Статус';
    dmMain.qContractList.FieldByName('conStatus').OnGetText := ContractStatusGetText;
  end;
  if dmMain.qContractList.FindField('conSum') <> nil then
    dmMain.qContractList.FieldByName('conSum').DisplayLabel := 'Сумма';
  if dmMain.qContractList.FindField('conPrepay') <> nil then
    dmMain.qContractList.FieldByName('conPrepay').DisplayLabel := 'Предоплата';
  if dmMain.qContractList.FindField('conDebt') <> nil then
    dmMain.qContractList.FieldByName('conDebt').DisplayLabel := 'Долг';
  if dmMain.qContractList.FindField('conComment') <> nil then
    dmMain.qContractList.FieldByName('conComment').DisplayLabel := 'Комментарий';
  if dmMain.qContractList.FindField('clFIO') <> nil then
    dmMain.qContractList.FieldByName('clFIO').DisplayLabel := 'Клиент';
  if dmMain.qContractList.FindField('empFIO') <> nil then
    dmMain.qContractList.FieldByName('empFIO').DisplayLabel := 'Сотрудник';
  if dmMain.qContractList.FindField('obCode') <> nil then
    dmMain.qContractList.FieldByName('obCode').DisplayLabel := 'Код объекта';
  if dmMain.qContractList.FindField('obName') <> nil then
    dmMain.qContractList.FieldByName('obName').DisplayLabel := 'Объект';
  if dmMain.qContractList.FindField('osName') <> nil then
    dmMain.qContractList.FieldByName('osName').DisplayLabel := 'Статус объекта';
  if dmMain.qContractList.FindField('snsName') <> nil then
    dmMain.qContractList.FieldByName('snsName').DisplayLabel := 'СНТ';
  if dmMain.qContractList.FindField('spStreet') <> nil then
    dmMain.qContractList.FieldByName('spStreet').DisplayLabel := 'Улица';
  if dmMain.qContractList.FindField('spPlotNo') <> nil then
    dmMain.qContractList.FieldByName('spPlotNo').DisplayLabel := 'Участок';
end;

procedure TfrmContracts.RefreshContractData;
begin
  if dmMain.qContractList.Active then
    dmMain.qContractList.Requery
  else
    dmMain.qContractList.Open;

  if dmMain.qRepContractList.Active then
    dmMain.qRepContractList.Requery;

  if dmMain.qRepContractPeriod.Active then
    dmMain.qRepContractPeriod.Requery;

  if dmMain.qChartSalesMonth.Active then
    dmMain.qChartSalesMonth.Requery;

  if dmMain.qChartSalesDyn.Active then
    dmMain.qChartSalesDyn.Requery;

  ConfigureContractGrid;
end;

function TfrmContracts.FindContractStatusId(const AStatusCode: string): Integer;
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

procedure TfrmContracts.FormShow(Sender: TObject);
var
  Q: TADOQuery;
begin
  OnClose := FormClose;

  grdContracts.DataSource := dmMain.dsContractList;

  cbConStatus.Items.Clear;

  if (dmMain <> nil) and dmMain.conMain.Connected then
  begin
    Q := TADOQuery.Create(nil);
    try
      Q.Connection := dmMain.conMain;
      Q.SQL.Text := 'SELECT csName FROM contract_status ORDER BY IDcs';
      Q.Open;
      while not Q.Eof do
      begin
        cbConStatus.Items.Add(ContractStatusDbToRu(Q.Fields[0].AsString));
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  end;

  if cbConStatus.Items.Count = 0 then
  begin
    cbConStatus.Items.Add('Активен');
    cbConStatus.Items.Add('Закрыт');
    cbConStatus.Items.Add('Отменен');
  end;

  chkUseFrom.Checked := False;
  chkUseTo.Checked := False;
  dtFrom.Date := Date;
  dtTo.Date := Date;
  cbConStatus.Text := '';

  dmMain.ResetContractListFilter;
  ConfigureContractGrid;
end;

function TfrmContracts.CurrentContractId: Integer;
begin
  Result := 0;
  if dmMain.qContractList.Active and (not dmMain.qContractList.IsEmpty) then
    Result := dmMain.qContractList.FieldByName('IDcon').AsInteger;
end;

function TfrmContracts.CurrentObjectId: Integer;
begin
  Result := 0;
  if dmMain.qContractList.Active and (not dmMain.qContractList.IsEmpty) then
    Result := dmMain.qContractList.FieldByName('IDob').AsInteger;
end;

procedure TfrmContracts.btnRefreshClick(Sender: TObject);
begin
  RefreshContractData;
end;

procedure TfrmContracts.OpenCard(const AMode: string);
begin
  if frmContractCard = nil then
    frmContractCard := TfrmContractCard.Create(Application);

  frmContractCard.OpenForMode(AMode, CurrentContractId);
  frmContractCard.ShowModal;

  RefreshContractData;
end;

procedure TfrmContracts.btnInsertClick(Sender: TObject);
begin
  OpenCard('INS');
end;

procedure TfrmContracts.btnEditClick(Sender: TObject);
begin
  if CurrentContractId = 0 then Exit;
  OpenCard('EDIT');
end;

procedure TfrmContracts.btnCardClick(Sender: TObject);
begin
  btnEditClick(nil);
end;

procedure TfrmContracts.grdContractsDblClick(Sender: TObject);
begin
  btnEditClick(nil);
end;

procedure TfrmContracts.btnDeleteClick(Sender: TObject);
var
  ID: Integer;
  ObjID: Integer;
begin
  ID := CurrentContractId;
  if ID = 0 then Exit;

  ObjID := CurrentObjectId;

  if MessageDlg('Удалить договор (ID=' + IntToStr(ID) + ')?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  dmMain.conMain.BeginTrans;
  try
    dmMain.qExec.Close;
    dmMain.qExec.SQL.Text := 'DELETE FROM contract WHERE IDcon = :pID';
    dmMain.qExec.Parameters.ParamByName('pID').Value := ID;
    dmMain.qExec.ExecSQL;

    if ObjID <> 0 then
      dmMain.RecalcObjectStatus(ObjID);

    dmMain.conMain.CommitTrans;
  except
    on E: Exception do
    begin
      dmMain.conMain.RollbackTrans;
      MessageDlg(
        'Операция не выполнена.' + sLineBreak +
        'Причина: ' + E.Message,
        mtError, [mbOK], 0
      );
      Exit;
    end;
  end;

  RefreshContractData;
end;

procedure TfrmContracts.SetContractStatus(const ANewStatus: string);
var
  ID: Integer;
  ObjID: Integer;
  StatusID: Integer;
begin
  ID := CurrentContractId;
  if ID = 0 then Exit;

  ObjID := CurrentObjectId;
  StatusID := FindContractStatusId(ANewStatus);
  if StatusID = 0 then
  begin
    MessageDlg(
      'Не найден статус договора: ' + ANewStatus,
      mtError, [mbOK], 0
    );
    Exit;
  end;

  dmMain.conMain.BeginTrans;
  try
    dmMain.qExec.Close;
    dmMain.qExec.SQL.Text :=
      'UPDATE contract ' +
      'SET conStatusID = :pStatusID ' +
      'WHERE IDcon = :pID';

    dmMain.qExec.Parameters.ParamByName('pStatusID').Value := StatusID;
    dmMain.qExec.Parameters.ParamByName('pID').Value := ID;
    dmMain.qExec.ExecSQL;

    if ObjID <> 0 then
      dmMain.RecalcObjectStatus(ObjID);

    dmMain.conMain.CommitTrans;
  except
    on E: Exception do
    begin
      dmMain.conMain.RollbackTrans;
      MessageDlg(
        'Операция не выполнена.' + sLineBreak +
        'Причина: ' + E.Message,
        mtError, [mbOK], 0
      );
      Exit;
    end;
  end;

  RefreshContractData;
end;

procedure TfrmContracts.btnClearFilterClick(Sender: TObject);
begin
  chkUseFrom.Checked := False;
  chkUseTo.Checked := False;
  cbConStatus.ItemIndex := -1;
  dmMain.ResetContractListFilter;
  ConfigureContractGrid;
end;

procedure TfrmContracts.btnCloseContractClick(Sender: TObject);
begin
  if MessageDlg('Закрыть договор? Объект станет "Продан".',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  SetContractStatus('Closed');
end;

procedure TfrmContracts.btnApplyFilterClick(Sender: TObject);
var
  VFrom, VTo, VStatus: Variant;
begin
  if chkUseFrom.Checked then
    VFrom := dtFrom.Date
  else
    VFrom := Null;

  if chkUseTo.Checked then
    VTo := dtTo.Date
  else
    VTo := Null;

  if (cbConStatus.ItemIndex >= 0) and (Trim(cbConStatus.Text) <> '') then
    VStatus := ContractStatusRuToDb(cbConStatus.Text)
  else
    VStatus := Null;

  dmMain.ApplyContractListFilter(VStatus, VFrom, VTo);
  ConfigureContractGrid;
end;

procedure TfrmContracts.btnCancelContractClick(Sender: TObject);
begin
  if MessageDlg('Отменить договор? Объект может стать "Свободен".',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  SetContractStatus('Canceled');
end;

procedure TfrmContracts.grdContractsTitleClick(Column: TColumn);
begin
  DBGridTitleClickSort(grdContracts, Column);
end;

end.