unit dmMainUnit;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  Data.Win.ADODB, Data.DB,
  Vcl.Graphics, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TKairosUserRole = (urNone, urObjectAdmin, urRealtor);

  TdmMain = class(TDataModule)
    Con_Main: TADOConnection;

    Q_ObjectList: TADOQuery;
    DS_ObjectList: TDataSource;

    Q_ObjectCard: TADOQuery;
    DS_ObjectCard: TDataSource;

    Q_ContractList: TADOQuery;
    DS_ContractList: TDataSource;

    Q_ObjectPhoto: TADOQuery;
    DS_ObjectPhoto: TDataSource;

    Q_ObjectChar: TADOQuery;
    DS_ObjectChar: TDataSource;

    Q_ObjectUtility: TADOQuery;
    DS_ObjectUtility: TDataSource;

    Q_ObjectMaterial: TADOQuery;
    DS_ObjectMaterial: TDataSource;

    Q_Status: TADOQuery;
    DS_Status: TDataSource;

    Q_Settlement: TADOQuery;
    DS_Settlement: TDataSource;

    Q_Place: TADOQuery;
    DS_Place: TDataSource;

    Q_UtilityType: TADOQuery;
    DS_UtilityType: TDataSource;

    Q_CharacteristicType: TADOQuery;
    DS_CharacteristicType: TDataSource;

    Q_MaterialType: TADOQuery;
    DS_MaterialType: TDataSource;

    Q_Employee: TADOQuery;
    DS_Employee: TDataSource;
    
    Q_EmployeeDir: TADOQuery;
    DS_EmployeeDir: TDataSource;

    Q_EmployeeEditOne: TADOQuery;
    DS_EmployeeEditOne: TDataSource;

    Q_EmployeePositionDir: TADOQuery;
    DS_EmployeePositionDir: TDataSource;

    Q_Client: TADOQuery;
    DS_Client: TDataSource;

    Q_ObjectPick: TADOQuery;
    DS_ObjectPick: TDataSource;

    Q_ContractEdit: TADOQuery;
    DS_ContractEdit: TDataSource;

    Q_ClientEdit: TADOQuery;
    DS_ClientEdit: TDataSource;

    Q_ObjectEdit: TADOQuery;
    DS_ObjectEdit: TDataSource;

    Q_UtilityTypeEdit: TADOQuery;
    DS_UtilityTypeEdit: TDataSource;

    Q_CharacteristicTypeEdit: TADOQuery;
    DS_CharacteristicTypeEdit: TDataSource;

    Q_MaterialTypeEdit: TADOQuery;
    DS_MaterialTypeEdit: TDataSource;

    Q_SettlementEdit: TADOQuery;
    DS_SettlementEdit: TDataSource;

    Q_PlaceEdit: TADOQuery;
    DS_PlaceEdit: TDataSource;

    Q_StatusEdit: TADOQuery;
    DS_StatusEdit: TDataSource;

    Q_GlobalSearch: TADOQuery;
    DS_GlobalSearch: TDataSource;

    Q_RepObjectList: TADOQuery;
    DS_RepObjectList: TDataSource;

    Q_RepContractList: TADOQuery;
    DS_RepContractList: TDataSource;

    Q_RepObjGroupSntStatus: TADOQuery;
    DS_RepObjGroupSntStatus: TDataSource;

    Q_RepContractGroupPeriod: TADOQuery;
    DS_RepContractGroupPeriod: TDataSource;

    Q_RepObjMaster: TADOQuery;
    DS_RepObjMaster: TDataSource;

    Q_RepObjCharDetail: TADOQuery;
    DS_RepObjCharDetail: TDataSource;

    Q_ChartSalesMonth: TADOQuery;
    DS_ChartSalesMonth: TDataSource;

    Q_ChartStatusStruct: TADOQuery;
    DS_ChartStatusStruct: TDataSource;

    Q_ChartAvgPriceSnt: TADOQuery;
    DS_ChartAvgPriceSnt: TDataSource;

    Q_ChartSalesDyn: TADOQuery;
    DS_ChartSalesDyn: TDataSource;

    Q_Exec: TADOQuery;

    Cmd_RecalcObjectStatus: TADOCommand;

    procedure DataModuleCreate(Sender: TObject);
    procedure Q_ObjectListAfterScroll(DataSet: TDataSet);
  private
    FLoginUser: string;
    FRole: TKairosUserRole;

    procedure SafeOpen(Q: TADOQuery; const AName: string);
    procedure SafeClose(Q: TADOQuery);

    procedure DetectRoleByUserName(const AUser: string);

    function HasObjects: Boolean;
    function NormalizeContractStatusFilter(const AStatus: Variant): Variant;
    procedure EnsureParam(Q: TADOQuery; const ParamName: string);
    procedure EnsureSqlParam(Q: TADOQuery; const ParamName: string; ADataType: TDataType; const ASize: Integer = 0);
    procedure RefreshObjectDetails;

    function TryGetDataSetFieldInt(ADataSet: TDataSet; const AFieldName: string; out AValue: Integer): Boolean;
    function ResolveCurrentObjectID: Integer;
    function DetectMimeType(const AFileName: string): string;
    procedure RefreshPhotoData(const AObjectID: Integer);
    procedure RequeryActive(Q: TADOQuery);
  public
    property conMain: TADOConnection read Con_Main;

    property qObjectList: TADOQuery read Q_ObjectList;
    property dsObjectList: TDataSource read DS_ObjectList;

    property qObjectCard: TADOQuery read Q_ObjectCard;
    property dsObjectCard: TDataSource read DS_ObjectCard;

    property qContractList: TADOQuery read Q_ContractList;
    property dsContractList: TDataSource read DS_ContractList;

    property qObjectPhoto: TADOQuery read Q_ObjectPhoto;
    property dsObjectPhoto: TDataSource read DS_ObjectPhoto;

    property qObjectChar: TADOQuery read Q_ObjectChar;
    property dsObjectChar: TDataSource read DS_ObjectChar;

    property qObjectUtility: TADOQuery read Q_ObjectUtility;
    property dsObjectUtility: TDataSource read DS_ObjectUtility;

    property qObjectMaterial: TADOQuery read Q_ObjectMaterial;
    property dsObjectMaterial: TDataSource read DS_ObjectMaterial;

    property qStatus: TADOQuery read Q_Status;
    property dsStatus: TDataSource read DS_Status;

    property qSettlement: TADOQuery read Q_Settlement;
    property dsSettlement: TDataSource read DS_Settlement;

    property qPlace: TADOQuery read Q_Place;
    property dsPlace: TDataSource read DS_Place;

    property qUtilityType: TADOQuery read Q_UtilityType;
    property dsUtilityType: TDataSource read DS_UtilityType;

    property qCharacteristicType: TADOQuery read Q_CharacteristicType;
    property dsCharacteristicType: TDataSource read DS_CharacteristicType;

    property qMaterialType: TADOQuery read Q_MaterialType;
    property dsMaterialType: TDataSource read DS_MaterialType;

    property qEmployee: TADOQuery read Q_Employee;
    property dsEmployee: TDataSource read DS_Employee;

    property qEmployeeDir: TADOQuery read Q_EmployeeDir;
    property dsEmployeeDir: TDataSource read DS_EmployeeDir;

    property qEmployeeEditOne: TADOQuery read Q_EmployeeEditOne;
    property dsEmployeeEditOne: TDataSource read DS_EmployeeEditOne;

    property qEmployeePositionDir: TADOQuery read Q_EmployeePositionDir;
    property dsEmployeePositionDir: TDataSource read DS_EmployeePositionDir;

    property qClient: TADOQuery read Q_Client;
    property dsClient: TDataSource read DS_Client;

    property qObjectPick: TADOQuery read Q_ObjectPick;
    property dsObjectPick: TDataSource read DS_ObjectPick;

    property qContractEdit: TADOQuery read Q_ContractEdit;
    property dsContractEdit: TDataSource read DS_ContractEdit;

    property qClientEdit: TADOQuery read Q_ClientEdit;
    property dsClientEdit: TDataSource read DS_ClientEdit;

    property qObjectEdit: TADOQuery read Q_ObjectEdit;
    property dsObjectEdit: TDataSource read DS_ObjectEdit;

    property qUtilityTypeEdit: TADOQuery read Q_UtilityTypeEdit;
    property dsUtilityTypeEdit: TDataSource read DS_UtilityTypeEdit;

    property qCharacteristicTypeEdit: TADOQuery read Q_CharacteristicTypeEdit;
    property dsCharacteristicTypeEdit: TDataSource read DS_CharacteristicTypeEdit;

    property qMaterialTypeEdit: TADOQuery read Q_MaterialTypeEdit;
    property dsMaterialTypeEdit: TDataSource read DS_MaterialTypeEdit;

    property qSettlementEdit: TADOQuery read Q_SettlementEdit;
    property dsSettlementEdit: TDataSource read DS_SettlementEdit;

    property qPlaceEdit: TADOQuery read Q_PlaceEdit;
    property dsPlaceEdit: TDataSource read DS_PlaceEdit;

    property qStatusEdit: TADOQuery read Q_StatusEdit;
    property dsStatusEdit: TDataSource read DS_StatusEdit;

    property qGlobalSearch: TADOQuery read Q_GlobalSearch;
    property dsGlobalSearch: TDataSource read DS_GlobalSearch;

    property qRepObjectList: TADOQuery read Q_RepObjectList;
    property dsRepObjectList: TDataSource read DS_RepObjectList;

    property qRepContractList: TADOQuery read Q_RepContractList;
    property dsRepContractList: TDataSource read DS_RepContractList;

    property qRepObjGroup: TADOQuery read Q_RepObjGroupSntStatus;
    property dsRepObjGroup: TDataSource read DS_RepObjGroupSntStatus;

    property qRepContractPeriod: TADOQuery read Q_RepContractGroupPeriod;
    property dsRepContractPeriod: TDataSource read DS_RepContractGroupPeriod;

    property qRepObjMaster: TADOQuery read Q_RepObjMaster;
    property dsRepObjMaster: TDataSource read DS_RepObjMaster;

    property qRepObjCharDetail: TADOQuery read Q_RepObjCharDetail;
    property dsRepObjCharDetail: TDataSource read DS_RepObjCharDetail;

    property qChartSalesMonth: TADOQuery read Q_ChartSalesMonth;
    property dsChartSalesMonth: TDataSource read DS_ChartSalesMonth;

    property qChartStatusStruct: TADOQuery read Q_ChartStatusStruct;
    property dsChartStatusStruct: TDataSource read DS_ChartStatusStruct;

    property qChartAvgPriceSnt: TADOQuery read Q_ChartAvgPriceSnt;
    property dsChartAvgPriceSnt: TDataSource read DS_ChartAvgPriceSnt;

    property qChartSalesDyn: TADOQuery read Q_ChartSalesDyn;
    property dsChartSalesDyn: TDataSource read DS_ChartSalesDyn;

    property qExec: TADOQuery read Q_Exec;
    property qProc: TADOCommand read Cmd_RecalcObjectStatus;

    function Connect(const AUser, APass: string; out AErr: string): Boolean;
    procedure Disconnect;

    property LoginUser: string read FLoginUser;
    property Role: TKairosUserRole read FRole;

    function CheckPrivileges(out AErr: string): Boolean;

    procedure OpenLookups;
    procedure OpenMainData;
    procedure CloseAllData;

    procedure RecalcObjectStatus(const AObjectID: Integer = 0);

    procedure ResetObjectListFilter;
    procedure ResetContractListFilter;

    procedure PrepareObjectListParams;
    procedure PrepareContractListParams;

    procedure ApplyObjectListFilter(
      const AStatus, ASnt: Variant;
      const APriceMin, APriceMax: Variant;
      const AOnlyFree: Boolean);

    procedure ApplyContractListFilter(
      const AStatus: Variant;
      const ADateFrom, ADateTo: Variant);

    procedure PrepareGlobalSearchParams;
    procedure ApplyGlobalSearch(const AText: string);
    procedure ResetGlobalSearch;

    procedure OpenRepObjectList;
    procedure RefreshRepObjectList;

    procedure OpenRepContractList;
    procedure RefreshRepContractList;

    procedure OpenRepObjGroupSntStatus;
    procedure ApplyRepObjGroupSntStatusFilter(const ASnt, AStatus: Variant);

    procedure OpenRepContractGroupPeriod;
    procedure ApplyRepContractGroupPeriodFilter(const ADateFrom, ADateTo: Variant);

    procedure OpenRepObjCharMD;
    procedure ApplyRepObjMasterFilter(
      const ASnt, AStatus, AMinPrice, AMaxPrice: Variant;
      const AOnlyFree: Boolean);
    procedure RefreshRepObjCharDetail;

    procedure OpenChartSalesMonth;
    procedure OpenChartStatusStruct;
    procedure OpenChartAvgPriceSnt;

    procedure PrepareChartSalesDynParams;
    procedure ApplyChartSalesDynFilter(
      const ASnt, AStatus: Variant;
      const ADateFrom, ADateTo: Variant);

    procedure FixParamTypes(Q: TADOQuery);

    procedure AddObjectPhotoBlob(const AObjectID: Integer; const AFileName: string; const AMakeMain: Boolean = False);
    procedure DeleteObjectPhoto(const APhotoID: Integer);
    procedure SetMainObjectPhoto(const AObjectID, APhotoID: Integer);
    procedure LoadMainObjectPhotoToImage(const AObjectID: Integer; AImage: TPicture);
  end;

