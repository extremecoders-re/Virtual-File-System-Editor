unit explorer;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, OrtusShellExplorer, ImgList, ShellAPI, ShlObj,
  aboutdialogbox, optionsdialog, hiddendialog, rundialog,
  ExtCtrls, ComCtrls, ToolWin;

type
  TForm1 = class(TForm)
    statusBar: TStatusBar;
    tlb1: TToolBar;
    extractButton: TToolButton;
    addButton: TToolButton;
    deleteButton: TToolButton;
    shellTreeView: TOrtusShellTreeView;
    shellListView: TOrtusShellListView;
    spl1: TSplitter;
    helpButton: TToolButton;
    aboutButton: TToolButton;
    il1: TImageList;
    extractServerButton: TToolButton;
    checkAccessButton: TToolButton;
    selectFilesDialog: TOpenDialog;
    extractHiddenButton: TToolButton;
    optionsButton: TToolButton;
    runButton: TToolButton;
    procedure shellListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure extractButtonClick(Sender: TObject);
    function getOutputDirectoryPath(Path: PChar): Boolean;
    procedure deleteButtonClick(Sender: TObject);
    procedure helpButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure aboutButtonClick(Sender: TObject);
    procedure extractServerButtonClick(Sender: TObject);
    procedure checkAccessButtonClick(Sender: TObject);
    procedure addButtonClick(Sender: TObject);
    procedure optionsButtonClick(Sender: TObject);
    procedure extractHiddenButtonClick(Sender: TObject);
    procedure runButtonClick(Sender: TObject);
  private
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

type
  {Addresses of Hooked APIs}
  HookedCreateFileA = function(lpFileName: PAnsiChar; dwDesiredAccess: Cardinal;
    dwShareMode: Cardinal; lpSecurityAttributes: PSecurityAttributes;
    dwCreationDisposition: Cardinal; dwFlagsAndAttributes: Cardinal; hTemplateFile: Cardinal): THandle; stdcall;

  HookedGetFileSize = function(hFile: THandle; lpFileSizeHigh: Pointer): DWORD; stdcall;

  HookedReadFile = function(hFile: THandle; var Buffer; nNumberOfBytesToRead: DWORD;
    lpNumberOfBytesRead: LPDWORD; lpOverlapped: POverlapped): BOOL; stdcall;

  HookedCloseHandle = function(hObject: THandle): BOOL; stdcall;

var
  Form1: TForm1;

implementation

{$R *.dfm}


//--------------------------------------------------------------------------------
//
// Callback procedure invoked when any selection is changed in the shell list view
//
//--------------------------------------------------------------------------------
procedure TForm1.shellListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
var
  selectionCount: Integer;

begin
  selectionCount := shellListView.SelCount;
  if selectionCount = 0 then statusBar.Panels.Items[0].Text := 'Ready'
  else if selectionCount = 1 then statusBar.Panels.Items[0].Text := shellListView.SelectedItems.Items[0].PathName
  else statusBar.Panels.Items[0].Text := IntToStr(selectionCount) + ' files selected';
end;


//--------------------------------------------------------------------------------
//
// Callback procedure for extract button click
//
//--------------------------------------------------------------------------------
procedure TForm1.extractButtonClick(Sender: TObject);
var
  sourceFile, destinationDir: array[0..MAX_PATH] of Char;
  selectedFilesList: TStringList;
  fileOp: SHFILEOPSTRUCTA;
  i, failedFiles: Integer;
