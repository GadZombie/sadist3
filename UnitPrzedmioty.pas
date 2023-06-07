unit UnitPrzedmioty;

interface
uses Graphics, Types, vars, sinusy;


  procedure koles_wyrzuc_co_trzymasz(k: integer);
  procedure nowyprzedmiot(sx,sy, sdx,sdy :real;
                   rodzajliczenia:byte;
                   rodz:byte; amunicja_: integer=-1; niebierz_:integer=0);
  procedure pauza_przenos_przedmioty;
  procedure ruszaj_przedmioty;
  procedure rysuj_przedmioty;

implementation
uses unit1, unitEfekty, UnitWybuchy, unitkolesie, unitsyfki, powertypes, unitrysowanie,
     unitmenusy, unitstringi, unitgraglowna;

procedure nowyprzedmiot(sx,sy, sdx,sdy :real;
                   rodzajliczenia:byte;
                   rodz:byte; amunicja_: integer=-1; niebierz_:integer=0);
var a,b:longint;
begin
a:=przedm_nowy;
b:=0;
while (b<max_przedm) and (przedm[a].jest) do begin
   inc(a);
   inc(b);
   if a>=max_przedm then a:=0;
end;
if not przedm[a].jest then with przedm[a] do begin
   x:=sx;
   y:=sy;
   if rodzajliczenia=0 then begin
      dx:=sdx;
      dy:=sdy;
   end else begin
      dx:=_sin(trunc(sdx))*sdy/3;
      dy:=-_cos(trunc(sdx))*sdy/3;
   end;
   jest:=true;
   rodzaj:=rodz;
   klatka:=random*6;
   kat:=random*256;
   rozwal:=false;
   przenoszony:=false;
   lezy:=false;
   niebierz:=niebierz_;
   if amunicja_=-1 then begin
       case rodz of
         1,2:amunicja:=5;
         3:amunicja:=10;
         4:amunicja:=3;
       end;
   end else amunicja:=amunicja_;
end;

end;

procedure gracz_zbierz_paczke(a:integer);
var p:integer;
begin
with przedm[a] do begin
     form1.graj(form1.dzw_rozne.item[0],x,y,1000);
     if gracz.paczek>wymagane_do_broni[58].pacz then //zakladam, ze bomba atomowa to MAX potrzebnych paczek
        p:=5000+random(5000)
     else
        p:=500+random(5000);

     nowynapis(trunc(x),trunc(y),Gra_paczka+Gra_paczka_i+l2t(p,0)+Gra_paczka_pkt,1);
     inc(gracz.paczek);
     inc(gracz.pkt,p);

     jest:=false;
end;
end;

procedure pauza_przenos_przedmioty;
var a:integer;
begin
for a:=0 to max_przedm do
  if przedm[a].jest then with przedm[a] do begin
    if (vars.bron.przenoszenie) and
       (not przenoszony) and
       (x-ekran.px>=mysz.x-7) and
       (x-ekran.px<=mysz.x+7) and
       (y-ekran.py>=mysz.y-8) and
       (y-ekran.py<=mysz.y+4) then przenoszony:=true;

    if przenoszony then begin
       x:=mysz.x+ekran.px;
       y:=mysz.y+ekran.py;
       dx:=(mysz.x-mysz.sx)/2;
       dy:=(mysz.y-mysz.sy)/2;

       if rodzaj=paczka_gracza then gracz_zbierz_paczke(a);
    end;

  end;
end;

procedure koles_wyrzuc_co_trzymasz(k: integer);
begin
if ((koles[k].bron=1) and (koles[k].amunicja>=5)) or
   ((koles[k].bron=2) and (koles[k].amunicja>=5)) or
   ((koles[k].bron=3) and (koles[k].amunicja>=10)) or
   ((koles[k].bron=4) and (koles[k].amunicja>=3)) then begin
   nowyprzedmiot(koles[k].x,koles[k].y,random-0.5,-random,0,koles[k].bron,koles[k].amunicja,60);
   koles[k].bron:=0;
   koles[k].amunicja:=0;
end;
end;