var
  dmMain: TdmMain;

implementation

{$R *.dfm}

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  FLoginUser := '';
  FRole := urNone;
end;

procedure TdmMain.SafeOpen(Q: TADOQuery; const AName: string);
begin
  if Q = nil then Exit;
  if not conMain.Connected then Exit;

  if Q.Active then Exit;
  try
    Q.Open;
  except
    on E: Exception do
      raise Exception.Create(Format('%s: %s', [AName, E.Message]));
  end;
end;

procedure TdmMain.SafeClose(Q: TADOQuery);
begin
  if Q = nil then Exit;
  try
    if Q.Active then
      Q.Close;
  except
  end;
end;

function TdmMain.Connect(const AUser, APass: string; out AErr: string): Boolean;
var
  S: string;
begin
  Result := False;
  AErr := '';

  try
    S := Trim(Con_Main.ConnectionString);

    Con_Main.Close;
    Con_Main.Provider := 'MSDASQL.1';
    Con_Main.LoginPrompt := False;

    if Pos('EXTENDED PROPERTIES=', UpperCase(S)) = 0 then
    begin
      if (AUser <> '') and (Pos('USER ID=', UpperCase(S)) = 0) then
        S := S + 'User ID=' + AUser + ';';

      if (APass <> '') and (Pos('PASSWORD=', UpperCase(S)) = 0) then
        S := S + 'Password=' + APass + ';';
    end;

    Con_Main.ConnectionString := S;
    Con_Main.Open;

    DetectRoleByUserName(AUser);

    Result := True;
  except
    on E: Exception do
    begin
      AErr := E.Message;
      Result := False;
    end;
  end;
