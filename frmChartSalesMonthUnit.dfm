object frmChartSalesMonth: TfrmChartSalesMonth
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1043#1088#1072#1092#1080#1082': '#1087#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084
  ClientHeight = 560
  ClientWidth = 980
  Constraints.MinHeight = 460
  Constraints.MinWidth = 760
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
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    Caption = ''
    TabOrder = 0
    object btnRefresh: TButton
      Left = 12
      Top = 10
      Width = 110
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btnRefreshClick
    end
    object btnClose: TButton
      Left = 128
      Top = 10
      Width = 110
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
  object pbChart: TPaintBox
    Left = 0
    Top = 49
    Width = 980
    Height = 511
    Align = alClient
    OnPaint = pbChartPaint
  end
end