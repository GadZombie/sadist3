program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UnitKolesie in 'UnitKolesie.pas',
  UnitPociski in 'UnitPociski.pas',
  UnitSyfki in 'UnitSyfki.pas',
  UnitEfekty in 'UnitEfekty.pas',
  vars in 'vars.pas',
  sinusy in 'sinusy.pas',
  UnitGraGlowna in 'UnitGraGlowna.pas',
  UnitWybuchy in 'UnitWybuchy.pas',
  UnitPrzedmioty in 'UnitPrzedmioty.pas',
  UnitCiezkie in 'UnitCiezkie.pas',
  UnitMiny in 'UnitMiny.pas',
  UnitBomble in 'UnitBomble.pas',
  UnitRysowanie in 'UnitRysowanie.pas',
  UnitMenusy in 'UnitMenusy.pas',
  UnitZwierzaki in 'UnitZwierzaki.pas',
  UnitPliki in 'UnitPliki.pas',
  UnitMiesko in 'UnitMiesko.pas',
  UnitMenuGlowne in 'UnitMenuGlowne.pas',
  UnitPogoda in 'UnitPogoda.pas',
  UnitAutorzy in 'UnitAutorzy.pas',
{$IFDEF SPRAWDZANIE_POZYCJI_MENUGLOWNE}
  Unit2 in 'Unit2.pas' {Form2},
{$ENDIF}
  UnitStringi in 'UnitStringi.pas',
  UnitMisje in 'UnitMisje.pas',
  UnitDzwiek in 'UnitDzwiek.pas',
  oooal in 'oooal.pas',
  Al in 'al.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Sadist 3: Prawdziwi zabójcy';
  Application.CreateForm(TForm1, Form1);
{$IFDEF SPRAWDZANIE_POZYCJI_MENUGLOWNE}
  Application.CreateForm(TForm2, Form2);
{$ENDIF}

  form1.start;
  Application.Run;
end.

