program VFSserver;

uses
  Forms,
  Unit1 in 'Unit1.pas' {VFSServerForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TVFSServerForm, VFSServerForm);
  Application.Run;
end.
