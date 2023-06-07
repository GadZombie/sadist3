unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, vars, StdCtrls, Spin, ExtCtrls, Buttons, PowerInputs, directinput8,
  jpeg;

const ile_klaw=30;
type
  TForm1 = class(TForm)
    strony: TPageControl;
    sgrafika: TTabSheet;
    sdetale: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    ilpoc: TSpinEdit;
    Label2: TLabel;
    ilsyf: TSpinEdit;
    Label3: TLabel;
    ilmiesa: TSpinEdit;
    Label4: TLabel;
    ilwyb: TSpinEdit;
    Label5: TLabel;
    ilbombel: TSpinEdit;
    Label6: TLabel;
    ilciezkie: TSpinEdit;
    Label7: TLabel;
    ilgwiazd: TSpinEdit;
    Label8: TLabel;
    ildeszcz: TSpinEdit;
    Label9: TLabel;
    ilkol: TSpinEdit;
    Label10: TLabel;
    ilzwierz: TSpinEdit;
    Label11: TLabel;
    ilmin: TSpinEdit;
    Label12: TLabel;
    ilprzedm: TSpinEdit;
    Label13: TLabel;
    grozdzielczosc: TComboBox;
    Label14: TLabel;
    Label15: TLabel;
    gbitdepth: TComboBox;
    grefresz: TComboBox;
    Label16: TLabel;
    gaa: TCheckBox;
    gdither: TCheckBox;
    gvsync: TCheckBox;
    gfullscr: TCheckBox;
    gtripbuf: TCheckBox;
    gbitdepthtex: TComboBox;
    Label17: TLabel;
    soprogramie: TTabSheet;
    StaticText1: TStaticText;
    Panel1: TPanel;
    bok: TSpeedButton;
    SpeedButton1: TSpeedButton;
    klawiszetab: TTabSheet;
    klawskrol: TScrollBox;
    StaticText2: TStaticText;
    PowerInput1: TPowerInput;
    TabSheet1: TTabSheet;
    dwylaczdzwieki: TCheckBox;
    ButPrzywrocDomyslne: TSpeedButton;
    dwylaczmuzyke: TCheckBox;
    dilekanalow: TSpinEdit;
    Label18: TLabel;
    Image1: TImage;
    procedure SpeedButton1Click(Sender: TObject);
    procedure zapisz_kfg;
    procedure wczytaj_kfg;
    procedure bokClick(Sender: TObject);
    procedure ustawieniadomyslneklawiszy;
    procedure FormCreate(Sender: TObject);
    procedure KlawiszClick(Sender: TObject);
    procedure ButPrzywrocDomyslneClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    klawisze_labele:array[0..ile_klaw] of TLabel;
    klawisze_zmien:array[0..ile_klaw] of TSpeedbutton;

  end;

const
rozdz:array[0..6] of record x,y:integer end=
      ((x: 320;y: 240),
       (x: 512;y: 384),
       (x: 640;y: 400),
       (x: 640;y: 480),
       (x: 800;y: 600),
       (x:1024;y: 768),
       (x:1280;y:1024));
rozdzdom=3;

bitd:array[0..2] of integer=
      (8, 16, 32);
bitddom=2;

refr:array[0..8] of integer=
      (0, 60, 70, 72, 75, 80, 85, 90, 100);
refrdom=0;

nazwyklawiszy:array[0..ile_klaw] of string=(
         'Przesuwanie ekranu w lewo',
         'Przesuwanie ekranu w prawo',
         'Przesuwanie ekranu w górê',
         'Przesuwanie ekranu w dó³',
         'Podnieœ poziom wody w górê',
         'Opuœæ poziom wody w dó³',

         'Sterowanie postaci¹: skocz',
         'Sterowanie postaci¹: p³yñ w górê',
         'Sterowanie postaci¹: p³yñ w dó³',
         'Sterowanie postaci¹: idŸ/p³yñ w lewo',
         'Sterowanie postaci¹: idŸ/p³yñ w prawo',
         'Sterowanie postaci¹: biegnij (trzymaj+kierunek)',
         'Sterowanie postaci¹: uderz z grzywy',
         'Sterowanie postaci¹: bij rêk¹',
         'Sterowanie postaci¹: kopnij',
         'Sterowanie postaci¹: strzelaj',

         'Zbieranie min kursorem myszy',
         'Rzucanie trzymanym w wybranym kierunku',
         'Przenoszenie kursorem myszy',

         'Pauza',
         'Wybór postaci do sterowania, wskazanej kursorem',

         'W³¹czanie/wy³¹czanie menu na dole',
         'Nastêpne menu',
         'Nastêpne podmenu',

         'Pokaz liczniki (jeœli w³¹czone ich chowanie)',

         'Rysowanie: poprzednia tekstura/kolor',
         'Rysowanie: nastêpna tekstura/kolor',
         'Rysowanie: zmniejsz pêdzel',
         'Rysowanie: zwiêksz pêdzel',
         'Rysowanie: rysuj maskê/teren',
         'Rysowanie: poka¿ maskê/teren'
);

