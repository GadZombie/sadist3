unit UnitMenuGlowne;

interface
uses types, vars, unitgraglowna, dialogs, forms, unit2, unitstringi, sysutils, unitpliki;

  procedure MenuGlowneDzialaj;
  procedure MenuGlownePokaz;

  procedure stworz_pole_wpisu(tytul_:string; var cozmieniac_:string; dlugosc_:integer);
  procedure dzialaj_pole_wpisu;
  procedure pokaz_pole_wpisu;

  procedure MenuGlowneZacznij(ktore:integer);
  procedure MenuGlowneZakoncz;
  procedure WczytajDruzynyJesliZmienione;

  procedure nowyogien(sx,sy,dx_,dy_:real; sz:byte; przezr:smallint;wielkosc_:integer);
  procedure ruszaj_ogien;
  procedure rysuj_ogien;

  procedure sprawdz_tajny_kod;

const
 menu_mjuzik:string[16]='..\Data\menu.ogg';
 misjeily=12; {ile plikow na liscie misji miesci sie w pionie}
 terenyily=15; {ile plikow na liscie terenow miesci sie w pionie}
 scenily=8; {ile plikow na liscie scenariuszy miesci sie w pionie}

 max_ogien:word=50;

type
  Tguzik=record
          x,y:integer;
          rx,ry:integer;
          typ:byte; { 1-suwak,2-przelacznik 1/0 }
          mn,mx,wartosc:integer;
          ikona:byte; {0:brak; 1..255}
          tt:string; {tultip}
    end;

  Togien=record
        x,y,dx,dy:real;
        jest:boolean;
        klatka,szyb,dosz:shortint;
        przezroczysty:smallint;
        wielkosc:integer; {0:normalna, >=1: w pixelach szerokosc i wysokosc}
        kat:smallint;
        end;

var
  menusy:array[-1..7] of record
       x,y:integer;
       pzoom,zoom:real;
       end=(
  {-1 ?!? }  (x:   0; y:-1000;pzoom:0.1 ),
  {0glowne}  (x: 915; y: 672; pzoom:1   ),
  {1nowy  }  (x: 315; y: 688; pzoom:1.05),
  {2opcje }  (x:1499; y: 223; pzoom:1.10),
  {3zapis }  (x: 320; y:1176; pzoom:1   ),
  {4druz  }  (x: 933; y:1172; pzoom:1.00),
  {5najw  }  (x:1509; y: 663; pzoom:1.05),
  {6misje }  (x: 334; y: 231; pzoom:1.10),
  {7odczyt}  (x: 320; y:1176; pzoom:1   )

 // {stat  }  (x:1128; y: 597; pzoom:1.50)
       );

  regiony:array[0..21] of record
       x,y,x2,y2,w,h, nm:integer;
       tt:string;
       end=(
 {szybka gra }(x: 0670; y:0509;  x2: 0847; y2:0547; nm:-4; tt:MenuGlownePodp_SzybkaGra),
 {nowa gra   }(x: 0671; y:0601;  x2: 0848; y2:0641; nm: 1; tt:MenuGlownePodp_NowaGra),
 {         ->}(x: 0536; y:0863;  x2: 0572; y2:0892; nm: 0),
 {wczytwarunk}(x: 0361; y:0846;  x2: 0525; y2:0881; nm:-9),
 {         ok}(x: 0064; y:0839;  x2: 0168; y2:0888; nm:-3),
 {->misje    }(x: 0248; y:0490;  x2: 0353; y2:0531; nm: 6),
 {         ->}(x: 0541; y:0373;  x2: 0577; y2:0400; nm: 1),
 {         ok}(x: 0079; y:0386;  x2: 0209; y2:0416; nm:-5),
 {->odczyt   }(x: 0172; y:0853;  x2: 0354; y2:0884; nm: 7),
 {zapis/odczt}(x: 0669; y:0702;  x2: 0847; y2:0738; nm: 3; tt:MenuGlownePodp_ZapisOdczyt),
 {         ok}(x: 0036; y:1346;  x2: 0176; y2:1382; nm:-6),
 {zmien nazwe}(x: 0060; y:1002;  x2: 0345; y2:1019; nm:-7),
 {         ->}(x: 0538; y:0948;  x2: 0574; y2:0978; nm: 0),
 {wyb.druz   }(x: 0667; y:0785;  x2: 0846; y2:0838; nm: 4; tt:MenuGlownePodp_WybDruzyn),
 {         ->}(x: 1161; y:0961;  x2: 1195; y2:0990; nm: 0),
 {opcje      }(x: 1001; y:0502;  x2: 1175; y2:0543; nm: 2; tt:MenuGlownePodp_Opcje),
 {         ->}(x: 1263; y:0397;  x2: 1298; y2:0425; nm: 0),
 {najwieksi  }(x: 1003; y:0589;  x2: 1179; y2:0639; nm: 5; tt:MenuGlownePodp_Najwieksi),
 { zmien imie}(x: 1455; y:0498;  x2: 1734; y2:0517; nm:-8),
 {         ->}(x: 1253; y:0833;  x2: 1288; y2:0864; nm: 0),
 {autorzy    }(x: 1002; y:0687;  x2: 1183; y2:0726; nm:-1; tt:MenuGlownePodp_Autorzy),
 {wyjscie    }(x: 1002; y:0782;  x2: 1187; y2:0821; nm:-2; tt:MenuGlownePodp_Wyjscie)
       );

  glmenu:record
      x,y, x_,y_, dx,dy:real;
      zoom, szybzoom:real;
      wybrane:shortint; {0-glowne, -1-wyjscie z menu}
      mysz_x,mysz_y:integer;
      mysz_klik_l,mysz_klik_p:boolean;
      og_l,og_p:integer;
      opcjaklik:integer;

      ogienjasnosc:integer; //leci do przodu licznik
  end;

  guziki:array[1..7] of array[0..17] of TGuzik=(
  {nowy} ((x:80; y:140;rx:400; ry: 15; typ:1; mn:400; mx:2000; wartosc:640; ikona:0; tt:Nowy_Szerokoscterenu),
          (x:80; y:160;rx:400; ry: 15; typ:1; mn:400; mx:2000; wartosc:480; ikona:0; tt:Nowy_Wysokoscterenu),
          (x:80; y:50 ;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Nowy_Podloze),
          (x:80; y:70 ;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Nowy_Obiekty),
          (x:80; y:90 ;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Nowy_Przedmioty),
          (x:80; y:110;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Nowy_Miny),
          (x:70; y:370;rx:500; ry: 20; typ:1; mn:0; mx:100; wartosc:0; ikona:38),
          (),(),(),(),(),(),(),(),(),(),()
          ),
  {opcj} ((x:60;  y:140; rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Opcje_GlosZlegoPana),
          (x:60;  y:160; rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Opcje_Dzwieki),
          (x:260; y:160;rx:200; ry: 20; typ:1; mn:0; mx:100; wartosc:0; ikona:38; tt:Opcje_Glosnoscdzwiekow),
          (x:60;  y:180; rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Opcje_Muzyka),
          (x:260; y:180;rx:200; ry: 20; typ:1; mn:0; mx:100; wartosc:0; ikona:38; tt:Opcje_Glosnoscmuzyki),
          (x:60;  y:200;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Opcje_Krewmiesozostawiasladynaterenie),
          (x:60;  y:240;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Opcje_Chowajlicznikiwynikowwczasiebezczynnosci),
          (x:60;  y:260;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Opcje_Swiatla),
          (x:60;  y:220;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Opcje_Liczniki),
          (x:60;  y:280;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Opcje_Wstrzasy),
          (x:80;  y:340;rx:250; ry: 20; typ:1; mn:0; mx:10; wartosc:0; ikona:38; tt:Opcje_Czestpaczek),
          (x:80;  y:300;rx:250; ry: 20; typ:1; mn:1; mx:5; wartosc:0; ikona:38; tt:Opcje_Poziomdetali),
          (x:60;  y:320;rx:20; ry: 20; typ:2; mn:0; mx:2; wartosc:0; ikona:53; tt:Opcje_Kursor),
          (x:60;  y:360;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Opcje_Paczkiwdowolnychmiejscach),
          (x:60;  y:380;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Opcje_EfektySoczewki),
          (x:60;  y:400;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:38; tt:Opcje_Walkazkursorem),
          (x:360; y:260;rx:20; ry: 20; typ:2; mn:0; mx:1; wartosc:0; ikona:51; tt:Opcje_RodzajSterowania),
          (x:360; y:280;rx:20; ry: 20; typ:2; mn:0; mx:2; wartosc:0; ikona:56; tt:Opcje_Dymki)
          ),
  {zapi} ((x:70; y:375;rx:470; ry: 20; typ:1; mn:0; mx:100; wartosc:0; ikona:38),
          (),(),(),(),(),(),(),(),(),(),(),(),(),(),(),(),()),
  {druz} ((),
          (),(),(),(),(),(),(),(),(),(),(),(),(),(),(),(),()),
  {najw} ((),
          (),(),(),(),(),(),(),(),(),(),(),(),(),(),(),(),()),
  {misj} ((x:70; y:350;rx:500; ry: 20; typ:1; mn:0; mx:100; wartosc:0; ikona:38),
          (),
          (),(),(),(),(),(),(),(),(),(),(),(),(),(),(),()),
  {odcz} ((x:70; y:375;rx:470; ry: 20; typ:1; mn:0; mx:100; wartosc:0; ikona:38),
          (),
          (),(),(),(),(),(),(),(),(),(),(),(),(),(),(),())
         );


  ustawienia_terenu:record {ustawienia dla nowego terenu. to, co widac w menu glownym.}
      width,height:integer;
      podloze,
      obiekty,
      przedmioty,
      miny:boolean;
      nazwaterenu:string;
  end;

  menumisje:record
      wybrana:integer; {numer na liscie wybranej misji}
      listax:integer;  {pozycja X przesuwania listy}
      ileskonczonych:integer; {ile misji jest skonczonych}
  end;

  menutereny:record
      wybrany:integer; {numer na liscie wybranego terenu}
      listax:integer;  {pozycja X przesuwania listy}
  end;

  menuscen:record
      wybrany:integer; {numer na liscie wybranego scenariusza}
      listax:integer;  {pozycja X przesuwania listy}
  end;

  polewpisu:record {pole do wpisywania tekstu z klawiatury}
      aktywne:boolean; {czy jest? - jak jest, to wylaczone sa kliki myszki!}
      cozmieniac:^string; {wskaznik do stringa, ktory bedzie zmieniany}
      dlugosc:integer;   {dlugosc znakow dla edytowanego stringa}
      tytul:string; {tekst, ktory sie pojawi nad polem wpisu}
      kursorx:integer; {miejsce kursora}

      kurani, kuranikier:integer; {klatka "animacji" migania kursora (0..63) i jej kierunek (1 lub -1)}
  end;

  oto_kod_tajny: string; {a tu buraki beda wpisywaly tajne kody ;)}

  druzyny_numerplikunaliscie:array[-1..max_druzyn] of integer;

  ogien:array of Togien;

  mnozrozmx,mnozrozmy:real; {razy ile mnozyc wszystkie pozycje na ekranie, zeby dostosowac je do rozdzielczosci}
  tylkoraznastarcie:boolean=false; {znacznik czy juz raz menu bylo czy nie; zeby pewne rzeczy na wstepie zrobic tylko raz}

