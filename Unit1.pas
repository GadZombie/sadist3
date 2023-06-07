unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  DXInput, DXSounds, DIB,
  unitKolesie, unitPociski, unitsyfki, unitefekty, unitGraGlowna, UnitPrzedmioty,
  UnitMiesko, UnitMenuGlowne,
  sinusy,vars, DXClass, DXDraws, Wave, ExtCtrls,
  PDrawEx, d3d9, AGFUnit, PowerTypes, PowerDraw3, PowerTimers, PowerInputs,
  ImgList, UnitPliki, directinput8, unitpogoda, unitautorzy,unitmenusy,
  unitstringi, unitmisje, audiere, unitdzwiek,
  al, altypes, alut, oooal;


type
  TForm1 = class(TForm)

    zegarek: TTimer;
    PowerDraw1: TPowerDraw;
    PowerTimer1: TPowerTimer;
    PowerInput1: TPowerInput;
    sladysyfkow: TImageList;

    procedure graj(g:TAlObject; x,y:real; stopienzmianywysokosci:word; glosnosc:real=1);
    procedure wczytaj_dzwieki;

    procedure drawsprajt(s:TSprajt; sx,sy:integer; n:integer);
    procedure drawsprajtalpha(s:TSprajt; sx,sy:integer; n:integer; alfa:byte);
    procedure drawsprajtkolor(s:TSprajt; sx,sy:integer; n:integer; kolor:cardinal);
    procedure linia(x1,y1,x2,y2:integer; kolor:cardinal);

    procedure pokaz_wczytywanie(t:string='');
    procedure schowaj_wczytywanie;

    procedure start;
    procedure inicjalizujmuzyke;
    procedure grajkawalek(t:string; streaming:boolean);
    procedure wlaczmuzyke(ripit:boolean);
    procedure wylaczmuzyke;
    procedure zakonczmuzyke;
    procedure popraw_dol_maski_terenu;
    procedure czyscteren;
    procedure ustaw_parametry_nieba;
    procedure ustaw_dane_terenu;
    procedure poprawustawienianieba_powczytaniu;
    procedure zrobkrewdruzynie(ktora:integer; kolor:cardinal);
    procedure wczytajdruzyne(ktora:integer; nazwa:string);
    procedure wczytajteksture(nazwa:string);
    procedure wczytajobiekt(nazwa:string);
    procedure wczytaj_druzyny;
    procedure nowyteren;
    procedure nowyteren_wczytaj(nazwa:string);
    procedure nowyteren_wczytaj_misja(nazwa:string);
    procedure stdkfg;
    procedure zliczSkonczoneMisje;
    procedure wypelnlistyplikow;
    procedure wypelnlisteterenow;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure wczytajobrazki;
    procedure zmienobrazkiikonbroni;
    procedure FreeDirectDraw;
    procedure zegarekTimer(Sender: TObject);
    procedure PowerTimer1Process(Sender: TObject);
    procedure PowerTimer1Render(Sender: TObject);
    procedure PowerDraw1InitDevice(Sender: TObject; var ExitCode: Integer);
    procedure wczytaj_wszystkie_tekstury;
    procedure graj_muzyke_w_grze(ktory:integer);

    procedure AppActivate(Sender: TObject);
    procedure AppDeactivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
  public
    { Public declarations }
    dzw_wybuchy: TDzwieki;
    dzw_bronie_strzaly: TDzwieki;
    dzw_bronie_inne: TDzwieki;
    dzw_rozne: TDzwieki;
    dzw_zwierzaki: TDzwieki;
    dzw_zly_pan: TDzwieki;
  end;

const
  max_ilosc_dzwiekow_w_klatce=4;

