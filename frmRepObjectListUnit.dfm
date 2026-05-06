object frmRepObjectList: TfrmRepObjectList
  Left = 0
  Top = 0
  ActiveControl = btnRefresh
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1054#1090#1095#1105#1090': '#1057#1087#1080#1089#1086#1082' '#1086#1073#1098#1077#1082#1090#1086#1074
  ClientHeight = 620
  ClientWidth = 1180
  Constraints.MinHeight = 520
  Constraints.MinWidth = 920
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
    Width = 1180
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btnRefresh: TButton
      Left = 8
      Top = 10
      Width = 120
      Height = 29
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btnRefreshClick
    end
    object btnExport: TButton
      Left = 136
      Top = 10
      Width = 140
      Height = 29
      Caption = #1069#1082#1089#1087#1086#1088#1090
      TabOrder = 1
      OnClick = btnExportClick
    end
    object btnPrint: TButton
      Left = 284
      Top = 10
      Width = 120
      Height = 29
      Caption = #1055#1077#1095#1072#1090#1100
      TabOrder = 2
      OnClick = btnPrintClick
    end
    object btnClose: TButton
      Left = 1052
      Top = 10
      Width = 120
      Height = 29
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 3
      OnClick = btnCloseClick
    end
  end
  object grd: TDBGrid
    Left = 0
    Top = 49
    Width = 1180
    Height = 571
    Align = alClient
    DataSource = dmMain.DS_RepObjectList
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
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
        FieldName = 'osName'
        Width = 110
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
        FieldName = 'snsRegion'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'snsDistrict'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'snsName'
        Width = 140
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
        FieldName = 'obShortAddress'
        Width = 240
        Visible = True
      end>
  end
  object sd: TSaveDialog
    Left = 824
    Top = 8
  end
end