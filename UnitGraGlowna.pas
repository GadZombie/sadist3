unit UnitGraGlowna;

interface

uses
  windows, graphics, sysutils, types,
  unitKolesie, unitPociski, unitminy, unitsyfki, unitefekty, UnitWybuchy, UnitPrzedmioty,
  UnitMiesko, unitbomble, UnitRysowanie, unitmenusy, UnitZwierzaki, UnitCiezkie,
  sinusy,vars, unitpliki, unitpogoda, unitstringi, unitmisje,
  al, altypes;

var
licznik,          {leci caly czas od 0 do 359, z krokiem co 2}
licznik2:integer; {leci caly czas od 0 do 179, z krokiem 1}
licznik3:integer; {leci caly czas od 0 do 179, z krokiem 1 (dziala tez w czasie pauzy)}

    procedure pisz(s:string; sx,sy:integer);
    procedure wylacz_dzwieki_ciagle;
    procedure piszwaskie(s:string; sx,sy:integer; kol:cardinal=$FFFFFFFF; margines:byte=0); {0-lewy, 1-prawy}
    procedure piszdowolne(s:string; sx,sy:real; kol:cardinal=$FFFFFFFF;rx:integer=9;ry:integer=12; margines:byte=0);
    procedure piszdowolnezlamaniem(s:string; sx,sy:real;kol:cardinal;rx,ry,szer:integer; margines:byte); {0-lewy, 1-prawy}

    procedure piszdowolne_dymki(s:string; sx,sy:real; kol:cardinal=$FFFFFFFF;rx:integer=9;ry:integer=12; margines:byte=0); {0-lewy, 1-prawy}
    function sprawdz_pusta_linie(x1, y1, x2, y2:Integer):boolean;

    procedure ruszaj;
    procedure sprawdz_dostepne_bronie;
    procedure glowna_gra_ruch;
    procedure glowna_gra_pokaz;
    procedure pokaz_kursor_myszy;
    procedure pokaz_info_o_kolesiu;
    procedure rysujfale(kolor:cardinal);

    procedure GraZacznij;
    procedure GraZakoncz;

implementation
uses unit1, PowerInputs, powertypes, PowerDraw3, directinput8, d3d9, pdrawex,
  AGFUnit, oooal;

procedure wylacz_dzwieki_ciagle;
var a:integer;
begin
if not kfg.calkiem_bez_dzwiekow then begin
    with dzwieki_ciagle do begin
       if ogien then begin
          form1.dzw_bronie_inne.Item[5].Stop;
          ogien:=false;
       end;
       if deszcz then begin
          form1.dzw_rozne.Item[6].Stop;
          deszcz:=false;
       end;
       if laser then begin
          form1.dzw_bronie_strzaly.Item[6].Stop;
          laser:=false;
       end;
       if prad then begin
          form1.dzw_bronie_strzaly.Item[7].Stop;
          prad:=false;
       end;

       if pilaluz then begin
          form1.dzw_bronie_strzaly.Item[10].Stop;
          pilaluz:=false;
       end;
       if pilatnie then begin
          form1.dzw_bronie_strzaly.Item[11].Stop;
          pilatnie:=false;
       end;
       if pilatniebardzo then begin
          form1.dzw_bronie_strzaly.Item[12].Stop;
          pilatniebardzo:=false;
       end;

       for a:=13 to 16 do
           if form1.dzw_rozne.Item[a].playing then
              form1.dzw_rozne.Item[a].Stop;
    end;
end;
end;

procedure pisz(s:string; sx,sy:integer);
var
a,ssx:integer;
begin
ssx:=sx;
for a:=1 to length(s) do begin
    if s[a]=#13 then begin
       ssx:=sx;
       sy:=sy+13;
    end else
    if s[a]=#10 then begin
    end else begin
        if s[a]<>#32 then begin
            form1.PowerDraw1.TextureMap(obr.font.surf,
                          pBounds4(ssx,sy,9,13),cWhite4,
                          tPattern(tabznakow[s[a]]),
                          effectSrcAlpha);
        end;
        ssx:=ssx+9;
    end;
end;

end;

procedure piszwaskie(s:string; sx,sy:integer; kol:cardinal; margines:byte); {0-lewy, 1-prawy}
var
a,ssx:integer;
sz,wys:integer;
ef:integer;
begin
if margines=1 then sx:=sx-length(s)*6;
ssx:=sx;
sz:=6;
wys:=13;
if kol=$FFFFFFFF then ef:=effectSrcAlpha
                 else ef:=effectSrcAlpha or effectdiffuse;

for a:=1 to length(s) do begin
    if s[a]=#13 then begin
       ssx:=sx;
       sy:=sy+13;
    end else
    if s[a]=#10 then begin
    end else begin
        if s[a]<>#32 then begin
            form1.PowerDraw1.TextureMap(
                     obr.font.surf,
                     pBounds4(ssx,sy,sz,wys),
                     ccolor1(kol),
                     tPattern(tabznakow[s[a]]),
                     ef);
        end;
        ssx:=ssx+6;
    end;
end;

end;

procedure piszdowolne(s:string; sx,sy:real;kol:cardinal;rx,ry:integer; margines:byte); {0-lewy, 1-prawy}
var
a:integer;
ef,ssx:integer;
begin
ssx:=trunc(sx);
if kol=$FFFFFFFF then ef:=effectSrcAlpha
                 else ef:=effectSrcAlpha or effectdiffuse;

if margines=1 then ssx:=ssx-length(s)*rx;
for a:=1 to length(s) do begin
    if s[a]=#13 then begin
       ssx:=trunc(sx);
       sy:=sy+13;
    end else
    if s[a]=#10 then begin
    end else begin
        if s[a]<>#32 then begin
            form1.PowerDraw1.TextureMap(obr.font.surf,
                   pBounds4(round(ssx),round(sy),rx,ry),
                   ccolor1(kol),
                   tPattern(tabznakow[s[a]]),
                   ef);
        end;
        ssx:=ssx+rx;
    end;
end;

end;

procedure piszdowolnezlamaniem(s:string; sx,sy:real;kol:cardinal;rx,ry,szer:integer; margines:byte); {0-lewy, 1-prawy}
var
a,b,b1:integer;
ef,ssx:integer;
begin
ssx:=trunc(sx);
if kol=$FFFFFFFF then ef:=effectSrcAlpha
                 else ef:=effectSrcAlpha or effectdiffuse;

if margines=1 then ssx:=ssx-length(s)*rx;

if length(s)*rx>szer then begin //³am tekst
   a:=1;
   b:=0;
   while (a<=length(s)) do begin
      inc(b,rx);
      if s[a]=#13 then b:=0;
      if (b>=szer-rx) then begin //doszlo do dlugosci maxymalnej, wiec tniemy:
         b1:=a;
         while (b1>=1) and (s[b1]<>' ') do dec(b1);
         if b1>1 then begin //znaleziono spacje wczesniej niz poczatek stringa
            s[b1]:=#13; //wstaw enter zamiast spacji
            a:=b1+1;
         end;
         b:=0;
      end;

      inc(a);
   end;


end;

for a:=1 to length(s) do begin
    if s[a]=#13 then begin
       ssx:=trunc(sx);
       sy:=sy+13;
    end else
    if s[a]=#10 then begin
    end else begin
        if s[a]<>#32 then begin
            form1.PowerDraw1.TextureMap(obr.font.surf,
                   pBounds4(round(ssx),round(sy),rx,ry),
                   ccolor1(kol),
                   tPattern(tabznakow[s[a]]),
                   ef);
        end;
        ssx:=ssx+rx;
    end;
end;

end;


procedure piszdowolne_dymki(s:string; sx,sy:real;kol:cardinal;rx,ry:integer; margines:byte); {0-lewy, 1-prawy}
var
a:integer;
ef,ssx:integer;
begin
ssx:=trunc(sx);
if kol=$FFFFFFFF then ef:=effectSrcAlpha
                 else ef:=effectSrcAlpha or effectdiffuse;

if margines=1 then ssx:=ssx-length(s)*rx;
for a:=1 to length(s) do begin
    if s[a]=#13 then begin
       ssx:=trunc(sx);
       sy:=sy+10;
    end else
    if s[a]=#10 then begin
    end else begin
        if s[a]<>#32 then begin
            form1.PowerDraw1.TextureMap(obr.font2.surf,
                   pBounds4(round(ssx),round(sy),rx,ry),
                   ccolor1(kol),
                   tPattern(tabznakow[s[a]]),
                   ef);
        end;
        ssx:=ssx+6;
    end;
end;

end;

function sprawdz_pusta_linie(x1, y1, x2, y2:Integer):boolean;
var
    DeltaX, DeltaY, NumPixels, Counter,
    D, Dinc1, Dinc2,
    X, Xinc1, Xinc2,
    Y, Yinc1, Yinc2 : Integer;
begin
    result:=true;
    DeltaX := abs (x2 - x1);
    DeltaY := abs (y2 - y1);
    if (DeltaX >= DeltaY) then begin
      NumPixels := Deltax + 1;
      D := (DeltaY shl 1) - DeltaX;
      Dinc1 := DeltaY shl 1;
      Dinc2 := (DeltaY - DeltaX) shl 1;
      Xinc1 := 1;
      Xinc2 := 1;
      Yinc1 := 0;
      Yinc2 := 1;
    end else begin
      NumPixels := DeltaY + 1;
      D := (DeltaX shl 1) - DeltaY;
      Dinc1 := DeltaX shl 1;
      Dinc2 := (DeltaX - DeltaY) shl 1;
      Xinc1 := 0;
      Xinc2 := 1;
      Yinc1 := 1;
      Yinc2 := 1;
    end;
    if x1 > x2 then begin
      Xinc1 := -Xinc1;
      Xinc2 := -Xinc2;
    end;
    if y1 > y2 then begin
      Yinc1 := -Yinc1;
      Yinc2 := -Yinc2;
    end;
    X := x1;
    Y := y1;
    for Counter := 1 to NumPixels do begin
      if (x>=0) and (y>=0) and (x<=teren.width-1) and (y<=teren.height+29) and
         (teren.maska[x,y]<>0) then begin
         result:=false;
         exit;
      end;
      if (D < 0) then begin
        inc (D, Dinc1);
        inc (X, Xinc1);
        inc (Y, Yinc1);
      end else begin
        inc (D, Dinc2);
        inc (X, Xinc2);
        inc (Y, Yinc2);
      end;
    end;
end;



procedure ruszaj;
var
a,s,b,c,d,cx,cy:integer;
m:Tmysz;
s_mr:boolean;
r:real;

kx,ky:real;

begin
m:=mysz;
m.x:=m.x+ekran.px;
m.y:=m.y+ekran.py;
s:=0;
s_mr:=false;
if not mysz.menustop then begin
   s_mr:=mysz.r;
   m.l:=(form1.PowerInput1.mbPressed[0]>0) and (mysz.y<ekran.height-ekran.menux);
   m.r:=(form1.PowerInput1.mbPressed[1]>0) and (mysz.y<ekran.height-ekran.menux);
   mysz.r:=m.r;
   mysz.l:=m.l;
   if m.l then s:=-1;
   if m.r then s:=1;

   mysz.menul:=(form1.PowerInput1.mbPressed[0]>0) and (mysz.y>=ekran.height-ekran.menux);
   mysz.menur:=(form1.PowerInput1.mbPressed[1]>0) and (mysz.y>=ekran.height-ekran.menux);
end else begin
   if (form1.PowerInput1.mbPressed[0]=0) and (form1.PowerInput1.mbPressed[1]=0) then mysz.menustop:=false;
   mysz.menul:=false;
   mysz.menur:=false;
   mysz.l:=false;
   mysz.r:=false;
end;
if (mysz.jest_obracanie) and (m.r) then begin {obracanie celownika i zmiana sily}
      bron.skat:=bron.kat;

      case kfg.sterowanie of
        0:begin
          bron.kat:=bron.kat+form1.powerinput1.mDeltaX;
          while bron.kat>=360 do dec(bron.kat,360);
          while bron.kat<0 do inc(bron.kat,360);
          bron.sila:=bron.sila-form1.powerinput1.mDeltay;
          if bron.sila<0 then bron.sila:=0;
          if bron.sila>99 then bron.sila:=99;
          end;
        1:begin
          kx:=bron.sila * sin(bron.kat * pi180);
          ky:=bron.sila * -cos(bron.kat * pi180);

          kx:=kx+form1.powerinput1.mDeltaX;
          ky:=ky+form1.powerinput1.mDeltaY;

          bron.sila:=round(sqrt2(kx*kx+ky*ky));
          bron.kat:=round( jaki_to_kat(kx,ky) );

          while bron.kat>=360 do dec(bron.kat,360);
          while bron.kat<0 do inc(bron.kat,360);
          if bron.sila<0 then bron.sila:=0;
          if bron.sila>99 then bron.sila:=99;
          end;
      end;

      mysz.x:=mysz.sx;
      mysz.y:=mysz.sy;

      bron.tryb:=0;
end;
if (bron.glownytryb=1) and (rysowanie.corobi=2) and (m.r) then begin
      rysowanie.kat:=rysowanie.kat+form1.powerinput1.mDeltaX ;
      while rysowanie.kat>=360 do dec(rysowanie.kat,360);
      while rysowanie.kat<0 do inc(rysowanie.kat,360);
      rysowanie.odleglosci:=rysowanie.odleglosci-form1.powerinput1.mDeltay;
      if rysowanie.odleglosci<rysmenuuklad[2][5].mn then rysowanie.odleglosci:=rysmenuuklad[2][5].mn;
      if rysowanie.odleglosci>rysmenuuklad[2][5].mx then rysowanie.odleglosci:=rysmenuuklad[2][5].mx;

      rysmenuuklad[2][5].wartosc:=rysowanie.odleglosci;
      rysmenuuklad[2][6].wartosc:=rysowanie.kat;

      mysz.x:=mysz.sx;
      mysz.y:=mysz.sy;
end;

