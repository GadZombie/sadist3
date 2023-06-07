program S3EdMis;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  vars in '..\vars.pas',
  UnitMisjeIO in 'UnitMisjeIO.pas',
  UnitStringi in '..\UnitStringi.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Sadist 3 - Edytor misji';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
