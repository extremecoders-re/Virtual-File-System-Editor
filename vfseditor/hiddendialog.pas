unit hiddendialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, optionsdialog, ShlObj, ShLwApi;

type
  TForm4 = class(TForm)
    mmo1: TMemo;
    doneButton: TButton;
    lbl1: TLabel;
    prefixEdit: TLabeledEdit;
    cancelButton: TButton;
    selectDirButton: TButton;
    outputPathEdit: TLabeledEdit;
    procedure selectDirButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure doneButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  outputDir, outputFilePath: array[0..MAX_PATH] of Char;

implementation

uses explorer, StrUtils;

{$R *.dfm}

//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm4.selectDirButtonClick(Sender: TObject);
var
  browseinfo: BROWSEINFOA;
  itemId: PItemIDList;
  path: array[0..MAX_PATH] of Char;
begin
  with browseinfo do
  begin
    hwndOwner := Form4.Handle;
    pidlRoot := 0;
    pszDisplayName := nil;
    lpszTitle :=
      PChar('Select the output folder. Please ensure that the selected folder is outside the virtual file system');
    lpfn := nil;
    ulFlags := BIF_RETURNONLYFSDIRS;
  end;
  itemId := SHBrowseForFolderA(browseinfo);
  if itemId <> nil then
  begin
    SHGetPathFromIDListA(itemId, path);
    outputPathEdit.Text := path;
  end;
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm4.cancelButtonClick(Sender: TObject);
begin
  Close;
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm4.doneButtonClick(Sender: TObject);
var
  serverWinHandle: HWND;
  prefix, suffix, fullPath: array[0..MAX_PATH] of Char;
  fileSize, bytesRead: DWORD;
  copyDataStruct: TCopyDataStruct;
  buffer: TMemoryStream;
  fileData: Pointer;
  hcfa: HookedCreateFileA;
  hrf: HookedReadFile;
  hgfs: HookedGetFileSize;
  hch: HookedCloseHandle;
  fileHandle: THandle;
  i, failedFiles, filePathLen, cfaAddr, rfAddr, gfsAddr, chAddr, pktNum, allocated: Integer;

begin
  serverWinHandle := FindWindow(PChar('TVFSServerForm'), PChar('VFS Server'));
  if serverWinHandle = 0 then
  begin
      MessageBox(Form1.Handle, 'VFS Server is not running.' + #13#10 + 'Please run vfsserver.exe before extracting this way',
      'Error', MB_OK + MB_ICONSTOP);
      SetFocus;
  end

  else
  begin
    ZeroMemory(@outputDir, SizeOf(outputDir));
    StrCopy(@outputDir, PChar(outputPathEdit.Text));
    StrCopy(@prefix, PChar(prefixEdit.Text));
    if outputDir = '' then MessageBox(Handle, 'Please select the output directory', 'Error', MB_ICONWARNING)
    else
    begin
      cfaAddr := Form3.getCreateFileAAddress;
      rfAddr := Form3.getReadFileAddress;
      gfsAddr := Form3.getGetFileSizeAddress;
      chAddr := Form3.getCloseHandleAddress;

      if (cfaAddr > 0) and (rfAddr > 0) and (gfsAddr > 0) and (chAddr > 0) then
      begin
        @hcfa := Pointer(cfaAddr);
        @hrf := Pointer(rfAddr);
        @hgfs := Pointer(gfsAddr);
        @hch := Pointer(chAddr);
      end
      else
      begin
        @hcfa := GetProcAddress(GetModuleHandleA('kernel32'), 'CreateFileA');
        @hrf := GetProcAddress(GetModuleHandleA('kernel32'), 'ReadFile');
        @hgfs := GetProcAddress(GetModuleHandleA('kernel32'), 'GetFileSize');
        @hch := GetProcAddress(GetModuleHandleA('kernel32'), 'CloseHandle');
      end;
      buffer := TMemoryStream.Create;

      failedFiles := 0;
      for i := 0 to mmo1.Lines.Count - 1 do
      begin
        if mmo1.Lines[i] = '' then Continue;
        StrCopy(@suffix, PChar(mmo1.Lines[i]));
        PathCombine(@fullPath, @prefix, @suffix);
        fileHandle := hcfa(fullPath, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
        if fileHandle = INVALID_HANDLE_VALUE then
        begin
          Inc(failedFiles);
          Continue;
        end;
        bytesRead := 0;
        fileSize := 0;

        fileSize := hgfs(fileHandle, nil);
        if fileSize = 0 then
        begin
          hch(fileHandle);
          Continue;
        end;

        //-----------------------------------------TODO-------------------
        pktNum := 0;
        while fileSize > 0 do
        begin
          if fileSize > 1000000 then allocated := 1000000
          else allocated := fileSize;
          Dec(fileSize, allocated);
          Inc(pktNum);

          GetMem(fileData, allocated);
          hrf(fileHandle, fileData^, allocated, @bytesRead, nil);

          ZeroMemory(@outputFilePath, SizeOf(outputFilePath));
          PathCombine(@outputFilePath, @outputDir, PChar(ExtractFileName(suffix)));

          filePathLen := StrLen(outputFilePath);
          buffer.Write(filePathLen, SizeOf(filePathLen));
          buffer.Write(outputFilePath, filePathLen);
          buffer.Write(pktNum, SizeOf(pktNum));
          buffer.Write(allocated, SizeOf(allocated));
          buffer.Write(fileData^, allocated);
          FreeMem(fileData);

          copyDataStruct.dwData := $DEADBEEF;
          copyDataStruct.cbData := buffer.size;
          copyDataStruct.lpData := buffer.memory;
          if SendMessage(serverWinHandle, WM_COPYDATA, Integer(Form1.Handle), Integer(@copyDataStruct)) <> 20586 then
          begin
            Inc(failedFiles);
            buffer.Clear;
            Break;
          end;
          buffer.Clear;
        end;
        hch(fileHandle);
        //-----------------------------------------TODO-------------------
      end;
      buffer.Free;
      ShowMessage('Extraction completed' + #13 + IntToStr(failedFiles) + ' file(s) failed.');
      Close;
    end;
  end;
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm4.FormShow(Sender: TObject);
begin
  prefixEdit.Text := Form1.shellTreeView.SelectedItems.Items[0].PathName;
end;

end.

