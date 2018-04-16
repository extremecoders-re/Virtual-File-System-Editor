unit optionsdialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm3 = class(TForm)
    grp1: TGroupBox;
    okButton: TButton;
    cancelButton: TButton;
    manualSpecifyCheckBox: TCheckBox;
    createFileAEdit: TLabeledEdit;
    getFileSizeEdit: TLabeledEdit;
    readFileEdit: TLabeledEdit;
    notificationLabel: TLabel;
    closeHandleEdit: TLabeledEdit;
    procedure manualSpecifyCheckBoxClick(Sender: TObject);
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    function getCreateFileAAddress(): Integer;
    function getGetFileSizeAddress(): Integer;
    function getReadFileAddress(): Integer;
    function getCloseHandleAddress(): Integer;
  end;

var
  Form3: TForm3;
  createFileAAddress: Integer;
  getFileSizeAddress: Integer;
  readFileAddress: Integer;
  closeHandleAddress: Integer;

implementation

{$R *.dfm}

//---------------------------------------------
//
//
//---------------------------------------------

function TForm3.getCreateFileAAddress(): Integer;
begin
  Result := -1;
  if manualSpecifyCheckBox.Enabled = True then Result := createFileAAddress;
end;

function TForm3.getGetFileSizeAddress(): Integer;
begin
  Result := -1;
  if manualSpecifyCheckBox.Enabled = True then Result := getFileSizeAddress;
end;

function TForm3.getReadFileAddress(): Integer;
begin
  Result := -1;
  if manualSpecifyCheckBox.Enabled = True then Result := readFileAddress;
end;

function TForm3.getCloseHandleAddress(): Integer;
begin
  Result := -1;
  if manualSpecifyCheckBox.Enabled = True then Result := closeHandleAddress;
end;


//---------------------------------------------
//
//
//---------------------------------------------

procedure TForm3.manualSpecifyCheckBoxClick(Sender: TObject);
var
  isChecked: Boolean;
begin
  isChecked := manualSpecifyCheckBox.Checked;
  notificationLabel.Enabled := isChecked;
  createFileAEdit.Enabled := isChecked;
  getFileSizeEdit.Enabled := isChecked;
  readFileEdit.Enabled := isChecked;
  closeHandleEdit.Enabled := isChecked;
  okButton.Enabled := isChecked;
  cancelButton.Enabled := not isChecked;
end;


//---------------------------------------------
//
//
//---------------------------------------------

procedure TForm3.okButtonClick(Sender: TObject);
var
  t1, t2, t3, t4: Integer;
begin
  try
    t1 := StrToInt('0x' + Trim(createFileAEdit.Text));
    t2 := StrToInt('0x' + Trim(getFileSizeEdit.Text));
    t3 := StrToInt('0x' + Trim(readFileEdit.Text));
    t4 := StrToInt('0x' + Trim(closeHandleEdit.Text));
    createFileAAddress := t1;
    getFileSizeAddress := t2;
    readFileAddress := t3;
    closeHandleAddress := t4;
    Close;
  except
    on EConvertError do
    begin
      MessageBox(Handle, 'Please recheck the entered values', 'Error', MB_ICONWARNING);
    end;
  end;
end;


//------------------------------------------------
//
//
//------------------------------------------------

procedure TForm3.cancelButtonClick(Sender: TObject);
begin
  createFileAEdit.Text := IntToHex(createFileAAddress, 8);
  getFileSizeEdit.Text := IntToHex(getFileSizeAddress, 8);
  readFileEdit.Text := IntToHex(readFileAddress, 8);
  closeHandleEdit.Text := IntToHex(closeHandleAddress, 8);
  Close;
end;

end.