begin
  if shellListView.SelCount = 0 then MessageBox(Handle, 'No files selected', 'Warning', MB_ICONWARNING)
  else
  begin
    ZeroMemory(@destinationDir, SizeOf(destinationDir));
    if getOutputDirectoryPath(@destinationDir) = True then
    begin
      statusBar.Panels.Items[0].Text := 'Please wait...Extraction in Progress';
      selectedFilesList := shellListView.SelectedItems.PathNames;
      failedFiles := 0;
      for i := 0 to selectedFilesList.Count - 1 do
      begin
        ZeroMemory(@sourceFile, SizeOf(sourceFile));
        StrCopy(@sourceFile, PChar(selectedFilesList[i]));
        ZeroMemory(@fileOp, SizeOf(fileOp));
        with fileOp do
        begin
          Wnd := Handle;
          wFunc := FO_COPY;
          pFrom := @sourceFile;
          pTo := @destinationDir;
        end;
        if SHFileOperationA(fileOp) <> 0 then Inc(failedFiles);
      end;
      statusBar.Panels.Items[0].Text := 'Ready';
      ShowMessage('Extraction completed.' + #13 + IntToStr(failedFiles) + ' file(s) failed.');
    end;
  end;
end;


//--------------------------------------------------------------------------------
//
// Opens a select folder dialog box and returns the path selected.
//
//--------------------------------------------------------------------------------
function TForm1.getOutputDirectoryPath(Path: PChar): Boolean;
var
  browseinfo: BROWSEINFOA;
  itemId: PItemIDList;
begin
  with browseinfo do
  begin
    hwndOwner := Form1.Handle;
    pidlRoot := 0;
    pszDisplayName := nil;
    lpszTitle :=
      PChar('Select the output folder. Please ensure that the selected folder is outside the virtual file system');
    lpfn := nil;
    ulFlags := BIF_RETURNONLYFSDIRS;
  end;
  itemId := SHBrowseForFolderA(browseinfo);
  if itemId = nil then
    getOutputDirectoryPath := False
  else
    getOutputDirectoryPath := SHGetPathFromIDListA(itemId, Path);
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm1.deleteButtonClick(Sender: TObject);
var
  sourceFile: array[0..MAX_PATH] of Char;
  selectedFilesList: TStringList;
  fileOp: SHFILEOPSTRUCTA;
  i, failedFiles: Integer;
begin
  if shellListView.SelCount = 0 then
  begin
    MessageBox(Handle, 'No files selected', 'Warning', MB_ICONWARNING);
    Exit;
  end;
  if MessageBox(Handle, 'Are you sure to permanently delete the selected file(s) ?' + #13#10 + 'This operation is not reversible',
    'Confirm Deletion ?', MB_YESNO + MB_ICONSTOP) = IDYES then
  begin
    statusBar.Panels.Items[0].Text := 'Please wait...Deletion in Progress';
    selectedFilesList := shellListView.SelectedItems.PathNames;
    failedFiles := 0;
    for i := 0 to selectedFilesList.Count - 1 do
    begin
      ZeroMemory(@sourceFile, SizeOf(sourceFile));
      StrCopy(@sourceFile, PChar(selectedFilesList[i]));
      ZeroMemory(@fileOp, SizeOf(fileOp));
      with fileOp do
      begin
        Wnd := Handle;
        wFunc := FO_DELETE;
        pFrom := @sourceFile;
        fFlags := FOF_NOCONFIRMATION;
      end;
      if SHFileOperationA(fileOp) <> 0 then Inc(failedFiles);
    end;
    statusBar.Panels.Items[0].Text := 'Ready';
    ShowMessage('Deleting completed' + #13 + IntToStr(failedFiles) + ' file(s) failed.');
  end;
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm1.helpButtonClick(Sender: TObject);
begin
  MessageBox(Form1.Handle, 'See the included README.HTML for more information', 'Help',
    MB_ICONINFORMATION);
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm1.FormCreate(Sender: TObject);
begin
  shellTreeView.SelectFolder(ExtractFileDir(GetModuleName(0)));
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm1.aboutButtonClick(Sender: TObject);
begin
  Form2.ShowModal;
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm1.extractServerButtonClick(Sender: TObject);
var
  serverWinHandle: HWND;
  copyDataStruct: TCopyDataStruct;
  selectedFilesList: TStringList;
  destinationDir, destinationFilePath: array[0..MAX_PATH] of Char;
  fileSize, bytesRead: DWORD;
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
  if serverWinHandle = 0 then MessageBox(Form1.Handle, 'VFS Server is not running.' + #13#10 + 'Please run vfsserver.exe before extracting this way',
      'Error', MB_OK + MB_ICONSTOP)
  else
  begin
    if getOutputDirectoryPath(@destinationDir) = True then
    begin
      statusBar.Panels.Items[0].Text := 'Please wait...Extraction in Progress';
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
      selectedFilesList := shellListView.SelectedItems.PathNames;
      failedFiles := 0;
      for i := 0 to selectedFilesList.Count - 1 do
      begin
        fileHandle := hcfa(PChar(selectedFilesList[i]), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
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

          ZeroMemory(@destinationFilePath, SizeOf(destinationFilePath));
          StrCopy(@destinationFilePath, @destinationDir);
          destinationFilePath[StrLen(@destinationFilePath)] := #92;
          StrCat(@destinationFilePath, PChar(ExtractFileName(selectedFilesList[i])));
          filePathLen := StrLen(@destinationFilePath);

          buffer.Write(filePathLen, SizeOf(filePathLen));
          buffer.Write(destinationFilePath, filePathLen);
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
        //----------------------------TODO-------------------------------
      end;
      buffer.Free;
      statusBar.Panels.Items[0].Text := 'Ready';
      ShowMessage('Extraction completed' + #13 + IntToStr(failedFiles) + ' file(s) failed.');
    end;
  end;
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm1.checkAccessButtonClick(Sender: TObject);
var
  hcfa: HookedCreateFileA;
  hch: HookedCloseHandle;
  msg: string;
  fileName: string;
  hnd: THandle;
begin
  if shellListView.SelCount = 0 then Exit;
  fileName := shellListView.SelectedItems.PathNames[0];
  if FileExists(fileName) = True then
  begin
    hnd := CreateFileA(PChar(fileName), 0, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if hnd <> INVALID_HANDLE_VALUE then
    begin
      msg := 'Accessible using implicit CreateFileA';
      CloseHandle(hnd);
    end
    else msg := 'Not accessible using implicit CreateFileA';

    @hcfa := GetProcAddress(GetModuleHandleA('kernel32'), 'CreateFileA');
    @hch := GetProcAddress(GetModuleHandleA('kernel32'), 'CloseHandle');

    hnd := hcfa(PChar(fileName), 0, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if hnd <> INVALID_HANDLE_VALUE then
    begin
      msg := msg + #13 + 'Accessible using GetProcAddress(CreateFileA)';
      hch(hnd);
    end
    else msg := msg + #13 + 'Not accessible using GetProcAddress(CreateFileA)';
    MessageDlg(fileName + #13 + msg, mtInformation, [mbOK], 0);
  end;
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm1.addButtonClick(Sender: TObject);
var
  fileList: TStrings;
  sourcePath, destinationPath: array[0..MAX_PATH] of Char;
  i, failedFiles: Integer;
  fileOp: SHFILEOPSTRUCTA;

begin
  if selectFilesDialog.Execute = True then
  begin
    statusBar.Panels.Items[0].Text := 'Please wait...Addition of files in progress';
    fileList := selectFilesDialog.Files;
    ZeroMemory(@destinationPath, SizeOf(destinationPath));
    StrCopy(@destinationPath, PChar(shellTreeView.SelectedItems.PathNames[0]));
    StrCat(@destinationPath, '\');
    failedFiles := 0;
    for i := 0 to fileList.Count - 1 do
    begin
      ZeroMemory(@sourcePath, SizeOf(sourcePath));
      StrCopy(@sourcePath, PChar(fileList[i]));
      ZeroMemory(@fileOp, SizeOf(fileOp));
      with fileOp do
      begin
        Wnd := Handle;
        wFunc := FO_COPY;
        pFrom := @sourcePath;
        pTo := @destinationPath;
      end;
      if SHFileOperationA(fileOp) <> 0 then Inc(failedFiles);
    end;
    statusBar.Panels.Items[0].Text := 'Ready';
    ShowMessage('Addition of files completed' + #13 + IntToStr(failedFiles) + ' file(s) failed.');
  end;
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm1.optionsButtonClick(Sender: TObject);
begin
  Form3.ShowModal;
end;


//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm1.extractHiddenButtonClick(Sender: TObject);
begin
  Form4.ShowModal;
end;

//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm1.WMSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType = SC_MINIMIZE then
    ShowWindow(Handle, SW_MINIMIZE)
  else
    inherited;
end;

//--------------------------------------------------------------------------------
//
//
//
//--------------------------------------------------------------------------------
procedure TForm1.runButtonClick(Sender: TObject);
begin
  Form5.ShowModal;
end;

end.