procedure ruszaj_przedmioty;
var
a:longint;
k,k1:smallint;
d:shortint;
wez:boolean;
wyswodywx:integer;
gl:real;

begin
for a:=0 to max_przedm do
  if przedm[a].jest then with przedm[a] do begin
    x:=x+dx;
    y:=y+dy;
    wyswodywx:=wyswody(x);

    if niebierz>0 then dec(niebierz);

    lezy:= (abs(dx)<=0.1) and (abs(dy)<=0.1) and (x>=0) and (y>=0) and
             (x<=teren.width-1) and (y<=teren.height+30) and
             (teren.maska[trunc(x),trunc(y)+1]>0);
    if ((abs(warunki.wiatr)>0.5) or (not lezy)) and
       ((warunki.typ_wody=0) or (y<wyswodywx)) then dx:=dx+warunki.wiatr/10;
    if random(2)=0 then dx:=dx*0.985;
    if random(2)=0 then dy:=dy*0.989;
    if (x<0) or (x>teren.Width) then begin
       jest:=false;
    end;
    if y>teren.Height+30 then begin
       jest:=false;
      { y:=DXDraw1.Height-2;
       dy:=-abs(dy)*0.91;}

    end;

    kat:=kat+dx*5;
    if kat<0 then kat:=kat+256;
    if kat>=256 then kat:=kat-256;

    if ((trunc(x+dx)>=0) and (trunc(y+dy)>=0) and (trunc(x+dx)<=teren.width-1) and (trunc(y+dy)<=teren.height+30) and
       (teren.maska[trunc(x+dx),trunc(y+dy)]<>0)) {or
       (y+dy>teren.height-1)} then begin
        if dx>=0 then d:=1 else d:=-1;
        if (trunc(x+d)>=0) and (trunc(y)>=0) and (trunc(x+d)<=teren.width-1) and (trunc(y)<=teren.height+30) and
           (teren.maska[trunc(x+d),trunc(y)]<>0) then begin
           x:=x-dx;
           dx:=-dx/3;
        end;
        if dy>=0 then d:=1 else d:=-1;
        if (trunc(x)>=0) and (trunc(y+d)>=0) and (trunc(x)<=teren.width-1) and (trunc(y+d)<=teren.height+30) and
           (teren.maska[trunc(x),trunc(y+d)]<>0) then begin
           y:=y-dy;
           dy:=-dy/3;
        end;
        if ((abs(dx)>=0.4) or (abs(dy)>=0.4)) and (random(4)=0) then begin
           gl:=sqrt2(sqr(dx)+sqr(dy))/3;
           if gl<0.02 then gl:=0.02;
           if gl>1 then gl:=1;
           form1.graj(form1.dzw_bronie_inne.Item[2],x,y,1000,gl);
        end

    end;
    if ((trunc(x)>=0) and (trunc(y+1)>=0) and (trunc(x)<=teren.width-1) and (trunc(y+1)<=teren.height+30) and
       (teren.maska[trunc(x),trunc(y+1)]<>0)) and
       (abs(dx)<0.1) and (abs(dy)<0.1) and
       (trunc(kat) mod 64<>0) then begin
           if trunc(kat) mod 64<32 then dx:=dx-0.3
                                   else dx:=dx+0.3;
           dy:=dy-0.2;
    end;

    if not lezy then dy:=dy+0.15*warunki.grawitacja;

    if (warunki.typ_wody>=1) and (y>=wyswodywx) then begin
       case warunki.typ_wody of
          1..max_wod:begin
            if abs(dx)>gestosci[warunki.typ_wody].maxx then dx:=dx/(gestosci[warunki.typ_wody].x*1.09);
            if abs(dy)>gestosci[warunki.typ_wody].maxy then dy:=dy/gestosci[warunki.typ_wody].y;
            if (warunki.typ_wody=2) and (random(20)=0) then rozwal:=true;
            end;
       end;
    end;
    if (warunki.typ_wody>=1) and
       {(y>=wyswodywx-10) and
       (y<=wyswodywx) and}
       (((y-dy>=wyswodywx-2) and (y<wyswodywx-2)) or
        ((y-dy<wyswodywx-2) and (y>=wyswodywx-2))) and
       ((abs(dx)>0.8) or (abs(dy)>0.7)) {and (random(3)=0)} then begin
       form1.graj(form1.dzw_rozne.item[5],x,y,7000);
       for k:=0 to 5+random(10) do
           nowysyf(x-8+random(16),wyswodywx-1,(random*2-1)+dx/2,-abs(random*dy/2),0,random(5),0,2,true, 0,warunki.typ_wody);
       plum(x,y,dy,12,1.5)
    end;

    klatka:=klatka+0.1;
    if klatka>=6 then klatka:=klatka-6;
    if rozwal then begin
       jest:=false;
       wybuch(x,y,10+random(15),false,true,true,false,-1,false);
       nowywybuchdym(x,y,0,0,random(2),0,1+random(2),random(2)*(120+random(130)));
       form1.graj(form1.dzw_wybuchy.Item[1],x,y,10000);
    end;

    if niebierz=0 then
      for k:=0 to max_kol do begin
        if (koles[k].jest) then begin
           {spradz, czy postac nie wlazla na przedmiot i go zbierz}
           if (x>=koles[k].x-10) and (y>=koles[k].y-13) and
              (x<=koles[k].x+10) and (y<=koles[k].y+17) and
              ((koles[k].zebrac=a) or
               ((koles[k].zebrac>=0) and (przedm[koles[k].zebrac].jest) and (przedm[koles[k].zebrac].rodzaj=rodzaj)) or
               ((koles[k].sila<{150}druzyna[koles[k].team].maxsila) and (rodzaj=0)) or
               (bron.sterowanie=k)
              )
            then begin
              case rodzaj of
                 0:begin {apteczka}
                   inc(koles[k].sila,30);
                   if koles[k].sila>druzyna[koles[k].team].maxsila then koles[k].sila:=druzyna[koles[k].team].maxsila;

                   if koles[k].stopien_spalenia<255 then begin
                      if koles[k].stopien_spalenia+70>255 then koles[k].stopien_spalenia:=255
                         else inc(koles[k].stopien_spalenia,70);
                      if koles[k].stopien_spalenia>=128 then //czerwieni sie
                         koles[k].kolor:=$FF0000FF or (koles[k].stopien_spalenia shl 16) or (koles[k].stopien_spalenia shl 8)
                      else
                         koles[k].kolor:=$FF000000 or (koles[k].stopien_spalenia shl 16) or (koles[k].stopien_spalenia shl 8) or (koles[k].stopien_spalenia shl 1{czyli *2});
                   end;

                   form1.graj(form1.dzw_rozne.item[0],koles[k].x,koles[k].y,1000);
                   nowynapis(trunc(x),trunc(y),'+30 '+napis_przedmiotow[0],1);
                   end;
                 1:begin {granaty}
                   if koles[k].bron<>1 then begin
                      koles_wyrzuc_co_trzymasz(k);
                      koles[k].amunicja:=amunicja;
                   end else inc(koles[k].amunicja,amunicja);
                   koles[k].bron:=1;
                   if koles[k].amunicja>druzyna[koles[k].team].maxamunicji[koles[k].bron] then
                      koles[k].amunicja:=druzyna[koles[k].team].maxamunicji[koles[k].bron];
                   form1.graj(form1.dzw_rozne.item[0],koles[k].x,koles[k].y,1000);
                   nowynapis(trunc(x),trunc(y),'+'+l2t(amunicja,0)+' '+napis_przedmiotow[1],1);
                   end;
                 2:begin {bomby}
                   if koles[k].bron<>2 then begin
                      koles_wyrzuc_co_trzymasz(k);
                      koles[k].amunicja:=amunicja;
                   end else inc(koles[k].amunicja,amunicja);
                   koles[k].bron:=2;
                   if koles[k].amunicja>druzyna[koles[k].team].maxamunicji[koles[k].bron] then
                      koles[k].amunicja:=druzyna[koles[k].team].maxamunicji[koles[k].bron];
                   form1.graj(form1.dzw_rozne.item[0],koles[k].x,koles[k].y,1000);
                   nowynapis(trunc(x),trunc(y),'+'+l2t(amunicja,0)+' '+napis_przedmiotow[2],1);
                   end;
                 3:begin {karabin}
                   if koles[k].bron<>3 then begin
                      koles_wyrzuc_co_trzymasz(k);
                      koles[k].amunicja:=amunicja
                   end else inc(koles[k].amunicja,amunicja);
                   koles[k].bron:=3;
                   if koles[k].amunicja>druzyna[koles[k].team].maxamunicji[koles[k].bron] then
                      koles[k].amunicja:=druzyna[koles[k].team].maxamunicji[koles[k].bron];
                   form1.graj(form1.dzw_rozne.item[0],koles[k].x,koles[k].y,1000);
                   nowynapis(trunc(x),trunc(y),'+'+l2t(amunicja,0)+' '+napis_przedmiotow[3],1);
                   end;
                 4:begin {dynamit}
                   if koles[k].bron<>4 then begin
                      koles_wyrzuc_co_trzymasz(k);
                      koles[k].amunicja:=amunicja
                   end else inc(koles[k].amunicja,amunicja);
                   koles[k].bron:=4;
                   if koles[k].amunicja>druzyna[koles[k].team].maxamunicji[koles[k].bron] then
                      koles[k].amunicja:=druzyna[koles[k].team].maxamunicji[koles[k].bron];
                   form1.graj(form1.dzw_rozne.item[0],koles[k].x,koles[k].y,1000);
                   nowynapis(trunc(x),trunc(y),'+'+l2t(amunicja,0)+' '+napis_przedmiotow[4],1);
                   end;
                 5:begin {tlen}
                   if druzyna[koles[k].team].maxtlen<=1 then inc(koles[k].tlen)
                      else inc(koles[k].tlen,druzyna[koles[k].team].maxtlen div 2);
                   if koles[k].tlen>druzyna[koles[k].team].maxtlen then koles[k].tlen:=druzyna[koles[k].team].maxtlen;
                   form1.graj(form1.dzw_rozne.item[0],koles[k].x,koles[k].y,1000);
                   nowynapis(trunc(x),trunc(y),'+'+l2t(druzyna[koles[k].team].maxtlen div 2,0)+' '+napis_przedmiotow[5],1);
                   end;
                 6:begin {niewidzialnosc}
                   koles[k].niewidzialnosc:=600;
                   form1.graj(form1.dzw_rozne.item[0],koles[k].x,koles[k].y,1000);
                   nowynapis(trunc(x),trunc(y),napis_przedmiotow[6],1);
                   end;

                 paczka_gracza:begin {paczka_gracza}
                   form1.graj(form1.dzw_rozne.item[0],koles[k].x,koles[k].y,1000);
                   pokaz_dymek(k,cr_cieszy);
                   end;
              end;
              jest:=false;
              if (koles[k].corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_pokazuje,cr_trzyma,cr_wyrzuca]) and (random(4)=0) then begin
                 koles[k].corobil:=koles[k].corobi;
                 koles[k].corobi:=cr_cieszy;
                 koles[k].ani:=0;
                 koles[k].anido:=0;
                 koles[k].anikl:=0;
              end;
              if not jest then break;
           end else
           {jesli nie jest tak blisko, to moze postac do tego podbiegnie}
           if (x>=koles[k].x-90) and (y>=koles[k].y-90) and
              (x<=koles[k].x+90) and (y<=koles[k].y+(50+ord(koles[k].corobi=cr_plynie)*40)) and
              (abs(koles[k].dx)<=1) and (abs(koles[k].dy)<=1) and (koles[k].corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_plynie]) and
              (random(20)=0) and (
               ((koles[k].zebrac=-1) or (koles[k].czaszbierania>1000)) or
               ((rodzaj=0) and (koles[k].sila<15)) or
               ((rodzaj=5) and (koles[k].tlen<druzyna[koles[k].team].maxtlen div 3))
              ) then begin

              if (koles[k].czaszbierania<=1000) or (koles[k].zebrac<>a) then begin
                 wez:=false;
                 case rodzaj of
                    0:if (koles[k].sila<300) or (koles[k].stopien_spalenia<250) then wez:=true;
                    1:if (koles[k].bron in [0,4]) or
                         ((koles[k].bron=1) and (koles[k].amunicja<druzyna[koles[k].team].maxamunicji[koles[k].bron]-1)) or
                         (koles[k].bron=4) or
                         (koles[k].amunicja<=2) then wez:=true;
                    2:if (koles[k].bron in [0,1,4]) or
                         ((koles[k].bron=2) and (koles[k].amunicja<druzyna[koles[k].team].maxamunicji[koles[k].bron]-1)) or
                         (koles[k].amunicja<=2) then wez:=true;
                    3:if (koles[k].bron in [0..2,4]) or
                         ((koles[k].bron=3) and (koles[k].amunicja<druzyna[koles[k].team].maxamunicji[koles[k].bron]-1)) or
                         (koles[k].amunicja<=2) then wez:=true;
                    4:if (koles[k].bron=0) or
                         ((koles[k].bron=4) and (koles[k].amunicja<druzyna[koles[k].team].maxamunicji[koles[k].bron]-1)) or
                         ((koles[k].amunicja<=2) and (druzyna[koles[k].team].maxamunicji[koles[k].bron]>2)) then wez:=true;
                    5:if koles[k].tlen<druzyna[koles[k].team].maxtlen-druzyna[koles[k].team].maxtlen div 3 {czyli 2/3} then wez:=true;
                    6:if koles[k].niewidzialnosc<100 then wez:=true;
                    paczka_gracza:wez:=true;
                 end;

                 if wez then begin
                    if (sprawdz_pusta_linie(trunc(koles[k].x-3+random(7)),trunc(koles[k].y-12+random(3)),trunc(x-7+random(15)),trunc(y-7+random(8)))) then begin
                       koles[k].zebrac:=a;
                       koles[k].czaszbierania:=0;
                    end;
                 end;
              end;

           end;
        end;
      end;

    if (lezy) and (abs(dx)<0.1) then dx:=0;
    if (lezy) and (abs(dy)<0.1) then dy:=0;

    if (ekran.iletrzes>=3) and (lezy) then begin
       dx:=dx+random/10-0.05;
       dy:=dy+random/10-0.05;
    end;

    if (vars.bron.przenoszenie) and
       (not przenoszony) and
       (x-ekran.px>=mysz.x-7) and
       (x-ekran.px<=mysz.x+7) and
       (y-ekran.py>=mysz.y-8) and
       (y-ekran.py<=mysz.y+4) then przenoszony:=true;

    if przenoszony then begin
       x:=mysz.x+ekran.px;
       y:=mysz.y+ekran.py;
       dx:=(mysz.x-mysz.sx)/2;
       dy:=(mysz.y-mysz.sy)/2;
       if rodzaj=paczka_gracza then gracz_zbierz_paczke(a);
    end;

    if not jest then
       for k1:=0 to max_kol do
           if koles[k1].zebrac=a then koles[k1].zebrac:=-1;
end;
end;

procedure rysuj_przedmioty;
var
a,n:longint;
wx,wy:smallint;

begin
for a:=0 to max_przedm do
  if przedm[a].jest then with przedm[a] do begin
     n:=trunc(klatka);

     if lezy then begin
        wx:=ekran.trzesx;
        wy:=ekran.trzesy;
     end else begin
         wx:=0;
         wy:=0;
     end;

     form1.PowerDraw1.TextureMap(obr.przedm[rodzaj].surf,
                pRotate4c(trunc(x)-ekran.px+wx,
                          trunc(y)-ekran.py+wy,
                          obr.przedm[rodzaj].rx,
                          obr.przedm[rodzaj].ry,
                          trunc(kat) ),
                          cWhite4, tPattern(n), effectSrcAlpha);

{     form1.drawsprajt(obr.przedm[rodzaj],
                      trunc(x-obr.przedm[rodzaj].ofsx)-ekran.px+wx,
                      trunc(y-obr.przedm[rodzaj].ry+2)-ekran.py+wy, n);}
end;
end;




end.