implementation
uses unit1, directinput8, powertypes, unitmenusy, PowerDraw3, unitautorzy, unitmisje,
     unitwybuchy;

function mmysz_w(x1,y1,x2,y2:integer):boolean;
begin
result:=(glmenu.mysz_x>=x1) and (glmenu.mysz_y>=y1) and (glmenu.mysz_x<=x2) and (glmenu.mysz_y<=y2);
end;

function mmysz_w2(x1,y1,rx,ry:integer):boolean;
begin
result:=(glmenu.mysz_x>=x1) and (glmenu.mysz_y>=y1) and (glmenu.mysz_x<=x1+rx) and (glmenu.mysz_y<=y1+ry);
end;

procedure popraw_ustawienia_z_ekranu;
begin
 ustawienia_terenu.width:= guziki[1][0].wartosc;
 ustawienia_terenu.height:= guziki[1][1].wartosc;
 ustawienia_terenu.podloze:= boolean(guziki[1][2].wartosc);
 ustawienia_terenu.obiekty:= boolean(guziki[1][3].wartosc);
 ustawienia_terenu.przedmioty:= boolean(guziki[1][4].wartosc);
 ustawienia_terenu.miny:= boolean(guziki[1][5].wartosc);

 kfg.glos_zlego_pana:= boolean(guziki[2][0].wartosc);
 kfg.jest_dzwiek:= boolean(guziki[2][1].wartosc);

 if not kfg.calkiem_bez_dzwiekow then begin
     if kfg.glosnosc<>guziki[2][2].wartosc then begin
        kfg.glosnosc:= guziki[2][2].wartosc;
        form1.dzw_bronie_strzaly.Item[2].gain:=kfg.glosnosc/100;
        form1.dzw_bronie_strzaly.Item[2].Play;
     end;
 end;

 if not kfg.calkiem_bez_muzyki then begin
     if kfg.jest_muzyka and (guziki[2][3].wartosc=0) then begin
        form1.wylaczmuzyke;
        kfg.jest_muzyka:=boolean(guziki[2][3].wartosc);
     end else
         if not kfg.jest_muzyka and (guziki[2][3].wartosc=1) then begin
            kfg.jest_muzyka:=boolean(guziki[2][3].wartosc);
            form1.grajkawalek(menu_mjuzik,true);
            form1.wlaczmuzyke(false);
         end;
 end;

 //kfg.jest_muzyka:= boolean(guziki[2][3].wartosc);
 kfg.glosnoscmuzyki:= guziki[2][4].wartosc/100;
 if not kfg.calkiem_bez_muzyki then muzyka.Sound.SetVolume(kfg.glosnoscmuzyki);
 kfg.krew_mieso_zostawia_slady:=boolean(guziki[2][5].wartosc);
 kfg.chowaj_liczniki:=boolean(guziki[2][6].wartosc);
 kfg.swiatla:=boolean(guziki[2][7].wartosc);
 kfg.trzesienie:=boolean(guziki[2][9].wartosc);
 ekran.pokazuj_wyniki:=boolean(guziki[2][8].wartosc);
 warunki.czestpaczek:=guziki[2][10].wartosc;
 kfg.detale:=guziki[2][11].wartosc;
 kfg.jaki_kursor:=guziki[2][12].wartosc;
 warunki.paczkidowolnie:=boolean(guziki[2][13].wartosc);
 kfg.efekty_soczewki:=boolean(guziki[2][14].wartosc);
 warunki.walka_z_kursorem:=boolean(guziki[2][15].wartosc);
 kfg.sterowanie:=guziki[2][16].wartosc;
 kfg.dymki_kolesi:=guziki[2][17].wartosc;

 menumisje.listax:=guziki[6][0].wartosc;
 if glmenu.wybrane=3 then begin
    menutereny.listax:=guziki[3][0].wartosc;
    guziki[7,0].wartosc:=guziki[3,0].wartosc;
 end else begin
    menutereny.listax:=guziki[7][0].wartosc;
    guziki[3,0].wartosc:=guziki[7,0].wartosc;
 end;
 menuscen.listax:=guziki[1][6].wartosc;
end;

procedure popraw_ustawienia_na_ekranie;
begin
 guziki[1][0].wartosc:= ustawienia_terenu.width;
 guziki[1][1].wartosc:= ustawienia_terenu.height;
 guziki[1][2].wartosc:= ord(ustawienia_terenu.podloze);
 guziki[1][3].wartosc:= ord(ustawienia_terenu.obiekty);
 guziki[1][4].wartosc:= ord(ustawienia_terenu.przedmioty);
 guziki[1][5].wartosc:= ord(ustawienia_terenu.miny);

 guziki[2][0].wartosc:= ord(kfg.glos_zlego_pana);
 guziki[2][1].wartosc:= ord(kfg.jest_dzwiek);
 guziki[2][2].wartosc:= kfg.glosnosc;
 guziki[2][3].wartosc:= ord(kfg.jest_muzyka);
 guziki[2][4].wartosc:= trunc(kfg.glosnoscmuzyki*100);
 guziki[2][5].wartosc:= ord(kfg.krew_mieso_zostawia_slady);
 guziki[2][6].wartosc:= ord(kfg.chowaj_liczniki);
 guziki[2][7].wartosc:= ord(kfg.swiatla);
 guziki[2][8].wartosc:= ord(ekran.pokazuj_wyniki);
 guziki[2][9].wartosc:= ord(kfg.trzesienie);
 guziki[2][10].wartosc:= warunki.czestpaczek;
 guziki[2][11].wartosc:= kfg.detale;
 guziki[2][12].wartosc:= kfg.jaki_kursor;
 guziki[2][13].wartosc:= ord(warunki.paczkidowolnie);
 guziki[2][14].wartosc:= ord(kfg.efekty_soczewki);
 guziki[2][15].wartosc:= ord(warunki.walka_z_kursorem);
 guziki[2][16].wartosc:= kfg.sterowanie;
 guziki[2][17].wartosc:= kfg.dymki_kolesi;

 guziki[6][0].wartosc:= menumisje.listax;
 if glmenu.wybrane=3 then begin
    guziki[3][0].wartosc:= menutereny.listax;
    guziki[3,0].wartosc:=guziki[7,0].wartosc;
 end else begin
    guziki[7][0].wartosc:= menutereny.listax;
    guziki[7,0].wartosc:=guziki[3,0].wartosc;
 end;
 guziki[1][6].wartosc:= menuscen.listax;

