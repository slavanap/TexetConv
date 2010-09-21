object fmSettings: TfmSettings
  Left = 265
  Top = 239
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 160
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 321
    Height = 113
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 205
      Height = 21
      AutoSize = False
      Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1089#1082#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1092#1072#1081#1083#1099'...'
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 8
      Top = 80
      Width = 89
      Height = 21
      AutoSize = False
      Caption = #1060#1086#1088#1084#1072#1090' '#1080#1084#1077#1085#1080':'
      Layout = tlCenter
    end
    object edFolder: TEdit
      Left = 96
      Top = 56
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'edFolder'
    end
    object btSelect: TButton
      Left = 224
      Top = 56
      Width = 75
      Height = 21
      Caption = #1054#1073#1079#1086#1088'...'
      TabOrder = 3
      OnClick = btSelectClick
    end
    object rbFolder: TRadioButton
      Left = 8
      Top = 56
      Width = 81
      Height = 21
      Caption = #1074' '#1101#1090#1091' '#1087#1072#1087#1082#1091
      TabOrder = 0
      OnClick = rbFolderClick
    end
    object rbSourceFolder: TRadioButton
      Left = 8
      Top = 32
      Width = 169
      Height = 21
      Caption = #1074' '#1087#1072#1087#1082#1091' '#1089' '#1080#1089#1093#1086#1076#1085#1099#1084' '#1092#1072#1081#1083#1086#1084
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = rbFolderClick
    end
    object edNameFormat: TEdit
      Left = 96
      Top = 80
      Width = 204
      Height = 21
      TabOrder = 4
      Text = 'edNameFormat'
    end
  end
  object btClose: TButton
    Left = 248
    Top = 128
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    Default = True
    TabOrder = 1
    OnClick = btCloseClick
  end
end
