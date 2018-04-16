unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TVFSServerForm = class(TForm)
    mmo1: TMemo;
    procedure WMCopyData(var msg: TWMCopyData); message WM_COPYDATA;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VFSServerForm: TVFSServerForm;

implementation

{$R *.dfm}

procedure TVFSServerForm.WMCopyData(var msg: TWMCopyData);
var
  filePathLen, fileSize, pktNum: Integer;
  filePath: array[0..MAX_PATH] of Char;
  buffer: TMemoryStream;
  fileStream: TFileStream;

begin
  if msg.CopyDataStruct.dwData = $DEADBEEF then
  begin
    buffer := TMemoryStream.Create;
    ZeroMemory(@filePath, SizeOf(filePath));
    buffer.Write(msg.CopyDataStruct.lpData^, msg.CopyDataStruct.cbData);
    buffer.Seek(0, soFromBeginning);
    buffer.Read(filePathLen, SizeOf(filePathLen));
    buffer.Read(filePath, filePathLen);
    buffer.Read(pktNum, SizeOf(pktNum));
    buffer.Read(fileSize, SizeOf(fileSize));

    if DirectoryExists(ExtractFileDir(filePath)) = True then
    begin
      if pktNum > 1 then
      begin
        fileStream := TFileStream.Create(filePath, fmOpenReadWrite or fmShareDenyWrite);
        fileStream.Seek(0, soFromEnd);
      end
      else fileStream := TFileStream.Create(filePath, fmCreate or fmShareDenyWrite);

      fileStream.CopyFrom(buffer, fileSize);
      fileStream.Free;

      if pktNum = 1 then
      begin
        mmo1.Lines.Add(filePath);
        //mmo1.Lines.Add('Size: ' + IntToStr(fileSize));
        mmo1.Lines.Add('');
      end;
      msg.Result := 20586;
    end
    else
    begin
      mmo1.Lines.Add(filePath);
      mmo1.Lines.Add('Invalid file path!, Skipping...');
      mmo1.Lines.Add('');
      msg.Result := 9999;
    end;
    buffer.Free;
  end;
end;

end.