end;

procedure SprawdzajGuziki;
var
a:integer;
begin
if polewpisu.aktywne then exit;

if glmenu.wybrane>=1 then begin
 a:=0;
 while (a<=high(guziki[glmenu.wybrane]))  do
    with guziki[glmenu.wybrane][a] do begin
       case typ of
          1:begin {suwak}
            if (glmenu.og_l>=1) and (mysz_w2(x,y,rx,ry)) then
               wartosc:=round((mysz.x-x)/(rx/(mx-mn)))+mn;
          end;
          2:begin {przelacznik}
            if (glmenu.mysz_klik_l) and (mysz_w2(x,y,rx+length(guziki[glmenu.wybrane][a].tt)*9,ry)) then begin
               inc(wartosc);
               if wartosc>mx then wartosc:=mn;
            end;
          end;
       end;
       inc(a);
    end;
end;

 popraw_ustawienia_z_ekranu;

end;

function czyTRok(var tr:trect):boolean;
begin
if (tr.Left<ekran.width) and (tr.Top<ekran.height) and (tr.Right>=0) and (tr.Bottom>=0) then begin
   if (tr.Left<0) then tr.Left:=0;
   if (tr.Top<0) then tr.Top:=0;
   if (tr.Right>=ekran.width) then tr.Right:=ekran.width;
   if (tr.Bottom>=ekran.height) then tr.Bottom:=ekran.height;
   result:=true;
end else result:=false;
end;

procedure RysujGuziki;
var
a,b:integer;
c:cardinal;
s:string;
tr,tr2:trect;
x_,y_:integer;
begin

 tr:=rect(0,0,form1.PowerDraw1.width,form1.PowerDraw1.Height);
 a:=0;
 while (a<=high(guziki[glmenu.wybrane]))  do begin
    x_:=guziki[glmenu.wybrane][a].x+round( (menusy[glmenu.wybrane].x-glmenu.x) *mnozrozmx);
    y_:=guziki[glmenu.wybrane][a].y+round( (menusy[glmenu.wybrane].y-glmenu.y) *mnozrozmy);
    with guziki[glmenu.wybrane][a] do begin

       case typ of
          1:begin {suwak}
            if mysz_w2(x_,y_,rx,ry) then begin
               c:=$FFFFFFFF;
               if tt<>'' then s:=tt+': ' else s:='';
               nowytultip(x_,y_-10,s+l2t(wartosc,0));
            end else
               c:=kolor_przyciemnienia;

            if mx-mn=0 then b:=rx
               else b:=trunc((wartosc-mn)*rx/(mx-mn));

            if wartosc<mx then begin
               tr2:=rect(x_+b,y,x_+rx,y+ry);
               if czytrok(tr2) then begin
                   form1.PowerDraw1.ClipRect:=tr2;
                   form1.PowerDraw1.TextureMap(obr.menusuwaktlo.surf,
                     pBounds4(x_,y_,rx,ry),
                     ccolor1(c),
                     tPattern(0),
                     effectSrcAlpha or effectdiffuse);
               end;
            end;

            tr2:=rect(x_,y_,x_+b,y_+ry);
            if czytrok(tr2) then begin
                form1.PowerDraw1.ClipRect:=tr2;

                form1.PowerDraw1.TextureMap(obr.menusuwakwyp.surf,
                     pBounds4(x_,y_,rx,ry),
                     ccolor1(c),
                     tPattern(0),
                     effectSrcAlpha or effectdiffuse);
            end;
            form1.PowerDraw1.ClipRect:=tr;

            form1.PowerDraw1.TextureMap(obr.menusuwak.surf,
                 pBounds4(x_-obr.menusuwak.ofsx +b,
                          y_,
                          obr.menusuwak.rx,
                          ry),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectdiffuse);
          end;
          2:begin {przelacznik}
            if mysz_w2(x_,y_, rx+length(tt)*9, ry) then begin
               c:=$FFFFFFFF;
               //if tt<>'' then nowytultip(x,y-10,tt);
            end else
               c:=kolor_przyciemnienia;

            form1.PowerDraw1.RenderEffectCol(obr.menuikony.surf,
                             x_,
                             y_,
                             c,
                             ikona-1+(wartosc),
                             effectSrcAlpha or effectdiffuse);

            if tt<>'' then piszdowolne(tt,x_+22,y_+3,$FFFFFFFF,9,14);
          end;
       end;
       inc(a);
    end;
 end;

end;

{$IFDEF SPRAWDZANIE_POZYCJI_MENUGLOWNE}
var
kkt:byte;
stt:string;
{$ENDIF}
var dupa:integer;

procedure MenuGlowneDzialaj;
var
a,b,n,x_,y_,sx,sy:integer;
bt,k:byte;
begin
inc(dupa);
inc(glmenu.ogienjasnosc);
{if random(3)=0 then begin
    if form1.PowerInput1.Keys[dik_left] then inc(glmenu.x);
    if form1.PowerInput1.Keys[dik_right] then dec(glmenu.x);
    if form1.PowerInput1.Keys[dik_up] then inc(glmenu.y);
    if form1.PowerInput1.Keys[dik_down] then dec(glmenu.y);

    if form1.PowerInput1.Keys[dik_add] then glmenu.zoom:=glmenu.zoom+0.05;
    if form1.PowerInput1.Keys[dik_subtract] then glmenu.zoom:=glmenu.zoom-0.05;
end;
}

ile_flara := 0;
glmenu.x_:=glmenu.x;
glmenu.y_:=glmenu.y;
if glmenu.wybrane>=0 then begin
    if glmenu.x<menusy[glmenu.wybrane].x then begin
       glmenu.x:=glmenu.x+15;
       if glmenu.x>menusy[glmenu.wybrane].x then glmenu.x:=menusy[glmenu.wybrane].x;
    end else
    if glmenu.x>menusy[glmenu.wybrane].x then begin
       glmenu.x:=glmenu.x-15;
       if glmenu.x<menusy[glmenu.wybrane].x then glmenu.x:=menusy[glmenu.wybrane].x;
    end;
    if glmenu.y<menusy[glmenu.wybrane].y then begin
       glmenu.y:=glmenu.y+15;
       if glmenu.y>menusy[glmenu.wybrane].y then glmenu.y:=menusy[glmenu.wybrane].y;
    end else
    if glmenu.y>menusy[glmenu.wybrane].y then begin
       glmenu.y:=glmenu.y-15;
       if glmenu.y<menusy[glmenu.wybrane].y then glmenu.y:=menusy[glmenu.wybrane].y;
    end;
end;

{$IFDEF SPRAWDZANIE_POZYCJI_MENUGLOWNE}
  if glmenu.mysz_klik_p then begin
     if kkt=0 then stt:='(x: '+l2t(glmenu.mysz_x,4)+'; y:'+l2t(glmenu.mysz_y,4)+';  ';
     if kkt=1 then stt:=stt+'x2: '+l2t(glmenu.mysz_x,4)+'; y2:'+l2t(glmenu.mysz_y,4)+'; nm: 0),';

     inc(kkt);
     if kkt>=2 then begin
        kkt:=0;
        form2.Memo1.Lines.Add(stt);
        form2.Memo1.Lines.SaveToFile('pozycje.txt');
     end;

  end;
{$ENDIF}

if glmenu.zoom<menusy[glmenu.wybrane].zoom then begin
   glmenu.zoom:=glmenu.zoom+glmenu.szybzoom;
   if glmenu.zoom>menusy[glmenu.wybrane].zoom then glmenu.zoom:=menusy[glmenu.wybrane].zoom;
end else
if glmenu.zoom>menusy[glmenu.wybrane].zoom then begin
   glmenu.zoom:=glmenu.zoom-glmenu.szybzoom;
   if glmenu.wybrane=-1 then glmenu.zoom:=glmenu.zoom-0.025;
   if glmenu.zoom<menusy[glmenu.wybrane].zoom then begin
      glmenu.zoom:=menusy[glmenu.wybrane].zoom;
      glmenu.szybzoom:=0.025;
   end;
end;

glmenu.dx:=glmenu.x_-glmenu.x;
glmenu.dy:=glmenu.y_-glmenu.y;

//glmenu.zoom:=glmenu.zoom+cos(dupa/80)*0.005;
{glmenu.x:=glmenu.x+cos(dupa/30)*1.4;
glmenu.y:=glmenu.y+sin(dupa/50)*0.4;}

glmenu.mysz_x:=round(glmenu.x + (-form1.PowerDraw1.width div 2+mysz.x)/glmenu.zoom);
glmenu.mysz_y:=round(glmenu.y + (-form1.PowerDraw1.Height div 2+mysz.y)/glmenu.zoom);