bron.piluje:=false;
{strzelanie}
if (s<>0) and (bron.glownytryb=0) and (bron.dostrzalu=0) then
   case bron.wybrana of
      0:if not warunki.pauza and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin
           if ((s=-1) and (bron.went_szyb<90)) or
              ((s=1) and (bron.went_szyb>-90)) then bron.went_szyb:=bron.went_szyb-s;

           if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      1:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bazuka}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,0,50,60,0,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=15;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      2:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {granat}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,1,30,80,1,true,bronmenuuklad[bron.wybrana][1].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
        bron.dostrzalu:=10;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      3:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bomba}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,1,30,80,2,true,bronmenuuklad[bron.wybrana][1].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
        bron.dostrzalu:=10;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      4:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {rzucanie przedmiotami}
        if bronmenuuklad[bron.wybrana][0].wartosc=0 then b:=random(ile_przedm)
           else b:=bronmenuuklad[bron.wybrana][0].wartosc-1;
        nowyprzedmiot(m.x,m.y,bron.kat,bron.sila/2,1,b);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
        bron.dostrzalu:=10;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      5:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {minigan}
        strzel(m.x,m.y,bron.kat-2+random(5),20,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,2,60,3,-1,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[2],m.x,m.y,1000);
        bron.dostrzalu:=5;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      6:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {karabin}
        strzel(m.x,m.y,bron.kat,18,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,2,40,2,-1,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[3],m.x,m.y,1000);
        bron.dostrzalu:=7;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      7:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {strzelba}
        for a:=1 to bronmenuuklad[bron.wybrana][1].wartosc do
            strzel(m.x,m.y,bron.kat-5+random(11),15+random(3),1,-2,bronmenuuklad[bron.wybrana][0].wartosc,2,40,4,-1,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[4],m.x,m.y,1000);
        bron.dostrzalu:=60;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      8:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {odlamki}
        strzel(m.x,m.y,bron.kat-2+random(5),bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc+random(7),3,30,100,3,false,200+random(100));
        form1.graj(form1.dzw_bronie_strzaly.Item[3],m.x,m.y,1000);
        bron.dostrzalu:=9;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      9:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {mieso}
        if bronmenuuklad[bron.wybrana][1].wartosc=0 then b:=random(max_druzyn+1)
           else b:=bronmenuuklad[bron.wybrana][1].wartosc-1;
        case bronmenuuklad[bron.wybrana][0].wartosc of
           0:nowemieso(m.x,m.y,_sin(trunc(bron.kat))*bron.sila/10,-_cos(trunc(bron.kat))*bron.sila/9,random(6),b,boolean(bronmenuuklad[bron.wybrana][2].wartosc),-1);
           1..6:nowemieso(m.x,m.y,_sin(trunc(bron.kat))*bron.sila/10,-_cos(trunc(bron.kat))*bron.sila/9,bronmenuuklad[bron.wybrana][0].wartosc-1,b,boolean(bronmenuuklad[bron.wybrana][2].wartosc),-1);
           7:begin
             d:= nowemieso(m.x+druzyna[b].miesomiejsca[1].x,
                           m.y+druzyna[b].miesomiejsca[1].y,
                           _sin(trunc(bron.kat))*bron.sila/10,
                           -_cos(trunc(bron.kat))*bron.sila/9,
                           1,b,boolean(bronmenuuklad[bron.wybrana][2].wartosc),-1);
             for a:=0 to 5 do if a<>1 then
                 nowemieso(m.x+druzyna[b].miesomiejsca[a].x,
                           m.y+druzyna[b].miesomiejsca[a].y,
                           _sin(trunc(bron.kat))*bron.sila/10,
                           -_cos(trunc(bron.kat))*bron.sila/9,
                           a,b,boolean(bronmenuuklad[bron.wybrana][2].wartosc),-1,d);
             end;
        end;
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,0);
        bron.dostrzalu:=15;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      10:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {miny}
            rzucmine(m.x,m.y,bron.kat-2+random(5),bron.sila/2,1,boolean(bronmenuuklad[bron.wybrana][1].wartosc),0);
            form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
            bron.dostrzalu:=12;
            if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
         end;
      11:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {napalm}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,10,4,40,110,4,true,{380}bronmenuuklad[bron.wybrana][0].wartosc+random(80));
        //form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=2;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      12:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {ogien}
        strzel(m.x,m.y,bron.kat-5+random(11),bron.sila/4-3+random(7),1,-2,20,5,10,-20,5,boolean(random(2)),55-random(10));
        //form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=0;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      13:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bomba z gwozdziami}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,1,45,90,6,true,bronmenuuklad[bron.wybrana][1].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,3000);
        bron.dostrzalu:=20;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      14:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {pocisk co robi tunele}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,6,50,99,26,false,-1,bronmenuuklad[bron.wybrana][1].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=25;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      15:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {duzy granat}
        strzel(m.x,m.y,bron.kat,bron.sila/3,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,1,60,99,7,false,-1,bronmenuuklad[bron.wybrana][1].wartosc,bronmenuuklad[bron.wybrana][2].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
        bron.dostrzalu:=20;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      16:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bazuka naprowadzana}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,7,50,60,21,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=17;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      17:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {kula ognista}
        strzel(m.x,m.y,bron.kat,bron.sila/3,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,8,140,100,8,false,-1);
        //form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=30;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      18:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {miny podwodne}
        rzucmine(m.x,m.y,bron.kat-2+random(5),bron.sila/2,1,boolean(bronmenuuklad[bron.wybrana][1].wartosc),1);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
        bron.dostrzalu:=20;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      19:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {miny podwodne zaczepione (chyba to zrobie jako jedna bron z minami podwodnymi)}
        if bron.tryb=0 then begin
           if (m.x>=0) and (m.y>=0) and (m.x<=teren.width-1) and (m.y<=teren.height+30) and
              (teren.maska[m.x,m.y]<>0) then begin
              bron.mx:=m.x;
              bron.my:=m.y;
              bron.tryb:=1;
           end;
        end;
        end;
     {20:brak - w zamian jest mina na linie}
      21:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {dynamit}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,9,30,60,9,true,bronmenuuklad[bron.wybrana][1].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
        bron.dostrzalu:=13;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      22:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {pilka}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,10,13,50,10,true,bronmenuuklad[bron.wybrana][1].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
        bron.dostrzalu:=20;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      23:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {koles}
        if bronmenuuklad[bron.wybrana][0].wartosc=0 then b:=random(max_druzyn+1)
           else b:=bronmenuuklad[bron.wybrana][0].wartosc-1;
        nowykoles(m.x,m.y,_sin(trunc(bron.kat))*bron.sila/5,-_cos(trunc(bron.kat))*bron.sila/5,-1,b);
        form1.graj(form1.dzw_rozne.Item[12],m.x,m.y,2000);
        bron.dostrzalu:=20;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      24:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {nalot}
        for a:=1 to bronmenuuklad[bron.wybrana][1].wartosc do
            strzel( m.x-bronmenuuklad[bron.wybrana][1].wartosc*5+(a-1)*10-2*_sin(trunc(bron.kat))*bron.sila,
                    -200-_sin(trunc(bron.kat))*(bron.sila/10)*(-bronmenuuklad[bron.wybrana][1].wartosc+(a-1)*2)-random(400),
                    _sin(trunc(bron.kat))*(bron.sila/20),
                    1.6+random*2.5,
                    0,
                    -2,
                    bronmenuuklad[bron.wybrana][0].wartosc,
                    0,50,60,0,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=100;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      25:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {nalot naprowadzany}
        for a:=1 to bronmenuuklad[bron.wybrana][1].wartosc do
            strzel( m.x-bronmenuuklad[bron.wybrana][1].wartosc*5+(a-1)*10-2*_sin(trunc(bron.kat))*bron.sila,
                    -200-_sin(trunc(bron.kat))*(bron.sila/10)*(-bronmenuuklad[bron.wybrana][1].wartosc+(a-1)*2)-random(300),
                    _sin(trunc(bron.kat))*(bron.sila/20),
                    1.6+random,
                    0,
                    -2,
                    bronmenuuklad[bron.wybrana][0].wartosc,
                    7,50,60,21,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=100;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      26:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bazuka z napalmem}
        if bronmenuuklad[bron.wybrana][1].wartosc>bronmenuuklad[bron.wybrana][1].mn then
           b:=bronmenuuklad[bron.wybrana][1].wartosc
           else b:=-1;
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,11,50,90,11,false,b);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=30;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      27:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {nalot napalmowy}
        if bronmenuuklad[bron.wybrana][2].wartosc>bronmenuuklad[bron.wybrana][2].mn then
           b:=bronmenuuklad[bron.wybrana][2].wartosc
           else b:=-1;
        for a:=1 to bronmenuuklad[bron.wybrana][1].wartosc do begin
            c:=random(400);
            strzel( m.x-bronmenuuklad[bron.wybrana][1].wartosc*5+(a-1)*10-2*_sin(trunc(bron.kat))*bron.sila,
                    -200-_sin(trunc(bron.kat))*(bron.sila/10)*(-bronmenuuklad[bron.wybrana][1].wartosc+(a-1)*2)-c,
                    _sin(trunc(bron.kat))*(bron.sila/20),
                    1.6+random*2.5,
                    0,
                    -2,
                    bronmenuuklad[bron.wybrana][0].wartosc,
                    11,50,90,11,false,b+c div 6);
        end;
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=100;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      28:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {krew}
        if bronmenuuklad[bron.wybrana][0].wartosc=0 then b:=random(max_druzyn+2)-1
           else
           if bronmenuuklad[bron.wybrana][0].wartosc=max_druzyn+2 then b:=-1
              else b:=bronmenuuklad[bron.wybrana][0].wartosc-1;
        c:=random(4);
        if c>=2 then begin
           if random(6)=0 then d:=1 else d:=0;
        end else d:=0;
        nowysyf(m.x,m.y,bron.kat-5+random(11),bron.sila/4-3+random(7),1,c,d,0,false,b);
        bron.dostrzalu:=0;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      29:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {snajperka}
        form1.graj(form1.dzw_bronie_strzaly.Item[5],m.x,m.y,2000);
        for a:=0 to 9 do
            wybuch(m.x,m.y,12,false,false,true,false,-2,true);
        wybuch(m.x,m.y,15,true,true,true,false,-2,true);

        nowywybuchdym( m.x, m.y,
                       0, 0,
                       0, wd_dym,
                       4+random(3),
                       200+random(54),
                       140+random(80));


        for a:=0 to max_kol do
            if (koles[a].jest) and
               (koles[a].x>=m.x-70) and
               (koles[a].y>=m.y-70) and
               (koles[a].x<=m.x+70) and
               (koles[a].y<=m.y+70) then koles[a].corobi:=cr_panika;

        bron.dostrzalu:=50;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      30:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {smieci}
        if bronmenuuklad[bron.wybrana][0].wartosc=0 then b:=random(max_smieci+1)
           else b:=bronmenuuklad[bron.wybrana][0].wartosc-1;

        nowemieso(m.x,m.y,_sin(trunc(bron.kat))*bron.sila/10,-_cos(trunc(bron.kat))*bron.sila/9,b,-2,boolean(bronmenuuklad[bron.wybrana][2].wartosc),-1);

        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,0);
        bron.dostrzalu:=15;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      31:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bfg}
        strzel(m.x,m.y,bron.kat,10+bron.sila/3,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,12,80,5,12,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=80;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      32:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {proton}
        strzel(m.x,m.y,bron.kat,15+bron.sila/3,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,13,80,5,13,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=10;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      33:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {miotacz ognia}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,10,14,40,-10,14,random(5)=0,80+random(20));
        //form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=2;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      34:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {noze}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,10,15,10,5,15,true,bronmenuuklad[bron.wybrana][0].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
        bron.dostrzalu:=5;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      35:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {zwierzaki}
        if bronmenuuklad[bron.wybrana][0].wartosc=0 then b:=random(max_rodz_zwierzaki+1)
           else b:=bronmenuuklad[bron.wybrana][0].wartosc-1;
        nowyzwierzak(m.x,m.y,_sin(trunc(bron.kat))*bron.sila/10,-_cos(trunc(bron.kat))*bron.sila/9,b);
        bron.dostrzalu:=20;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      36:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {chmura/dym}
        strzel(m.x,m.y,bron.kat-5+random(11),bron.sila/3+(random(7)*ord(bron.sila>0)),1,-2,20,16,14,0,16,true,bronmenuuklad[bron.wybrana][0].wartosc+random(50),10+random(60),0,random(2048));
        //form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=2;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      37:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bomba z gazem}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,1,45,70,17,true,bronmenuuklad[bron.wybrana][1].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,3000);
        bron.dostrzalu:=20;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      38:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bazuka z gazem}
        if bronmenuuklad[bron.wybrana][1].wartosc>bronmenuuklad[bron.wybrana][1].mn then
           b:=bronmenuuklad[bron.wybrana][1].wartosc
           else b:=-1;
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,11,50,90,18,false,b);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=30;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      39:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {ciezkie}
        if bronmenuuklad[bron.wybrana][0].wartosc=0 then b:=random(3)
           else b:=bronmenuuklad[bron.wybrana][0].wartosc-1;
        noweciezkie(m.x,m.y,_sin(trunc(bron.kat))*bron.sila/10,-_cos(trunc(bron.kat))*bron.sila/9,b);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,0);
        bron.dostrzalu:=40;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      40:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {molotov}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,1,30,110,19,false,0);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
        bron.dostrzalu:=40;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      41:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and not warunki.pauza and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {laser}
        bron.dostrzalu:=0;
        inc(bron.laserdlugosc,200);
        if bron.laserdlugosc>bronmenuuklad[bron.wybrana][1].wartosc then bron.laserdlugosc:=bronmenuuklad[bron.wybrana][1].wartosc;
        laser(m.x,m.y,_sin(trunc(bron.kat)),-_cos(trunc(bron.kat)),bronmenuuklad[bron.wybrana][0].wartosc,boolean(bronmenuuklad[bron.wybrana][2].wartosc),boolean(bronmenuuklad[bron.wybrana][3].wartosc));
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      42:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and not warunki.pauza and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {prad}
        bron.dostrzalu:=0;
        inc(bron.laserdlugosc,30);
        if bron.laserdlugosc>bronmenuuklad[bron.wybrana][1].wartosc then bron.laserdlugosc:=bronmenuuklad[bron.wybrana][1].wartosc;
        laser(m.x,m.y,_sin(trunc(bron.kat)),-_cos(trunc(bron.kat)),bronmenuuklad[bron.wybrana][0].wartosc,false,boolean(bronmenuuklad[bron.wybrana][2].wartosc));
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      43:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and not warunki.pauza and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {rejlgan}
        bron.dostrzalu:=50;
        bron.laserdlugosc:=5000;
        form1.graj(form1.dzw_bronie_strzaly.Item[13],m.x,m.y,2000);
        laser(m.x,m.y,_sin(trunc(bron.kat)),-_cos(trunc(bron.kat)),40,false,false);
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      44:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and not warunki.pauza and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {hiper-mega-radioaktywny-promien :)}
        bron.dostrzalu:=0;
        inc(bron.laserkrec);
        inc(bron.laserdlugosc,10);
        if bron.laserdlugosc>bronmenuuklad[bron.wybrana][1].wartosc then bron.laserdlugosc:=bronmenuuklad[bron.wybrana][1].wartosc;
        laser(m.x,m.y,_sin(trunc(bron.kat)),-_cos(trunc(bron.kat)),bronmenuuklad[bron.wybrana][0].wartosc,false,false);
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      45:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {gaz wybuchajacy}
        strzel(m.x,m.y,bron.kat-5+random(11),bron.sila/3+(random(7)*ord(bron.sila>0)),1,-2,20,16,14,0,20,true,bronmenuuklad[bron.wybrana][0].wartosc+random(50),10+random(60),0,random(2048));
        //form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=2;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      46:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {nalot z gazem wybuchajacym}
        for a:=1 to bronmenuuklad[bron.wybrana][1].wartosc do
            strzel( m.x-bronmenuuklad[bron.wybrana][1].wartosc*10+(a-1)*20-2*_sin(trunc(bron.kat))*bron.sila,
                    -200-_sin(trunc(bron.kat))*(bron.sila/10)*(-bronmenuuklad[bron.wybrana][1].wartosc+(a-1)*2)-random(200),
                    _sin(trunc(bron.kat))*(bron.sila/20),
                    2+random,
                    0,
                    -2,
                    bronmenuuklad[bron.wybrana][0].wartosc,
                    17,50,60,0,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=100;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      47:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bazuka z gazem wybuchajacym}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,17,50,60,0,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=50;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      48:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and not warunki.pauza and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {piorun}
        bron.dostrzalu:=30;
        bron.piorun_dostrzalu:=bron.dostrzalu;
        piorun(m.x,m.y,bron.kat,bronmenuuklad[bron.wybrana][0].wartosc, true);
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      49:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {pila}
        bron.dostrzalu:=0;
        if not warunki.pauza then begin
           piluj;
           if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
        end;
      50:if not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {mlotek}
         if m.l then begin
            bron.dostrzalu:=20;
            bron.mlotek_ani:=20;
         end;
         if m.r then begin
            if (bron.kat>=300) and (bron.skat<=60) then
               b:=(bron.kat-360-bron.skat)
              else
            if (bron.skat>=300) and (bron.kat<=60) then
               b:=(bron.kat+360-bron.skat)
              else b:=(bron.kat-bron.skat);

            b:=b mod 360;
            if abs(b)>=1 then wal_mlotkiem(-b/6);


         end;
         if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
         end;
      51:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bomba z gazem wybuchajacym}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,1,45,70,28,true,bronmenuuklad[bron.wybrana][1].wartosc,1);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,3000);
        bron.dostrzalu:=20;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
      52:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bomba na cialo}
        b:=-1;
        a:=0;
        while (a<=max_kol) and (b=-1) do begin
            if (koles[a].jest) and
               (koles[a].x-ekran.px+10>=mysz.x) and
               (koles[a].x-ekran.px-10<=mysz.x) and
               (koles[a].y-ekran.py+10>=mysz.y) and
               (koles[a].y-ekran.py-10<=mysz.y) then b:=a;
            inc(a);
        end;

        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,18,50,80,23,true,bronmenuuklad[bron.wybrana][1].wartosc,b,bronmenuuklad[bron.wybrana][2].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
        bron.dostrzalu:=70;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
     53:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {roller}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,19,40,110,24,true,bronmenuuklad[bron.wybrana][1].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
        bron.dostrzalu:=10;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
     54:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {rakieta}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,0,50,15,25,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=20;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
     55:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and not warunki.pauza and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {zemsta bogow}
        bron.dostrzalu:=teren.height;
        zemsta_wypal(m.x,bronmenuuklad[bron.wybrana][0].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[9],m.x,m.y,5000);
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
     56:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bloto}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,1,50,70,27,false,-1,bronmenuuklad[bron.wybrana][1].wartosc);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=13;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
     57:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {beczki}
            rzucmine(m.x,m.y,bron.kat-2+random(5),bron.sila/2,1,boolean(bronmenuuklad[bron.wybrana][1].wartosc),2);
            form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
            bron.dostrzalu:=20;
            if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
         end;
     58:if m.l and not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
           not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {bomba atomowa}
        strzel(m.x,m.y,bron.kat,bron.sila/2,1,-2,bronmenuuklad[bron.wybrana][0].wartosc,20,80,90,29,false,-1);
        form1.graj(form1.dzw_bronie_strzaly.Item[0],m.x,m.y,0);
        bron.dostrzalu:=60;
        if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
        end;
   end;

