program CyberKombatRT;

uses
  Vcl.Forms,
  CyberKombatRT.UnitMain in 'CyberKombatRT.UnitMain.pas' {FormMain},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Lavender Classico');
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
