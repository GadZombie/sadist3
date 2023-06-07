unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, DXDraws, Buttons, Grids, DIB, ImgList,
  unitstringi, vars, Spin, unitmisjeio;

type
  TForm1 = class(TForm)
    st: TPageControl;
    Ogolne: TTabSheet;
    Warunki: TTabSheet;
    Podglad: TTabSheet;
    Panel1: TPanel;
    ListaTerenow: TListBox;
    Panel2: TPanel;
    Panel3: TPanel;
    dodajflage1: TSpeedButton;
    dodajflage2: TSpeedButton;
    namunicja: TStringGrid;
    hpomoc: TStaticText;
    skrolwarunki: TScrollBox;
    Splitter1: TSplitter;
    Panel4: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    nsterowanie: TCheckBox;
    nileczasu: TDateTimePicker;
    Panel5: TPanel;
    listamisji: TListBox;
    Panel6: TPanel;
    Druzyny: TTabSheet;
    ndruzyny: TStringGrid;
    Label4: TLabel;
    skrolpodglad: TScrollBox;
    podgter: TPaintBox;
    Panel7: TPanel;
    zoomin: TSpeedButton;
    zoomout: TSpeedButton;
    info: TStaticText;
    zoom100: TSpeedButton;
    zoomcale: TSpeedButton;
    dodajflage3: TSpeedButton;
    zoombar: TTrackBar;
    dodajprostokat1: TSpeedButton;
    dodajprostokat2: TSpeedButton;
    oprogramie: TTabSheet;
    tekstoprogramie: TStaticText;
    dodajflage4: TSpeedButton;
    nkolesie: TStringGrid;
    njestczas: TCheckBox;
    nsterowanapostac: TSpinEdit;
    GroupBox3: TGroupBox;
    nwyp_czas: TCheckBox;
    nprzeg_czas: TCheckBox;
    nwyp_zginie: TCheckBox;
    nwyp_zginiegrup: TSpinEdit;
    nwyp_zginieile: TSpinEdit;
    Label5: TLabel;
    nprzeg_zginie: TCheckBox;
    nprzeg_zginieile: TSpinEdit;
    Label6: TLabel;
    nprzeg_zginiegrup: TSpinEdit;
    nwyp_dojdzie: TCheckBox;
    nwyp_dojdzieile: TSpinEdit;
    Label7: TLabel;
    nwyp_dojdziegrup: TSpinEdit;
    nprzeg_dojdziegrup: TSpinEdit;
    Label8: TLabel;
    nprzeg_dojdzieile: TSpinEdit;
    nprzeg_dojdzie: TCheckBox;
    nwlaczonykursor: TCheckBox;
    nwyp_zebrane: TCheckBox;
    nwyp_zebraneile: TSpinEdit;
    nprzeg_zebrane: TCheckBox;
    nprzeg_zebraneile: TSpinEdit;
    nwyp_zniszczone: TCheckBox;
    nwyp_zniszczoneile: TSpinEdit;
    nprzeg_zniszczoneile: TSpinEdit;
    nprzeg_zniszczone: TCheckBox;
    skrologolne: TScrollBox;
    Label1: TLabel;
    nnazwa: TEdit;
    Label2: TLabel;
    nautor: TEdit;
    Label3: TLabel;
    ndatastworzenia: TDateTimePicker;
    Label9: TLabel;
    nopis: TMemo;
    Label10: TLabel;
    nnagroda: TEdit;
    Splitter2: TSplitter;
    Panel8: TPanel;
    Zapisz: TSpeedButton;
    Wczytaj: TSpeedButton;
    dodajpostac: TSpeedButton;
    dodajpostaczgrupy: TSpinEdit;
    Kolesie: TTabSheet;
    StaticText1: TStaticText;
    Splitter3: TSplitter;
    StaticText2: TStaticText;
    nzmianawarunkow: TCheckBox;
    nrysowanie: TCheckBox;
    nzmianawejsc: TCheckBox;
    nzmianadruzyn: TCheckBox;
    Panel9: TPanel;
    ustawwszystkie_ile: TSpinEdit;
    ustawwszystkie: TSpeedButton;
    nmuzyka: TComboBox;
    Label11: TLabel;
    nprzenoszenie: TCheckBox;
    nczestpaczek: TSpinEdit;
    Label12: TLabel;
    Paneldruz: TPanel;
    ikonki: TImageList;
    nbrondomyslna: TSpinEdit;
    Label13: TLabel;
    ColorDialog1: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure namunicjaExit(Sender: TObject);
    procedure ndruzynyExit(Sender: TObject);
    procedure odswiez_kolesi;

    procedure zroblistyplikow;
    procedure ListaTerenowClick(Sender: TObject);
    procedure podgterPaint(Sender: TObject);
    procedure zoominClick(Sender: TObject);
    procedure zoomoutClick(Sender: TObject);
    procedure stChange(Sender: TObject);
    procedure podgterMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dodajflage1Click(Sender: TObject);
    procedure podgterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zoom100Click(Sender: TObject);
    procedure zoomcaleClick(Sender: TObject);
    procedure zoombarChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure nkolesieExit(Sender: TObject);
    procedure njestczasClick(Sender: TObject);
    procedure nsterowanieClick(Sender: TObject);
    procedure podgterMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ZapiszClick(Sender: TObject);
    procedure listamisjiClick(Sender: TObject);
    procedure WczytajClick(Sender: TObject);
    procedure nwyp_czasClick(Sender: TObject);
    procedure nwyp_zginieClick(Sender: TObject);
    procedure nwyp_dojdzieClick(Sender: TObject);
    procedure nwyp_zebraneClick(Sender: TObject);
    procedure nwyp_zniszczoneClick(Sender: TObject);
    procedure nprzeg_zginieClick(Sender: TObject);
    procedure nprzeg_dojdzieClick(Sender: TObject);
    procedure nprzeg_zebraneClick(Sender: TObject);
    procedure nprzeg_zniszczoneClick(Sender: TObject);
    procedure ustawwszystkieClick(Sender: TObject);
    procedure nbrondomyslnaExit(Sender: TObject);
    procedure KolorClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form1: TForm1;
  obrterenu:Tbitmap;

  teren:record
      width,height:integer;
      tlowidth,tloheight:integer;
      tlododx,tlodody:real;

      maska:array of array of byte;
            {  0: puste, nic, powietrze oraz obrazki w tle
               1: skala - da sie normalnie rozwalac
               2-9: ciezkie do rozwalenia, kazde uszkodzenie obcina o jeden w dol, az dojdzie do 1
               10: metal - nie da sie rozwalic
            }
      end;


  ustawienia:record
     zoom:double;
     wybranyteren,
     wybranamisja:string;
  end;
  flagi:array of record x,y:integer; rodz:byte end;
  prostokaty:array of record x1,y1,x2,y2:integer; rodz:byte end;


  tryb_dzialania:integer;
  {  0-nic
     1-stawianie flagi1
     2-stawianie flagi2
     3-stawianie flagi3
     4-stawianie prostokata1
     5-stawianie-dokanczanie prostokata1
     6-stawianie prostokata1
     7-stawianie-dokanczanie prostokata1
     8-stawianie wejsc
     9-stawianie kolesi
    10-przesuwanie
  }

  koldruz:array[0..max_druzyn] of TShape;

  kursorx,kursory:integer;

  przesuwanie:record
    nr:integer;
    rodzaj:byte; {0-flaga, 1-prostokat, 2-koles}
    end;
  ruch_ekranu:boolean;

  ile_kolesi,
  ile_wejsc:integer;

