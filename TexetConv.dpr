program TexetConv;

uses
  Forms,
  ufMain in 'ufMain.pas' {Form1},
  unProControl in 'unProControl.pas',
  unParams in 'unParams.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Конвертер teXet';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