//otwarcie okna z tajnymi kodami: na srodku oba przyciski myszy + spacja
if (form1.PowerInput1.mbPressed[0]>0) and
   (form1.PowerInput1.mbPressed[1]>0) and
   (form1.PowerInput1.KeyPressed[57]) and
   (mmysz_w(0903, 0660, 0936, 0690)) then begin
   stworz_pole_wpisu(Wpisuj_tajny_kod, oto_kod_tajny,20);
end;

//guziki w menu glownym, regiony:
if (glmenu.mysz_klik_l) and (glmenu.wybrane<>-1) then begin
   glmenu.opcjaklik:=0;
   if not polewpisu.aktywne then
     for a:=low(regiony) to high(regiony) do
       if mmysz_w(regiony[a].x, regiony[a].y, regiony[a].x2, regiony[a].y2) then begin
          if regiony[a].nm>=0 then glmenu.wybrane:=regiony[a].nm
             else begin
                  case regiony[a].nm of
                    -5:begin //zacznij misje
                      if length(listyplikow[5])>0 then begin
                         glmenu.opcjaklik:=abs(regiony[a].nm);
                         glmenu.wybrane:=-1;
                      end;
                      end;
                    -6:begin //wczytaj/zapisz teren
                       if (glmenu.wybrane=3) and jest_juz_gra and (ustawienia_terenu.nazwaterenu<>'') then begin //zapis
                          zapisz_teren_do_pliku_full(ustawienia_terenu.nazwaterenu);
                          form1.wypelnlisteterenow;
                       end else
                       if (glmenu.wybrane=7)
                          and (length(listyplikow[6])>0) and (menutereny.wybrany>=0) and (menutereny.wybrany<=high(listyplikow[6])) then begin//odczyt
                           glmenu.opcjaklik:=abs(regiony[a].nm);
                           glmenu.wybrane:=-1;
                       end;
                      end;
                    -7:if glmenu.wybrane=3 then begin //zmien nazwe pliku terenu
                       //stworz_pole_wpisu('Podaj nazwe:',@gracz.imie,30);
                      stworz_pole_wpisu(Podaj_nazwe_terenu,ustawienia_terenu.nazwaterenu,35);
                      end;
                    -8:begin //zmien swoje imie
                      stworz_pole_wpisu(Podaj_swoje_imie,gracz.imie,30);
                      end;
                    -9:begin //wczytanie tylko warunkow ze scenariusza
                       if jest_juz_gra then begin
                          glmenu.opcjaklik:=abs(regiony[a].nm);
                          glmenu.wybrane:=-1;
                       end;
                      end;
                    else begin
                       glmenu.opcjaklik:=abs(regiony[a].nm);
                       glmenu.wybrane:=-1;
                    end;
                  end;
                  end;
          mysz.menustop:=true;
       end;

end;

{kliknieta opcja, ktora zamyka menu i robi cos innego!}
if (glmenu.wybrane=-1) and (glmenu.zoom<=menusy[glmenu.wybrane].zoom) then begin
   case glmenu.opcjaklik of
      1:begin{autorzy};
        MenuGlowneZakoncz;
        zacznij_autorzy;
        end;
      2:begin {wyjscie}
        form1.Close;
        exit;
        end;
      3:begin {nowa gra}
        MenuGlowneZakoncz;
        //if not jest_juz_gra then begin
           form1.nowyteren;
           form1.wczytaj_wszystkie_tekstury;
        //end;
        GraZacznij;
        end;
      4:begin {szybka gra}
        MenuGlowneZakoncz;
        ustawienia_terenu.podloze:=boolean(random(2));
        ustawienia_terenu.obiekty:=boolean(random(2));
        ustawienia_terenu.przedmioty:=boolean(random(2));
        ustawienia_terenu.miny:=boolean(random(2));
        ustawienia_terenu.width:=640+random(400);
        ustawienia_terenu.height:=480+random(500);
        menuscen.wybrany:=random(length(listyplikow[4]));
        form1.nowyteren;
        form1.wczytaj_wszystkie_tekstury;
        GraZacznij;
        end;
      5:begin {nowa misja}
        MenuGlowneZakoncz;
        //form1.nowyteren;
{        wczytaj_misje(listyplikow[5][menumisje.wybrana]);
        form1.nowyteren_wczytaj(tryb_misji.wybranyteren);
        tryb_misji.wlaczony:=true;}
        form1.nowyteren_wczytaj_misja(listyplikow[5][menumisje.wybrana]);
        form1.wczytaj_wszystkie_tekstury;
        GraZacznij;
        end;
      6:begin {wczytaj teren}
        MenuGlowneZakoncz;
        //if not jest_juz_gra then begin
           //form1.nowyteren;
           form1.wczytaj_wszystkie_tekstury;
           form1.nowyteren_wczytaj(listyplikow[6][menutereny.wybrany]);
        //end;
        GraZacznij;
        end;
   (* te sa wyzej, bo nie zamykaja menu
      7: {zmien nazwe pliku terenu}
      8: {zmien imie gracza}
   *)
      9:begin {zmiana warunkow na te z wybranego scenariusza}
        if jest_juz_gra then begin
           MenuGlowneZakoncz;
           WczytajDruzynyJesliZmienione;
           wczytaj_scenariusz(listyplikow[4][menuscen.wybrany], false);
           form1.poprawustawienianieba_powczytaniu;
           GraZacznij;
        end else begin
            glmenu.wybrane:=1;
            glmenu.opcjaklik:=0;
        end;
        end;

   end;
end;


if (form1.PowerInput1.mbPressed[0]>0) and (glmenu.og_l=0) then glmenu.mysz_klik_l:=true
                                                            else glmenu.mysz_klik_l:=false;
if (form1.PowerInput1.mbPressed[1]>0) and (glmenu.og_p=0) then glmenu.mysz_klik_p:=true
                                                            else glmenu.mysz_klik_p:=false;

glmenu.og_l:=form1.PowerInput1.mbPressed[0];
glmenu.og_p:=form1.PowerInput1.mbPressed[1];

sprawdzajguziki;
x_:=round((menusy[glmenu.wybrane].x-glmenu.x)*mnozrozmx);
y_:=round((menusy[glmenu.wybrane].y-glmenu.y)*mnozrozmy);
case glmenu.wybrane of
  1:begin {nowy - wybor scenariusza}
    if (glmenu.og_l>=1) then begin
     a:=0; {x}
     n:=menuscen.listax*(scenily+1);
     while (a<=1) and (n<=high(listyplikow[4])) do begin
        b:=0; {y}
        while (b<=scenily) and (n<=high(listyplikow[4])) do begin
           if mysz_w2(x_+round(mnozrozmx*(70+a*250)), y_+round(mnozrozmy*(225+b*15)), round(mnozrozmx*245), round(mnozrozmy*14)) then
              menuscen.wybrany:=n;
           inc(b);
           inc(n);
        end;
        inc(a);
     end;
    end;
    end;
  4:begin {druzyny}
    if (glmenu.og_l>=1) then
      for a:=0 to max_druzyn do begin
         sx:=x_+round(mnozrozmx*360);
         sy:=y_+round(mnozrozmy*(105+a*35));
         if (mysz_w2(sx,sy,round(mnozrozmx*200),round(mnozrozmy*15))) then
            druzyna[a].numerplikunaliscie:=round((mysz.x-sx)/(mnozrozmx*200/high(listyplikow[3])));

          for k:=0 to 2 do begin
              sx:=x_+round(mnozrozmx*(190+k*75));
              sy:=y_+round(mnozrozmy*(123+a*35));

              if mysz_w2(sx,sy,round(mnozrozmx*64),round(mnozrozmy*12)) then begin
                 bt:=byte(round((mysz.x-sx)/(mnozrozmx*64/255)));
                 case k of
                    0:druzyna[a].kolor_druzyny:=cardinal(
                        (druzyna[a].kolor_druzyny and $FFFF00) or bt
                        );
                    1:druzyna[a].kolor_druzyny:=cardinal(
                        (druzyna[a].kolor_druzyny and $FF00FF) or (bt shl 8)
                        );
                    2:druzyna[a].kolor_druzyny:=cardinal(
                        (druzyna[a].kolor_druzyny and $00FFFF) or (bt shl 16)
                        );
                 end;
              end;

          end;

      end;
    end;
  6:begin {misje}
    if (glmenu.og_l>=1) then begin
     a:=0; {x}
     n:=menumisje.listax*(misjeily+1);
     while (a<=1) and (n<=high(listyplikow[5])) do begin
        b:=0; {y}
        while (b<=misjeily) and (n<=high(listyplikow[5])) do begin
           if mysz_w2(x_+round(mnozrozmx*(70+a*265)),y_+round(mnozrozmy*(140+b*15)), round(mnozrozmx*245), round(mnozrozmy*14)) then
              menumisje.wybrana:=n;
           inc(b);
           inc(n);
        end;
        inc(a);
     end;
    end;
    end;
  3,7:begin {zapis/odczyt terenu}
    if (glmenu.og_l>=1) then begin
     a:=0; {x}
     n:=menutereny.listax*(terenyily+1);
     while (a<=1) and (n<=high(listyplikow[6])) do begin
        b:=0; {y}
        while (b<=terenyily) and (n<=high(listyplikow[6])) do begin
           if mysz_w2(x_+round(mnozrozmx*(70+a*250)),y_+round(mnozrozmy*(120+b*15)), round(mnozrozmx*245), round(mnozrozmy*14)) then begin
              menutereny.wybrany:=n;
              ustawienia_terenu.nazwaterenu:=listyplikow[6][n];
           end;
           inc(b);
           inc(n);
        end;
        inc(a);
     end;
    end;
    end;
