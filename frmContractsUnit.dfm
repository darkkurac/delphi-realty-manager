object frmContracts: TfrmContracts
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1044#1086#1075#1086#1074#1086#1088#1099
  ClientHeight = 660
  ClientWidth = 1280
  Constraints.MinHeight = 560
  Constraints.MinWidth = 1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object grdContracts: TDBGrid
    Left = 0
    Top = 102
    Width = 1280
    Height = 558
    Align = alClient
    DataSource = dmMain.DS_ContractList
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = grdContractsDblClick
    OnTitleClick = grdContractsTitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'conNumber'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'conDate'
        Width = 95
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'conStatus'
        Width = 95
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'conSum'
        Width = 110
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'conPrepay'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'conDebt'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'clFIO'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'empFIO'
        Width = 160
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'obCode'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'obName'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'osName'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'snsName'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'spStreet'
        Width = 140
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'spPlotNo'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'conComment'
        Width = 220
        Visible = True
      end>
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 1280
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btnInsert: TButton
      Left = 8
      Top = 10
      Width = 92
      Height = 29
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btnInsertClick
    end
    object btnEdit: TButton
      Left = 106
      Top = 10
      Width = 92
      Height = 29
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 204
      Top = 10
      Width = 92
      Height = 29
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnRefresh: TButton
      Left = 302
      Top = 10
      Width = 100
      Height = 29
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 3
      OnClick = btnRefreshClick
    end
    object btnCard: TButton
      Left = 408
      Top = 10
      Width = 110
      Height = 29
      Caption = #1050#1072#1088#1090#1086#1095#1082#1072
      TabOrder = 4
      OnClick = btnCardClick
    end
    object btnCloseContract: TButton
      Left = 540
      Top = 10
      Width = 145
      Height = 29
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1076#1086#1075#1086#1074#1086#1088
      TabOrder = 5
      OnClick = btnCloseContractClick
    end
    object btnCancelContract: TButton
      Left = 691
      Top = 10
      Width = 155
      Height = 29
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088
      TabOrder = 6
      OnClick = btnCancelContractClick
    end
  end
  object pFilter: TPanel
    Left = 0
    Top = 49
    Width = 1280
    Height = 53
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object chkUseFrom: TCheckBox
      Left = 8
      Top = 9
      Width = 70
      Height = 17
      Caption = #1044#1072#1090#1072' '#1089
      TabOrder = 0
    end
    object dtFrom: TDateTimePicker
      Left = 80
      Top = 7
      Width = 120
      Height = 23
      Date = 45200.000000000000000000
      Time = 45200.000000000000000000
      TabOrder = 1
    end
    object chkUseTo: TCheckBox
      Left = 216
      Top = 9
      Width = 75
      Height = 17
      Caption = #1044#1072#1090#1072' '#1087#1086
      TabOrder = 2
    end
    object dtTo: TDateTimePicker
      Left = 296
      Top = 7
      Width = 120
      Height = 23
      Date = 45200.000000000000000000
      Time = 45200.000000000000000000
      TabOrder = 3
    end
    object cbConStatus: TComboBox
      Left = 432
      Top = 7
      Width = 180
      Height = 23
      Style = csDropDownList
      TabOrder = 4
    end
    object btnApplyFilter: TButton
      Left = 628
      Top = 6
      Width = 120
      Height = 25
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      TabOrder = 5
      OnClick = btnApplyFilterClick
    end
    object btnClearFilter: TButton
      Left = 754
      Top = 6
      Width = 120
      Height = 25
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100
      TabOrder = 6
      OnClick = btnClearFilterClick
    end
  end
end