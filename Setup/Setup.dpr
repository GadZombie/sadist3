program Setup;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  vars in 'vars.pas',
  Unit2 in 'Unit2.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Sadist 3 - konfiguracja';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
