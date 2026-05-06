object frmChartSalesDyn: TfrmChartSalesDyn
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1043#1088#1072#1092#1080#1082': '#1087#1088#1086#1076#1072#1078#1080' ('#1076#1080#1085#1072#1084#1080#1082#1072', '#1092#1080#1083#1100#1090#1088#1099')'
  ClientHeight = 600
  ClientWidth = 980
  Constraints.MinHeight = 500
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
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    Caption = ''
    TabOrder = 0
    object lblFrom: TLabel
      Left = 12
      Top = 8
      Width = 19
      Height = 15
      Caption = #1054#1090
    end
    object lblTo: TLabel
      Left = 132
      Top = 8
      Width = 21
      Height = 15
      Caption = #1044#1086
    end
    object lblSnt: TLabel
      Left = 312
      Top = 8
      Width = 23
      Height = 15
      Caption = #1057#1053#1058
    end
    object lblStatus: TLabel
      Left = 552
      Top = 8
      Width = 36
      Height = 15
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object dtFrom: TDateTimePicker
      Left = 12
      Top = 26
      Width = 110
      Height = 23
      Date = 0
      TabOrder = 0
    end
    object dtTo: TDateTimePicker
      Left = 132
      Top = 26
      Width = 110
      Height = 23
      Date = 0
      TabOrder = 1
    end
    object chkNoDates: TCheckBox
      Left = 252
      Top = 30
      Width = 55
      Height = 17
      Caption = #1042#1089#1077
      TabOrder = 2
      OnClick = chkNoDatesClick
    end
    object lcbSnt: TDBLookupComboBox
      Left = 312
      Top = 26
      Width = 230
      Height = 23
      TabOrder = 3
    end
    object lcbStatus: TDBLookupComboBox
      Left = 552
      Top = 26
      Width = 210
      Height = 23
      TabOrder = 4
    end
    object btnApply: TButton
      Left = 846
      Top = 24
      Width = 120
      Height = 29
      Anchors = [akTop, akRight]
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      TabOrder = 5
      OnClick = btnApplyClick
    end
    object btnClose: TButton
      Left = 846
      Top = 4
      Width = 120
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 6
      OnClick = btnCloseClick
    end
  end
  object pbChart: TPaintBox
    Left = 0
    Top = 70
    Width = 980
    Height = 530
    Align = alClient
    OnPaint = pbChartPaint
  end
end