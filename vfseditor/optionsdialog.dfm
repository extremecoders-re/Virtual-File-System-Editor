object Form3: TForm3
  Left = 707
  Top = 231
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Options'
  ClientHeight = 237
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object notificationLabel: TLabel
    Left = 8
    Top = 40
    Width = 366
    Height = 39
    Caption = 
      'Specified addresses will only be used in extracting by name and ' +
      'server modes. Also please double check your values, otherwise th' +
      'e application may crash.'
    Enabled = False
    WordWrap = True
  end
  object grp1: TGroupBox
    Left = 8
    Top = 89
    Width = 369
    Height = 104
    Caption = 'API Addresses (VA)'
    TabOrder = 0
    object createFileAEdit: TLabeledEdit
      Left = 96
      Top = 24
      Width = 73
      Height = 21
      Hint = 'virtual address in hexadecimal'
      CharCase = ecUpperCase
      EditLabel.Width = 63
      EditLabel.Height = 13
      EditLabel.Caption = 'CreateFileA :'
      Enabled = False
      LabelPosition = lpLeft
      LabelSpacing = 10
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '00000000'
    end
    object getFileSizeEdit: TLabeledEdit
      Left = 264
      Top = 24
      Width = 73
      Height = 21
      Hint = 'virtual address in hexadecimal'
      CharCase = ecUpperCase
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = 'GetFileSize :'
      Enabled = False
      LabelPosition = lpLeft
      LabelSpacing = 10
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '00000000'
    end
    object readFileEdit: TLabeledEdit
      Left = 96
      Top = 64
      Width = 73
      Height = 21
      Hint = 'virtual address in hexadecimal'
      CharCase = ecUpperCase
      EditLabel.Width = 48
      EditLabel.Height = 13
      EditLabel.Caption = 'ReadFile :'
      Enabled = False
      LabelPosition = lpLeft
      LabelSpacing = 10
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '00000000'
    end
    object closeHandleEdit: TLabeledEdit
      Left = 264
      Top = 64
      Width = 73
      Height = 21
      Hint = 'virtual address in hexadecimal'
      CharCase = ecUpperCase
      EditLabel.Width = 66
      EditLabel.Height = 13
      EditLabel.Caption = 'CloseHandle :'
      Enabled = False
      LabelPosition = lpLeft
      LabelSpacing = 10
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '00000000'
    end
  end
  object okButton: TButton
    Left = 112
    Top = 203
    Width = 75
    Height = 25
    Caption = 'Ok'
    Enabled = False
    TabOrder = 1
    OnClick = okButtonClick
  end
  object cancelButton: TButton
    Left = 200
    Top = 202
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cancelButtonClick
  end
  object manualSpecifyCheckBox: TCheckBox
    Left = 8
    Top = 16
    Width = 129
    Height = 17
    Caption = 'Specify API addresses'
    TabOrder = 3
    OnClick = manualSpecifyCheckBoxClick
  end
end