end;

procedure TdmMain.Disconnect;
begin
  CloseAllData;
  try
    Con_Main.Close;
  except
  end;

  FLoginUser := '';
  FRole := urNone;
end;

procedure TdmMain.DetectRoleByUserName(const AUser: string);

  function FallbackRoleFromLogin(const U: string): TKairosUserRole;
  begin
    if SameText(U, 'kh_obj_admin') then
      Exit(urObjectAdmin);

    if SameText(U, 'kh_realtor') then
      Exit(urRealtor);

    Result := urNone;
  end;

  function TryReadRoleFromDb(const U: string; out ARole: TKairosUserRole): Boolean;
  var
    Q: TADOQuery;
    Code: string;
  begin
    Result := False;
    ARole := urNone;

    if not conMain.Connected then Exit;
    if Trim(U) = '' then Exit;

    Q := TADOQuery.Create(nil);
    try
      Q.Connection := conMain;
      Q.CursorLocation := clUseClient;

      Q.SQL.Text :=
        'SELECT role_code ' +
        'FROM app_user_role ' +
        'WHERE mysql_user = ? ' +
        'LIMIT 1';

      Q.Parameters.Refresh;
      if Q.Parameters.Count = 0 then
        Q.Parameters.CreateParameter('mysql_user', ftString, pdInput, 255, Null);

      Q.Parameters[0].Value := Trim(U);

      try
        Q.Open;
      except
        Exit(False);
      end;

      if Q.IsEmpty then
        Exit(False);

      Code := UpperCase(Trim(Q.Fields[0].AsString));

      if Code = 'OBJ_ADMIN' then
        ARole := urObjectAdmin
      else if Code = 'REALTOR' then
        ARole := urRealtor
      else
        ARole := urNone;

      Result := True;
    finally
      Q.Free;
    end;
  end;

var
  R: TKairosUserRole;
begin
  FLoginUser := Trim(AUser);
  FRole := urNone;

  if TryReadRoleFromDb(FLoginUser, R) then
    FRole := R
  else
    FRole := FallbackRoleFromLogin(FLoginUser);
end;

function TdmMain.CheckPrivileges(out AErr: string): Boolean;
var
  Q: TADOQuery;

  procedure ProbeSelect(const ASql, AFailPrefix: string);
  begin
    try
      Q.Close;
      Q.SQL.Text := ASql;
      Q.Open;
      Q.Close;
    except
      on E: Exception do
        raise Exception.Create(AFailPrefix + ' ' + E.Message);
    end;
  end;

begin
  Result := False;
  AErr := '';

  if not conMain.Connected then
  begin
    AErr := 'Нет соединения с БД.';
    Exit(False);
  end;

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := conMain;

    try
      ProbeSelect('SELECT 1', 'SELECT:');
      ProbeSelect('SELECT * FROM `app_user_role` LIMIT 1', '`app_user_role`:');
      ProbeSelect('SELECT * FROM `object_status` LIMIT 1', '`object_status`:');
      ProbeSelect('SELECT * FROM `snt_settlement` LIMIT 1', '`snt_settlement`:');
      ProbeSelect('SELECT * FROM `snt_place` LIMIT 1', '`snt_place`:');
      ProbeSelect('SELECT * FROM `employee` LIMIT 1', '`employee`:');
      ProbeSelect('SELECT * FROM `employee_position` LIMIT 1', '`employee_position`:');

      ProbeSelect('SELECT * FROM `q_v_object_list` LIMIT 1', '`q_v_object_list`:');
      ProbeSelect('SELECT * FROM `q_v_global_search` LIMIT 1', '`q_v_global_search`:');
      ProbeSelect('SELECT * FROM `q_v_object_char_detail` LIMIT 1', '`q_v_object_char_detail`:');
      ProbeSelect('SELECT * FROM `q_v_object_utility` LIMIT 1', '`q_v_object_utility`:');
      ProbeSelect('SELECT * FROM `q_v_object_material` LIMIT 1', '`q_v_object_material`:');
      ProbeSelect('SELECT * FROM `q_v_object_photo_blob` LIMIT 1', '`q_v_object_photo_blob`:');
      ProbeSelect('SELECT * FROM `q_v_rep_object_list` LIMIT 1', '`q_v_rep_object_list`:');
      ProbeSelect('SELECT * FROM `q_v_rep_obj_group_snt_status` LIMIT 1', '`q_v_rep_obj_group_snt_status`:');
      ProbeSelect('SELECT * FROM `q_v_rep_object_master` LIMIT 1', '`q_v_rep_object_master`:');
      ProbeSelect('SELECT * FROM `q_v_chart_sales_by_month` LIMIT 1', '`q_v_chart_sales_by_month`:');
      ProbeSelect('SELECT * FROM `q_v_chart_status_structure` LIMIT 1', '`q_v_chart_status_structure`:');
      ProbeSelect('SELECT * FROM `q_v_chart_avg_price_by_snt` LIMIT 1', '`q_v_chart_avg_price_by_snt`:');

      case FRole of
        urObjectAdmin:
          begin
            ProbeSelect('SELECT * FROM `object` LIMIT 1', '`object`:');
            ProbeSelect('SELECT * FROM `object_photo` LIMIT 1', '`object_photo`:');
            ProbeSelect('SELECT * FROM `object_characteristic` LIMIT 1', '`object_characteristic`:');
            ProbeSelect('SELECT * FROM `object_utility` LIMIT 1', '`object_utility`:');
            ProbeSelect('SELECT * FROM `object_material` LIMIT 1', '`object_material`:');
            ProbeSelect('SELECT * FROM `characteristic_type` LIMIT 1', '`characteristic_type`:');
            ProbeSelect('SELECT * FROM `utility_type` LIMIT 1', '`utility_type`:');
            ProbeSelect('SELECT * FROM `material_type` LIMIT 1', '`material_type`:');
          end;

        urRealtor:
          begin
            ProbeSelect('SELECT * FROM `client` LIMIT 1', '`client`:');
            ProbeSelect('SELECT * FROM `contract` LIMIT 1', '`contract`:');
            ProbeSelect('SELECT * FROM `contract_status` LIMIT 1', '`contract_status`:');
            ProbeSelect('SELECT * FROM `q_v_contract_list` LIMIT 1', '`q_v_contract_list`:');
            ProbeSelect('SELECT * FROM `q_v_rep_contract_list` LIMIT 1', '`q_v_rep_contract_list`:');
            ProbeSelect('SELECT * FROM `q_v_rep_contract_group_period` LIMIT 1', '`q_v_rep_contract_group_period`:');
          end;
      else
        raise Exception.Create('Роль пользователя не определена.');
      end;

      Result := True;
    except
      on E: Exception do
      begin
        AErr := E.Message;
        Result := False;
      end;
    end;
  finally
    Q.Free;
  end;
end;

procedure TdmMain.OpenLookups;
begin
  if not conMain.Connected then Exit;

  SafeOpen(qStatus, 'qStatus');
  SafeOpen(qSettlement, 'qSettlement');
  SafeOpen(qPlace, 'qPlace');

  SafeOpen(qUtilityType, 'qUtilityType');
  SafeOpen(qCharacteristicType, 'qCharacteristicType');
  SafeOpen(qMaterialType, 'qMaterialType');

  if FRole in [urObjectAdmin, urRealtor] then
  begin
    SafeOpen(qEmployee, 'qEmployee');
    SafeOpen(qEmployeeDir, 'qEmployeeDir');
    SafeOpen(qEmployeePositionDir, 'qEmployeePositionDir');
  end
  else
  begin
    SafeClose(qEmployee);
    SafeClose(qEmployeeDir);
    SafeClose(qEmployeePositionDir);
  end;

  if FRole = urRealtor then
  begin
    SafeOpen(qClient, 'qClient');
    SafeOpen(qObjectPick, 'qObjectPick');
  end
  else
  begin
    SafeClose(qClient);
    SafeClose(qObjectPick);
  end;
