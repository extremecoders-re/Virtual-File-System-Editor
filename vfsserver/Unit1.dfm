object VFSServerForm: TVFSServerForm
  Left = 774
  Top = 406
  Width = 487
  Height = 321
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'VFS Server'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mmo1: TMemo
    Left = 0
    Top = 0
    Width = 479
    Height = 287
    Align = alClient
    Color = clNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clLime
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '[*] Server process for Virtual File System Editor'
      '[*] This will receive files Extracted by server method'
      ''
      '[*] Server Running...'
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
end
