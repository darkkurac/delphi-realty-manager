program KairosHome;

uses
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.DBCtrls,
  Vcl.DBGrids,
  frmLoginUnit in 'frmLoginUnit.pas' {frmLogin},
  dmMainUnit in 'dmMainUnit.pas' {dmMain: TDataModule},
  frmMainUnit in 'frmMainUnit.pas' {frmMain},
  frmObjectsUnit in 'frmObjectsUnit.pas' {frmObjects},
  frmObjectCardUnit in 'frmObjectCardUnit.pas' {frmObjectCard},
  frmClientsUnit in 'frmClientsUnit.pas' {frmClients},
  frmClientCardUnit in 'frmClientCardUnit.pas' {frmClientCard},
  frmContractsUnit in 'frmContractsUnit.pas' {frmContracts},
  frmContractCardUnit in 'frmContractCardUnit.pas' {frmContractCard},
  frmDirCharacteristicTypeUnit in 'frmDirCharacteristicTypeUnit.pas' {frmDirCharacteristicType},
  frmDirUtilityTypeUnit in 'frmDirUtilityTypeUnit.pas' {frmDirUtilityType},
  frmDirMaterialTypeUnit in 'frmDirMaterialTypeUnit.pas' {frmDirMaterialType},
  frmDirSntUnit in 'frmDirSntUnit.pas' {frmDirSnt},
  uDBGridSortUnit in 'uDBGridSortUnit.pas',
  frmGlobalSearchUnit in 'frmGlobalSearchUnit.pas' {frmGlobalSearch},
  uReportUtilsUnit in 'uReportUtilsUnit.pas',
  frmRepObjectListUnit in 'frmRepObjectListUnit.pas' {frmRepObjectList},
  frmRepContractListUnit in 'frmRepContractListUnit.pas' {frmRepContractList},
  frmRepObjGroupUnit in 'frmRepObjGroupUnit.pas' {frmRepObjGroup},
  frmRepContractPeriodUnit in 'frmRepContractPeriodUnit.pas' {frmRepContractPeriod},
  frmRepObjCharMDUnit in 'frmRepObjCharMDUnit.pas' {frmRepObjCharMD},
  uChartUtilsUnit in 'uChartUtilsUnit.pas',
  frmChartSalesMonthUnit in 'frmChartSalesMonthUnit.pas' {frmChartSalesMonth},
  frmChartStatusStructureUnit in 'frmChartStatusStructureUnit.pas' {frmChartStatusStructure},
  frmChartAvgPriceSntUnit in 'frmChartAvgPriceSntUnit.pas' {frmChartAvgPriceSnt},
  frmChartSalesDynUnit in 'frmChartSalesDynUnit.pas' {frmChartSalesDyn},
  frmEmployeeCardUnit in 'frmEmployeeCardUnit.pas' {frmEmployeeCard},
  frmEmployeesUnit in 'frmEmployeesUnit.pas' {frmEmployees};

{$R *.res}

var
  LoginRes: Integer;

begin
  RegisterClasses([TLabel, TButton, TEdit, TCheckBox, TPanel, TDBGrid, TDBLookupComboBox]);

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  Application.CreateForm(TdmMain, dmMain);
  frmLogin := TfrmLogin.Create(nil);
  try
    LoginRes := frmLogin.ShowModal;
  finally
    frmLogin.Free;
    frmLogin := nil;
  end;

  if LoginRes <> mrOk then
    Exit;

  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.