unit frmMainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls,
  dmMainUnit, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    sbMain: TStatusBar;

    miDirectories: TMenuItem;
    miDirUtilityType: TMenuItem;
    miDirCharacteristicType: TMenuItem;
    miDirMaterialType: TMenuItem;
    miDirSnt: TMenuItem;

    miEmployees: TMenuItem;

    miObjects: TMenuItem;
    miObjList: TMenuItem;
    miObjCard: TMenuItem;

    miSales: TMenuItem;
    miClients: TMenuItem;
    miContracts: TMenuItem;

    miReports: TMenuItem;
    miRepObjectList: TMenuItem;
    miRepContractList: TMenuItem;
    miRepObjGroup: TMenuItem;
    miRepContractPeriod: TMenuItem;
    miRepObjCharMD: TMenuItem;

    miCharts: TMenuItem;
    miChartSales: TMenuItem;
    miChartStatuses: TMenuItem;
    miChartAvgPriceLoc: TMenuItem;
    miChartSalesDyn: TMenuItem;

    miAdmin: TMenuItem;
    miLogout: TMenuItem;
    miExit: TMenuItem;

    miHelp: TMenuItem;
    miAbout: TMenuItem;
    miGlobalSearch: TMenuItem;

    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure miExitClick(Sender: TObject);
    procedure miLogoutClick(Sender: TObject);

    procedure miObjListClick(Sender: TObject);
    procedure miObjCardClick(Sender: TObject);

    procedure miClientsClick(Sender: TObject);
    procedure miContractsClick(Sender: TObject);

    procedure miDirCharacteristicTypeClick(Sender: TObject);
    procedure miDirUtilityTypeClick(Sender: TObject);
    procedure miDirMaterialTypeClick(Sender: TObject);
    procedure miDirSntClick(Sender: TObject);
    
    procedure miEmployeesClick(Sender: TObject);

    procedure miAboutClick(Sender: TObject);
    procedure miGlobalSearchClick(Sender: TObject);

    procedure miRepObjectListClick(Sender: TObject);
    procedure miRepContractListClick(Sender: TObject);
    procedure miRepObjGroupClick(Sender: TObject);
    procedure miRepContractPeriodClick(Sender: TObject);
    procedure miRepObjCharMDClick(Sender: TObject);

    procedure miChartSalesClick(Sender: TObject);
    procedure miChartStatusesClick(Sender: TObject);
    procedure miChartAvgPriceLocClick(Sender: TObject);
    procedure miChartSalesDynClick(Sender: TObject);
  private
    procedure ApplyRolePolicy;
    function RoleToText(R: TKairosUserRole): string;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  frmLoginUnit,
  frmObjectsUnit,
  frmObjectCardUnit,
  frmClientsUnit,
  frmContractsUnit,
  frmDirCharacteristicTypeUnit,
  frmDirUtilityTypeUnit,
  frmDirMaterialTypeUnit,
  frmDirSntUnit,
  frmEmployeesUnit,
  frmGlobalSearchUnit,
  frmRepObjectListUnit,
  frmRepContractListUnit,
  frmRepObjGroupUnit,
  frmRepContractPeriodUnit,
  frmRepObjCharMDUnit,
  frmChartSalesMonthUnit,
  frmChartStatusStructureUnit,
  frmChartAvgPriceSntUnit,
  frmChartSalesDynUnit;

function TfrmMain.RoleToText(R: TKairosUserRole): string;
begin
  case R of
    urObjectAdmin: Result := 'Администратор объектов';
    urRealtor:     Result := 'Риелтор';
  else
    Result := 'Не определена';
  end;
end;

procedure TfrmMain.ApplyRolePolicy;
var
  IsObjAdmin, IsRealtor: Boolean;