implementation

{$R *.DFM}

procedure odswiezinfo;
begin
form1.info.caption:='Iloœæ flag: '+inttostr(length(flagi))+#13#10+
                    'Iloœæ regionów: '+inttostr(length(prostokaty))+#13#10+
                    'Iloœæ kolesi: '+inttostr(ile_kolesi)+#13#10+
                    'Iloœæ wejœæ: '+inttostr(ile_wejsc);
end;

procedure dodajflage(x,y:integer; r:byte);
begin
setlength(flagi,length(flagi)+1);
flagi[high(flagi)].x:=x;
flagi[high(flagi)].y:=y;
flagi[high(flagi)].rodz:=r;
end;

procedure usunflage(a:integer);
var n:integer;
begin
if a<high(flagi) then begin
   for n:=a to high(flagi)-1 do
       flagi[n]:=flagi[n+1];
end;
setlength(flagi,length(flagi)-1);
end;

procedure dodajprostokat(x,y:integer; r:byte);
begin
setlength(prostokaty,length(prostokaty)+1);
prostokaty[high(prostokaty)].x1:=x;
prostokaty[high(prostokaty)].y1:=y;
prostokaty[high(prostokaty)].x2:=x;
prostokaty[high(prostokaty)].y2:=y;
prostokaty[high(prostokaty)].rodz:=r;
end;

procedure usunprostokat(a:integer);
var n:integer;
begin
if a<high(prostokaty) then begin
   for n:=a to high(prostokaty)-1 do
       prostokaty[n]:=prostokaty[n+1];
end;

setlength(prostokaty,length(prostokaty)-1);
end;

procedure dodajkolesia(x,y:integer; t:byte);
begin
koles[ile_kolesi].x:=x;
koles[ile_kolesi].y:=y;
koles[ile_kolesi].team:=t;
koles[ile_kolesi].jest:=true;
koles[ile_kolesi].sila:=100; {sila z druzyny!}
koles[ile_kolesi].kierunek:=1;
koles[ile_kolesi].corobi:=0;
koles[ile_kolesi].bron:=0;
koles[ile_kolesi].amunicja:=0;
koles[ile_kolesi].palisie:=false;
inc(ile_kolesi);
end;

procedure usunkolesia(a:integer);
var n:integer;
begin
if a<ile_kolesi then begin
   for n:=a to ile_kolesi-2 do
       koles[n]:=koles[n+1];
end;
dec(ile_kolesi);
end;

procedure TForm1.FormCreate(Sender: TObject);
var a,b:integer;
begin
ChDir(ExtractFilePath(Application.ExeName));

with ustawienia do begin
     zoom:=1;
end;
Skrolpodglad.DoubleBuffered:=true;

druzyna[0].kolor_druzyny:=$0000FF;
druzyna[1].kolor_druzyny:=$FF0000;
druzyna[2].kolor_druzyny:=$00FF00;
druzyna[3].kolor_druzyny:=$00FFFF;
druzyna[4].kolor_druzyny:=$FF00FF;
druzyna[5].kolor_druzyny:=$509010;
druzyna[6].kolor_druzyny:=$404040;
druzyna[7].kolor_druzyny:=$FF9040;
druzyna[8].kolor_druzyny:=$004010;
druzyna[9].kolor_druzyny:=$709090;

