unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, DXDraws, Buttons, Grids, DIB, ImgList,
  unitstringi, vars, Spin, unitpostio, DXInput, DXClass, mmsystem;

const
  max_ani=18;
  max_mies=5;
  max_dzw=15;
  max_dym=7;
type
  TForm1 = class(TForm)
    st: TPageControl;
    Ogolne: TTabSheet;
    Parametry: TTabSheet;
    Wyglad: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    skrolwarunki: TScrollBox;
    GroupBox2: TGroupBox;
    Panel5: TPanel;
    listadruzyn: TListBox;
    Panel6: TPanel;
    Label4: TLabel;
    obrterenu: TImage;
    skrolpodglad: TScrollBox;
    podgani: TPaintBox;
    Panel7: TPanel;
    zoomin: TSpeedButton;
    zoomout: TSpeedButton;
    ikonki: TImageList;
    zoom100: TSpeedButton;
    zoomcale: TSpeedButton;
    zoombar: TTrackBar;
    oprogramie: TTabSheet;
    tekstoprogramie: TStaticText;
    ustamun0: TSpinEdit;
    skrologolne: TScrollBox;
    Label1: TLabel;
    nnazwa: TEdit;
    Label2: TLabel;
    nautor: TEdit;
    Label3: TLabel;
    ndatastworzenia: TDateTimePicker;
    Splitter2: TSplitter;
    Panel8: TPanel;
    Zapisz: TSpeedButton;
    Wczytaj: TSpeedButton;
    Splitter3: TSplitter;
    Dzwieki: TTabSheet;
    skroldzwieki: TScrollBox;
    Label5: TLabel;
    ustamun1: TSpinEdit;
    label6: TLabel;
    ustamun2: TSpinEdit;
    Label7: TLabel;
    ustamun3: TSpinEdit;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    ustpocsila: TSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    ustmaxtlen: TSpinEdit;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    ustszyb: TSpinEdit;
    Label12: TLabel;
    ustwaga: TSpinEdit;
    Label13: TLabel;
    ustsilabicia: TSpinEdit;
    Kolory: TGroupBox;
    Label14: TLabel;
    ColorDialog1: TColorDialog;
    nkolorkrwi: TShape;
    zmienkolorkrwi: TSpeedButton;
    ustmaxsily: TSpinEdit;
    Label15: TLabel;
    Listaanimacji: TScrollBox;
    OpenDialogwav: TOpenDialog;
    klatki: TStaticText;
    klatkapop: TSpeedButton;
    klatkanast: TSpeedButton;
    aniodtworz: TSpeedButton;
    aniszybk: TTrackBar;
    Timerani: TTimer;
    skrolparametry: TScrollBox;
    Splitter4: TSplitter;
    OpenDialogtga: TOpenDialog;
    Panel3: TPanel;
    pok_bom: TSpeedButton;
    StaticText3: TStaticText;
    pok_bom_x: TEdit;
    StaticText4: TStaticText;
    pok_bom_y: TEdit;
    pok_bom_kat: TEdit;
    StaticText5: TStaticText;
    Panel4: TPanel;
    pok_wekt: TSpeedButton;
    pok_wekt_dx: TEdit;
    pok_wekt_dy: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    pok_wekt_sila: TEdit;
    StaticText6: TStaticText;
    pok_wekt_klatka: TEdit;
    StaticText7: TStaticText;
    zatwierdz_wekt: TSpeedButton;
    Panel9: TPanel;
    StaticText8: TStaticText;
    ani_szybk: TEdit;
    panel_stoi: TPanel;
    stoi_dod: TSpeedButton;
    StaticText9: TStaticText;
    stoi_od: TEdit;
    stoi_ile: TEdit;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    stoi_szyb: TEdit;
    stoi_zapetl: TCheckBox;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    stoi_usun: TSpeedButton;
    stoi_licznik: TStaticText;
    stoi_nast: TSpeedButton;
    stoi_pop: TSpeedButton;
    stoi_od_wez: TSpeedButton;
    stoi_ile_wez: TSpeedButton;
    stoi_play: TSpeedButton;
    miesotab: TTabSheet;
    mies_Splitter3: TSplitter;
    mies_Panel7: TPanel;
    mies_zoomin: TSpeedButton;
    mies_zoomout: TSpeedButton;
    mies_zoom100: TSpeedButton;
    mies_zoomcale: TSpeedButton;
    mies_klatkapop: TSpeedButton;
    mies_klatkanast: TSpeedButton;
    mies_aniodtworz: TSpeedButton;
    mies_zoombar: TTrackBar;
    mies_klatki: TStaticText;
    mies_aniszybk: TTrackBar;
    mies_Panel1: TPanel;
    mies_Splitter4: TSplitter;
    mies_Panel2: TPanel;
    mies_Listaanimacji: TScrollBox;
    mies_skrolparametry: TScrollBox;
    mies_Panel4: TPanel;
    mies_StaticText14: TStaticText;
    mies_skrolpodglad: TScrollBox;
    mies_podgani: TPaintBox;
    Panel10: TPanel;
    mies_wym: TEdit;
    mies_wym_y: TEdit;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText18: TStaticText;
    mies_widok_1: TSpeedButton;
    mies_widok_2: TSpeedButton;
    Panel11: TPanel;
    mies_miejs_x: TEdit;
    mies_miejs_y: TEdit;
    StaticText19: TStaticText;
    StaticText20: TStaticText;
    mies_miejs_kl: TEdit;
    StaticText21: TStaticText;
    StaticText22: TStaticText;
    Panel12: TPanel;
    pok_bron: TSpeedButton;
    StaticText17: TStaticText;
    pok_bron_x: TEdit;
    StaticText23: TStaticText;
    pok_bron_y: TEdit;
    StaticText25: TStaticText;
    mies_wym_x: TEdit;
    mies_ileklatek: TEdit;
    StaticText24: TStaticText;
    mies_Timerani: TTimer;
    StaticText26: TStaticText;
    pok_bron_kat: TEdit;
    Nowy: TSpeedButton;
    dzwiekistop: TButton;
    barpocsila: TTrackBar;
    barmaxsily: TTrackBar;
    barmaxtlen: TTrackBar;
    barszyb: TTrackBar;
    barwaga: TTrackBar;
    barsilabicia: TTrackBar;
    baramun0: TTrackBar;
    baramun1: TTrackBar;
    baramun2: TTrackBar;
    baramun3: TTrackBar;
    StaticText27: TStaticText;
    mies_miejs_kat: TEdit;
    StaticText28: TStaticText;
    mies_miejs_odl: TEdit;
    mies_miejs_zaczx: TEdit;
    StaticText29: TStaticText;
    mies_miejs_zaczy: TEdit;
    StaticText30: TStaticText;
    dymkitab: TTabSheet;
    skroldymki: TScrollBox;
    procedure FormCreate(Sender: TObject);

    procedure zroblistyplikow;
