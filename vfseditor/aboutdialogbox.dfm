object Form2: TForm2
  Left = 518
  Top = 264
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'About'
  ClientHeight = 209
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object txt1: TStaticText
    Left = 50
    Top = 11
    Width = 285
    Height = 29
    Caption = 'Virtual File System Editor v0.3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object txt2: TStaticText
    Left = 71
    Top = 42
    Width = 243
    Height = 18
    Caption = 'Developed by Extreme Coders '#169' 2014 - 15'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object mmo1: TMemo
    Left = 9
    Top = 88
    Width = 368
    Height = 112
    BiDiMode = bdLeftToRight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Coded in Borland Delphi 7'
      ''
      'Virtual File System Editor uses the following :'
      '> Ortus Shell Components :: http://www.delphicomponents.net/'
      '> Aesthetica Icon Set, version 2.0 :: http://dryicons.com/')
    ParentBiDiMode = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    WordWrap = False
  end
  object txt3: TStaticText
    Left = 94
    Top = 62
    Width = 198
    Height = 18
    Caption = 'email: extremecoders@hotmail.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
end