ndatastworzenia.DateTime:=now;

{poczatkowy uklad grida broni}
namunicja.Cells[0,0]:='Broñ';
namunicja.Cells[1,0]:='Iloœæ amunicji';
namunicja.RowCount:=max_broni+2;
for a:=0 to max_broni do begin
    if nazwy_broni[a]='' then namunicja.Cells[0,1+a]:='<<brak-niewazne>>'
       else namunicja.Cells[0,1+a]:=l2t(a,2)+'. '+nazwy_broni[a];
    namunicja.Cells[1,1+a]:='-1';
end;
namunicjaExit(namunicja);
nbrondomyslna.Value:=0;
nbrondomyslna.MaxValue:=max_broni;

{poczatkowy uklad grida druzyn}
ndruzyny.Cells[0,0]:='Dru¿yna: ';
ndruzyny.Cells[1,0]:='Wybrana dru¿yna';
ndruzyny.Cells[2,0]:='Iloœæ kolesi w ca³ej dru¿ynie';
ndruzyny.Cells[3,0]:='Max kolesi na raz na ekranie';
ndruzyny.Cells[4,0]:='Zabijaæ(0) czy broniæ(1)';
ndruzyny.Cells[5,0]:='Ilu trzeba zabiæ/uratowaæ by skoñczyæ misje';
ndruzyny.Cells[6,0]:='Si³a pocz¹tkowa';
ndruzyny.Cells[7,0]:='Broñ:granaty(1),bomby(2),karabin(3)';
ndruzyny.Cells[8,0]:='Amunicja';

ndruzyny.Cells[9,0]:='Kolor';
ndruzyny.ColWidths[9]:=60;

ndruzyny.ColWidths[2]:=150;
for a:=2 to 8 do ndruzyny.ColWidths[a]:=50;
ndruzyny.rowheights[0]:=20;
ndruzyny.RowCount:=max_druzyn+2;
for a:=0 to max_druzyn do begin
    ndruzyny.Cells[0,1+a]:='Dru¿yna '+inttostr(a+1);
    ndruzyny.Cells[1,1+a]:='Ludzie';
    ndruzyny.Cells[9,1+a]:=inttohex(druzyna[a].kolor_druzyny,6);
end;
ndruzynyExit(ndruzyny);
//Application.ProcessMessages;
b:=0;
for a:=0 to max_druzyn do begin
    koldruz[a]:=tshape.Create(form1);
    with koldruz[a] do begin
         parent:=paneldruz;
         left:=3;
         b:=b+ndruzyny.RowHeights[a]+1;
         top:=b+2;
         width:=paneldruz.Width-6;
         height:=ndruzyny.RowHeights[a+1];
         brush.Color:=tcolor(druzyna[a].kolor_druzyny and $FFFFFF);
         Cursor:=crHelp;
         tag:=a;
         koldruz[a].OnMouseUp:=KolorClick;
    end;
end;

{poczatkowy uklad grida kolesi}
nkolesie.ColCount:=11;
nkolesie.rowheights[0]:=20;
for a:=1 to 10 do nkolesie.ColWidths[a]:=60;

ile_kolesi:=0;
setlength(koles,max_kol+1);

odswiez_kolesi;

obrterenu:=tbitmap.Create;

dodajpostaczgrupy.maxvalue:=max_druzyn+1;
randomize;
ruch_ekranu:=false;

zroblistyplikow;
end;

procedure TForm1.namunicjaExit(Sender: TObject);
var wart,a,i:integer;
begin
for a:=1 to max_broni+1 do begin
    val(namunicja.cells[1,a],wart,i);
    if (i<>0) or
       (wart<-1) or (wart>9999) then namunicja.cells[1,a]:='-1';
end;

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

function wartosc(s:string):integer;
var i:integer;
begin
  val(s,result,i);
end;


procedure TForm1.ndruzynyExit(Sender: TObject);
var a:integer;
begin
for a:=0 to max_druzyn do begin
    ndruzyny.cells[2,1+a]:=sprawdzpoprawnosc(ndruzyny.cells[2,1+a],0,99999);
    ndruzyny.cells[3,1+a]:=sprawdzpoprawnosc(ndruzyny.cells[3,1+a],0,max_kol);
    ndruzyny.cells[4,1+a]:=sprawdzpoprawnosc(ndruzyny.cells[4,1+a],0,1);
    ndruzyny.cells[5,1+a]:=sprawdzpoprawnosc(ndruzyny.cells[5,1+a],0,wartosc(ndruzyny.cells[3,1+a]));
    ndruzyny.cells[6,1+a]:=sprawdzpoprawnosc(ndruzyny.cells[6,1+a],10,999);
    ndruzyny.cells[7,1+a]:=sprawdzpoprawnosc(ndruzyny.cells[7,1+a],1,3);
    ndruzyny.cells[8,1+a]:=sprawdzpoprawnosc(ndruzyny.cells[8,1+a],0,30);
//    ndruzyny.cells[9,1+a]:=ndruzyny.cells[9,1+a];
end;
end;

