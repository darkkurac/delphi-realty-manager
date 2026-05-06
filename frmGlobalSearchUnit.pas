unit frmGlobalSearchUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB, dmMainUnit;

type
  TfrmGlobalSearch = class(TForm)
    pTop: TPanel;
    edSearch: TEdit;
    btnSearch: TButton;
    btnClear: TButton;
    grdResult: TDBGrid;

    procedure FormShow(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure edSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdResultDblClick(Sender: TObject);
  private
    procedure Bind;
    procedure ConfigureResultGrid;
    procedure EntityTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure SubtitleGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  public
  end;

var
  frmGlobalSearch: TfrmGlobalSearch;

implementation

{$R *.dfm}

procedure TfrmGlobalSearch.Bind;
begin
  grdResult.DataSource := dmMain.dsGlobalSearch;
end;

procedure TfrmGlobalSearch.ConfigureResultGrid;
begin
  if not dmMain.qGlobalSearch.Active then Exit;

  if dmMain.qGlobalSearch.FindField('entityId') <> nil then
    dmMain.qGlobalSearch.FieldByName('entityId').Visible := False;
  if dmMain.qGlobalSearch.FindField('searchText') <> nil then
    dmMain.qGlobalSearch.FieldByName('searchText').Visible := False;

  if dmMain.qGlobalSearch.FindField('entityType') <> nil then
    dmMain.qGlobalSearch.FieldByName('entityType').DisplayLabel := 'Раздел';
  if dmMain.qGlobalSearch.FindField('title') <> nil then
    dmMain.qGlobalSearch.FieldByName('title').DisplayLabel := 'Наименование';
  if dmMain.qGlobalSearch.FindField('subtitle') <> nil then
    dmMain.qGlobalSearch.FieldByName('subtitle').DisplayLabel := 'Описание';
  if dmMain.qGlobalSearch.FindField('entityType') <> nil then
  begin
    dmMain.qGlobalSearch.FieldByName('entityType').DisplayLabel := 'Раздел';
    dmMain.qGlobalSearch.FieldByName('entityType').OnGetText := EntityTypeGetText;
  end;

  if dmMain.qGlobalSearch.FindField('title') <> nil then
    dmMain.qGlobalSearch.FieldByName('title').DisplayLabel := 'Наименование';

  if dmMain.qGlobalSearch.FindField('subtitle') <> nil then
  begin
    dmMain.qGlobalSearch.FieldByName('subtitle').DisplayLabel := 'Описание';
    dmMain.qGlobalSearch.FieldByName('subtitle').OnGetText := SubtitleGetText;
  end;
end;

procedure TfrmGlobalSearch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmGlobalSearch := nil;
end;

procedure TfrmGlobalSearch.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  Bind;
  dmMain.PrepareGlobalSearchParams;
  dmMain.ResetGlobalSearch;
  ConfigureResultGrid;
  ActiveControl := edSearch;
end;

procedure TfrmGlobalSearch.grdResultDblClick(Sender: TObject);
begin
  // намеренно пусто (без добавления новых пользовательских сценариев)
end;

procedure TfrmGlobalSearch.btnSearchClick(Sender: TObject);
begin
  dmMain.ApplyGlobalSearch(edSearch.Text);
  ConfigureResultGrid;
end;

procedure TfrmGlobalSearch.btnClearClick(Sender: TObject);
begin
  edSearch.Clear;
  dmMain.ResetGlobalSearch;
  ConfigureResultGrid;
  edSearch.SetFocus;
end;

procedure TfrmGlobalSearch.edSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    btnSearchClick(nil);
  end;

  if Key = VK_ESCAPE then
  begin
    Key := 0;
    btnClearClick(nil);
  end;
end;

function EntityTypeDbToRu(const AValue: string): string;
begin
  if SameText(AValue, 'OBJECT') then
    Result := 'Объект'
  else if SameText(AValue, 'CONTRACT') then
    Result := 'Договор'
  else if SameText(AValue, 'CLIENT') then
    Result := 'Клиент'
  else if SameText(AValue, 'EMPLOYEE') then
    Result := 'Сотрудник'
  else if SameText(AValue, 'SETTLEMENT') then
    Result := 'СНТ/посёлок'
  else if SameText(AValue, 'PLACE') then
    Result := 'Участок/адрес'
  else if SameText(AValue, 'MATERIAL_TYPE') then
    Result := 'Материал'
  else if SameText(AValue, 'UTILITY_TYPE') then
    Result := 'Коммунальная услуга'
  else if SameText(AValue, 'CHAR_TYPE') then
    Result := 'Характеристика'
  else
    Result := AValue;
end;

function ReplaceContractStatusesToRu(const AValue: string): string;
begin
  Result := AValue;
  Result := StringReplace(Result, 'Active', 'Активен', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, 'Closed', 'Закрыт', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, 'Canceled', 'Отменен', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TfrmGlobalSearch.EntityTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := EntityTypeDbToRu(Sender.AsString);
end;

procedure TfrmGlobalSearch.SubtitleGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := ReplaceContractStatusesToRu(Sender.AsString);
end;

end.