begin
  IsObjAdmin := dmMain.Role = urObjectAdmin;
  IsRealtor  := dmMain.Role = urRealtor;

  miObjects.Enabled := IsObjAdmin or IsRealtor;
  miObjList.Enabled := IsObjAdmin or IsRealtor;
  miObjCard.Enabled := IsObjAdmin or IsRealtor;

  miDirectories.Enabled := IsObjAdmin or IsRealtor;
  miDirUtilityType.Enabled := IsObjAdmin;
  miDirCharacteristicType.Enabled := IsObjAdmin;
  miDirMaterialType.Enabled := IsObjAdmin;
  miDirSnt.Enabled := IsObjAdmin;
  miEmployees.Enabled := IsObjAdmin or IsRealtor;

  miSales.Enabled := IsObjAdmin or IsRealtor;
  miClients.Enabled := IsRealtor;
  miContracts.Enabled := IsRealtor;

  miReports.Enabled := IsObjAdmin or IsRealtor;
  miRepObjectList.Enabled := IsObjAdmin or IsRealtor;
  miRepContractList.Enabled := IsRealtor;
  miRepObjGroup.Enabled := IsObjAdmin or IsRealtor;
  miRepContractPeriod.Enabled := IsObjAdmin or IsRealtor;
  miRepObjCharMD.Enabled := IsObjAdmin or IsRealtor;

  miCharts.Enabled := IsObjAdmin or IsRealtor;
  miChartSales.Enabled := IsObjAdmin or IsRealtor;
  miChartStatuses.Enabled := IsObjAdmin or IsRealtor;
  miChartAvgPriceLoc.Enabled := IsObjAdmin or IsRealtor;
  miChartSalesDyn.Enabled := IsObjAdmin or IsRealtor;

  sbMain.SimpleText := Format('Пользователь: %s | Роль: %s', [dmMain.LoginUser, RoleToText(dmMain.Role)]);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  sbMain.SimplePanel := True;
  ApplyRolePolicy;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dmMain.Disconnect;

  Action := caFree;
  frmMain := nil;
  Application.Terminate;
end;

procedure TfrmMain.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miLogoutClick(Sender: TObject);
var
  I: Integer;
  LoginForm: TfrmLogin;
begin
  for I := Screen.FormCount - 1 downto 0 do
    if Screen.Forms[I] <> Self then
      Screen.Forms[I].Close;

  dmMain.Disconnect;

  Hide;

  LoginForm := TfrmLogin.Create(nil);
  try
    if LoginForm.ShowModal = mrOk then
    begin
      ApplyRolePolicy;
      Show;
      BringToFront;
    end
    else
      Application.Terminate;
  finally
    LoginForm.Free;
  end;
end;

procedure TfrmMain.miObjListClick(Sender: TObject);
begin
  if frmObjects = nil then
    frmObjects := TfrmObjects.Create(Application);
  frmObjects.Show;
end;

procedure TfrmMain.miObjCardClick(Sender: TObject);
begin
  if not dmMain.qObjectList.Active then
    dmMain.qObjectList.Open;

  if dmMain.qObjectList.IsEmpty then Exit;

  if frmObjectCard = nil then
    frmObjectCard := TfrmObjectCard.Create(Application);

  frmObjectCard.OpenForMode('EDIT', dmMain.qObjectList.FieldByName('IDob').AsInteger);
  frmObjectCard.ShowModal;

  dmMain.qObjectList.Requery;
end;

procedure TfrmMain.miClientsClick(Sender: TObject);
begin
  if frmClients = nil then
    frmClients := TfrmClients.Create(Application);
  frmClients.Show;
end;

procedure TfrmMain.miContractsClick(Sender: TObject);
begin
  if frmContracts = nil then
    frmContracts := TfrmContracts.Create(Application);
  frmContracts.Show;
end;

procedure TfrmMain.miDirCharacteristicTypeClick(Sender: TObject);
begin
  if frmDirCharacteristicType = nil then
    frmDirCharacteristicType := TfrmDirCharacteristicType.Create(Application);
  frmDirCharacteristicType.Show;
