object frmGlobalSearch: TfrmGlobalSearch
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1043#1083#1086#1073#1072#1083#1100#1085#1099#1081' '#1087#1086#1080#1089#1082
  ClientHeight = 500
  ClientWidth = 980
  Constraints.MinHeight = 420
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
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object btnSearch: TButton
      Left = 724
      Top = 12
      Width = 120
      Height = 29
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1081#1090#1080
      TabOrder = 1
      OnClick = btnSearchClick
    end
    object btnClear: TButton
      Left = 850
      Top = 12
      Width = 120
      Height = 29
      Anchors = [akTop, akRight]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 0
      OnClick = btnClearClick
    end
  end
  object edSearch: TEdit
    Left = 8
    Top = 14
    Width = 706
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnKeyDown = edSearchKeyDown
  end
  object grdResult: TDBGrid
    Left = 0
    Top = 52
    Width = 980
    Height = 448
    Align = alClient
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = grdResultDblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'entityType'
        Width = 110
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'title'
        Width = 280
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'subtitle'
        Width = 540
        Visible = True
      end>
  end
end