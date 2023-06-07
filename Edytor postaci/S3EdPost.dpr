program S3EdPost;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  vars in 'vars.pas',
  UnitStringi in 'UnitStringi.pas',
  UnitProgres in 'UnitProgres.pas' {Formprogres};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Sadist 3 - Edytor postaci';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormprogres, Formprogres);
  Application.Run;
end.