procedure tform1.odswiez_kolesi;
var a,b:integer;
begin
nkolesie.Cells[0,0]:='Koleœ nr';
nkolesie.Cells[1,0]:='Jest?';
nkolesie.Cells[2,0]:='Dru¿yna';
nkolesie.Cells[3,0]:='X';
nkolesie.Cells[4,0]:='Y';
nkolesie.Cells[5,0]:='Si³a';
nkolesie.Cells[6,0]:='Kierunek';
nkolesie.Cells[7,0]:='Corobi';
nkolesie.Cells[8,0]:='Broñ';
nkolesie.Cells[9,0]:='Amunicja';
nkolesie.Cells[10,0]:='Pali siê';

if ile_kolesi=0 then nkolesie.RowCount:=2
                else nkolesie.RowCount:=ile_kolesi+1;
for a:=0 to ile_kolesi-1 do begin
    nkolesie.Cells[0,1+a]:='Koleœ '+inttostr(a+1);
    nkolesie.Cells[1,1+a]:=inttostr(ord(koles[a].jest));
    nkolesie.Cells[2,1+a]:=inttostr(koles[a].team);
    nkolesie.Cells[3,1+a]:=inttostr(trunc(koles[a].x));
    nkolesie.Cells[4,1+a]:=inttostr(trunc(koles[a].y));
    nkolesie.Cells[5,1+a]:=inttostr(koles[a].sila);
    nkolesie.Cells[6,1+a]:=inttostr(koles[a].kierunek);
    nkolesie.Cells[7,1+a]:=inttostr(koles[a].corobi);
    nkolesie.Cells[8,1+a]:=inttostr(koles[a].bron);
    nkolesie.Cells[9,1+a]:=inttostr(koles[a].amunicja);
    nkolesie.Cells[10,1+a]:=inttostr(ord(koles[a].palisie));
end;

nkolesieExit(nkolesie);
end;

procedure TForm1.nkolesieExit(Sender: TObject);
var a,b:integer;
begin
for a:=0 to ile_kolesi-1 do begin
    nkolesie.cells[1,1+a]:=sprawdzpoprawnosc(nkolesie.cells[1,1+a],1,1);
    nkolesie.cells[2,1+a]:=sprawdzpoprawnosc(nkolesie.cells[2,1+a],0,max_druzyn);
    nkolesie.cells[3,1+a]:=sprawdzpoprawnosc(nkolesie.cells[3,1+a],0,teren.width);
    nkolesie.cells[4,1+a]:=sprawdzpoprawnosc(nkolesie.cells[4,1+a],0,teren.height);
    nkolesie.cells[5,1+a]:=sprawdzpoprawnosc(nkolesie.cells[5,1+a],1,999);
    nkolesie.cells[6,1+a]:=sprawdzpoprawnosc(nkolesie.cells[6,1+a],-1,1);
    if wartosc(nkolesie.cells[6,1+a])=0 then nkolesie.cells[6,1+a]:='1';
    nkolesie.cells[7,1+a]:=sprawdzpoprawnosc(nkolesie.cells[7,1+a],0,16);
    nkolesie.cells[8,1+a]:=sprawdzpoprawnosc(nkolesie.cells[8,1+a],0,2);
    nkolesie.cells[9,1+a]:=sprawdzpoprawnosc(nkolesie.cells[9,1+a],0,99);
    nkolesie.cells[10,1+a]:=sprawdzpoprawnosc(nkolesie.cells[10,1+a],0,1);

    koles[a].team:=wartosc(nkolesie.cells[2,1+a]);
    koles[a].x:=wartosc(nkolesie.cells[3,1+a]);
    koles[a].y:=wartosc(nkolesie.cells[4,1+a]);
    koles[a].sila:=wartosc(nkolesie.cells[5,1+a]);
    koles[a].kierunek:=wartosc(nkolesie.cells[6,1+a]);
    koles[a].corobi:=wartosc(nkolesie.cells[7,1+a]);
    koles[a].bron:=wartosc(nkolesie.cells[8,1+a]);
    koles[a].amunicja:=wartosc(nkolesie.cells[9,1+a]);
    koles[a].palisie:=boolean(wartosc(nkolesie.cells[10,1+a]));
end;
end;