{miny na haku}
if (bron.glownytryb=0) and (bron.wybrana=19) and (bron.tryb=1) and (not m.l) then begin
   rzucmine(m.x,m.y,bron.kat-2+random(5),bron.sila/2,1,boolean(bronmenuuklad[bron.wybrana][1].wartosc),1,true,bron.mx,bron.my);
   form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
   bron.dostrzalu:=20;
   bron.tryb:=0;
   if (tryb_misji.wlaczony) and (tryb_misji.amunicja[bron.wybrana]>0) then dec(tryb_misji.amunicja[bron.wybrana]);
end;

if ((bron.wybrana<>43) or (not warunki.pauza)) and (bron.dostrzalu>0) then begin
   dec(bron.dostrzalu);
   bron.laserkrec:=0;
end;

if (not warunki.pauza) and (bron.piorun_dostrzalu>0) then
   dec(bron.piorun_dostrzalu);

if (bron.wybrana in [41,42,44]) and (bron.laserdlugosc>0) and (not m.l) and (not warunki.pauza) then bron.laserdlugosc:=0;
if (bron.wybrana=43) and (bron.laserdlugosc>0) and (bron.dostrzalu<=1) and (not warunki.pauza) then bron.laserdlugosc:=0;

if (bron.wybrana=50) and (bron.mlotek_ani>0) then begin
   if bron.mlotek_ani<=4 then wal_mlotkiem(7+random*5) else
   if bron.mlotek_ani in [10..13] then wal_mlotkiem(-7-random*5);
   dec(bron.mlotek_ani);
end
   else bron.mlotek_ani:=0;

{wentylator}
if (bron.wybrana<>0) or (s=0) then begin
   if bron.went_szyb>0 then dec(bron.went_szyb) else
   if bron.went_szyb<0 then inc(bron.went_szyb);
end;
if (bron.wybrana=0) and (bron.went_szyb<>0) then begin
   if bron.went_szyb>=0 then a:=1 else a:=-1;
   bron.went_ani:=bron.went_ani+bron.went_szyb/30;
   if bron.went_ani<0 then bron.went_ani:=bron.went_ani+obr.wentylator.klatek;
   if bron.went_ani>=obr.wentylator.klatek then bron.went_ani:=bron.went_ani-obr.wentylator.klatek;

   if not warunki.pauza then begin
      rozrzuc(m.x,m.y,abs(bron.went_szyb/2),a,false,false,-2,false);
      if random(5)=0 then
         plum_z_piana(m.x,m.y, abs(bron.went_szyb/3),5);
   end;
end;