//    procedure ListaAnimacjiClick(Sender: TObject);
    procedure zoominClick(Sender: TObject);
    procedure zoomoutClick(Sender: TObject);
    procedure zoom100Click(Sender: TObject);
    procedure zoomcaleClick(Sender: TObject);
    procedure zoombarChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ZapiszClick(Sender: TObject);
    procedure listadruzynClick(Sender: TObject);
    procedure WczytajClick(Sender: TObject);
    procedure zmienkolorkrwiClick(Sender: TObject);
    procedure Splitter3CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure wyborbitmapy(Sender: TObject);
    procedure podganiPaint(Sender: TObject);
    procedure klatkanastClick(Sender: TObject);
    procedure klatkapopClick(Sender: TObject);
    procedure aniszybkChange(Sender: TObject);
    procedure TimeraniTimer(Sender: TObject);
    procedure aniodtworzClick(Sender: TObject);
    procedure wybierzanimacje(Sender: TObject);
    procedure pok_wektClick(Sender: TObject);
    procedure pok_bomClick(Sender: TObject);
    procedure podganiMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure podganiMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure podganiMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure poprawwartosc(Sender: TObject);
    procedure pok_wekt_dxExit(Sender: TObject);
    procedure pok_wekt_dxKeyPress(Sender: TObject; var Key: Char);
    procedure zatwierdz_wektClick(Sender: TObject);
    procedure wybierzwav(Sender: TObject);
    procedure odtworzwav(Sender: TObject);
    procedure stoi_dodClick(Sender: TObject);
    procedure stoi_usunClick(Sender: TObject);
    procedure stoi_popClick(Sender: TObject);
    procedure stoi_nastClick(Sender: TObject);
    procedure stoi_zapetlClick(Sender: TObject);
    procedure stoi_od_wezClick(Sender: TObject);
    procedure stoi_ile_wezClick(Sender: TObject);
    procedure stoi_playClick(Sender: TObject);
    procedure Splitter3Moved(Sender: TObject);
    procedure pok_bronClick(Sender: TObject);

    procedure mies_wybierzanimacje(Sender: TObject);
    procedure mies_podganiPaint(Sender: TObject);
    procedure mies_wyborbitmapy(Sender: TObject);
    procedure mies_zoominClick(Sender: TObject);
    procedure mies_zoomoutClick(Sender: TObject);
    procedure mies_zoom100Click(Sender: TObject);
    procedure mies_zoomcaleClick(Sender: TObject);
    procedure mies_zoombarChange(Sender: TObject);
    procedure mies_poprawwartosc(Sender: TObject);
    procedure mies_miejs_xKeyPress(Sender: TObject; var Key: Char);
    procedure mies_miejs_xExit(Sender: TObject);
    procedure mies_klatkapopClick(Sender: TObject);
    procedure mies_klatkanastClick(Sender: TObject);
    procedure mies_aniszybkChange(Sender: TObject);
    procedure mies_aniodtworzClick(Sender: TObject);
    procedure mies_TimeraniTimer(Sender: TObject);
    procedure mies_widok_2Click(Sender: TObject);
    procedure mies_widok_1Click(Sender: TObject);
    procedure mies_podganiMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mies_podganiMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NowyClick(Sender: TObject);
    procedure dzwiekistopClick(Sender: TObject);
    procedure nkolorkrwiMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ustpocsilaChange(Sender: TObject);
    procedure barpocsilaChange(Sender: TObject);
    procedure ustmaxsilyChange(Sender: TObject);
    procedure barmaxsilyChange(Sender: TObject);
    procedure ustmaxtlenChange(Sender: TObject);
    procedure barmaxtlenChange(Sender: TObject);
    procedure ustszybChange(Sender: TObject);
    procedure barszybChange(Sender: TObject);
    procedure ustwagaChange(Sender: TObject);
    procedure barwagaChange(Sender: TObject);
    procedure ustsilabiciaChange(Sender: TObject);
    procedure barsilabiciaChange(Sender: TObject);
    procedure ustamun0Change(Sender: TObject);
    procedure baramun0Change(Sender: TObject);
    procedure ustamun1Change(Sender: TObject);
    procedure baramun1Change(Sender: TObject);
    procedure ustamun2Change(Sender: TObject);
    procedure baramun2Change(Sender: TObject);
    procedure ustamun3Change(Sender: TObject);
    procedure baramun3Change(Sender: TObject);
    procedure dodajdymek(Sender: TObject);
    procedure usundymek(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    dzwieki_labele:array[0..max_dzw] of TLabel;
    dzwieki_edity:array[0..max_dzw] of TEdit;
    dzwieki_zmien:array[0..max_dzw] of TSpeedbutton;
    dzwieki_play:array[0..max_dzw] of TSpeedbutton;

    d_animacje:array[0..max_ani] of TBitmap;
    ani_labele:array[0..max_ani] of TLabel;
    ani_edity:array[0..max_ani] of TEdit;
    ani_zmien:array[0..max_ani] of TSpeedbutton;

    mies_d_animacje:array[0..max_mies] of TBitmap;
    mies_d_ani_wym:array[0..max_mies] of integer;
    mies_d_ani_ilekl:array[0..max_mies] of integer;
    mies_ani_labele:array[0..max_mies] of TLabel;
    mies_ani_edity:array[0..max_mies] of TEdit;
    mies_ani_zmien:array[0..max_mies] of TSpeedbutton;

    dymki_labele:array[0..max_dym] of TLabel;
    dymki_comboboxy:array[0..max_dym] of TCombobox;
    dymki_guzdod:array[0..max_dym] of TSpeedbutton;
    dymki_guzusun:array[0..max_dym] of TSpeedbutton;

  end;

var
  Form1: TForm1;
  h:integer;

  ustawienia:record
     zoom,
     mies_zoom:double;
     wybranadruzyna:string;

     doklatki:integer;
     aniwybrana:byte;
     klatkawybrana:integer;

     stoi_wyb:integer;
     odtw_od,odtw_ile:integer;

     mies_aniwybrana:byte;
     mies_klatkawybrana:integer;
     mies_anisz:integer;
  end;

  kursor:record
         x,y:integer;
         rx,ry:real;
         ciagnie1:boolean;
         ciagnie2:boolean;
         ciagnie3:boolean;
         end;

implementation
{$R *.DFM}

const
nazwydzwiekow:array[0..max_dzw] of string=
        ('krzyk podczas oberwania 1',
         'krzyk podczas oberwania 2',
         'krzyk podczas oberwania 3',
         'odbicie siê miêsa',
         'œmieræ',
         'cieszy siê',
         'panika',
         'kopniêcie',
         'topienie siê',
         'œmieræ przez utopienie',
         'uderzenie piêœci¹',
         'skok',
         'uderzenie z grzywy',
         'pokazywanie wroga',
         'kaszlenie w gazie',
         'krzyk od uderzenia w œcianê');

nazwyani:array[0..max_ani] of string=
        ('stoi',
         'idzie',
         'biegnie',
         'rzuca granatem',
         'cieszy siê',
         'trzyma',
         'p³ynie w bok',
         'panikuje',
         'kopie',
         'strzela z karabinu',
         'nurkuje (w pionie)',
         'bije',
         'wyrzuca to co trzyma',
         'obraca siê w powietrzu',
         'spada machaj¹c rêkami',
         'wali z grzywy',
         'pokazuje przeciwnika',
         'skacze',
         'wspina siê pod górê');

mies_nazwyani:array[0..max_mies] of string=
        ('g³owa',
         'tu³ów',
         'noga lewa',
         'noga prawa',
         'rêka lewa',
         'rêka prawa' );

nazwy_dymkow:array[0..max_dym] of string=
        ('gdy stoi i siê nudzi',
         'gdy oberwie od swojego',
         'gdy rzuca w kogoœ granatem itp.',
         'gdy sie cieszy',
         'gdy stoi i cos trzyma',
         'w czasie paniki',
         'gdy wyrzuca to co trzyma',
         'gdy nasy³a swoich na wroga'
          );

function jaki_to_kat_Real(dx,dy:real):real;
var kk0:real;
begin
 if dx>0 then begin
    if (dy>0) then kk0:=arctan(dy/dx)+pi/2
              else kk0:=arctan(dy/dx)+pi/2;
 end else if dx<0 then begin
    if (dy>0) then kk0:=arctan(dy/dx)+(3/2)*pi
              else kk0:=arctan(dy/dx)+(3/2)*pi;
 end else begin
    if (dy>0) then kk0:=pi
              else kk0:=0;
 end;
 result:= (kk0/(pi/180)) ;
end;

procedure odswiezinfo;
begin
{form1.info.caption:='Iloœæ flag: '+inttostr(length(flagi))+#13#10+
                    'Iloœæ regionów: '+inttostr(length(prostokaty))+#13#10+
                    'Iloœæ kolesi: '+inttostr(ile_kolesi)+#13#10+
                    'Iloœæ wejœæ: '+inttostr(ile_wejsc);}
end;

procedure TForm1.FormCreate(Sender: TObject);
const odstep=20;
var a:integer;
begin
ChDir(ExtractFilePath(Application.ExeName));

with ustawienia do begin
     zoom:=1;
     mies_zoom:=1;
     aniwybrana:=0;
     mies_aniwybrana:=0;
end;
Skrolpodglad.DoubleBuffered:=true;
mies_Skrolpodglad.DoubleBuffered:=true;

ndatastworzenia.DateTime:=now;

for a:=0 to high(dzwieki_labele) do begin
    dzwieki_labele[a]:=TLabel.create(form1);
    with dzwieki_labele[a] do begin
       parent:=skroldzwieki;
       visible:=true;
       left:=20;
       top:=5+a*odstep;
       caption:=nazwydzwiekow[a];
       tag:=a;
    end;
    dzwieki_edity[a]:=TEdit.create(form1);
    with dzwieki_edity[a] do begin
       parent:=skroldzwieki;
       anchors:=[akright, aktop, akleft];
       visible:=true;
       left:=200;
       width:=skroldzwieki.width-left-55;
       top:=5+a*odstep;
       text:='';
       tag:=a;
    end;
    dzwieki_zmien[a]:=TSpeedButton.create(form1);
    with dzwieki_zmien[a] do begin
       parent:=skroldzwieki;
       anchors:=[akright, aktop];
       visible:=true;
       left:=skroldzwieki.width-25-25;
       width:=24;
       height:=20;
       top:=5+a*odstep;
       ParentFont:=false;
       caption:='1';
       font.Name:='Wingdings';
       font.size:=11;
       flat:=true;
       tag:=a;
       onclick:=wybierzwav;
    end;
    dzwieki_play[a]:=TSpeedButton.create(form1);
    with dzwieki_play[a] do begin
       parent:=skroldzwieki;
       anchors:=[akright, aktop];
       visible:=true;
       left:=skroldzwieki.width-25;
       width:=20;
       height:=20;
       top:=5+a*odstep;
       ParentFont:=false;
       caption:='8';
       font.Name:='Marlett';
       font.size:=15;
       flat:=true;
       tag:=a;
       onclick:=odtworzwav;
    end;
end;

for a:=0 to high(dymki_labele) do begin
    dymki_labele[a]:=TLabel.create(form1);
    with dymki_labele[a] do begin
       parent:=skroldymki;
       visible:=true;
       left:=20;
       top:=5+a*odstep;
       caption:=nazwy_dymkow[a];
       tag:=a;
    end;
    dymki_comboboxy[a]:=TCombobox.create(form1);
    with dymki_comboboxy[a] do begin
       parent:=skroldymki;
       anchors:=[akright, aktop, akleft];
       visible:=true;
       left:=200;
       width:=skroldymki.width-left-55;
       top:=5+a*odstep;
       text:='';
       tag:=a;
    end;
    dymki_guzdod[a]:=TSpeedButton.create(form1);
    with dymki_guzdod[a] do begin
       parent:=skroldymki;
       anchors:=[akright, aktop];
       visible:=true;
       left:=skroldymki.width-25-25;
       width:=24;
       height:=20;
       top:=5+a*odstep;
       ParentFont:=false;
       caption:='+';
       font.Name:='Arial';
       font.size:=13;
       flat:=true;
       tag:=a;
       onclick:=dodajdymek;
    end;
    dymki_guzusun[a]:=TSpeedButton.create(form1);
    with dymki_guzusun[a] do begin
       parent:=skroldymki;
       anchors:=[akright, aktop];
       visible:=true;
       left:=skroldymki.width-25;
       width:=24;
       height:=20;
       top:=5+a*odstep;
       ParentFont:=false;
       caption:='-';
       font.Name:='Arial';
       font.size:=13;
       flat:=true;
       tag:=a;
       onclick:=usundymek;
    end;
end;

for a:=0 to high(ani_labele) do begin
    ani_labele[a]:=TLabel.create(form1);
    with ani_labele[a] do begin
       parent:=Listaanimacji;
       AutoSize:=false;
       anchors:=[akleft,aktop,akright];
       visible:=true;
       left:=1;
       width:=Listaanimacji.width-3;
       top:=2+a*odstep;
       height:=18;
       tag:=a;
       Layout:=tlCenter;
       caption:=' '+nazwyani[a];
       onclick:=wybierzanimacje;
    end;
    ani_edity[a]:=TEdit.create(form1);
    with ani_edity[a] do begin
       parent:=Listaanimacji;
       visible:=true;
       left:=130;
       width:=Listaanimacji.width-27-left;
       anchors:=[akright,akleft,aktop];
       top:=1+a*odstep;
       tag:=a;
       text:='';
    end;
    ani_zmien[a]:=TSpeedButton.create(form1);
    with ani_zmien[a] do begin
       parent:=Listaanimacji;
       visible:=true;
       left:=Listaanimacji.width-25;
       anchors:=[akright,aktop];
       width:=22;
       height:=20;
       top:=1+a*odstep;
       caption:='1';
       font.Name:='Wingdings';
       font.size:=10;
       tag:=a;
       flat:=true;
       OnClick:=wyborbitmapy;
    end;
end;
wybierzanimacje(ani_labele[0]);

for a:=0 to high(mies_ani_labele) do begin
    mies_ani_labele[a]:=TLabel.create(form1);
    with mies_ani_labele[a] do begin
       parent:=mies_Listaanimacji;
       AutoSize:=false;
       anchors:=[akleft,aktop,akright];
       visible:=true;
       left:=1;
       width:=mies_Listaanimacji.width-3;
       top:=2+a*odstep;
       height:=18;
       tag:=a;
       Layout:=tlCenter;
       caption:=' '+mies_nazwyani[a];
       onclick:=mies_wybierzanimacje;
    end;
    mies_ani_edity[a]:=TEdit.create(form1);
    with mies_ani_edity[a] do begin
       parent:=mies_Listaanimacji;
       visible:=true;
       left:=80;
       width:=mies_Listaanimacji.width-27-left;
       anchors:=[akright,akleft,aktop];
       top:=1+a*odstep;
       tag:=a;
       text:='';
    end;
    mies_ani_zmien[a]:=TSpeedButton.create(form1);
    with mies_ani_zmien[a] do begin
       parent:=mies_Listaanimacji;
       visible:=true;
       left:=mies_Listaanimacji.width-25;
       anchors:=[akright,aktop];
       width:=22;
       height:=20;
       top:=1+a*odstep;
       caption:='1';
       font.Name:='Wingdings';
       font.size:=10;
       tag:=a;
       flat:=true;
       OnClick:=mies_wyborbitmapy;
    end;
end;
mies_wybierzanimacje(mies_ani_labele[0]);


randomize;

zroblistyplikow;

setlength(druzyna[1].aninudzi,1);
druzyna[1].aninudzi[0].od:=0;
druzyna[1].aninudzi[0].ile:=1;
druzyna[1].aninudzi[0].szyb:=1;
druzyna[1].aninudzi[0].tylkoraz:=true;

for a:=0 to max_ani do begin
    setlength(druzyna[1].anibombana[a],0);
end;

Nowadruzyna;

podgani.Repaint;
end;

function sprawdzpoprawnosc(a:string; min_:integer=-1; max_:integer=-2):string;
var wart,i:integer;
begin
  val(a,wart,i);
  if (i<>0) then begin
     if min_<=max_ then a:=inttostr(min_)
        else a:='0';
  end
  else if ((min_<=max_) and ((wart<min_) or (wart>max_))) then a:=inttostr(min_);
  result:=a;
end;


procedure wczytaj_teren(nazwa:string);
begin

end;

procedure tform1.zroblistyplikow;
var
  sr: TSearchRec;
  FileAttrs: Integer;
begin
  ListaDruzyn.Clear;
  FileAttrs := faAnyFile;
  if FindFirst('Teams\*.s3p', FileAttrs, sr)=0 then begin
     repeat
        sr.Name:=copy(sr.Name,1,length(sr.name)-4);
        ListaDruzyn.Items.Add(sr.name);
     until FindNext(sr) <>0;
     FindClose(sr);
  end;

end;

procedure TForm1.zoominClick(Sender: TObject);
begin
ustawienia.zoom:=ustawienia.zoom*2;
zoombar.Position:=round(ustawienia.zoom*100);
end;                                   

procedure TForm1.zoomoutClick(Sender: TObject);
begin
ustawienia.zoom:=ustawienia.zoom/2;
zoombar.Position:=round(ustawienia.zoom*100);
end;

procedure TForm1.zoom100Click(Sender: TObject);
begin
ustawienia.zoom:=1;
zoombar.Position:=round(ustawienia.zoom*100);
end;

procedure TForm1.zoomcaleClick(Sender: TObject);
var r:double;
begin
ustawienia.zoom:=(form1.skrolpodglad.width-5)/30;
r:=(form1.skrolpodglad.height-5)/30;
if r<ustawienia.zoom then ustawienia.zoom:=r;
zoombar.Position:=round(ustawienia.zoom*100);
end;

procedure TForm1.zoombarChange(Sender: TObject);
begin
ustawienia.zoom:=zoombar.Position/100;
form1.podgani.Repaint;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
tekstoprogramie.Refresh;
podgani.Repaint;
mies_podgani.Repaint;
end;


procedure TForm1.ZapiszClick(Sender: TObject);
begin
if MessageBox(h,pchar('Czy chcesz zapisaæ dru¿ynê pod nazw¹ '+nnazwa.Text+'?'),'Uwaga', MB_YESNO or MB_ICONWARNING or MB_SYSTEMMODAL)= IDYES then begin
   spakujpliki('Teams\'+nnazwa.Text+'.s3p');
   zroblistyplikow;
end;
end;

procedure TForm1.listadruzynClick(Sender: TObject);
var a:integer;
begin
if (sender as tlistbox).ItemIndex>=0 then begin
   ustawienia.wybranadruzyna:=(sender as tlistbox).items[(sender as tlistbox).ItemIndex];
   Wczytaj.Enabled:=true;
   a:=(sender as tlistbox).ItemIndex;
   zroblistyplikow;
   (sender as tlistbox).ItemIndex:=a;
end;
end;

procedure TForm1.WczytajClick(Sender: TObject);
begin
{wczytaj_misje(ustawienia.wybranadruzyna);
wczytaj_teren(ustawienia.wybranyteren);}
if MessageBox(h,pchar('Czy chcesz wczytaæ dru¿ynê '+ustawienia.wybranadruzyna+'?'),'Uwaga', MB_YESNO or MB_ICONWARNING or MB_SYSTEMMODAL)= IDYES then begin
   Wczytajdruzyne(ustawienia.wybranadruzyna);
end;
end;

procedure TForm1.zmienkolorkrwiClick(Sender: TObject);
begin
ColorDialog1.Color:=nkolorkrwi.Brush.Color;
if ColorDialog1.Execute then begin
   druzyna[1].kolor_krwi:=ColorDialog1.Color;
   nkolorkrwi.Brush.Color:=ColorDialog1.Color;
end;
end;

procedure TForm1.Splitter3CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
if newsize<210 then newsize:=210;
end;

procedure TForm1.wyborbitmapy(Sender: TObject);
var a:integer;
begin
if opendialogtga.execute then begin
   if wczytaj_animacje(d_animacje[(sender as tspeedbutton).tag],opendialogtga.filename,30) then begin
      ani_edity[(sender as tspeedbutton).tag].Text:=opendialogtga.filename;
      setlength(druzyna[1].anibombana[(sender as tspeedbutton).tag],d_animacje[(sender as tspeedbutton).tag].height div 30);
      setlength(druzyna[1].anibron   [(sender as tspeedbutton).tag],d_animacje[(sender as tspeedbutton).tag].height div 30);
   end;

end;
podgani.repaint;
end;

procedure TForm1.podganiPaint(Sender: TObject);
var
tr:trect;
bmp:tbitmap;
sx,sy,
ax,ay,ak:integer;
adx,ady:real;
k:real;
pk:array of tpoint;
kol:tcolor;
begin
//trunc(flagi[a].x*ustawienia.zoom)-rx div 2,trunc(flagi[a].y*ustawienia.zoom)-ry div 2
if d_animacje[ustawienia.aniwybrana]<>nil then begin
   bmp:=tbitmap.create;
   bmp.Width:=30;
   bmp.height:=30;
   bmp.PixelFormat:=pf32bit;
   tr:=rect(0,ustawienia.klatkawybrana*30,30,ustawienia.klatkawybrana*30+30);
   bmp.canvas.CopyRect(rect(0,0,30,30),d_animacje[ustawienia.aniwybrana].canvas,tr);

   sx:=(skrolpodglad.Width-4) div 2;
   sy:=(skrolpodglad.Height-4) div 2;

   tr.TopLeft:=point( sx-trunc(30*ustawienia.zoom) div 2,
                      sy-trunc(30*ustawienia.zoom) div 2);
   tr.bottomright:=point( tr.left+trunc(30*ustawienia.zoom),
                          tr.top+trunc(30*ustawienia.zoom));

   form1.podgani.canvas.stretchdraw(tr,bmp);
   bmp.free;
   bmp:=nil;

   if pok_wekt.Down then begin {pokazuj wektor}
      ax:=druzyna[1].anidzialanie[ustawienia.aniwybrana].x;
      ay:=druzyna[1].anidzialanie[ustawienia.aniwybrana].y;
      adx:=druzyna[1].anidzialanie[ustawienia.aniwybrana].dx*3;
      ady:=druzyna[1].anidzialanie[ustawienia.aniwybrana].dy*3;
      if druzyna[1].anidzialanie[ustawienia.aniwybrana].klatka=ustawienia.klatkawybrana then
         kol:=$0000FF
         else kol:=$404080;
      form1.podgani.canvas.Pen.color:=kol;
      form1.podgani.canvas.Brush.color:=kol;
      form1.podgani.canvas.Ellipse(trunc( sx+ax*ustawienia.zoom+ustawienia.zoom/2 -0.5*ustawienia.zoom),
                                   trunc( sy+ay*ustawienia.zoom+ustawienia.zoom/2 -0.5*ustawienia.zoom),
                                   trunc( sx+ax*ustawienia.zoom+ustawienia.zoom/2 +0.5*ustawienia.zoom),
                                   trunc( sy+ay*ustawienia.zoom+ustawienia.zoom/2 +0.5*ustawienia.zoom));
      if druzyna[1].anidzialanie[ustawienia.aniwybrana].klatka=ustawienia.klatkawybrana then
         kol:=$dF00dF
         else kol:=$7F407F;
      form1.podgani.canvas.Pen.color:=kol;
      form1.podgani.canvas.MoveTo(trunc( sx+ax*ustawienia.zoom+ustawienia.zoom/2 ),
                                  trunc( sy+ay*ustawienia.zoom+ustawienia.zoom/2 ));
      form1.podgani.canvas.LineTo(trunc( sx+(ax+adx)*ustawienia.zoom+ustawienia.zoom/2 ),
                                  trunc( sy+(ay+ady)*ustawienia.zoom+ustawienia.zoom/2 ));

      if druzyna[1].anidzialanie[ustawienia.aniwybrana].klatka=ustawienia.klatkawybrana then
         kol:=$FF0000
         else kol:=$804040;
      form1.podgani.canvas.Pen.color:=kol;
      form1.podgani.canvas.brush.color:=kol;
      setlength(pk,3);
      pk[0]:=point( trunc( sx+(ax+adx)*ustawienia.zoom+ustawienia.zoom/2 ),
                    trunc( sy+(ay+ady)*ustawienia.zoom+ustawienia.zoom/2 ));

      k:=jaki_to_kat_real(adx,ady)+165;
      pk[1]:=point( trunc( sx+(ax+adx+sin(k*(pi/180))*2)*ustawienia.zoom+ustawienia.zoom/2 ),
                    trunc( sy+(ay+ady-cos(k*(pi/180))*2)*ustawienia.zoom+ustawienia.zoom/2 ));

      k:=jaki_to_kat_real(adx,ady)+195;
      pk[2]:=point( trunc( sx+(ax+adx+sin(k*(pi/180))*2)*ustawienia.zoom+ustawienia.zoom/2 ),
                    trunc( sy+(ay+ady-cos(k*(pi/180))*2)*ustawienia.zoom+ustawienia.zoom/2 ));

      (sender as tpaintbox).canvas.Polygon(pk);

   end else
   if pok_bom.Down then begin {pokazuj bombe}
      ax:=druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].x;
      ay:=druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].y;
      ak:=druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].klatka*6+45;
      kol:=$00FF00;
      form1.podgani.canvas.Pen.color:=kol;
      form1.podgani.canvas.Brush.color:=kol;
      form1.podgani.canvas.Ellipse(trunc( sx+ax*ustawienia.zoom+ustawienia.zoom/2 -0.5*ustawienia.zoom),
                                   trunc( sy+ay*ustawienia.zoom+ustawienia.zoom/2 -0.5*ustawienia.zoom),
                                   trunc( sx+ax*ustawienia.zoom+ustawienia.zoom/2 +0.5*ustawienia.zoom),
                                   trunc( sy+ay*ustawienia.zoom+ustawienia.zoom/2 +0.5*ustawienia.zoom));
      adx:=10;
      ady:=10;
      setlength(pk,5);
      pk[0]:=point( trunc( sx+(ax+sin((ak)*(pi/180))*adx )*ustawienia.zoom+ustawienia.zoom/2 ),
                    trunc( sy+(ay-cos((ak)*(pi/180))*ady )*ustawienia.zoom+ustawienia.zoom/2 ));
      pk[1]:=point( trunc( sx+(ax+sin((ak+90)*(pi/180))*adx )*ustawienia.zoom+ustawienia.zoom/2 ),
                    trunc( sy+(ay-cos((ak+90)*(pi/180))*ady )*ustawienia.zoom+ustawienia.zoom/2 ));
      pk[2]:=point( trunc( sx+(ax+sin((ak+180)*(pi/180))*adx )*ustawienia.zoom+ustawienia.zoom/2 ),
                    trunc( sy+(ay-cos((ak+180)*(pi/180))*ady )*ustawienia.zoom+ustawienia.zoom/2 ));
      pk[3]:=point( trunc( sx+(ax+sin((ak+270)*(pi/180))*adx )*ustawienia.zoom+ustawienia.zoom/2 ),
                    trunc( sy+(ay-cos((ak+270)*(pi/180))*ady )*ustawienia.zoom+ustawienia.zoom/2 ));
      pk[4]:=pk[0];

      (sender as tpaintbox).canvas.Polyline(pk);
   end else
   if pok_bron.Down then begin {pokazuj bron}
      ax:=druzyna[1].anibron[ustawienia.aniwybrana][ustawienia.klatkawybrana].x;
      ay:=druzyna[1].anibron[ustawienia.aniwybrana][ustawienia.klatkawybrana].y;
      ak:=trunc( druzyna[1].anibron[ustawienia.aniwybrana][ustawienia.klatkawybrana].kat*(360/256) );
      kol:=$00FF00;
      form1.podgani.canvas.Pen.color:=kol;
      form1.podgani.canvas.Brush.color:=kol;
      form1.podgani.canvas.Ellipse(trunc( sx+ax*ustawienia.zoom+ustawienia.zoom/2 -0.5*ustawienia.zoom),
                                   trunc( sy+ay*ustawienia.zoom+ustawienia.zoom/2 -0.5*ustawienia.zoom),
                                   trunc( sx+ax*ustawienia.zoom+ustawienia.zoom/2 +0.5*ustawienia.zoom),
                                   trunc( sy+ay*ustawienia.zoom+ustawienia.zoom/2 +0.5*ustawienia.zoom));
      adx:=16;
      ady:=4.5;
      setlength(pk,5);
      pk[0]:=point( trunc( sx+(ax+ sin((ak    )*(pi/180))*adx  )*ustawienia.zoom+ustawienia.zoom/2 ),
                    trunc( sy+(ay- cos((ak    )*(pi/180))*ady  )*ustawienia.zoom+ustawienia.zoom/2 ));
      pk[1]:=point( trunc( sx+(ax+ sin((ak+90 )*(pi/180))*adx  )*ustawienia.zoom+ustawienia.zoom/2 ),
                    trunc( sy+(ay- cos((ak+90 )*(pi/180))*ady  )*ustawienia.zoom+ustawienia.zoom/2 ));
      pk[2]:=point( trunc( sx+(ax+ sin((ak+180)*(pi/180))*adx  )*ustawienia.zoom+ustawienia.zoom/2 ),
                    trunc( sy+(ay- cos((ak+180)*(pi/180))*ady  )*ustawienia.zoom+ustawienia.zoom/2 ));
      pk[3]:=point( trunc( sx+(ax+ sin((ak+270)*(pi/180))*adx  )*ustawienia.zoom+ustawienia.zoom/2 ),
                    trunc( sy+(ay- cos((ak+270)*(pi/180))*ady  )*ustawienia.zoom+ustawienia.zoom/2 ));
      pk[4]:=pk[0];

      (sender as tpaintbox).canvas.Polyline(pk);
      form1.podgani.canvas.Ellipse(pk[0].x-3,pk[0].y-3,pk[0].x+3,pk[0].y+3);
   end;

   klatki.Caption:='Klatka: '+inttostr(ustawienia.klatkawybrana+1)+' / '+inttostr(d_animacje[ustawienia.aniwybrana].height div 30);
   pok_wekt_dx.text:=floattostr(druzyna[1].anidzialanie[ustawienia.aniwybrana].dx);
   pok_wekt_dy.text:=floattostr(druzyna[1].anidzialanie[ustawienia.aniwybrana].dy);
   pok_wekt_sila.text:=floattostr(sqrt2(sqr(druzyna[1].anidzialanie[ustawienia.aniwybrana].dx)+sqr(druzyna[1].anidzialanie[ustawienia.aniwybrana].dy)));
   pok_wekt_klatka.text:=inttostr(druzyna[1].anidzialanie[ustawienia.aniwybrana].klatka);

   pok_bom_x.text:=inttostr(druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].x);
   pok_bom_y.text:=inttostr(druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].y);
   pok_bom_kat.text:=inttostr(druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].klatka*6);

   pok_bron_x.text:=inttostr(druzyna[1].anibron[ustawienia.aniwybrana][ustawienia.klatkawybrana].x);
   pok_bron_y.text:=inttostr(druzyna[1].anibron[ustawienia.aniwybrana][ustawienia.klatkawybrana].y);
   pok_bron_kat.text:=inttostr(trunc(druzyna[1].anibron[ustawienia.aniwybrana][ustawienia.klatkawybrana].kat*(360/256)));

   ani_szybk.enabled:=ustawienia.aniwybrana<>0;
   ani_szybk.text:=inttostr(druzyna[1].aniszyb[ustawienia.aniwybrana]);
   aniszybk.position:=druzyna[1].aniszyb[ustawienia.aniwybrana];
