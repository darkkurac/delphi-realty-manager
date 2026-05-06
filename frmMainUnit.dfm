object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Kairos Home - '#1087#1088#1086#1076#1072#1078#1080' '#1085#1077#1076#1074#1080#1078#1080#1084#1086#1089#1090#1080
  ClientHeight = 520
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Menu = mmMain
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object sbMain: TStatusBar
    Left = 0
    Top = 501
    Width = 900
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitTop = 493
    ExplicitWidth = 898
  end
  object mmMain: TMainMenu
    Left = 552
    Top = 8
    object miDirectories: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      object miDirUtilityType: TMenuItem
        Caption = #1042#1080#1076#1099' '#1082#1086#1084#1084#1091#1085#1072#1083#1100#1085#1099#1093' '#1091#1089#1083#1091#1075
        OnClick = miDirUtilityTypeClick
      end
      object miDirCharacteristicType: TMenuItem
        Caption = #1042#1080#1076#1099' '#1093#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082
        OnClick = miDirCharacteristicTypeClick
      end
      object miDirMaterialType: TMenuItem
        Caption = #1052#1072#1090#1077#1088#1080#1072#1083#1099
        OnClick = miDirMaterialTypeClick
      end
      object miDirSnt: TMenuItem
        Caption = #1057#1053#1058
        OnClick = miDirSntClick
      end
      object miEmployees: TMenuItem
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
        OnClick = miEmployeesClick
      end
    end
    object miObjects: TMenuItem
      Caption = #1054#1073#1098#1077#1082#1090#1099
      object miObjList: TMenuItem
        Caption = #1057#1087#1080#1089#1086#1082
        OnClick = miObjListClick
      end
      object miObjCard: TMenuItem
        Caption = #1050#1072#1088#1090#1086#1095#1082#1072
        OnClick = miObjCardClick
      end
    end
    object miSales: TMenuItem
      Caption = #1055#1088#1086#1076#1072#1078#1080
      object miClients: TMenuItem
        Caption = #1050#1083#1080#1077#1085#1090#1099
        OnClick = miClientsClick
      end
      object miContracts: TMenuItem
        Caption = #1044#1086#1075#1086#1074#1086#1088#1099
        OnClick = miContractsClick
      end
    end
    object miReports: TMenuItem
      Caption = #1054#1090#1095#1105#1090#1099
      object miRepObjectList: TMenuItem
        Caption = #1057#1087#1080#1089#1086#1082' '#1086#1073#1098#1077#1082#1090#1086#1074
        OnClick = miRepObjectListClick
      end
      object miRepContractList: TMenuItem
        Caption = #1057#1087#1080#1089#1086#1082' '#1076#1086#1075#1086#1074#1086#1088#1099
        OnClick = miRepContractListClick
      end
      object miRepObjGroup: TMenuItem
        Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072' '#1086#1073#1098#1077#1082#1090#1086#1074
        OnClick = miRepObjGroupClick
      end
      object miRepContractPeriod: TMenuItem
        Caption = #1044#1086#1075#1086#1074#1086#1088#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
        OnClick = miRepContractPeriodClick
      end
      object miRepObjCharMD: TMenuItem
        Caption = #1061#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1080' ('#1075#1083#1072#1074#1085#1086#1077'-'#1087#1086#1076#1095#1080#1085#1077#1085#1085#1086#1077')'
        OnClick = miRepObjCharMDClick
      end
    end
    object miCharts: TMenuItem
      Caption = #1043#1088#1072#1092#1080#1082#1080
      object miChartSales: TMenuItem
        Caption = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
        OnClick = miChartSalesClick
      end
      object miChartStatuses: TMenuItem
        Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1072' '#1089#1090#1072#1090#1091#1089#1086#1074
        OnClick = miChartStatusesClick
      end
      object miChartAvgPriceLoc: TMenuItem
        Caption = #1057#1088#1077#1076#1085#1103#1103' '#1094#1077#1085#1072' '#1087#1086' '#1083#1086#1082#1072#1094#1080#1103#1084
        OnClick = miChartAvgPriceLocClick
      end
      object miChartSalesDyn: TMenuItem
        Caption = #1055#1088#1086#1076#1072#1078#1080' ('#1076#1080#1085#1072#1084#1080#1082#1072', '#1092#1080#1083#1100#1090#1088#1099')'
        OnClick = miChartSalesDynClick
      end
    end
    object miAdmin: TMenuItem
      Caption = #1040#1076#1084#1080#1085#1080#1089#1090#1088#1080#1088#1086#1074#1072#1085#1080#1077
      object miLogout: TMenuItem
        Caption = #1057#1084#1077#1085#1080#1090#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
        OnClick = miLogoutClick
      end
      object miExit: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = miExitClick
      end
    end
    object miHelp: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object miAbout: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = miAboutClick
      end
      object miGlobalSearch: TMenuItem
        Caption = #1055#1086#1080#1089#1082
        OnClick = miGlobalSearchClick
      end
    end
  end
end