end;

procedure TdmMain.OpenMainData;
begin
  if not conMain.Connected then Exit;

  PrepareObjectListParams;
  SafeOpen(qObjectList, 'qObjectList');
  RefreshObjectDetails;

  if FRole = urRealtor then
  begin
    PrepareContractListParams;
    SafeOpen(qContractList, 'qContractList');
  end
  else
  begin
    SafeClose(qContractList);
  end;
end;

procedure TdmMain.CloseAllData;
begin
  SafeClose(qObjectList);
  SafeClose(qObjectCard);
  SafeClose(qObjectPhoto);
  SafeClose(qObjectChar);
  SafeClose(qObjectUtility);
  SafeClose(qObjectMaterial);

  SafeClose(qContractList);

  SafeClose(qStatus);
  SafeClose(qSettlement);
  SafeClose(qPlace);
  SafeClose(qUtilityType);
  SafeClose(qCharacteristicType);
  SafeClose(qMaterialType);
  SafeClose(qEmployee);
  SafeClose(qClient);
  SafeClose(qObjectPick);

  SafeClose(qContractEdit);
  SafeClose(qClientEdit);
  SafeClose(qObjectEdit);

  SafeClose(qUtilityTypeEdit);
  SafeClose(qCharacteristicTypeEdit);
  SafeClose(qMaterialTypeEdit);
  SafeClose(qSettlementEdit);
  SafeClose(qPlaceEdit);
  SafeClose(qStatusEdit);

  SafeClose(qGlobalSearch);

  SafeClose(qRepObjectList);
  SafeClose(qRepContractList);
  SafeClose(qRepObjGroup);
  SafeClose(qRepContractPeriod);
  SafeClose(qRepObjMaster);
  SafeClose(qRepObjCharDetail);

  SafeClose(qChartSalesMonth);
  SafeClose(qChartStatusStruct);
  SafeClose(qChartAvgPriceSnt);
  SafeClose(qChartSalesDyn);

  SafeClose(qExec);
end;

procedure TdmMain.RequeryActive(Q: TADOQuery);
begin
  if (Q <> nil) and Q.Active then
    Q.Requery;
end;

function TdmMain.TryGetDataSetFieldInt(ADataSet: TDataSet; const AFieldName: string; out AValue: Integer): Boolean;
var
  F: TField;
begin
  Result := False;
  AValue := 0;

  if (ADataSet = nil) or (not ADataSet.Active) or ADataSet.IsEmpty then
    Exit;

  F := ADataSet.FindField(AFieldName);
  if (F = nil) or F.IsNull then
    Exit;

  AValue := F.AsInteger;
  Result := True;
end;

function TdmMain.ResolveCurrentObjectID: Integer;
begin
  Result := 0;

  if TryGetDataSetFieldInt(qContractEdit, 'conObjectID', Result) then Exit;
  if TryGetDataSetFieldInt(qContractList, 'IDob', Result) then Exit;
  if TryGetDataSetFieldInt(qContractList, 'conObjectID', Result) then Exit;
  if TryGetDataSetFieldInt(qObjectEdit, 'IDob', Result) then Exit;
  if TryGetDataSetFieldInt(qObjectCard, 'IDob', Result) then Exit;
  if TryGetDataSetFieldInt(qObjectList, 'IDob', Result) then Exit;
end;

procedure TdmMain.RecalcObjectStatus(const AObjectID: Integer);
var
  ObjID: Integer;
begin
  if not conMain.Connected then Exit;

  ObjID := AObjectID;
  if ObjID <= 0 then
    ObjID := ResolveCurrentObjectID;
  if ObjID <= 0 then
    Exit;

  if Cmd_RecalcObjectStatus.Parameters.FindParam('p_object_id') = nil then
    Cmd_RecalcObjectStatus.Parameters.Refresh;

  Cmd_RecalcObjectStatus.Parameters.ParamByName('p_object_id').Value := ObjID;
  Cmd_RecalcObjectStatus.Execute;

  RequeryActive(qObjectList);
  RequeryActive(qContractList);
  RequeryActive(qRepObjectList);
  RequeryActive(qRepObjGroup);
  RequeryActive(qRepObjMaster);
  RequeryActive(qChartStatusStruct);

  if qObjectCard.Active and (qObjectCard.Parameters.FindParam('IDob') <> nil) then
  begin
    qObjectCard.Close;
    qObjectCard.Parameters.ParamByName('IDob').Value := ObjID;
    qObjectCard.Open;
  end;
end;

procedure TdmMain.ResetObjectListFilter;
begin
  PrepareObjectListParams;
  if qObjectList.Active then
  begin
    qObjectList.Close;
    qObjectList.Open;
  end;
end;

procedure TdmMain.ResetContractListFilter;
begin
  PrepareContractListParams;
  if qContractList.Active then
  begin
    qContractList.Close;
    qContractList.Open;
  end;
end;

procedure TdmMain.PrepareObjectListParams;
begin
  if not conMain.Connected then Exit;

  FixParamTypes(qObjectList);

  if qObjectList.Parameters.FindParam('pStatus1') <> nil then qObjectList.Parameters.ParamByName('pStatus1').Value := Null;
  if qObjectList.Parameters.FindParam('pStatus2') <> nil then qObjectList.Parameters.ParamByName('pStatus2').Value := Null;

  if qObjectList.Parameters.FindParam('pSnt1') <> nil then qObjectList.Parameters.ParamByName('pSnt1').Value := Null;
  if qObjectList.Parameters.FindParam('pSnt2') <> nil then qObjectList.Parameters.ParamByName('pSnt2').Value := Null;

  if qObjectList.Parameters.FindParam('pPriceMin1') <> nil then qObjectList.Parameters.ParamByName('pPriceMin1').Value := Null;
  if qObjectList.Parameters.FindParam('pPriceMin2') <> nil then qObjectList.Parameters.ParamByName('pPriceMin2').Value := Null;

  if qObjectList.Parameters.FindParam('pPriceMax1') <> nil then qObjectList.Parameters.ParamByName('pPriceMax1').Value := Null;
  if qObjectList.Parameters.FindParam('pPriceMax2') <> nil then qObjectList.Parameters.ParamByName('pPriceMax2').Value := Null;

  if qObjectList.Parameters.FindParam('pOnlyFree') <> nil then qObjectList.Parameters.ParamByName('pOnlyFree').Value := 0;
end;

procedure TdmMain.PrepareContractListParams;
begin
  if not conMain.Connected then Exit;

  FixParamTypes(qContractList);

  if qContractList.Parameters.FindParam('pDateFrom1') <> nil then qContractList.Parameters.ParamByName('pDateFrom1').Value := Null;
  if qContractList.Parameters.FindParam('pDateFrom2') <> nil then qContractList.Parameters.ParamByName('pDateFrom2').Value := Null;

  if qContractList.Parameters.FindParam('pDateTo1') <> nil then qContractList.Parameters.ParamByName('pDateTo1').Value := Null;
  if qContractList.Parameters.FindParam('pDateTo2') <> nil then qContractList.Parameters.ParamByName('pDateTo2').Value := Null;

  if qContractList.Parameters.FindParam('pConStatus1') <> nil then qContractList.Parameters.ParamByName('pConStatus1').Value := Null;
  if qContractList.Parameters.FindParam('pConStatus2') <> nil then qContractList.Parameters.ParamByName('pConStatus2').Value := Null;
