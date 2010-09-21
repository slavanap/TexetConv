Program vc;

uses
  Forms,
  ufMain in 'ufMain.pas' {fmMain},
  ufSettings in 'ufSettings.pas' {fmSettings},
  unManager in 'unManager.pas',
  pl_T72X in 'pl_T72X.pas';

{$R *.res}

Begin
  Application.Initialize;
  Application.Title := 'Конвертер teXet';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmSettings, fmSettings);
  Application.Run;
End.
