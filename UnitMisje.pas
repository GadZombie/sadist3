unit UnitMisje;

interface
uses Graphics, Types, vars, classes, sysutils, controls;

procedure wczytaj_misje(nazwapliku:string);
procedure usunflage(a:integer);
procedure ruszaj_flagi;
procedure rysuj_flagi;
procedure obsluz_misje;
procedure misja_pokaz_info;

implementation
uses unit1, powertypes, unitgraglowna, unitstringi, directinput8, unitpliki, unitrysowanie,unitmenuglowne;
type
Tnaglowek=array[0..9] of char;

const
naglowek:Tnaglowek=('S','3','M','i','s','j','a','1','0','0');

procedure wczytaj_misje(nazwapliku:string);
var
  p:TStream;
  a:integer;
  tmp:Tnaglowek;

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

 function wczytajI64:int64;
 var b:int64;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajI64:=b;
 end;

 function wczytajC:cardinal;
 var b:cardinal;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajC:=b;
 end;

 function wczytajD:TDate;
 var b:TDate;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajD:=b;
 end;

 function wczytajcz:TTime;
 var b:TTime;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajcz:=b;
 end;

var
tmpdata:TDate;
tmpczas:TTime;
czh,czm,czs,czss:word;
ile:integer;

begin
log('Wczytywanie misji: '+nazwapliku);
with tryb_misji do begin
     wlaczony:=true;
     wstrzymana:=true;
     dlaczego_wstrzymana:=0;
     flag_zebranych:=0;
     flag_zniszczonych:=0;
     doszlo_dobrze:=0;
     doszlo_zle:=0;
     for a:=0 to max_druzyn do druzyny[a].zginelo:=0;

     try
       p:=TFileStream.Create('Missions\'+nazwapliku+'.S3Mis',fmOpenRead);

       p.readbuffer(tmp,sizeof(tmp));

       if tmp<>naglowek then Raise EReadError.Create('Zly naglowek');

       wybranyteren:=wczytajstring(p);
       
       nazwa:=wczytajstring(p);
       autor:=wczytajstring(p);
       opis:=wczytajstring(p);
       tmpdata{ndatastworzenia}:=wczytajD;
       nagroda:=wczytajI64;

       tryb_misji.muzyka:=wczytajstring(p);
       if tryb_misji.muzyka<>'' then begin {sprawdz czy wybrana muzyka istnieje!}
           a:=0;
           while (a<=length(listyplikow[2])-1) and (listyplikow[2][a]<>tryb_misji.muzyka) do inc(a);
           if a>length(listyplikow[2])-1 then tryb_misji.muzyka:='';
       end;

       jest_czas:=wczytajB;
       tmpczas:=wczytajcz;
       DecodeTime(tmpczas,czh,czm,czs,czss);
       ile_czasu:=czs+czm*60+czh*60*60;

       ruszanie_postacia:=wczytajB;
       ruszanie_postacia_ktora:=wczytajI;
         if ruszanie_postacia then bron.sterowanie:=ruszanie_postacia_ktora
                              else bron.sterowanie:=-1;
       dziala_kursor:=wczytajB;
       zmianawarunkow:=wczytajB;
       rysowanie:=wczytajB;
       zmianawejsc:=wczytajB;
       zmianadruzyn:=wczytajB;
       przenoszenie:=wczytajB;

       wygrana_gdy.czas:=wczytajB;
       wygrana_gdy.czas_o:=wczytajB;
       wygrana_gdy.zginie_min:=wczytajB;
       wygrana_gdy.zginie_min_o:=wczytajB;
       wygrana_gdy.zginie_ile:=wczytajI;
       wygrana_gdy.zginie_grupa:=wczytajI;
       wygrana_gdy.dojdzie_do_prost:=wczytajB;
       wygrana_gdy.dojdzie_do_prost_o:=wczytajB;
       wygrana_gdy.dojdzie_do_prost_ile_kolesi:=wczytajI;
       wygrana_gdy.dojdzie_do_prost_z_grupy:=wczytajI;
       wygrana_gdy.zebrane_flagi:=wczytajB;
       wygrana_gdy.zebrane_flagi_o:=wczytajB;
       wygrana_gdy.zebrane_flagi_ile:=wczytajI;
       wygrana_gdy.zniszczone_flagi:=wczytajB;
       wygrana_gdy.zniszczone_flagi_o:=wczytajB;
       wygrana_gdy.zniszczone_flagi_ile:=wczytajI;

       przegrana_gdy.czas:=wczytajB;
       przegrana_gdy.czas_o:=wczytajB;
       przegrana_gdy.zginie_min:=wczytajB;
       przegrana_gdy.zginie_min_o:=wczytajB;
       przegrana_gdy.zginie_ile:=wczytajI;
       przegrana_gdy.zginie_grupa:=wczytajI;
       przegrana_gdy.dojdzie_do_prost:=wczytajB;
       przegrana_gdy.dojdzie_do_prost_o:=wczytajB;
       przegrana_gdy.dojdzie_do_prost_ile_kolesi:=wczytajI;
       przegrana_gdy.dojdzie_do_prost_z_grupy:=wczytajI;
       przegrana_gdy.zebrane_flagi:=wczytajB;
       przegrana_gdy.zebrane_flagi_o:=wczytajB;
       przegrana_gdy.zebrane_flagi_ile:=wczytajI;
       przegrana_gdy.zniszczone_flagi:=wczytajB;
       przegrana_gdy.zniszczone_flagi_o:=wczytajB;
       przegrana_gdy.zniszczone_flagi_ile:=wczytajI;

       warunki.czestpaczek:=wczytajI;

       bron.wybrana:=wczytajI;

       for a:=0 to 100{max_broni} do
           if a<=max_broni then amunicja[a]:=wczytajI
                             else wczytajI;

       a:=wczytajI;
       setlength(flagi,a+1);
       for a:=0 to high(flagi) do begin
           flagi[a].x:=wczytajI;
           flagi[a].y:=wczytajI;
           flagi[a].rodz:=wczytajI;
       end;
       a:=wczytajI;
       setlength(prostokaty,a+1);
       for a:=0 to high(prostokaty) do begin
           prostokaty[a].x1:=wczytajI;
           prostokaty[a].y1:=wczytajI;
           prostokaty[a].x2:=wczytajI;
           prostokaty[a].y2:=wczytajI;
           prostokaty[a].rodz:=wczytajI;
       end;

       for a:=0 to max_druzyn do begin
           druzyny[a].nazwa:=wczytajstring(p);
           druzyny[a].ilosc_kolesi_w_druzynie:=wczytajI;
           druzyny[a].max_kolesi_na_raz:=wczytajI;
           druzyny[a].zabijac_czy_bronic:=wczytajB;
           druzyny[a].zabijac_czy_bronic_ilu:=wczytajI;
           druzyny[a].sila_poczatkowa:=wczytajI;
           druzyny[a].bron:=wczytajI;
           druzyny[a].amunicja:=wczytajI;
       end;

       for a:=0 to 9 do
           druzyna[a].kolor_druzyny:=wczytajC;

       {kolesie}
       ile:=wczytajI;
       for a:=0 to max_kol do koles[a].jest:=false;
       for a:=0 to ile-1 do begin
           koles[a].jest:=true;
           koles[a].team:=wczytajI;
           koles[a].x:=wczytajI;
           koles[a].y:=wczytajI;
           koles[a].sila:=wczytajI;
           koles[a].kierunek:=wczytajI;
           koles[a].corobi:=wczytajI;
           koles[a].bron:=wczytajI;
           koles[a].amunicja:=wczytajI;
           koles[a].palisie:=wczytajB;
       end;

       if p<>nil then begin
          p.free;
          p:=nil;
       end;
     except
       if p<>nil then begin
          p.free;
          p:=nil;
       end;
     end;


     flag_zebranych:=0;
     flag_zniszczonych:=0;
     doszlo_dobrze:=0;
     doszlo_zle:=0;

     wstrzymana_alfa:=0;
     wylaczanie_wstrzymania:=false;

     wroc_do_menu:=6;
end;

end;

procedure usunflage(a:integer);
var n:integer;
begin
if a<high(tryb_misji.flagi) then begin
   for n:=a to high(tryb_misji.flagi)-1 do
       tryb_misji.flagi[n]:=tryb_misji.flagi[n+1];
end;
setlength(tryb_misji.flagi,length(tryb_misji.flagi)-1);
end;


procedure ruszaj_flagi;
var a,b:integer;
begin
a:=0;
while a<=high(tryb_misji.flagi) do begin
    with tryb_misji.flagi[a] do begin
         aniklatka:=aniklatka+(0.3+abs(warunki.wiatr))*(random*1.8+1);
         if aniklatka>=30 then aniklatka:=aniklatka-30;

         if rodz in [0,2] then begin
            if (x>=0) and (x<=teren.width-1) and
               (y+14>=0) and (y+14<=teren.height+29) and
               (teren.maska[trunc(x),trunc(y+14)]>0) then begin
                  if abs(dy)<0.1 then dy:=0
                                 else dy:=-dy/1.4;
            end else begin
                   dy:=dy+0.15;
                   if ((warunki.typ_wody>0) and (x>warunki.wys_wody)) and (dy>1.5) then dy:=1.5
                      else
                      if (dy>3) then dy:=3;
                   if y>teren.height+20 then begin
                      usunflage(a);
                      inc(tryb_misji.flag_zniszczonych);

                      dec(a);
                      break;
                   end;
                end;
            y:=y+dy;
         end;

         if rodz in [2,3] then
            for b:=0 to max_kol do
                if (koles[b].jest) and
                   (koles[b].x>=x-10) and (koles[b].x<=x+10) and
                   (koles[b].y>=y-15) and (koles[b].y<=y+15) then begin
                   usunflage(a);
                   dec(a);
                   inc(tryb_misji.flag_zebranych);
                   break;
                end;
    end;
    inc(a);
end;
end;

procedure rysuj_flagi;
const kulory:array[0..3] of cardinal= ($FF0000ff, $ffff0000, $ff00ffff, $FF00ff00);
var a,xx,yy:integer; c:cardinal;
begin
for a:=0 to high(tryb_misji.flagi) do
    with tryb_misji.flagi[a] do begin
      if (x+15-ekran.px>=0) and (y+15-ekran.py>=0) and
         (x-15-ekran.px<=ekran.width) and (y-15-ekran.py<=ekran.height-ekran.menux) then begin
         form1.PowerDraw1.TextureMap(obr.flagaslup.surf,
                      pBounds4(trunc(x)-ekran.px+ekran.trzesx-obr.flagaslup.ofsx,
                               trunc(y)-ekran.py+ekran.trzesy-obr.flagaslup.ofsy,
                               obr.flagaslup.rx,
                               obr.flagaslup.ry),
                      cWhite4,
                      tPattern(0),
                      effectSrcAlpha or effectDiffuse);
         c:=kulory[rodz];
         xx:=-trunc(obr.flaga.rx*warunki.wiatr*4.4);
         if abs(xx)<7 then begin
            if warunki.wiatr>=0 then xx:=-7
                                else xx:=7;
         end;
         if abs(xx)>20 then begin
            if warunki.wiatr>=0 then xx:=-20
                                else xx:=20;
         end;
         yy:=trunc(obr.flaga.ry/(1+abs(warunki.wiatr))+5);
         if yy=0 then yy:=1;
         form1.PowerDraw1.TextureMap(obr.flaga.surf,
                      pBounds4(trunc(x)-ekran.px+ekran.trzesx-xx,
                               trunc(y)-ekran.py+ekran.trzesy-25+yy,
                               xx,
                               yy),
                      cColor1(c),
                      tPattern(trunc(aniklatka)),
                      effectSrcAlpha or effectDiffuse);

      end;
    end;
end;

procedure obsluz_misje;
var ok,nieok,takok:boolean; a,b,ile:integer;
begin
if tryb_misji.wstrzymana then begin
   warunki.pauza:=true;
   if form1.PowerInput1.KeyPressed[dik_space] then begin
      tryb_misji.wylaczanie_wstrzymania:=true;
   end;

   if tryb_misji.wylaczanie_wstrzymania then begin
      if tryb_misji.wstrzymana_alfa>0 then begin
         dec(tryb_misji.wstrzymana_alfa,4);
         if tryb_misji.wstrzymana_alfa<0 then tryb_misji.wstrzymana_alfa:=0;
      end;
      if tryb_misji.wstrzymana_alfa<=0 then begin
          tryb_misji.wstrzymana:=false;
          warunki.pauza:=false;
          if tryb_misji.dlaczego_wstrzymana in [1,2] then tryb_misji.wlaczony:=false;
          tryb_misji.wylaczanie_wstrzymania:=false;
      end;
   end else
       if tryb_misji.wstrzymana_alfa<255 then begin
          inc(tryb_misji.wstrzymana_alfa,4);
          if tryb_misji.wstrzymana_alfa>255 then tryb_misji.wstrzymana_alfa:=255;
       end;
end else begin
   {sprawdzamy po kolei warunki na przegranie misji, czy sa spelnione - to pierwsze, bo wazniejsze}
   with tryb_misji do begin
     ok:=false; {jesli ok = true, to misja przegrana}
     nieok:=false; {jesli nieok=true to nie zostal wypelniony ktorys z niezbednych warunkow (kilku) i i tak nie moze byc zakonczone}
     takok:=false; {jesli takok=true to zostal wypelniony ktorys z niezbednych warunkow i co by sie nie dzialo, to przegrana jest}
     {koniec czasu}
      if (przegrana_gdy.czas) and (ile_czasu<=0) then begin
         ok:=true;
         if not przegrana_gdy.czas_o then takok:=true;
      end else if przegrana_gdy.czas_o then nieok:=true;
     {jesli zginie iles postaci z grupy}
      if (przegrana_gdy.zginie_min) and (druzyny[przegrana_gdy.zginie_grupa].zginelo>=przegrana_gdy.zginie_ile) then begin
         ok:=true;
         if not przegrana_gdy.zginie_min_o then takok:=true;
      end else if przegrana_gdy.zginie_min_o then nieok:=true;
     {doszlo ilus do zlego prostokata}
      if przegrana_gdy.dojdzie_do_prost then begin
         ile:=0;
         for a:=0 to high(prostokaty) do
             if {not ok and }(prostokaty[a].rodz=1) then begin
                for b:=0 to max_kol do
                    if (koles[b].jest) and (koles[b].team=przegrana_gdy.dojdzie_do_prost_z_grupy) and
                       (koles[b].x>=prostokaty[a].x1) and (koles[b].x<=prostokaty[a].x2) and
                       (koles[b].y>=prostokaty[a].y1) and (koles[b].y<=prostokaty[a].y2) then inc(ile);
                if ile>=przegrana_gdy.dojdzie_do_prost_ile_kolesi then begin
                   ok:=true;
                   if not przegrana_gdy.dojdzie_do_prost_o then takok:=true;
                end;
             end;
         doszlo_zle:=ile;
         if not ok and przegrana_gdy.dojdzie_do_prost_o then nieok:=true;
      end;
     {zostalo zebranych iles choragiewek}
      if (przegrana_gdy.zebrane_flagi) and (flag_zebranych>=przegrana_gdy.zebrane_flagi_ile) then begin
         ok:=true;
         if not przegrana_gdy.zebrane_flagi_o then takok:=true;
      end else if przegrana_gdy.zebrane_flagi_o then nieok:=true;
     {zostalo zniszczonych iles choragiewek}
      if (przegrana_gdy.zniszczone_flagi) and (flag_zniszczonych>=przegrana_gdy.zniszczone_flagi_ile) then begin
         ok:=true;
         if not przegrana_gdy.zniszczone_flagi_o then takok:=true;
      end else if przegrana_gdy.zniszczone_flagi_o then nieok:=true;

     if (ok and not nieok) or takok then begin {misja przegrana}
        wstrzymana:=true;
        dlaczego_wstrzymana:=2;
     end;
   end;

   {sprawdzamy po kolei warunki na wypelnienie misji, czy sa spelnione - to drugie,
    wygrac mozna tylko jak sie nie spieprzylo warunkow, ktorych nie wolno spelnic}
   with tryb_misji do begin
     ok:=false; {jesli ok = true, to misja wygrana}
     nieok:=false; {jesli nieok=true to nie zostal wypelniony ktorys z niezbednych warunkow (kilku) i i tak nie moze byc zakonczone}
     takok:=false; {jesli takok=true to zostal wypelniony ktorys z niezbednych warunkow i co by sie nie dzialo, to wygrana jest}
     {koniec czasu}
      if (wygrana_gdy.czas) and (ile_czasu<=0) then begin
         ok:=true;
         if not wygrana_gdy.czas_o then takok:=true;
      end else if wygrana_gdy.czas_o then nieok:=true;
     {jesli zginie iles postaci z grupy}
      if (wygrana_gdy.zginie_min) and (druzyny[wygrana_gdy.zginie_grupa].zginelo>=wygrana_gdy.zginie_ile) then begin
         ok:=true;
         if not wygrana_gdy.zginie_min_o then takok:=true;
      end else if wygrana_gdy.zginie_min_o then nieok:=true;
     {doszlo ilus do zlego prostokata}
      if wygrana_gdy.dojdzie_do_prost then begin
         ile:=0;
         for a:=0 to high(prostokaty) do
             if {not ok and }(prostokaty[a].rodz=0) then begin
                for b:=0 to max_kol do
                    if (koles[b].jest) and (koles[b].team=wygrana_gdy.dojdzie_do_prost_z_grupy) and
                       (koles[b].x>=prostokaty[a].x1) and (koles[b].x<=prostokaty[a].x2) and
                       (koles[b].y>=prostokaty[a].y1) and (koles[b].y<=prostokaty[a].y2) then inc(ile);
                if ile>=wygrana_gdy.dojdzie_do_prost_ile_kolesi then begin
                   ok:=true;
                   if not wygrana_gdy.dojdzie_do_prost_o then takok:=true;
                end
             end;
         doszlo_dobrze:=ile;
         if not ok and wygrana_gdy.dojdzie_do_prost_o then nieok:=true;
      end;
     {zostalo zebranych iles choragiewek}
      if (wygrana_gdy.zebrane_flagi) and (flag_zebranych>=wygrana_gdy.zebrane_flagi_ile) then begin
         ok:=true;
         if not wygrana_gdy.zebrane_flagi_o then takok:=true;
      end else if wygrana_gdy.zebrane_flagi_o then nieok:=true;
     {zostalo zniszczonych iles choragiewek}
      if (wygrana_gdy.zniszczone_flagi) and (flag_zniszczonych>=wygrana_gdy.zniszczone_flagi_ile) then begin
         ok:=true;
         if not wygrana_gdy.zniszczone_flagi_o then takok:=true;
      end else if wygrana_gdy.zniszczone_flagi_o then nieok:=true;

     if (ok and not nieok) or takok then begin {misja wygrana}
        wstrzymana:=true;
        dlaczego_wstrzymana:=1;
        inc(gracz.pkt,tryb_misji.nagroda);
        skonczonemisje[menumisje.wybrana]:=true;
        {inc(menumisje.wybrana);
        if (menumisje.wybrana>high(listyplikow[5])) then menumisje.wybrana:=0;}
        a:=0;
        while (a<high(listyplikow[5])) and (skonczonemisje[menumisje.wybrana]) do begin
           inc(a);
           inc(menumisje.wybrana);
           if (menumisje.wybrana>high(listyplikow[5])) then menumisje.wybrana:=0;
        end;
     end;
   end;




end;
end;

procedure misja_pokaz_info;
var s:string; al:cardinal;
begin
al:=cardinal(tryb_misji.wstrzymana_alfa shl 24);
if al>3858759680 then al:=3858759680;
form1.PowerDraw1.Rectangle(30,30,ekran.width-60,ekran.height-60, al or $8080a0, al or $404050, effectsrcalpha or effectdiffuse);

case tryb_misji.dlaczego_wstrzymana of
   0:begin {info o misji}
     piszdowolnezlamaniem(tryb_misji.nazwa,40,40,al or $FFFFFF, 11,13, ekran.width-80,0);
     piszdowolne(Mis_autor+tryb_misji.autor,40,60,al or $9FFF9F,10,10);

     s:=Mis_czas;
     if tryb_misji.jest_czas then s:=s+l2t(tryb_misji.ile_czasu div 3600,0)+':'+l2t((tryb_misji.ile_czasu div 60) mod 60,2)+':'+l2t(tryb_misji.ile_czasu mod 60,2)
        else s:=s+Mis_czasieograniczony;
     piszdowolne(s,40,90,al or $FFFFFF);

     piszdowolne(Mis_nagroda+l2t(tryb_misji.nagroda,0)+Mis_punktow,40,110,al or $FFFFFF);
     piszdowolnezlamaniem(tryb_misji.opis,40,140,al or $FFFFFF, 10,12, ekran.width-80,0);

     piszdowolne(Mis_nacisnij_spacje,40,ekran.height-60,al or $FFFFaF,10,12);
     end;
   1:begin {wygrana}
     piszdowolne(Mis_misjawypelniona,40,40,al or $FFFFFF,12,14);

     piszdowolne(Mis_otrzymujesz+l2t(tryb_misji.nagroda,0)+Mis_punktow,40,110,al or $FFFFFF);

     piszdowolne(Mis_maszpkt+l2t(gracz.pkt,0)+Mis_punktow,40,150,al or $FFFFFF);

     piszdowolne(Mis_nacisnij_spacje_wygrana,40,ekran.height-140,al or $FFFFaF,10,12);
     end;
   2:begin {przegrana}
     piszdowolne(Mis_misjaprzegrana,40,40,al or $FFFFFF,12,14);

     piszdowolne(Mis_nacisnij_spacje_przegrana,40,ekran.height-140,al or $FFFFaF,10,12);
     end;
end;

end;



end.
