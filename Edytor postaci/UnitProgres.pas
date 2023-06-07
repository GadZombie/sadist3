unit UnitProgres;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Gauges;

type
  TFormprogres = class(TForm)
    pasek: TGauge;
    nazwapl: TLabel;
    Memo1: TMemo;
    Zamknij: TButton;
    procedure ZamknijClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Memo1Enter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Formprogres: TFormprogres;

implementation

uses Unit1;

{$R *.DFM}

procedure TFormprogres.ZamknijClick(Sender: TObject);
begin
form1.Enabled:=true;
close;
end;

procedure TFormprogres.FormShow(Sender: TObject);
begin
  form1.Enabled:=false;
  //Zamknij.SetFocus;
end;

procedure TFormprogres.Memo1Enter(Sender: TObject);
begin
formprogres.SetFocusedControl(zamknij);
end;

end.
