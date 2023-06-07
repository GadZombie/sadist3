program S3EdScen;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UnitStringi in 'UnitStringi.pas',
  vars in 'vars.pas',
  UnitScenIO in 'UnitScenIO.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Sadist 3 - Edytor scenariuszy';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