end;

if polewpisu.aktywne then dzialaj_pole_wpisu;

for a:=0 to 1 do begin
    b:=random(18);
    nowyogien( mysz.x+random(7)+b div 2, mysz.y+4+random(5)+b,
               random/4-0.125,  -random*2-1,
               random(2)+1,(150+random(84)),190-random(130));
end;

ruszaj_ogien;

end;

procedure MenuGlownePokaz;
var
tr,tr2:trect;
a,b,n,x_,y_,sx,sy:integer;
c:cardinal;
s:string;
bt,k:byte;
begin
// form1.PowerDraw1.Clear($2F000000);
 form1.PowerDraw1.BeginScene();
 tr:=rect(0,0,form1.PowerDraw1.width,form1.PowerDraw1.Height);
 form1.PowerDraw1.ClipRect:=tr;
// form1.PowerDraw1.FillRect(tr,$25000000,effectdiffuse or effectsrcalpha);

 form1.PowerDraw1.TextureMapd(obr.glownemenu.surf,
                          form1.PowerDraw1.width div 2 - glmenu.x*glmenu.zoom{+sin(dupa/120)*1.8},
                          form1.PowerDraw1.Height div 2 - glmenu.y*glmenu.zoom{+cos(dupa/150)*1.8},
                          form1.PowerDraw1.width div 2 - glmenu.x*glmenu.zoom+ obr.glownemenu.surf.PatternWidth*glmenu.zoom{+sin(dupa/120)*1.8},
                          form1.PowerDraw1.Height div 2 - glmenu.y*glmenu.zoom+ obr.glownemenu.surf.patternheight*glmenu.zoom{+cos(dupa/150)*1.8},
                 cWhite4,
                 tPattern(0),
                 effectNone);



 for a:=low(regiony) to high(regiony) do begin
     if mmysz_w(regiony[a].x, regiony[a].y, regiony[a].x2, regiony[a].y2) then begin
        form1.PowerDraw1.TextureMap(obr.wybuchdym[3,0].surf, pBounds4(
                                   -round(glmenu.x*glmenu.zoom) + round(regiony[a].x*glmenu.zoom)+form1.PowerDraw1.width div 2,
                                   -round(glmenu.y*glmenu.zoom) + round(regiony[a].y*glmenu.zoom)+form1.PowerDraw1.Height div 2,
                                   round(regiony[a].w*glmenu.zoom),
                                   round(regiony[a].h*glmenu.zoom)),
                                   cColor1($700000ff),tPattern(0),effectsrcalpha or effectAdd or effectDiffuse);
        if regiony[a].tt<>'' then nowytultip(mysz.x,mysz.y-10,regiony[a].tt);
{        form1.PowerDraw1.Rectangle(-round(glmenu.x*glmenu.zoom) + round(regiony[a].x*glmenu.zoom)+form1.PowerDraw1.width div 2,
                                   -round(glmenu.y*glmenu.zoom) + round(regiony[a].y*glmenu.zoom)+form1.PowerDraw1.Height div 2,
                                   round(regiony[a].w*glmenu.zoom),
                                   round(regiony[a].h*glmenu.zoom),
                                   $200000ff,$100000ff,effectsrcalpha or effectdiffuse);}
     end;

 end;

 x_:=round((menusy[glmenu.wybrane].x-glmenu.x)*mnozrozmx);
 y_:=round((menusy[glmenu.wybrane].y-glmenu.y)*mnozrozmy);
 case glmenu.wybrane of
   0:begin {glowne}
     if glmenu.zoom=menusy[glmenu.wybrane].zoom then begin
         piszdowolne(MenuGlowneGlobalne+gracz.imie,90*mnozrozmx+x_,425*mnozrozmy+y_,$FF00FF00,round(mnozrozmx*7),round(mnozrozmy*10));
         piszdowolne(MenuGlowneGlobalneGier+l2t(gracz.globalniebylogier,3),90*mnozrozmx+x_,437*mnozrozmy+y_,$FFFFFFFF,round(mnozrozmx*8),round(mnozrozmy*10));

         piszdowolne(MenuGlowneGlobalnePkt+l2tprzec(gracz.punktyglobalne,12),570*mnozrozmx+x_,420*mnozrozmy+y_,$FFFFFFFF,round(mnozrozmx*7),round(mnozrozmy*10),1);
         piszdowolne(MenuGlowneGlobalneTrup+l2tprzec(gracz.trupyglobalne,12),570*mnozrozmx+x_,432*mnozrozmy+y_,$FFFFFFFF,round(mnozrozmx*7),round(mnozrozmy*10),1);
     end;
     end;
   1:begin {nowy}
     RysujGuziki;

     form1.PowerDraw1.Rectangle(round(45*mnozrozmx+x_), round(205*mnozrozmy+y_+10), round(535*mnozrozmx), round((scenily+2)*15*mnozrozmy), $a0505080, $80404070,effectsrcalpha);
     a:=0; {x}
     n:=menuscen.listax*(scenily+1);
     while (a<=1) and (n<=high(listyplikow[4])) do begin
        b:=0; {y}
        while (b<=scenily) and (n<=high(listyplikow[4])) do begin
           if mysz_w2(round(x_+(70+a*250)*mnozrozmx), round(y_+(225+b*15)*mnozrozmy), round(245*mnozrozmx), round(14*mnozrozmy)) then
              form1.PowerDraw1.Rectangle(round(x_+(70+a*250)*mnozrozmx), round( y_+(225+b*15)*mnozrozmy), round(245*mnozrozmx), round(14*mnozrozmy), $309090a0, $409090B0,effectsrcalpha);
           if n=menuscen.wybrany then begin
              c:=$FF00FFff;
              form1.PowerDraw1.Rectangle(round(x_+(70+a*250)*mnozrozmx), round( y_+(225+b*15)*mnozrozmy), round(245*mnozrozmx), round(14*mnozrozmy), $60a0b0b0, $7090b0b0,effectsrcalpha);
           end else c:=$FFFFFFFF;
           piszdowolne(listyplikow[4][n],round(x_+(70+a*250)*mnozrozmx), round( y_+(225+b*15)*mnozrozmy), c,trunc(9*mnozrozmx),trunc(12*mnozrozmy));
           inc(b);
           inc(n);
        end;
        inc(a);
     end;

     end;
   2:begin
     RysujGuziki;
     end;
   4:begin {wczytaj druzyny}
     //RysujGuziki;
     for a:=0 to max_druzyn do begin
         sx:=round((x_+360)*mnozrozmx);
         sy:=round((105+y_+a*35)*mnozrozmy);

         if mysz_w2(x_+round(70*mnozrozmx), sy, round(500*mnozrozmx), round(35*mnozrozmx)) then c:=druzyna[a].kolor_druzyny or $47000000
            else c:=druzyna[a].kolor_druzyny or $26000000;
         form1.PowerDraw1.FillRect(
                        x_+round(70*mnozrozmx), sy, round(500*mnozrozmx), round(35*mnozrozmx),
               c, effectSrcAlpha or effectdiffuse);

         piszdowolne(WczDruz_Druzyna+' '+l2t(a+1,0)+': '+ listyplikow[3][druzyna[a].numerplikunaliscie],round(80*mnozrozmx)+x_,sy+round(3*mnozrozmy),$FFfffFFF);

          if mysz_w2(sx,sy,round(200*mnozrozmx), round(15*mnozrozmx)) then begin
             c:=$FFFFFFFF;
             s:=WczDruz_Druzyna+' '+l2t(a+1,0);
             nowytultip(sx,sy-10,s);
          end else
             c:=kolor_przyciemnienia;

          b:=trunc(druzyna[a].numerplikunaliscie*200/high(listyplikow[3]));

          if druzyna[a].numerplikunaliscie<high(listyplikow[3]) then begin
             tr2:=rect(sx+round(b*mnozrozmx), sy, sx+round(200*mnozrozmx), sy+round(15*mnozrozmy));
             if czytrok(tr2) then begin
                 form1.PowerDraw1.ClipRect:=tr2;
                 form1.PowerDraw1.TextureMap(obr.menusuwaktlo.surf,
                   pBounds4(sx, sy, round(200*mnozrozmx), round(15*mnozrozmy)),
                   ccolor1(c),
                   tPattern(0),
                   effectSrcAlpha or effectdiffuse);
             end;
          end;

          tr2:=rect(sx, sy, sx+round(b*mnozrozmx), sy+round(15*mnozrozmy));
          if czytrok(tr2) then begin
              form1.PowerDraw1.ClipRect:=tr2;

              form1.PowerDraw1.TextureMap(obr.menusuwakwyp.surf,
                   pBounds4(sx, sy, round(200*mnozrozmx), round(15*mnozrozmy)),
                   ccolor1(c),
                   tPattern(0),
                   effectSrcAlpha or effectdiffuse);
          end;
          form1.PowerDraw1.ClipRect:=tr;

          form1.PowerDraw1.TextureMap(obr.menusuwak.surf,
               pBounds4(sx +round((-obr.menusuwak.ofsx +b)*mnozrozmx),
                        sy,
                        round(obr.menusuwak.rx*mnozrozmx),
                        round(15*mnozrozmy)),
               ccolor1(c),
               tPattern(0),
               effectSrcAlpha or effectdiffuse);



          for k:=0 to 2 do begin
              sx:=x_+round(({346+}190+k*75)*mnozrozmx);
              sy:=y_+round((123+a*35)*mnozrozmy);

              bt:=byte ((druzyna[a].kolor_druzyny and ($FF shl (k*8))) shr (k*8) );

              if mysz_w2(sx,sy,round(64*mnozrozmx),round(12*mnozrozmy)) then begin
                 c:=$FFFFFFFF;
                 case k of
                      0:s:='R:'+l2t(bt,0);
                      1:s:='G:'+l2t(bt,0);
                      2:s:='B:'+l2t(bt,0);
                 end;
                 nowytultip(sx,sy-10,s);
              end else
                 c:=kolor_przyciemnienia;


              b:=trunc(bt*64/256);

              if bt<255 then begin
                 tr2:=rect(sx+round(b*mnozrozmx),sy,sx+round(64*mnozrozmx),sy+round(12*mnozrozmy));
                 if czytrok(tr2) then begin
                     form1.PowerDraw1.ClipRect:=tr2;
                     form1.PowerDraw1.TextureMap(obr.menusuwaktlo.surf,
                       pBounds4(sx,sy,round(64*mnozrozmx),round(12*mnozrozmy)),
                       ccolor1(c),
                       tPattern(0),
                       effectSrcAlpha or effectdiffuse);
                 end;
              end;

              tr2:=rect(sx,sy,sx+round(b*mnozrozmx),sy+round(12*mnozrozmy));
              if czytrok(tr2) then begin
                  form1.PowerDraw1.ClipRect:=tr2;

                  form1.PowerDraw1.TextureMap(obr.menusuwakwyp.surf,
                       pBounds4(sx,sy,round(64*mnozrozmx),round(12*mnozrozmy)),
                       ccolor1(c),
                       tPattern(0),
                       effectSrcAlpha or effectdiffuse);
              end;
              form1.PowerDraw1.ClipRect:=tr;

              form1.PowerDraw1.TextureMap(obr.menusuwak.surf,
                   pBounds4(sx+round((-obr.menusuwak.ofsx +b)*mnozrozmx),
                            sy,
                            round(obr.menusuwak.rx*mnozrozmx),
                            round(12*mnozrozmy)),
                   ccolor1(c),
                   tPattern(0),
                   effectSrcAlpha or effectdiffuse);
          end;
          form1.PowerDraw1.TextureMap(obr.pasekkolor.surf,
                     pBounds4(x_+round(90*mnozrozmx), y_+round((123+a*35)*mnozrozmy), round(80*mnozrozmx),round(12*mnozrozmy)),
                     cColor1(cardinal(druzyna[a].kolor_druzyny or $FF000000)),
                     tPattern(0),
                     effectSrcAlpha or effectdiffuse);
     end;


     end;
   5:begin {lista najlepszych}
     //RysujGuziki;

     form1.PowerDraw1.Rectangle(round(mnozrozmx*45)+x_,y_+round(mnozrozmy*130),round(mnozrozmx*535),round(mnozrozmy*((ilemiejsc_lokalnie+2)*13)), $a0505080, $80404070,effectsrcalpha);
     for a:=1 to ilemiejsc_lokalnie+1 do begin
         if a=listarekordow_lokalna_tmp_gdziegracz then
            form1.PowerDraw1.Rectangle(round(mnozrozmx*45)+x_,y_+round(mnozrozmy*(120+a*13)),round(mnozrozmx*535),round(mnozrozmy*14), $809090a0, $909090B0,effectsrcalpha);
         piszdowolne(l2t(a,2)+'.',round(mnozrozmx*50)+x_,y_+round(mnozrozmy*(122+a*13)),$FFFFFFFF,round(mnozrozmx*6),round(mnozrozmy*10));
         piszdowolne(listarekordow_lokalna_tmp[a].imie,round(mnozrozmx*70+x_),y_+round(mnozrozmy*(120+a*13)),$FFFFFFFF,round(mnozrozmx*8),round(mnozrozmy*13));
         piszdowolne(l2tprzec(listarekordow_lokalna_tmp[a].pkt,10),round(mnozrozmx*350)+x_,y_+round(mnozrozmy*(120+a*13)),$FFaFFFfF,round(mnozrozmx*8),round(mnozrozmy*13));
         piszdowolne(l2tprzec(listarekordow_lokalna_tmp[a].trupy,10),round(mnozrozmx*465)+x_,y_+round(mnozrozmy*(120+a*13)),$FF7070FF,round(mnozrozmx*8),round(mnozrozmy*13));
     end;

     //rysuj tultip z dokladniejszymi danymi wybranego gracza:
     for a:=1 to ilemiejsc_lokalnie+1 do begin
         if mysz_w2(round(mnozrozmx*45)+x_,y_+round(mnozrozmy*(120+a*13)),round(mnozrozmx*535),round(mnozrozmy*13)) then begin
            n:=round(mnozrozmx*65)+x_; //x tultipa
            b:=y_+round(mnozrozmy*(120+a*13+14)); //y tultipa
            form1.PowerDraw1.Rectangle(n,b,
                                       round(mnozrozmx*500),round(mnozrozmy*54),
                                       $e070b0b0, $e0405090,effectsrcalpha);

            if a=listarekordow_lokalna_tmp_gdziegracz then
                piszdowolne(ListaNaj_obecnagra,
                            n+round(mnozrozmx*490),b+round(mnozrozmy*5),$FF40fF40,round(mnozrozmx*12),round(mnozrozmy*12),1);

            piszdowolne(l2t(a,2)+'.',n+round(mnozrozmx*10),b+round(mnozrozmy*6),$FFFFFFFF,round(mnozrozmx*8),round(mnozrozmy*10));
            piszdowolne(listarekordow_lokalna_tmp[a].imie,n+round(mnozrozmx*35),b+round(mnozrozmy*5),$FFFFFFFF,round(mnozrozmx*9),round(mnozrozmy*13));

            piszdowolne(ListaNaj_pkt+l2tprzec(listarekordow_lokalna_tmp[a].pkt,10),n+round(mnozrozmx*25),b+round(mnozrozmy*17),$FFaFFFfF,round(mnozrozmx*9),round(mnozrozmy*13));
            piszdowolne(ListaNaj_trupow+l2tprzec(listarekordow_lokalna_tmp[a].trupy,10),n+round(mnozrozmx*25),b+round(mnozrozmy*33),$FF7070FF,round(mnozrozmx*9),round(mnozrozmy*13));

            piszdowolne(ListaNaj_czasgry+l2t(listarekordow_lokalna_tmp[a].czas div 3600,0)+':'+l2t((listarekordow_lokalna_tmp[a].czas div 60) mod 60,2)+':'+l2t(listarekordow_lokalna_tmp[a].czas mod 60,2),
                        n+round(mnozrozmx*490),b+round(mnozrozmy*17),$FFfFb090,round(mnozrozmx*8),round(mnozrozmy*13),1);
            piszdowolne(ListaNaj_datagry+DateTimeToStr(listarekordow_lokalna_tmp[a].data),
                        n+round(mnozrozmx*490),b+round(mnozrozmy*33),$FFfFb0b0,round(mnozrozmx*8),round(mnozrozmy*13),1);

            break;
         end;
     end;

     piszdowolne(gracz.imie,round(mnozrozmx*268)+x_,round(mnozrozmy*67)+y_,$FFFFFFFF,round(mnozrozmx*9),round(mnozrozmy*16));
     end;
   6:begin {misje}
     RysujGuziki;

     form1.PowerDraw1.Rectangle(round(mnozrozmx*45)+x_,y_+round(mnozrozmy*(120+10)),round(mnozrozmx*550),round(mnozrozmy*((misjeily+2)*15)), $a0505080, $80404070,effectsrcalpha);
     if length(listyplikow[5])>0 then begin
         a:=0; {x}
         n:=menumisje.listax*(misjeily+1);
         while (a<=1) and (n<=high(listyplikow[5])) do begin
            b:=0; {y}
            while (b<=misjeily) and (n<=high(listyplikow[5])) do begin
               if mysz_w2(x_+round(mnozrozmx*(70+a*250)),y_+round(mnozrozmy*(140+b*15)), round(mnozrozmx*245), round(mnozrozmy*14)) then
                  form1.PowerDraw1.Rectangle(x_+round(mnozrozmx*(70+a*265)),y_+round(mnozrozmy*(140+b*15)), round(mnozrozmx*245), round(mnozrozmy*14), $309090a0, $409090B0,effectsrcalpha);
               if n=menumisje.wybrana then begin
                  c:=$FF00FFff;
                  form1.PowerDraw1.Rectangle(x_+round(mnozrozmx*(70+a*265)),y_+round(mnozrozmy*(140+b*15)), round(mnozrozmx*245), round(mnozrozmy*14), $60a0b0b0, $7090b0b0,effectsrcalpha);
               end else begin
                   if (skonczonemisje[n]) then c:=$FF50FF50
                                          else c:=$FFFFFFFF;
               end;
               piszdowolne(listyplikow[5][n],x_+round(mnozrozmx*(70+a*265)),y_+round(mnozrozmy*(140+b*15)), c,trunc(mnozrozmx*9),trunc(mnozrozmy*12));
               if (skonczonemisje[n]) then
                  form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                          pBounds4(x_+round(mnozrozmx*(54+a*265)),
                                   y_+round(mnozrozmy*(140+b*15)),
                                   round(mnozrozmx*12),
                                   round(mnozrozmy*12)),
                                   cColor1($FFFFFFFF),
                                   tPattern(38),
                                   effectSrcAlpha or effectdiffuse);
               inc(b);
               inc(n);
            end;
            inc(a);
         end;
     end else
         piszdowolne(Misje_brakmisji,round(mnozrozmx*70)+x_,round(mnozrozmy*140)+y_,$FF0050ff,12,14);

     piszdowolne(Misje_sumamisji+l2t(length(listyplikow[5]),0), round(mnozrozmx*595)+x_,round(mnozrozmy*90)+y_,$FFFFFFFF,10,12,1);
     piszdowolne(Misje_skonczonychmisji+l2t(menumisje.ileskonczonych,0),round(mnozrozmx*595)+x_,round(mnozrozmy*102)+y_,$FFFFFFFF,10,12,1);
     piszdowolne(Misje_nieskonczonychmisji+l2t(length(listyplikow[5])-menumisje.ileskonczonych,0),round(mnozrozmx*595)+x_,round(mnozrozmy*114)+y_,$FFFFFFFF,10,12,1);

     end;
   3,7:begin {odczyt/zapis terenu}
     RysujGuziki;

     form1.PowerDraw1.Rectangle(round(mnozrozmx*45)+x_,y_+round(mnozrozmy*(100+10)),round(mnozrozmx*535),round(mnozrozmy*((terenyily+2)*15)), $a0505080, $80404070,effectsrcalpha);
     if length(listyplikow[6])>0 then begin
         a:=0; {x}
         n:=menutereny.listax*(terenyily+1);
         while (a<=1) and (n<=high(listyplikow[6])) do begin
            b:=0; {y}
            while (b<=terenyily) and (n<=high(listyplikow[6])) do begin
               if mysz_w2(x_+round(mnozrozmx*(70+a*250)),y_+round(mnozrozmy*(120+b*15)), round(mnozrozmx*245), round(mnozrozmy*14)) then
                  form1.PowerDraw1.Rectangle(x_+round(mnozrozmx*(70+a*250)),y_+round(mnozrozmy*(120+b*15)), round(mnozrozmx*245), round(mnozrozmy*14), $309090a0, $409090B0,effectsrcalpha);
               if n=menutereny.wybrany then begin
                  c:=$FF00FFff;
                  form1.PowerDraw1.Rectangle(x_+round(mnozrozmx*(70+a*250)),y_+round(mnozrozmy*(120+b*15)), round(mnozrozmx*245), round(mnozrozmy*14), $60a0b0b0, $7090b0b0,effectsrcalpha);
               end else c:=$FFFFFFFF;
               piszdowolne(listyplikow[6][n],x_+round(mnozrozmx*(70+a*250)),y_+round(mnozrozmy*(120+b*15)), c,trunc(mnozrozmx*9),trunc(mnozrozmy*12));
               inc(b);
               inc(n);
            end;
            inc(a);
         end;
     end else
         piszdowolne(Tereny_brakterenow,round(mnozrozmx*70)+x_,round(mnozrozmy*120)+y_,$FF0050ff,12,14);

     piszdowolne(ustawienia_terenu.nazwaterenu,round(mnozrozmx*68)+x_,round(mnozrozmy*66)+y_,$FFFFFFFF,8,17);
     end;
 end;
 tr:=rect(0,0,form1.PowerDraw1.width,form1.PowerDraw1.Height);
 form1.PowerDraw1.ClipRect:=tr;

 if polewpisu.aktywne then pokaz_pole_wpisu;

 rysuj_ogien;
