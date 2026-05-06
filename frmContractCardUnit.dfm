object frmContractCard: TfrmContractCard
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1050#1072#1088#1090#1086#1095#1082#1072' '#1076#1086#1075#1086#1074#1086#1088#1072
  ClientHeight = 420
  ClientWidth = 720
  Constraints.MinHeight = 420
  Constraints.MinWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  TextHeight = 15
  object lblNumber: TLabel
    Left = 24
    Top = 18
    Width = 38
    Height = 15
    Caption = #1053#1086#1084#1077#1088
  end
  object lblDate: TLabel
    Left = 24
    Top = 62
    Width = 25
    Height = 15
    Caption = #1044#1072#1090#1072
  end
  object lblClient: TLabel
    Left = 24
    Top = 106
    Width = 39
    Height = 15
    Caption = #1050#1083#1080#1077#1085#1090
  end
  object lblEmployee: TLabel
    Left = 24
    Top = 150
    Width = 59
    Height = 15
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object lblObject: TLabel
    Left = 24
    Top = 194
    Width = 40
    Height = 15
    Caption = #1054#1073#1098#1077#1082#1090
  end
  object lblSum: TLabel
    Left = 24
    Top = 238
    Width = 38
    Height = 15
    Caption = #1057#1091#1084#1084#1072
  end
  object lblPrepay: TLabel
    Left = 24
    Top = 282
    Width = 66
    Height = 15
    Caption = #1055#1088#1077#1076#1086#1087#1083#1072#1090#1072
  end
  object lblStatus: TLabel
    Left = 24
    Top = 325
    Width = 36
    Height = 15
    Caption = #1057#1090#1072#1090#1091#1089
  end
  object lblComment: TLabel
    Left = 360
    Top = 238
    Width = 77
    Height = 15
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
  end
  object edNumber: TDBEdit
    Left = 120
    Top = 14
    Width = 220
    Height = 23
    TabOrder = 0
  end
  object edDate: TDBEdit
    Left = 120
    Top = 58
    Width = 220
    Height = 23
    TabOrder = 1
  end
  object cbClient: TDBLookupComboBox
    Left = 120
    Top = 102
    Width = 560
    Height = 23
    TabOrder = 2
  end
  object cbEmployee: TDBLookupComboBox
    Left = 120
    Top = 146
    Width = 560
    Height = 23
    TabOrder = 3
  end
  object cbObject: TDBLookupComboBox
    Left = 120
    Top = 190
    Width = 560
    Height = 23
    TabOrder = 4
  end
  object edSum: TDBEdit
    Left = 120
    Top = 234
    Width = 220
    Height = 23
    TabOrder = 5
  end
  object edPrepay: TDBEdit
    Left = 120
    Top = 278
    Width = 220
    Height = 23
    TabOrder = 6
  end
  object cbStatus: TComboBox
    Left = 120
    Top = 322
    Width = 220
    Height = 23
    Style = csDropDownList
    TabOrder = 7
  end
  object edComment: TDBEdit
    Left = 360
    Top = 258
    Width = 320
    Height = 23
    TabOrder = 8
  end
  object pButtons: TPanel
    Left = 0
    Top = 375
    Width = 720
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 9
    object btnPost: TButton
      Left = 456
      Top = 8
      Width = 120
      Height = 29
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 0
      OnClick = btnPostClick
    end
    object btnCancel: TButton
      Left = 584
      Top = 8
      Width = 110
      Height = 29
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end