end;

procedure TdmMain.ApplyObjectListFilter(
  const AStatus, ASnt: Variant;
  const APriceMin, APriceMax: Variant;
  const AOnlyFree: Boolean);
begin
  if not conMain.Connected then Exit;

  qObjectList.Close;
  PrepareObjectListParams;

  if qObjectList.Parameters.FindParam('pStatus1') <> nil then qObjectList.Parameters.ParamByName('pStatus1').Value := AStatus;
  if qObjectList.Parameters.FindParam('pStatus2') <> nil then qObjectList.Parameters.ParamByName('pStatus2').Value := AStatus;

  if qObjectList.Parameters.FindParam('pSnt1') <> nil then qObjectList.Parameters.ParamByName('pSnt1').Value := ASnt;
  if qObjectList.Parameters.FindParam('pSnt2') <> nil then qObjectList.Parameters.ParamByName('pSnt2').Value := ASnt;

  if qObjectList.Parameters.FindParam('pPriceMin1') <> nil then qObjectList.Parameters.ParamByName('pPriceMin1').Value := APriceMin;
  if qObjectList.Parameters.FindParam('pPriceMin2') <> nil then qObjectList.Parameters.ParamByName('pPriceMin2').Value := APriceMin;

  if qObjectList.Parameters.FindParam('pPriceMax1') <> nil then qObjectList.Parameters.ParamByName('pPriceMax1').Value := APriceMax;
  if qObjectList.Parameters.FindParam('pPriceMax2') <> nil then qObjectList.Parameters.ParamByName('pPriceMax2').Value := APriceMax;

  if qObjectList.Parameters.FindParam('pOnlyFree') <> nil then
    qObjectList.Parameters.ParamByName('pOnlyFree').Value := Ord(AOnlyFree);

  qObjectList.Open;
end;

procedure TdmMain.ApplyContractListFilter(
  const AStatus: Variant;
  const ADateFrom, ADateTo: Variant);
var
  VStatus: Variant;
begin
  if not conMain.Connected then Exit;

  qContractList.Close;
  PrepareContractListParams;

  VStatus := NormalizeContractStatusFilter(AStatus);

  if qContractList.Parameters.FindParam('pDateFrom1') <> nil then qContractList.Parameters.ParamByName('pDateFrom1').Value := ADateFrom;
  if qContractList.Parameters.FindParam('pDateFrom2') <> nil then qContractList.Parameters.ParamByName('pDateFrom2').Value := ADateFrom;

  if qContractList.Parameters.FindParam('pDateTo1') <> nil then qContractList.Parameters.ParamByName('pDateTo1').Value := ADateTo;
  if qContractList.Parameters.FindParam('pDateTo2') <> nil then qContractList.Parameters.ParamByName('pDateTo2').Value := ADateTo;

  if qContractList.Parameters.FindParam('pConStatus1') <> nil then qContractList.Parameters.ParamByName('pConStatus1').Value := VStatus;
  if qContractList.Parameters.FindParam('pConStatus2') <> nil then qContractList.Parameters.ParamByName('pConStatus2').Value := VStatus;

  qContractList.Open;
end;

procedure TdmMain.PrepareGlobalSearchParams;
begin
  if not conMain.Connected then Exit;

  FixParamTypes(qGlobalSearch);

  if qGlobalSearch.Parameters.FindParam('pQ1') <> nil then
    qGlobalSearch.Parameters.ParamByName('pQ1').Value := Null;
  if qGlobalSearch.Parameters.FindParam('pQ2') <> nil then
    qGlobalSearch.Parameters.ParamByName('pQ2').Value := Null;
end;

function NormalizeGlobalSearchText(const AText: string): string;
begin
  Result := UpperCase(Trim(AText));
  Result := StringReplace(Result, 'АКТИВЕН', 'ACTIVE', [rfReplaceAll]);
  Result := StringReplace(Result, 'ЗАКРЫТ', 'CLOSED', [rfReplaceAll]);
  Result := StringReplace(Result, 'ОТМЕНЕН', 'CANCELED', [rfReplaceAll]);
  Result := StringReplace(Result, 'ОТМЕНЁН', 'CANCELED', [rfReplaceAll]);
end;

procedure TdmMain.ApplyGlobalSearch(const AText: string);
var
  S: string;
begin
  if not conMain.Connected then Exit;

  qGlobalSearch.Close;
  PrepareGlobalSearchParams;

  S := Trim(AText);
  if S <> '' then
  begin
    if qGlobalSearch.Parameters.FindParam('pQ1') <> nil then
      qGlobalSearch.Parameters.ParamByName('pQ1').Value := S;
    if qGlobalSearch.Parameters.FindParam('pQ2') <> nil then
      qGlobalSearch.Parameters.ParamByName('pQ2').Value := '%' + S + '%';
  end;

  qGlobalSearch.Open;
end;

procedure TdmMain.ResetGlobalSearch;
begin
  if not conMain.Connected then Exit;

  qGlobalSearch.Close;
  PrepareGlobalSearchParams;
  qGlobalSearch.Open;
end;

procedure TdmMain.OpenRepObjectList;
begin
  if not conMain.Connected then Exit;
  SafeOpen(qRepObjectList, 'qRepObjectList');
end;

procedure TdmMain.RefreshRepObjectList;
begin
  if qRepObjectList.Active then
    qRepObjectList.Requery;
end;

procedure TdmMain.OpenRepContractList;
begin
  if not conMain.Connected then Exit;
  SafeOpen(qRepContractList, 'qRepContractList');
end;

procedure TdmMain.RefreshRepContractList;
begin
  if qRepContractList.Active then
    qRepContractList.Requery;
end;

procedure TdmMain.OpenRepObjGroupSntStatus;
begin
  if not conMain.Connected then Exit;
  SafeOpen(qRepObjGroup, 'qRepObjGroup');
end;

procedure TdmMain.ApplyRepObjGroupSntStatusFilter(const ASnt, AStatus: Variant);
begin
  if not conMain.Connected then Exit;

  qRepObjGroup.Close;

  FixParamTypes(qRepObjGroup);

  if qRepObjGroup.Parameters.FindParam('pSnt1') <> nil then
    qRepObjGroup.Parameters.ParamByName('pSnt1').Value := ASnt;
  if qRepObjGroup.Parameters.FindParam('pSnt2') <> nil then
    qRepObjGroup.Parameters.ParamByName('pSnt2').Value := ASnt;

  if qRepObjGroup.Parameters.FindParam('pStatus1') <> nil then
    qRepObjGroup.Parameters.ParamByName('pStatus1').Value := AStatus;
  if qRepObjGroup.Parameters.FindParam('pStatus2') <> nil then
    qRepObjGroup.Parameters.ParamByName('pStatus2').Value := AStatus;

  qRepObjGroup.Open;
end;

procedure TdmMain.OpenRepContractGroupPeriod;
begin
  if not conMain.Connected then Exit;
  SafeOpen(qRepContractPeriod, 'qRepContractPeriod');
end;

