object frmObjects: TfrmObjects
  Left = 0
  Top = 0
  Caption = #1054#1073#1098#1077#1082#1090#1099
  ClientHeight = 560
  ClientWidth = 980
  Color = clBtnFace
  Constraints.MinHeight = 520
  Constraints.MinWidth = 860
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object pFilter: TPanel
    Left = 0
    Top = 0
    Width = 980
    Height = 76
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblFStatus: TLabel
      Left = 12
      Top = 8
      Width = 36
      Height = 15
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object lblFSnt: TLabel
      Left = 232
      Top = 8
      Width = 23
      Height = 15
      Caption = #1057#1053#1058
    end
    object lblPriceMin: TLabel
      Left = 452
      Top = 8
      Width = 54
      Height = 15
      Caption = #1062#1077#1085#1072' '#1084#1080#1085
    end
    object lblPriceMax: TLabel
      Left = 552
      Top = 8
      Width = 58
      Height = 15
      Caption = #1062#1077#1085#1072' '#1084#1072#1082#1089
    end
    object cbFStatus: TDBLookupComboBox
      Left = 12
      Top = 26
      Width = 210
      Height = 23
      TabOrder = 0
    end
    object cbFSnt: TDBLookupComboBox
      Left = 232
      Top = 26
      Width = 210
      Height = 23
      TabOrder = 1
    end
    object edPriceMin: TEdit
      Left = 452
      Top = 26
      Width = 90
      Height = 23
      TabOrder = 2
    end
    object edPriceMax: TEdit
      Left = 552
      Top = 26
      Width = 90
      Height = 23
      TabOrder = 3
    end
    object chkOnlyFree: TCheckBox
      Left = 652
      Top = 30
      Width = 150
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1089#1074#1086#1073#1086#1076#1085#1099#1077
      TabOrder = 4
    end
    object btnApplyFilter: TButton
      Left = 12
      Top = 48
      Width = 110
      Height = 25
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      TabOrder = 5
      OnClick = btnApplyFilterClick
    end
    object btnClearFilter: TButton
      Left = 128
      Top = 48
      Width = 110
      Height = 25
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100
      TabOrder = 6
      OnClick = btnClearFilterClick
    end
  end
  object pTop: TPanel
    Left = 0
    Top = 76
    Width = 980
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btnInsert: TButton
      Left = 12
      Top = 10
      Width = 90
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btnInsertClick
    end
    object btnEdit: TButton
      Left = 108
      Top = 10
      Width = 90
      Height = 25
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 204
      Top = 10
      Width = 90
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnRefresh: TButton
      Left = 300
      Top = 10
      Width = 100
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 3
      OnClick = btnRefreshClick
    end
    object btnCard: TButton
      Left = 406
      Top = 10
      Width = 100
      Height = 25
      Caption = #1050#1072#1088#1090#1086#1095#1082#1072
      TabOrder = 4
      OnClick = btnCardClick
    end
  end
  object grdObjects: TDBGrid
    Left = 0
    Top = 125
    Width = 980
    Height = 435
    Align = alClient
    DataSource = dmMain.DS_ObjectList
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = grdObjectsDblClick
    OnTitleClick = grdObjectsTitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'IDob'
        Title.Caption = 'ID'
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'obCode'
        Title.Caption = #1050#1086#1076
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'obName'
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 250
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'obPrice'
        Title.Caption = #1062#1077#1085#1072
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'obStatus'
        Title.Caption = #1057#1090#1072#1090#1091#1089
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'sntName'
        Title.Caption = #1057#1053#1058
        Width = 160
        Visible = True
      end>
  end
end