end;

procedure TfrmMain.miDirUtilityTypeClick(Sender: TObject);
begin
  if frmDirUtilityType = nil then
    frmDirUtilityType := TfrmDirUtilityType.Create(Application);
  frmDirUtilityType.Show;
end;

procedure TfrmMain.miDirMaterialTypeClick(Sender: TObject);
begin
  if frmDirMaterialType = nil then
    frmDirMaterialType := TfrmDirMaterialType.Create(Application);
  frmDirMaterialType.Show;
end;

procedure TfrmMain.miDirSntClick(Sender: TObject);
begin
  if frmDirSnt = nil then
    frmDirSnt := TfrmDirSnt.Create(Application);
  frmDirSnt.Show;
end;

procedure TfrmMain.miGlobalSearchClick(Sender: TObject);
begin
  if frmGlobalSearch = nil then
    frmGlobalSearch := TfrmGlobalSearch.Create(Application);
  frmGlobalSearch.Show;
end;

procedure TfrmMain.miRepObjectListClick(Sender: TObject);
begin
  if frmRepObjectList = nil then
    frmRepObjectList := TfrmRepObjectList.Create(Application);
  frmRepObjectList.Show;
end;

procedure TfrmMain.miRepContractListClick(Sender: TObject);
begin
  if frmRepContractList = nil then
    frmRepContractList := TfrmRepContractList.Create(Application);
  frmRepContractList.Show;
end;

procedure TfrmMain.miRepObjGroupClick(Sender: TObject);
begin
  if frmRepObjGroup = nil then
    frmRepObjGroup := TfrmRepObjGroup.Create(Application);
  frmRepObjGroup.Show;
end;

procedure TfrmMain.miRepContractPeriodClick(Sender: TObject);
begin
  if frmRepContractPeriod = nil then
    frmRepContractPeriod := TfrmRepContractPeriod.Create(Application);
  frmRepContractPeriod.Show;
end;

procedure TfrmMain.miRepObjCharMDClick(Sender: TObject);
begin
  if frmRepObjCharMD = nil then
    frmRepObjCharMD := TfrmRepObjCharMD.Create(Application);
  frmRepObjCharMD.Show;
end;

procedure TfrmMain.miChartSalesClick(Sender: TObject);
begin
  if frmChartSalesMonth = nil then
    frmChartSalesMonth := TfrmChartSalesMonth.Create(Application);
  frmChartSalesMonth.Show;
end;

procedure TfrmMain.miChartStatusesClick(Sender: TObject);
begin
  if frmChartStatusStructure = nil then
    frmChartStatusStructure := TfrmChartStatusStructure.Create(Application);
  frmChartStatusStructure.Show;
end;

procedure TfrmMain.miChartAvgPriceLocClick(Sender: TObject);
begin
  if frmChartAvgPriceSnt = nil then
    frmChartAvgPriceSnt := TfrmChartAvgPriceSnt.Create(Application);
  frmChartAvgPriceSnt.Show;
end;

procedure TfrmMain.miChartSalesDynClick(Sender: TObject);
begin
  if frmChartSalesDyn = nil then
    frmChartSalesDyn := TfrmChartSalesDyn.Create(Application);
  frmChartSalesDyn.Show;
end;

procedure TfrmMain.miEmployeesClick(Sender: TObject);
begin
  if frmEmployees = nil then
    frmEmployees := TfrmEmployees.Create(Application);
  frmEmployees.Show;
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  MessageDlg(
    'Kairos Home - продажи недвижимости' + sLineBreak + sLineBreak +
    'Учебная информационная система для сопровождения продаж объектов недвижимости.' + sLineBreak +
    'Версия: 1.0' + sLineBreak +
    'Пользователь: ' + dmMain.LoginUser + sLineBreak +
    'Роль: ' + RoleToText(dmMain.Role),
    mtInformation, [mbOK], 0
  );
end;

end.