// form1.PowerDraw1.RenderEffectcol(obr.kursor.surf,mysz.x-obr.kursor.ofsx,mysz.y-obr.kursor.ofsy,$C0FFFFFF,10,effectsrcalpha or effectdiffuse);

 rysuj_flary;

 pokazuj_tultip;

 pokazuj_napiswrogu;

{$IFDEF SPRAWDZANIE_POZYCJI_MENUGLOWNE}
 pisz(l2t(glmenu.mysz_x ,0)+ ' x '+ l2t(glmenu.mysz_y ,0), 0,0);
 pisz(l2t(trunc(glmenu.x) ,0)+ ' x '+ l2t(trunc(glmenu.y) ,0), 0,15);
 pisz(l2t(trunc(glmenu.zoom*1000),0),0,30);
 pisz(l2t(glmenu.wybrane,0),0,45);
{$ENDIF}

{    pisz('AA:'+bl[form1.PowerDraw1.antialias],0,50);
    pisz('DIT:'+bl[form1.PowerDraw1.dithering],0,61);
    pisz('HARD:'+bl[form1.PowerDraw1.hardware],0,72);
    pisz(l2t(form1.PowerDraw1.Width,0)+'x'+l2t(form1.PowerDraw1.Height,0),0,83);
    pisz(l2t(form1.PowerDraw1.RefreshRate,0)+'Hz',0,94);
    pisz('Buf:'+l2t(form1.PowerDraw1.BackBufferCount,0),0,105);
}

 form1.PowerDraw1.EndScene();
 form1.PowerDraw1.Present();