procedure TForm1.podgterPaint(Sender: TObject);
var tr:trect; a,rx,ry:integer; bmp:TBitmap;
begin
if obrterenu<>nil then begin
   form1.podgter.canvas.Font.Height:=13;
   form1.podgter.canvas.Font.Name:='Tahoma';
   form1.podgter.canvas.Font.style:=[];
   form1.podgter.canvas.brush.style:=bsSolid;
   tr.TopLeft:=point(0,0);
   tr.bottomright:=point(form1.podgter.width,form1.podgter.height);
   form1.Podgter.Canvas.StretchDraw(tr,ObrTerenu);

   rx:=trunc(ikonki.width*ustawienia.zoom);
   ry:=trunc(ikonki.height*ustawienia.zoom);

   for a:=0 to high(flagi) do begin
       bmp:=tbitmap.Create;
       form1.ikonki.GetBitmap(flagi[a].rodz,bmp);
       bmp.TransparentColor:=clfuchsia;
       bmp.Transparent:=true;
       tr.TopLeft:=point(trunc(flagi[a].x*ustawienia.zoom)-rx div 2,trunc(flagi[a].y*ustawienia.zoom)-ry div 2);
       tr.bottomright:=point(tr.Left+rx, tr.top+ry );
       form1.podgter.canvas.stretchdraw(tr,bmp);
       bmp.Free;
   end;

   form1.podgter.canvas.brush.style:=bsClear;
   for a:=0 to ile_wejsc-1 do begin
       bmp:=tbitmap.Create;
       form1.ikonki.GetBitmap(4,bmp);
       bmp.TransparentColor:=clfuchsia;
       bmp.Transparent:=true;
       tr.TopLeft:=point(trunc(wejscia[a].x*ustawienia.zoom)-rx div 2,trunc(wejscia[a].y*ustawienia.zoom)-5);
       tr.bottomright:=point(tr.Left+rx, tr.top+ry );
       form1.podgter.canvas.stretchdraw(tr,bmp);
       form1.podgter.canvas.Font.color:=$ff8020;
       form1.podgter.canvas.TextOut(tr.left,tr.top,inttostr(a));
       bmp.Free;
   end;

   for a:=0 to ile_kolesi-1 do begin
       bmp:=tbitmap.Create;
       form1.ikonki.GetBitmap(5,bmp);
       bmp.TransparentColor:=clfuchsia;
       bmp.Transparent:=true;
       tr.TopLeft:=point(trunc(koles[a].x*ustawienia.zoom)-rx div 2,trunc(koles[a].y*ustawienia.zoom)-ry div 2);
       tr.bottomright:=point(tr.Left+rx, tr.top+ry );
       form1.podgter.canvas.Pen.Color:=druzyna[koles[a].team].kolor_druzyny;
       form1.podgter.canvas.brush.Color:=druzyna[koles[a].team].kolor_druzyny;
       form1.podgter.canvas.brush.Style:=bsDiagCross;
       form1.podgter.canvas.Ellipse(tr);
       form1.podgter.canvas.stretchdraw(tr,bmp);
       form1.podgter.canvas.Font.color:=$ff8020;
       form1.podgter.canvas.TextOut(tr.left,tr.top,inttostr(1+a));
       form1.podgter.canvas.TextOut(tr.left+rx-form1.podgter.canvas.TextWidth(inttostr(koles[a].team+1)),tr.top,inttostr(koles[a].team+1));
       bmp.Free;
   end;

   if tryb_dzialania in [6,8] then begin
      prostokaty[high(prostokaty)].x2:=kursorx;
      prostokaty[high(prostokaty)].y2:=kursory;
   end;

   for a:=0 to high(prostokaty) do begin
       tr.TopLeft:=point(trunc(prostokaty[a].x1*ustawienia.zoom),trunc(prostokaty[a].y1*ustawienia.zoom));
       tr.bottomright:=point(trunc(prostokaty[a].x2*ustawienia.zoom),trunc(prostokaty[a].y2*ustawienia.zoom));
       case prostokaty[a].rodz of
          0:form1.podgter.canvas.pen.color:=$30ff30;
          1:form1.podgter.canvas.pen.color:=$3040ff;
       end;
       form1.podgter.canvas.Rectangle(tr);
       form1.podgter.canvas.Font.color:=form1.podgter.canvas.pen.color;
       form1.podgter.canvas.TextOut(tr.left,tr.top,inttostr(a));
   end;

   if tryb_dzialania in [1..4] then begin
      bmp:=tbitmap.Create;
      form1.ikonki.GetBitmap(tryb_dzialania-1,bmp);
      bmp.TransparentColor:=clfuchsia;
      bmp.Transparent:=true;
      tr.TopLeft:=point(trunc(kursorx*ustawienia.zoom)-rx div 2,trunc(kursory*ustawienia.zoom)-ry div 2);
      tr.bottomright:=point(tr.Left+rx, tr.top+ry );
      form1.podgter.canvas.stretchdraw(tr,bmp);
      bmp.Free;
   end;

{   if tryb_dzialania in [8] then begin
      bmp:=tbitmap.Create;
      form1.ikonki.GetBitmap(3,bmp);
      bmp.TransparentColor:=clfuchsia;
      bmp.Transparent:=true;
      tr.TopLeft:=point(trunc(kursorx*ustawienia.zoom)-rx div 2,trunc(kursory*ustawienia.zoom)-5);
      tr.bottomright:=point(tr.Left+rx, tr.top+ry );
      form1.podgter.canvas.stretchdraw(tr,bmp);
      bmp.Free;
   end;
}
   if tryb_dzialania in [9] then begin
      bmp:=tbitmap.Create;
      form1.ikonki.GetBitmap(5,bmp);
      bmp.TransparentColor:=clfuchsia;
      bmp.Transparent:=true;
      tr.TopLeft:=point(trunc(kursorx*ustawienia.zoom)-rx div 2,trunc(kursory*ustawienia.zoom)-ry div 2);
      tr.bottomright:=point(tr.Left+rx, tr.top+ry );
      form1.podgter.canvas.stretchdraw(tr,bmp);
      bmp.Free;
   end;

end;
odswiezinfo;
end;

procedure wczytaj_teren(nazwa:string; z_kolesiami:boolean);
var wl:boolean;
begin
//form1.ObrTerenu.Picture.LoadFromFile('Terrains\'+nazwa+'.bmp');
wczytaj_teren_z_pliku_full(nazwa, z_kolesiami);
teren.width:=ObrTerenu.Width;
teren.height:=ObrTerenu.Height;
ile_wejsc:=0;

wl:=obrterenu<>nil;
if wl then begin
   form1.podgter.width:=trunc(ObrTerenu.width*ustawienia.zoom);
   form1.podgter.height:=trunc(ObrTerenu.height*ustawienia.zoom);