end else begin
   aniodtworz.down:=false;
   klatki.Caption:='';
   pok_wekt_dx.text:='';
   pok_wekt_dy.text:='';
   pok_wekt_sila.text:='';
   pok_wekt_klatka.text:='';
   ani_szybk.text:='';
   ani_szybk.enabled:=false;

   pok_bom_x.text:='';
   pok_bom_y.text:='';
   pok_bom_kat.text:='';

   pok_bron_x.text:='';
   pok_bron_y.text:='';
   pok_bron_kat.text:='';
end;

if ustawienia.aniwybrana in [3,8,11,12,15] then begin
   pok_wekt.Enabled:=d_animacje[ustawienia.aniwybrana]<>nil;
   zatwierdz_wekt.Enabled:=pok_wekt.Down;
   pok_wekt_dx.Enabled:=pok_wekt.Down;
   pok_wekt_dy.Enabled:=pok_wekt.Down;
   pok_wekt_klatka.Enabled:=pok_wekt.Down;
end else begin
   pok_wekt.Enabled:=false;
   zatwierdz_wekt.Enabled:=false;
   pok_wekt_dx.Enabled:=false;
   pok_wekt_dy.Enabled:=false;
   pok_wekt_klatka.Enabled:=false;
end;

if (d_animacje[0]<>nil) and (ustawienia.aniwybrana=0) then begin
   panel_stoi.Enabled:=true;
   panel_stoi.font.Color:=clBlack;
   stoi_ile.Color:=clWindow;
   stoi_od.Color:=clWindow;
   stoi_szyb.Color:=clWindow;
