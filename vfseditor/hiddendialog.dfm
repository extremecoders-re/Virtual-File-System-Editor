object Form4: TForm4
  Left = 656
  Top = 215
  BorderStyle = bsToolWindow
  Caption = 'Extract Files by Name'
  ClientHeight = 350
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 8
    Top = 16
    Width = 438
    Height = 26
    Caption = 
      'Enter the full path of the files. One item per line. You may als' +
      'o provide a path prefix. It will be concatenated at the beginnin' +
      'g for each path specified.'
    WordWrap = True
  end
  object mmo1: TMemo
    Left = 16
    Top = 120
    Width = 441
    Height = 177
    Hint = 'Enter the filenames here. One on each line.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ScrollBars = ssBoth
    ShowHint = True
    TabOrder = 3
    WordWrap = False
  end
  object doneButton: TButton
    Left = 16
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Done'
    TabOrder = 4
    OnClick = doneButtonClick
  end
  object prefixEdit: TLabeledEdit
    Left = 112
    Top = 88
    Width = 345
    Height = 21
    Hint = 
      'The prefix string to be appended to each filename specified (opt' +
      'ional)'
    EditLabel.Width = 57
    EditLabel.Height = 13
    EditLabel.Caption = 'Path Prefix:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    LabelPosition = lpLeft
    LabelSpacing = 37
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object cancelButton: TButton
    Left = 104
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = cancelButtonClick
  end
  object selectDirButton: TButton
    Left = 432
    Top = 56
    Width = 27
    Height = 22
    Caption = '...'
    TabOrder = 2
    OnClick = selectDirButtonClick
  end
  object outputPathEdit: TLabeledEdit
    Left = 112
    Top = 56
    Width = 313
    Height = 21
    Hint = 
      'Please ensure that the output directory already exists and is ou' +
      'tside the virtual file system'
    EditLabel.Width = 84
    EditLabel.Height = 13
    EditLabel.Caption = 'Output directory:'
    LabelPosition = lpLeft
    LabelSpacing = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
end