procedure TdmMain.ApplyRepContractGroupPeriodFilter(const ADateFrom, ADateTo: Variant);
begin
  if not conMain.Connected then Exit;

  qRepContractPeriod.Close;

  FixParamTypes(qRepContractPeriod);

  if qRepContractPeriod.Parameters.FindParam('pDateFrom1') <> nil then
    qRepContractPeriod.Parameters.ParamByName('pDateFrom1').Value := ADateFrom;
  if qRepContractPeriod.Parameters.FindParam('pDateFrom2') <> nil then
    qRepContractPeriod.Parameters.ParamByName('pDateFrom2').Value := ADateFrom;

  if qRepContractPeriod.Parameters.FindParam('pDateTo1') <> nil then
    qRepContractPeriod.Parameters.ParamByName('pDateTo1').Value := ADateTo;
  if qRepContractPeriod.Parameters.FindParam('pDateTo2') <> nil then
    qRepContractPeriod.Parameters.ParamByName('pDateTo2').Value := ADateTo;

  if qRepContractPeriod.Parameters.FindParam('pConStatus1') <> nil then
    qRepContractPeriod.Parameters.ParamByName('pConStatus1').Value := Null;
  if qRepContractPeriod.Parameters.FindParam('pConStatus2') <> nil then
    qRepContractPeriod.Parameters.ParamByName('pConStatus2').Value := Null;

  qRepContractPeriod.Open;
end;

procedure TdmMain.OpenRepObjCharMD;
begin
  if not conMain.Connected then Exit;

  SafeOpen(qRepObjMaster, 'qRepObjMaster');
  RefreshRepObjCharDetail;
end;

procedure TdmMain.ApplyRepObjMasterFilter(
  const ASnt, AStatus, AMinPrice, AMaxPrice: Variant;
  const AOnlyFree: Boolean);
begin
  if not conMain.Connected then Exit;

  qRepObjMaster.Close;

  FixParamTypes(qRepObjMaster);

  if qRepObjMaster.Parameters.FindParam('pSnt1') <> nil then
    qRepObjMaster.Parameters.ParamByName('pSnt1').Value := ASnt;
  if qRepObjMaster.Parameters.FindParam('pSnt2') <> nil then
    qRepObjMaster.Parameters.ParamByName('pSnt2').Value := ASnt;

  if qRepObjMaster.Parameters.FindParam('pStatus1') <> nil then
    qRepObjMaster.Parameters.ParamByName('pStatus1').Value := AStatus;
  if qRepObjMaster.Parameters.FindParam('pStatus2') <> nil then
    qRepObjMaster.Parameters.ParamByName('pStatus2').Value := AStatus;

  if qRepObjMaster.Parameters.FindParam('pPriceMin1') <> nil then
    qRepObjMaster.Parameters.ParamByName('pPriceMin1').Value := AMinPrice;
  if qRepObjMaster.Parameters.FindParam('pPriceMin2') <> nil then
    qRepObjMaster.Parameters.ParamByName('pPriceMin2').Value := AMinPrice;

  if qRepObjMaster.Parameters.FindParam('pPriceMax1') <> nil then
    qRepObjMaster.Parameters.ParamByName('pPriceMax1').Value := AMaxPrice;
  if qRepObjMaster.Parameters.FindParam('pPriceMax2') <> nil then
    qRepObjMaster.Parameters.ParamByName('pPriceMax2').Value := AMaxPrice;

  if qRepObjMaster.Parameters.FindParam('pOnlyFree') <> nil then
    qRepObjMaster.Parameters.ParamByName('pOnlyFree').Value := Ord(AOnlyFree);

  qRepObjMaster.Open;
  RefreshRepObjCharDetail;
end;

procedure TdmMain.RefreshRepObjCharDetail;
var
  ID: Variant;
begin
  SafeClose(qRepObjCharDetail);

  if (not qRepObjMaster.Active) or qRepObjMaster.IsEmpty then Exit;

  ID := qRepObjMaster.FieldByName('IDob').Value;
  if VarIsNull(ID) then Exit;

  EnsureParam(qRepObjCharDetail, 'IDob');
  qRepObjCharDetail.Parameters.ParamByName('IDob').Value := ID;
  SafeOpen(qRepObjCharDetail, 'qRepObjCharDetail');
end;

procedure TdmMain.OpenChartSalesMonth;
begin
  if not conMain.Connected then Exit;
  SafeOpen(qChartSalesMonth, 'qChartSalesMonth');
end;

procedure TdmMain.OpenChartStatusStruct;
begin
  if not conMain.Connected then Exit;
  SafeOpen(qChartStatusStruct, 'qChartStatusStruct');
end;

procedure TdmMain.OpenChartAvgPriceSnt;
begin
  if not conMain.Connected then Exit;
  SafeOpen(qChartAvgPriceSnt, 'qChartAvgPriceSnt');
end;

procedure TdmMain.PrepareChartSalesDynParams;
begin
  if not conMain.Connected then Exit;

  FixParamTypes(qChartSalesDyn);

  if qChartSalesDyn.Parameters.FindParam('pDateFrom1') <> nil then qChartSalesDyn.Parameters.ParamByName('pDateFrom1').Value := Null;
  if qChartSalesDyn.Parameters.FindParam('pDateFrom2') <> nil then qChartSalesDyn.Parameters.ParamByName('pDateFrom2').Value := Null;

  if qChartSalesDyn.Parameters.FindParam('pDateTo1') <> nil then qChartSalesDyn.Parameters.ParamByName('pDateTo1').Value := Null;
  if qChartSalesDyn.Parameters.FindParam('pDateTo2') <> nil then qChartSalesDyn.Parameters.ParamByName('pDateTo2').Value := Null;

  if qChartSalesDyn.Parameters.FindParam('pSnt1') <> nil then qChartSalesDyn.Parameters.ParamByName('pSnt1').Value := Null;
  if qChartSalesDyn.Parameters.FindParam('pSnt2') <> nil then qChartSalesDyn.Parameters.ParamByName('pSnt2').Value := Null;

  if qChartSalesDyn.Parameters.FindParam('pConStatus1') <> nil then qChartSalesDyn.Parameters.ParamByName('pConStatus1').Value := Null;
  if qChartSalesDyn.Parameters.FindParam('pConStatus2') <> nil then qChartSalesDyn.Parameters.ParamByName('pConStatus2').Value := Null;
end;

procedure TdmMain.ApplyChartSalesDynFilter(
  const ASnt, AStatus: Variant;
  const ADateFrom, ADateTo: Variant);
var
  VStatus: Variant;
begin
  if not conMain.Connected then Exit;

  qChartSalesDyn.Close;
  PrepareChartSalesDynParams;

  VStatus := NormalizeContractStatusFilter(AStatus);

  if qChartSalesDyn.Parameters.FindParam('pDateFrom1') <> nil then
    qChartSalesDyn.Parameters.ParamByName('pDateFrom1').Value := ADateFrom;
  if qChartSalesDyn.Parameters.FindParam('pDateFrom2') <> nil then
    qChartSalesDyn.Parameters.ParamByName('pDateFrom2').Value := ADateFrom;

  if qChartSalesDyn.Parameters.FindParam('pDateTo1') <> nil then
    qChartSalesDyn.Parameters.ParamByName('pDateTo1').Value := ADateTo;
  if qChartSalesDyn.Parameters.FindParam('pDateTo2') <> nil then
    qChartSalesDyn.Parameters.ParamByName('pDateTo2').Value := ADateTo;

  if qChartSalesDyn.Parameters.FindParam('pSnt1') <> nil then
    qChartSalesDyn.Parameters.ParamByName('pSnt1').Value := ASnt;
  if qChartSalesDyn.Parameters.FindParam('pSnt2') <> nil then
    qChartSalesDyn.Parameters.ParamByName('pSnt2').Value := ASnt;

  if qChartSalesDyn.Parameters.FindParam('pConStatus1') <> nil then
    qChartSalesDyn.Parameters.ParamByName('pConStatus1').Value := VStatus;
  if qChartSalesDyn.Parameters.FindParam('pConStatus2') <> nil then
    qChartSalesDyn.Parameters.ParamByName('pConStatus2').Value := VStatus;

  qChartSalesDyn.Open;