end else begin
   panel_stoi.Enabled:=false;
   panel_stoi.font.Color:=clBtnShadow;
   stoi_ile.Color:=clBtnFace;
   stoi_od.Color:=clBtnFace;
   stoi_szyb.Color:=clBtnFace;
end;
stoi_licznik.Caption:=inttostr(ustawienia.stoi_wyb+1)+'/'+inttostr(length(druzyna[1].aninudzi));
if length(druzyna[1].aninudzi)>=1 then begin
   stoi_od.Text:=inttostr(druzyna[1].aninudzi[ustawienia.stoi_wyb].od+1);
   stoi_ile.Text:=inttostr(druzyna[1].aninudzi[ustawienia.stoi_wyb].ile);
   stoi_szyb.Text:=inttostr(druzyna[1].aninudzi[ustawienia.stoi_wyb].szyb);
   stoi_zapetl.Checked:=not druzyna[1].aninudzi[ustawienia.stoi_wyb].tylkoraz;
end else begin
    ustawienia.stoi_wyb:=0;
    stoi_od.Text:='';
    stoi_ile.Text:='';
    stoi_szyb.Text:='';
end;
if ustawienia.stoi_wyb>high(druzyna[1].aninudzi) then ustawienia.stoi_wyb:=high(druzyna[1].aninudzi);

