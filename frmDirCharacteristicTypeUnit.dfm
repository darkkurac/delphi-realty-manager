object frmDirCharacteristicType: TfrmDirCharacteristicType
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1042#1080#1076#1099' '#1093#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082
  ClientHeight = 441
  ClientWidth = 624
  KeyPreview = True
  Position = poScreenCenter
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object grd: TDBGrid
    Left = 0
    Top = 45
    Width = 624
    Height = 396
    Align = alClient
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnTitleClick = grdTitleClick
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 45
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 622
    object btnInsert: TButton
      Left = 0
      Top = 11
      Width = 75
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btnInsertClick
    end
    object btnEdit: TButton
      Left = 104
      Top = 11
      Width = 75
      Height = 25
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 216
      Top = 11
      Width = 75
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnPost: TButton
      Left = 336
      Top = 11
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 3
      OnClick = btnPostClick
    end
    object btnCancel: TButton
      Left = 440
      Top = 11
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 4
      OnClick = btnCancelClick
    end
    object btnRefresh: TButton
      Left = 549
      Top = 11
      Width = 75
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 5
      OnClick = btnRefreshClick
    end
  end
end
