object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Sentinel Super Pro Memory Read/Write Tool by h4sh3m'
  ClientHeight = 513
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 124
    Height = 13
    Caption = 'API Packet size (in HEX) : '
  end
  object Label2: TLabel
    Left = 8
    Top = 54
    Width = 116
    Height = 13
    Caption = 'Communication Modes : '
  end
  object Label3: TLabel
    Left = 8
    Top = 100
    Width = 158
    Height = 13
    Caption = 'Developer Code (in HEX string) : '
  end
  object Label4: TLabel
    Left = 8
    Top = 146
    Width = 114
    Height = 13
    Caption = 'Developer ID (in HEX) : '
  end
  object Label5: TLabel
    Left = 8
    Top = 192
    Width = 126
    Height = 13
    Caption = 'Write Password (in HEX) : '
  end
  object Label6: TLabel
    Left = 253
    Top = 146
    Width = 157
    Height = 13
    Caption = 'Overwrite Password 1 (in HEX) : '
  end
  object Label7: TLabel
    Left = 253
    Top = 192
    Width = 157
    Height = 13
    Caption = 'Overwrite Password 2 (in HEX) : '
  end
  object Label8: TLabel
    Left = 8
    Top = 238
    Width = 112
    Height = 13
    Caption = 'Access Code (in HEX) : '
  end
  object Label9: TLabel
    Left = 8
    Top = 284
    Width = 116
    Height = 13
    Caption = 'Data to Write (in HEX) : '
  end
  object Label10: TLabel
    Left = 8
    Top = 330
    Width = 27
    Height = 13
    Caption = 'Log : '
  end
  object Label11: TLabel
    Left = 253
    Top = 238
    Width = 105
    Height = 13
    Caption = 'Data Index (in HEX) : '
  end
  object btnWrite: TBitBtn
    Left = 89
    Top = 478
    Width = 75
    Height = 25
    Caption = 'Write'
    TabOrder = 11
    OnClick = btnWriteClick
  end
  object memLog: TMemo
    Left = 8
    Top = 349
    Width = 445
    Height = 123
    TabOrder = 12
  end
  object edtPacketSize: TEdit
    Left = 8
    Top = 27
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object cbCommunicationModes: TComboBox
    Left = 8
    Top = 73
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 1
    Text = 'RNBO_STANDALONE'
    Items.Strings = (
      'RNBO_STANDALONE'
      'RNBO_SPN_LOCAL'
      'RNBO_SPN_DRIVER'
      'RNBO_SPN_BROADCAST'
      'RNBO_SPN_ALL_MODES'
      'RNBO_SPN_SERVER_MODES')
  end
  object edtDeveloperCode: TEdit
    Left = 8
    Top = 119
    Width = 445
    Height = 21
    TabOrder = 2
  end
  object edtDeveloperID: TEdit
    Left = 8
    Top = 165
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object edtWritePassword: TEdit
    Left = 8
    Top = 211
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object edtOverwritePassword1: TEdit
    Left = 253
    Top = 165
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object edtOverwritePassword2: TEdit
    Left = 253
    Top = 211
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object edtAccessCode: TEdit
    Left = 8
    Top = 257
    Width = 121
    Height = 21
    TabOrder = 7
  end
  object edtData: TEdit
    Left = 8
    Top = 303
    Width = 121
    Height = 21
    TabOrder = 9
  end
  object btnRead: TBitBtn
    Left = 8
    Top = 478
    Width = 75
    Height = 25
    Caption = 'Read'
    TabOrder = 10
    OnClick = btnReadClick
  end
  object edtDataIndex: TEdit
    Left = 253
    Top = 257
    Width = 121
    Height = 21
    TabOrder = 8
  end
end
