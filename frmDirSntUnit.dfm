object frmDirSnt: TfrmDirSnt
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1057#1053#1058
  ClientHeight = 520
  ClientWidth = 900
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
  object Splitter1: TSplitter
    Left = 0
    Top = 245
    Width = 624
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = -8
    ExplicitTop = 241
  end
  object grdSettlement: TDBGrid
    Left = 0
    Top = 45
    Width = 624
    Height = 200
    Align = alTop
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnCellClick = grdSettlementCellClick
    OnTitleClick = grdSettlementTitleClick
  end
  object grdPlace: TDBGrid
    Left = 0
    Top = 293
    Width = 624
    Height = 148
    Align = alClient
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnTitleClick = grdPlaceTitleClick
  end
  object pSetTop: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 45
    Align = alTop
    TabOrder = 2
    object btnSetInsert: TButton
      Left = 0
      Top = 8
      Width = 75
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btnSetInsertClick
    end
    object btnSetEdit: TButton
      Left = 104
      Top = 8
      Width = 75
      Height = 25
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      TabOrder = 1
      OnClick = btnSetEditClick
    end
    object btnSetDelete: TButton
      Left = 216
      Top = 8
      Width = 75
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = btnSetDeleteClick
    end
    object btnSetPost: TButton
      Left = 328
      Top = 8
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 3
      OnClick = btnSetPostClick
    end
    object btnSetCancel: TButton
      Left = 440
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 4
      OnClick = btnSetCancelClick
    end
    object btnSetRefresh: TButton
      Left = 549
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 5
      OnClick = btnSetRefreshClick
    end
  end
  object pPlaceTop: TPanel
    Left = 0
    Top = 248
    Width = 624
    Height = 45
    Align = alTop
    TabOrder = 3
    object btnPlInsert: TButton
      Left = 0
      Top = 6
      Width = 75
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btnPlInsertClick
    end
    object btnPlEdit: TButton
      Left = 104
      Top = 6
      Width = 75
      Height = 25
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      TabOrder = 1
      OnClick = btnPlEditClick
    end
    object btnPlDelete: TButton
      Left = 216
      Top = 6
      Width = 75
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = btnPlDeleteClick
    end
    object btnPlPost: TButton
      Left = 328
      Top = 6
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 3
      OnClick = btnPlPostClick
    end
    object btnPlCancel: TButton
      Left = 440
      Top = 6
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 4
      OnClick = btnPlCancelClick
    end
    object btnPlRefresh: TButton
      Left = 549
      Top = 6
      Width = 75
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 5
      OnClick = btnPlRefreshClick
    end
  end
end
