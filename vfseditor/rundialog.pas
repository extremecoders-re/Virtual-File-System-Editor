unit rundialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellAPI, jpeg;

type
  TForm5 = class(TForm)
    lbl1: TLabel;
    filePathEdit: TLabeledEdit;
    okBtn: TButton;
    cancelBtn: TButton;
    browseBtn: TButton;
    img1: TImage;
    browseDlg: TOpenDialog;
    procedure okBtnClick(Sender: TObject);
    procedure cancelBtnClick(Sender: TObject);
    procedure browseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm5.okBtnClick(Sender: TObject);
begin
  if StrLen(PChar(filePathEdit.Text)) > 0 then
  begin
    if ShellExecute(Handle, 'open', PChar(filePathEdit.Text), nil, nil, SW_SHOWNORMAL) <= 32 then
    begin
      MessageDlg('Could not perform the requested action.' + #13#10 +
        'Make sure you typed the name correctly.',  mtError, [mbOK], 0);
      Exit;
    end;
    Close;
  end;
end;

//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm5.cancelBtnClick(Sender: TObject);
begin
  Close;
end;

//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm5.browseBtnClick(Sender: TObject);
begin
  if browseDlg.Execute then filePathEdit.Text := browseDlg.FileName;
end;

end.