end;

procedure TForm1.klatkanastClick(Sender: TObject);
begin
if d_animacje[ustawienia.aniwybrana]<>nil then begin
    inc(ustawienia.klatkawybrana);
    if ustawienia.klatkawybrana>=d_animacje[ustawienia.aniwybrana].height div 30 then ustawienia.klatkawybrana:=0;
end;
podgani.repaint;
end;

procedure TForm1.klatkapopClick(Sender: TObject);
begin
if d_animacje[ustawienia.aniwybrana]<>nil then begin
    dec(ustawienia.klatkawybrana);
    if ustawienia.klatkawybrana<0 then ustawienia.klatkawybrana:=d_animacje[ustawienia.aniwybrana].height div 30-1;
end;
podgani.repaint;
end;

procedure TForm1.aniszybkChange(Sender: TObject);
begin
druzyna[1].aniszyb[ustawienia.aniwybrana]:=(sender as ttrackbar).Position;
ustawienia.doklatki:=0;
podgani.repaint;
end;

procedure TForm1.TimeraniTimer(Sender: TObject);
begin
if aniodtworz.down then begin
   inc(ustawienia.doklatki);
   if ustawienia.doklatki>=druzyna[1].aniszyb[ustawienia.aniwybrana] then begin
      ustawienia.doklatki:=0;
      //klatkanast.Click;

      if d_animacje[ustawienia.aniwybrana]<>nil then begin
          inc(ustawienia.klatkawybrana);
          if ustawienia.klatkawybrana>=ustawienia.odtw_od+ustawienia.odtw_ile then ustawienia.klatkawybrana:=ustawienia.odtw_od;
      end;
      podgani.repaint;

   end;
end;
end;

procedure TForm1.aniodtworzClick(Sender: TObject);
begin
timerani.Enabled:=(sender as tspeedbutton).down;
stoi_play.down:=false;
if timerani.Enabled and (d_animacje[ustawienia.aniwybrana]<>nil) then begin
   ustawienia.odtw_od:=0;
   ustawienia.odtw_ile:=d_animacje[ustawienia.aniwybrana].height div 30;
end;
podgani.repaint;
end;

procedure TForm1.wybierzanimacje(Sender: TObject);
var a:integer;
begin
ustawienia.aniwybrana:=(sender as tlabel).tag;
ustawienia.klatkawybrana:=0;

ustawienia.odtw_od:=0;
if d_animacje[ustawienia.aniwybrana]<>nil then
   ustawienia.odtw_ile:=d_animacje[ustawienia.aniwybrana].height div 30
   else ustawienia.odtw_ile:=1;
stoi_play.down:=false;

for a:=0 to high(ani_labele) do begin
    ani_labele[a].parentcolor:=true;
    ani_labele[a].font.Style:=[];
    ani_edity[a].color:=$F0ffff;
end;
(sender as tlabel).Color:=$00ffff;
ani_edity[ustawienia.aniwybrana].color:=$80ffff;
ani_labele[ustawienia.aniwybrana].font.Style:=[fsbold];

podgani.repaint;
Listaanimacji.repaint;
end;


procedure TForm1.pok_wektClick(Sender: TObject);
begin
pok_bom.Down:=false;
pok_bron.Down:=false;
podgani.Repaint;
end;

procedure TForm1.pok_bomClick(Sender: TObject);
begin
pok_wekt.Down:=false;
pok_bron.Down:=false;
podgani.Repaint;
end;

procedure TForm1.podganiMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if button=mbleft then kursor.ciagnie1:=true;
if button=mbright then kursor.ciagnie2:=true;
podganiMouseMove(podgani, shift, x,y);
end;

procedure TForm1.podganiMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if (button=mbleft) and not (ssShift in shift) then kursor.ciagnie1:=false;
if (button=mbleft) and (ssShift in shift) then kursor.ciagnie3:=false;
if button=mbright then kursor.ciagnie2:=false;
end;

procedure TForm1.podganiMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var kx,ky:real;
begin
kx:=kursor.rx; ky:=kursor.ry;
kursor.rx:= (-(skrolpodglad.Width-4) div 2+x-ustawienia.zoom/2)/ustawienia.zoom ;
kursor.ry:= (-(skrolpodglad.height-4) div 2+y-ustawienia.zoom/2)/ustawienia.zoom ;
kursor.x:=round(kursor.rx);
kursor.y:=round(kursor.ry);

if (pok_wekt.down) and (kursor.ciagnie2) then begin
   druzyna[1].anidzialanie[ustawienia.aniwybrana].x:=kursor.x;
   druzyna[1].anidzialanie[ustawienia.aniwybrana].y:=kursor.y;
   podgani.Repaint;
end;
if (pok_wekt.down) and (kursor.ciagnie1) then begin
   druzyna[1].anidzialanie[ustawienia.aniwybrana].dx:=(kursor.rx-druzyna[1].anidzialanie[ustawienia.aniwybrana].x)/3;
   druzyna[1].anidzialanie[ustawienia.aniwybrana].dy:=(kursor.ry-druzyna[1].anidzialanie[ustawienia.aniwybrana].y)/3;
   podgani.Repaint;
end;
if (pok_bom.down) and (kursor.ciagnie1) then begin
   druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].x:=kursor.x;
   druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].y:=kursor.y;
   podgani.Repaint;
end;
if (pok_bom.down) and (kursor.ciagnie2) then begin
   druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].klatka:=
    (druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].klatka+
      trunc((-kx+kursor.x)*2) +60) mod 60;
   podgani.Repaint;
end;
if (pok_bron.down) and (kursor.ciagnie1) then begin
   druzyna[1].anibron[ustawienia.aniwybrana][ustawienia.klatkawybrana].x:=kursor.x;
   druzyna[1].anibron[ustawienia.aniwybrana][ustawienia.klatkawybrana].y:=kursor.y;
   podgani.Repaint;
end;
if (pok_bron.down) and (kursor.ciagnie2) then begin
   druzyna[1].anibron[ustawienia.aniwybrana][ustawienia.klatkawybrana].kat:=
    (druzyna[1].anibron[ustawienia.aniwybrana][ustawienia.klatkawybrana].kat+
      trunc((-kx+kursor.x)*2) +256) mod 256;
   podgani.Repaint;
end;

end;

function wartosc(s:string):real;
var w:real; i:integer;
begin
//s:=(sender as tedit).text;
i:=1;
while (i<=length(s)) and (s[i] in ['0'..'9']) do inc(i);
if i<length(s) then s[i]:='.';
val(s,result,i);
end;

procedure TForm1.poprawwartosc(Sender: TObject);
var s:string; w:real; i:integer;
begin
s:=(sender as tedit).text;
i:=1;
while (i<=length(s)) and (s[i] in ['0'..'9']) do inc(i);
if i<length(s) then s[i]:='.';
val(s,w,i);

case (sender as tedit).tag of
 0:begin
   if i=0 then druzyna[1].anidzialanie[ustawienia.aniwybrana].dx:=w;
   end;
 1:begin
   if i=0 then druzyna[1].anidzialanie[ustawienia.aniwybrana].dy:=w;
   end;
 6:begin
   if i=0 then druzyna[1].anidzialanie[ustawienia.aniwybrana].klatka:=trunc(w) mod (d_animacje[ustawienia.aniwybrana].Height div 30);
   end;

 3:begin
   if i=0 then druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].x:=trunc(w);
   end;
 4:begin
   if i=0 then druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].y:=trunc(w);
   end;
 5:begin
   if i=0 then druzyna[1].anibombana[ustawienia.aniwybrana][ustawienia.klatkawybrana].klatka:=trunc(w/6) mod 60;
   end;

 7:begin
   if i=0 then begin
      druzyna[1].aniszyb[ustawienia.aniwybrana]:=trunc(w) mod 101;
      if druzyna[1].aniszyb[ustawienia.aniwybrana]<=0 then druzyna[1].aniszyb[ustawienia.aniwybrana]:=1;
   end;
   end;

 8:begin
   if i=0 then begin
      druzyna[1].aninudzi[ustawienia.stoi_wyb].od:=trunc(w-1);
      if druzyna[1].aninudzi[ustawienia.stoi_wyb].od<0 then druzyna[1].aninudzi[ustawienia.stoi_wyb].od:=0;
      if druzyna[1].aninudzi[ustawienia.stoi_wyb].od>d_animacje[0].Height div 30-1 then druzyna[1].aninudzi[ustawienia.stoi_wyb].od:=d_animacje[0].Height div 30-1;

      if druzyna[1].aninudzi[ustawienia.stoi_wyb].od+druzyna[1].aninudzi[ustawienia.stoi_wyb].ile>d_animacje[0].Height div 30 then
         druzyna[1].aninudzi[ustawienia.stoi_wyb].ile:=d_animacje[0].Height div 30-druzyna[1].aninudzi[ustawienia.stoi_wyb].od;
   end;
   end;
 9:begin
   if i=0 then begin
      druzyna[1].aninudzi[ustawienia.stoi_wyb].ile:=trunc(w);
      if druzyna[1].aninudzi[ustawienia.stoi_wyb].ile<1 then druzyna[1].aninudzi[ustawienia.stoi_wyb].ile:=1;
      if druzyna[1].aninudzi[ustawienia.stoi_wyb].ile>d_animacje[0].Height div 30 then druzyna[1].aninudzi[ustawienia.stoi_wyb].ile:=d_animacje[0].Height div 30;

      if druzyna[1].aninudzi[ustawienia.stoi_wyb].od+druzyna[1].aninudzi[ustawienia.stoi_wyb].ile>d_animacje[0].Height div 30 then
         druzyna[1].aninudzi[ustawienia.stoi_wyb].od:=d_animacje[0].Height div 30-druzyna[1].aninudzi[ustawienia.stoi_wyb].ile;
   end;
   end;
 10:begin
   if i=0 then begin
      druzyna[1].aninudzi[ustawienia.stoi_wyb].szyb:=trunc(w);
      if druzyna[1].aninudzi[ustawienia.stoi_wyb].szyb<1 then druzyna[1].aninudzi[ustawienia.stoi_wyb].szyb:=1;
      if druzyna[1].aninudzi[ustawienia.stoi_wyb].szyb>100 then druzyna[1].aninudzi[ustawienia.stoi_wyb].szyb:=100;

      if druzyna[1].aninudzi[ustawienia.stoi_wyb].od+druzyna[1].aninudzi[ustawienia.stoi_wyb].ile>d_animacje[0].Height div 30 then
         druzyna[1].aninudzi[ustawienia.stoi_wyb].od:=d_animacje[0].Height div 30-druzyna[1].aninudzi[ustawienia.stoi_wyb].ile;
   end;
   end;