end;

procedure stworz_pole_wpisu(tytul_:string; var cozmieniac_:string; dlugosc_:integer);
begin
polewpisu.aktywne:=true;
polewpisu.cozmieniac:=@cozmieniac_;
polewpisu.dlugosc:=dlugosc_;
polewpisu.tytul:=tytul_;
polewpisu.kursorx:=length(cozmieniac_)+1;
end;

procedure dzialaj_pole_wpisu;
begin
polewpisu.kurani:=polewpisu.kurani+polewpisu.kuranikier;
if (polewpisu.kurani<=0) then polewpisu.kuranikier:=1;
if (polewpisu.kurani>=63) then polewpisu.kuranikier:=-1;
end;

procedure pokaz_pole_wpisu;
var x,rx:integer; c:cardinal;
begin
  rx:=trunc(mnozrozmx*10);

  form1.PowerDraw1.Rectangle(round(mnozrozmx*60),round(mnozrozmy*200),round(mnozrozmx*520),round(mnozrozmy*80), $D09090c0, $C0404070,effectsrcalpha);
  piszdowolne(polewpisu.tytul, round(mnozrozmx*80),round(mnozrozmy*220),$ff3060ff,rx,trunc(mnozrozmy*13));
  piszdowolne(polewpisu.cozmieniac^, round(mnozrozmx*80),round(mnozrozmy*250),$ffffffff,rx,trunc(mnozrozmy*13));
  x:=round(mnozrozmx*80)+(polewpisu.kursorx-1)*rx;
  c:=cardinal( (polewpisu.kurani shl 26) or $b0b0ff);
  form1.powerdraw1.Rectangle(x,round(mnozrozmy*250),rx,trunc(mnozrozmy*13), c,c,effectAdd or effectSrcAlpha);
end;

