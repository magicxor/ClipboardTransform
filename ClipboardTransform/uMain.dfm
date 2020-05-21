object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ClipboardTransform'
  ClientHeight = 118
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelHotKeyPaste: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 97
    Height = 19
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Paste:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelMatch: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 33
    Width = 97
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Match:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelReplace: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 60
    Width = 97
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Replace:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object HotKeyPaste: THotKey
    Left = 111
    Top = 8
    Width = 162
    Height = 19
    AutoSize = False
    HotKey = 16450
    InvalidKeys = [hcAlt, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt]
    Modifiers = [hkCtrl]
    TabOrder = 1
  end
  object ButtonSave: TButton
    AlignWithMargins = True
    Left = 3
    Top = 90
    Width = 289
    Height = 25
    Align = alBottom
    Caption = 'Apply && Save'
    TabOrder = 0
    OnClick = ButtonApplyAndSaveClick
    ExplicitTop = 32
    ExplicitWidth = 213
  end
  object EditMatch: TEdit
    Left = 111
    Top = 33
    Width = 162
    Height = 21
    TabOrder = 2
    Text = '(^.*$)'
  end
  object EditReplace: TEdit
    Left = 111
    Top = 60
    Width = 162
    Height = 21
    TabOrder = 3
    Text = '/// $1'
  end
end