end;
podgani.Repaint;
end;

procedure TForm1.pok_wekt_dxExit(Sender: TObject);
begin
poprawwartosc(sender);
end;

procedure TForm1.pok_wekt_dxKeyPress(Sender: TObject; var Key: Char);
begin
if key=#13 then poprawwartosc(sender);
end;

procedure TForm1.zatwierdz_wektClick(Sender: TObject);
begin
if pok_wekt_klatka.Focused then begin
   form1.ActiveControl:=nil;
   druzyna[1].anidzialanie[ustawienia.aniwybrana].klatka:=trunc(wartosc(pok_wekt_klatka.Text));
end else
    druzyna[1].anidzialanie[ustawienia.aniwybrana].klatka:=ustawienia.klatkawybrana;

podgani.Repaint;
end;

{---------}
procedure TForm1.wybierzwav(Sender: TObject);
begin
if opendialogwav.execute then begin
   //wczytaj_animacje((sender as tspeedbutton).tag,opendialogtga.filename);
   dzwieki_edity[(sender as tspeedbutton).tag].Text:=opendialogwav.filename;

end;
podgani.repaint;
end;

procedure TForm1.odtworzwav(Sender: TObject);
begin
PlaySound(pchar(dzwieki_edity[(sender as tspeedbutton).tag].Text), hinstance, SND_ASYNC);
end;




procedure TForm1.stoi_dodClick(Sender: TObject);
begin
if length(druzyna[1].aninudzi)<99 then
   setlength(druzyna[1].aninudzi,length(druzyna[1].aninudzi)+1);
   druzyna[1].aninudzi[high(druzyna[1].aninudzi)].od:=ustawienia.klatkawybrana;
   druzyna[1].aninudzi[high(druzyna[1].aninudzi)].ile:=1;
   druzyna[1].aninudzi[high(druzyna[1].aninudzi)].szyb:=1;
   druzyna[1].aninudzi[high(druzyna[1].aninudzi)].tylkoraz:=true;
podgani.Repaint;
end;

procedure TForm1.stoi_usunClick(Sender: TObject);
var
a:integer;

begin
if length(druzyna[1].aninudzi)>=2 then begin
   if ustawienia.stoi_wyb<high(druzyna[1].aninudzi)-1 then
      for a:=ustawienia.stoi_wyb to high(druzyna[1].aninudzi)-1 do begin
          druzyna[1].aninudzi[a].od:=druzyna[1].aninudzi[a+1].od;
          druzyna[1].aninudzi[a].ile:=druzyna[1].aninudzi[a+1].ile;
          druzyna[1].aninudzi[a].szyb:=druzyna[1].aninudzi[a+1].szyb;
          druzyna[1].aninudzi[a].tylkoraz:=druzyna[1].aninudzi[a+1].tylkoraz;
      end;
   setlength(druzyna[1].aninudzi,length(druzyna[1].aninudzi)-1);
end;

if ustawienia.stoi_wyb>high(druzyna[1].aninudzi) then ustawienia.stoi_wyb:=high(druzyna[1].aninudzi);

podgani.Repaint;

end;

procedure TForm1.stoi_popClick(Sender: TObject);
begin
dec(ustawienia.stoi_wyb);
if ustawienia.stoi_wyb<0 then ustawienia.stoi_wyb:=high(druzyna[1].aninudzi);
podgani.Repaint;
end;

procedure TForm1.stoi_nastClick(Sender: TObject);
begin
inc(ustawienia.stoi_wyb);
if ustawienia.stoi_wyb>high(druzyna[1].aninudzi) then ustawienia.stoi_wyb:=0;
podgani.Repaint;
end;

procedure TForm1.stoi_zapetlClick(Sender: TObject);
begin
druzyna[1].aninudzi[ustawienia.stoi_wyb].tylkoraz:=not (sender as tcheckbox).checked;
end;

procedure TForm1.stoi_od_wezClick(Sender: TObject);
begin
druzyna[1].aninudzi[ustawienia.stoi_wyb].od:=ustawienia.klatkawybrana;

if druzyna[1].aninudzi[ustawienia.stoi_wyb].od<0 then druzyna[1].aninudzi[ustawienia.stoi_wyb].od:=0;
if druzyna[1].aninudzi[ustawienia.stoi_wyb].od>d_animacje[0].Height div 30-1 then druzyna[1].aninudzi[ustawienia.stoi_wyb].od:=d_animacje[0].Height div 30-1;

if druzyna[1].aninudzi[ustawienia.stoi_wyb].od+druzyna[1].aninudzi[ustawienia.stoi_wyb].ile>d_animacje[0].Height div 30 then
   druzyna[1].aninudzi[ustawienia.stoi_wyb].ile:=d_animacje[0].Height div 30-druzyna[1].aninudzi[ustawienia.stoi_wyb].od;


podgani.Repaint;
end;

procedure TForm1.stoi_ile_wezClick(Sender: TObject);
begin
druzyna[1].aninudzi[ustawienia.stoi_wyb].ile:=ustawienia.klatkawybrana-druzyna[1].aninudzi[ustawienia.stoi_wyb].od+1;

if druzyna[1].aninudzi[ustawienia.stoi_wyb].ile<1 then druzyna[1].aninudzi[ustawienia.stoi_wyb].ile:=1;
if druzyna[1].aninudzi[ustawienia.stoi_wyb].ile>d_animacje[0].Height div 30 then druzyna[1].aninudzi[ustawienia.stoi_wyb].ile:=d_animacje[0].Height div 30;

if druzyna[1].aninudzi[ustawienia.stoi_wyb].od+druzyna[1].aninudzi[ustawienia.stoi_wyb].ile>d_animacje[0].Height div 30 then
   druzyna[1].aninudzi[ustawienia.stoi_wyb].od:=d_animacje[0].Height div 30-druzyna[1].aninudzi[ustawienia.stoi_wyb].ile;

podgani.Repaint;
end;

procedure TForm1.stoi_playClick(Sender: TObject);
begin
timerani.Enabled:=(sender as tspeedbutton).down;
aniodtworz.Down:=(sender as tspeedbutton).down;
if timerani.Enabled then begin
   ustawienia.odtw_od:=druzyna[1].aninudzi[ustawienia.stoi_wyb].od;
   ustawienia.odtw_ile:=druzyna[1].aninudzi[ustawienia.stoi_wyb].ile;
   aniszybk.Position:=druzyna[1].aninudzi[ustawienia.stoi_wyb].szyb;
   timerani.Enabled:=true;
end;
podgani.repaint;
end;

procedure TForm1.Splitter3Moved(Sender: TObject);
begin
statictext10.Repaint;
end;

procedure TForm1.pok_bronClick(Sender: TObject);
begin
pok_wekt.Down:=false;
pok_bom.Down:=false;
podgani.Repaint;
end;

{--------mieso-----------}
procedure TForm1.mies_wybierzanimacje(Sender: TObject);
var a:integer;
begin
ustawienia.mies_aniwybrana:=(sender as tlabel).tag;
ustawienia.mies_klatkawybrana:=0;

for a:=0 to high(mies_ani_labele) do begin
    mies_ani_labele[a].parentcolor:=true;
    mies_ani_labele[a].font.Style:=[];
    mies_ani_edity[a].color:=$F0ffff;
end;
(sender as tlabel).Color:=$00ffff;
mies_ani_edity[ustawienia.mies_aniwybrana].color:=$80ffff;
mies_ani_labele[ustawienia.mies_aniwybrana].font.Style:=[fsbold];

mies_podgani.repaint;
mies_Listaanimacji.repaint;
end;


procedure TForm1.mies_podganiPaint(Sender: TObject);
var
tr:trect;
bmp:tbitmap;
sx,sy,
ax,ay:integer;
adx,ady:real;
k:real;
pk:array[0..2] of tpoint;
kol:tcolor;
a:integer;