end;
form1.podgter.Repaint;

form1.zoomin.enabled:=wl;
form1.zoomout.enabled:=wl;
form1.zoom100.enabled:=wl;
form1.zoomcale.enabled:=wl;
form1.podgter.enabled:=wl;
form1.dodajflage1.enabled:=wl;
form1.dodajflage2.enabled:=wl;
form1.dodajflage3.enabled:=wl;
form1.dodajflage4.enabled:=wl;
form1.dodajprostokat1.enabled:=wl;
form1.dodajprostokat2.enabled:=wl;
form1.dodajpostac.enabled:=wl;
form1.dodajpostaczgrupy.enabled:=wl;
odswiezinfo;
end;

procedure tform1.zroblistyplikow;
var
  sr: TSearchRec;
  FileAttrs: Integer;
  w:string;
  a:integer;
begin
  listaterenow.Clear;
  FileAttrs := faAnyFile;
  if FindFirst('Terrains\*.s3ter', FileAttrs, sr)=0 then begin
     repeat
        sr.Name:=copy(sr.Name,1,length(sr.name)-6);
        listaterenow.Items.Add(sr.name);
     until FindNext(sr) <>0;
     FindClose(sr);
  end;

  listamisji.Clear;
  FileAttrs := faAnyFile;
  if FindFirst('Missions\*.S3Mis', FileAttrs, sr)=0 then begin
     repeat
        sr.Name:=copy(sr.Name,1,length(sr.name)-6);
        listamisji.Items.Add(sr.name);
     until FindNext(sr) <>0;
     FindClose(sr);
  end;

  a:=nmuzyka.ItemIndex;
  nmuzyka.Clear;
  nmuzyka.Items.Add('[ LOSOWA ]');
  FileAttrs := faAnyFile;
  if FindFirst('Music\*.*', FileAttrs, sr)=0 then begin
     repeat
        w:=uppercase(ExtractFileExt(sr.name));
        if (w='.MOD') or (w='.S3M') or (w='.XM') or (w='.IT') or
           (w='.MP3') or (w='.OGG') then begin
           nmuzyka.Items.Add(sr.name);
        end;
     until FindNext(sr) <>0;
     FindClose(sr);
  end;
  if a=-1 then nmuzyka.ItemIndex:=0 else nmuzyka.ItemIndex:=a; 

end;

procedure TForm1.ListaTerenowClick(Sender: TObject);
begin
if (sender as tlistbox).ItemIndex>=0 then begin
   ustawienia.wybranyteren:=(sender as tlistbox).items[(sender as tlistbox).ItemIndex];
   wczytaj_teren(ustawienia.wybranyteren, true);
   Zapisz.Enabled:=true;
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

procedure TForm1.stChange(Sender: TObject);
begin
tryb_dzialania:=0;
odswiez_kolesi;
end;

procedure TForm1.podgterMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
tr:trect; bmp:TBitmap; rx,ry:integer;
begin

if ruch_ekranu then begin
{   skrolpodglad.ScrollBy( trunc(x/ustawienia.zoom)-kursorx,
                          trunc(y/ustawienia.zoom)-kursory );}
   skrolpodglad.HorzScrollBar.Position:=skrolpodglad.HorzScrollBar.Position-trunc(x/ustawienia.zoom)+kursorx;
   skrolpodglad.vertScrollBar.Position:=skrolpodglad.vertScrollBar.Position-trunc(y/ustawienia.zoom)+kursory;
   if skrolpodglad.HorzScrollBar.Position<0 then skrolpodglad.HorzScrollBar.Position:=0;
   if skrolpodglad.HorzScrollBar.Position>skrolpodglad.HorzScrollBar.Range then skrolpodglad.HorzScrollBar.Position:=skrolpodglad.HorzScrollBar.Range;
   if skrolpodglad.VertScrollBar.Position<0 then skrolpodglad.vertScrollBar.Position:=0;
   if skrolpodglad.vertScrollBar.Position>skrolpodglad.vertScrollBar.Range then skrolpodglad.vertScrollBar.Position:=skrolpodglad.vertScrollBar.Range;
end;

kursorx:=trunc(x/ustawienia.zoom);
kursory:=trunc(y/ustawienia.zoom);

if tryb_dzialania=10 then begin
   case przesuwanie.rodzaj of
      0:begin
        flagi[przesuwanie.nr].x:=kursorx;
        flagi[przesuwanie.nr].y:=kursory;
        end;
      1:begin
        rx:=prostokaty[przesuwanie.nr].x2-prostokaty[przesuwanie.nr].x1;
        ry:=prostokaty[przesuwanie.nr].y2-prostokaty[przesuwanie.nr].y1;
        prostokaty[przesuwanie.nr].x1:=kursorx;
        prostokaty[przesuwanie.nr].y1:=kursory;
        prostokaty[przesuwanie.nr].x2:=kursorx+rx;
        prostokaty[przesuwanie.nr].y2:=kursory+ry;
        end;
      2:begin
        koles[przesuwanie.nr].x:=kursorx;
        koles[przesuwanie.nr].y:=kursory;
        end;
   end;
end;

if (tryb_dzialania>0) or (ruch_ekranu){ in [1..5] }then begin
   podgter.Repaint;
end;
end;

procedure TForm1.dodajflage1Click(Sender: TObject);
begin
if (sender as tspeedbutton).down then tryb_dzialania:=(sender as tspeedbutton).tag
   else tryb_dzialania:=0;
