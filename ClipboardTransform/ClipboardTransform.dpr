program ClipboardTransform;

uses
  Vcl.Forms,
  uGlobalHotKeys in 'uGlobalHotKeys.pas',
  uMain in 'uMain.pas' {FormMain},
  uIniManager in 'uIniManager.pas',
  MapReduce in 'MapReduce\MapReduce.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
