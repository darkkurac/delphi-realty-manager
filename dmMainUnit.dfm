object dmMain: TdmMain
  OnCreate = DataModuleCreate
  Height = 811
  Width = 1251
  object Con_Main: TADOConnection
    LoginPrompt = False
    Left = 48
    Top = 16
  end
  object Q_ObjectList: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    AfterScroll = Q_ObjectListAfterScroll
    Parameters = <
      item
        Name = 'pStatus1'
        DataType = ftWideString
        Size = 80
        Value = Null
      end
      item
        Name = 'pStatus2'
        DataType = ftWideString
        Size = 80
        Value = Null
      end
      item
        Name = 'pSnt1'
        DataType = ftWideString
        Size = 120
        Value = Null
      end
      item
        Name = 'pSnt2'
        DataType = ftWideString
        Size = 120
        Value = Null
      end
      item
        Name = 'pPriceMin1'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = 'pPriceMin2'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = 'pPriceMax1'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = 'pPriceMax2'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = 'pOnlyFree'
        DataType = ftInteger
        Value = 0
      end>
    SQL.Strings = (
      'SELECT'
      '  ob.IDob,'
      '  ob.obCode,'
      '  ob.obName,'
      '  ob.obPrice,'
      '  os.osName AS obStatus,'
      '  snt.snsName AS sntName,'
      '  ob.obTotalArea,'
      '  ob.obRooms,'
      '  ob.obFloors,'
      '  ob.obCreatedAt,'
      '  ob.obUpdatedAt'
      'FROM `object` ob'
      'JOIN object_status os ON os.IDos = ob.obStatusID'
      'JOIN snt_place sp ON sp.IDsp = ob.obPlaceID'
      'JOIN snt_settlement snt ON snt.IDsns = sp.spSettlementID'
      'WHERE'
      '  (:pStatus1 IS NULL OR os.osName = :pStatus2)'
      '  AND (:pSnt1 IS NULL OR snt.snsName = :pSnt2)'
      '  AND (:pPriceMin1 IS NULL OR ob.obPrice >= :pPriceMin2)'
      '  AND (:pPriceMax1 IS NULL OR ob.obPrice <= :pPriceMax2)'
      '  AND (:pOnlyFree = 0 OR os.osName = '#39#1057#1074#1086#1073#1086#1076#1077#1085#39')'
      'ORDER BY ob.IDob DESC')
    Left = 48
    Top = 96
  end
  object DS_ObjectList: TDataSource
    DataSet = Q_ObjectList
    Left = 192
    Top = 96
  end
  object Q_ObjectCard: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'IDob'
        DataType = ftInteger
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '  ob.IDob,'
      '  ob.obCode,'
      '  ob.obName,'
      '  ob.obDescription,'
      '  ob.obPrice,'
      '  ob.obBuildYear,'
      '  ob.obTotalArea,'
      '  ob.obFloors,'
      '  ob.obRooms,'
      '  ob.obStatusID,'
      '  os.osName AS osName,'
      '  ob.obPlaceID,'
      '  sp.spCadastral,'
      '  sp.spArea,'
      '  sp.spAddress,'
      '  sp.spSettlementID,'
      '  snt.snsName AS sntName'
      'FROM `object` ob'
      'JOIN object_status os ON os.IDos = ob.obStatusID'
      'JOIN snt_place sp ON sp.IDsp = ob.obPlaceID'
      'JOIN snt_settlement snt ON snt.IDsns = sp.spSettlementID'
      'WHERE ob.IDob = :IDob'
      'LIMIT 1')
    Left = 48
    Top = 152
  end
  object DS_ObjectCard: TDataSource
    DataSet = Q_ObjectCard
    Left = 192
    Top = 152
  end
  object Q_ObjectPhoto: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'IDob'
        DataType = ftInteger
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '  IDph,'
      '  phObjectID,'
      '  phIsMain,'
      '  phFileName,'
      '  phMime,'
      '  CAST(phSize AS SIGNED) AS phSize,'
      '  phUploadedAt AS phCreatedAt'
      'FROM q_v_object_photo_blob'
      'WHERE phObjectID = :IDob'
      'ORDER BY phIsMain DESC, phUploadedAt DESC, IDph DESC')
    Left = 48
    Top = 272
  end
  object DS_ObjectPhoto: TDataSource
    DataSet = Q_ObjectPhoto
    Left = 192
    Top = 272
  end
  object Q_ObjectChar: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'IDob'
        DataType = ftInteger
        Value = Null
      end>
    SQL.Strings = (
      'SELECT *'
      'FROM q_v_object_char_detail'
      'WHERE IDob = :IDob'
      'ORDER BY ctName')
    Left = 48
    Top = 328
  end
  object DS_ObjectChar: TDataSource
    DataSet = Q_ObjectChar
    Left = 192
    Top = 328
  end
  object Q_ObjectUtility: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'IDob'
        DataType = ftInteger
        Value = Null
      end>
    SQL.Strings = (
      'SELECT *'
      'FROM q_v_object_utility'
      'WHERE IDob = :IDob'
      'ORDER BY utName')
    Left = 48
    Top = 384
  end
  object DS_ObjectUtility: TDataSource
    DataSet = Q_ObjectUtility
    Left = 192
    Top = 384
  end
  object Q_ObjectMaterial: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'IDob'
        DataType = ftInteger
        Value = Null
      end>
    SQL.Strings = (
      'SELECT *'
      'FROM q_v_object_material'
      'WHERE IDob = :IDob'
      'ORDER BY mtName')
    Left = 48
    Top = 440
  end
  object DS_ObjectMaterial: TDataSource
    DataSet = Q_ObjectMaterial
    Left = 192
    Top = 440
  end
  object Q_Status: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '  IDos,'
      '  osName'
      'FROM object_status'
      'ORDER BY osName')
    Left = 336
    Top = 96
  end
  object DS_Status: TDataSource
    DataSet = Q_Status
    Left = 480
    Top = 96
  end
  object Q_Settlement: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '  IDsns,'
      '  snsName'
      'FROM snt_settlement'
      'ORDER BY snsName')
    Left = 336
    Top = 152
  end
  object DS_Settlement: TDataSource
    DataSet = Q_Settlement
    Left = 480
    Top = 152
  end
  object Q_Place: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '  IDsp,'
      '  spCadastral,'
      '  spAddress,'
      '  spSettlementID'
      'FROM snt_place'
      'ORDER BY IDsp')
    Left = 336
    Top = 208
  end
  object DS_Place: TDataSource
    DataSet = Q_Place
    Left = 480
    Top = 208
  end
  object Q_Employee: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '  e.IDemp,'
      '  e.empFIO'
      'FROM employee e'
      'ORDER BY e.empFIO, e.IDemp')
    Left = 336
    Top = 272
  end
  object DS_Employee: TDataSource
    DataSet = Q_Employee
    Left = 480
    Top = 272
  end
  object Q_EmployeeDir: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '  IDemp,'
      '  empFIO,'
      '  empPhone,'
      '  empEmail,'
      '  empPositionID,'
      '  empIsActive'
      'FROM employee'
      'ORDER BY empFIO, IDemp')
    Left = 336
    Top = 776
  end
  object DS_EmployeeDir: TDataSource
    DataSet = Q_EmployeeDir
    Left = 480
    Top = 776
  end
  object Q_EmployeeEditOne: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'pID'
        DataType = ftInteger
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '  IDemp,'
      '  empFIO,'
      '  empPhone,'
      '  empEmail,'
      '  empPositionID,'
      '  empIsActive'
      'FROM employee'
      'WHERE IDemp = :pID'
      'LIMIT 1')
    Left = 640
    Top = 776
  end
  object DS_EmployeeEditOne: TDataSource
    DataSet = Q_EmployeeEditOne
    Left = 808
    Top = 776
  end
  object Q_EmployeePositionDir: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '  IDep,'
      '  epName'
      'FROM employee_position'
      'ORDER BY epName')
    Left = 1000
    Top = 320
  end
  object DS_EmployeePositionDir: TDataSource
    DataSet = Q_EmployeePositionDir
    Left = 1168
    Top = 320
  end
  object Q_Client: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT *'
      'FROM client'
      'ORDER BY clFIO, IDcl')
    Left = 336
    Top = 328
  end
  object DS_Client: TDataSource
    DataSet = Q_Client
    Left = 480
    Top = 328
  end
  object Q_ObjectEdit: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'pID'
        DataType = ftInteger
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '  IDob,'
      '  obName,'
      '  obPrice,'
      '  obStatusID,'
      '  obPlaceID,'
      '  obTotalArea,'
      '  obFloors'
      'FROM `object`'
      'WHERE IDob = :pID'
      'LIMIT 1')
    Left = 336
    Top = 384
  end
  object DS_ObjectEdit: TDataSource
    DataSet = Q_ObjectEdit
    Left = 480
    Top = 384
  end
  object Q_UtilityType: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT IDut, utName'
      'FROM utility_type'
      'ORDER BY utName')
    Left = 336
    Top = 440
  end
  object DS_UtilityType: TDataSource
    DataSet = Q_UtilityType
    Left = 480
    Top = 440
  end
  object Q_CharacteristicType: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT IDct, ctName, ctValueType'
      'FROM characteristic_type'
      'ORDER BY ctName')
    Left = 336
    Top = 496
  end
  object DS_CharacteristicType: TDataSource
    DataSet = Q_CharacteristicType
    Left = 480
    Top = 496
  end
  object Q_MaterialType: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT IDmt, mtName'
      'FROM material_type'
      'ORDER BY mtName')
    Left = 336
    Top = 552
  end
  object DS_MaterialType: TDataSource
    DataSet = Q_MaterialType
    Left = 480
    Top = 552
  end
  object Q_ClientEdit: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT *'
      'FROM client'
      'ORDER BY IDcl')
    Left = 336
    Top = 608
  end
  object DS_ClientEdit: TDataSource
    DataSet = Q_ClientEdit
    Left = 480
    Top = 608
  end
  object Q_ContractList: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'pDateFrom1'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pDateFrom2'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pDateTo1'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pDateTo2'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pConStatus1'
        DataType = ftWideString
        Size = 64
        Value = Null
      end
      item
        Name = 'pConStatus2'
        DataType = ftWideString
        Size = 64
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '  IDcon,'
      '  conNumber,'
      '  conDate,'
      '  conStatus,'
      '  conStatus AS conStatusCode,'
      '  conSum,'
      '  conPrepay,'
      '  conDebt,'
      '  conComment,'
      '  IDcl,'
      '  clFIO,'
      '  clPhone,'
      '  clEmail,'
      '  IDemp,'
      '  empFIO,'
      '  empPhone,'
      '  empEmail,'
      '  IDob,'
      '  obCode,'
      '  obName,'
      '  osName,'
      '  snsName,'
      '  spStreet,'
      '  spPlotNo'
      'FROM q_v_contract_list'
      'WHERE'
      '  (:pDateFrom1 IS NULL OR conDate >= :pDateFrom2)'
      '  AND (:pDateTo1 IS NULL OR conDate <= :pDateTo2)'
      '  AND (:pConStatus1 IS NULL OR conStatus = :pConStatus2)'
      'ORDER BY conDate DESC, IDcon DESC')
    Left = 48
    Top = 208
  end
  object DS_ContractList: TDataSource
    DataSet = Q_ContractList
    Left = 192
    Top = 496
  end
  object Q_ContractEdit: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'pID'
        DataType = ftInteger
        Value = Null
      end>
    SQL.Strings = (
      'SELECT *'
      'FROM contract'
      'WHERE IDcon = :pID'
      'LIMIT 1')
    Left = 336
    Top = 664
  end
  object DS_ContractEdit: TDataSource
    DataSet = Q_ContractEdit
    Left = 480
    Top = 664
  end
  object Q_CharacteristicTypeEdit: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT IDct, ctName, ctValueType'
      'FROM characteristic_type'
      'ORDER BY ctName')
    Left = 640
    Top = 96
  end
  object DS_CharacteristicTypeEdit: TDataSource
    DataSet = Q_CharacteristicTypeEdit
    Left = 808
    Top = 96
  end
  object Q_UtilityTypeEdit: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT IDut, utName'
      'FROM utility_type'
      'ORDER BY utName')
    Left = 640
    Top = 152
  end
  object DS_UtilityTypeEdit: TDataSource
    DataSet = Q_UtilityTypeEdit
    Left = 808
    Top = 152
  end
  object Q_MaterialTypeEdit: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT IDmt, mtName'
      'FROM material_type'
      'ORDER BY mtName')
    Left = 640
    Top = 208
  end
  object DS_MaterialTypeEdit: TDataSource
    DataSet = Q_MaterialTypeEdit
    Left = 808
    Top = 208
  end
  object Q_SettlementEdit: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT IDsns, snsName'
      'FROM snt_settlement'
      'ORDER BY snsName')
    Left = 640
    Top = 264
  end
  object DS_SettlementEdit: TDataSource
    DataSet = Q_SettlementEdit
    Left = 808
    Top = 264
  end
  object Q_PlaceEdit: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'IDsns'
        DataType = ftInteger
        Value = Null
      end>
    SQL.Strings = (
      'SELECT IDsp, spSettlementID, spAddress, spArea, spCadastral'
      'FROM snt_place'
      'WHERE spSettlementID = :IDsns'
      'ORDER BY IDsp')
    Left = 640
    Top = 320
  end
  object DS_PlaceEdit: TDataSource
    DataSet = Q_PlaceEdit
    Left = 808
    Top = 320
  end
  object Q_StatusEdit: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '  IDos,'
      '  osName'
      'FROM object_status'
      'ORDER BY osName')
    Left = 640
    Top = 348
  end
  object DS_StatusEdit: TDataSource
    DataSet = Q_StatusEdit
    Left = 808
    Top = 348
  end
  object Q_GlobalSearch: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'pQ1'
        DataType = ftWideString
        Size = 255
        Value = Null
      end
      item
        Name = 'pQ2'
        DataType = ftWideString
        Size = 255
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '  entity_type AS entityType,'
      '  entity_id AS entityId,'
      '  title,'
      '  subtitle,'
      '  search_text AS searchText'
      'FROM q_v_global_search'
      'WHERE'
      '  (:pQ1 IS NULL OR search_text LIKE :pQ2)'
      'ORDER BY entity_type, title, entity_id DESC'
      'LIMIT 500')
    Left = 640
    Top = 376
  end
  object DS_GlobalSearch: TDataSource
    DataSet = Q_GlobalSearch
    Left = 808
    Top = 376
  end
  object Q_RepObjectList: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT *'
      'FROM q_v_rep_object_list')
    Left = 640
    Top = 432
  end
  object DS_RepObjectList: TDataSource
    DataSet = Q_RepObjectList
    Left = 808
    Top = 432
  end
  object Q_RepContractList: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT *'
      'FROM q_v_rep_contract_list')
    Left = 640
    Top = 488
  end
  object DS_RepContractList: TDataSource
    DataSet = Q_RepContractList
    Left = 808
    Top = 488
  end
  object Q_RepObjGroupSntStatus: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'pSnt1'
        DataType = ftWideString
        Size = 120
        Value = Null
      end
      item
        Name = 'pSnt2'
        DataType = ftWideString
        Size = 120
        Value = Null
      end
      item
        Name = 'pStatus1'
        DataType = ftWideString
        Size = 80
        Value = Null
      end
      item
        Name = 'pStatus2'
        DataType = ftWideString
        Size = 80
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '  snt_name,'
      '  status_name,'
      '  cnt_objects,'
      '  price_min,'
      '  price_max,'
      '  price_avg'
      'FROM q_v_rep_obj_group_snt_status'
      'WHERE'
      '  (:pSnt1 IS NULL OR snt_name = :pSnt2)'
      '  AND (:pStatus1 IS NULL OR status_name = :pStatus2)'
      'ORDER BY snt_name, status_name')
    Left = 640
    Top = 544
  end
  object DS_RepObjGroupSntStatus: TDataSource
    DataSet = Q_RepObjGroupSntStatus
    Left = 808
    Top = 544
  end
  object Q_RepContractGroupPeriod: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'pDateFrom1'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pDateFrom2'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pDateTo1'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pDateTo2'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pConStatus1'
        DataType = ftWideString
        Size = 64
        Value = Null
      end
      item
        Name = 'pConStatus2'
        DataType = ftWideString
        Size = 64
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '  YEAR(conDate) AS y,'
      '  MONTH(conDate) AS m,'
      '  conStatus,'
      '  conStatus AS conStatusCode,'
      '  COUNT(0) AS cnt_contracts,'
      '  SUM(conSum) AS sum_contracts'
      'FROM q_v_contract_list'
      'WHERE'
      '  (:pDateFrom1 IS NULL OR conDate >= :pDateFrom2)'
      '  AND (:pDateTo1 IS NULL OR conDate <= :pDateTo2)'
      '  AND (:pConStatus1 IS NULL OR conStatus = :pConStatus2)'
      'GROUP BY YEAR(conDate), MONTH(conDate), conStatus'
      'ORDER BY y DESC, m DESC, conStatusCode')
    Left = 640
    Top = 600
  end
  object DS_RepContractGroupPeriod: TDataSource
    DataSet = Q_RepContractGroupPeriod
    Left = 808
    Top = 600
  end
  object Q_RepObjMaster: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'pStatus1'
        DataType = ftWideString
        Size = 80
        Value = Null
      end
      item
        Name = 'pStatus2'
        DataType = ftWideString
        Size = 80
        Value = Null
      end
      item
        Name = 'pSnt1'
        DataType = ftWideString
        Size = 120
        Value = Null
      end
      item
        Name = 'pSnt2'
        DataType = ftWideString
        Size = 120
        Value = Null
      end
      item
        Name = 'pPriceMin1'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = 'pPriceMin2'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = 'pPriceMax1'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = 'pPriceMax2'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = 'pOnlyFree'
        DataType = ftInteger
        Value = 0
      end>
    SQL.Strings = (
      'SELECT'
      '  ob.IDob,'
      '  ob.obCode,'
      '  ob.obName,'
      '  ob.obPrice,'
      '  os.osName AS obStatus,'
      '  snt.snsName AS sntName,'
      '  ob.obTotalArea,'
      '  ob.obRooms,'
      '  ob.obFloors'
      'FROM `object` ob'
      'JOIN object_status os ON os.IDos = ob.obStatusID'
      'JOIN snt_place sp ON sp.IDsp = ob.obPlaceID'
      'JOIN snt_settlement snt ON snt.IDsns = sp.spSettlementID'
      'WHERE'
      '  (:pStatus1 IS NULL OR os.osName = :pStatus2)'
      '  AND (:pSnt1 IS NULL OR snt.snsName = :pSnt2)'
      '  AND (:pPriceMin1 IS NULL OR ob.obPrice >= :pPriceMin2)'
      '  AND (:pPriceMax1 IS NULL OR ob.obPrice <= :pPriceMax2)'
      '  AND (:pOnlyFree = 0 OR os.osName = '#39#1057#1074#1086#1073#1086#1076#1077#1085#39')'
      'ORDER BY ob.IDob DESC')
    Left = 640
    Top = 656
  end
  object DS_RepObjMaster: TDataSource
    DataSet = Q_RepObjMaster
    Left = 808
    Top = 656
  end
  object Q_RepObjCharDetail: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'IDob'
        DataType = ftInteger
        Value = Null
      end>
    SQL.Strings = (
      'SELECT *'
      'FROM q_v_object_char_detail'
      'WHERE IDob = :IDob'
      'ORDER BY ctName, IDoc')
    Left = 640
    Top = 712
  end
  object DS_RepObjCharDetail: TDataSource
    DataSet = Q_RepObjCharDetail
    Left = 808
    Top = 712
  end
  object Q_ChartSalesMonth: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT *'
      'FROM q_v_chart_sales_by_month')
    Left = 1000
    Top = 96
  end
  object DS_ChartSalesMonth: TDataSource
    DataSet = Q_ChartSalesMonth
    Left = 1168
    Top = 96
  end
  object Q_ChartStatusStruct: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT *'
      'FROM q_v_chart_status_structure')
    Left = 1000
    Top = 152
  end
  object DS_ChartStatusStruct: TDataSource
    DataSet = Q_ChartStatusStruct
    Left = 1168
    Top = 152
  end
  object Q_ChartAvgPriceSnt: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    SQL.Strings = (
      'SELECT *'
      'FROM q_v_chart_avg_price_by_snt')
    Left = 1000
    Top = 208
  end
  object DS_ChartAvgPriceSnt: TDataSource
    DataSet = Q_ChartAvgPriceSnt
    Left = 1168
    Top = 208
  end
  object Q_ChartSalesDyn: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'pDateFrom1'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pDateFrom2'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pDateTo1'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pDateTo2'
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = 'pSnt1'
        DataType = ftWideString
        Size = 255
        Value = Null
      end
      item
        Name = 'pSnt2'
        DataType = ftWideString
        Size = 255
        Value = Null
      end
      item
        Name = 'pConStatus1'
        DataType = ftWideString
        Size = 64
        Value = Null
      end
      item
        Name = 'pConStatus2'
        DataType = ftWideString
        Size = 64
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '  YEAR(conDate) AS y,'
      '  MONTH(conDate) AS m,'
      
        '  CONCAT(YEAR(conDate), '#39'-'#39', LPAD(MONTH(conDate), 2, '#39'0'#39')) AS ym' +
        ','
      '  COUNT(0) AS cnt_contracts,'
      '  SUM(conSum) AS sum_sales'
      'FROM q_v_contract_list'
      'WHERE'
      '  (:pDateFrom1 IS NULL OR conDate >= :pDateFrom2)'
      '  AND (:pDateTo1 IS NULL OR conDate <= :pDateTo2)'
      '  AND (:pSnt1 IS NULL OR snsName = :pSnt2)'
      '  AND (:pConStatus1 IS NULL OR conStatus = :pConStatus2)'
      
        'GROUP BY YEAR(conDate), MONTH(conDate), CONCAT(YEAR(conDate), '#39'-' +
        #39', LPAD(MONTH(conDate), 2, '#39'0'#39'))'
      'ORDER BY y, m')
    Left = 1000
    Top = 264
  end
  object DS_ChartSalesDyn: TDataSource
    DataSet = Q_ChartSalesDyn
    Left = 1168
    Top = 264
  end
  object Q_ObjectPick: TADOQuery
    Connection = Con_Main
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'pSnt1'
        DataType = ftString
        Size = 150
        Value = Null
      end
      item
        Name = 'pSnt2'
        DataType = ftString
        Size = 150
        Value = Null
      end
      item
        Name = 'pStatus1'
        DataType = ftString
        Size = 50
        Value = Null
      end
      item
        Name = 'pStatus2'
        DataType = ftString
        Size = 50
        Value = Null
      end>
    SQL.Strings = (
      'SELECT'
      '  ob.IDob,'
      '  ob.obCode,'
      '  ob.obName,'
      
        '  CONCAT(ob.obCode, '#39' - '#39', ob.obName, '#39' ('#39', snt.snsName, '#39')'#39') AS' +
        ' obDisplay,'
      '  ob.obPrice,'
      '  ob.obPrice,'
      '  os.osName AS osName,'
      '  snt.snsName AS sntName'
      'FROM `object` ob'
      'JOIN object_status os ON os.IDos = ob.obStatusID'
      'JOIN snt_place sp ON sp.IDsp = ob.obPlaceID'
      'JOIN snt_settlement snt ON snt.IDsns = sp.spSettlementID'
      'WHERE'
      '  (:pSnt1 IS NULL OR snt.snsName = :pSnt2)'
      '  AND (:pStatus1 IS NULL OR os.osName = :pStatus2)'
      'ORDER BY ob.IDob DESC')
    Left = 336
    Top = 720
  end
  object DS_ObjectPick: TDataSource
    DataSet = Q_ObjectPick
    Left = 480
    Top = 720
  end
  object Q_Exec: TADOQuery
    Connection = Con_Main
    Parameters = <>
    Left = 48
    Top = 496
  end
  object Cmd_RecalcObjectStatus: TADOCommand
    CommandText = 'sp_recalc_object_status'
    CommandType = cmdStoredProc
    Connection = Con_Main
    Parameters = <
      item
        Name = 'p_object_id'
        DataType = ftInteger
        Value = Null
      end>
    Left = 192
    Top = 496
  end
end
