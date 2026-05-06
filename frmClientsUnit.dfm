object frmClients: TfrmClients
  Left = 0
  Top = 0
  Caption = #1050#1083#1080#1077#1085#1090#1099
  ClientHeight = 560
  ClientWidth = 960
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 760
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object grdClients: TDBGrid
    Left = 0
    Top = 53
    Width = 960
    Height = 507
    Align = alClient
    DataSource = dmMain.DS_Client
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = grdClientsDblClick
    OnTitleClick = grdClientsTitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'clFIO'
        Width = 220
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'clPhone'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'clEmail'
        Width = 190
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'clPassport'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'clAddress'
        Width = 220
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'clNote'
        Width = 220
        Visible = True
      end>
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 960
    Height = 53
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 958
    object btnInsert: TButton
      Left = 8
      Top = 12
      Width = 92
      Height = 29
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btnInsertClick
    end
    object btnEdit: TButton
      Left = 106
      Top = 12
      Width = 92
      Height = 29
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 204
      Top = 12
      Width = 92
      Height = 29
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnRefresh: TButton
      Left = 302
      Top = 12
      Width = 100
      Height = 29
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 3
      OnClick = btnRefreshClick
    end
    object btnCard: TButton
      Left = 408
      Top = 12
      Width = 110
      Height = 29
      Caption = #1050#1072#1088#1090#1086#1095#1082#1072
      TabOrder = 4
      OnClick = btnCardClick
    end
  end
end
