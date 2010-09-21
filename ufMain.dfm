object fmMain: TfmMain
  Left = 202
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1050#1086#1085#1074#1077#1088#1090#1077#1088' teXet '#1076#1083#1103' '#1087#1083#1077#1077#1088#1086#1074' T-72X, T-73X, T-74X'
  ClientHeight = 446
  ClientWidth = 601
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 427
    Width = 601
    Height = 19
    Panels = <>
  end
  object GroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 585
    Height = 409
    Caption = ' '#1057#1087#1080#1089#1086#1082' '#1079#1072#1076#1072#1085#1080#1081' '
    TabOrder = 1
    object list: TListView
      Left = 8
      Top = 16
      Width = 569
      Height = 353
      Columns = <
        item
          AutoSize = True
          Caption = #1048#1084#1103' '#1092#1072#1081#1083#1072
        end
        item
          AutoSize = True
          Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074
        end
        item
          Alignment = taCenter
          Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1086
          Width = 90
        end>
      RowSelect = True
      SmallImages = ImageList
      TabOrder = 0
      ViewStyle = vsReport
      OnChange = listChange
    end
    object btAdd: TButton
      Left = 8
      Top = 376
      Width = 177
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1072#1081#1083#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Shell Dlg'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      WordWrap = True
      OnClick = btAddClick
    end
    object btSettings: TButton
      Left = 454
      Top = 376
      Width = 121
      Height = 25
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Shell Dlg'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      WordWrap = True
      OnClick = btSettingsClick
    end
    object btDelete: TButton
      Left = 192
      Top = 376
      Width = 177
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1076#1072#1085#1080#1077
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Shell Dlg'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      WordWrap = True
      OnClick = btDeleteClick
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      #1042#1089#1077' '#1087#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1084#1099#1077' '#1092#1086#1088#1084#1072#1090#1099'|*.avi;*.rm;*.rmvb;*.mpg;*.mpeg;*.mp4;' +
      '*.asf;*.wmv;*.mkv;*.dat;*.vob;*.flv|'#1060#1072#1081#1083' AVI (*.avi)|*.avi|'#1060#1072#1081#1083' ' +
      'Real (*.rm;*.rmvb)|*.rm;*.rmvb|'#1060#1072#1081#1083' Mpeg (*.mpg;*.mpeg;*.mp4)|*.' +
      'mpg;*.mpeg;*.mp4|'#1060#1072#1081#1083' Asf (*.asf)|*.asf|'#1060#1072#1081#1083' WMV (*.wmv)|*.wmv|'#1060 +
      #1072#1081#1083' Mkv (*.mkv)|*.mkv|'#1060#1072#1081#1083' VCD (*.dat)|*.dat|'#1060#1072#1081#1083' DVD (*.vob)|*.' +
      'vob|FlashVideo (*.flv;*.flac)|*.flv;*.flac|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083#1099' '#1076#1083#1103' '#1082#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1085#1080#1103
    Left = 24
    Top = 32
  end
  object ImageList: TImageList
    Left = 56
    Top = 32
    Bitmap = {
      494C010104000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D2C4BB009372
      5E00D0C2BA00000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CCBCB100906D5700845B3D00AE8C
      6C006E422500000000000000000000000000FFFFFFFF85B785FF0F6F0FFF1674
      16FF1A761AFF1A761AFF187818FF177917FF137D13FF0D7F0DFF0A7E0AFF077C
      07FF027B02FF007000FF7FB07FFFFFFFFFFF0000000000000000000000000000
      00000000000084B8850028812A00096C0B0009680B002778290085B286000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000210001014E0000006000000065000000600000004F0000002B000000
      0100000000000000000000000000000000000000000000000000000000000000
      000000000000C2AD9E008D684D00794E2F0090694C00BA997B00CAAD8D00C6A8
      880071452700000000000000000000000000FFFFFFFF118311FF1F8C1FFF2A91
      2AFF2F932FFF2E942EFF2C962CFF299A29FF239E23FF1CA31CFF15A415FF0DA4
      0DFF059F05FF019101FF006F00FFFFFFFFFF0000000000000000000000008DC3
      8E000D7D10000F821E0011872800108728000F8725000C8220000A7615000763
      09008FB690000000000000000000000000000000000000000000000001000101
      4E000000840000008E0000008E0000008F0000008C0000008800000081000101
      540000000B00000000000000000000000000000000000000000000000000CBB8
      AA008B624200A9886D00C2A88F00CDB39900D4B99D00DBBE9E00D7B99900CCAF
      8F0073462900000000000000000000000000FFFFFFFF198D19FF2C962CFF379C
      37FF3D9F3DFF3C9F3CFF39A139FFA3D6A3FFFFFFFFFF24AF24FF1CB11CFF13B2
      13FF0AAD0AFF049F04FF027902FFFFFFFFFF000000000000000093C994000F86
      160015933100148D2F0013892B0011882900108A2800108B26000D8923000B83
      1D0008670B0095BA950000000000000000000000000000000400010163000000
      96000000970000009B0000009F000000A00000009D000000970000008F000000
      88000000620000000B0000000000000000000000000000000000D0BFB1009972
      5300D2BAA300DCC6AF00DEC6AD00E3C9AE00EACDB000EECFB000E5C6A600D2B4
      95007E543700BFAC9F000000000000000000FFFFFFFF229122FF389C38FF43A2
      43FF48A448FF45A545FF42A642FFFFFFFFFFFFFFFFFFFFFFFFFF21B521FF18B6
      18FF0EB10EFF08A308FF057E05FFFFFFFFFF00000000000000000E8B1100189B
      37001692350014852D00157D29004B995A001180270011892800108E27000E8C
      24000B831C000762090000000000000000000000000001015D000101A3000808
      9E009999D4006868D0000000AC000000AE000000A9004848B800B7B7E3002727
      A50000008C000101520000000000000000000000000000000000966F4D00DEC7
      B200EBD7C100EED8C0006D0A00006D0A00006D0A00006D0A0000EDCEAF00D7BA
      9C00B99A7D00724528000000000000000000FFFFFFFF2C962CFF42A042FF4CA5
      4CFF4FA74FFF4CA74CFF46A746FF40AA40FFFFFFFFFFFFFFFFFFFFFFFFFF1AB3
      1AFF14AF14FF0FA30FFF0B800BFFFFFFFFFF000000008ECB8F00169A2B001A9C
      3D0015873000167C2B00A0C7A800F2F2F20070AD7C00117B250011882800108F
      27000E8B24000A75140090B891000000000001018C0003039D000000AB002828
      A300DEDED200FEFEFF006464D4000000B3004646C000E7E7EC00FFFFF7005E5E
      B70000009A000202870000011D000000000000000000D2C0B100C4A68C00F8E5
      D300F7E4CF00F9E3CD00FBE3CA006D0A00006D0A0000FBDEC000F3D5B600E1C4
      A600CDB1940098725500C1ADA10000000000FFFFFFFF359A35FF4BA54BFF52A8
      52FF53A953FF4EA84EFF49A749FF41A841FF38AA38FFFFFFFFFFFFFFFFFFFFFF
      FFFF19AC19FF18A218FF128212FFFFFFFFFF0000000039A73B0026A747001D97
      3E00177E2D009EC6A700F2F2F200F2F2F200F2F2F20070AD7C00117A25001188
      2800108D27000D85200037833900000000000303C2000505B0000303B9000000
      C2004C4CA700E6E6D900FCFCFF009E9EE600E8E9F400FFFFF1007575B9000606
      B1000101AB000202A000010251000000000000000000B0917400EBD8C600FEED
      DD00FEEBD800FCE8D300FDE7D0006D0A00006D0A0000FDE1C500F8DCBE00ECCF
      B100D8BCA000BA9B7E008F6C540000000000FFFFFFFF3F9F3FFF53A953FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF1F9E1FFF188118FFFFFFFFFF00000000169B18003BB060002697
      45007BB38700F2F2F200F2F2F200C3D9C700F2F2F200F2F2F20078B28400117E
      260011892800108C2600116D1400000000000708BA000808BB000707C8000505
      D1000000C8005353B600F2F2ED00FFFFFF00FFFFFC007575C9000000BE000101
      C3000303B8000303AC00030367000000000000000000A37D5B00FCF0E500FEF1
      E300FEEEDD00FEEBD800FDE9D4006D0A00006D0A0000FDE3C900FCE0C400F3D7
      BA00E2C6AA00CEB296007C53360000000000FFFFFFFF45A245FF5AAC5AFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF259A25FF1D7F1DFFFFFFFFFF00000000189E1A004DB8700035A0
      5300258A3E00BED6C3007AB28600137C2A0096C19F00F2F2F200F2F2F20078B1
      840011882900108D280016731800000000000B0BC3000C0CC9000D0DD8000B0B
      DC000000D6003C3DCE00EEEFED00FFFFFF00FFFFFD005858DB000000CA000303
      CB000606C5000606B800040471000000000000000000A6815E00FCF3E900FEF3
      E800FEF0E200FEEDDD006D0A00006D0A00006D0A0000FDE5CC00FDE3C900F8DD
      C100E9CEB300D4B99D0081583B0000000000FFFFFFFF4FA74FFF63B163FF61AF
      61FF59AB59FF51A651FF48A248FF3F9F3FFF369C36FFFFFFFFFFFFFFFFFFFFFF
      FFFF269926FF2A972AFF217E21FFFFFFFFFF0000000047B5490052BA6C004CB1
      6C002D9A4C001B89370015802E00147C2B00137C2A0096C19F00F2F2F2008EBE
      9700138A2C00118C27003F8D4100000000000B0BD4001414D8001717EA000B0B
      F1004343DB00E4E4EA00FDFDF500BABAD400EAEAE800FEFEFF006363E5000303
      D7000A0ACF000A0AC30005056F000000000000000000BC9F8300EADBCD00FEF6
      ED00FEF2E700FEF0E000FEEDDC00FEEBD800FDE9D400FDE7D000FDE5CC00F9DF
      C600EED4B900CBAD91009B7A620000000000FFFFFFFF53A953FF6CB66CFF68B4
      68FF5EAD5EFF54A854FF4CA34CFF429F42FFFFFFFFFFFFFFFFFFFFFFFFFF2997
      29FF2B982BFF2D952DFF237E23FFFFFFFFFF000000009AD89B003DB44C006DC6
      8C004DB56F0031A65400219B45001B933B00188B340016842F0061AA7100158A
      2F001595310010861F008DBD8E00000000000606E3001A1AE4002222FB003F3F
      E900DCDCE500FDFDEE007373C5000303D7005151B000E3E3D600FFFFFE006161
      E5000808DB000F0FCA00040451000000000000000000DCCCBD00CBB29B00FFF8
      F200FEF6ED00FEF2E700FEF0E1006D0A00006D0A0000FDE9D500FDE8D100FCE4
      CB00F3DAC100B08D6F00C9B7AA0000000000FFFFFFFF5EAF5EFF7ABD7AFF70B8
      70FF63B063FF5AAB5AFF52A652FFFFFFFFFFFFFFFFFFFFFFFFFF339933FF3099
      30FF309830FF2F942FFF237D23FFFFFFFFFF000000000000000016A6180074CC
      8C0079CE97005CC27F0044B7690033AE59002BA64E0028A04800279E450021A0
      4100179C33000C7B100000000000000000000404E9001515EC003232FF005252
      ED00B3B3C2007777CA000000EA000000EC000000E8005252B400ADADB0004D4D
      E1001818ED000F0FAE0000000D00000000000000000000000000AB866300EEE3
      D800FFF8F300FEF6EE00FEF3E8006D0A00006D0A0000FEEDDC00FDEBD900FDE8
      D300E5CAB0008A6040000000000000000000FFFFFFFF6BB56BFF8DC68DFF80C0
      80FF6FB76FFF67B267FF60AE60FFB4D9B4FFFFFFFFFF4CA54CFF49A449FF41A1
      41FF3A9D3AFF309530FF1E7A1EFFFFFFFFFF0000000000000000A0DCA00021AC
      250081D397008FDAAA007AD39A0065CA870056C178004DBC6E0045B8650030AC
      4D001087160095C696000000000000000000000000000505F2002A2AFB005353
      FF006868EF005757F9003838FF002525FD002929FF003838FC004242EB003232
      FF001F1FE9000606560000000000000000000000000000000000DECFC000B290
      6F00EEE3D900FFF9F400FEF7F000FEF5EC00FEF3E800FEF2E500FEEFE100E9D3
      BE0099725200D0C0B3000000000000000000FFFFFFFF77BB77FF9DCF9DFF8CC6
      8CFF79BC79FF70B870FF69B469FF65B265FF62B062FF5DAE5DFF56AB56FF4EA7
      4EFF41A141FF2F942FFF197719FFFFFFFFFF000000000000000000000000A1DD
      A10016A818004EBF5A007AD18E008CDAA6007DD49A0058C0710030A83F000F8D
      12009ACD9B0000000000000000000000000000000000000000000C0DF5003535
      FD006E6EFF009191FF009393FF008484FF007676FF006767FF005151FF002F2F
      FB000A0A7300000000000000000000000000000000000000000000000000DECF
      C000AB866300CCB59E00E9DBCF00FCF5EE00FCF3EB00E6D5C500C3A78E00966F
      4E00D3C3B500000000000000000000000000FFFFFFFFB1D8B1FF76BB76FF67B3
      67FF5BAD5BFF54A954FF4FA74FFF4AA44AFF4BA54BFF46A346FF3FA03FFF3B9E
      3BFF319831FF238C23FF8ABB8AFFFFFFFFFF0000000000000000000000000000
      0000000000009BDA9B004DBA4D0018A3190017A018004BB34C0099D299000000
      0000000000000000000000000000000000000000000000000000000000000809
      F8002D2DFC006363FE008787FF009292FF007676FF005353FF002C2CF0000909
      7600000000000000000000000000000000000000000000000000000000000000
      000000000000DBCABB00BDA08500A6815E00A37D5B00B6997E00D5C4B5000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000B0BF8001819F8003334FA005252FE003838FB001616FC000607C9000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFC70000FFFFFFFFFF070000F81FF00F
      F8070000E007C007E0070000C0038003C0030000C0038003C003000080010001
      8001000080010001800100008001000180010000800100018001000080010001
      800100008001000180010000C0030001C0030000C0038003C0030000E007C007
      E0070000F81FE00FF81F0000FFFFF01F00000000000000000000000000000000
      000000000000}
  end
end