{dzwieki ciagle broni:}
if not kfg.calkiem_bez_dzwiekow then begin
    if kfg.jest_dzwiek and
       (bron.wybrana in [11,12,33]) and (m.l) and
       not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
       not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {miotacz ognia}
         if not dzwieki_ciagle.miotacz then begin
            form1.dzw_bronie_strzaly.Item[8].Play;
            dzwieki_ciagle.miotacz:=true;
         end;
         form1.dzw_bronie_strzaly.Item[8].xpos:=mysz.x/przeziledziel;
         form1.dzw_bronie_strzaly.Item[8].ypos:=mysz.y/przeziledziel;
         form1.dzw_bronie_strzaly.Item[8].Update;
    end else if dzwieki_ciagle.miotacz then begin
        form1.dzw_bronie_strzaly.Item[8].Stop;
        dzwieki_ciagle.miotacz:=false
    end;

    if kfg.jest_dzwiek and
       (bron.wybrana =49) and (not m.l) and
       not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
       not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {pila luz}
         if not dzwieki_ciagle.pilaluz then begin
            form1.dzw_bronie_strzaly.Item[10].Play;
            dzwieki_ciagle.pilaluz:=true;
         end;
         form1.dzw_bronie_strzaly.Item[10].xpos:=mysz.x/przeziledziel;
         form1.dzw_bronie_strzaly.Item[10].ypos:=mysz.y/przeziledziel;
         form1.dzw_bronie_strzaly.Item[10].Update;
    end else if dzwieki_ciagle.pilaluz then begin
        form1.dzw_bronie_strzaly.Item[10].Stop;
        dzwieki_ciagle.pilaluz:=false
    end;
    if kfg.jest_dzwiek and
       (bron.wybrana =49) and (m.l) and (not bron.pilujebardzo) and
       not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
       not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {pila tnie}
         if not dzwieki_ciagle.pilatnie then begin
            form1.dzw_bronie_strzaly.Item[11].Play;
            dzwieki_ciagle.pilatnie:=true;
         end;
         form1.dzw_bronie_strzaly.Item[11].xpos:=mysz.x/przeziledziel;
         form1.dzw_bronie_strzaly.Item[11].ypos:=mysz.y/przeziledziel;
         form1.dzw_bronie_strzaly.Item[11].Update;
    end else if dzwieki_ciagle.pilatnie then begin
        form1.dzw_bronie_strzaly.Item[11].Stop;
        dzwieki_ciagle.pilatnie:=false
    end;
    if kfg.jest_dzwiek and
       (bron.wybrana =49) and (m.l) and (bron.pilujebardzo) and
       not (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) and
       not (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin {pila tnie kogos}
         if not dzwieki_ciagle.pilatniebardzo then begin
            form1.dzw_bronie_strzaly.Item[12].Play;
            dzwieki_ciagle.pilatniebardzo:=true;
         end;
         form1.dzw_bronie_strzaly.Item[12].xpos:=mysz.x/przeziledziel;
         form1.dzw_bronie_strzaly.Item[12].ypos:=mysz.y/przeziledziel;
         form1.dzw_bronie_strzaly.Item[12].Update;
    end else if dzwieki_ciagle.pilatniebardzo then begin
        form1.dzw_bronie_strzaly.Item[12].Stop;
        dzwieki_ciagle.pilatniebardzo:=false
    end;

end;

{rysowanie}
if (s<>0) and (bron.glownytryb=1) and (bron.dostrzalu=0) and
   (not (tryb_misji.wlaczony and not tryb_misji.rysowanie)) then begin
   case rysowanie.corobi of
     0:begin
       if m.l then rysuj_kolko_kol(m.x,m.y,rysowanie.rozmiar,rysowanie.kolor,rysowanie.twardosc);
       if m.r then rysuj_kolko_kol(m.x,m.y,rysowanie.rozmiar,$0,0);
       end;
     1:begin
       if m.l then rysuj_kolko_tex(m.x,m.y,rysowanie.rozmiar,rysowanie.twardosc);
       if m.r then rysuj_kolko_kol(m.x,m.y,rysowanie.rozmiar,$0,0);
       end;
     2:begin
       if m.l then begin
          for a:=0 to rysowanie.dlugosc-1 do begin
               cx:= m.x-obr.obiektpok.ofsx- trunc(
                    _sin(rysowanie.kat)*(a-(rysowanie.dlugosc-1)/2)*(rysowanie.odleglosci) );
               cy:= m.y-obr.obiektpok.ofsy+ trunc(
                    _cos(rysowanie.kat)*(a-(rysowanie.dlugosc-1)/2)*(rysowanie.odleglosci) );

               rysuj_obiekt(cx,cy,rysowanie.twardosc);
          end;


          bron.dostrzalu:=20;
       end;
       if (m.r) and (not s_mr) then begin
          rysowanie.odwrocony:=not rysowanie.odwrocony;
          bron.dostrzalu:=10;
       end;
       end;
     3:begin
       if (m.l) and (bron.tryb=0) then begin
          bron.mx:=m.x;
          bron.my:=m.y;
          bron.tryb:=1;
       end;
       if (bron.tryb=1) and (m.r) then bron.tryb:=0;
       end;
   end;
end;
{robienie trawy}
if (bron.glownytryb=1) and (bron.dostrzalu=0) and (bron.tryb=1) and (not m.l) then begin
   if not (tryb_misji.wlaczony and not tryb_misji.rysowanie) then 
      zrob_trawe(bron.mx,bron.my,m.x,m.y,rysowanie.cien.kolorg,rysowanie.cien.kolord,rysowanie.cien.efg,rysowanie.cien.efd,false);
   bron.tryb:=0;
end;

{stawianie wejscia}
if not (tryb_misji.wlaczony and not tryb_misji.zmianawejsc) then begin
  if (bron.glownytryb=2) and (menju.widoczne=4) and (m.l) then begin
     dodaj_wejscie(mysz.x+ekran.px,mysz.y+ekran.py);
     bron.dostrzalu:=100;
     bron.glownytryb:=0;
  end;
end;
if (bron.glownytryb=2) and (menju.widoczne=4) and (m.r) then begin
   bron.dostrzalu:=100;
   bron.glownytryb:=0;
end;

{stawianie swiatla}
if not (tryb_misji.wlaczony and not tryb_misji.rysowanie) then begin
  if (bron.glownytryb=4) and (menju.widoczne=1) and (m.l) then begin
     dodaj_swiatlo(mysz.x+ekran.px,mysz.y+ekran.py);
     bron.dostrzalu:=100;
     bron.glownytryb:=6;
  end;
end;
if (bron.glownytryb=4) and (menju.widoczne=1) and (m.r) then begin
   bron.dostrzalu:=100;
   bron.glownytryb:=6;
end;

end;


procedure sprawdz_dostepne_bronie;
var a:integer; b:boolean;
begin
if (gracz.pkt<>gracz._pkt) or (gracz.trupow<>gracz._trupow) or (gracz.paczek<>gracz._paczek) then begin
   gracz.punktyglobalne := gracz.punktyglobalne_od+gracz.pkt;
   gracz.trupyglobalne := gracz.trupyglobalne_od+gracz.trupow;
   gracz.paczkiglobalne := gracz.paczkiglobalne_od+gracz.paczek;

   for a:=0 to max_broni do begin
       b:=(gracz.punktyglobalne>=wymagane_do_broni[a].pkt) and
                          (gracz.trupyglobalne>=wymagane_do_broni[a].trup) and
                          (gracz.paczkiglobalne>=wymagane_do_broni[a].pacz);
       if b and not gracz.broniesa[a] then begin
          nowynapis(mysz.x+ekran.px,mysz.y+ekran.py, Gra_odblokowanabron+nazwy_broni[a]);
          nowynapiswrogu(Gra_odblokowanabron+nazwy_broni[a], 300);
       end;
       gracz.broniesa[a]:=b;
   end;

   //nowynapis(trunc(x),trunc(y),Gra_MEGASMIERC);

   gracz._pkt:=gracz.pkt;
   gracz._trupow:=gracz.trupow;
   gracz._paczek:=gracz.paczek;
end;
end;

procedure glowna_gra_ruch;
var a,b,c, zx,zy:integer; zdx:real;
begin
if kfg.efekty_soczewki then
  ile_flara := 0; //wyczysc flary w tej klatce

Zrodla_odswiez;

inc(licznik3);
if licznik3>=180 then begin
   dec(licznik3,180);
   sprawdz_dostepne_bronie;
end;
if (licznik3 mod 10=0) then begin
   inc(menju.aniklatka);
   if menju.aniklatka>=20{obr.aniikony[iko_num[bron.wybrana]].klatek} then menju.aniklatka:=0;
end;

listenerpos[0]:=(ekran.px+ekran.width div 2) /przeziledziel;
listenerpos[1]:=(ekran.py+ekran.height div 2) /przeziledziel;
AlListenerfv ( AL_POSITION, @listenerpos);

mysz.x:=mysz.x+mysz.dx;
mysz.y:=mysz.y+mysz.dy;

if licznik3 mod 2=0 then begin
    if mysz.dx>0 then dec(mysz.dx);
    if mysz.dx<0 then inc(mysz.dx);
    if mysz.dy>0 then dec(mysz.dy);
    if mysz.dy<0 then inc(mysz.dy);
end;

if not warunki.pauza then begin
{jak nie pauza}
    graj_dzwieki_pogody;

    inc(licznik2);
    if licznik2>=180 then begin
       dec(licznik2,180);
       {moze zrzucic paczke?}
       if ((warunki.czestpaczek>=1) and (random(84-warunki.czestpaczek*8)=0)) or
          (gracz.pkt>=gracz.pkt_pacz+20000) then begin

          if (gracz.pkt>=gracz.pkt_pacz+20000) then begin //paczka dla gracza
             c:=ile_przedm;
             gracz.pkt_pacz:=gracz.pkt;
          end else c:=random(ile_przedm); //paczki dla reszty

          if warunki.paczkidowolnie then b:=random(teren.height) else b:=0;
          a:=random(teren.width);
          if (a>=0) and (a<teren.width) and (teren.maska[a,b]=0) then begin
             if b=0 then b:=-30; //jesli z gory, to zacznij NAD ekranem
             nowyprzedmiot(a,b,random-0.5,-random,0,c);
             if b>=0 then
                nowywybuchdym(a,b,0,0,0,wd_swiatlo,1,200+random(50),80,$50e050);
             //form1.graj(form1.dzw_bronie_strzaly.Item[1],m.x,m.y,1000);
          end;
       end;
    end;
    {obsluga wody itp}
    if warunki.typ_wody>=1 then begin
       inc(licznik,2);
       if licznik>=360 then dec(licznik,360);
       warunki.wys_wody:=warunki.ust_wys_wody{+trunc(_sin(licznik)*5)};
       if random(40)=0 then
          nowybombel(random(teren.width),teren.height,0,0,random(200)+55,random(300)+30);

       case warunki.typ_wody of
        2:begin{lawa plonie}
          if random(2)=0 then begin
             a:=random(ekran.width)+ekran.px;
             if (a>=0) and (a<teren.width) and (teren.maska[a,warunki.wys_wody-1]=0) then begin
                if random(2)=0 then
                   strzel(a, warunki.wys_wody-1,-random+0.5,-random/1.6,
                          0,-1,10,5,4,-20-random(15),5,false,8+random(10),1)
                else
                   nowywybuchdym(a,warunki.wys_wody-2,random/2-0.25,-random*1.5,1,wd_dym,random(5),50+random(150),100+random(350));

             end;
          end else
          if random(10)=0 then begin
             a:=random(ekran.width)+ekran.px;
             if (a>=0) and (a<teren.width) and (teren.maska[a,warunki.wys_wody-1]=0) then begin
                for b:=0 to 1+random(5) do begin
                    nowysyf(a,warunki.wys_wody-1,
                            random(90)+random(2)*(180+random(90)),
                            random*8,
                            1,random(4),0,0,true, -1, 2);
                end;
             end;
          end;
          if random(100)=0 then begin
             a:=random(ekran.width)+ekran.px;
             if (a>=0) and (a<teren.width) and (teren.maska[a,warunki.wys_wody-1]=0) then begin
                zdx:=wyswody(a);
                for b:=0 to 5+random(15) do
                   nowysyf(a,zdx-2,(random*2-1),-abs(random*1.4+0.6),0,random(5),0,2,true, 0,warunki.typ_wody);
                plum(a,zdx+1,-0.75,9,25+random(25))
             end;

          end;
          end;
        3:begin{kwas sie pieni}
          a:=random(ekran.width)+ekran.px;
          if (a>=0) and (a<teren.width) and (teren.maska[a,warunki.wys_wody]=0) then
             nowybombel(a,wyswody(a)+1,0,random,random(200)+55,random(150)+30);
          if random(20)=0 then begin
             a:=random(ekran.width)+ekran.px;
             if (a>=0) and (a<teren.width) and (teren.maska[a,warunki.wys_wody-1]=0) then
                strzel(a,warunki.wys_wody-1,-random+0.5,-random-0.4,0,-1,20,16,14,0,16,true,120+random(40),10+random(60));
          end;
          end;
        4:begin{krew bulka}
          if random(20)=0 then begin
             a:=random(ekran.width)+ekran.px;
             if (a>=0) and (a<teren.width) and (teren.maska[a,warunki.wys_wody-1]=0) then begin
                for b:=0 to 3+random(6) do begin
                    nowysyf(a,warunki.wys_wody-1,
                            random(90)+random(2)*(180+random(90)),
                            random*3,
                            1,random(4),0,0,true, -1);
                end;
             end;
          end;
          end;
       end;

    end;

    if tryb_misji.wlaczony then ruszaj_flagi;

    ruszaj_kolesi;
    ruszaj_pociski;
    ruszaj_miny;
    ruszaj_syfki;
    ruszaj_wybuchydymy;
    ruszaj_przedmioty;
    ruszaj_mieso;
    ruszaj_ciezkie;
    ruszaj_zwierzaki;
    ruszaj_bomble;

    ruszaj_zwlokikolesi;

    ruszaj_chmury_deszcz_burze;

    ruszaj_napis;

    faledzialaj;
end else begin
{w czasie pauzy}
    pauza_czytaj_info;
    pauza_przenos_miny;
    pauza_przenos_przedmioty;
    pauza_przenos_zwierzaki;
    pauza_przenos_ciezkie;

    faledzialaj_pauza;
end;

{if (form1.PowerInput1.Keys[dik_r]) and (warunki.wiatr>-0.5) then warunki.wiatr:=warunki.wiatr-0.03;
if (form1.PowerInput1.Keys[dik_t]) and (warunki.wiatr<0.5) then warunki.wiatr:=warunki.wiatr+0.03;
}
mysz.jest_obracanie:= ((not (bron.wybrana in [0])) or
                       (bron.przenoszenie)) and
                      (bron.glownytryb=0);

if not (tryb_misji.wlaczony and tryb_misji.wstrzymana) then ruszaj;

sprawdz_kliki_menu_boczne;
case menju.widoczne of
   0:sprawdz_kliki_menu_bronie;
   1:begin
     if not (tryb_misji.wlaczony and not tryb_misji.rysowanie) then begin
        sprawdz_kliki_menu_rysowanie;
        if (kfg.swiatla) and (rysowanie.corobi=4) then dzialaj_swiatla;
     end;
     end;
   2:begin
     {sprawdzanie czy to misja jest wewnatrz procedury, bo niektore guziki zawsze dzialaja}
     {if not (tryb_misji.wlaczony and not tryb_misji.zmianawarunkow) then begin}
        sprawdz_kliki_menu_warunki;
     {end;}
     end;
   3:begin
     {sprawdzanie czy to misja jest wewnatrz procedury, bo niektore guziki zawsze dzialaja}
     {if not (tryb_misji.wlaczony and not tryb_misji.zmianadruzyn) then begin}
        sprawdz_kliki_menu_druzyny;
     {end;}
     end;
   4:begin
     if not (tryb_misji.wlaczony and not tryb_misji.zmianawejsc) then begin
        sprawdz_kliki_menu_wejscia;
        dzialaj_wejscia;
     end;
     end;
end;



if not warunki.pauza then begin
    if (kfg.trzesienie) and (ekran.iletrzes>0) then begin
    {   ekran.trzesx:=random(ekran.iletrzes)-ekran.iletrzes shr 1;
       ekran.trzesy:=random(ekran.iletrzes)-ekran.iletrzes shr 1;}
       ekran.trzesx:=trunc(_sin(trunc(ekran.iletrzes*30))*(ekran.iletrzes*ekran.silatrzes));
       ekran.trzesy:=trunc(_cos(trunc(ekran.iletrzes*30))*(ekran.iletrzes*ekran.silatrzes));
{       ekran.trzesx:=trunc(_sin(trunc(ekran.iletrzes*30))*(ekran.iletrzes*ekran.silatrzes));
       ekran.trzesy:=trunc(_cos(trunc(ekran.iletrzes*30))*(ekran.iletrzes*ekran.silatrzes));}
       dec(ekran.iletrzes);
    end else begin
        ekran.trzesx:=0;
        ekran.trzesy:=0;
        end;

    if bron.zemsta.leci then zemsta_dzialaj;
end;

if gracz.czas_dzialania_kombo>0 then begin
   dec(gracz.czas_dzialania_kombo);
   if gracz.czas_dzialania_kombo=0 then begin
      gracz.ostatnie_kombo:=gracz.kombo_licznik;
      if gracz.ostatnie_kombo>gracz.max_kombo then gracz.max_kombo:=gracz.ostatnie_kombo;
      inc(gracz.pkt,sqr(gracz.kombo_licznik+5)+100);
      if gracz.ostatnie_kombo>=2 then
         nowynapis(gracz.ostatnia_smierc_x,gracz.ostatnia_smierc_y-20,l2t(gracz.ostatnie_kombo,0)+Gra_xkombo);

   if (kfg.glos_zlego_pana) and (gracz.ostatnie_kombo>=2) then
      case gracz.ostatnie_kombo of
         2..3:form1.graj(form1.dzw_zly_pan.item[random(3)],mysz.x,mysz.y,5000);
         4..5:form1.graj(form1.dzw_zly_pan.item[1+random(2)*3],mysz.x,mysz.y,5000);
         6..8:form1.graj(form1.dzw_zly_pan.item[2+random(2)*3],mysz.x,mysz.y,5000);
         else begin
           case random(3) of
              0:b:=2;
              1:b:=3;
              2:b:=6;
              else b:=0;
           end;
           form1.graj(form1.dzw_zly_pan.item[b],mysz.x,mysz.y,5000);
         end;
     end;



      gracz.kombo_licznik:=0;
   end;
end;


{menu chowanie i pokazywanie}
if (ekran.menu_widoczne>=1) and (ekran.menux<obr.menud.ry-(ekran.menu_widoczne-1)*23) then begin
   inc(ekran.menux,10);
   if ekran.menux>obr.menud.ry-(ekran.menu_widoczne-1)*23 then ekran.menux:=obr.menud.ry-(ekran.menu_widoczne-1)*23;
end;
if (ekran.menu_widoczne>=1) and (ekran.menux>obr.menud.ry-(ekran.menu_widoczne-1)*23) then begin
   dec(ekran.menux,10);
   if ekran.menux<obr.menud.ry-(ekran.menu_widoczne-1)*23 then ekran.menux:=obr.menud.ry-(ekran.menu_widoczne-1)*23;
end;
if (ekran.menu_widoczne=0) and (ekran.menux>0) then begin
   dec(ekran.menux,10);
   if ekran.menux<0 then ekran.menux:=0;
end;

if (mysz.y>=ekran.height-ekran.menux) or (bron.glownytryb in [2..6]) then mysz.wyglad:=10
   else if bron.glownytryb in [1,4..6] then mysz.wyglad:=1
      else if bron.wybrana=49 then mysz.wyglad:=-1
        else if bron.wybrana=50 then mysz.wyglad:=-2
          else if bron.wybrana=0 then mysz.wyglad:=-3
            else mysz.wyglad:=0;

{przesuwanie ekranu}
if (((mysz.x=0) and
     ((mysz.y<ekran.height-ekran.menux) or (mysz.y=ekran.height-1))
    ) or
     (form1.PowerInput1.Keys[klawisze[0]])
   ) and
   (ekran.dx>-20) and (ekran.px>0)
   then ekran.dx:=ekran.dx-1
else
   if (((mysz.x>=ekran.Width-1) and
       ((mysz.y<ekran.height-ekran.menux) or (mysz.y=ekran.height-1)) and
       (ekran.px<teren.Width-ekran.Width))
       or
       (form1.PowerInput1.Keys[klawisze[1]])
       ) and
      (ekran.dx<20) and (ekran.px<teren.Width-ekran.Width) then ekran.dx:=ekran.dx+1
else
   if ekran.dx<>0 then begin
      if ekran.dx>0 then dec(ekran.dx)
         else inc(ekran.dx)
   end;
if ((mysz.y=0) or (form1.PowerInput1.Keys[klawisze[2]])) and
   (ekran.dy>-20) and (ekran.py>0)
   then ekran.dy:=ekran.dy-1
else
   if ((mysz.y>=mysz.dmarg) or (form1.PowerInput1.Keys[klawisze[3]])) and
      (ekran.dy<20) and (ekran.py<teren.Height-ekran.Height+ekran.menux)
   then ekran.dy:=ekran.dy+1
else
   if ekran.dy<>0 then begin
      if ekran.dy>0 then dec(ekran.dy)
         else inc(ekran.dy)
   end;

if (ekran.dx>0) then begin
   if (ekran.dy=0) then mysz.wyglad:=2
   else
   if (ekran.dy<0) then mysz.wyglad:=9
   else
                        mysz.wyglad:=3
end else
if (ekran.dx<0) then begin
   if (ekran.dy=0) then mysz.wyglad:=6
   else
   if (ekran.dy<0) then mysz.wyglad:=7
   else
                        mysz.wyglad:=5
end else begin
   if (ekran.dy<0) then mysz.wyglad:=8
   else
   if (ekran.dy>0) then mysz.wyglad:=4;
end;

ekran.px:=ekran.px+ekran.dx;
ekran.py:=ekran.py+ekran.dy;

{klawisze}
if (form1.PowerInput1.Keys[klawisze[4]]) and (warunki.gleb_wody<teren.height-2) and
   (not (tryb_misji.wlaczony and not tryb_misji.zmianawarunkow)) then begin
   inc(warunki.gleb_wody);
   warunki.ust_wys_wody:=teren.height-warunki.gleb_wody;
   warunki.wys_wody:=warunki.ust_wys_wody;
end;
if (form1.PowerInput1.Keys[klawisze[5]]) and (warunki.gleb_wody>1) and
   (not (tryb_misji.wlaczony and not tryb_misji.zmianawarunkow)) then begin
   dec(warunki.gleb_wody);
   warunki.ust_wys_wody:=teren.height-warunki.gleb_wody;
   warunki.wys_wody:=warunki.ust_wys_wody;
end;

if (form1.PowerInput1.KeyPressed[klawisze[17]]) and (bron.przenoszenie) then begin
   for a:=0 to max_kol do
       if koles[a].przenoszony then begin
          koles[a].przenoszony:=false;
          koles[a].dx:=_sin(trunc(bron.kat))*bron.sila/4;
          koles[a].dy:=-_cos(trunc(bron.kat))*bron.sila/4;
       end;
   for a:=0 to max_mina do
       if mina[a].przenoszony then begin
          mina[a].przenoszony:=false;
          mina[a].dx:=_sin(trunc(bron.kat))*bron.sila/4;
          mina[a].dy:=-_cos(trunc(bron.kat))*bron.sila/4;
       end;
   for a:=0 to max_przedm do
       if przedm[a].przenoszony then begin
          przedm[a].przenoszony:=false;
          przedm[a].dx:=_sin(trunc(bron.kat))*bron.sila/4;
          przedm[a].dy:=-_cos(trunc(bron.kat))*bron.sila/4;
       end;
   for a:=0 to max_zwierz do
       if zwierz[a].przenoszony then begin
          zwierz[a].przenoszony:=false;
          zwierz[a].dx:=_sin(trunc(bron.kat))*bron.sila/4;
          zwierz[a].dy:=-_cos(trunc(bron.kat))*bron.sila/4;
       end;
   for a:=0 to max_ciezkie do
       if ciezkie[a].przenoszony then begin
          ciezkie[a].przenoszony:=false;
          ciezkie[a].dx:=_sin(trunc(bron.kat))*bron.sila/10;
          ciezkie[a].dy:=-_cos(trunc(bron.kat))*bron.sila/10;
       end;
   bron.przenoszenie:=false;
end;
if (not tryb_misji.wlaczony or tryb_misji.przenoszenie) and (form1.PowerInput1.KeyReleased[klawisze[18]]) and (bron.przenoszenie) then begin
   for a:=0 to max_kol do if koles[a].przenoszony then koles[a].przenoszony:=false;
   for a:=0 to max_mina do if mina[a].przenoszony then mina[a].przenoszony:=false;
   for a:=0 to max_przedm do if przedm[a].przenoszony then przedm[a].przenoszony:=false;
   for a:=0 to max_zwierz do if zwierz[a].przenoszony then zwierz[a].przenoszony:=false;
   for a:=0 to max_ciezkie do if ciezkie[a].przenoszony then ciezkie[a].przenoszony:=false;
   bron.przenoszenie:=false;
end;
if (not tryb_misji.wlaczony or tryb_misji.przenoszenie) and (form1.PowerInput1.KeyPressed[klawisze[18]]) then begin
   if not (tryb_misji.wlaczony and not tryb_misji.dziala_kursor) then
      bron.przenoszenie:=true;
end;
if form1.PowerInput1.KeyPressed[klawisze[20]] then begin
   b:=-1;
   a:=0;
   while (a<=max_kol) and (b=-1) do begin
       if koles[a].jest and
          (koles[a].x-ekran.px+15>=mysz.x) and
          (koles[a].x-ekran.px-15<=mysz.x) and
          (koles[a].y-ekran.py+15>=mysz.y) and
          (koles[a].y-ekran.py-15<=mysz.y) then b:=a;
       inc(a);
   end;
   bron.sterowanie:=b;
end;

{sterowanie wybranym kolesiem}
if (bron.sterowanie>=0) and (koles[bron.sterowanie].jest) then with koles[bron.sterowanie] do begin
   {ruch ekranu}
   if (x>ekran.px+ekran.width-ekran.width shr 2) then begin
      ekran.px:=trunc(x)-ekran.width+ekran.width shr 2;
      if (ekran.width<teren.Width) and
         (ekran.px>teren.Width-ekran.width) then ekran.px:=teren.Width-ekran.width;
   end;
   if (x<ekran.px+ekran.width shr 2) then begin
      ekran.px:=trunc(x)-ekran.width shr 2;
      if (ekran.width<teren.Width) and
         (ekran.px<0) then ekran.px:=0;
   end;

   if (y>ekran.py+ekran.height-ekran.menux-ekran.height shr 2) then begin
      ekran.py:=trunc(y)-ekran.height+ekran.menux+ekran.height shr 2;
      if (ekran.height-ekran.menux<teren.height) and
         (ekran.py>teren.height-ekran.height+ekran.menux) then ekran.py:=teren.height-ekran.height+ekran.menux;
   end;
   if (y<ekran.py+ekran.height shr 2) then begin
      ekran.py:=trunc(y)-ekran.height shr 2;
      if (ekran.height-ekran.menux<teren.height) and
         (ekran.py<0) then ekran.py:=0;
   end;
   {klawisze}
   if not (corobi in [cr_obracasie,cr_spada]) then begin
       if (form1.PowerInput1.Keys[klawisze[6]]) and
          (corobi in [cr_idzie,cr_biegnie,cr_stoi]) and
          ((warunki.typ_wody=0) or (y<warunki.wys_wody+5)) then skocz:=true
       else
       if (form1.PowerInput1.Keys[klawisze[7]]) and
          (warunki.typ_wody>=1) and (y>=warunki.wys_wody+5) and (dy>-0.5) then dy:=dy-0.3
       else
       if (form1.PowerInput1.Keys[klawisze[8]]) and
          (warunki.typ_wody>=1) and (y>=warunki.wys_wody+5) and (dy<0.5) then dy:=dy+0.3;
       if form1.PowerInput1.Keys[klawisze[9]] then begin
          kierunek:=-1;
          if corobi<>cr_plynie then begin
             if (warunki.typ_wody>=1) and (y>=warunki.wys_wody+5) then corobi:=cr_plynie
             else
             if form1.PowerInput1.Keys[klawisze[11]] then corobi:=cr_biegnie
                                                    else corobi:=cr_idzie;
          end;
       end else
       if form1.PowerInput1.Keys[klawisze[10]] then begin
          kierunek:=1;
          if corobi<>cr_plynie then begin
             if (warunki.typ_wody>=1) and (y>=warunki.wys_wody+5) then corobi:=cr_plynie
             else
             if form1.PowerInput1.Keys[klawisze[11]] then corobi:=cr_biegnie
                                                    else corobi:=cr_idzie;
          end;
       end else
       if form1.PowerInput1.Keys[klawisze[12]] then begin
          corobi:=cr_grzywa;
          cochcekopnac:=3;
          ktoregochcekopnac:=-1;
       end else
       if form1.PowerInput1.Keys[klawisze[13]] then begin
          corobi:=cr_bije;
          cochcekopnac:=3;
          ktoregochcekopnac:=-1;
       end else
       if form1.PowerInput1.Keys[klawisze[14]] then begin
          corobi:=cr_kopie;
          cochcekopnac:=3;
          ktoregochcekopnac:=-1;
       end else
       if form1.PowerInput1.Keys[klawisze[15]] then begin
          if amunicja>0 then corobi:=cr_strzela;
       end else begin
           if corobi in [cr_idzie,cr_biegnie,cr_plynie] then corobi:=cr_stoi;
       end;
   end;
end;
{--}

{jeszcze granice przesuwania ekranu}
if ekran.px<0 then ekran.px:=0;
if ekran.px>teren.Width-ekran.Width then ekran.px:=teren.Width-ekran.Width;
if ekran.py<0 then ekran.py:=0;
if ekran.py>teren.Height-ekran.Height+ekran.menux then ekran.py:=teren.Height-ekran.Height+ekran.menux;

if teren.width<=ekran.width then
   ekran.px:=-(ekran.width-teren.width) div 2;
if teren.height<=ekran.height-ekran.menux then
   ekran.py:=-((ekran.height-ekran.menux)-teren.height) div 2;

{wybor broni ulubionych}
if mysz.y<ekran.height-ekran.menux then begin
   for a:=0 to 9 do
       if (form1.PowerInput1.Keys[$02+a]) and
          (bron.ulubiona[a]>=0) then begin
          bron.wybrana:=bron.ulubiona[a];
          form1.zmienobrazkiikonbroni;
       end;
end;

{zbieranie min}
if (form1.PowerInput1.Keys[klawisze[16]]) and
   (not (tryb_misji.wlaczony and not tryb_misji.dziala_kursor)) then
  for a:=0 to max_mina do
      if (mina[a].jest) and
         (mina[a].x>=mysz.x-4+ekran.px) and (mina[a].x<=mysz.x+4+ekran.px) and
         (mina[a].y>=mysz.y-4+ekran.py) and (mina[a].y<=mysz.y+4+ekran.py) then mina[a].jest:=false;

{zwierzaki same}
if not warunki.pauza and warunki.zwierzeta_same and (random(70)=0) then begin
   zx:=-1;
   zy:=-1;
   case random(4) of
      0:begin {gora}
        zx:=random(teren.width);
        zy:=0;
        end;
      1:if warunki.typ_wody in [1,4,5] then begin {dol}
        zx:=random(teren.width);
        zy:=teren.height-1;
        end;
      2:begin {lewo}
        zx:=0;
        zy:=random(teren.height)
        end;
      3:begin {prawo}
        zx:=teren.width-1;
        zy:=random(teren.height)
        end;
   end;
   if (zx>=0) and (zy>=0) and (teren.maska[zx,zy]=0) then begin
      if (warunki.typ_wody>=1) and (zy>=warunki.wys_wody) then begin
         case random(2) of {wodne}
            0:b:=1;
            1:b:=3;
         end;
      end else
         case random(3) of {nadwodne - ptaki itp}
            0:b:=0;
            1:b:=2;
            2:b:=4;
         end;

      {zamieniaj w dzien nietoperze na motylki}
      if (b=0) and (warunki.godzina>=900) and (warunki.godzina<=1900) then b:=4;

      nowyzwierzak(zx,zy,random-0.5,random-0.5,b);
   end;
end;

{smieci z boku ekranu w czasie wiatru}
if not warunki.pauza and (abs(warunki.wiatr)>0.2) and (random(10)=0) then begin
   zy:=random(teren.height);
   if warunki.wiatr>=0 then begin {lewo}
      zx:=0;
      zdx:=(30+random*50)*warunki.wiatr;
   end else begin {prawo}
      zx:=teren.width-1;
      zdx:=(30+random*50)*warunki.wiatr;
   end;

   if (zx>=0) and (zy>=0) and (teren.maska[zx,zy]=0) then
      if (warunki.typ_wody=0) or (zy<warunki.wys_wody) then begin
          nowysyf(zx,zy,zdx,random*5-3.5,
                  0,random(5),0,1,false);
      end;
end;


if (not warunki.pauza) then tworz_kolesi_jak_trzeba;
   //and (kol_il<il) and (random(10)=0) then nowykoles(random(teren.Width-koles_rx)+koles_prx,-30,0,0,-1,random(max_druzyn));

if form1.PowerInput1.KeyPressed[klawisze[19]] then begin
   warunki.pauza:=not warunki.pauza;
end;

if form1.PowerInput1.KeyPressed[klawisze[21]] then begin
   inc(ekran.menu_widoczne);
   if ekran.menu_widoczne>3 then ekran.menu_widoczne:=0;
end;
if form1.PowerInput1.KeyPressed[klawisze[22]] then begin
   inc(menju.widoczne);
   if menju.widoczne>=5 then menju.widoczne:=0;
   ustaw_menu_widoczne;
end;
if form1.PowerInput1.KeyPressed[klawisze[23]] then begin
   case menju.widoczne of
     1:begin
        inc(rysowanie.corobi);
        if rysowanie.corobi>=5 then rysowanie.corobi:=0;
       end;
     3:begin
        inc(druzynymenu.wybrana);
        if druzynymenu.wybrana>max_druzyn then druzynymenu.wybrana:=0;
       end;
     4:begin
        inc(druzynymenu.wejsciewybrane);
        if druzynymenu.wejsciewybrane>druzynymenu.ilewejsc then begin
           {if druzynymenu.ilewejsc>=1 then druzynymenu.wejsciewybrane:=1
                                      else }
           druzynymenu.wejsciewybrane:=0;
        end;
       end;
   end;
end;


if tryb_misji.wlaczony then obsluz_misje;

if kfg.chowaj_liczniki and
   (form1.PowerInput1.KeyPressed[klawisze[24]]) then ekran.czasniezmienionychwynikow:=0;

if ekran.pokazuj_wyniki and (ekran.czasniezmienionychwynikow<400) then
   inc(ekran.czasniezmienionychwynikow);

if licznik2 mod niebo.kolorytlaszybkosc=0 then begin
   if not warunki.pauza then warunki.godzina:= warunki.godzina+1;
   if warunki.godzina>=2400 then warunki.godzina:=0;

   zmieniaj_niebo;

   niebo.slonce.x:=trunc( niebo.tlowidth/2- sin((warunki.godzina*0.12)*pi180)*(niebo.tlowidth/2-40) );
   niebo.slonce.y:=trunc( niebo.tloheight+ cos((warunki.godzina*0.12)*pi180)*(niebo.tloheight-100) );
   niebo.ksiezyc.x:=trunc( niebo.tlowidth/2- sin((((warunki.godzina+1200) mod 2400)*0.13)*pi180)*(niebo.tlowidth/2-40) );
   niebo.ksiezyc.y:=trunc( niebo.tloheight+ cos((((warunki.godzina+1200) mod 2400)*0.13)*pi180)*(niebo.tloheight-140) );
   for a:=0 to high(niebo.gwiazdy) do begin
       niebo.gwiazdy[a].x:=trunc( niebo.tlowidth/2- sin((((warunki.godzina+1200) mod 2400) *0.03+niebo.gwiazdy[a].kat)*pi180)*niebo.gwiazdy[a].odl );
       niebo.gwiazdy[a].y:=trunc( niebo.tloheight+600+ cos((((warunki.godzina+1200) mod 2400)*0.03+niebo.gwiazdy[a].kat)*pi180)*niebo.gwiazdy[a].odl );
   end;
end;

end;

procedure glowna_gra_pokaz;
const
kolorymaski:array[1..10] of cardinal=
           ($FFc0c0c0, $FFb0b0b0, $FFa0a0a0, $FF909090, $FF808080,
            $FF707070, $FF606060, $FF505050, $FF404040, $FF308030);
var
a,b:integer;
tr,tr2:trect;
cx,cy:integer;
snajp:boolean;
kol:cardinal;

begin
if (teren.width<ekran.width) or (teren.height<ekran.height-ekran.menux) then
   form1.PowerDraw1.Clear($FF000000);
 form1.PowerDraw1.BeginScene();

 if teren.width<=ekran.width then begin
    tr.Left:=(ekran.width-teren.width) div 2;
    tr.Right:=tr.Left+teren.width;
 end else begin
    tr.Left:=0;
    tr.Right:=ekran.width;
 end;
 if teren.height<=ekran.height-ekran.menux then begin
    tr.Top:=((ekran.height-ekran.menux)-teren.height) div 2;
    tr.Bottom:=tr.Top+teren.height;
 end else begin
    tr.Top:=0;
    tr.Bottom:=ekran.height-ekran.menux;
 end;
 //tr:=rect(0,0,ekran.width,ekran.height-ekran.menux);

 if (bron.glownytryb=0) and
    (bron.wybrana=29) and
    (mysz.x>=tr.Left) and (mysz.x<tr.Right) and
    (mysz.y>=tr.Top) and (mysz.y<tr.Bottom) then begin
    form1.PowerDraw1.Clear($FF000000);
    if mysz.r then tr2:=rect(mysz.x-210,mysz.y-210,mysz.x+210,mysz.y+210)
              else tr2:=rect(mysz.x-70,mysz.y-70,mysz.x+70,mysz.y+70);
    if tr2.Left<tr.Left then tr2.Left:=tr.Left;
    if tr2.Top<tr.Top then tr2.Top:=tr.Top;
    if tr2.Right>=tr.Right then tr2.Right:=tr.Right;
    if tr2.Bottom>=tr.Bottom then tr2.Bottom:=tr.Bottom;
    snajp:=true;
    form1.PowerDraw1.ClipRect:=tr2;
 end
 else begin
      snajp:=false;
      form1.PowerDraw1.ClipRect:=tr;
      end;

{pozostalosci po pokazywaniu obrazka w tle: (raczej do skasowania)
    if not kfg.tlo_obrazek then begin}
       //form1.PowerDraw1.Clear(kfg.tlo_kolor)
       pokaz_niebo;
{    end else begin}
(*        b:=0;
        cy:=0;
        while b<ekran.Height do begin
            a:=0;
            cx:=0;
            while a<ekran.Width do begin
               if cx=0 then begin
                  tr.Left:=-trunc(ekran.px*teren.tlododx)+a;
                  tr.Right:=-trunc(ekran.px*teren.tlododx)+a+teren.tlowidth;
               end else begin
                  tr.Right:=-trunc(ekran.px*teren.tlododx)+a;
                  tr.Left:=-trunc(ekran.px*teren.tlododx)+a+teren.tlowidth;
               end;
               if cy=0 then begin
                  tr.Top:=-trunc(ekran.py*teren.tlodody)+b;
                  tr.Bottom:=-trunc(ekran.py*teren.tlodody)+b+teren.tloheight;
               end else begin
                  tr.Bottom:=-trunc(ekran.py*teren.tlodody)+b;
                  tr.Top:=-trunc(ekran.py*teren.tlodody)+b+teren.tloheight;
               end;
//                  form1.PowerDraw1.TextureMap(obr.tlo.surf, pRect4(tr), cWhite4, tPattern(0), 0);
                  {form1.PowerDraw1.RenderEffect(obr.tlo[0].surf,
                           -trunc(ekran.px*teren.tlododx)+a,
                           -trunc(ekran.py*teren.tlodody)+b,
                           0,0);}
                  inc(a,teren.tlowidth);
                  inc(cx);if cx>=2 then cx:=0;
            end;
            inc(b,teren.tloheight);
            inc(cy);if cy>=2 then cy:=0;
        end;

        {a:=0;
        while a<ekran.Width*teren.tlododx*4 do begin
              form1.drawsprajt(obr.tlo[1],
                      -trunc(ekran.px*teren.tlododx*2)+a,
                      -trunc(ekran.py*teren.tlodody*2-teren.height*teren.tlodody*4),
                      0);
              inc(a,obr.tlo[1].rx);
        end;}*)
{    end;}

    if warunki.chmurki then rysuj_chmurki(true);

    if (bron.glownytryb=1) and (rysowanie.pokaz_maske) then begin
      for cy:=ekran.py to ekran.py+ekran.height-1-ekran.menux do
          for cx:=ekran.px to ekran.px+ekran.width-1 do
              if (cx>=0) and (cy>=0) and (cx<teren.width) and (cy<teren.height) and
                 (teren.maska[cx,cy]<>0) then
                 form1.PowerDraw1.PutPixel(cx-ekran.px,cy-ekran.py,kolorymaski[teren.maska[cx,cy]],0);
    end else begin
      //  form1.PowerDraw1.RenderEffectCol(obr.teren.surf,-ekran.px+ekran.trzesx+7,-ekran.py+ekran.trzesy+7,$70303030,0,effectsrcalpha or effectdiffuse);
        if (kfg.swiatla) then pokazuj_swiatla(true);
        if teren.ilex>=1 then begin
        for b{y}:=0 to teren.ileekry do
            for a{x}:=0 to teren.ileekrx do
                {form1.PowerDraw1.RenderEffect(obr.teren.surf,
                        ekran.trzesx+ a*128 -ekran.px mod 128,
                        ekran.trzesy+ b*128 -ekran.py mod 128,
                         (a+ekran.px div 128)+
                         (b+ekran.py div 128)*teren.ilex,
                        effectsrcalpha);}
                form1.PowerDraw1.TextureMap(obr.teren.surf, pBounds4(
                        ekran.trzesx+ a*128 -ekran.px mod 128,
                        ekran.trzesy+ b*128 -ekran.py mod 128, 128,128),
                         ccolor1(niebo.kolorterenu),
                         tPattern((a+ekran.px div 128)+
                         (b+ekran.py div 128)*teren.ilex),
                        effectsrcalpha);
        end else begin
{            form1.PowerDraw1.RenderEffect(obr.teren.surf,
                    -ekran.px+ekran.trzesx,-ekran.py+ekran.trzesy,
                     0, effectsrcalpha);}
            form1.PowerDraw1.TextureMap(obr.teren.surf,pBounds4(
                    -ekran.px+ekran.trzesx,-ekran.py+ekran.trzesy, obr.teren.rx, obr.teren.ry),
                     cColor1(niebo.kolorterenu),tPattern(0), effectsrcalpha OR effectDiffuse);
        end;
    end;

    if tryb_misji.wlaczony then rysuj_flagi;

    rysuj_przedmioty;
    rysuj_kolesi;
    rysuj_miny;
    rysuj_mieso;
    rysuj_mieso_na_terenie;
    rysuj_ciezkie;
    rysuj_ciezkie_na_terenie;
    rysuj_zwierzaki;
    rysuj_syfki;
    rysuj_syfki_na_terenie;
    rysuj_pociski;
    if (bron.laserdlugosc>0) then begin //rysuj lasery itd oraz wlaczaj im dzwieki
       rysuj_lasery_itd;
       if not kfg.calkiem_bez_dzwiekow and kfg.jest_dzwiek then begin
         if bron.wybrana=41 then begin //laser
            if not dzwieki_ciagle.laser then begin //laser
              form1.dzw_bronie_strzaly.Item[6].gain:=0.6+bronmenuuklad[41][0].wartosc/10;
              form1.dzw_bronie_strzaly.Item[6].pitch:=1+bronmenuuklad[41][0].wartosc/20;
              form1.dzw_bronie_strzaly.Item[6].Play;
              dzwieki_ciagle.laser:=true;
            end;
            form1.dzw_bronie_strzaly.Item[6].xpos:=(mysz.x+ekran.px)/przeziledziel;
            form1.dzw_bronie_strzaly.Item[6].ypos:=(mysz.y+ekran.py)/przeziledziel;
            form1.dzw_bronie_strzaly.Item[6].Update;
         end else
         if bron.wybrana=42 then begin //prad
            if not dzwieki_ciagle.prad then begin //prad
              form1.dzw_bronie_strzaly.Item[7].gain:=0.6+bronmenuuklad[42][0].wartosc/10;
              form1.dzw_bronie_strzaly.Item[7].pitch:=0.8+bronmenuuklad[42][0].wartosc/25;
              form1.dzw_bronie_strzaly.Item[7].Play;
              dzwieki_ciagle.prad:=true;
            end;
            form1.dzw_bronie_strzaly.Item[7].xpos:=mysz.x/przeziledziel;
            form1.dzw_bronie_strzaly.Item[7].ypos:=mysz.y/przeziledziel;
            form1.dzw_bronie_strzaly.Item[7].Update;
         end;
       end;
    end else begin //wylaczaj dzwieki laserow
       if not kfg.calkiem_bez_dzwiekow then begin
           if dzwieki_ciagle.laser then begin //laser
              form1.dzw_bronie_strzaly.Item[6].Stop;
              dzwieki_ciagle.laser:=false;
           end;
           if dzwieki_ciagle.prad then begin //prad
              form1.dzw_bronie_strzaly.Item[7].Stop;
              dzwieki_ciagle.prad:=false;
           end;
       end;
    end;
    if (bron.piorun_dostrzalu>0) then rysuj_piorun;
    rysuj_bomble;
    rysuj_wybuchydymy;


    if warunki.deszcz or warunki.snieg then rysuj_deszcz;
    if warunki.chmurki then rysuj_chmurki(false);

    {rysuj line laczaca kursor myszy i stawiana mine na linie}
    if (bron.wybrana=19) and (bron.tryb=1) then begin
       form1.drawsprajt( obr.mina[3],
                       bron.mx-ekran.px+ekran.trzesx-obr.mina[3].ofsx,
                       bron.my-ekran.py+ekran.trzesy-obr.mina[3].ofsy,
                       0);
       form1.PowerDraw1.wuLine( point(bron.mx-ekran.px+ekran.trzesx,bron.my-ekran.py+ekran.trzesy),
                              point(mysz.x,mysz.y),
                              $ff808080,$ff808080,0);

    end;

    {woda}
    if warunki.typ_wody>=1 then begin
       if warunki.wys_wody-ekran.py-5<=ekran.height then begin
          tr.Left:=0;
          tr.Right:=ekran.width;

          case warunki.typ_wody of
            1:begin{woda}
              {a:=-obr.woda.rx;
              while a<ekran.Width do begin
                 Form1.PowerDraw1.RenderEffect(obr.woda.surf,a+(licznik*2) mod 360,warunki.wys_wody-ekran.py-5,0,effectSrcAlpha);
                 inc(a,obr.woda.rx);
              end;
              for a:=0 to 19 do begin
                tr.Top:=warunki.wys_wody-ekran.py+trunc((warunki.gleb_wody/20)*a)+5;
                if a<19 then tr.Bottom:=warunki.wys_wody-ekran.py+trunc((warunki.gleb_wody/20)*(a+1))+5
                       else tr.Bottom:=ekran.height;
                if tr.top<=ekran.height-1 then begin
                   form1.PowerDraw1.FillRect( tr,
                                       cardinal( (($47+a*2) shl 24) or (($FF-a*4) shl 16) or (($A0-a*4) shl 8) or ($50-a) ),
                                       effectSrcAlpha  );
                end;
              end;}

               rysujfale($47FFA050);

               for a:=0 to 19 do begin
                  tr.Top:=warunki.wys_wody+30-ekran.py+trunc((warunki.gleb_wody/20)*a);
                  if a<19 then tr.Bottom:=warunki.wys_wody+30-ekran.py+trunc((warunki.gleb_wody/20)*(a+1))
                         else tr.Bottom:=ekran.height;
                  if tr.top<=ekran.height-1 then begin
                     form1.PowerDraw1.FillRect( tr,
                                         cardinal( (($47+a*2) shl 24) or (($FF-a*4) shl 16) or (($A0-a*4) shl 8) or ($50-a) ),
                                         effectSrcAlpha  );
                  end;
               end;


              end;
            2:begin {lawa}
              {a:=-obr.woda.rx;
              while a<ekran.Width do begin
                 Form1.PowerDraw1.RenderEffect(obr.lawa.surf,a+(licznik*2) mod 360,warunki.wys_wody-ekran.py-5,0,effectSrcAlpha);
                 inc(a,obr.woda.rx);
              end;}
              rysujfale($98000bb3);
              for a:=0 to 19 do begin
                tr.Top:=warunki.wys_wody-ekran.py+trunc((warunki.gleb_wody/20)*a)+30;
                if a<19 then tr.Bottom:=warunki.wys_wody-ekran.py+trunc((warunki.gleb_wody/20)*(a+1))+30
                       else tr.Bottom:=ekran.height;
                if tr.top<=ekran.height-1 then begin
                   form1.PowerDraw1.FillRect( tr,
                                       cardinal( (($98+a*2) shl 24) or (($70-(19-a)*5) shl 8) or ($FF-(19-a)*4) ),
                                       effectSrcAlpha  );
                end;
              end;
              end;
            3:begin {radioaktywny kwas}
              {a:=-obr.woda.rx;
              while a<ekran.Width do begin
                 Form1.PowerDraw1.RenderEffectcol(obr.kwas.surf,a+(licznik*2) mod 360,warunki.wys_wody-ekran.py-5,
                 (($68) shl 24) or (($30) shl 16) or (($A0) shl 8) or ($50+trunc(_sin(2*licznik)*20))
                 ,0,effectSrcAlpha or effectdiffuse);
                 inc(a,obr.woda.rx);
              end;}
              rysujfale(cardinal($6830a050+trunc(_sin(2*licznik)*20)));
              for a:=0 to 19 do begin
                tr.Top:=warunki.wys_wody-ekran.py+trunc((warunki.gleb_wody/20)*a)+30;
                if a<19 then tr.Bottom:=warunki.wys_wody-ekran.py+trunc((warunki.gleb_wody/20)*(a+1))+30
                       else tr.Bottom:=ekran.height;
                if tr.top<=ekran.height-1 then begin
                   form1.PowerDraw1.FillRect( tr,
                                       cardinal( (($68+a*2) shl 24) or (($30-a) shl 16) or (($A0-a*4) shl 8) or ($50+trunc(_sin(2*licznik)*20)-a) ),
                                       effectSrcAlpha  );
                end;
              end;
              end;
            4:begin{krew}
              {a:=-obr.woda.rx;
              while a<ekran.Width do begin
                 Form1.PowerDraw1.RenderEffect(obr.krew.surf,a+(licznik*2) mod 360,warunki.wys_wody-ekran.py-5,0,effectSrcAlpha);
                 inc(a,obr.woda.rx);
              end;}
              rysujfale($880020ef);
              for a:=0 to 19 do begin
                tr.Top:=warunki.wys_wody-ekran.py+trunc((warunki.gleb_wody/20)*a)+30;
                if a<19 then tr.Bottom:=warunki.wys_wody-ekran.py+trunc((warunki.gleb_wody/20)*(a+1))+30
                       else tr.Bottom:=ekran.height;
                if tr.top<=ekran.height-1 then begin
                   form1.PowerDraw1.FillRect( tr,
                                       cardinal( (($88+a*4) shl 24) or (($20-a div 2) shl 8) or ($EF-a*3) ),
                                       effectSrcAlpha  );
                end;
              end;
              end;
            5:begin{blotko}
              {a:=-obr.woda.rx;
              while a<ekran.Width do begin
                 Form1.PowerDraw1.RenderEffect(obr.bloto.surf,a+(licznik*2) mod 360,warunki.wys_wody-ekran.py-5,0,effectSrcAlpha);
                 inc(a,obr.woda.rx);
              end;}
              rysujfale($c7204050);
              for a:=0 to 19 do begin
                tr.Top:=warunki.wys_wody-ekran.py+trunc((warunki.gleb_wody/20)*a)+30;
                if a<19 then tr.Bottom:=warunki.wys_wody-ekran.py+trunc((warunki.gleb_wody/20)*(a+1))+30
                       else tr.Bottom:=ekran.height;
                if tr.top<=ekran.height-1 then begin
                   form1.PowerDraw1.FillRect( tr,
                                       cardinal( (($C7+a*2) shl 24) or (($20-a) shl 16) or (($40-a) shl 8) or ($50-a) ),
                                       effectSrcAlpha  );
                end;
              end;
              end;
          end;


       end;
    end;

    {pokaz swiatla}
    if (kfg.swiatla) then pokazuj_swiatla(false);

    rysuj_zwlokikolesi;

    {pokaz wejscia}
    if (menju.widoczne=4) then pokazuj_wejscia;

    if kfg.efekty_soczewki then rysuj_flary;
    
    {rysuj celownik snajperski}
    if snajp then begin
       if mysz.r then begin
          tr2:=rect(mysz.x-211,mysz.y-211,mysz.x+211,mysz.y+211);
          form1.PowerDraw1.FillRect(tr2,cColor1($7000FF00), effectSrcAlpha or effectdiffuse);
          form1.PowerDraw1.TextureMap(obr.snajper.surf,pRect4(tr2),cColor1($A000FF00), tPattern(0), effectSrcAlpha);
       end else begin
            tr2:=rect(mysz.x-70,mysz.y-70,mysz.x+70,mysz.y+70);
            form1.PowerDraw1.TextureMap(obr.snajper.surf,pRect4(tr2),cWhite4, tPattern(0), effectSrcAlpha);
            end;
//       Form1.drawsprajt(obr.snajper,mysz.x-70,mysz.y-70,0);
    end;

    {rysuj przezroczyste kolko w miejscu rysowania}
    if (bron.glownytryb=1) and (mysz.y<ekran.height-ekran.menux) then begin
       case rysowanie.corobi of
         0,1:begin {rys,tex}
           if rysowanie.corobi=1 then kol:=$70808689
              else kol:=cardinal($70000000 or
                                    (rysowanie.kolor and $000000FF) shl 16 or
                                    (rysowanie.kolor and $0000FF00) or
                                    (rysowanie.kolor and $00FF0000) shr 16);

           if rysowanie.ksztaltpedzla=0 then begin
              form1.PowerDraw1.circle(mysz.x,mysz.y,rysowanie.rozmiar,rysowanie.rozmiar,kol,effectSrcAlpha);
              if rysowanie.maskowanie in [1,2] then
                 form1.PowerDraw1.circle(mysz.x,mysz.y,rysowanie.rozmiar,0,$FF20b020,0);
              if rysowanie.maskowanie in [0,2] then
                 form1.PowerDraw1.circle(mysz.x,mysz.y,rysowanie.rozmiar-1,0,$FFc0c0c0,0);
           end else begin
              form1.PowerDraw1.Rectangle(mysz.x-rysowanie.rozmiar,mysz.y-rysowanie.rozmiar,
                                         2*rysowanie.rozmiar,2*rysowanie.rozmiar,
                                         $00000000,kol,effectSrcAlpha);
              if rysowanie.maskowanie in [1,2] then
              form1.PowerDraw1.Rectangle(mysz.x-rysowanie.rozmiar,mysz.y-rysowanie.rozmiar,
                                         2*rysowanie.rozmiar,2*rysowanie.rozmiar,
                                         $FF20b020,$00000000,0);
              if rysowanie.maskowanie in [0,2] then
              form1.PowerDraw1.Rectangle(mysz.x-rysowanie.rozmiar+1,mysz.y-rysowanie.rozmiar+1,
                                         2*rysowanie.rozmiar-2,2*rysowanie.rozmiar-2,
                                         $FFc0c0c0,$00000000,0);
           end;
           end;
         2:begin {obiekty}
           if rysowanie.odwrocony then b:=-1 else b:=1;
           for a:=0 to rysowanie.dlugosc-1 do begin
               cx:= mysz.x+(-b)*obr.obiektpok.ofsx- trunc(
                    _sin(rysowanie.kat)*(a-(rysowanie.dlugosc-1)/2)*(rysowanie.odleglosci) );
               cy:= mysz.y-obr.obiektpok.ofsy+ trunc(
                    _cos(rysowanie.kat)*(a-(rysowanie.dlugosc-1)/2)*(rysowanie.odleglosci) );

                  form1.PowerDraw1.TextureMap(obr.obiektpok.surf,
                     pBounds4(cx,cy,b*obr.obiektpok.rx,obr.obiektpok.ry),
                     ccolor1($64ffffff),
                     tPattern(0),
                     effectSrcAlpha or effectDiffuse)
           end;
           end;

       end;
    end;
    {rysuj prostokat zaznaczajacy do cieniowania}
    if (bron.glownytryb=1) and (rysowanie.corobi=3) and (bron.tryb=1) then
       form1.PowerDraw1.Rectangle(bron.mx-ekran.px,
                                  bron.my-ekran.py,
                                  mysz.x-bron.mx+ekran.px,
                                  mysz.y-bron.my+ekran.py,
                                  $FFB0C0B0,$70009000,effectsrcalpha or effectdiffuse);


    tr:=rect(0,0,ekran.width,ekran.height-ekran.menux);
    form1.PowerDraw1.ClipRect:=tr;
    pokazuj_napis;

    {menu}
    if ekran.menux>0 then begin
       pokaz_menu_tlo;
       case menju.widoczne of
          0:pokaz_menu_bronie;
          1:pokaz_menu_rysowanie;
          2:pokaz_menu_warunki;
          3:pokaz_menu_druzyny;
          4:pokaz_menu_wejscia;
       end;
       pokaz_menu_boczne;
    end;

    if (kfg.pokazuj_info) and (bron.info_o_kolesiu>=0) and
       (mysz.y<ekran.height-ekran.menux) then pokaz_info_o_kolesiu;


    tr:=rect(0,0,ekran.width,ekran.height);
    form1.PowerDraw1.ClipRect:=tr;

    {rysuj wejscie pod kursorem myszy jak stawianie}
    if (bron.glownytryb=2) and (menju.widoczne=4) then
       form1.PowerDraw1.RenderEffect(obr.wejscie.surf,
                                  mysz.x-20,
                                  mysz.y-20,
                                  0,
                                  effectsrcalpha or effectdiffuse);

    {rysuj male swiatelko jesli stawianie swiatla}
    if (bron.glownytryb=4) and (menju.widoczne=1) then
       form1.PowerDraw1.TextureMap(obr.wybuchdym[3,0].surf,
          pRotate4(mysz.x,
                   mysz.y,
                   50,
                   50,
                   50 div 2,
                   50 div 2,
                   0),
                   cColor1($70ffffff),
                   tPattern(0),
                   effectSrcAlpha or effectAdd);


    {wyniki}

{$IFDEF MENU_UKLADANIE_BRONI}
    piszwaskie(l2t(unitmenusy.dupa,5),0,0);
{$ENDIF}

    if ekran.pokazuj_wyniki then begin
       if gracz.pkt<>ekran.spkt then begin
          ekran.spkt:=gracz.pkt;
          ekran.czasniezmienionychwynikow:=0;
       end;
       if gracz.trupow<>ekran.strup then begin
          ekran.strup:=gracz.trupow;
          ekran.czasniezmienionychwynikow:=0;
       end;
       if gracz.paczek<>ekran.spaczek then begin
          ekran.spaczek:=gracz.paczek;
          ekran.czasniezmienionychwynikow:=0;
       end;
       if ekran.czasniezmienionychwynikow<400 then begin
          if ekran.czasniezmienionychwynikow<=340 then kol:=$FFFFFFFF
             else kol:=cardinal( ((100-ekran.czasniezmienionychwynikow div 4) shl 28) or $FFFFFF );
          piszwaskie(Gra_gorlicz_pkt+l2tprzec(gracz.pkt,9),ekran.width-1,0,kol,1);
          piszwaskie(Gra_gorlicz_trp+l2tprzec(gracz.trupow,9),ekran.width-1,11,kol,1);
          piszwaskie(Gra_gorlicz_pacz+l2tprzec(gracz.paczek,7),ekran.width-1,22,kol,1);
          piszwaskie(Gra_gorlicz_czas+l2t(gracz.czas div 3600,0)+':'+l2t((gracz.czas div 60) mod 60,2)+':'+l2t(gracz.czas mod 60,2),ekran.width-1,33,kol,1);

         { piszwaskie(l2t(bron.went_szyb,0),ekran.width-1,40,kol,1);
          piszwaskie(l2t(trunc(bron.went_ani),0),ekran.width-1,51,kol,1);}
       end;

       if tryb_misji.wlaczony then begin
          a:=0;
          if tryb_misji.jest_czas then begin
             if tryb_misji.ile_czasu<=10 then kol:=$FF6F6FFF
                else kol:=$FFFFFFFF;
             piszwaskie(Gra_licz_czas+l2t(tryb_misji.ile_czasu div 3600,0)+':'+l2t((tryb_misji.ile_czasu div 60) mod 60,2)+':'+l2t(tryb_misji.ile_czasu mod 60,2),1,a,kol);
             inc(a,11);
          end;
          if tryb_misji.wygrana_gdy.zebrane_flagi then begin
             if tryb_misji.flag_zebranych>=tryb_misji.wygrana_gdy.zebrane_flagi_ile then kol:=$FF6FFF6F
                else kol:=$FFFFFFFF;
             piszwaskie(Gra_licz_zebraneflagi+l2t(tryb_misji.flag_zebranych,0)+'/'+l2t(tryb_misji.wygrana_gdy.zebrane_flagi_ile,0),1,a,kol);
             inc(a,11);
          end;
          if tryb_misji.przegrana_gdy.zebrane_flagi then begin
             if tryb_misji.flag_zebranych>=tryb_misji.przegrana_gdy.zebrane_flagi_ile then kol:=$FF6F6FFF
                else kol:=$FFFFFFFF;
             piszwaskie(Gra_licz_zebraneflagi+l2t(tryb_misji.flag_zebranych,0)+'/'+l2t(tryb_misji.przegrana_gdy.zebrane_flagi_ile,0),1,a,kol);
             inc(a,11);
          end;
          if tryb_misji.wygrana_gdy.zniszczone_flagi then begin
             if tryb_misji.flag_zniszczonych>=tryb_misji.wygrana_gdy.zniszczone_flagi_ile then kol:=$FF6FFF6F
                else kol:=$FFFFFFFF;
             piszwaskie(Gra_licz_zniszczoneflagi+l2t(tryb_misji.flag_zniszczonych,0)+'/'+l2t(tryb_misji.wygrana_gdy.zniszczone_flagi_ile,0),1,a,kol);
             inc(a,11);
          end;
          if tryb_misji.przegrana_gdy.zniszczone_flagi then begin
             if tryb_misji.flag_zniszczonych>=tryb_misji.wygrana_gdy.zniszczone_flagi_ile then kol:=$FF6F6FFF
                else kol:=$FFFFFFFF;
             piszwaskie(Gra_licz_zniszczoneflagi+l2t(tryb_misji.flag_zniszczonych,0)+'/'+l2t(tryb_misji.przegrana_gdy.zniszczone_flagi_ile,0),1,a,kol);
             inc(a,11);
          end;
          if tryb_misji.wygrana_gdy.zginie_min then begin
             if tryb_misji.druzyny[tryb_misji.wygrana_gdy.zginie_grupa].zginelo>=tryb_misji.wygrana_gdy.zginie_ile then kol:=$FF6FFF6F
                else kol:=$FFFFFFFF;

             form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                         pBounds4(0, 1+a, 20,20),
                         cColor1(cardinal(druzyna[tryb_misji.wygrana_gdy.zginie_grupa].kolor_druzyny or $FF000000)),
                         tPattern(47),
                         effectSrcAlpha or effectdiffuse);

             piszwaskie(Gra_licz_zginelo+l2t(tryb_misji.druzyny[tryb_misji.wygrana_gdy.zginie_grupa].zginelo,0)+'/'+l2t(tryb_misji.wygrana_gdy.zginie_ile,0)+Gra_licz_z_grupy+l2t(tryb_misji.wygrana_gdy.zginie_grupa+1,0),15,a,kol);
             inc(a,11);
          end;
          if tryb_misji.przegrana_gdy.zginie_min then begin
             if tryb_misji.druzyny[tryb_misji.przegrana_gdy.zginie_grupa].zginelo>=tryb_misji.przegrana_gdy.zginie_ile then kol:=$FF6F6FFF
                else kol:=$FFFFFFFF;

             form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                         pBounds4(0, 1+a, 20,20),
                         cColor1(cardinal(druzyna[tryb_misji.przegrana_gdy.zginie_grupa].kolor_druzyny or $FF000000)),
                         tPattern(47),
                         effectSrcAlpha or effectdiffuse);

             piszwaskie(Gra_licz_zginelo+l2t(tryb_misji.druzyny[tryb_misji.przegrana_gdy.zginie_grupa].zginelo,0)+'/'+l2t(tryb_misji.przegrana_gdy.zginie_ile,0)+Gra_licz_z_grupy+l2t(tryb_misji.przegrana_gdy.zginie_grupa+1,0),15,a,kol);
             inc(a,11);
          end;
          if tryb_misji.wygrana_gdy.dojdzie_do_prost then begin
             if tryb_misji.doszlo_dobrze>=tryb_misji.wygrana_gdy.dojdzie_do_prost_ile_kolesi then kol:=$FF6FFF6F
                else kol:=$FFFFFFFF;

             form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                         pBounds4(0, 1+a, 20,20),
                         cColor1(cardinal(druzyna[tryb_misji.wygrana_gdy.dojdzie_do_prost_z_grupy].kolor_druzyny or $FF000000)),
                         tPattern(47),
                         effectSrcAlpha or effectdiffuse);

             piszwaskie(Gra_licz_znalazlosiedobrze+l2t(tryb_misji.doszlo_dobrze,0)+'/'+l2t(tryb_misji.wygrana_gdy.dojdzie_do_prost_ile_kolesi,0)+Gra_licz_z_grupy+l2t(tryb_misji.wygrana_gdy.dojdzie_do_prost_z_grupy+1,0),15,a,kol);
             inc(a,11);
          end;
          if tryb_misji.przegrana_gdy.dojdzie_do_prost then begin
             if tryb_misji.doszlo_zle>=tryb_misji.przegrana_gdy.dojdzie_do_prost_ile_kolesi then kol:=$FF6F6FFF
                else kol:=$FFFFFFFF;

             form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                         pBounds4(0, 1+a, 20,20),
                         cColor1(cardinal(druzyna[tryb_misji.przegrana_gdy.dojdzie_do_prost_z_grupy].kolor_druzyny or $FF000000)),
                         tPattern(47),
                         effectSrcAlpha or effectdiffuse);

             piszwaskie(Gra_licz_znalazlosiezle+l2t(tryb_misji.doszlo_zle,0)+'/'+l2t(tryb_misji.przegrana_gdy.dojdzie_do_prost_ile_kolesi,0)+Gra_licz_z_grupy+l2t(tryb_misji.przegrana_gdy.dojdzie_do_prost_z_grupy+1,0),15,a,kol);
             //inc(a,11);
          end;
       end;

       if not kfg.chowaj_liczniki then ekran.czasniezmienionychwynikow:=0;
    end;

