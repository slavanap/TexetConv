Unit ufSettings;
Interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, INIFiles, ShlObj, ActiveX;

Type
  TfmSettings = class(TForm)
    GroupBox1: TGroupBox;
    edFolder: TEdit;
    btSelect: TButton;
    rbFolder: TRadioButton;
    rbSourceFolder: TRadioButton;
    edNameFormat: TEdit;
    btClose: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; var Action: TCloseAction);
    Procedure btCloseClick(Sender: TObject);
    Procedure rbFolderClick(Sender: TObject);
    Procedure btSelectClick(Sender: TObject);
  Private
    Procedure SyncParams;
  Public
    { Public declarations }
  End;

Var
  fmSettings: TfmSettings;

Implementation

uses unManager;

{$R *.dfm}

Function BrowseForFolder(var Folder: string; Handle: HWND;
  const szText: string): Boolean;
Var
  BI: TBrowseInfo;
  PIDL: PItemIDList;
  Path: array[0..MAX_PATH-1] of Char;
  ResPIDL: PItemIDList;
  ShMalloc: IMalloc;
Begin
  Result := FALSE;
  IF SHGetMalloc(ShMalloc) <> NO_ERROR then
    Exit;
  SHGetSpecialFolderLocation(0, CSIDL_DRIVES, PIDL);
  FillChar(BI, SizeOf(BI), 0);
  With BI do
  Begin
    hwndOwner := Handle;
    lpszTitle := PChar(szText);
    ulFlags := BIF_RETURNONLYFSDIRS;
    pidlRoot := PIDL;
  End;
  resPIDL := SHBrowseForFolder(BI);
  IF Assigned( resPIDL ) then
  Begin
    SHGetPathFromIDList(ResPIDL, @Path[0]);
    Folder := Path;
    ShMalloc.Free(ResPIDL);
    Result := TRUE;
  End;
  ShMalloc.Free(PIDL);
End;


Procedure TfmSettings.SyncParams;
Begin
  IF rbFolder.Checked then
    unManager.FolderToSave := edFolder.Text
  else
    unManager.FolderToSave := '';
  OutNameFormat := edNameFormat.Text;
End;

Procedure TfmSettings.FormCreate(Sender: TObject);
Var
  INI: TINIFile;
Begin
  INI := TINIFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  rbFolder.Checked := INI.ReadBool('main', 'UseFolder', false);
  edFolder.Text := INI.ReadString('main', 'Folder', '');
  edNameFormat.Text := INI.ReadString('main', 'NameFormat', 'cv_%s.avi');
  rbFolderClick(nil);
  INI.Free;
  SyncParams;
End;

Procedure TfmSettings.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  INI: TINIFile;
Begin
  INI := TINIFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  INI.WriteBool('main', 'UseFolder', rbFolder.Checked);
  INI.WriteString('main', 'Folder', edFolder.Text);
  INI.WriteString('main', 'NameFormat', edNameFormat.Text);
  INI.Free;
  SyncParams;
End;

Procedure TfmSettings.btCloseClick(Sender: TObject);
Begin
  Close;
End;

Procedure TfmSettings.rbFolderClick(Sender: TObject);
Const
  Color: array [boolean] of TColor = (clBtnFace, clWindow);
Begin
  edFolder.Enabled := rbFolder.Checked;
  edFolder.Color := Color[rbFolder.Checked];
  btSelect.Enabled := rbFolder.Checked;
End;

Procedure TfmSettings.btSelectClick(Sender: TObject);
Var
  S: string;
Begin
  S := edFolder.Text;
  BrowseForFolder(S, Handle, 'Выберите папку для сохранения');
  edFolder.Text := S;
End;

End.
