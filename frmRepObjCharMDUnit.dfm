object frmRepObjCharMD: TfrmRepObjCharMD
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1054#1090#1095#1105#1090': '#1061#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1080' ('#1075#1083#1072#1074#1085#1086#1077'-'#1087#1086#1076#1095#1080#1085#1077#1085#1085#1086#1077')'
  ClientHeight = 680
  ClientWidth = 1180
  Color = clBtnFace
  Constraints.MinHeight = 560
  Constraints.MinWidth = 980
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
  object spl: TSplitter
    Left = 0
    Top = 396
    Width = 1180
    Height = 6
    Cursor = crVSplit
    Align = alTop
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 1180
    Height = 66
    Align = alTop
    BevelOuter = bvNone
    Caption = ''
    TabOrder = 0
    DesignSize = (
      1180
      66)
    object lblSnt: TLabel
      Left = 8
      Top = 7
      Width = 23
      Height = 15
      Caption = #1057#1053#1058
    end
    object lblStatus: TLabel
      Left = 220
      Top = 7
      Width = 36
      Height = 15
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object lblMin: TLabel
      Left = 432
      Top = 7
      Width = 54
      Height = 15
      Caption = #1062#1077#1085#1072' '#1084#1080#1085
    end
    object lblMax: TLabel
      Left = 538
      Top = 7
      Width = 58
      Height = 15
      Caption = #1062#1077#1085#1072' '#1084#1072#1082#1089
    end
    object lcbSnt: TDBLookupComboBox
      Left = 8
      Top = 29
      Width = 200
      Height = 23
      TabOrder = 0
    end
    object lcbStatus: TDBLookupComboBox
      Left = 220
      Top = 29
      Width = 200
      Height = 23
      TabOrder = 1
    end
    object edMin: TEdit
      Left = 432
      Top = 29
      Width = 96
      Height = 23
      TabOrder = 2
    end
    object edMax: TEdit
      Left = 538
      Top = 29
      Width = 96
      Height = 23
      TabOrder = 3
    end
    object chkOnlyFree: TCheckBox
      Left = 646
      Top = 33
      Width = 150
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1089#1074#1086#1073#1086#1076#1085#1099#1077
      TabOrder = 4
    end
    object btnApply: TButton
      Left = 1076
      Top = 28
      Width = 94
      Height = 27
      Anchors = [akTop, akRight]
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      TabOrder = 5
      OnClick = btnApplyClick
    end
    object btnExportMaster: TButton
      Left = 1076
      Top = 3
      Width = 94
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1069#1082#1089#1087#1086#1088#1090
      TabOrder = 6
      OnClick = btnExportMasterClick
    end
    object btnPrintMaster: TButton
      Left = 976
      Top = 3
      Width = 94
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1055#1077#1095#1072#1090#1100
      TabOrder = 7
      OnClick = btnPrintMasterClick
    end
    object btnClose: TButton
      Left = 876
      Top = 3
      Width = 94
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 8
      OnClick = btnCloseClick
    end
  end
  object grdMaster: TDBGrid
    Left = 0
    Top = 66
    Width = 1180
    Height = 330
    Align = alTop
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
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
        FieldName = 'obStatus'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'sntName'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'obPrice'
        Width = 110
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'obTotalArea'
        Width = 110
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'obRooms'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'obFloors'
        Width = 90
        Visible = True
      end>
  end
  object grdDetail: TDBGrid
    Left = 0
    Top = 402
    Width = 1180
    Height = 278
    Align = alClient
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ctName'
        Width = 220
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ctUnit'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ocValueNum'
        Width = 140
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ocValueText'
        Width = 320
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ocValueBool'
        Width = 120
        Visible = True
      end>
  end
  object sd: TSaveDialog
    Left = 856
    Top = 8
  end
end