end;

procedure TdmMain.FixParamTypes(Q: TADOQuery);
begin
  if Q = nil then
    Exit;

  if Q.Owner = Self then
    Exit;

  Q.Parameters.Clear;
end;

function FileToOleBlob(const AFileName: string; out AFileSize: Integer): OleVariant;
var
  FS: TFileStream;
  V: OleVariant;
  P: Pointer;
begin
  FS := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    AFileSize := FS.Size;
    if AFileSize <= 0 then
      raise Exception.Create('Файл пустой: ' + AFileName);

    V := VarArrayCreate([0, AFileSize - 1], varByte);
    P := VarArrayLock(V);
    try
      FS.ReadBuffer(P^, AFileSize);
    finally
      VarArrayUnlock(V);
    end;

    Result := V;
  finally
    FS.Free;
  end;
end;

function TdmMain.DetectMimeType(const AFileName: string): string;
var
  Ext: string;
begin
  Ext := LowerCase(ExtractFileExt(AFileName));

  if (Ext = '.jpg') or (Ext = '.jpeg') then Exit('image/jpeg');
  if Ext = '.png' then Exit('image/png');
  if Ext = '.gif' then Exit('image/gif');
  if Ext = '.bmp' then Exit('image/bmp');
  if Ext = '.webp' then Exit('image/webp');

  Result := 'application/octet-stream';
end;

procedure TdmMain.RefreshPhotoData(const AObjectID: Integer);
begin
  if (AObjectID <= 0) or (qObjectPhoto = nil) then
    Exit;

  SafeClose(qObjectPhoto);
  EnsureParam(qObjectPhoto, 'IDob');
  qObjectPhoto.Parameters.ParamByName('IDob').Value := AObjectID;
  SafeOpen(qObjectPhoto, 'qObjectPhoto');
end;

procedure TdmMain.AddObjectPhotoBlob(const AObjectID: Integer; const AFileName: string; const AMakeMain: Boolean);
var
  Q: TADOQuery;
  NeedMain: Boolean;
  ExistingMainCount: Integer;
  FileSize: Integer;
  FileNameOnly: string;
  FileBlob: OleVariant;
  NewPhotoID: Integer;
begin
  if not conMain.Connected then
    Exit;
  if AObjectID <= 0 then
    Exit;
  if not FileExists(AFileName) then
    raise Exception.Create('Файл не найден: ' + AFileName);

  SafeClose(qObjectPhoto);

  FileNameOnly := ExtractFileName(AFileName);
  FileBlob := FileToOleBlob(AFileName, FileSize);

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := conMain;

    Q.SQL.Text :=
      'SELECT COUNT(*) AS cnt ' +
      'FROM object_photo ' +
      'WHERE phObjectID = :pObjectID AND phIsMain = 1';

    FixParamTypes(Q);
    EnsureSqlParam(Q, 'pObjectID', ftInteger);
    Q.Parameters.ParamByName('pObjectID').Value := AObjectID;
    Q.Open;
    ExistingMainCount := Q.FieldByName('cnt').AsInteger;
    Q.Close;

    NeedMain := AMakeMain or (ExistingMainCount = 0);

    conMain.BeginTrans;
    try
      Q.SQL.Text :=
        'INSERT INTO object_photo ' +
        '  (phObjectID, phPath, phIsMain, phBlob, phFileName, phMime, phSize, phUploadedAt) ' +
        'VALUES ' +
        '  (:pObjectID, :pPath, 0, :pBlob, :pFileName, :pMime, :pSize, NOW())';

      FixParamTypes(Q);
      EnsureSqlParam(Q, 'pObjectID', ftInteger);
      EnsureSqlParam(Q, 'pPath', ftString, 255);
      EnsureSqlParam(Q, 'pBlob', ftBlob);
      EnsureSqlParam(Q, 'pFileName', ftString, 255);
      EnsureSqlParam(Q, 'pMime', ftString, 64);
      EnsureSqlParam(Q, 'pSize', ftInteger);

      Q.Parameters.ParamByName('pObjectID').Value := AObjectID;
      Q.Parameters.ParamByName('pPath').Value := 'blob/' + FileNameOnly;
      Q.Parameters.ParamByName('pBlob').Value := FileBlob;
      Q.Parameters.ParamByName('pFileName').Value := FileNameOnly;
      Q.Parameters.ParamByName('pMime').Value := DetectMimeType(AFileName);
      Q.Parameters.ParamByName('pSize').Value := FileSize;

      try
        Q.ExecSQL;
      except
        on E: Exception do
          raise Exception.Create('AddObjectPhotoBlob/INSERT: ' + E.Message);
      end;

      Q.SQL.Text := 'SELECT LAST_INSERT_ID() AS NewPhotoID';
      FixParamTypes(Q);
      Q.Open;
      NewPhotoID := Q.FieldByName('NewPhotoID').AsInteger;
      Q.Close;

      if NeedMain and (NewPhotoID > 0) then
      begin
        Q.SQL.Text :=
          'UPDATE object_photo ' +
          'SET phIsMain = CASE WHEN IDph = :pPhotoID THEN 1 ELSE 0 END ' +
          'WHERE phObjectID = :pObjectID';

        FixParamTypes(Q);
        EnsureSqlParam(Q, 'pPhotoID', ftInteger);
        EnsureSqlParam(Q, 'pObjectID', ftInteger);

        Q.Parameters.ParamByName('pPhotoID').Value := NewPhotoID;
        Q.Parameters.ParamByName('pObjectID').Value := AObjectID;

        try
          Q.ExecSQL;
        except
          on E: Exception do
            raise Exception.Create('AddObjectPhotoBlob/SETMAIN: ' + E.Message);
        end;
      end;

      conMain.CommitTrans;
    except
      on E: Exception do
      begin
        conMain.RollbackTrans;
        raise;
      end;
    end;
  finally
    Q.Free;
  end;

  RefreshPhotoData(AObjectID);
end;

procedure TdmMain.DeleteObjectPhoto(const APhotoID: Integer);
var
  Q: TADOQuery;
  ObjectID: Integer;
  WasMain: Boolean;
  NewMainID: Integer;
