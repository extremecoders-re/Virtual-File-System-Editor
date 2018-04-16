library vfseditor;

uses
  SysUtils,
  Classes,
  Forms,
  Windows,
  explorer in 'explorer.pas' {Form1},
  aboutdialogbox in 'aboutdialogbox.pas' {Form2},
  optionsdialog in 'optionsdialog.pas' {Form3},
  hiddendialog in 'hiddendialog.pas' {Form4},
  rundialog in 'rundialog.pas' {Form5};

{$R *.res}

procedure threadFunc(param: Pointer);
begin
  //Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end;

procedure DllMain(reason: DWORD);
var tid: DWORD;
begin
  case reason of
    DLL_PROCESS_ATTACH: CreateThread(nil, 0, @threadFunc, nil, 0, tid);
    DLL_PROCESS_DETACH: ExitProcess(0);
  end;
end;

begin
  DllProc := @DllMain;
  DllMain(DLL_PROCESS_ATTACH);
end.