(*
klawisze[0]:=dik_left;     {ekran w lewo}
klawisze[1]:=dik_right;    {ekran w prawo}
klawisze[2]:=dik_up;       {ekran w gore}
klawisze[3]:=dik_down;     {ekran w dol}
klawisze[4]:=DIK_PRIOR;    {poziom wody w gore}
klawisze[5]:=DIK_NEXT;     {poziom wody w dol}

klawisze[6]:=DIK_NUMPAD8;  {sterowanie kolesiem: skok}
klawisze[7]:=DIK_NUMPAD8;  {sterowanie kolesiem: plyn w gore}
klawisze[8]:=DIK_NUMPAD2;  {sterowanie kolesiem: plyn w dol}
klawisze[9]:=DIK_NUMPAD4;  {sterowanie kolesiem: w lewo}
klawisze[10]:=DIK_NUMPAD6; {sterowanie kolesiem: w prawo}
klawisze[11]:=DIK_NUMPAD0; {sterowanie kolesiem: bieganie/chodzenie}
klawisze[12]:=DIK_Q;       {sterowanie kolesiem: grzywa}
klawisze[13]:=DIK_A;       {sterowanie kolesiem: bije}
klawisze[14]:=DIK_Z;       {sterowanie kolesiem: kopie}
klawisze[15]:=DIK_S;       {sterowanie kolesiem: strzela}

klawisze[16]:=DIK_M;       {zbieranie min}
klawisze[17]:=DIK_RCONTROL;{rzucanie trzymanym}
klawisze[18]:=DIK_RSHIFT;  {przenoszenie}

klawisze[19]:=DIK_P;       {pauza}
klawisze[20]:=DIK_T;       {wybor kolesia do sterowania}

klawisze[21]:=DIK_GRAVE;   {wlaczanie/wylaczanie menu na dole}
klawisze[22]:=DIK_TAB;     {nastepne menu}
klawisze[23]:=DIK_CAPITAL; {nastepne podmenu}

klawisze[24]:=DIK_L;       {pokaz liczniki, jesli sa chowane}
*)

var
  Form1: TForm1;
  hnd:integer;

implementation

uses Unit2;

{$R *.DFM}


procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
close;
end;

procedure TForm1.zapisz_kfg;
var p:TStream; a:integer;

 procedure zapiszB(i:boolean);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

 procedure zapiszI(i:integer);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

 procedure zapiszBt(i:byte);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

begin
try
   p:=TFileStream.Create('S3konfig.kfg', fmCreate);

   zapiszI(rozdz[grozdzielczosc.ItemIndex].x);
   zapiszI(rozdz[grozdzielczosc.ItemIndex].y);
   zapiszI(bitd[gbitdepth.ItemIndex]);
   zapiszI(refr[grefresz.ItemIndex]);
   zapiszI(gbitdepthtex.ItemIndex);
   zapiszB(gaa.Checked);
   zapiszB(gdither.Checked);
   zapiszB(gvsync.Checked);
   zapiszB(gfullscr.Checked);
   zapiszB(gtripbuf.Checked);

   zapiszI(ilpoc.Value);
   zapiszI(ilsyf.Value);
   zapiszI(ilmiesa.Value);
   zapiszI(ilwyb.Value);
   zapiszI(ilbombel.Value);
   zapiszI(ilciezkie.Value);
   zapiszI(ilgwiazd.Value);
   zapiszI(ildeszcz.Value);

   zapiszI(ilkol.Value);
   zapiszI(ilzwierz.Value);
   zapiszI(ilmin.Value);
   zapiszI(ilprzedm.Value);

   zapiszB(dwylaczdzwieki.Checked);
   zapiszB(dwylaczmuzyke.Checked);
   zapiszBt(dilekanalow.Value);

   for a:=0 to ile_klaw do zapiszBt(klawisze[a]);

   p.Free;