begin
  if not conMain.Connected then
    Exit;
  if APhotoID <= 0 then
    Exit;

  SafeClose(qObjectPhoto);

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := conMain;

    Q.SQL.Text :=
      'SELECT phObjectID, phIsMain ' +
      'FROM object_photo ' +
      'WHERE IDph = :pPhotoID';

    FixParamTypes(Q);
    EnsureSqlParam(Q, 'pPhotoID', ftInteger);
    Q.Parameters.ParamByName('pPhotoID').Value := APhotoID;
    Q.Open;

    if Q.IsEmpty then
      Exit;

    ObjectID := Q.FieldByName('phObjectID').AsInteger;
    WasMain := Q.FieldByName('phIsMain').AsInteger <> 0;
    Q.Close;

    conMain.BeginTrans;
    try
      Q.SQL.Text :=
        'DELETE FROM object_photo ' +
        'WHERE IDph = :pPhotoID';

      FixParamTypes(Q);
      EnsureSqlParam(Q, 'pPhotoID', ftInteger);
      Q.Parameters.ParamByName('pPhotoID').Value := APhotoID;
      Q.ExecSQL;

      if WasMain then
      begin
        Q.SQL.Text :=
          'SELECT IDph ' +
          'FROM object_photo ' +
          'WHERE phObjectID = :pObjectID ' +
          'ORDER BY phUploadedAt DESC, IDph DESC ' +
          'LIMIT 1';

        FixParamTypes(Q);
        EnsureSqlParam(Q, 'pObjectID', ftInteger);
        Q.Parameters.ParamByName('pObjectID').Value := ObjectID;
        Q.Open;

        if not Q.IsEmpty then
          NewMainID := Q.FieldByName('IDph').AsInteger
        else
          NewMainID := 0;

        Q.Close;

        if NewMainID > 0 then
        begin
          Q.SQL.Text :=
            'UPDATE object_photo ' +
            'SET phIsMain = CASE WHEN IDph = :pPhotoID THEN 1 ELSE 0 END ' +
            'WHERE phObjectID = :pObjectID';

          FixParamTypes(Q);
          EnsureSqlParam(Q, 'pPhotoID', ftInteger);
          EnsureSqlParam(Q, 'pObjectID', ftInteger);

          Q.Parameters.ParamByName('pPhotoID').Value := NewMainID;
          Q.Parameters.ParamByName('pObjectID').Value := ObjectID;
          Q.ExecSQL;
        end;
      end;

      conMain.CommitTrans;
    except
      on E: Exception do
      begin
        conMain.RollbackTrans;
        raise Exception.Create('DeleteObjectPhoto: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
  end;

  RefreshPhotoData(ObjectID);
end;

procedure TdmMain.SetMainObjectPhoto(const AObjectID, APhotoID: Integer);
var
  Q: TADOQuery;
begin
  if not conMain.Connected then
    Exit;
  if (AObjectID <= 0) or (APhotoID <= 0) then
    Exit;

  SafeClose(qObjectPhoto);

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := conMain;

    conMain.BeginTrans;
    try
      Q.SQL.Text :=
        'UPDATE object_photo ' +
        'SET phIsMain = CASE WHEN IDph = :pPhotoID THEN 1 ELSE 0 END ' +
        'WHERE phObjectID = :pObjectID';

      FixParamTypes(Q);
      EnsureSqlParam(Q, 'pPhotoID', ftInteger);
      EnsureSqlParam(Q, 'pObjectID', ftInteger);

      Q.Parameters.ParamByName('pPhotoID').Value := APhotoID;
      Q.Parameters.ParamByName('pObjectID').Value := AObjectID;
      Q.ExecSQL;

      conMain.CommitTrans;
    except
      on E: Exception do
      begin
        conMain.RollbackTrans;
        raise Exception.Create('SetMainObjectPhoto: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
  end;

  RefreshPhotoData(AObjectID);
end;

procedure TdmMain.LoadMainObjectPhotoToImage(const AObjectID: Integer; AImage: TPicture);
var
  Q: TADOQuery;
  MS: TMemoryStream;
begin
  if AImage = nil then
    Exit;

  AImage.Assign(nil);

  if not Con_Main.Connected then
    Exit;

  if AObjectID <= 0 then
    Exit;

  Q := TADOQuery.Create(nil);
  try
    Q.Connection := Con_Main;
    Q.SQL.Text :=
      'SELECT phBlob ' +
      'FROM object_photo ' +
      'WHERE phObjectID = :pObjectID ' +
      '  AND phBlob IS NOT NULL ' +
      'ORDER BY phIsMain DESC, phUploadedAt DESC, IDph DESC ' +
      'LIMIT 1';

    FixParamTypes(Q);
    EnsureSqlParam(Q, 'pObjectID', ftInteger);
    Q.Parameters.ParamByName('pObjectID').Value := AObjectID;

    try
      Q.Open;
    except
      on E: Exception do
        raise Exception.Create('LoadMainObjectPhotoToImage.Q.Open: ' + E.Message);
    end;

    if Q.IsEmpty then
      Exit;

    if Q.FieldByName('phBlob').IsNull then
      Exit;

    MS := TMemoryStream.Create;
    try
      try
        TBlobField(Q.FieldByName('phBlob')).SaveToStream(MS);
      except
        on E: Exception do
          raise Exception.Create('LoadMainObjectPhotoToImage.SaveToStream: ' + E.Message);
      end;

      if MS.Size = 0 then
        Exit;

      MS.Position := 0;

      try
        AImage.LoadFromStream(MS);
      except
        on E: Exception do
          raise Exception.Create('LoadMainObjectPhotoToImage.LoadFromStream: ' + E.Message);
      end;
    finally
      MS.Free;
    end;
  finally
    Q.Free;
  end;
end;

procedure TdmMain.Q_ObjectListAfterScroll(DataSet: TDataSet);
begin
  RefreshObjectDetails;
end;

function TdmMain.HasObjects: Boolean;
begin
  Result := Assigned(qObjectList) and qObjectList.Active and (not qObjectList.IsEmpty);
end;

function TdmMain.NormalizeContractStatusFilter(const AStatus: Variant): Variant;
var
  S: string;
begin
  if VarIsEmpty(AStatus) or VarIsNull(AStatus) then
    Exit(Null);

  S := Trim(VarToStr(AStatus));
  if S = '' then
    Exit(Null);

  if SameText(S, 'Активен') then
    Result := 'Active'
  else if SameText(S, 'Закрыт') then
    Result := 'Closed'
  else if SameText(S, 'Отменен') then
    Result := 'Canceled'
  else
    Result := S;
end;

procedure TdmMain.EnsureParam(Q: TADOQuery; const ParamName: string);
begin
  if Q.Parameters.FindParam(ParamName) = nil then
    if conMain.Connected then
      Q.Parameters.Refresh;

  if Q.Parameters.FindParam(ParamName) = nil then
    raise Exception.Create(Format('В %s отсутствует параметр :%s. Проверь SQL.', [Q.Name, ParamName]));
end;

procedure TdmMain.EnsureSqlParam(Q: TADOQuery; const ParamName: string; ADataType: TDataType; const ASize: Integer);
begin
  if Q = nil then Exit;

  if Q.Parameters.FindParam(ParamName) = nil then
    Q.Parameters.CreateParameter(ParamName, ADataType, pdInput, ASize, Null);
end;

procedure TdmMain.RefreshObjectDetails;
var
  ID: Variant;
begin
  if not HasObjects then
  begin
    SafeClose(qObjectCard);
    SafeClose(qObjectPhoto);
    SafeClose(qObjectChar);
    SafeClose(qObjectUtility);
    SafeClose(qObjectMaterial);
    Exit;
  end;

  ID := qObjectList.FieldByName('IDob').Value;
  if VarIsNull(ID) then Exit;

  SafeClose(qObjectCard);
  EnsureParam(qObjectCard, 'IDob');
  qObjectCard.Parameters.ParamByName('IDob').Value := ID;
  SafeOpen(qObjectCard, 'qObjectCard');

  SafeClose(qObjectPhoto);
  EnsureParam(qObjectPhoto, 'IDob');
  qObjectPhoto.Parameters.ParamByName('IDob').Value := ID;
  SafeOpen(qObjectPhoto, 'qObjectPhoto');

  SafeClose(qObjectChar);
  EnsureParam(qObjectChar, 'IDob');
  qObjectChar.Parameters.ParamByName('IDob').Value := ID;
  SafeOpen(qObjectChar, 'qObjectChar');

  SafeClose(qObjectUtility);
  EnsureParam(qObjectUtility, 'IDob');
  qObjectUtility.Parameters.ParamByName('IDob').Value := ID;
  SafeOpen(qObjectUtility, 'qObjectUtility');

  SafeClose(qObjectMaterial);
  EnsureParam(qObjectMaterial, 'IDob');
  qObjectMaterial.Parameters.ParamByName('IDob').Value := ID;
  SafeOpen(qObjectMaterial, 'qObjectMaterial');
end;

end.