var
  Form1: TForm1;
  ilosc_dzwiekow_w_klatce:integer;

  pelny_ekran:boolean=true;

  AudiereDevice:TAdrAudioDevice;
  muzyka:record
      Sound:TAdrOutputStream;
      source:TAdrSampleSource;
      wlaczona:boolean;
      ktory_kawalek_z_listy_gra:integer;
  end;

 wczytywanie:TSprajt;

 //dzwieki
  listenerpos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenervel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenerori: array [0..5] of TALfloat= ( 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  przeziledziel:integer = 180; //do liczenia odleglosci listenera od dzwieku

 procedure robsprajt(var s:TSprajt; plik:string; rx,ry:integer; ilosc_bitow:integer=16);
 procedure wywalblad(s:string);

implementation

uses Types, TGAReader, unitrysowanie, inifiles;

{$R *.dfm}

//--------------------------------------------------------

procedure TForm1.graj(g:TAlObject; x,y:real; stopienzmianywysokosci:word; glosnosc:real=1);
var p,v,sx,sy:single;
d:real;
begin
if not kfg.calkiem_bez_dzwiekow and kfg.jest_dzwiek then begin
   if ilosc_dzwiekow_w_klatce>=max_ilosc_dzwiekow_w_klatce then exit;
   if (x>=ekran.px) and (x<=ekran.px+ekran.width) and
      (y>=ekran.py) and (y<=ekran.py+ekran.Height) then begin
      v:=1;
//      g.xpos:=0;
//      g.ypos:=0;
   end else begin
       sx:=ekran.px+(ekran.width shr 1);
       sy:=ekran.py+(ekran.height shr 1);

{       d:=sqrt2(abs(sqr(sx-x)+sqr(sy-y)));

       v:=1-d/800;
       if (v<0) then exit;
       if (v>1) then v:=1;}

//       g.xpos:=sx/100;
//       g.ypos:=sy/100;

   end;

//   sx:=ekran.px+(ekran.width shr 1);
//   sy:=ekran.py+(ekran.height shr 1);
   g.xpos:=x/przeziledziel;
   g.ypos:=y/przeziledziel;

   g.gain:=(kfg.glosnosc/100)*glosnosc;

   p:=(trunc(x)-ekran.px-(ekran.width shr 1))/500;
   if p<-1 then p:=-1 else
   if p>1 then p:=1;


   if stopienzmianywysokosci>0 then
      g.pitch:=(22050-stopienzmianywysokosci shr 1+random(stopienzmianywysokosci))/22050
   else
      g.pitch:=1;


   g.Play;
{    if not g.ciagly then begin
       g.SoundEf.SetPan(p);
       g.SoundEf.SetVolume(v);
       if stopienzmianywysokosci>0 then
          g.SoundEf.SetPitchShift( (22050-stopienzmianywysokosci shr 1+random(stopienzmianywysokosci))/22050 )
        else g.SoundEf.SetPitchShift(1);
       g.SoundEf.Play;
    end else begin
       g.Sound.SetPan(p);
       g.Sound.SetVolume(v);
       if stopienzmianywysokosci>0 then
          g.Sound.SetPitchShift( (22050-stopienzmianywysokosci shr 1+random(stopienzmianywysokosci))/22050 )
        else g.Sound.SetPitchShift(1);
       g.Sound.Play;
    end;
}


   inc(ilosc_dzwiekow_w_klatce);
end;
end;

procedure wczytajdzwiek(dzw: TDzwieki ; nazwa:string; czyciagly:boolean=false; relat:boolean=true);
begin
if not kfg.calkiem_bez_dzwiekow then begin
  log('Wczytywanie dzwieku: '+nazwa);
    with dzw.Add do begin
      Create;
      LoadFromFile(nazwa);
      if czyciagly then
         loop:=TRUE
      else
         loop:=FALSE;

      if relat then relative:=AL_TRUE
               else relative:=AL_FALSE;

      Update;

    end;
end else begin
    log('Dzwiek: '+nazwa+' pominiety z powodu wylaczonych dzwiekow w konfiguracji');
    dzw.Add;
end;
end;

procedure Tform1.wczytaj_dzwieki;
const s:string='Data\';
begin
//if not kfg.calkiem_bez_dzwiekow then begin
  log('Wczytywanie dzwiekow');

  dzw_wybuchy:=TDzwieki.Create(TAlObject);
    wczytajdzwiek(dzw_wybuchy, s+'wybuch1.wav'); //0
    wczytajdzwiek(dzw_wybuchy, s+'wybuch2.wav'); //1
    wczytajdzwiek(dzw_wybuchy, s+'wybuch3.wav'); //2
    wczytajdzwiek(dzw_wybuchy, s+'wybuch4.wav'); //3
    wczytajdzwiek(dzw_wybuchy, s+'wybuch5.wav'); //4

  dzw_bronie_strzaly:=TDzwieki.Create(TAlObject);
    wczytajdzwiek(dzw_bronie_strzaly, s+'bazuka.wav'); //0
    wczytajdzwiek(dzw_bronie_strzaly, s+'granat-bomba.wav'); //1
    wczytajdzwiek(dzw_bronie_strzaly, s+'Minigan.wav'); //2
    wczytajdzwiek(dzw_bronie_strzaly, s+'karabin.wav'); //3
    wczytajdzwiek(dzw_bronie_strzaly, s+'strzelba.wav'); //4
    wczytajdzwiek(dzw_bronie_strzaly, s+'snajper.wav'); //5
    wczytajdzwiek(dzw_bronie_strzaly, s+'laser1.wav',true); //6
    wczytajdzwiek(dzw_bronie_strzaly, s+'prad.wav',true); //7
    wczytajdzwiek(dzw_bronie_strzaly, s+'miotacz.wav',true); //8
    wczytajdzwiek(dzw_bronie_strzaly, s+'zemsta.wav'); //9
    wczytajdzwiek(dzw_bronie_strzaly, s+'pilaluz.wav',true); //10
    wczytajdzwiek(dzw_bronie_strzaly, s+'pilatnie1.wav',true); //11
    wczytajdzwiek(dzw_bronie_strzaly, s+'pilatnie.wav',true); //12
    wczytajdzwiek(dzw_bronie_strzaly, s+'rejlgan.wav'); //13

  dzw_bronie_inne:=TDzwieki.Create(TAlObject);
    wczytajdzwiek(dzw_bronie_inne, s+'granat-odbijasie.wav'); //0
    wczytajdzwiek(dzw_bronie_inne, s+'bomba-odbijasie.wav'); //1
    wczytajdzwiek(dzw_bronie_inne, s+'przedmiot-odbijasie.wav'); //2
    wczytajdzwiek(dzw_bronie_inne, s+'minapip.wav'); //3
    wczytajdzwiek(dzw_bronie_inne, s+'duzygranat-rozpadasie.wav'); //4
    wczytajdzwiek(dzw_bronie_inne, s+'ogien.wav', true, false); //5
    wczytajdzwiek(dzw_bronie_inne, s+'rikoszet1.wav'); //6
    wczytajdzwiek(dzw_bronie_inne, s+'rikoszet2.wav'); //7
    wczytajdzwiek(dzw_bronie_inne, s+'rikoszet3.wav'); //8
    wczytajdzwiek(dzw_bronie_inne, s+'kowadlo.wav'); //9
    wczytajdzwiek(dzw_bronie_inne, s+'ciezkikamol.wav'); //10
    wczytajdzwiek(dzw_bronie_inne, s+'fortepian.wav'); //11
    wczytajdzwiek(dzw_bronie_inne, s+'beczka.wav'); //12

  dzw_rozne:=TDzwieki.Create(TAlObject);
    wczytajdzwiek(dzw_rozne, s+'postac-bierze-bron.wav'); //0
    wczytajdzwiek(dzw_rozne, s+'syf-spada.wav'); //1
{  }  wczytajdzwiek(dzw_rozne, s+'bulbul.wav'); //2   DO ZMIANY! MOZNA TU WCZYTAC COS INNEGO!!!!!!
    wczytajdzwiek(dzw_rozne, s+'psss1.wav'); //3
    wczytajdzwiek(dzw_rozne, s+'psss2.wav'); //4
    wczytajdzwiek(dzw_rozne, s+'plum.wav'); //5
    wczytajdzwiek(dzw_rozne, s+'deszcz.wav', true, false); //6
    wczytajdzwiek(dzw_rozne, s+'grzmot1.wav'); //7
    wczytajdzwiek(dzw_rozne, s+'grzmot2.wav'); //8
    wczytajdzwiek(dzw_rozne, s+'grzmot3.wav'); //9
    wczytajdzwiek(dzw_rozne, s+'bulbul.wav'); //10
    wczytajdzwiek(dzw_rozne, s+'bulbul.wav'); //11
    wczytajdzwiek(dzw_rozne, s+'postac.wav'); //12
    wczytajdzwiek(dzw_rozne, s+'wiatr1.wav',true); //13
    wczytajdzwiek(dzw_rozne, s+'wiatr2.wav',true); //14
    wczytajdzwiek(dzw_rozne, s+'wiatr3.wav',true); //15
    wczytajdzwiek(dzw_rozne, s+'wiatr4.wav',true); //16
    wczytajdzwiek(dzw_rozne, s+'cisza.wav'); //17

  dzw_zwierzaki:=TDzwieki.Create(TAlObject);
    wczytajdzwiek(dzw_zwierzaki, s+'netoper.wav'); //0

  dzw_zly_pan:=TDzwieki.Create(TAlObject);
    wczytajdzwiek(dzw_zly_pan, s+'smiech1.wav'); //1
    wczytajdzwiek(dzw_zly_pan, s+'smiech2.wav'); //2
    wczytajdzwiek(dzw_zly_pan, s+'smiech3.wav'); //3
    wczytajdzwiek(dzw_zly_pan, s+'smiech4.wav'); //4
    wczytajdzwiek(dzw_zly_pan, s+'smiech5.wav'); //5
    wczytajdzwiek(dzw_zly_pan, s+'smiech6.wav'); //6
    wczytajdzwiek(dzw_zly_pan, s+'smiech7.wav'); //7

//end;
end;


//--------------------------------------------------------

procedure robsprajt(var s:TSprajt; plik:string; rx,ry:integer; ilosc_bitow:integer=16);
var
  f:file;
  header:TGAHeader;
  res:integer;
  tx,ty,a:integer;
  typ:0..127;
begin
log('Tworzenie sprajta '+plik+' [rozmiar:x='+l2t(rx,0)+', y='+l2t(ry,0)+']');
if s.surf<>nil then begin
   log('  Usuwanie starej tekstury');
   s.surf.Free;
   s.surf:=nil;
end;

assignfile(f,plik);
filemode:=0;
reset(f,1);
with header do begin
   blockread(f,idlength,sizeof(idlength));
   blockread(f,colourmaptype,sizeof(colourmaptype));
   blockread(f,datatypecode,sizeof(datatypecode));
   blockread(f,colourmaporigin,sizeof(colourmaporigin));
   blockread(f,colourmaplength,sizeof(colourmaplength));
   blockread(f,colourmapdepth,sizeof(colourmapdepth));
   blockread(f,x_origin,sizeof(x_origin));
   blockread(f,y_origin,sizeof(y_origin));
   blockread(f,width,sizeof(width));
   blockread(f,height,sizeof(height));
end;
closefile(f);
log('  Rzeczywiste wymiary bitmapy: rx='+l2t(header.width,0)+', ry='+l2t(header.height,0));

log('  Tworzenie tekstury');
 s.surf:= TAGFImage.Create(form1.PowerDraw1);

 if rx=-1 then rx:=header.width;
 if ry=-1 then ry:=header.height;
 if ry=-2 then ry:=header.width;

 a:=0;
 while (a<high(dozwrozm)) and (dozwrozm[a]<header.width) do inc(a);
 tx:=dozwrozm[a];
 a:=0;
 while (a<high(dozwrozm)) and (dozwrozm[a]<header.height) do inc(a);
 ty:=dozwrozm[a];

 if kfg.glebokosc_tekstur=0 then begin
     case ilosc_bitow of
       17:typ:=D3DFMT_A1R5G5B5;
       32:typ:=D3DFMT_A8R8G8B8;
       else {16} typ:=D3DFMT_A4R4G4B4;
     end;
 end else
     if kfg.glebokosc_tekstur=1 then typ:=D3DFMT_A4R4G4B4
        else typ:=D3DFMT_A8R8G8B8;

 Res:= s.surf.LoadFromFile(plik, rx,ry,tx,ty, typ);
 if (Res <> 0) then
  begin
   log('  Blad przy wczytywaniu pliku');
   form1.PowerDraw1.Finalize();

   MessageDlg(ErrorString(Res), mtError, [mbOk], 0);

   Application.Terminate();
   form1.PowerTimer1.MayRender:= False;
   Exit;
  end;



  if rx=-1 then begin {jak sie nie poda wymiarow sprajta (1 klatki) to bierze z szerokosci sprajta. uwaga: musi byc kwadratowy!}
     s.rx:=header.width;//rx;
     s.ry:=header.width;//ry;
  end else begin
     s.rx:=rx;
     s.ry:=ry;
  end;
  s.ofsx:=s.rx div 2;
  s.ofsy:=s.ry div 2;
  s.klatek:=s.surf.PatternCount;// header.height div s.ry;
end;


procedure Tform1.drawsprajt(s:TSprajt; sx,sy:integer; n:integer);
begin
 if (sx+s.rx>=0) and
    (sx<=ekran.width) and
    (sy+s.ry>=0) and
    (sy<=ekran.height) then
     PowerDraw1.RenderEffect(s.surf, sx,sy, n, effectSrcAlpha{ or effectDiffuse});
end;

procedure Tform1.drawsprajtalpha(s:TSprajt; sx,sy:integer; n:integer; alfa:byte);
begin
 if (sx+s.rx>=0) and
    (sx<=ekran.width) and
    (sy+s.ry>=0) and
    (sy<=ekran.height) then
 PowerDraw1.RenderEffectcol(s.surf, sx,sy, (alfa shl 24) or $FFFFFF, n, effectSrcAlpha or effectDiffuse);
end;

procedure Tform1.drawsprajtkolor(s:TSprajt; sx,sy:integer; n:integer; kolor:cardinal);
begin
 if (sx+s.rx>=0) and
    (sx<=ekran.width) and
    (sy+s.ry>=0) and
    (sy<=ekran.height) then
 PowerDraw1.RenderEffectcol(s.surf, sx,sy, kolor, n, effectSrcAlpha or effectDiffuse);
end;

procedure Tform1.linia(x1,y1,x2,y2:integer; kolor:cardinal);
begin
 PowerDraw1.Line(point(x1,y1),point(x2,y2),kolor,kolor,0);

end;

procedure Tform1.inicjalizujmuzyke;
begin
if not kfg.calkiem_bez_muzyki then begin
  log('Inicjalizacja muzyki');
   AdrLoadDLL;
   AudiereDevice := AdrOpenDevice('', '');
   AudiereDevice.Ref;
end;
end;

procedure Tform1.grajkawalek(t:string; streaming:boolean);
var w,n:string;
frmt:TAdrSampleFormat;
chanc,samprat:integer;
begin
if not kfg.calkiem_bez_muzyki then begin
  log('Otwieranie utworu: '+t);
   n:=ExtractFileName(t);
   w:=uppercase(ExtractFileExt(t));
   t:='Music\'+t;
   if w='.MP3' then muzyka.source:=AdrOpenSampleSource(pchar(t),FF_MP3)
   else
   if w='.OGG' then muzyka.source:=AdrOpenSampleSource(pchar(t),FF_OGG)
   else
   if (w='.MOD') or (w='.S3M') or (w='.XM') or (w='.IT') then
      muzyka.source:=AdrOpenSampleSource(pchar(t),FF_MOD)
   else exit;
  // muzyka.source:=AdrOpenSampleSource(pchar(t),FF_AUTODETECT);
   muzyka.Sound:=AdrOpenSound(AudiereDevice, muzyka.source, streaming);

   muzyka.source.GetFormat(chanc,samprat,frmt);

   log('Utwor wlaczony [kanaly='+l2t(chanc,0)+', samplerate='+l2t(samprat,0)+']');

   if glowne_co_widac=1 then nowynapiswrogu(Gra_odtwarzane+n,200);
end;
end;

procedure Tform1.wlaczmuzyke(ripit:boolean);
begin
if not kfg.calkiem_bez_muzyki then begin
   if not kfg.jest_muzyka then exit;
   log('Wlaczanie muzyki');
   muzyka.Sound.SetRepeat(ripit);
   muzyka.Sound.SetVolume(kfg.glosnoscmuzyki);
   muzyka.Sound.Play;
   muzyka.wlaczona:=true;
end;
end;

procedure Tform1.wylaczmuzyke;
begin
if not kfg.calkiem_bez_muzyki then begin
    if not kfg.jest_muzyka then exit;
    log('Wylaczanie muzyki');
      if muzyka.wlaczona then muzyka.Sound.Stop;
      muzyka.wlaczona:=false;
end;
end;

procedure Tform1.zakonczmuzyke;
begin
if not kfg.calkiem_bez_muzyki then begin
    log('Konczenie muzyki');
     wylaczmuzyke;
     try
        muzyka.Sound.unref;
        AudiereDevice.unref;
     except
     end;
end;
end;

procedure Tform1.pokaz_wczytywanie(t:string);
begin
 robsprajt(wczytywanie,'Graphics\wczytywanie.tga',200,200);
 form1.PowerDraw1.Clear($FF000000);
 form1.PowerDraw1.BeginScene();

 PowerDraw1.RenderEffect(wczytywanie.surf,powerdraw1.Width div 2-wczytywanie.ofsx,powerdraw1.Height div 2-wczytywanie.ofsy,0,effectsrcalpha);
 if kfg.log then pisz(Log_is_on,0,0);

 if (t<>'') and (obr.font.surf<>nil) then begin
    pisz(t,powerdraw1.width div 2-trunc(length(t)*4.5),powerdraw1.Height div 2+wczytywanie.ofsy+10);
 end;

 if ktore_haslo_wczytywanie_widac>=1 then begin
    piszdowolne(rodzaje_wczytywanie[hasla_wczytywanie[ktore_haslo_wczytywanie_widac].r],
                30,powerdraw1.Height div 2+wczytywanie.ofsy+40,
                $FF1050ff, 9,11,0
                );
    piszdowolnezlamaniem(hasla_wczytywanie[ktore_haslo_wczytywanie_widac].t,
                50,powerdraw1.Height div 2+wczytywanie.ofsy+70,
                $FF20ffff, 8,11,ekran.width-100, 0
                );
 end;

 form1.PowerDraw1.EndScene();
 form1.PowerDraw1.Present();

 if wczytywanie.surf<>nil then begin
    wczytywanie.surf.Free;
    wczytywanie.surf:=nil;
 end;

end;

procedure Tform1.schowaj_wczytywanie;
begin
 form1.PowerDraw1.Clear($FF000000);
 form1.PowerDraw1.BeginScene();
 form1.PowerDraw1.EndScene();
 form1.PowerDraw1.Present();
end;

procedure wywalblad(s:string);
begin
log('B≥πd: '+s);
{form1.PowerDraw1.DoneDevice();
form1.PowerDraw1.Finalize();}
Messagebox(form1.Handle,pchar(s),'B≥πd!', MB_OK or MB_ICONERROR or MB_TASKMODAL);
Application.Terminate();
//Abort;
Exit;
end;

procedure TForm1.start;
var a,b:integer;
 Res: Integer;
 argv: array of PChar;
begin
ChDir(ExtractFilePath(Application.ExeName));

kfg.log:=(ParamCount>=1) and (uppercase(paramstr(1))='-L');
kasujlog;
log('Start');
randomize;
_InitCosin;
wyjscie_z_programu:=false;
wroc_do_menu:=0;

{A-Z} for a:=0 to 25 do tabznakow[chr(65+a)]:=32+a;
{a-z} for a:=0 to 25 do tabznakow[chr(97+a)]:=64+a;
{0-9} for a:=0 to 9  do tabznakow[chr(48+a)]:=15+a;
tabznakow['!']:=0;
tabznakow['"']:=1;
tabznakow['#']:=2;
tabznakow['$']:=3;
tabznakow['%']:=4;
tabznakow['&']:=5;
tabznakow['''']:=6;
tabznakow['(']:=7;
tabznakow[')']:=8;
tabznakow['*']:=9;
tabznakow['+']:=10;
tabznakow[',']:=11;
tabznakow['-']:=12;
tabznakow['.']:=13;
tabznakow['/']:=14;
tabznakow[':']:=25;
tabznakow[';']:=26;
tabznakow['<']:=27;
tabznakow['=']:=28;
tabznakow['>']:=29;
tabznakow['?']:=30;
tabznakow['@']:=31;

tabznakow['•']:=94;
tabznakow['∆']:=95;
tabznakow[' ']:=96;
tabznakow['£']:=97;
tabznakow['—']:=98;
tabznakow['”']:=99;
tabznakow['å']:=100;
tabznakow['è']:=101;
tabznakow['Ø']:=102;

tabznakow['π']:=103;
tabznakow['Ê']:=104;
tabznakow['Í']:=105;
tabznakow['≥']:=106;
tabznakow['Ò']:=107;
tabznakow['Û']:=108;
tabznakow['ú']:=109;
tabznakow['ü']:=110;
tabznakow['ø']:=111;

stdkfg;

setlength(koles,max_kol+1);
setlength(zwlokikolesi,max_zwlokikolesi+1);
setlength(poc,max_poc+1);
setlength(mina,max_mina+1);
setlength(syf,max_syf+1);
setlength(mieso,max_mieso+1);
setlength(ciezkie,max_ciezkie+1);
setlength(wybuchdym,max_wybuchdym+1);
setlength(bombel,max_bombel+1);
setlength(przedm,max_przedm+1);
setlength(zwierz,max_zwierz+1);
setlength(niebo.gwiazdy,max_gwiazd+1);
setlength(deszcz,max_deszcz+1);
setlength(chmurka,max_chmurki+1);
setlength(swiatla,max_swiatla+1);


if kfg.ekran.windowed then begin
   form1.clientWidth:=kfg.ekran.width;
   form1.clientHeight:=kfg.ekran.height;
   form1.Left:=screen.Width div 2-form1.Width div 2;
   form1.Top:=screen.Height div 2-form1.Height div 2;
end;
ShowCursor(false);

PDrawExDLLName:= PDrawExDLLName;

PowerDraw1.Antialias:=kfg.ekran.antialias;
if kfg.ekran.bitdepth=16 then PowerDraw1.BitDepth:=bd16
                         else PowerDraw1.BitDepth:=bd32;
PowerDraw1.Dithering:=kfg.ekran.dithering;
PowerDraw1.Height:=kfg.ekran.height;
PowerDraw1.VSync:=kfg.ekran.vsync;
PowerDraw1.Width:=kfg.ekran.width;
PowerDraw1.Windowed:=kfg.ekran.windowed;
PowerDraw1.BackBufferCount:=kfg.ekran.buffers;
if not kfg.ekran.windowed then PowerDraw1.RefreshRate:=kfg.ekran.refresh;
PowerDraw1.Hardware:=true;

wypelnlistyplikow;
przejrzyjskonczonemisje;

if length(listyplikow[3])=0 then wywalblad('Brak plikÛw z druøynami!');
if length(listyplikow[4])=0 then wywalblad('Brak plikÛw ze scenariuszami!');

Application.OnActivate:= AppActivate;
Application.OnDeactivate:= AppDeactivate;

log('Inicjalizacja grafiki');
// initialize PowerGraph
Res:=PowerDraw1.Initialize();
if (Res <> 0) then begin
   MessageDlg(ErrorString(Res), mtError, [mbOk], 0);
   Application.Terminate();
   Exit;
 end;

 // initialize video mode
Res:=PowerDraw1.InitDevice();
if (Res <> 0) then begin
   MessageDlg(ErrorString(Res), mtError, [mbOk], 0);
   PowerDraw1.Finalize();
   Application.Terminate();
   Exit;
end;

 ktore_haslo_wczytywanie_widac:=0;

 ekran.width:=form1.PowerDraw1.Width;
 ekran.height:=form1.PowerDraw1.Height;

 for a:=0 to kfg.ekran.buffers do begin
     PowerDraw1.Clear($FF000000);
     form1.PowerDraw1.BeginScene();
     form1.PowerDraw1.EndScene();
     form1.PowerDraw1.Present();
 end;
 pokaz_wczytywanie;
 form1.PowerDraw1.BeginScene();
 pisz(l2t(form1.PowerDraw1.Width,0)+'x'+l2t(form1.PowerDraw1.Height,0),0,11);
 pisz('Hardware:'+bl[form1.PowerDraw1.hardware],0,22);
 pisz('Antialias:'+bl[form1.PowerDraw1.antialias],0,33);
 pisz('Dithering:'+bl[form1.PowerDraw1.dithering],0,44);
 pisz('Buffers:'+l2t(form1.PowerDraw1.BackBufferCount,0),0,55);
 if form1.PowerDraw1.Windowed then pisz('Windowed',0,66)
                              else pisz('Full screen',0,66);
 form1.PowerDraw1.EndScene();
 form1.PowerDraw1.Present();


 wypelnlisteterenow;

{ for a:=0 to max_druzyn do begin
     druzyna[a].numerplikunaliscie:=random(length(listyplikow[3]));
 end;}

 DecimalSeparator:='.';

 if not kfg.calkiem_bez_dzwiekow then begin
    AlutInit(nil,argv,kfg.ile_kanalow);
 end;
    wczytaj_dzwieki;
 if not kfg.calkiem_bez_dzwiekow then begin
     AlListenerfv ( AL_POSITION, @listenerpos);
     AlListenerfv ( AL_VELOCITY, @listenervel);
     AlListenerfv ( AL_ORIENTATION, @listenerori);
 end;

 if not kfg.calkiem_bez_muzyki then begin
    inicjalizujmuzyke;
 end;

 zrobkrewdruzynie(-1,$0000D0);

 for a:=0 to high(rysmenuuklad) do
     for b:=0 to high(rysmenuuklad[a]) do
         if (rysmenuuklad[a][b].typ=1) and (rysmenuuklad[a][b].sz=0) then rysmenuuklad[a][b].sz:=150;

 for a:=0 to high(bronmenuuklad) do
     for b:=0 to high(bronmenuuklad[a]) do
         if (bronmenuuklad[a][b].typ=1) and (bronmenuuklad[a][b].sz=0) then bronmenuuklad[a][b].sz:=150;

log('Wczytanie rekordow lokalnych');
 wczytaj_rekordy_lokalne;

log('Inicjalizacja inputa');
 PowerInput1.Initialize;
 mysz.x:=PowerDraw1.Width div 2;
 mysz.y:=PowerDraw1.Height div 2;

 schowaj_wczytywanie;

 ile_flara := 0;
 setlength(flary, max_flara);

 MenuGlowneZacznij(0);
end;

procedure Tform1.popraw_dol_maski_terenu;
var x,y:integer; a:byte;
begin
if warunki.typ_wody=0 then a:=10 else a:=0;
for y:=teren.height to teren.height+30 do begin
    for x:=0 to teren.width-1 do
        teren.maska[x,y]:=a;
end;
end;

procedure TForm1.czyscteren;
var a:integer;
begin
log('Czyszczenie danych terenu');
for a:=0 to max_kol do koles[a].jest:=false;
kol_nowy:=0;
for a:=0 to max_zwlokikolesi do zwlokikolesi[a].jest:=false;
zwlokikolesi_nowy:=0;
for a:=0 to max_poc do poc[a].jest:=false;
poc_nowy:=0;
for a:=0 to max_mina do mina[a].jest:=false;
mina_nowy:=0;
for a:=0 to max_syf do syf[a].jest:=false;
syf_nowy:=0;
for a:=0 to max_mieso do mieso[a].jest:=false;
mieso_nowy:=0;
for a:=0 to max_ciezkie do ciezkie[a].jest:=false;
ciezkie_nowy:=0;
for a:=0 to max_wybuchdym do wybuchdym[a].jest:=false;
wybuchdym_nowy:=0;
for a:=0 to max_bombel do bombel[a].jest:=false;
for a:=0 to max_deszcz do deszcz[a].jest:=false;
for a:=0 to max_chmurki do chmurka[a].jest:=false;
for a:=0 to max_przedm do przedm[a].jest:=false;
przedm_nowy:=0;
for a:=0 to max_zwierz do zwierz[a].jest:=false;
zwierz_nowy:=0;

ile_swiatel:=0;

setlength(tryb_misji.flagi,0);
setlength(tryb_misji.prostokaty,0);

bron.piorun_dostrzalu:=0;
bron.laserdlugosc:=0;
bron.went_szyb:=0;

druzynymenu.ilewejsc:=0;
for a:=0 to max_napis do napis[a].czas:=0;
druzynymenu.lecatezzgory:=true;

ile_min:=0;
end;


procedure TForm1.ustaw_parametry_nieba;
var a,b,d:integer;
begin
log('Ustawianie parametrow nieba');
//rx:=0; ry:=0; zy:=0;
//tyl:=false;
//jasn:=0; rodz:=0; sz:=0;
{teren.width:=obr.teren.surf.PatternWidth;
teren.height:=obr.teren.surf.PatternHeight;}

niebo.tloheight:=trunc(teren.height*0.8);
niebo.tlowidth:=trunc(teren.width*0.8);

if niebo.tloheight<ekran.height+obr.menud.ry then niebo.tloheight:=ekran.height+obr.menud.ry;
if niebo.tlowidth<ekran.width+30 then niebo.tlowidth:=ekran.width+30;

if teren.width-ekran.width<>0 then
   teren.tlododx:=(niebo.tlowidth-ekran.width)/(teren.width-ekran.width)
   else teren.tlododx:=0;
if teren.height-ekran.Height<>0 then
   teren.tlodody:=(niebo.tloheight-ekran.Height)/(teren.height-ekran.Height)
   else teren.tlodody:=0;

if teren.tlodody<0 then teren.tlodody:=0;
if teren.tlododx<0 then teren.tlododx:=0;
if teren.tlodody>1 then teren.tlodody:=0;
if teren.tlododx>1 then teren.tlododx:=0;

niebo.blysk:=0;
niebo.blyskkrotnosc:=0;
end;

procedure TForm1.ustaw_dane_terenu;
begin
with warunki do begin
     typ_wody:=0;
{     if random(5)<=2 then typ_wody:=0
        else typ_wody:=1+random(max_wod);}
     gleb_wody:=random(random(teren.height div 2));
     ust_wys_wody:=teren.height-warunki.gleb_wody;
     wys_wody:=ust_wys_wody;
     wiatr:=-0.1+random/5;
     godzina:=random(24)*100;
     deszcz:=random(8)=0;
     if not deszcz then snieg:=random(7)=0
        else snieg:=false;
     burza:=random(8)=0;
     silaburzy:=100+random(300);
     iloscchmur:=random(max_chmurki div 2);
     jakiechmury:=random(2);
end;

druzynymenu.ilewejsc:=0;

ekran.spkt:=gracz.pkt-1;
ekran.strup:=gracz.trupow-1;
ekran.czasniezmienionychwynikow:=0;

end;

procedure TForm1.poprawustawienianieba_powczytaniu;
var a,b,d:integer;
tyl:boolean;
    zx,zy,rx,ry,jasn,rodz:integer; r,sz:real;
begin
with niebo do begin
     tlo_grad_il:=100;
     tlo_grad_skok:=niebo.tloheight div tlo_grad_il;

     a:=0;
     while (a<=23) do begin
        b:=a+1;
        d:=1;
        while (not kolorytla[b mod 24].zmiana) do begin
           inc(b);
           inc(d);
        end;
        for b:=0 to d-1 do begin
            kolorytla[a+b].dlugosc:=d;
            kolorytla[a+b].bierzdanez:=a;
        end;
        inc(a,d);
     end;

     pog:=1;
     pog2:=1;
     pog_widac:=pog;
     pog2_widac:=pog2;
     jasnosc_nieba:=0;
     jasnosc_nieba_widac:=jasnosc_nieba;

     for a:=0 to high(gwiazdy) do begin
         gwiazdy[a].kat:=80+random*100;
         if tlowidth>=tloheight then gwiazdy[a].odl:=650+random*tlowidth
                                else gwiazdy[a].odl:=650+random*tloheight;
         gwiazdy[a].wielk:=40+random(150);
         gwiazdy[a].przezr:=random(150)+gwiazdy[a].wielk div 2;
     end;
end;
oblicz_kolory_tla;

unitgraglowna.licznik2:=(niebo.kolorytlaszybkosc*2-1) mod niebo.kolorytlaszybkosc;

warmenuuklad[16].mx:=teren.height-2;

rx:=0; ry:=0; zy:=0;
tyl:=false;
jasn:=0; rodz:=0; sz:=0;

niebo.ile_jest_chmur:=0;
if warunki.chmurki then begin
   for a:=0 to warunki.iloscchmur do begin
      case warunki.jakiechmury of
       0:begin {czarne}
          tyl:=random(4)>=1;
          if not tyl then begin
             zy:=random(50)-60;
             ry:=50+random(100);
          end else begin
              ry:=50+random(400);
              zy:=random(teren.height-abs(ry) shr 1)-60;
          end;
          jasn:=10+random(70);
          if ry<0 then ry:=abs(ry);
          rx:=ry-50+random(500);
          if rx<ry then rx:=ry;
          rodz:=random(4);
          sz:=0.8+random*2.4;
         end;
       1:begin {biale}
          tyl:=random(5)>=1;
          if not tyl then begin
             zy:=random(50)-60;
             ry:=50+random(70);
          end else begin
              zy:=random(teren.height)-60;
              ry:=50+round(random(140)/(1+abs(zy)/60));
          end;
          jasn:=255-random(70);
          if ry<0 then ry:=abs(ry);
          rx:=256+round(random(350)/(1+abs(zy)/40));
          if rx<ry then rx:=ry;
          rodz:=random(5);
          sz:=0.3+random*(2.7/(1+zy/100));
         end;
      end;

      zx:=random(teren.width+rx*2)-rx;

      nowachmurka(zx,
                  zy,
                  sz,
                  random(95)+160,
                  rx,ry,
                  rodz,
                  jasn,
                  tyl);
   end;
end;

end;

procedure TForm1.wczytajteksture(nazwa:string);
begin
log('Wczytywanie tekstury do pamieci: '+nazwa);
nazwa:=nazwa;//+'.tga';
if obr.tekstura<>nil then begin
   log('  Usuwanie starej tekstury');
   obr.tekstura.Free;
   obr.tekstura:=nil;
end;
if obr.teksturapok.surf<>nil then begin
   log('  Usuwanie starej tekstury 2');
   obr.teksturapok.surf.Free;
   obr.teksturapok.surf:=nil;
end;
log('  Tworzenie bitmapy');
obr.tekstura:=TBitmapEx.Create;
log('  Wczytywanie danych do bitmapy');
obr.tekstura.LoadFromFile('Textures\'+nazwa);
log('  Wczytywanie sprajta');
robsprajt(obr.teksturapok,'Textures\'+nazwa,-1,-1);
log('  OK');
end;

procedure TForm1.wczytajobiekt(nazwa:string);
var ob:Tinifile; s1,s2,s3:string; n,k1,k2:integer; c:cardinal;
begin
log('Wczytywanie obiektu do pamieci: '+nazwa);
if obr.obiekt<>nil then begin
   log('  Usuwanie starego obiektu');
   obr.obiekt.Free;
   obr.obiekt:=nil;
end;
if obr.obiektpok.surf<>nil then begin
   log('  Usuwanie starego obiektu 2');
   obr.obiektpok.surf.Free;
   obr.obiektpok.surf:=nil;
end;
log('  Tworzenie bitmapy');
obr.obiekt:=TBitmapEx.Create;
log('  Wczytywanie danych do bitmapy');
obr.obiekt.LoadFromFile('Objects\'+nazwa);
log('  Wczytywanie sprajta');
robsprajt(obr.obiektpok,'Objects\'+nazwa,-1,-1);

log('  Sprawdzenie, czy jest plik dodatkowy z wlasciwosciami obiektu');

podzielnazwe(nazwa, s1,s2,s3);
if FileExists('Objects\'+s2+'.ini') then begin
   log('    Jest - wczytywanie wlasciwosci obiektu z pliku '+s2+'.ini');
   ob:=TInifile.Create('Objects\'+s2+'.ini');
   setlength(wlasc_wczytanego_obiektu.swiatla, 0);

   n:=0;
   s1:='light'+l2t(n,0);
   while ob.SectionExists(s1) do begin
      setlength(wlasc_wczytanego_obiektu.swiatla, length(wlasc_wczytanego_obiektu.swiatla)+1);
      with wlasc_wczytanego_obiektu.swiatla[n] do begin
        x:=ob.ReadInteger(s1, 'x', 0);
        y:=ob.ReadInteger(s1, 'y', 0);
        typ:=ob.ReadInteger(s1, 'type', 0);
        wielkosc:=ob.ReadInteger(s1, 'size', 0);
        k1:=ob.ReadInteger(s1, 'angle', 0);
        if k1=-1 then kat:=random(256)
                 else kat:=k1;

        k1:=ob.ReadInteger(s1, 'color', 0);
        k2:=ob.ReadInteger(s1, 'intensity', 0);

        kolor:= cardinal(k2) shl 24 + cardinal(k1 and $FFFFFF);

        zniszczalne:=ob.ReadBool(s1, 'destroyable', true);
        ztylu:=ob.ReadBool(s1, 'back', false);
        efekt:=ob.ReadInteger(s1, 'effect', 0);
      end;
      inc(n);
      s1:='light'+l2t(n,0);
   end;

   ob.Free;
end else begin
   log('    Nie ma');
   setlength(wlasc_wczytanego_obiektu.swiatla, 0);
end;

log('  OK');
end;


procedure TForm1.zrobkrewdruzynie(ktora:integer; kolor:cardinal);
var
bm:TBitmap;
c:cardinal;
a,y,x:integer;
begin
log('Tworzenie sprajtow krwi druzyny '+l2t(ktora,0));
druzyna[ktora].kolor_krwi:=kolor;
bm:=tbitmap.Create;
sladysyfkow.GetBitmap(0,bm);
for a:=0 to 4 do begin
    for y:=0 to 1+a do
        for x:=0 to 1+a do begin
            c:=bm.Canvas.Pixels[x,y +a*6];
            if c<>$00FF00FF then c:=c and druzyna[ktora].kolor_krwi;
            druzyna[ktora].syfslad[a][x,y]:=
                                         $FF000000 or
                                    (c and $0000FF) shl 16 or
                                    (c and $00FF00) or
                                    (c and $FF0000) shr 16;
        end;
end;
bm.free;
bm:=nil;
end;

procedure TForm1.wczytajdruzyne(ktora:integer; nazwa:string);
//var a,b:integer;
const
  max_ani=18;
  max_mies=5;
  max_dzw=15;
  max_dym=7;
  dym_kolejnosc:array[0..max_dym] of integer=  (0,1,3,4,5,7,12,16);
var
  f:file;
  listarozm:array[0..70] of int64;
  a,b,b1,n:integer;
  suma:int64;
  d:TDate;
  c:cardinal;
  nazwatmpkat,s:string;
  nagtmp:TNagloweks3p;
  sm:integer;

  kk0:real;
  dx,dy:integer;

  function wczytajstring2(var plik:file):string;
  var
    buf:shortstring;
    bufa:array[0..254] of byte;
    d:word;
    d1:byte;
    m,dl:longint;
    t:string;
  begin
      blockread(plik, dl,sizeof(dl)); {length(t):=dl}
      m:=1;
      t:='';
      while m<=dl do begin
         if dl-(m-1)>255 then d:=255
            else d:=dl-(m-1);
         blockread(plik, bufa,d);
         move(bufa,buf[1],d);
         d1:=d;
         buf[0]:=chr(d1);

         t:=t+copy(buf,1,d);
         inc(m,d);
      end;
      if t=#1#2 then t:='';
      wczytajstring2:=t;
  end;


  procedure wczytajwartosc(var s:integer);
  var i:integer;
  begin
    blockread(f, i, sizeof(i));
    s:=i;
  end;

  procedure wypakujplik(n:integer; nazwa:string);
  var
    ToF: File;
    NumRead, NumWritten: Integer;
    Buf: array[1..2048] of Char;
    s:int64;
  begin
    AssignFile(ToF, nazwa);
    filemode:=1;
    Rewrite(ToF, 1);
    s:=0;
    repeat
      if s+sizeof(buf)<=listarozm[n] then BlockRead(F, Buf, SizeOf(Buf), NumRead)
         else BlockRead(F, Buf, listarozm[n]-s, NumRead);
      BlockWrite(ToF, Buf, NumRead, NumWritten);
      s:=s+numwritten;
    until (NumRead = 0) or (NumWritten <> NumRead);
    CloseFile(ToF);

    log(nazwa+': rozmiar='+inttostr(listarozm[n])+', wczytano='+inttostr(s));

    //formprogres.pasek.Progress:=formprogres.pasek.Progress+s;
    //application.processmessages;
  end;


begin
log('Wczytywanie druzyny '+l2t(ktora,0)+': '+nazwa);
pokaz_wczytywanie(Logo_WczytywanieDruzyny+l2t(ktora+1,0));

//* if druzyna[ktora].dzwieki_init then druzyna[ktora].dzwieki.Items.Finalize;
   if druzyna[ktora].dzwieki<>nil then begin
      if not kfg.calkiem_bez_dzwiekow then begin
          for a:=max_dzw downto 0 do begin
              if druzyna[ktora].dzwieki.Item[a].playing then begin
                 log(' zatrzymywanie dzwieku '+l2t(a,0)+' z '+l2t(max_dzw,0));
                 druzyna[ktora].dzwieki.Item[a].Stop;
              end;
              log(' usuwanie dzwieku '+l2t(a,0)+' z '+l2t(max_dzw,0));
              druzyna[ktora].dzwieki.Item[a].Destroy;
              //druzyna[ktora].dzwieki.Item[a]:=nil;
          end;
      end;
      log(' czyszczenie dzwiekow');
      druzyna[ktora].dzwieki.Clear;
   //   druzyna[ktora].dzwieki.Free;
   //   druzyna[ktora].dzwieki:=nil;
   end else
       druzyna[ktora].dzwieki:=tDzwieki.Create(TAlObject);

{-nowe}
  for a:=0 to max_ani do begin
      druzyna[ktora].aniszyb[a]:=2;
      druzyna[ktora].anidzialanie[a].x:=0;
      druzyna[ktora].anidzialanie[a].y:=0;
      druzyna[ktora].anidzialanie[a].klatka:=0;
      druzyna[ktora].anidzialanie[a].dx:=0;
      druzyna[ktora].anidzialanie[a].dy:=0;
  end;

  for a:=0 to max_mies do begin
      druzyna[ktora].miesomiejsca[a].x:=0;
      druzyna[ktora].miesomiejsca[a].y:=0;
      druzyna[ktora].miesomiejsca[a].kl:=0;
      druzyna[ktora].miesomiejsca[a].kat:=0;
      druzyna[ktora].miesomiejsca[a].odl:=0;

      druzyna[ktora].miesomiejsca[a].zaczx:=0;
      druzyna[ktora].miesomiejsca[a].zaczy:=0;

      {form1.mies_d_ani_wym[a]:=0;
      form1.mies_d_ani_ilekl[a]:=0;}
  end;

//* to powinno zostac wczytane z pliku:
{  druzyna[ktora].miesomiejsca[0].zaczx:= 0; //glowa
  druzyna[ktora].miesomiejsca[0].zaczy:= 5;
  druzyna[ktora].miesomiejsca[1].zaczx:= 0; //srodek
  druzyna[ktora].miesomiejsca[1].zaczy:= 0;
  druzyna[ktora].miesomiejsca[2].zaczx:= 5 ; //l noga
  druzyna[ktora].miesomiejsca[2].zaczy:=-7 ;
  druzyna[ktora].miesomiejsca[3].zaczx:=-5 ; //p noga
  druzyna[ktora].miesomiejsca[3].zaczy:=-7 ;
  druzyna[ktora].miesomiejsca[4].zaczx:= 3 ; //l reka
  druzyna[ktora].miesomiejsca[4].zaczy:=-4 ;
  druzyna[ktora].miesomiejsca[5].zaczx:=-3 ; //p reka
  druzyna[ktora].miesomiejsca[5].zaczy:=-4 ;}
//*

  setlength(druzyna[ktora].aninudzi,1);
  druzyna[ktora].aninudzi[0].od:=0;
  druzyna[ktora].aninudzi[0].ile:=0;
  druzyna[ktora].aninudzi[0].szyb:=0;
  druzyna[ktora].aninudzi[0].tylkoraz:=true;

//*  druzyna[ktora].dzwieki.Items.Clear;

{-wczytaj}
  n:=-1;

//  delete(nazwa,length(nazwa)-4,4);
  AssignFile(f, 'Teams\'+nazwa+'.s3p');
try
  filemode:=0;
  Reset(f, 1);

  //naglowek
  blockread(f, nagtmp, sizeof(nagtmp));
  if nagtmp<>nagloweks3p then begin
     log('Z≥y nag≥Ûwek pliku!');
     raise exception.create('Z≥y nag≥Ûwek pliku!');
  end;

  //ustawienia 2 czesc
  {form1.nnazwa.Text:=}wczytajstring2(f);
  {form1.nautor.Text:=}wczytajstring2(f);
  blockread(f, d, sizeof(d));
  //form1.ndatastworzenia.date:=d;

  log('** Rozmiary plikow: pozycja pliku:'+inttostr(filepos(f)) );
  //pliki
  n:=max_ani+max_mies+max_dzw+2;
  {formprogres.pasek.MaxValue:=n;}

  //najpierw wczytujemy kolejne rozmiary plikow
  for a:=0 to n do begin
      blockread(f, listarozm[a], sizeof(int64));
      //log(inttostr(a)+') '+inttostr(listarozm[a])+' b.');
  end;

  //tworzymy tymczasowy katalog dla plikow "wypakowanych"
  if not DirectoryExists('Teams\'+nazwa) then begin
     CreateDir('Teams\'+nazwa);
     rozpakowanedruzyny[druzyna[ktora].numerplikunaliscie]:=false;
  end;

  if rozpakowanedruzyny[druzyna[ktora].numerplikunaliscie] then begin
     log('Druzyna "'+nazwa+'" juz jest rozpakowana, pominiete zostanie wypakowywanie jej plikow dla przyspieszenia wczytywania!');

     b:=filepos(f);
     n:=-1;
     for a:=0 to max_ani do begin inc(n); b:=b+listarozm[n]; end;
     for a:=0 to max_mies do begin inc(n); b:=b+listarozm[n]; end;
     for a:=0 to max_dzw do begin inc(n); b:=b+listarozm[n]; end;
     seek(f,b);
  end;

  log('** Animacje postaci: pozycja pliku:'+inttostr(filepos(f)) );
  n:=-1;
  //potem kopie samych plikow
  for a:=0 to max_ani do begin
      inc(n);
      s:='Teams\'+nazwa+'\anim'+inttostr(a)+'.tga';
      if listarozm[n]>=1 then begin
         if not rozpakowanedruzyny[druzyna[ktora].numerplikunaliscie] then  wypakujplik(n,s);
         //form1.ani_edity[a].Text:=GetCurrentDir+'\'+s;
         {if not wczytaj_animacje(form1.d_animacje[a],s,30) then begin
            exception.Create('B≥πd przy otwieraniu animacji!');
         end;}
         robsprajt(druzyna[ktora].animacje[a],s,30,30);
      end;
  end;

  log('** Animacje miesa: pozycja pliku:'+inttostr(filepos(f)) );
  for a:=0 to max_mies do begin
      inc(n);
      s:='Teams\'+nazwa+'\anim_mies'+inttostr(a)+'.tga';
      if listarozm[n]>=1 then begin
         if not rozpakowanedruzyny[druzyna[ktora].numerplikunaliscie] then  wypakujplik(n,s);
         //form1.mies_ani_edity[a].Text:=GetCurrentDir+'\'+s;
         {if not wczytaj_animacje(form1.mies_d_animacje[a],s,0) then begin
            exception.Create('B≥πd przy otwieraniu animacji!');
         end;}
         robsprajt(druzyna[ktora].mieso[a],s,-1,-2);
      end;
  end;

  log('** DüwiÍki: pozycja pliku:'+inttostr(filepos(f)) );
  for a:=0 to max_dzw do begin
      inc(n);
      s:='Teams\'+nazwa+'\dzw'+inttostr(a)+'.wav';
      if listarozm[n]>=1 then begin
         if not rozpakowanedruzyny[druzyna[ktora].numerplikunaliscie] then  wypakujplik(n,s);
         //form1.dzwieki_edity[a].Text:=GetCurrentDir+'\'+s;
         //druzyna[ktora].dzwieki.Items.Add;
         //druzyna[ktora].dzwieki.Items[druzyna[ktora].dzwieki.Items.Count-1].Wave.LoadFromFile(s);
         wczytajdzwiek( druzyna[ktora].dzwieki, s);
      end;
  end;


//*  druzyna[ktora].dzwieki.Items.Initialize(DXSound1);
  druzyna[ktora].dzwieki_init:=true;

  //ustawienia 2 czesc
  log('** Ustawienia (1): pozycja pliku:'+inttostr(filepos(f)) );
  wczytajwartosc(druzyna[ktora].startsila);
  wczytajwartosc(druzyna[ktora].maxsila);
  wczytajwartosc(druzyna[ktora].maxtlen);

  wczytajwartosc(b); druzyna[ktora].szybkosc:=b/100;
  wczytajwartosc(b); druzyna[ktora].waga:=b/100;
  wczytajwartosc(b); druzyna[ktora].silabicia:=b/100;

  for a:=1 to 4 do
      wczytajwartosc(druzyna[ktora].maxamunicji[a]);

  blockread(f, c, sizeof(c));
  druzyna[ktora].kolor_krwi:=c;
  //form1.nkolorkrwi.Brush.Color:=c;

  log('** Ustawienia (2): pozycja pliku:'+inttostr(filepos(f)) );
  for a:=0 to max_ani do begin
      blockread(f, druzyna[ktora].aniszyb[a], sizeof(druzyna[ktora].aniszyb[a]));
      blockread(f, druzyna[ktora].anidzialanie[a].x, sizeof(druzyna[ktora].anidzialanie[a].x));
      blockread(f, druzyna[ktora].anidzialanie[a].y, sizeof(druzyna[ktora].anidzialanie[a].y));
      blockread(f, druzyna[ktora].anidzialanie[a].klatka, sizeof(druzyna[ktora].anidzialanie[a].klatka));
      blockread(f, druzyna[ktora].anidzialanie[a].dx, sizeof(druzyna[ktora].anidzialanie[a].dx));
      blockread(f, druzyna[ktora].anidzialanie[a].dy, sizeof(druzyna[ktora].anidzialanie[a].dy));
  end;

  log('** Ustawienia (3): pozycja pliku:'+inttostr(filepos(f)) );
  for a:=0 to max_mies do begin
      blockread(f, druzyna[ktora].miesomiejsca[a].x, sizeof(druzyna[ktora].miesomiejsca[a].x));
      blockread(f, druzyna[ktora].miesomiejsca[a].y, sizeof(druzyna[ktora].miesomiejsca[a].y));
      blockread(f, druzyna[ktora].miesomiejsca[a].kl, sizeof(druzyna[ktora].miesomiejsca[a].kl));

      blockread(f, druzyna[ktora].miesomiejsca[a].zaczx, sizeof(druzyna[ktora].miesomiejsca[a].zaczx));
      blockread(f, druzyna[ktora].miesomiejsca[a].zaczy, sizeof(druzyna[ktora].miesomiejsca[a].zaczy));

      blockread(f, sm{form1.mies_d_ani_wym[a]}, sizeof(sm{form1.mies_d_ani_wym[a]}));
      blockread(f, sm{form1.mies_d_ani_ilekl[a]}, sizeof(sm{form1.mies_d_ani_ilekl[a]}));
  end;

  log('** Ustawienia (4): pozycja pliku:'+inttostr(filepos(f)) );
  for a:=0 to max_ani do begin
      blockread(f, b1, sizeof(b1));
      setlength(druzyna[ktora].anibombana[a],b1);
      setlength(druzyna[ktora].bronmiejsca[a],b1);
      log('  Ustawienie animacji '+inttostr(a)+', klatek '+inttostr(b1) );
      if length(druzyna[ktora].anibombana[a])>=1 then
        for b:=0 to b1-1 do begin
            blockread(f, druzyna[ktora].anibombana[a][b].x, sizeof(druzyna[ktora].anibombana[a][b].x));
            blockread(f, druzyna[ktora].anibombana[a][b].y, sizeof(druzyna[ktora].anibombana[a][b].y));
            blockread(f, druzyna[ktora].anibombana[a][b].klatka, sizeof(druzyna[ktora].anibombana[a][b].klatka));

            blockread(f, druzyna[ktora].bronmiejsca[a][b].x, sizeof(druzyna[ktora].bronmiejsca[a][b].x));
            blockread(f, druzyna[ktora].bronmiejsca[a][b].y, sizeof(druzyna[ktora].bronmiejsca[a][b].y));
            blockread(f, druzyna[ktora].bronmiejsca[a][b].kat, sizeof(druzyna[ktora].bronmiejsca[a][b].kat));
        end;
  end;

  log('** Ustawienia (5): pozycja pliku:'+inttostr(filepos(f)) );
  blockread(f, b1, sizeof(b1));
  setlength(druzyna[ktora].aninudzi,b1);
  if length(druzyna[ktora].aninudzi)>=1 then
    for b:=0 to b1-1 do begin
        blockread(f, druzyna[ktora].aninudzi[b].od, sizeof(druzyna[ktora].aninudzi[b].od));
        blockread(f, druzyna[ktora].aninudzi[b].ile, sizeof(druzyna[ktora].aninudzi[b].ile));
        blockread(f, druzyna[ktora].aninudzi[b].szyb, sizeof(druzyna[ktora].aninudzi[b].szyb));
        blockread(f, druzyna[ktora].aninudzi[b].tylkoraz, sizeof(druzyna[ktora].aninudzi[b].tylkoraz));
    end;

  zrobkrewdruzynie(ktora,druzyna[ktora].kolor_krwi);

  {----------}
  druzyna[ktora].startbron:=1;
  druzyna[ktora].startamunicja:=0;
  druzyna[ktora].ma_byc_kolesi:=0;
  for a:=0 to max_druzyn do druzyna[ktora].przyjaciele[a]:=false;
  druzyna[ktora].przyjaciele[ktora]:=true;

  rozpakowanedruzyny[druzyna[ktora].numerplikunaliscie]:=true;

  for a:=0 to max_mies do
   if a<>1 then begin
     dx:=druzyna[ktora].miesomiejsca[a].x-druzyna[ktora].miesomiejsca[1].x;
     dy:=druzyna[ktora].miesomiejsca[a].y-druzyna[ktora].miesomiejsca[1].y;

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

     druzyna[ktora].miesomiejsca[a].kat:=trunc( (kk0/(pi180)) );
     druzyna[ktora].miesomiejsca[a].odl:=trunc( sqrt2(sqr(dx)+sqr(dy)) );
   end;


  {------dymki-------}

  {czyszczenie tablic:}
  log('** Teksty dymkow: pozycja pliku:'+inttostr(filepos(f)) );

  for a:=0 to max_dym do begin
      blockread(f, b1, sizeof(b1));
      log(inttostr(a)+') ilosc='+inttostr(b1));
      setlength(druzyna[ktora].aniteksty[dym_kolejnosc[a]],b1);
      if b1>0 then
         for b:=0 to b1-1 do begin
             druzyna[ktora].aniteksty[dym_kolejnosc[a]][b]:=wczytajstring2(f);
         end;
  end;

{  setlength(druzyna[ktora].aniteksty[0],3);
    druzyna[ktora].aniteksty[0][0]:='Hmmm...';
    druzyna[ktora].aniteksty[0][1]:='Ale piÍkny zachÛd s≥oÒca!';
    druzyna[ktora].aniteksty[0][2]:='Nudno tu';

  setlength(druzyna[ktora].aniteksty[1],2);
    druzyna[ktora].aniteksty[1][0]:='Zdrajca!';
    druzyna[ktora].aniteksty[1][1]:='Nie do mnie!';

  setlength(druzyna[ktora].aniteksty[3],2);
    druzyna[ktora].aniteksty[3][0]:='åmierÊ!';
    druzyna[ktora].aniteksty[3][1]:='Øryj to!';

  setlength(druzyna[ktora].aniteksty[4],2);
    druzyna[ktora].aniteksty[4][0]:='Hehe!';
    druzyna[ktora].aniteksty[4][1]:='£upi!';

  setlength(druzyna[ktora].aniteksty[5],3);
    druzyna[ktora].aniteksty[5][0]:='Hmm';
    druzyna[ktora].aniteksty[5][1]:='Co my tu mamy..';
    druzyna[ktora].aniteksty[5][2]:='MÛj skarb!';

  setlength(druzyna[ktora].aniteksty[7],4);
    druzyna[ktora].aniteksty[7][0]:='Ratunku!!';
    druzyna[ktora].aniteksty[7][1]:='Pomocy!';
    druzyna[ktora].aniteksty[7][2]:='Uuuaaaaaaa!';
    druzyna[ktora].aniteksty[7][3]:='AAaarrrgghhh!';

  setlength(druzyna[ktora].aniteksty[12],2);
    druzyna[ktora].aniteksty[12][0]:='Siup!';
    druzyna[ktora].aniteksty[12][1]:='£ap!';

  setlength(druzyna[ktora].aniteksty[16],3);
    druzyna[ktora].aniteksty[16][0]:='£apcie go!';
    druzyna[ktora].aniteksty[16][1]:='ZabiiiiiÊ!!';
    druzyna[ktora].aniteksty[16][2]:='Pomocy!';}



finally
  CloseFile(F);
end;



end;

procedure TForm1.wczytaj_druzyny;
var a:integer;
begin
  for a:=0 to max_druzyn do
      wczytajdruzyne(a,listyplikow[3][druzyna[a].numerplikunaliscie]);
  sa_juz_wczytane_druzyny:=true;
end;

procedure TForm1.nowyteren;
begin
log('Tworzenie nowego terenu');
{to co jest ok:}
  pokaz_wczytywanie(Logo_Tworzenieterenu);

  if FileExists('Terrains\temp.tmp') then DeleteFile('Terrains\temp.tmp');
  czyscteren;

{wciaz do sprawdzenia:}
  teren.width:=unitmenuglowne.ustawienia_terenu.width;
  teren.height:=unitmenuglowne.ustawienia_terenu.height;
log('Wymiary tworzonego terenu: X='+l2t(teren.width,0)+', Y='+l2t(teren.height,0));
log('Ustawianie danych terenu');
  ustaw_dane_terenu;
  ustaw_parametry_nieba;
  wczytaj_scenariusz(listyplikow[4][menuscen.wybrany]);
  poprawustawienianieba_powczytaniu;
  rysujteren(teren.width,teren.height);
  //czyscteren;
//  ustaw_dane_terenu;
log('Dodawanie spodu maski terenu');
  popraw_dol_maski_terenu;
  tryb_misji.wlaczony:=false;

//  wczytaj_misje('chuj2');

  inicjujfale(1+teren.width div fal_zoomx);
  bron.sterowanie:=-1;
  mysz.dx:=0;
  mysz.dy:=0;
  jest_juz_gra:=true;
  wroc_do_menu:=0;
log('Zakonczenie tworzenia terenu');
end;

procedure TForm1.nowyteren_wczytaj(nazwa:string);
begin
log('Tworzenie nowego terenu');
{to co jest ok:}
  pokaz_wczytywanie(Logo_Tworzenieterenu);

  if FileExists('Terrains\temp.tmp') then DeleteFile('Terrains\temp.tmp');
  czyscteren;

{wciaz do sprawdzenia:}
  teren.width:=unitmenuglowne.ustawienia_terenu.width;
  teren.height:=unitmenuglowne.ustawienia_terenu.height;
log('Wymiary tworzonego terenu: X='+l2t(teren.width,0)+', Y='+l2t(teren.height,0));
log('Ustawianie danych terenu');
  ustaw_dane_terenu;
  wczytaj_scenariusz(listyplikow[4][menuscen.wybrany]);
  poprawustawienianieba_powczytaniu;
  //rysujteren(teren.width,teren.height);

  wczytaj_teren_z_pliku_full(nazwa,true);
  ustaw_parametry_nieba;
  warmenuuklad[16].mx:=teren.height-2;

  //czyscteren;
//  ustaw_dane_terenu;
log('Dodawanie spodu maski terenu');
  popraw_dol_maski_terenu;
  tryb_misji.wlaczony:=false;

//  wczytaj_misje('chuj2');

  inicjujfale(1+teren.width div fal_zoomx);
  bron.sterowanie:=-1;
  jest_juz_gra:=true;
  wroc_do_menu:=0;
log('Zakonczenie tworzenia terenu');
end;

procedure TForm1.nowyteren_wczytaj_misja(nazwa:string);
begin
log('Tworzenie nowego terenu');
{to co jest ok:}
  pokaz_wczytywanie(Logo_Tworzenieterenu);

  if FileExists('Terrains\temp.tmp') then DeleteFile('Terrains\temp.tmp');
  czyscteren;

{wciaz do sprawdzenia:}
  teren.width:=unitmenuglowne.ustawienia_terenu.width;
  teren.height:=unitmenuglowne.ustawienia_terenu.height;
log('Wymiary tworzonego terenu: X='+l2t(teren.width,0)+', Y='+l2t(teren.height,0));
log('Ustawianie danych terenu');
  ustaw_dane_terenu;
  wczytaj_scenariusz(listyplikow[4][menuscen.wybrany]);
  //rysujteren(teren.width,teren.height);

  bron.sterowanie:=-1;

  wczytaj_misje(nazwa);
  wczytaj_teren_z_pliku_full(tryb_misji.wybranyteren,false);
  ustaw_parametry_nieba;
  poprawustawienianieba_powczytaniu;
  warmenuuklad[16].mx:=teren.height-2;

  //czyscteren;
//  ustaw_dane_terenu;
log('Dodawanie spodu maski terenu');
  popraw_dol_maski_terenu;

//  wczytaj_misje('chuj2');

  inicjujfale(1+teren.width div fal_zoomx);
  jest_juz_gra:=true;
  wroc_do_menu:=0;
log('Zakonczenie tworzenia terenu');
end;

procedure Tform1.stdkfg;
var a:integer;
begin
log('Ustawienie konfiguracji standardowej');
with kfg do begin
     calkiem_bez_dzwiekow:=false;
     calkiem_bez_muzyki:=false;

     glosnosc:=100;
     jest_dzwiek:=true;

     glosnoscmuzyki:=1;
     jest_muzyka:=true;

     glebokosc_tekstur:=0;

     glos_zlego_pana:=true;

     jaki_kursor:=0;
     odblaski:=true;
     wybuchydymy:=true;
     krew_mieso_zostawia_slady:=true;
     chowaj_liczniki:=true;

     pokazuj_info:=true;
     wskazniki_kolesi:=true;

     swiatla:=true;
     trzesienie:=true;

     dymki_kolesi:=2;
     
     efekty_soczewki:=true;

     detale:=5;
     sterowanie:=0;
     
     with ekran do begin
        width:=640;
        height:=480;
        bitdepth:=32;
        antialias:=true;
        dithering:=true;
        vsync:=true;
        windowed:=true;
        buffers:=1;
     end;
end;
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
klawisze[26]:=DIK_RBRACKET;  {Rysowanie: nastÍpna tekstura/kolor}
klawisze[27]:=DIK_MINUS;     {Rysowanie: zmniejsz pÍdzel}
klawisze[28]:=DIK_EQUALS;    {Rysowanie: zwiÍksz pÍdzel}
klawisze[29]:=DIK_APOSTROPHE;{Rysowanie: rysuj maskÍ/teren}
klawisze[30]:=DIK_BACKSLASH; {Rysowanie: pokaø maskÍ/teren}

with ustawienia_terenu do begin
    width:=640;
    height:=480;
    podloze:=true;
    obiekty:=true;
    przedmioty:=true;
    miny:=true;
    nazwaterenu:='';
end;
with druzynymenu do begin
    lecatezzgory:=true;
    wybrana:=0;
    wejsciewybrane:=0;
    ilewejsc:=0;
    wejscieruszane:=0;
end;
with ekran do begin
     pokazuj_wyniki:=true;
     px:=0;
     py:=0;
     menux:=0;
     menu_widoczne:=1;
end;
mysz.wyglad:=0;
with bron do begin
     wybrana:=23;
     kat:=0;
     sila:=20;
     tryb:=0;
     przenoszenie:=false;
     glownytryb:=0;
     sterowanie:=-1;
     for a:=0 to 9 do ulubiona[a]:=a+1;
     info_o_kolesiu:=-1;
end;
with gracz do begin
     pkt:=0;
     trupow:=0;
     _pkt:=-1;
     _trupow:=-1;
     kombo_licznik:=0;
     czas_dzialania_kombo:=0;
     ostatnie_kombo:=0;
     max_kombo:=0;
     czas:=0;
     imie:=domyslne_imie;

     pkt_pacz:=0;

     punktyglobalne:=0;
     trupyglobalne:=0;
     paczkiglobalne:=0;
     punktyglobalne_od:=0;
     trupyglobalne_od:=0;
     paczkiglobalne_od:=0;

     globalniebylogier:=0;
end;
with warunki do begin
     agresja:=4;
     walka_ze_swoimi:=false;
     walka_bez_powodu:=true;
     zwierzeta_same:=true;
     pauza:=false;
     chmurki:=true;
     grawitacja:=1;
     czestpaczek:=3;
     paczkidowolnie:=true;
end;
with dzwieki_ciagle do begin
     ogien:=false;
     deszcz:=false;
end;
with tultip do begin
     x:=0;
     y:=0;
     tekst:='';
     czas:=0;
end;
for a:=0 to max_napis do
  with napis[a] do begin
     x:=0;
     y:=0;
     tekst:='';
     czas:=0;
  end;
with napiswrogu do begin
     tekst:='';
     czas:=0;
end;
with rysowanie do begin
     kolor:=$FF008000;
     twardosc:=3;
     rozmiar:=50;
     ziarna:=20;
     corobi:=1;
     odwrocony:=false;
     ztylu:=false;
     odleglosci:=10;
     dlugosc:=1;
     cien.kolorg:=$30A010;
     cien.kolord:=$603015;
     cien.efg:=1;
     cien.efd:=2;
end;
with rysowanie do begin
     kolor:= $FF000000 or
                   (byte(rysmenuuklad[0][0].wartosc and $FF) shl 16) or
                   (byte(rysmenuuklad[0][3].wartosc and $FF) shl 8) or
                   byte(rysmenuuklad[0][6].wartosc and $FF);
     twardosc:=rysmenuuklad[0][1].wartosc; rysmenuuklad[1][1].wartosc:=rysmenuuklad[0][1].wartosc; rysmenuuklad[2][1].wartosc:=rysmenuuklad[0][1].wartosc;
     rozmiar:=rysmenuuklad[0][2].wartosc; rysmenuuklad[1][2].wartosc:=rysmenuuklad[0][2].wartosc;
     ziarna:=rysmenuuklad[0][4].wartosc;
     ksztaltpedzla:=rysmenuuklad[0][5].wartosc; rysmenuuklad[1][5].wartosc:=rysmenuuklad[0][5].wartosc;
     ztylu:=boolean(rysmenuuklad[0][8].wartosc); rysmenuuklad[1][8].wartosc:=rysmenuuklad[0][8].wartosc; rysmenuuklad[2][9].wartosc:=rysmenuuklad[0][8].wartosc;
     maskowanie:=rysmenuuklad[0][7].wartosc; rysmenuuklad[1][7].wartosc:=rysmenuuklad[0][7].wartosc; rysmenuuklad[2][8].wartosc:=rysmenuuklad[0][7].wartosc;
end;

for a:=0 to max_druzyn do druzyna[a].numerplikunaliscie:=0;

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

menumisje.wybrana:=0;
menumisje.listax:=0;

menutereny.wybrany:=0;
menutereny.listax:=0;

menuscen.wybrany:=0;
menuscen.listax:=0;

wejscia[0].czest:=5;
wejscia[0].proc:=70;
wczytaj_kfg;
end;

procedure TForm1.zliczSkonczoneMisje;
var a:integer;
begin
log('Zliczanie skonczonych misji');
  menumisje.ileskonczonych:=0;
  for a:=0 to high(skonczonemisje) do
      if skonczonemisje[a] then inc(menumisje.ileskonczonych);
log('Skonczonych misji= '+l2t(menumisje.ileskonczonych,0)+', wszystkich= '+l2t(length(skonczonemisje),0));
end;

procedure TForm1.wypelnlistyplikow;
var
sr:TSearchRec;
FileAttrs,a:Integer;
tmp:TBitmapEx;

  procedure wypeln_obr(gdzie,co:string; ktora:integer);
  begin
  setlength(listyplikow[ktora],0);
  FileAttrs := faReadOnly + faHidden + faSysFile + faArchive;

  if FindFirst(gdzie+co, FileAttrs, sr) = 0 then begin
     repeat
        if (sr.Attr and FileAttrs) = sr.Attr then begin
           try
              log('  Znaleziona bitmapa: '+sr.Name+', sprawdzanie czy jest prawidlowa');
              tmp:=TBitmapEx.Create;
              tmp.LoadFromFile(gdzie+sr.name);
              log('  Prawidlowa - dodawanie bitmapy do listy: '+sr.Name);
              setlength(listyplikow[ktora],length(listyplikow[ktora])+1);
              sr.name:=ExtractFileName(sr.name);
              listyplikow[ktora][high(listyplikow[ktora])]:=sr.Name;

              if tmp<>nil then begin
                 tmp.Free;
                 tmp:=nil;
              end;
           except
              log('  NIEPRAWIDLOWA bitmapa, nie zostanie dodana do listy: '+sr.Name);
           end;
        end;
     until FindNext(sr) <> 0;
     FindClose(sr);
  end;
  end;

  procedure wypeln_muz(gdzie,co:string; ktora:integer);
  var w:string;
  begin
  setlength(listyplikow[ktora],0);
  FileAttrs := faReadOnly + faHidden + faSysFile + faArchive;

  if FindFirst(gdzie+co, FileAttrs, sr) = 0 then begin
     repeat
        if (sr.Attr and FileAttrs) = sr.Attr then begin
           W:=uppercase(ExtractFileExt(gdzie+sr.name));
           //w:=uppercase(copy(gdzie+sr.name,length(gdzie+sr.name)-3,4));
           if (w='.MP3') or (w='.OGG') or
              (w='.MOD') or (w='.S3M') or (w='.XM') or (w='.IT') then begin
              log('  Znaleziony plik z dobrym rozszerzeniem: '+sr.Name);
              setlength(listyplikow[ktora],length(listyplikow[ktora])+1);
              listyplikow[ktora][high(listyplikow[ktora])]:=sr.Name;
           end;
        end;
     until FindNext(sr) <> 0;
     FindClose(sr);
  end;
  end;

  procedure wypeln_s3p(gdzie,co:string; ktora:integer);
  var w:string;
  begin
  setlength(listyplikow[ktora],0);
  FileAttrs := faReadOnly + faHidden + faSysFile + faArchive;

  if FindFirst(gdzie+co, FileAttrs, sr) = 0 then begin
     repeat
        if (sr.Attr and FileAttrs) = sr.Attr then begin
           W:=sr.name;
           //w:=uppercase(copy(gdzie+sr.name,length(gdzie+sr.name)-3,4));
           delete(w,length(w)-3,4);
           {if (w<>'..') and (w<>'.') then begin}
              log('  Dodawanie zestawu postaci do listy: '+sr.Name);
              setlength(listyplikow[ktora],length(listyplikow[ktora])+1);
              listyplikow[ktora][high(listyplikow[ktora])]:=w;
              setlength(rozpakowanedruzyny,length(rozpakowanedruzyny)+1);
              rozpakowanedruzyny[high(rozpakowanedruzyny)]:=false;
           {end;}
        end;
     until FindNext(sr) <> 0;
     FindClose(sr);
  end;
  end;

  procedure wypeln_s3sce(gdzie,co:string; ktora:integer);
  var w:string;
  begin
  setlength(listyplikow[ktora],0);
  FileAttrs := faReadOnly + faHidden + faSysFile + faArchive;

  if FindFirst(gdzie+co, FileAttrs, sr) = 0 then begin
     repeat
        if (sr.Attr and FileAttrs) = sr.Attr then begin
           W:=sr.name;
           //w:=uppercase(copy(gdzie+sr.name,length(gdzie+sr.name)-3,4));
           if (w<>'..') and (w<>'.') then begin
              log('  Dodawanie scenariusza do listy: '+sr.Name);
              setlength(listyplikow[ktora],length(listyplikow[ktora])+1);
              delete(w,length(w)-5,6);
              listyplikow[ktora][high(listyplikow[ktora])]:=w;
           end;
        end;
     until FindNext(sr) <> 0;
     FindClose(sr);
  end;
  end;

  procedure wypeln_s3mis(gdzie,co:string; ktora:integer);
  var w:string; a:integer;
  begin
  setlength(listyplikow[ktora],0);
  FileAttrs := faReadOnly + faHidden + faSysFile + faArchive;

  if FindFirst(gdzie+co, FileAttrs, sr) = 0 then begin
     repeat
        if (sr.Attr and FileAttrs) = sr.Attr then begin
           W:=sr.name;
           //w:=uppercase(copy(gdzie+sr.name,length(gdzie+sr.name)-3,4));
           if (w<>'..') and (w<>'.') then begin
              log('  Dodawanie misji do listy: '+sr.Name);
              setlength(listyplikow[ktora],length(listyplikow[ktora])+1);
              delete(w,length(w)-5,6);
              listyplikow[ktora][high(listyplikow[ktora])]:=w;
           end;
        end;
     until FindNext(sr) <> 0;
     FindClose(sr);
  end;

  {lista skonczonych misji:}
  setlength(skonczonemisje, length(listyplikow[ktora]) );
  for a:=0 to high(skonczonemisje) do skonczonemisje[a]:=false;
  end;

begin
for a:=low(listyplikow) to high(listyplikow) do setlength(listyplikow[a],0);
log('Wypelnienie list plikow:');
log('Wypelnianie listy plikow (obiekty)');
wypeln_obr('Objects\','*.tga',0);
log('Wypelnianie listy plikow (tekstury)');
wypeln_obr('Textures\','*.tga',1);
log('Wypelnianie listy plikow (muzyka)');
wypeln_muz('Music\','*.*',2);
log('Wypelnianie listy plikow (druzyny)');
wypeln_s3p('Teams\','*.s3p',3);
log('Wypelnianie listy plikow (scenariusze)');
wypeln_s3sce('Scenarios\','*.s3sce',4);
if menuscen.wybrany>high(listyplikow[4]) then menuscen.wybrany:=0;
log('Wypelnianie listy plikow (misje)');
wypeln_s3mis('Missions\','*.S3Mis',5);
if menumisje.wybrana>high(listyplikow[5]) then menumisje.wybrana:=0;
unitmenuglowne.guziki[6,0].mx:=high(listyplikow[5]) div (unitmenuglowne.misjeily+1);
unitmenuglowne.guziki[1,6].mx:=high(listyplikow[4]) div (unitmenuglowne.scenily+1);

rysmenuuklad[2][3].mx:=high(listyplikow[0]); rysmenuuklad[2][4].mx:=rysmenuuklad[2][3].mx;
rysmenuuklad[1][3].mx:=high(listyplikow[1]); rysmenuuklad[1][4].mx:=rysmenuuklad[1][3].mx;
end;

procedure TForm1.wypelnlisteterenow;
var
sr:TSearchRec;
FileAttrs,a:Integer;
tmp:TBitmapEx;

  procedure wypeln_s3t(gdzie,co:string; ktora:integer);
  var w:string;
  begin
  setlength(listyplikow[ktora],0);
  FileAttrs := faReadOnly + faHidden + faSysFile + faArchive;

  if FindFirst(gdzie+co, FileAttrs, sr) = 0 then begin
     repeat
        if (sr.Attr and FileAttrs) = sr.Attr then begin
           W:=sr.name;
           //w:=uppercase(copy(gdzie+sr.name,length(gdzie+sr.name)-3,4));
           delete(w,length(w)-5,6);
           {if (w<>'..') and (w<>'.') then begin}
              log('  Dodawanie terenu do listy: '+sr.Name);
              setlength(listyplikow[ktora],length(listyplikow[ktora])+1);
              listyplikow[ktora][high(listyplikow[ktora])]:=w;
              setlength(rozpakowanedruzyny,length(rozpakowanedruzyny)+1);
              rozpakowanedruzyny[high(rozpakowanedruzyny)]:=false;
           {end;}
        end;
     until FindNext(sr) <> 0;
     FindClose(sr);
  end;
  end;


begin
setlength(listyplikow[6],0);
log('Wypelnianie listy plikow (tereny)');
wypeln_s3t('Terrains\','*.S3ter',6);
if menumisje.wybrana>high(listyplikow[5]) then menumisje.wybrana:=0;
unitmenuglowne.guziki[7,0].mx:=high(listyplikow[6]) div (unitmenuglowne.terenyily+1);
unitmenuglowne.guziki[3,0].mx:=unitmenuglowne.guziki[7,0].mx;
end;


procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var a:integer;
begin
case glowne_co_widac of
  0:begin {--------------------------------MENU--------------------------------}
    if (key=vk_escape) and (jest_juz_gra) then begin
       MenuGlowneZakoncz;
       WczytajDruzynyJesliZmienione;
       GraZacznij;
    end;
    if (polewpisu.aktywne) then begin
       if (key=vk_left) and (polewpisu.kursorx>1) then dec(polewpisu.kursorx);
       if (key=vk_right) and (polewpisu.kursorx<length(polewpisu.cozmieniac^)+1) then inc(polewpisu.kursorx);
    end;
  end;
  1:begin {--------------------------------GRA---------------------------------}
    if key=VK_F1 then begin
       inc(menju.kategoria);
       if (menju.kategoria>high(menubroniekategorie)) then menju.kategoria:=0;
    end;

    if key=VK_F2 then begin
       a:=0;
       while (a<=high(menubronie[menju.kategoria])) and (menubronie[menju.kategoria,a]<>bron.wybrana) do inc(a);
       if a>high(menubronie[menju.kategoria]) then bron.wybrana:=menubronie[menju.kategoria,0]
          else begin
             if (a<high(menubronie[menju.kategoria])) and (menubronie[menju.kategoria,a+1]<>-1) then
                bron.wybrana:=menubronie[menju.kategoria,a+1]
                else bron.wybrana:=menubronie[menju.kategoria,0];
          end;
       zmienobrazkiikonbroni;
    end;

    if (key=VK_F3) and
       (not (tryb_misji.wlaczony and not tryb_misji.zmianawarunkow)) then begin
       inc(warunki.typ_wody);
       if warunki.typ_wody>=max_wod+1 then warunki.typ_wody:=0;
       popraw_dol_maski_terenu;
    end;
    if key=VK_F7 then begin
       inc(kfg.jaki_kursor);
       if kfg.jaki_kursor>=3 then kfg.jaki_kursor:=0;
    end;
    if key=VK_F8 then begin
       if tryb_misji.wlaczony then begin
          if not tryb_misji.wstrzymana then tryb_misji.wstrzymana:=true
             else tryb_misji.wylaczanie_wstrzymania:=true;
       end;
    end;
    if key=VK_F12 then begin
       ekran.pokazuj_wyniki:=not ekran.pokazuj_wyniki;
    end;

    if key=vk_escape then begin
       GraZakoncz;
       MenuGlowneZacznij(wroc_do_menu);
    end;
  end;
  2:begin {-------------------------------AUTORZY------------------------------}
    if (key=vk_escape) then begin
       zakoncz_autorzy;
       MenuGlowneZacznij(0);
    end;
  end;
end;


end;

procedure TForm1.FormResize(Sender: TObject);
begin
ekran.width:=form1.ClientWidth;
ekran.height:=form1.ClientHeight;
mysz.ekranx:={form1.ClientRect.Left+form1.Left+{4+}form1.BoundsRect.left+4;
mysz.ekrany:=form1.ClientRect.Top+form1.top+23;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var a:integer;
begin
log('Zamykanie programu');

 zapisz_kfg;
 for a:=1 to ilemiejsc_lokalnie do
     listarekordow_lokalna[a]:=listarekordow_lokalna_tmp[a];
 zapisz_rekordy_lokalne;

 wyjscie_z_programu:=true;
 PowerTimer1.MayRender:= False;
 PowerTimer1.MayProcess:= False;
 form1.zegarek.Enabled:=false;
 FreeDirectDraw;
 if FileExists('Terrains\temp.tmp.s3t') then DeleteFile('Terrains\temp.tmp.s3t');
 zakonczmuzyke;

log('Finalizacja grafiki');
 PowerDraw1.DoneDevice();
 PowerDraw1.Finalize();

if not kfg.calkiem_bez_dzwiekow then begin
   log('Zatrzymywanie dzwiekow');
    for a:=0 to dzw_bronie_strzaly.Count-1 do dzw_bronie_strzaly.Item[a].Stop;
    for a:=0 to dzw_wybuchy.Count-1 do dzw_wybuchy.Item[a].Stop;
    for a:=0 to dzw_bronie_inne.Count-1 do dzw_bronie_inne.Item[a].Stop;
    for a:=0 to dzw_rozne.Count-1 do dzw_rozne.Item[a].Stop;
    for a:=0 to dzw_zwierzaki.Count-1 do dzw_zwierzaki.Item[a].Stop;
    for a:=0 to dzw_zly_pan.Count-1 do dzw_zly_pan.Item[a].Stop;
end;
{ for b:=1 to max_druzyn do
     for a:=0 to druzyna[b].dzwieki.Items.Count-1 do druzyna[b].dzwieki.Items[a].Stop;
}
log('Konczenie dzialania aplikacji');
 Application.Terminate;
 exit;
end;

procedure TForm1.wczytajobrazki;
begin
  robsprajt(obr.font,'Graphics\czcionka2.tga',10,13);
  robsprajt(obr.font2,'Graphics\czcionkadymki.tga',8,10);

  robsprajt(obr.pocisk[-1],'Graphics\pocisk0.tga',1,30);
  robsprajt(obr.pocisk[0],'Graphics\pocisk1.tga',12,12);
  robsprajt(obr.pocisk[1],'Graphics\pocisk2.tga',12,12);
  robsprajt(obr.pocisk[2],'Graphics\pocisk3.tga',16,16);
  robsprajt(obr.pocisk[3],'Graphics\pocisk4.tga',8,8);
  robsprajt(obr.pocisk[4],'Graphics\napalm2.tga',50,50);
  robsprajt(obr.pocisk[5],'Graphics\napalm4.tga',50,50);
  robsprajt(obr.pocisk[6],'Graphics\pociskD.tga',15,15);
  robsprajt(obr.pocisk[7],'Graphics\pocisk7.tga',16,16);
  {pocisk[8] - kula ognista. animacja napalmu}
  robsprajt(obr.pocisk[9],'Graphics\pocisk8.tga',12,12);
  robsprajt(obr.pocisk[10],'Graphics\pocisk9.tga',20,20);
  robsprajt(obr.pocisk[11],'Graphics\pociskA.tga',40,40);
  robsprajt(obr.pocisk[12],'Graphics\pociskB.tga',14,14);
  robsprajt(obr.pocisk[13],'Graphics\chmura1.tga',60,60,32);
  robsprajt(obr.pocisk[14],'Graphics\pociskE.tga',12,12);
  robsprajt(obr.pocisk[15],'Graphics\molotov.tga',14,14);
  robsprajt(obr.pocisk[16],'Graphics\chmura2.tga',60,60,32);
  robsprajt(obr.pocisk[17],'Graphics\pociskC.tga',14,14);
  robsprajt(obr.pocisk[18],'Graphics\pociskF.tga',22,22);
  robsprajt(obr.pocisk[19],'Graphics\pociskG.tga',12,12);
  robsprajt(obr.pocisk[20],'Graphics\pociskH.tga',19,19);
  robsprajt(obr.pocisk[21],'Graphics\pociskI.tga',15,15);
  robsprajt(obr.pocisk[22],'Graphics\pociskJ.tga',15,15);
  robsprajt(obr.pocisk[23],'Graphics\pociskK.tga',13,13);
  robsprajt(obr.pocisk[24],'Graphics\bomba.tga',28,45);

  robsprajt(obr.mina[0],'Graphics\mina0.tga',12,12);
  robsprajt(obr.mina[1],'Graphics\mina1.tga',12,12);
  robsprajt(obr.mina[2],'Graphics\minawodna.tga',13,13);
  robsprajt(obr.mina[3],'Graphics\minawhak.tga',9,9);
  robsprajt(obr.mina[4],'Graphics\beczka.tga',23,23);

  robsprajt(obr.kursor,'Graphics\kursor.tga',51,51);
  robsprajt(obr.celownik,'Graphics\celownik.tga',2,30);
  robsprajt(obr.wskaznik,'Graphics\wskaznik1.tga',7,7);
  robsprajt(obr.wskaznik2,'Graphics\wskaznik2.tga',-1,-1);
  robsprajt(obr.kurpodb,'Graphics\kursor-podb.tga',14,14);
  robsprajt(obr.znakteam,'Graphics\znakteam.tga',-1,-1);
  robsprajt(obr.syf[0,0],'Graphics\krewr1.tga',4,4);
  robsprajt(obr.syf[0,1],'Graphics\krewr2.tga',3,3);
  robsprajt(obr.syf[0,2],'Graphics\krewr3.tga',4,4);
  robsprajt(obr.syf[0,3],'Graphics\krewr4.tga',5,5);
  robsprajt(obr.syf[0,4],'Graphics\krewr5.tga',6,6);
  robsprajt(obr.syf[1,0],'Graphics\syf1.tga',3,6);
  robsprajt(obr.syf[1,1],'Graphics\syf2.tga',3,3);
  robsprajt(obr.syf[1,2],'Graphics\syf3.tga',4,4);
  robsprajt(obr.syf[1,3],'Graphics\syf4.tga',6,6);
  robsprajt(obr.syf[1,4],'Graphics\syf5.tga',7,7);
  robsprajt(obr.syf[2,0],'Graphics\chlup1.tga',-1,-1);
  robsprajt(obr.syf[2,1],'Graphics\chlup2.tga',-1,-1);
  robsprajt(obr.syf[2,2],'Graphics\chlup3.tga',-1,-1);
  robsprajt(obr.syf[2,3],'Graphics\chlup4.tga',-1,-1);
  robsprajt(obr.syf[2,4],'Graphics\chlup5.tga',-1,-1);
  robsprajt(obr.syf[3,0],'Graphics\iskra.tga',3,16);

  robsprajt(obr.smieci[0],'Graphics\pilka1.tga',-1,-2);
  robsprajt(obr.smieci[1],'Graphics\pilka2.tga',-1,-2);
  robsprajt(obr.smieci[2],'Graphics\jablko.tga',-1,-2);
  robsprajt(obr.smieci[3],'Graphics\kamol1.tga',-1,-2);
  robsprajt(obr.smieci[4],'Graphics\cegla.tga',-1,-2);
  robsprajt(obr.smieci[5],'Graphics\sztylet.tga',-1,-2);
  robsprajt(obr.smieci[6],'Graphics\tasak.tga',-1,-2);
  robsprajt(obr.smieci[7],'Graphics\smiecikarabin.tga',22,22);

  robsprajt(obr.wybuchdym[0,0],'Graphics\wybuch1.tga',60,60);
  robsprajt(obr.wybuchdym[0,1],'Graphics\wybuch2.tga',64,64);
  robsprajt(obr.wybuchdym[0,2],'Graphics\wybuch3.tga',64,64);
  robsprajt(obr.wybuchdym[0,3],'Graphics\wybuch4.tga',64,64);
  robsprajt(obr.wybuchdym[0,4],'Graphics\wybuch5.tga',64,64);
  robsprajt(obr.wybuchdym[0,5],'Graphics\wybuch6.tga',64,64);
  robsprajt(obr.wybuchdym[1,0],'Graphics\dym1.tga',28,28);
  robsprajt(obr.wybuchdym[1,1],'Graphics\dym2.tga',16,16);
  robsprajt(obr.wybuchdym[1,2],'Graphics\plomienrakiet.tga',16,16);
  robsprajt(obr.wybuchdym[1,3],'Graphics\dym3.tga',40,40);
  robsprajt(obr.wybuchdym[2,0],'Graphics\swiatlo1.tga',160,160);
  robsprajt(obr.wybuchdym[2,1],'Graphics\swiatlo2.tga',160,160);
  robsprajt(obr.wybuchdym[3,0],'Graphics\latarka.tga',200,200,32);
  robsprajt(obr.wybuchdym[4,0],'Graphics\krew.tga',36,36);

  robsprajt(obr.przedm[0],'Graphics\przedm-apteczka.tga',13,12);
  robsprajt(obr.przedm[1],'Graphics\przedm-granat.tga',13,12);
  robsprajt(obr.przedm[2],'Graphics\przedm-bomba.tga',13,12);
  robsprajt(obr.przedm[3],'Graphics\przedm-karabin.tga',13,12);
  robsprajt(obr.przedm[4],'Graphics\przedm-dynamit.tga',13,12);
  robsprajt(obr.przedm[5],'Graphics\przedm-tlen.tga',13,12);
  robsprajt(obr.przedm[6],'Graphics\przedm-predator.tga',13,12);
  robsprajt(obr.przedm[7],'Graphics\przedm-paczkagracza.tga',13,12);

  robsprajt(obr.broniekolesi[3],'Graphics\minigan.tga',34,9);
  {obr.broniekolesi[3].ofsx:=5;
  obr.broniekolesi[3].ofsy:=1;}

  robsprajt(obr.energia,'Graphics\energia.tga',30,4);

  robsprajt(obr.bombel,'Graphics\bombel.tga',7,7);

  robsprajt(obr.deszcz[0],'Graphics\deszczm.tga',2,100);
  robsprajt(obr.deszcz[1],'Graphics\sniegm.tga',10,10);
  robsprajt(obr.chmurka,'Graphics\chmurka1.tga',256,128,32);

  robsprajt(obr.snajper,'Graphics\snajper.tga',-1,-1,32);

  robsprajt(obr.slonce,'Graphics\slonce.tga',60,60);
  robsprajt(obr.ksiezyc,'Graphics\ksiezyc.tga',60,60);
  robsprajt(obr.gwiazda,'Graphics\gwiazda.tga',9,9);

  robsprajt(obr.ciezkie[0],'Graphics\kowadlo.tga',45,45);
  robsprajt(obr.ciezkie[1],'Graphics\kamol.tga',45,45);
  robsprajt(obr.ciezkie[2],'Graphics\sejf.tga',45,45);
  robsprajt(obr.ciezkie[3],'Graphics\fortepian.tga',45,45);

  robsprajt(obr.pila,'Graphics\pila.tga',100,43);
  robsprajt(obr.mlotek,'Graphics\mlotek1.tga',150,65);
  robsprajt(obr.wentylator,'Graphics\wentylator.tga',80,80);

  robsprajt(obr.wejscie,'Graphics\wejscia.tga',40,40);

  robsprajt(obr.aniikonyp,'Graphics\ikony\pojedyncze.tga',40,40);
  robsprajt(obr.aniikony,'Graphics\ikony\'+l2t(bron.wybrana,2)+'.tga',40,40);
  obr.aniikony_wczytana:=bron.wybrana;

  robsprajt(obr.flaga,'Graphics\flaga.tga',19,15);
  robsprajt(obr.flagaslup,'Graphics\flagaslupek.tga',-1,-1);

  robsprajt(obr.menud,'Graphics\menud1.tga',640,76);
  robsprajt(obr.menudprawo,'Graphics\menudprawo.tga',512,76);
  robsprajt(obr.menukratka,'Graphics\menukratka22x22.tga',22,22);
  robsprajt(obr.menusuwaktlo,'Graphics\menusuw1.tga',-1,-1,32);
  robsprajt(obr.menusuwak,'Graphics\menusuwp1.tga',-1,-1);
  robsprajt(obr.menusuwakwyp,'Graphics\menusuw2.tga',-1,-1,32);
  robsprajt(obr.menuikony,'Graphics\ikomenu.tga',-1,-2);
  robsprajt(obr.menuikonyw,'Graphics\ikomenuwar.tga',-1,-2);
  robsprajt(obr.menuikonydruz,'Graphics\ikomenudruz.tga',-1,-2);
  robsprajt(obr.ikowybmenu,'Graphics\ikowybmenu.tga',40,15);

  robsprajt(obr.ryscien,'Graphics\ryscien.tga',-1,-2);

  robsprajt(obr.zwierzaki[0,0],'Graphics\netoper.tga',12,12);
  robsprajt(obr.zwierzaki[0,1],'Graphics\netoper-s.tga',12,12);
  robsprajt(druzyna[-1].mieso[0],'Graphics\netoper-t.tga',12,12);

  robsprajt(obr.zwierzaki[1,0],'Graphics\rybka1.tga',12,12);
  robsprajt(druzyna[-1].mieso[1],'Graphics\rybka1-t.tga',12,12);

  robsprajt(obr.zwierzaki[2,0],'Graphics\motyl.tga',10,10);
  robsprajt(obr.zwierzaki[2,1],'Graphics\motyl.tga',10,10);
  robsprajt(druzyna[-1].mieso[2],'Graphics\motyl-t.tga',8,8);

  robsprajt(obr.zwierzaki[3,0],'Graphics\wegorz.tga',15,15);
  robsprajt(druzyna[-1].mieso[3],'Graphics\wegorz-t.tga',15,15);

  robsprajt(obr.zwierzaki[4,0],'Graphics\golab.tga',14,14);
  robsprajt(obr.zwierzaki[4,1],'Graphics\golab-s.tga',14,14);
  robsprajt(druzyna[-1].mieso[4],'Graphics\golab-t.tga',14,14);

  robsprajt(obr.zwierzaki[5,0],'Graphics\ryba3.tga',11,11);
  robsprajt(druzyna[-1].mieso[5],'Graphics\ryba3-t.tga',11,11);

  robsprajt(obr.flara,'Graphics\flara.tga',64,64);

end;

procedure TForm1.zmienobrazkiikonbroni;
begin
if obr.aniikony_wczytana<>bron.wybrana then begin
  if obr.aniikony.surf<>nil then begin
     obr.aniikony.surf.Free;
     obr.aniikony.surf:=nil;
  end;
  robsprajt(obr.aniikony,'Graphics\ikony\'+l2t(bron.wybrana,2)+'.tga',40,40);
  obr.aniikony_wczytana:=bron.wybrana;
end;
end;

procedure TForm1.FreeDirectDraw;
var a,b:integer;
begin
log('Freedirectdraw - finalizacja grafiki');
  if obr.font.surf<>nil then begin
     obr.font.surf.Free;
     obr.font.surf:=nil;
  end;
  for a:=low(obr.pocisk) to high(obr.pocisk) do obr.pocisk[a].surf.Free;
  for a:=low(obr.mina) to high(obr.mina) do obr.mina[a].surf.Free;
  for b:=low(obr.syf) to high(obr.syf) do
      for a:=low(obr.syf[b]) to high(obr.syf[b]) do obr.syf[b,a].surf.Free;
  for a:=low(obr.przedm) to high(obr.przedm) do obr.przedm[a].surf.Free;
  for a:=low(obr.broniekolesi) to high(obr.broniekolesi) do obr.broniekolesi[a].surf.Free;
  obr.kursor.surf.Free;
  obr.celownik.surf.Free;
  obr.wskaznik.surf.Free;
  obr.energia.surf.Free;
  obr.bombel.surf.Free;

  obr.teren.surf.Free;
//  obr.tlo.surf.Free;

  for b:=low(obr.wybuchdym) to high(obr.wybuchdym) do
      for a:=low(obr.wybuchdym[b]) to high(obr.wybuchdym[b]) do obr.wybuchdym[b,a].surf.Free;

  {jeszcze mieso i druzyny}
end;

procedure TForm1.zegarekTimer(Sender: TObject);
begin
if wyjscie_z_programu then exit;
inc(gracz.czas);
if tryb_misji.wlaczony and tryb_misji.jest_czas and (tryb_misji.ile_czasu>0) and not tryb_misji.wstrzymana then dec(tryb_misji.ile_czasu);
end;

procedure TForm1.PowerTimer1Process(Sender: TObject);
begin
if wyjscie_z_programu then exit;

  if ((form1.PowerInput1.mbPressed[0]>0) or (form1.PowerInput1.mbPressed[1]>0)) and
     (glowne_co_widac=1) and (mysz.y<ekran.height-ekran.menux) then begin
      mysz.gmarg:=0;
      mysz.dmarg:=ekran.height-ekran.menux-1;
  end else
  if ((form1.PowerInput1.mbPressed[0]>0) or (form1.PowerInput1.mbPressed[1]>0)) and
     (glowne_co_widac=1) and (mysz.y>=ekran.height-ekran.menux) then begin
      mysz.gmarg:=ekran.height-ekran.menux;
      mysz.dmarg:=ekran.height-1;
  end else begin
     mysz.gmarg:=0;
     mysz.dmarg:=ekran.height-1;
  end;

  mysz.x:=mysz.x+form1.PowerInput1.mDeltaX;
  mysz.y:=mysz.y+form1.PowerInput1.mDeltaY;

  if mysz.x<0 then mysz.x:=0;
  if mysz.x>form1.PowerDraw1.Width-1 then mysz.x:=form1.PowerDraw1.Width-1;

  if mysz.y<mysz.gmarg then mysz.y:=mysz.gmarg;
  if mysz.y>mysz.dmarg then mysz.y:=mysz.dmarg;

  case glowne_co_widac of
     0:begin {menu}
       MenuGlowneDzialaj;
       end;
     1:begin {gra}
       ilosc_dzwiekow_w_klatce:=0;
       glowna_gra_ruch;
       end;
     2:begin {autorzy}
       dzialaj_autorzy;
       end;
  end;

  PowerInput1.Update;
  mysz.sx:=mysz.x;
  mysz.sy:=mysz.y;

  if not kfg.calkiem_bez_muzyki then begin
      if muzyka.wlaczona and (glowne_co_widac=1) and not muzyka.Sound.IsPlaying then begin
         wylaczmuzyke;
         //form1.grajkawalek(listyplikow[2][random(length(listyplikow[2]))],false);
         graj_muzyke_w_grze(-1);
         form1.wlaczmuzyke(false);
      end;
  end;

end;

procedure TForm1.PowerTimer1Render(Sender: TObject);
begin
if wyjscie_z_programu then exit;
  case glowne_co_widac of
     0:begin {menu}
       MenuGlownePokaz;
       end;
     1:begin {gra}
       glowna_gra_pokaz;
       end;
     2:begin {autorzy}
       pokazuj_autorzy;
       end;
  end;
end;

procedure TForm1.wczytaj_wszystkie_tekstury;
begin
   Form1.pokaz_wczytywanie(Logo_wczytywanie);
   //wczytaj_druzyny;
   WczytajDruzynyJesliZmienione;
   wczytajteksture(listyplikow[1][rysmenuuklad[1][3].wartosc]);
   wczytajobiekt(listyplikow[0][rysmenuuklad[2][3].wartosc]);
end;

procedure TForm1.PowerDraw1InitDevice(Sender: TObject; var ExitCode: Integer);
begin
wczytajobrazki;
if jest_juz_gra and (glowne_co_widac=1) then begin
   wczytaj_wszystkie_tekstury
end;
end;

procedure tform1.graj_muzyke_w_grze(ktory:integer);
var a:integer;
begin
if not kfg.calkiem_bez_muzyki then begin
  if (not tryb_misji.wlaczony) or
     ((tryb_misji.wlaczony) and (tryb_misji.muzyka='')) then begin
       if ktory=-1 then ktory:=random(length(listyplikow[2]));
       grajkawalek(listyplikow[2][ktory],false);
       muzyka.ktory_kawalek_z_listy_gra:=ktory;
     end else begin
       grajkawalek(tryb_misji.muzyka,false);

       //znajdz, ktory to kawalek na liscie:
       a:=0;
       while (a<=length(listyplikow[2])-1) and (listyplikow[2][a]<>tryb_misji.muzyka) do inc(a);
       if a<=length(listyplikow[2])-1 then muzyka.ktory_kawalek_z_listy_gra:=a
                                      else muzyka.ktory_kawalek_z_listy_gra:=0;
     end;
end;
end;

procedure TForm1.AppActivate(Sender: TObject);
begin
 PowerTimer1.MayRender:= True;
 PowerTimer1.MayProcess:= True;
 if jest_juz_gra and (glowne_co_widac=1) then form1.zegarek.Enabled:=true;
 ShowCursor(false);
end;

//---------------------------------------------------------------------------
procedure TForm1.AppDeactivate(Sender: TObject);
begin
 PowerTimer1.MayRender:= False;
 PowerTimer1.MayProcess:= False;

 zegarek.Enabled:=false;
 ShowCursor(true);
end;



procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
if (glowne_co_widac=0) and (unitmenuglowne.polewpisu.aktywne) then begin
   if (key in ['0'..'9','a'..'z','A'..'Z',' ','!'..'@','['..'`','π','Ê','Í','≥','Ò','Û','ú','ü','ø','•','∆',' ','£','—','”','å','è','Ø'])
      and (length(polewpisu.cozmieniac^)<polewpisu.dlugosc) then begin
      insert(key,polewpisu.cozmieniac^,polewpisu.kursorx);
      inc(polewpisu.kursorx);
   end else
       if (key=#8) and (length(polewpisu.cozmieniac^)>0) and (polewpisu.kursorx>1) then begin
          delete(polewpisu.cozmieniac^,polewpisu.kursorx-1,1);
          dec(polewpisu.kursorx);
       end else
       if key=#13 then begin
          polewpisu.aktywne:=false;
          if polewpisu.cozmieniac = @unitmenuglowne.oto_kod_tajny then sprawdz_tajny_kod;
       end;

end;
end;

end.
