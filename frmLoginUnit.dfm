object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1042#1093#1086#1076
  ClientHeight = 425
  ClientWidth = 620
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblUser: TLabel
    Left = 248
    Top = 40
    Width = 77
    Height = 15
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
  end
  object lblPass: TLabel
    Left = 200
    Top = 128
    Width = 42
    Height = 15
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object lblDsn: TLabel
    Left = 110
    Top = 168
    Width = 132
    Height = 15
    Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1076#1072#1085#1085#1099#1093' (DSN)'
  end
  object edtUser: TEdit
    Left = 248
    Top = 85
    Width = 121
    Height = 23
    TabOrder = 0
  end
  object edtPass: TEdit
    Left = 248
    Top = 125
    Width = 121
    Height = 23
    PasswordChar = '*'
    TabOrder = 1
  end
  object cbDsn: TComboBox
    Left = 248
    Top = 165
    Width = 145
    Height = 23
    Style = csDropDownList
    TabOrder = 2
    Items.Strings = (
      'kairos_realty_dsn_admin_user'
      'kairos_realty_dsn_realtor_user')
  end
  object btnLogin: TButton
    Left = 248
    Top = 224
    Width = 75
    Height = 25
    Caption = #1042#1086#1081#1090#1080
    TabOrder = 3
    OnClick = btnLoginClick
  end
  object btnExit: TButton
    Left = 248
    Top = 272
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 4
    OnClick = btnExitClick
  end
end