{    piszwaskie(l2t(ord(mysz.menul),0),ekran.width-1,40,$FFFFFFFF,1);
    piszwaskie(l2t(ord(mysz.menur),0),ekran.width-1,50,$FFFFFFFF,1);
    piszwaskie(l2t(ord(mysz.menustop),0),ekran.width-1,60,$FFFFFFFF,1);}

    pokazuj_napiswrogu;

    if warunki.pauza then
       pisz(Gra_pauza,ekran.width div 2-32,20);

    pokazuj_tultip;

    if tryb_misji.wlaczony then begin
       if tryb_misji.wstrzymana then begin
          misja_pokaz_info;
       end;
    end;

    if not snajp then pokaz_kursor_myszy;

     {
    pisz('ktory='+l2t(dzwieki_pogody.ktory_dzwiek,0), 5,5);
    pisz('nast ='+l2t(dzwieki_pogody.nastepny_dzwiek,0), 5,15);
    pisz('przej='+l2t(dzwieki_pogody.przejscie,0), 5,25);
    pisz('glosn='+l2t(round(dzwieki_pogody.glosnosc*1000),0), 5,35);
    pisz('wys  ='+l2t(round(dzwieki_pogody.wysokosc*1000),0), 5,45);
    pisz('pan  ='+l2t(round(dzwieki_pogody.pan*1000),0), 5,55);

            }
 form1.PowerDraw1.EndScene();
 form1.PowerDraw1.Present();