podgter.Repaint;
end;

procedure TForm1.podgterMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var a:integer;
begin
ruch_ekranu:=Button=mbmiddle;
if ruch_ekranu then (sender as tpaintbox).cursor:=crSizeAll else (sender as tpaintbox).cursor:=crCross;
if tryb_dzialania in [1..4] then begin
    if button=mbleft then dodajflage(kursorx,kursory,tryb_dzialania-1)
       else
       if button=mbright then begin
          tryb_dzialania:=0;
          dodajflage1.Down:=false;
          dodajflage2.Down:=false;
          dodajflage3.Down:=false;
          dodajflage4.Down:=false;
          dodajprostokat1.Down:=false;
          dodajprostokat2.Down:=false;
          dodajpostac.down:=false;
       end;
end else
if tryb_dzialania in [5,7] then begin
    if button=mbleft then begin
       dodajprostokat(kursorx,kursory,tryb_dzialania div 2-2);
       tryb_dzialania:=tryb_dzialania+1;
    end else
       if button=mbright then begin
          tryb_dzialania:=0;
          dodajflage1.Down:=false;
          dodajflage2.Down:=false;
          dodajflage3.Down:=false;
          dodajflage4.Down:=false;
          dodajprostokat1.Down:=false;
          dodajprostokat2.Down:=false;
          dodajpostac.down:=false;
       end;
end else
if tryb_dzialania in [6,8] then begin
    if button=mbleft then begin
       if prostokaty[high(prostokaty)].x2<prostokaty[high(prostokaty)].x1 then begin
          a:=prostokaty[high(prostokaty)].x2;
          prostokaty[high(prostokaty)].x2:=prostokaty[high(prostokaty)].x1;
          prostokaty[high(prostokaty)].x1:=a;
       end;
       if prostokaty[high(prostokaty)].y2<prostokaty[high(prostokaty)].y1 then begin
          a:=prostokaty[high(prostokaty)].y2;
          prostokaty[high(prostokaty)].y2:=prostokaty[high(prostokaty)].y1;
          prostokaty[high(prostokaty)].y1:=a;
       end;

       tryb_dzialania:=tryb_dzialania-1;
    end else
       if button=mbright then begin
          tryb_dzialania:=0;
          dodajflage1.Down:=false;
          dodajflage2.Down:=false;
          dodajflage3.Down:=false;
          dodajflage4.Down:=false;
          dodajprostokat1.Down:=false;
          dodajprostokat2.Down:=false;
          dodajpostac.down:=false;
          usunprostokat(high(prostokaty));
       end;
{end else
if tryb_dzialania in [8] then begin
    if button=mbleft then dodajwejscie(kursorx,kursory)
       else
       if button=mbright then begin
          tryb_dzialania:=0;
          dodajflage1.Down:=false;
          dodajflage2.Down:=false;
          dodajflage3.Down:=false;
          dodajprostokat1.Down:=false;
          dodajprostokat2.Down:=false;
          dodajpostac.down:=false;
          dodajwejscie1.Down:=false;
       end;}
end else
if tryb_dzialania in [9] then begin
    if button=mbleft then dodajkolesia(kursorx,kursory,dodajpostaczgrupy.Value-1)
       else
       if button=mbright then begin
          tryb_dzialania:=0;
          dodajflage1.Down:=false;
          dodajflage2.Down:=false;
          dodajflage3.Down:=false;
          dodajflage4.Down:=false;
          dodajprostokat1.Down:=false;
          dodajprostokat2.Down:=false;
          dodajpostac.down:=false;
       end;
end else
if tryb_dzialania=0 then begin
    a:=high(flagi);
    while a>=0 do begin
       if (kursorx>=flagi[a].x-15) and (kursorx<=flagi[a].x+15) and
          (kursory>=flagi[a].y-30) and (kursory<=flagi[a].y) then begin
          if button=mbright then begin
             usunflage(a);
             a:=-1;
          end else
          if button=mbleft then begin
             tryb_dzialania:=10;
             przesuwanie.nr:=a;
             przesuwanie.rodzaj:=0;
             a:=-1;
          end;
       end;
       dec(a);
    end;
    if a=-1 then begin {nie kliknieto we flage}
       a:=ile_kolesi-1;
       while a>=0 do begin
          if (kursorx>=koles[a].x-15) and (kursorx<=koles[a].x+15) and
             (kursory>=koles[a].y-15) and (kursory<=koles[a].y+15) then begin
              if button=mbright then begin
                 usunkolesia(a);
                 a:=-1;
              end else
              if button=mbleft then begin
                 tryb_dzialania:=10;
                 przesuwanie.nr:=a;
                 przesuwanie.rodzaj:=2;
              end;
          end;
          dec(a);
       end;
    end;
    if a=-1 then begin {nie kliknieto we flage ani w kolesia}
       a:=high(prostokaty);
       while a>=0 do begin
          if (kursorx>=prostokaty[a].x1) and (kursorx<=prostokaty[a].x2) and
             (kursory>=prostokaty[a].y1) and (kursory<=prostokaty[a].y2) then begin
              if button=mbright then begin
                 usunprostokat(a);
                 a:=-1;
              end else
              if button=mbleft then begin
                 tryb_dzialania:=10;
                 przesuwanie.nr:=a;
                 przesuwanie.rodzaj:=1;
              end;
          end;
          dec(a);
       end;
    end;
