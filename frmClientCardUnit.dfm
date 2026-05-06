object frmClientCard: TfrmClientCard
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1050#1072#1088#1090#1086#1095#1082#1072' '#1082#1083#1080#1077#1085#1090#1072
  ClientHeight = 265
  ClientWidth = 620
  Color = clBtnFace
  Constraints.MinHeight = 265
  Constraints.MinWidth = 620
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  TextHeight = 15
  object lblFIO: TLabel
    Left = 40
    Top = 11
    Width = 27
    Height = 15
    Caption = #1060#1048#1054
  end
  object lblPhone: TLabel
    Left = 216
    Top = 11
    Width = 48
    Height = 15
    Caption = #1058#1077#1083#1077#1092#1086#1085
  end
  object lblEmail: TLabel
    Left = 408
    Top = 11
    Width = 52
    Height = 15
    Caption = #1069#1083'. '#1087#1086#1095#1090#1072
  end
  object lblPassport: TLabel
    Left = 40
    Top = 99
    Width = 47
    Height = 15
    Caption = #1055#1072#1089#1087#1086#1088#1090
  end
  object lblAddress: TLabel
    Left = 216
    Top = 99
    Width = 33
    Height = 15
    Caption = #1040#1076#1088#1077#1089
  end
  object lblNote: TLabel
    Left = 408
    Top = 99
    Width = 71
    Height = 15
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edFIO: TDBEdit
    Left = 40
    Top = 32
    Width = 160
    Height = 23
    TabOrder = 0
  end
  object edPhone: TDBEdit
    Left = 216
    Top = 32
    Width = 170
    Height = 23
    TabOrder = 1
  end
  object edEmail: TDBEdit
    Left = 408
    Top = 32
    Width = 180
    Height = 23
    TabOrder = 2
  end
  object edPassport: TDBEdit
    Left = 40
    Top = 120
    Width = 160
    Height = 23
    TabOrder = 3
  end
  object edAddress: TDBEdit
    Left = 216
    Top = 120
    Width = 170
    Height = 23
    TabOrder = 4
  end
  object edNote: TDBEdit
    Left = 408
    Top = 120
    Width = 180
    Height = 23
    TabOrder = 5
  end
  object pButtons: TPanel
    Left = 0
    Top = 220
    Width = 620
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    object btnPost: TButton
      Left = 360
      Top = 8
      Width = 110
      Height = 29
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 0
      OnClick = btnPostClick
    end
    object btnCancel: TButton
      Left = 480
      Top = 8
      Width = 100
      Height = 29
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