end;

procedure rysujfale(kolor:cardinal);
var
a,x1,x2,y:integer;
pk:array[0..3] of tpoint;
begin
 for a:=0 to faleilosc do begin
     x1:=a*fal_zoomx;
     x2:=(a-1)* fal_zoomx;
     y:=trunc( fale[a].y{*fal_zoomy} );

     if a=0 then begin
        pk[0]:=point(-ekran.px  , y-ekran.py);
        pk[1]:=point(-ekran.px  , warunki.wys_wody+30-ekran.py);
     end else begin
        pk[0]:=point(x2-ekran.px, trunc( fale[a-1].y{*fal_zoomy })-ekran.py);
        pk[1]:=point(x2-ekran.px, warunki.wys_wody+30-ekran.py);
     end;
        pk[2]:=point(x1-ekran.px, warunki.wys_wody+30-ekran.py);
        pk[3]:=point(x1-ekran.px, y-ekran.py);

     if pk[1].y>ekran.height then pk[1].y:=ekran.height;
     if pk[2].y>ekran.height then pk[2].y:=ekran.height;

     if (pk[0].y<ekran.height) or (pk[3].y<ekran.height) then begin
        form1.PowerDraw1.fillpoly(pPoint4(pk[0].x,pk[0].y, pk[1].x,pk[1].y, pk[2].x,pk[2].y, pk[3].x,pk[3].y),
                         cColor1( kolor ),
                         effectSrcAlpha  );
        form1.PowerDraw1.WuLine(Point(pk[0].x,pk[0].y), point(pk[3].x,pk[3].y),
                         kolor , kolor ,
                         effectAdd  );
     end;
 end;