except
   p.Free;
   MessageBox(hnd, 'Blad przy zapisie pliku konfiguracji', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
end;


end;

procedure TForm1.wczytaj_kfg;
var p:TStream;

 function wczytajB:boolean;
 var b:boolean;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajB:=b;
 end;

 function wczytajI:integer;
 var b:integer;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajI:=b;
 end;

 function wczytajBt:byte;
 var b:byte;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajBt:=b;
 end;

var a,x,y:integer;
begin
if FileExists('S3konfig.kfg') then begin
  try
   p:=TFileStream.Create('S3konfig.kfg',fmOpenRead);

   x:=wczytajI;
   y:=wczytajI;
   a:=0;
   while (a<=high(rozdz)) and ((rozdz[a].x<>x) or (rozdz[a].y<>y)) do inc(a);
   grozdzielczosc.ItemIndex:=a;

   x:=wczytajI;
   a:=0;
   while (a<=high(bitd)) and (bitd[a]<>x) do inc(a);
   gbitdepth.ItemIndex:=a;

   x:=wczytajI;
   a:=0;
   while (a<=high(refr)) and (refr[a]<>x) do inc(a);
   grefresz.ItemIndex:=a;

   gbitdepthtex.ItemIndex:=wczytajI;
   gaa.Checked:=wczytajB;
   gdither.Checked:=wczytajB;
   gvsync.Checked:=wczytajB;
   gfullscr.Checked:=wczytajB;
   gtripbuf.Checked:=wczytajB;

   ilpoc.Value:=wczytajI;
   ilsyf.Value:=wczytajI;
   ilmiesa.Value:=wczytajI;
   ilwyb.Value:=wczytajI;
   ilbombel.Value:=wczytajI;
   ilciezkie.Value:=wczytajI;
   ilgwiazd.Value:=wczytajI;
   ildeszcz.Value:=wczytajI;

   ilkol.Value:=wczytajI;
   ilzwierz.Value:=wczytajI;
   ilmin.Value:=wczytajI;
   ilprzedm.Value:=wczytajI;

   dwylaczdzwieki.Checked:=wczytajB;
   dwylaczmuzyke.Checked:=wczytajB;
   dilekanalow.Value:=wczytajBt;

   for a:=0 to ile_klaw do klawisze[a]:=wczytajBt;

   p.Free;
  except
     p.free;
     MessageBox(hnd, 'Blad przy odczycie pliku konfiguracji', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
  end;
end else begin
   MessageBox(hnd, 'Brak pliku konfiguracji, zostanie przywrócona konfiguracja domyœlna', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
end;



end;



procedure TForm1.bokClick(Sender: TObject);
begin
zapisz_kfg;
close;
end;

procedure TForm1.ustawieniadomyslneklawiszy;
begin
klawisze[0]:=dik_left;     {ekran w lewo}
klawisze[1]:=dik_right;    {ekran w prawo}
klawisze[2]:=dik_up;       {ekran w gore}
klawisze[3]:=dik_down;     {ekran w dol}
klawisze[4]:=DIK_PRIOR;    {poziom wody w gore}
klawisze[5]:=DIK_NEXT;     {poziom wody w dol}

klawisze[6]:=DIK_NUMPAD8;  {sterowanie kolesiem: skok}
klawisze[7]:=DIK_NUMPAD8;  {sterowanie kolesiem: plyn w gore}
klawisze[8]:=DIK_NUMPAD2;  {sterowanie kolesiem: plyn w dol}
klawisze[9]:=DIK_NUMPAD4;  {sterowanie kolesiem: w lewo}
klawisze[10]:=DIK_NUMPAD6; {sterowanie kolesiem: w prawo}
klawisze[11]:=DIK_NUMPAD0; {sterowanie kolesiem: bieganie/chodzenie}
klawisze[12]:=DIK_Q;       {sterowanie kolesiem: grzywa}
klawisze[13]:=DIK_A;       {sterowanie kolesiem: bije}
klawisze[14]:=DIK_Z;       {sterowanie kolesiem: kopie}
klawisze[15]:=DIK_S;       {sterowanie kolesiem: strzela}

klawisze[16]:=DIK_M;       {zbieranie min}
klawisze[17]:=DIK_RCONTROL;{rzucanie trzymanym}
klawisze[18]:=DIK_RSHIFT;  {przenoszenie}

klawisze[19]:=DIK_P;       {pauza}
klawisze[20]:=DIK_T;       {wybor kolesia do sterowania}

klawisze[21]:=DIK_GRAVE;   {wlaczanie/wylaczanie menu na dole}
klawisze[22]:=DIK_TAB;     {nastepne menu}
klawisze[23]:=DIK_CAPITAL; {nastepne podmenu}

klawisze[24]:=DIK_L;       {pokaz liczniki, jesli sa chowane}

klawisze[25]:=DIK_LBRACKET;  {Rysowanie: poprzednia tekstura/kolor}
klawisze[26]:=DIK_RBRACKET;  {Rysowanie: nastêpna tekstura/kolor}
klawisze[27]:=DIK_MINUS;     {Rysowanie: zmniejsz pêdzel}
klawisze[28]:=DIK_EQUALS;    {Rysowanie: zwiêksz pêdzel}
klawisze[29]:=DIK_APOSTROPHE;{Rysowanie: rysuj maskê/teren}
klawisze[30]:=DIK_BACKSLASH; {Rysowanie: poka¿ maskê/teren}
end;

procedure TForm1.FormCreate(Sender: TObject);
const odstep=20;
var a:integer;
begin
ChDir(ExtractFilePath(Application.ExeName));

for a:=0 to high(rozdz) do
    grozdzielczosc.Items.Add(inttostr(rozdz[a].x)+' x '+inttostr(rozdz[a].y));

for a:=0 to high(bitd) do
    gbitdepth.Items.Add(inttostr(bitd[a])+'-bit');

grefresz.Items.Add('Bez zmieniania');
for a:=1 to high(refr) do
    grefresz.Items.Add(inttostr(refr[a])+'Hz');

grozdzielczosc.Items[rozdzdom]:=grozdzielczosc.Items[rozdzdom]+' (Domyœlnie)';
grozdzielczosc.ItemIndex:=rozdzdom;

gbitdepth.Items[bitddom]:=gbitdepth.Items[bitddom]+' (Domyœlnie)';
gbitdepth.ItemIndex:=bitddom;

grefresz.Items[refrdom]:=grefresz.Items[refrdom]+' (Domyœlnie)';
grefresz.ItemIndex:=0;

gbitdepthtex.ItemIndex:=0;

ustawieniadomyslneklawiszy;

wczytaj_kfg;

for a:=0 to ile_klaw do begin
    klawisze_labele[a]:=TLabel.create(form1);
    with klawisze_labele[a] do begin
       parent:=klawskrol;
       visible:=true;
       left:=20;
       top:=30+a*odstep;
       caption:=nazwyklawiszy[a];
    end;
    klawisze_zmien[a]:=TSpeedButton.create(form1);
    with klawisze_zmien[a] do begin
       parent:=klawskrol;
       visible:=true;
       left:=280;
       width:=90;
       height:=20;
       top:=30+a*odstep;
       caption:=form1.PowerInput1.KeyName[klawisze[a]];
       font.Style:=[fsbold];
       flat:=true;
       tag:=a;
       OnClick:=klawiszclick;
    end;
end;
PowerInput1.Initialize();
end;

procedure TForm1.KlawiszClick(Sender: TObject);
begin
 form2.ktoryklawisz:=(sender as tspeedbutton).Tag;
 form2.PowerTimer1.MayProcess:=true;
 form2.Showmodal;
end;

procedure TForm1.ButPrzywrocDomyslneClick(Sender: TObject);
var a:integer;
begin
ustawieniadomyslneklawiszy;
for a:=0 to ile_klaw do begin
    klawisze_zmien[a].caption:=form1.PowerInput1.KeyName[klawisze[a]];
end;

end;

end.
