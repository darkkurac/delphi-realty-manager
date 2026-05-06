object frmEmployeeCard: TfrmEmployeeCard
  Left = 0
  Top = 0
  Caption = #1050#1072#1088#1090#1086#1095#1082#1072' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
  ClientHeight = 255
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 13
  object lblFIO: TLabel
    Left = 24
    Top = 24
    Width = 24
    Height = 13
    Caption = #1060#1048#1054
  end
  object lblPhone: TLabel
    Left = 24
    Top = 64
    Width = 47
    Height = 13
    Caption = #1058#1077#1083#1077#1092#1086#1085
  end
  object lblEmail: TLabel
    Left = 24
    Top = 104
    Width = 31
    Height = 13
    Caption = 'E-mail'
  end
  object lblPosition: TLabel
    Left = 24
    Top = 140
    Width = 60
    Height = 13
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object edtFIO: TDBEdit
    Left = 120
    Top = 20
    Width = 360
    Height = 21
    TabOrder = 0
  end
  object edtPhone: TDBEdit
    Left = 120
    Top = 60
    Width = 360
    Height = 21
    TabOrder = 1
  end
  object edtEmail: TDBEdit
    Left = 120
    Top = 100
    Width = 360
    Height = 21
    TabOrder = 2
  end
  object cbPosition: TDBLookupComboBox
    Left = 120
    Top = 140
    Width = 360
    Height = 21
    TabOrder = 3
  end
  object chkActive: TDBCheckBox
    Left = 120
    Top = 176
    Width = 145
    Height = 17
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' '#1072#1082#1090#1080#1074#1077#1085
    TabOrder = 4
  end
  object pBottom: TPanel
    Left = 0
    Top = 214
    Width = 520
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    object btnSave: TButton
      Left = 304
      Top = 6
      Width = 96
      Height = 27
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 408
      Top = 6
      Width = 96
      Height = 27
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
