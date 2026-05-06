object frmObjectCard: TfrmObjectCard
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1050#1072#1088#1090#1086#1095#1082#1072' '#1086#1073#1098#1077#1082#1090#1072
  ClientHeight = 620
  ClientWidth = 920
  Color = clBtnFace
  Constraints.MinHeight = 620
  Constraints.MinWidth = 920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  TextHeight = 15
  object pButtons: TPanel
    Left = 0
    Top = 575
    Width = 920
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnPost: TButton
      Left = 308
      Top = 8
      Width = 120
      Height = 29
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 0
      OnClick = btnPostClick
    end
    object btnCancel: TButton
      Left = 492
      Top = 8
      Width = 120
      Height = 29
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object pMain: TPanel
    Left = 0
    Top = 0
    Width = 920
    Height = 575
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object gbMain: TGroupBox
      Left = 0
      Top = 0
      Width = 920
      Height = 136
      Align = alTop
      Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      TabOrder = 0
      object lblName: TLabel
        Left = 16
        Top = 8
        Width = 83
        Height = 15
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      end
      object lblStatus: TLabel
        Left = 452
        Top = 8
        Width = 36
        Height = 15
        Caption = #1057#1090#1072#1090#1091#1089
      end
      object lblPrice: TLabel
        Left = 36
        Top = 53
        Width = 28
        Height = 15
        Caption = #1062#1077#1085#1072
      end
      object lblArea: TLabel
        Left = 362
        Top = 64
        Width = 52
        Height = 15
        Caption = #1055#1083#1086#1097#1072#1076#1100
      end
      object lblFloors: TLabel
        Left = 624
        Top = 64
        Width = 58
        Height = 15
        Caption = #1069#1090#1072#1078#1085#1086#1089#1090#1100
      end
      object lblPlace: TLabel
        Left = 16
        Top = 90
        Width = 80
        Height = 15
        Caption = #1059#1095#1072#1089#1090#1086#1082'/'#1072#1076#1088#1077#1089
      end
      object edName: TEdit
        Left = 16
        Top = 24
        Width = 420
        Height = 23
        TabOrder = 0
      end
      object edPrice: TEdit
        Left = 70
        Top = 61
        Width = 140
        Height = 23
        TabOrder = 1
      end
      object edArea: TEdit
        Left = 420
        Top = 61
        Width = 140
        Height = 23
        TabOrder = 2
      end
      object edFloors: TEdit
        Left = 688
        Top = 61
        Width = 108
        Height = 23
        TabOrder = 3
      end
      object cbStatus: TDBLookupComboBox
        Left = 452
        Top = 24
        Width = 446
        Height = 23
        TabOrder = 4
      end
      object cbPlace: TDBLookupComboBox
        Left = 16
        Top = 107
        Width = 882
        Height = 23
        TabOrder = 5
      end
    end
    object pcDetails: TPageControl
      Left = 0
      Top = 136
      Width = 920
      Height = 439
      ActivePage = tsChar
      Align = alClient
      TabOrder = 1
      object tsPhoto: TTabSheet
        Caption = #1060#1086#1090#1086
        DesignSize = (
          912
          409)
        object imgMainPhoto: TDBImage
          Left = 8
          Top = 8
          Width = 336
          Height = 353
          Anchors = [akLeft, akTop, akBottom]
          Proportional = True
          Stretch = True
          TabOrder = 0
        end
        object grdPhoto: TDBGrid
          Left = 352
          Top = 8
          Width = 548
          Height = 353
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'phIsMain'
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'phFileName'
              Width = 210
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'phMime'
              Width = 120
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'phSize'
              Width = 85
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'phCreatedAt'
              Width = 120
              Visible = True
            end>
        end
        object btnAddPhoto: TButton
          Left = 8
          Top = 370
          Width = 140
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1086#1090#1086
          TabOrder = 2
          OnClick = btnAddPhotoClick
        end
        object btnDeletePhoto: TButton
          Left = 154
          Top = 370
          Width = 140
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1059#1076#1072#1083#1080#1090#1100' '#1092#1086#1090#1086
          TabOrder = 3
          OnClick = btnDeletePhotoClick
        end
        object btnSetMainPhoto: TButton
          Left = 352
          Top = 370
          Width = 170
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1057#1076#1077#1083#1072#1090#1100' '#1075#1083#1072#1074#1085#1099#1084
          TabOrder = 4
          OnClick = btnSetMainPhotoClick
        end
        object chkMain: TCheckBox
          Left = 532
          Top = 376
          Width = 220
          Height = 17
          Anchors = [akLeft, akBottom]
          Caption = #1053#1072#1079#1085#1072#1095#1080#1090#1100' '#1075#1083#1072#1074#1085#1099#1084' '#1087#1088#1080' '#1079#1072#1075#1088#1091#1079#1082#1077
          TabOrder = 5
        end
      end
      object tsChar: TTabSheet
        Caption = #1061#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1080
        DesignSize = (
          912
          409)
        object grdChar: TDBGrid
          Left = 0
          Top = 0
          Width = 912
          Height = 360
          Align = alTop
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
        object btnAddChar: TButton
          Left = 8
          Top = 370
          Width = 120
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnAddCharClick
        end
        object btnEditChar: TButton
          Left = 134
          Top = 370
          Width = 120
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 2
          OnClick = btnEditCharClick
        end
        object btnDeleteChar: TButton
          Left = 260
          Top = 366
          Width = 120
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 3
          OnClick = btnDeleteCharClick
        end
      end
      object tsUtil: TTabSheet
        Caption = #1050#1086#1084#1084#1091#1085#1072#1083#1100#1085#1099#1077' '#1091#1089#1083#1091#1075#1080
        DesignSize = (
          912
          409)
        object grdUtil: TDBGrid
          Left = 0
          Top = 0
          Width = 912
          Height = 360
          Align = alTop
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
        object btnAddUtil: TButton
          Left = 8
          Top = 370
          Width = 120
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnAddUtilClick
        end
        object btnEditUtil: TButton
          Left = 134
          Top = 370
          Width = 120
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 2
          OnClick = btnEditUtilClick
        end
        object btnDeleteUtil: TButton
          Left = 260
          Top = 370
          Width = 120
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 3
          OnClick = btnDeleteUtilClick
        end
      end
      object tsMat: TTabSheet
        Caption = #1052#1072#1090#1077#1088#1080#1072#1083#1099
        DesignSize = (
          912
          409)
        object grdMat: TDBGrid
          Left = 0
          Top = 0
          Width = 912
          Height = 360
          Align = alTop
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
        object btnAddMat: TButton
          Left = 8
          Top = 370
          Width = 120
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 1
          OnClick = btnAddMatClick
        end
        object btnEditMat: TButton
          Left = 134
          Top = 370
          Width = 120
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 2
          OnClick = btnEditMatClick
        end
        object btnDeleteMat: TButton
          Left = 260
          Top = 370
          Width = 120
          Height = 29
          Anchors = [akLeft, akBottom]
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 3
          OnClick = btnDeleteMatClick
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Images|*.bmp;*.jpg;*.jpeg;*.png'
    Left = 400
    Top = 16
  end
end