procedure MenuGlowneZacznij(ktore:integer);
var a,b:integer;
begin
ktore_haslo_wczytywanie_widac:=0;
log('Rozpoczecie menu');
form1.SetFocus;
glowne_co_widac:=0;
Form1.pokaz_wczytywanie(Logo_wczytywanie);
robsprajt(obr.glownemenu,'Graphics\glmenu.tga',-1,-1,16);
robsprajt(obr.pasekkolor,'Graphics\pasekkolor.tga',-1,-1,32);
with glmenu do begin
   x:=menusy[0].x;
   y:=menusy[0].y;
   zoom:=20.1;
   szybzoom:=0.5;
   wybrane:=ktore;
   opcjaklik:=0;
end;

mnozrozmx:=form1.PowerDraw1.Width/640;
mnozrozmy:=form1.PowerDraw1.Height/480;
setlength(ogien,max_ogien+1);


for a:=low(menusy) to high(menusy) do begin
    menusy[a].zoom:=menusy[a].pzoom*mnozrozmx;
end;

if not tylkoraznastarcie then begin
    tylkoraznastarcie:=true;
    for a:=low(regiony) to high(regiony) do begin
        regiony[a].w:=regiony[a].x2-regiony[a].x;
        regiony[a].h:=regiony[a].y2-regiony[a].y;
    end;

    for a:=low(guziki) to high(guziki) do begin
        for b:=low(guziki[a]) to high(guziki[a]) do begin
            guziki[a][b].x:=round(guziki[a][b].x*mnozrozmx);
            guziki[a][b].y:=round(guziki[a][b].y*mnozrozmy);
            guziki[a][b].rx:=round(guziki[a][b].rx*mnozrozmx);
            guziki[a][b].ry:=round(guziki[a][b].ry*mnozrozmy);
        end;
    end;
end;

tultip.czas:=0;

polewpisu.aktywne:=false;
polewpisu.kurani:=0;
polewpisu.kuranikier:=1;

zrob_liste_lokalna_tmp;

popraw_ustawienia_na_ekranie;

for a:=-1 to max_druzyn do
    druzyny_numerplikunaliscie[a]:=druzyna[a].numerplikunaliscie;

glmenu.ogienjasnosc:=0;
form1.zliczSkonczoneMisje;

napiswrogu.czas:=0;
oto_kod_tajny:='';

zapisz_kfg;

Form1.schowaj_wczytywanie;
form1.PowerTimer1.MayRender:= True;
form1.PowerTimer1.MayProcess:= True;

form1.wylaczmuzyke;
form1.grajkawalek(menu_mjuzik,true);
form1.wlaczmuzyke(true);
end;

procedure MenuGlowneZakoncz;
begin
ktore_haslo_wczytywanie_widac:=1+random(length(hasla_wczytywanie)-1);
form1.PowerTimer1.MayRender:=false;
form1.PowerTimer1.MayProcess:=false;

napiswrogu.czas:=0;
tultip.czas:=0;

setlength(ogien,0);

if obr.glownemenu.surf<>nil then begin
   obr.glownemenu.surf.Free;
   obr.glownemenu.surf:=nil;
end;
if obr.pasekkolor.surf<>nil then begin
   obr.pasekkolor.surf.Free;
   obr.pasekkolor.surf:=nil;
end;
end;

procedure WczytajDruzynyJesliZmienione;
var a:integer;
begin
if sa_juz_wczytane_druzyny then begin
   a:=-1;
   while (a<=max_druzyn) and (druzyny_numerplikunaliscie[a]=druzyna[a].numerplikunaliscie) do inc(a);
   if a<=max_druzyn then form1.wczytaj_druzyny;
end else
    form1.wczytaj_druzyny;
end;


//-----efekty menu--------------------------------------------

//nowywybuchdym(sx,sy  ,dx_          ,dy_          ,rod,gatun ,sz         ,przezr           ,wielkosc_      );
//nowywybuchdym( x,y-10,random/2-0.25,-random/2-0.4,3  ,wd_dym,random(5)+1,(100+random(154)),220-random(130));

procedure nowyogien(sx,sy,dx_,dy_:real; sz:byte; przezr:smallint;wielkosc_:integer);
var b:longint;
begin
if length(ogien)<=0 then exit;

b:=0;
while (b<max_ogien) and (ogien[b].jest) do
   inc(b);

if b>=max_ogien then
   b:=random(max_ogien);
{if not ogien[a].jest then }
with ogien[b] do begin
   x:=sx;
   y:=sy;
   dx:=dx_;
   dy:=dy_;
   jest:=true;
   klatka:=7-random(4);
   szyb:=sz;
   dosz:=0;
   if wielkosc_=0 then begin
      wielkosc:=256;//obr.ogien[gatunek,rodz].rx;
   end else
       wielkosc:=wielkosc_;
   przezroczysty:=przezr;
   kat:=random(256);
end;

end;

procedure ruszaj_ogien;
var a:longint;
begin
if length(ogien)<=0 then exit;
for a:=0 to max_ogien do
  if ogien[a].jest then with ogien[a] do begin
    x:=x+dx+glmenu.dx;
    y:=y+dy+glmenu.dy;

    kat:=kat+round( ((1+random*7)/wielkosc)*110 );
    if kat>=256 then dec(kat,256);

    inc(dosz);
    if dosz>=szyb then begin
       inc(klatka,1+random(2));
       if klatka>=30 then jest:=false;
       if (przezroczysty=0) and (klatka>=15) then przezroczysty:=240;
       dosz:=0;
    end;
    if (przezroczysty>=25) then begin
         case szyb of
            0..1:dec(przezroczysty,3);
            2..3:dec(przezroczysty,2);
            else dec(przezroczysty);
         end;
    end;

  end;
end;


procedure rysuj_ogien;
var a:longint; sx,sy,ef:integer; kol:tcolor4; kolj: cardinal;
begin
if length(ogien)<=0 then exit;

sx:= trunc(obr.wybuchdym[3,0].rx + sin(glmenu.ogienjasnosc/5)*30 );
sy:= trunc(obr.wybuchdym[3,0].ry + sin(glmenu.ogienjasnosc/5)*30 );
kolj:=trunc(15+cos(glmenu.ogienjasnosc/7.2)*(7+cos(glmenu.ogienjasnosc*6.4)*3 ) );
form1.PowerDraw1.TextureMap(obr.wybuchdym[3,0].surf,
    pRotate4(trunc(mysz.sx+8),
             mysz.sy+10 - trunc( glmenu.ogienjasnosc*1.5 ) mod 20,
             sx,
             sy,
             sx div 2,
             sy div 2,
             0),
             cColor1( cardinal(kolj shl 24 + $00FFFF) ),
             tPattern(0),
             effectSrcAlpha or effectAdd or effectDiffuse);

nowa_flara(mysz.sx+8,mysz.sy+10, 140+kolj, (20+kolj*3) shl 24 + $0040Efff);
for a:=0 to max_ogien do begin
  if (ogien[a].jest) then with ogien[a] do begin

        sx:= (obr.wybuchdym[1,3].surf.PatternWidth * wielkosc) div 256;
        sy:= (obr.wybuchdym[1,3].surf.PatternHeight * wielkosc) div 256;

        if przezroczysty>0 then kol:=cColor1(cardinal((przezroczysty shl 24) or $efd0ef))
                           else kol:=cColor1(                                 $ffefd0ef);

        ef:=effectSrcAlpha or effectAdd or effectDiffuse;
        if (trunc(x+obr.wybuchdym[1,3].ofsx)>=0) and
           (trunc(x-obr.wybuchdym[1,3].ofsx)<=ekran.width) and
           (trunc(y+obr.wybuchdym[1,3].ofsy)>=0) and
           (trunc(y-obr.wybuchdym[1,3].ofsy)<=ekran.height) then
           form1.PowerDraw1.TextureMap(obr.wybuchdym[1,3].surf,
              pRotate4(trunc(x{-obr.ogien[gatunek,rodz].ofsx}),
                       trunc(y{-obr.ogien[gatunek,rodz].ofsy}),
                       sx,
                       sy,
                       sx div 2,
                       sy div 2,
                       kat),
                       kol,
                       tPattern(klatka),
                       ef);


  end;
  if a=7*max_ogien div 8 then  form1.PowerDraw1.RenderEffectcol(obr.kursor.surf,mysz.x-obr.kursor.ofsx,mysz.y-obr.kursor.ofsy,$C0FFFFFF,10,effectsrcalpha or effectdiffuse);

end;
end;

{sprawdz tajny kod! ;)}
procedure sprawdz_tajny_kod;
var a:integer;
begin

if oto_kod_tajny='GIVEMEALLWEAPONS' then begin {daje wszystkie bronie!}
   for a:=0 to max_broni do begin
       wymagane_do_broni[a].pkt:=0;
       wymagane_do_broni[a].trup:=0;
       wymagane_do_broni[a].pacz:=0;
   end;
   gracz._pkt:=gracz.pkt-1;
   sprawdz_dostepne_bronie;

   nowynapiswrogu(KOD_wszystkiebronieodblokowane, 400);
end;

oto_kod_tajny:='';

end;


end.