kk0:real;
dx,dy:integer;
begin
if mies_d_animacje[ustawienia.mies_aniwybrana]<>nil then begin
   if mies_widok_1.Down then begin {widok pojedynczego kawalka}
       bmp:=tbitmap.create;
       bmp.Width:=mies_d_ani_wym[ustawienia.mies_aniwybrana];
       bmp.height:=mies_d_ani_wym[ustawienia.mies_aniwybrana];
       bmp.PixelFormat:=pf32bit;

       tr.TopLeft:=point(     (ustawienia.mies_klatkawybrana mod (mies_d_animacje[ustawienia.mies_aniwybrana].Width div mies_d_ani_wym[ustawienia.mies_aniwybrana]) )*mies_d_ani_wym[ustawienia.mies_aniwybrana] ,
                              (ustawienia.mies_klatkawybrana div (mies_d_animacje[ustawienia.mies_aniwybrana].Width div mies_d_ani_wym[ustawienia.mies_aniwybrana]) )*mies_d_ani_wym[ustawienia.mies_aniwybrana] );
       tr.BottomRight:=point( tr.left+mies_d_ani_wym[ustawienia.mies_aniwybrana],
                              tr.top+mies_d_ani_wym[ustawienia.mies_aniwybrana]);

       bmp.canvas.CopyRect(rect(0,0,mies_d_ani_wym[ustawienia.mies_aniwybrana],mies_d_ani_wym[ustawienia.mies_aniwybrana]),mies_d_animacje[ustawienia.mies_aniwybrana].canvas,tr);

       sx:=(mies_skrolpodglad.Width-4) div 2;
       sy:=(mies_skrolpodglad.Height-4) div 2;

       tr.TopLeft:=point( sx-trunc(mies_d_ani_wym[ustawienia.mies_aniwybrana]*ustawienia.mies_zoom) div 2,
                          sy-trunc(mies_d_ani_wym[ustawienia.mies_aniwybrana]*ustawienia.mies_zoom) div 2);
       tr.bottomright:=point( tr.left+trunc(mies_d_ani_wym[ustawienia.mies_aniwybrana]*ustawienia.mies_zoom),
                              tr.top+trunc(mies_d_ani_wym[ustawienia.mies_aniwybrana]*ustawienia.mies_zoom));

       (sender as tpaintbox).canvas.stretchdraw(tr,bmp);
       bmp.free;
       bmp:=nil;
       mies_klatki.Caption:='Klatka: '+inttostr(ustawienia.mies_klatkawybrana+1)+' / '+inttostr(mies_d_animacje[ustawienia.mies_aniwybrana].height div mies_d_ani_wym[ustawienia.mies_aniwybrana]);
   end else begin {widok wszystkich}
       sx:=(mies_skrolpodglad.Width-4) div 2;
       sy:=(mies_skrolpodglad.Height-4) div 2;

       tr.TopLeft:=point( sx-trunc(30*ustawienia.mies_zoom) div 2,
                          sy-trunc(30*ustawienia.mies_zoom) div 2);
       tr.bottomright:=point( tr.left+trunc(30*ustawienia.mies_zoom),
                              tr.top+trunc(30*ustawienia.mies_zoom));

       (sender as tpaintbox).canvas.pen.color:=$206020;
       (sender as tpaintbox).canvas.Rectangle(tr);

       for a:=0 to 5 do
           if mies_d_animacje[a]<>nil then begin
               bmp:=tbitmap.create;
               bmp.Width:=mies_d_ani_wym[a];
               bmp.height:=mies_d_ani_wym[a];
               bmp.PixelFormat:=pf32bit;

               tr.TopLeft:=point(     (druzyna[1].miesomiejsca[a].kl mod (mies_d_animacje[a].Width div mies_d_ani_wym[a]) )*mies_d_ani_wym[a] ,
                                      (druzyna[1].miesomiejsca[a].kl div (mies_d_animacje[a].Width div mies_d_ani_wym[a]) )*mies_d_ani_wym[a] );
               tr.BottomRight:=point( tr.left+mies_d_ani_wym[a],
                                      tr.top+mies_d_ani_wym[a]);

               bmp.TransparentColor:=$FF00FF;
               bmp.Transparent:=true;
               bmp.canvas.CopyRect(rect(0,0,mies_d_ani_wym[a],mies_d_ani_wym[a]),mies_d_animacje[a].canvas,tr);

               tr.TopLeft:=point( sx+trunc((druzyna[1].miesomiejsca[a].x-mies_d_ani_wym[a] div 2)*ustawienia.mies_zoom) ,
                                  sy+trunc((druzyna[1].miesomiejsca[a].y-mies_d_ani_wym[a] div 2)*ustawienia.mies_zoom) );
               tr.bottomright:=point( tr.left+trunc(mies_d_ani_wym[a]*ustawienia.mies_zoom),
                                      tr.top+trunc(mies_d_ani_wym[a]*ustawienia.mies_zoom));

               (sender as tpaintbox).canvas.stretchdraw(tr,bmp);
               bmp.free;
               bmp:=nil;
           end;

       for a:=0 to 5 do begin
           kol:=$00FF00;
           (sender as tpaintbox).canvas.Pen.color:=kol;
           (sender as tpaintbox).canvas.Brush.color:=kol;
           ax:=druzyna[1].miesomiejsca[a].zaczx+druzyna[1].miesomiejsca[a].x;
           ay:=druzyna[1].miesomiejsca[a].zaczy+druzyna[1].miesomiejsca[a].y;
           (sender as tpaintbox).canvas.Ellipse(trunc( sx+ax*ustawienia.mies_zoom+ustawienia.mies_zoom/2 -0.5*ustawienia.mies_zoom),
                                                trunc( sy+ay*ustawienia.mies_zoom+ustawienia.mies_zoom/2 -0.5*ustawienia.mies_zoom),
                                                trunc( sx+ax*ustawienia.mies_zoom+ustawienia.mies_zoom/2 +0.5*ustawienia.mies_zoom),
                                                trunc( sy+ay*ustawienia.mies_zoom+ustawienia.mies_zoom/2 +0.5*ustawienia.mies_zoom));
      adx:=16;
       end;

       mies_klatki.Caption:='X';
   end;

   mies_miejs_x.text:=inttostr(druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].x);
   mies_miejs_y.text:=inttostr(druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].y);
   mies_miejs_kl.text:=inttostr(druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].kl);
   mies_miejs_zaczx.text:=inttostr(druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].zaczx);
   mies_miejs_zaczy.text:=inttostr(druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].zaczy);

   mies_wym.text:=inttostr(mies_d_ani_wym[ustawienia.mies_aniwybrana]);
   mies_wym_x.text:=inttostr(mies_d_animacje[ustawienia.mies_aniwybrana].Width div mies_d_ani_wym[ustawienia.mies_aniwybrana]);
   mies_wym_y.text:=inttostr(mies_d_animacje[ustawienia.mies_aniwybrana].Height div mies_d_ani_wym[ustawienia.mies_aniwybrana]);

   mies_ileklatek.text:=inttostr(mies_d_ani_ilekl[ustawienia.mies_aniwybrana]);


   dx:=druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].x-druzyna[1].miesomiejsca[1].x;
   dy:=druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].y-druzyna[1].miesomiejsca[1].y;

   kk0:=0;
   if dx>0 then begin
      if (dy>0) then kk0:=arctan(dy/dx)+pi/2
                else kk0:=arctan(dy/dx)+pi/2;
   end else if dx<0 then begin
      if (dy>0) then kk0:=arctan(dy/dx)+(3/2)*pi
                else kk0:=arctan(dy/dx)+(3/2)*pi;
   end else begin
      if (dy>0) then kk0:=pi
                else kk0:=0;
   end;

   mies_miejs_kat.text:=inttostr( trunc( (kk0/(pi/180)) ) );
   mies_miejs_odl.text:=inttostr( trunc( sqrt2(sqr(dx)+sqr(dy)) ));


end else begin
   mies_aniodtworz.down:=false;
   mies_klatki.Caption:='';

   mies_miejs_x.text:='';
   mies_miejs_y.text:='';
   mies_miejs_kl.text:='';

   mies_wym.text:='';
   mies_wym_x.text:='';
   mies_wym_y.text:='';

   mies_ileklatek.text:='';

   mies_miejs_kat.text:='';
   mies_miejs_odl.text:='';

end;

end;

procedure TForm1.mies_wyborbitmapy(Sender: TObject);
var a:integer;
begin
if opendialogtga.execute then begin
   if wczytaj_animacje(mies_d_animacje[(sender as tspeedbutton).tag],opendialogtga.filename,0) then begin
      mies_ani_edity[(sender as tspeedbutton).tag].Text:=opendialogtga.filename;
      mies_d_ani_wym[(sender as tspeedbutton).tag]:=mies_d_animacje[(sender as tspeedbutton).tag].Width;
      mies_d_ani_ilekl[(sender as tspeedbutton).tag]:=
         (mies_d_animacje[(sender as tspeedbutton).tag].Width div
          mies_d_ani_wym[(sender as tspeedbutton).tag])*
         (mies_d_animacje[(sender as tspeedbutton).tag].height div
          mies_d_ani_wym[(sender as tspeedbutton).tag]);
   end;
end;
mies_podgani.repaint;
end;


procedure TForm1.mies_zoominClick(Sender: TObject);
begin
ustawienia.mies_zoom:=ustawienia.mies_zoom*2;
mies_zoombar.Position:=round(ustawienia.mies_zoom*100);
mies_podgani.repaint;
end;

procedure TForm1.mies_zoomoutClick(Sender: TObject);
begin
ustawienia.mies_zoom:=ustawienia.mies_zoom/2;
mies_zoombar.Position:=round(ustawienia.mies_zoom*100);
mies_podgani.repaint;
end;

procedure TForm1.mies_zoom100Click(Sender: TObject);
begin
ustawienia.mies_zoom:=1;
mies_zoombar.Position:=round(ustawienia.mies_zoom*100);
mies_podgani.repaint;
end;

procedure TForm1.mies_zoomcaleClick(Sender: TObject);
var r:double;
begin
if mies_d_animacje[ustawienia.mies_aniwybrana]=nil then exit;
ustawienia.mies_zoom:=(form1.mies_skrolpodglad.width-5)/mies_d_ani_wym[ustawienia.mies_aniwybrana];
r:=(form1.mies_skrolpodglad.height-5)/mies_d_ani_wym[ustawienia.mies_aniwybrana];
if r<ustawienia.mies_zoom then ustawienia.mies_zoom:=r;
mies_zoombar.Position:=round(ustawienia.mies_zoom*100);
form1.mies_podgani.Repaint;
end;

procedure TForm1.mies_zoombarChange(Sender: TObject);
begin
ustawienia.mies_zoom:=mies_zoombar.Position/100;
form1.mies_podgani.Repaint;
end;

procedure TForm1.mies_poprawwartosc(Sender: TObject);
var s:string; w:real; i:integer;
begin
s:=(sender as tedit).text;
i:=1;
while (i<=length(s)) and (s[i] in ['0'..'9']) do inc(i);
if i<length(s) then s[i]:='.';
val(s,w,i);

case (sender as tedit).tag of
 0:begin
   if i=0 then druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].x:=trunc(w);
   end;
 1:begin
   if i=0 then druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].y:=trunc(w);
   end;
 2:begin
   if i=0 then druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].kl:=trunc(w) mod mies_d_ani_ilekl[ustawienia.mies_aniwybrana];
   if druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].kl<0 then druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].kl:=0;
   end;

 3:begin
   if i=0 then mies_d_ani_wym[ustawienia.mies_aniwybrana]:=trunc(w);
   if mies_d_ani_wym[ustawienia.mies_aniwybrana]<1 then mies_d_ani_wym[ustawienia.mies_aniwybrana]:=1;
   if mies_d_ani_wym[ustawienia.mies_aniwybrana]>mies_d_animacje[ustawienia.mies_aniwybrana].width then mies_d_ani_wym[ustawienia.mies_aniwybrana]:=mies_d_animacje[ustawienia.mies_aniwybrana].width;
   if mies_d_ani_wym[ustawienia.mies_aniwybrana]>mies_d_animacje[ustawienia.mies_aniwybrana].Height then mies_d_ani_wym[ustawienia.mies_aniwybrana]:=mies_d_animacje[ustawienia.mies_aniwybrana].Height;
   end;

 6:begin
   if i=0 then mies_d_ani_ilekl[ustawienia.mies_aniwybrana]:=trunc(w);
   if mies_d_ani_ilekl[ustawienia.mies_aniwybrana]<1 then mies_d_ani_ilekl[ustawienia.mies_aniwybrana]:=1;
   end;
 7:begin
   if i=0 then druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].zaczx:=trunc(w);
   end;
 8:begin
   if i=0 then druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].zaczy:=trunc(w);
   end;

