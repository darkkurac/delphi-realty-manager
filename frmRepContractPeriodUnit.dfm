object frmRepContractPeriod: TfrmRepContractPeriod
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1105#1090': '#1044#1086#1075#1086#1074#1086#1088#1099' '#1087#1086' '#1087#1077#1088#1080#1086#1076#1091
  ClientHeight = 620
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
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 980
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblFrom: TLabel
      Left = 8
      Top = 6
      Width = 40
      Height = 15
      Caption = #1044#1072#1090#1072' '#1086#1090
    end
    object lblTo: TLabel
      Left = 146
      Top = 6
      Width = 41
      Height = 15
      Caption = #1044#1072#1090#1072' '#1076#1086
    end
    object dtFrom: TDateTimePicker
      Left = 8
      Top = 23
      Width = 120
      Height = 23
      Date = 46075.000000000000000000
      Time = 0.321215428237337600
      TabOrder = 0
    end
    object dtTo: TDateTimePicker
      Left = 146
      Top = 23
      Width = 120
      Height = 23
      Date = 46075.000000000000000000
      Time = 0.321467187503003500
      TabOrder = 1
    end
    object chkNoDates: TCheckBox
      Left = 284
      Top = 25
      Width = 92
      Height = 17
      Caption = #1041#1077#1079' '#1076#1072#1090
      TabOrder = 2
    end
    object btnRefresh: TButton
      Left = 392
      Top = 22
      Width = 110
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 3
      OnClick = btnRefreshClick
    end
    object btnExport: TButton
      Left = 508
      Top = 22
      Width = 110
      Height = 25
      Caption = #1069#1082#1089#1087#1086#1088#1090' CSV'
      TabOrder = 4
      OnClick = btnExportClick
    end
    object btnPrint: TButton
      Left = 624
      Top = 22
      Width = 70
      Height = 25
      Caption = #1055#1077#1095#1072#1090#1100
      TabOrder = 5
      OnClick = btnPrintClick
    end
    object btnClose: TButton
      Left = 700
      Top = 22
      Width = 90
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 6
      OnClick = btnCloseClick
    end
  end
  object grd: TDBGrid
    Left = 0
    Top = 52
    Width = 980
    Height = 568
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
        FieldName = 'y'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'm'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'conStatus'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'cnt_contracts'
        Width = 170
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'sum_contracts'
        Width = 180
        Visible = True
      end>
  end
  object sd: TSaveDialog
    Left = 824
    Top = 8
  end
end
