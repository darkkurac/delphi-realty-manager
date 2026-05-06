object frmRepObjGroup: TfrmRepObjGroup
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1054#1090#1095#1105#1090': '#1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072' '#1086#1073#1098#1077#1082#1090#1086#1074
  ClientHeight = 620
  ClientWidth = 980
  Constraints.MinHeight = 520
  Constraints.MinWidth = 860
  Color = clBtnFace
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
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 980
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
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
    object btnRefresh: TButton
      Left = 436
      Top = 24
      Width = 110
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 2
      OnClick = btnRefreshClick
    end
    object btnExport: TButton
      Left = 552
      Top = 24
      Width = 110
      Height = 25
      Caption = #1069#1082#1089#1087#1086#1088#1090' CSV'
      TabOrder = 3
      OnClick = btnExportClick
    end
    object btnPrint: TButton
      Left = 668
      Top = 24
      Width = 90
      Height = 25
      Caption = #1055#1077#1095#1072#1090#1100
      TabOrder = 4
      OnClick = btnPrintClick
    end
    object btnClose: TButton
      Left = 860
      Top = 24
      Width = 110
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 5
      OnClick = btnCloseClick
    end
    object lcbSnt: TDBLookupComboBox
      Left = 8
      Top = 24
      Width = 200
      Height = 23
      TabOrder = 0
    end
    object lcbStatus: TDBLookupComboBox
      Left = 220
      Top = 24
      Width = 200
      Height = 23
      TabOrder = 1
    end
  end
  object grd: TDBGrid
    Left = 0
    Top = 60
    Width = 980
    Height = 560
    Align = alClient
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'snt_name'
        Width = 220
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'status_name'
        Width = 160
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'cnt_objects'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'price_min'
        Width = 140
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'price_max'
        Width = 140
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'price_avg'
        Width = 140
        Visible = True
      end>
  end
  object sd: TSaveDialog
    Left = 824
    Top = 8
  end
end