end;

form1.podgter.Repaint;
end;

procedure TForm1.zoom100Click(Sender: TObject);
begin
ustawienia.zoom:=1;
zoombar.Position:=round(ustawienia.zoom*100);
{form1.podgter.width:=trunc(form1.ObrTerenu.Picture.width*ustawienia.zoom);
form1.podgter.height:=trunc(form1.ObrTerenu.Picture.height*ustawienia.zoom);

form1.podgter.Repaint; }
end;

procedure TForm1.zoomcaleClick(Sender: TObject);
var r:double;
begin
ustawienia.zoom:=(form1.skrolpodglad.width-5)/ObrTerenu.width;
r:=(form1.skrolpodglad.height-5)/ObrTerenu.height;
if r<ustawienia.zoom then ustawienia.zoom:=r;
zoombar.Position:=round(ustawienia.zoom*100);
{form1.podgter.width:=trunc(form1.ObrTerenu.Picture.width*ustawienia.zoom);
form1.podgter.height:=trunc(form1.ObrTerenu.Picture.height*ustawienia.zoom);

form1.podgter.Repaint;}
end;

procedure TForm1.zoombarChange(Sender: TObject);
begin
ustawienia.zoom:=zoombar.Position/100;
form1.podgter.width:=trunc(ObrTerenu.width*ustawienia.zoom);
form1.podgter.height:=trunc(ObrTerenu.height*ustawienia.zoom);

form1.podgter.Repaint;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
tekstoprogramie.Refresh;
end;


procedure TForm1.njestczasClick(Sender: TObject);
begin
nileczasu.enabled:=(sender as tcheckbox).Checked;
end;

procedure TForm1.nsterowanieClick(Sender: TObject);
begin
nsterowanapostac.Enabled:=(sender as tcheckbox).Checked;
end;

procedure TForm1.podgterMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if tryb_dzialania=10 then tryb_dzialania:=0;
//ruch_ekranu:=Button=mbmiddle;
ruch_ekranu:=false;
if ruch_ekranu then (sender as tpaintbox).cursor:=crSizeAll else (sender as tpaintbox).cursor:=crCross;
end;

procedure TForm1.ZapiszClick(Sender: TObject);
begin
zapisz_misje(nnazwa.Text);
zroblistyplikow;
end;

procedure TForm1.listamisjiClick(Sender: TObject);
var a:integer;
begin
if (sender as tlistbox).ItemIndex>=0 then begin
   ustawienia.wybranamisja:=(sender as tlistbox).items[(sender as tlistbox).ItemIndex];
   Wczytaj.Enabled:=true;
   a:=(sender as tlistbox).ItemIndex;
   zroblistyplikow;
   (sender as tlistbox).ItemIndex:=a;
end;
end;

procedure TForm1.WczytajClick(Sender: TObject);
begin
wczytaj_misje(ustawienia.wybranamisja);
wczytaj_teren(ustawienia.wybranyteren, false);
Zapisz.Enabled:=true;
end;

procedure TForm1.nwyp_czasClick(Sender: TObject);
begin
if (sender as TCheckBox).State in [cbchecked,cbgrayed] then njestczas.Checked:=true;
end;

procedure TForm1.nwyp_zginieClick(Sender: TObject);
begin
nwyp_zginieile.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
nwyp_zginiegrup.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
end;

procedure TForm1.nwyp_dojdzieClick(Sender: TObject);
begin
nwyp_dojdzieile.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
nwyp_dojdziegrup.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
end;

procedure TForm1.nwyp_zebraneClick(Sender: TObject);
begin
nwyp_zebraneile.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
end;

procedure TForm1.nwyp_zniszczoneClick(Sender: TObject);
begin
nwyp_zniszczoneile.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
end;

procedure TForm1.nprzeg_zginieClick(Sender: TObject);
begin
nprzeg_zginieile.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
nprzeg_zginiegrup.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
end;

procedure TForm1.nprzeg_dojdzieClick(Sender: TObject);
begin
nprzeg_dojdzieile.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
nprzeg_dojdziegrup.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
end;

procedure TForm1.nprzeg_zebraneClick(Sender: TObject);
begin
nprzeg_zebraneile.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
end;

procedure TForm1.nprzeg_zniszczoneClick(Sender: TObject);
begin
nprzeg_zniszczoneile.Enabled:=(sender as Tcheckbox).State in [cbchecked,cbgrayed];
end;

procedure TForm1.ustawwszystkieClick(Sender: TObject);
var a:integer;
begin
for a:=0 to max_broni do
    namunicja.Cells[1,a+1]:=l2t(ustawwszystkie_ile.value,0);

end;


procedure TForm1.nbrondomyslnaExit(Sender: TObject);
begin
if nazwy_broni[nbrondomyslna.Value]='' then nbrondomyslna.Value:=nbrondomyslna.Value-1;
end;

procedure TForm1.KolorClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
colordialog1.Color:=(sender as TShape).Brush.Color;
if (colordialog1.execute) then begin
   (sender as TShape).Brush.Color:=colordialog1.Color;
   druzyna[(sender as TShape).tag].kolor_druzyny :=colordialog1.Color;
   ndruzyny.Cells[9,1+(sender as TShape).tag]:=inttohex(druzyna[(sender as TShape).tag].kolor_druzyny,6);
end;

end;

end.