end;


procedure pokaz_kursor_myszy;
var
a,b,bx,by,xsize,ysize:integer;
prz:byte;

begin
if kfg.jaki_kursor=1 then exit;
bx:=mysz.x-obr.kursor.ofsx+trunc(_sin(trunc(bron.kat))*(15+bron.sila/3));
by:=mysz.y-obr.kursor.ofsy-trunc(_cos(trunc(bron.kat))*(15+bron.sila/3));

if kfg.jaki_kursor=0 then prz:=255 else prz:=120;

if bron.przenoszenie then
   form1.drawsprajtalpha(obr.kursor,mysz.x+25-obr.kursor.ofsx,mysz.y-25-obr.kursor.ofsy,11,prz);

case mysz.wyglad of
 -3:begin {wentylator}
    form1.powerdraw1.TextureMap(obr.wentylator.surf,
               pBounds4(mysz.x-obr.wentylator.ofsx,
                        mysz.y-obr.wentylator.ofsy,
                        obr.wentylator.rx,
                        obr.wentylator.ry),
               cAlpha1(prz),
               tPattern(trunc(bron.went_ani)),
               effectSrcAlpha or effectDiffuse);
    end;
 -2:begin {mlotek}
    form1.powerdraw1.TextureMap(obr.mlotek.surf,
               pRotate4(trunc(mysz.x),
                        trunc(mysz.y),
                        obr.mlotek.rx,
                        obr.mlotek.ry,
                        130,
                        35,
                        trunc((bron.kat+180+_sin(bron.mlotek_ani*9)*90)/1.40625) ),
               cAlpha1(prz),
               tPattern(0),
               effectSrcAlpha or effectDiffuse);

