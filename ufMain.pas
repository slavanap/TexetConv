Unit ufMain;
Interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, XPMan, ImgList, unManager;

Const
  IM_WAIT = 0;
  IM_RUN = 1;
  IM_SUCC = 2;
  IM_ERROR = 3;

  SUB_OUTFILE = 0;
  SUB_PROGRESS = 1;

Type
  TfmMain = class(TForm)
    StatusBar: TStatusBar;
    GroupBox: TGroupBox;
    list: TListView;
    btAdd: TButton;
    btSettings: TButton;
    btDelete: TButton;
    OpenDialog: TOpenDialog;
    ImageList: TImageList;
    Procedure btSettingsClick(Sender: TObject);
    Procedure btAddClick(Sender: TObject);
    Procedure btDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure listChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  Private
    { Private declarations }
  Public
    Tasks: TTasks;
    Procedure OnStatus(Sender: TObject; ID: integer; Error: boolean);
    Procedure OnNext(Sender: TObject; ID: integer);
    Procedure OnSetProgress(Sender: TObject; ID, Progress: integer);
  End;

Var
  fmMain: TfmMain;

Implementation

uses ufSettings;

{$R *.dfm}

Procedure TfmMain.btSettingsClick(Sender: TObject);
Begin
  fmSettings.ShowModal;
End;

Procedure TfmMain.btAddClick(Sender: TObject);
Var
  i: integer;
Begin
  IF OpenDialog.Execute then
  Begin
    For i:=0 to Pred(OpenDialog.Files.Count) do
    Begin
      With list.Items.Add do
      Begin
        Caption := OpenDialog.Files[i];
        SubItems.Add(''); 
        SubItems.Add('');
        ImageIndex := IM_WAIT;
      End;
      Tasks.AddTask(OpenDialog.Files[i]);
    End;
    Tasks.Run;
  End;
End;

Procedure TfmMain.btDeleteClick(Sender: TObject);
Begin
  IF not Assigned(list.Selected) then Exit;
  IF Tasks.DeleteTask(list.Selected.Index) then
    list.Selected.Delete;
End;

Procedure TfmMain.FormCreate(Sender: TObject);
Begin
  Tasks := TTasks.Create(Handle);
  Tasks.OnStatus := OnStatus;
  Tasks.OnNext := OnNext;
  Tasks.OnSetProgress := OnSetProgress;
End;

Procedure TfmMain.FormDestroy(Sender: TObject);
Begin
  Tasks.Free;
End;

Procedure TfmMain.listChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
Begin
  btDelete.Enabled := Assigned(list.Selected);
End;

Procedure TfmMain.OnStatus(Sender: TObject; ID: integer; Error: boolean);
Const
  Img: array [boolean] of integer = (IM_SUCC, IM_ERROR);
Begin
  With list.Items[ID] do
  Begin
    ImageIndex := Img[Error];
    IF Error then
      SubItems[SUB_PROGRESS] := 'Ошибка: ' + Tasks.ConvObject.ErrorString
    else
      SubItems[SUB_PROGRESS] := 'Завершено';
  End;
End;

Procedure TfmMain.OnNext(Sender: TObject; ID: integer);
Begin
  With list.Items[ID] do
  Begin
    ImageIndex := IM_RUN;
    SubItems[SUB_OUTFILE] := Tasks.ConvObject.OutFileName;
    SubItems[SUB_PROGRESS] := 'Запускается...';
  End;
End;

Procedure TfmMain.OnSetProgress(Sender: TObject; ID, Progress: integer);
Begin
  list.Items[ID].SubItems[SUB_PROGRESS] := Format('%u%%', [Progress]);
End;

End.
