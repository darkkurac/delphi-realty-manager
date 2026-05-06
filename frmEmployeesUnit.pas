unit frmEmployeesUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, dmMainUnit;

type
  TfrmEmployees = class(TForm)
    pTop: TPanel;
    btnInsert: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    btnCard: TButton;
    grdEmployees: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCardClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure grdEmployeesDblClick(Sender: TObject);
    procedure grdEmployeesTitleClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function CurrentEmployeeId: Integer;
    procedure OpenCard(const AMode: string); // INS / EDIT
    procedure ConfigureEmployeeGrid;
    procedure RefreshEmployeeData;
  end;

var
  frmEmployees: TfrmEmployees;

implementation

{$R *.dfm}

uses
  frmEmployeeCardUnit, uDBGridSortUnit;

procedure TfrmEmployees.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmEmployees := nil;
end;

procedure TfrmEmployees.ConfigureEmployeeGrid;
begin
  if not dmMain.qEmployeeDir.Active then Exit;

  if dmMain.qEmployeeDir.FindField('IDemp') <> nil then
    dmMain.qEmployeeDir.FieldByName('IDemp').Visible := False;

  if dmMain.qEmployeeDir.FindField('empFIO') <> nil then
    dmMain.qEmployeeDir.FieldByName('empFIO').DisplayLabel := 'ФИО';

  if dmMain.qEmployeeDir.FindField('empPhone') <> nil then
    dmMain.qEmployeeDir.FieldByName('empPhone').DisplayLabel := 'Телефон';

  if dmMain.qEmployeeDir.FindField('empEmail') <> nil then
    dmMain.qEmployeeDir.FieldByName('empEmail').DisplayLabel := 'E-mail';

  if dmMain.qEmployeeDir.FindField('empPositionID') <> nil then
    dmMain.qEmployeeDir.FieldByName('empPositionID').DisplayLabel := 'Код должности';

  if dmMain.qEmployeeDir.FindField('empIsActive') <> nil then
    dmMain.qEmployeeDir.FieldByName('empIsActive').DisplayLabel := 'Активен';
end;

procedure TfrmEmployees.RefreshEmployeeData;
begin
  if dmMain.qEmployeeDir.Active then
    dmMain.qEmployeeDir.Close;
  dmMain.qEmployeeDir.Open;
  ConfigureEmployeeGrid;
end;

procedure TfrmEmployees.FormShow(Sender: TObject);
begin
  grdEmployees.DataSource := dmMain.dsEmployeeDir;
  RefreshEmployeeData;
end;

function TfrmEmployees.CurrentEmployeeId: Integer;
begin
  Result := 0;
  if dmMain.qEmployeeDir.Active and (not dmMain.qEmployeeDir.IsEmpty) then
    Result := dmMain.qEmployeeDir.FieldByName('IDemp').AsInteger;
end;

procedure TfrmEmployees.OpenCard(const AMode: string);
begin
  if frmEmployeeCard = nil then
    frmEmployeeCard := TfrmEmployeeCard.Create(Application);

  frmEmployeeCard.OpenEmployee(AMode, CurrentEmployeeId);
  RefreshEmployeeData;
end;

procedure TfrmEmployees.btnRefreshClick(Sender: TObject);
begin
  RefreshEmployeeData;
end;

procedure TfrmEmployees.btnInsertClick(Sender: TObject);
begin
  OpenCard('INS');
end;

procedure TfrmEmployees.btnEditClick(Sender: TObject);
begin
  if CurrentEmployeeId <= 0 then Exit;
  OpenCard('EDIT');
end;

procedure TfrmEmployees.btnCardClick(Sender: TObject);
begin
  if CurrentEmployeeId <= 0 then Exit;
  OpenCard('EDIT');
end;

procedure TfrmEmployees.btnDeleteClick(Sender: TObject);
begin
  if CurrentEmployeeId <= 0 then Exit;

  if MessageDlg('Удалить выбранного сотрудника?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    dmMain.qEmployeeDir.Delete;
    RefreshEmployeeData;
  except
    on E: Exception do
      MessageDlg(
        'Не удалось удалить сотрудника.' + sLineBreak +
        'Возможно, он используется в договорах.' + sLineBreak + sLineBreak +
        E.Message,
        mtError, [mbOK], 0
      );
  end;
end;

procedure TfrmEmployees.grdEmployeesDblClick(Sender: TObject);
begin
  if CurrentEmployeeId <= 0 then Exit;
  OpenCard('EDIT');
end;

procedure TfrmEmployees.grdEmployeesTitleClick(Column: TColumn);
begin
  DBGridTitleClickSort(grdEmployees, Column);
  ConfigureEmployeeGrid;
end;

end.