{    _dx:=_cos(trunc(bron.kat-14 +_sin(bron.mlotek_ani*9)*90 ));
    _dy:=_sin(trunc(bron.kat-14 +_sin(bron.mlotek_ani*9)*90 ));
    form1.PowerDraw1.WuLine(point(mysz.x,mysz.y),point(trunc(mysz.x+_dx*120),trunc(mysz.y+_dy*120)),$FFFFFFFF,$FFFF0000,effectSrcAlpha or effectDiffuse);}
    end;
 -1:begin {pila}
    if bron.piluje then begin
       bx:=random(9)-5;
       by:=random(9)-5;
    end else begin
       bx:=0;
       by:=0;
    end;
    form1.powerdraw1.TextureMap(obr.pila.surf,
               pRotate4(trunc(mysz.x)+bx,
                        trunc(mysz.y)+by,
                        obr.pila.rx,
                        obr.pila.ry,
                        77,
                        25,
                        trunc((bron.kat+90)/1.40625)),
               cAlpha1(prz),
               tPattern(licznik2 mod 10),
               effectSrcAlpha or effectDiffuse);

{    _dx:=_sin(trunc(bron.kat))  -_cos(trunc(bron.kat-bron.skat));
    _dy:=-_cos(trunc(bron.kat))  + _sin(trunc(bron.kat-bron.skat));
    form1.PowerDraw1.WuLine(point(mysz.x,mysz.y),point(trunc(mysz.x+_dx*60),trunc(mysz.y+_dy*60)),$FFFFFFFF,$FFFF0000,effectSrcAlpha or effectDiffuse);}
    end;
  0:begin {krzyzyk celownik}
//    form1.drawsprajtalpha(obr.kursor,mysz.x-obr.kursor.ofsx,mysz.y-obr.kursor.ofsy,0,prz);

    form1.powerdraw1.TextureMap(obr.kursor.surf,
               pRotate4c(mysz.x{-obr.kursor.ofsx},mysz.y{-obr.kursor.ofsy},
                        obr.kursor.rx,
                        obr.kursor.ry,
                        trunc((mysz.dx+mysz.dy)*10)),
               cAlpha1(prz),
               tPattern(0),
               effectSrcAlpha or effectDiffuse);

    if mysz.jest_obracanie then begin
        Xsize:= 1;//(obr.celownik.surf.PatternWidth * Scale) div 256;
        Ysize:= trunc(obr.celownik.surf.PatternHeight * (bron.sila/3) ) div 30+15;


        form1.powerdraw1.TextureMap(obr.celownik.surf,
                   pRotate4(trunc(mysz.x+_sin(trunc(bron.kat))*(15+bron.sila/3)/2),
                            trunc(mysz.y-_cos(trunc(bron.kat))*(15+bron.sila/3)/2),
                            Xsize,
                            Ysize,
                            Xsize div 2,
                            Ysize div 2,
                            trunc((bron.kat)/1.40625)),
                   cAlpha1(prz),
                   tPattern(0),
                   effectSrcAlpha or effectDiffuse);

        form1.drawsprajtalpha(obr.kursor,bx,by, 1,prz);
    end;
    end;
  else {pozostale: strzalki w kierunki itp}
    form1.drawsprajtalpha(obr.kursor,mysz.x-obr.kursor.ofsx,mysz.y-obr.kursor.ofsy,mysz.wyglad,prz);
end;

if mysz.wyglad=0 then begin
    if (bron.wybrana<>19) or
       ((bron.wybrana=19) and (bron.tryb=0)) then a:=iko_num[bron.wybrana]
       else
    if ((bron.wybrana=19) and (bron.tryb=1)) then a:=20
       else a:=0;

    if bron.dostrzalu=0 then b:=$FF
    else begin
       if $B0-bron.dostrzalu*5<$10 then b:=$10
          else b:=$B0-bron.dostrzalu*5;
    end;


    form1.PowerDraw1.WuLine(point(mysz.x-trunc(_sin(trunc(bron.kat))*6),
                                  mysz.y+trunc(_cos(trunc(bron.kat))*6)),
                            point(mysz.x-trunc(_sin(trunc(bron.kat))*26),
                                  mysz.y+trunc(_cos(trunc(bron.kat))*26)),
                            $60707070, $e0606060, effectSrcAlpha or effectDiffuse);

    form1.PowerDraw1.TextureMap(obr.kurpodb.surf,
                     pBounds4( mysz.x-7-trunc(_sin(trunc(bron.kat))*30),
                               mysz.y-7+trunc(_cos(trunc(bron.kat))*30),
                               14,14),
                     cColor1( cardinal((b shl 24) or $FFFFFF) ),
                     tPattern( iko_num[bron.wybrana]*20+menju.aniklatka ),
                     effectSrcAlpha or effectDiffuse);
    form1.PowerDraw1.TextureMap(obr.aniikony.surf,
                     pBounds4( mysz.x-6-trunc(_sin(trunc(bron.kat))*30),
                               mysz.y-6+trunc(_cos(trunc(bron.kat))*30),
                               12,12),
                     cColor1( cardinal((b shl 24) or $FFFFFF) ),
                     tPattern( {iko_num[bron.wybrana]*20+}menju.aniklatka ),
                     effectSrcAlpha or effectDiffuse);

    if (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) or
       (not gracz.broniesa[bron.wybrana]) then
        form1.PowerDraw1.TextureMap(obr.menukratka.surf,
                         pBounds4( mysz.x-6-trunc(_sin(trunc(bron.kat))*30),
                                   mysz.y-6+trunc(_cos(trunc(bron.kat))*30),
                                   12,12),
                         cColor1( cardinal((b shl 24) or $FFFFFF) ),
                         tPattern( 1 ),
                         effectSrcAlpha or effectDiffuse);

    if tryb_misji.wlaczony then begin
       if tryb_misji.amunicja[bron.wybrana]>=0 then
          piszdowolne(l2t(tryb_misji.amunicja[bron.wybrana],0),
                      mysz.x-6-trunc(_sin(trunc(bron.kat))*40),
                      mysz.y-6+trunc(_cos(trunc(bron.kat))*40),
                      $FFFFFFFF,8,11);
    end;

end;

end;

procedure pokaz_info_o_kolesiu;
var a,x,y,x1,y1,sx,sy, wys,sz:integer; tr:trect;
begin
tr:=rect(0,0,ekran.width,ekran.height);
form1.PowerDraw1.ClipRect:=tr;

sz:=100;
wys:=44;

x:=mysz.x;//trunc(koles[bron.info_o_kolesiu].x)-ekran.px;
y:=mysz.y;//trunc(koles[bron.info_o_kolesiu].y)-ekran.py;

if x<ekran.width div 2 then begin sx:=x+50; x1:=x+50 end
                       else begin sx:=x-50-sz+1; x1:=x-50 end;
if y<ekran.height div 2 then begin sy:=y+50; y1:=y+50 end
                        else begin sy:=y-50-wys+1; y1:=y-50 end;

form1.PowerDraw1.Rectangle(sx,sy,sz,wys,$90909090,{90001060}druzyna[koles[bron.info_o_kolesiu].team].kolor_druzyny or $60000000,effectsrcalpha or effectdiffuse);
form1.PowerDraw1.wuLine(point(trunc(koles[bron.info_o_kolesiu].x)-ekran.px,trunc(koles[bron.info_o_kolesiu].y)-ekran.py),point(x1,y1),$90909090,$90909090,effectsrcalpha or effectdiffuse);

piszdowolne(Kol_info_druz+l2t(koles[bron.info_o_kolesiu].team+1,0),sx+2,sy+2,$FFFFFFFF,6,8);
piszdowolne(Kol_info_sila+l2t(koles[bron.info_o_kolesiu].sila,0)+'/'+l2t(druzyna[koles[bron.info_o_kolesiu].team].startsila,0),sx+2,sy+10,$FFFFFFFF,6,8);
piszdowolne(Kol_info_bron+Kol_bron_nazwy[koles[bron.info_o_kolesiu].bron],sx+2,sy+18,$FFFFFFFF,6,8);
if koles[bron.info_o_kolesiu].bron>=1 then a:=druzyna[koles[bron.info_o_kolesiu].team].maxamunicji[koles[bron.info_o_kolesiu].bron]
                                      else a:=0;
piszdowolne(Kol_info_amun+l2t(koles[bron.info_o_kolesiu].amunicja,0)+'/'+l2t(a,0),sx+2,sy+26,$FFFFFFFF,6,8);
piszdowolne(Kol_info_tlen+l2t(koles[bron.info_o_kolesiu].tlen,0)+'/'+l2t(druzyna[koles[bron.info_o_kolesiu].team].maxtlen,0),sx+2,sy+34,$FFFFFFFF,6,8);

end;

procedure GraZacznij;
begin
 log('Rozpoczynanie gry');
 if (FileExists('Terrains\temp.tmp')) then wczytaj_teren_z_pliku_fast('temp.tmp');
 glowne_co_widac:=1;
 sprawdz_dostepne_bronie;
 form1.PowerTimer1.MayRender:=True;
 form1.PowerTimer1.MayProcess:=True;
 form1.zegarek.Enabled:=true;
 if not kfg.calkiem_bez_muzyki then begin
     form1.wylaczmuzyke;
     if kfg.jest_muzyka then begin
        //form1.grajkawalek(listyplikow[2][random(length(listyplikow[2]))],false);
        form1.graj_muzyke_w_grze(-1);
        form1.wlaczmuzyke(false);
     end;
 end;
end;

procedure Wyczysc_wszystkie_zrodla_2;
var
  a:integer;
  state:TAlint;
begin
for a:=0 to ile_zrodel-1 do begin
    form1.dzw_rozne.Item[17].Play_gdzie(a);
end;

end;

procedure GraZakoncz;
begin
 log('Zakanczanie gry');
 form1.zegarek.Enabled:=false;
 form1.PowerTimer1.MayRender:=false;
 form1.PowerTimer1.MayProcess:=false;
 if not kfg.calkiem_bez_dzwiekow then wylacz_dzwieki_ciagle;
 zapisz_teren_do_pliku_fast('temp.tmp');
 Wyczysc_wszystkie_zrodla;
 Wyczysc_wszystkie_zrodla_2;
end;

end.