end;
mies_podgani.Repaint;
end;

procedure TForm1.mies_miejs_xKeyPress(Sender: TObject; var Key: Char);
begin
if key=#13 then mies_poprawwartosc(sender);
end;

procedure TForm1.mies_miejs_xExit(Sender: TObject);
begin
mies_poprawwartosc(sender);
end;

procedure TForm1.mies_klatkanastClick(Sender: TObject);
begin
if mies_d_animacje[ustawienia.mies_aniwybrana]<>nil then begin
    inc(ustawienia.mies_klatkawybrana);
    if ustawienia.mies_klatkawybrana>=mies_d_ani_ilekl[ustawienia.mies_aniwybrana] then ustawienia.mies_klatkawybrana:=0;
end;
mies_podgani.repaint;
end;

procedure TForm1.mies_klatkapopClick(Sender: TObject);
begin
if mies_d_animacje[ustawienia.mies_aniwybrana]<>nil then begin
    dec(ustawienia.mies_klatkawybrana);
    if ustawienia.mies_klatkawybrana<0 then ustawienia.mies_klatkawybrana:=mies_d_ani_ilekl[ustawienia.mies_aniwybrana]-1;
end;
mies_podgani.repaint;
end;

procedure TForm1.mies_aniszybkChange(Sender: TObject);
begin
ustawienia.mies_anisz:=(sender as ttrackbar).Position;
ustawienia.doklatki:=0;
mies_podgani.repaint;
end;

procedure TForm1.mies_aniodtworzClick(Sender: TObject);
begin
if mies_widok_2.down then begin
   (sender as tspeedbutton).down:=false;
   exit;
end;
mies_timerani.Enabled:=(sender as tspeedbutton).down;
{if timerani.Enabled and (mies_d_animacje[ustawienia.mies_aniwybrana]<>nil) then begin
   ustawienia.odtw_od:=0;
   ustawienia.odtw_ile:=mies_d_ani_ilekl[ustawienia.mies_aniwybrana];
end;}
mies_podgani.repaint;
end;

procedure TForm1.mies_TimeraniTimer(Sender: TObject);
begin
if mies_aniodtworz.down then begin
   inc(ustawienia.doklatki);
   if ustawienia.doklatki>=ustawienia.mies_anisz then begin
      ustawienia.doklatki:=0;
      mies_klatkanast.Click;
   end;
end;
end;

procedure TForm1.mies_widok_2Click(Sender: TObject);
begin
mies_aniodtworz.down:=false;
mies_Timerani.Enabled:=false;
mies_podgani.repaint;
mies_Listaanimacji.repaint;
end;

procedure TForm1.mies_widok_1Click(Sender: TObject);
begin
mies_podgani.repaint;
mies_Listaanimacji.repaint;
end;

procedure TForm1.mies_podganiMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var kx,ky:real;
begin
kx:=kursor.rx; ky:=kursor.ry;
kursor.rx:= (-(mies_skrolpodglad.Width-4) div 2+x-ustawienia.mies_zoom/2)/ustawienia.mies_zoom ;
kursor.ry:= (-(mies_skrolpodglad.height-4) div 2+y-ustawienia.mies_zoom/2)/ustawienia.mies_zoom ;
kursor.x:=round(kursor.rx);
kursor.y:=round(kursor.ry);

if (kursor.ciagnie1) then begin
   druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].x:=kursor.x;
   druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].y:=kursor.y;
   mies_podgani.Repaint;
end;
if (kursor.ciagnie2) then begin
   druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].kl:=(druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].kl+ trunc((kx-kursor.x)*2) +mies_d_ani_ilekl[ustawienia.mies_aniwybrana]) mod mies_d_ani_ilekl[ustawienia.mies_aniwybrana];
   mies_podgani.Repaint;
end;
if (kursor.ciagnie3) then begin
   druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].zaczx:=kursor.x-druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].x;
   druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].zaczy:=kursor.y-druzyna[1].miesomiejsca[ustawienia.mies_aniwybrana].y;
   mies_podgani.Repaint;
end;
end;

procedure TForm1.mies_podganiMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if (button=mbleft) and not (ssShift in shift) then kursor.ciagnie1:=true;
if button=mbright then kursor.ciagnie2:=true;
if (button=mbleft) and (ssShift in shift) then kursor.ciagnie3:=true;
mies_podganiMouseMove(mies_podgani, shift, x,y);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
oczysc_pliki_tmp_druzyn;
end;

procedure TForm1.NowyClick(Sender: TObject);
begin
if MessageBox(h,'Czy chcesz stworzyæ now¹ dru¿ynê?','Uwaga', MB_YESNO or MB_ICONWARNING or MB_SYSTEMMODAL)= IDYES then
   Nowadruzyna;
end;

procedure TForm1.dzwiekistopClick(Sender: TObject);
begin
PlaySound(nil,hinstance,0);
end;

procedure TForm1.nkolorkrwiMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if (button=mbleft) and (x>=0) and (y>=0) and
   (x<=(sender as TShape).width) and (y<=(sender as TShape).height) then
   zmienkolorkrwiClick(zmienkolorkrwi);
end;

{------------------------------------------------}
procedure TForm1.ustpocsilaChange(Sender: TObject);
begin
barpocsila.Position:=(sender as TSpinEdit).Value;
end;

procedure TForm1.barpocsilaChange(Sender: TObject);
begin
ustpocsila.value:=(sender as TTrackBar).Position;
end;

procedure TForm1.ustmaxsilyChange(Sender: TObject);
begin
barmaxsily.Position:=(sender as TSpinEdit).Value;
end;

procedure TForm1.barmaxsilyChange(Sender: TObject);
begin
ustmaxsily.value:=(sender as TTrackBar).Position;
end;

procedure TForm1.ustmaxtlenChange(Sender: TObject);
begin
barmaxtlen.Position:=(sender as TSpinEdit).Value;
end;

procedure TForm1.barmaxtlenChange(Sender: TObject);
begin
ustmaxtlen.value:=(sender as TTrackBar).Position;
end;

procedure TForm1.ustszybChange(Sender: TObject);
begin
barszyb.Position:=(sender as TSpinEdit).Value;
end;

procedure TForm1.barszybChange(Sender: TObject);
begin
ustszyb.value:=(sender as TTrackBar).Position;
end;

procedure TForm1.ustwagaChange(Sender: TObject);
begin
barwaga.Position:=(sender as TSpinEdit).Value;
end;

procedure TForm1.barwagaChange(Sender: TObject);
begin
ustwaga.value:=(sender as TTrackBar).Position;
end;

procedure TForm1.ustsilabiciaChange(Sender: TObject);
begin
barsilabicia.Position:=(sender as TSpinEdit).Value;
end;

procedure TForm1.barsilabiciaChange(Sender: TObject);
begin
ustsilabicia.value:=(sender as TTrackBar).Position;
end;

procedure TForm1.ustamun0Change(Sender: TObject);
begin
baramun0.Position:=(sender as TSpinEdit).Value;
end;

procedure TForm1.baramun0Change(Sender: TObject);
begin
ustamun0.value:=(sender as TTrackBar).Position;
end;

procedure TForm1.ustamun1Change(Sender: TObject);
begin
baramun1.Position:=(sender as TSpinEdit).Value;
end;

procedure TForm1.baramun1Change(Sender: TObject);
begin
ustamun1.value:=(sender as TTrackBar).Position;
end;

procedure TForm1.ustamun2Change(Sender: TObject);
begin
baramun2.Position:=(sender as TSpinEdit).Value;
end;

procedure TForm1.baramun2Change(Sender: TObject);
begin
ustamun2.value:=(sender as TTrackBar).Position;
end;

procedure TForm1.ustamun3Change(Sender: TObject);
begin
baramun3.Position:=(sender as TSpinEdit).Value;
end;

procedure TForm1.baramun3Change(Sender: TObject);
begin
ustamun3.value:=(sender as TTrackBar).Position;
end;

procedure TForm1.dodajdymek(Sender: TObject);
var a:integer;
begin
dymki_comboboxy[(sender as TSpeedbutton).Tag].Text:=trim(dymki_comboboxy[(sender as TSpeedbutton).Tag].Text);
if dymki_comboboxy[(sender as TSpeedbutton).Tag].Text='' then exit;
a:=0;
while (a<=dymki_comboboxy[(sender as TSpeedbutton).Tag].Items.Count-1) and
      (dymki_comboboxy[(sender as TSpeedbutton).Tag].Items[a]<>dymki_comboboxy[(sender as TSpeedbutton).Tag].Text) do
    inc(a);
if a>dymki_comboboxy[(sender as TSpeedbutton).Tag].Items.Count-1 then begin
   dymki_comboboxy[(sender as TSpeedbutton).Tag].Items.Add(dymki_comboboxy[(sender as TSpeedbutton).Tag].Text);
end;
end;

procedure TForm1.usundymek(Sender: TObject);
var a:integer;
begin
dymki_comboboxy[(sender as TSpeedbutton).Tag].Text:=trim(dymki_comboboxy[(sender as TSpeedbutton).Tag].Text);
if dymki_comboboxy[(sender as TSpeedbutton).Tag].Text='' then exit;
if dymki_comboboxy[(sender as TSpeedbutton).Tag].Items.Count=0 then exit;

a:=0;
while (a<=dymki_comboboxy[(sender as TSpeedbutton).Tag].Items.Count-1) and
      (dymki_comboboxy[(sender as TSpeedbutton).Tag].Items[a]<>dymki_comboboxy[(sender as TSpeedbutton).Tag].Text) do
    inc(a);

if a<=dymki_comboboxy[(sender as TSpeedbutton).Tag].Items.Count-1 then begin
   dymki_comboboxy[(sender as TSpeedbutton).Tag].Items.Delete(a);
end;
end;

end.
