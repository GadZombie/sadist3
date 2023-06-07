unit UnitPociski;

interface
uses Graphics, Types, vars, sinusy;

  procedure strzel(sx,sy, sdx,sdy :real;
                 rodzajliczenia:byte;
                 czyj_pocisk:longint;
                 sila_wybuchu,
                 rodzaj_pocisku,
                 waga_do_odrzutu,
                 szybkosc_spadania:smallint;
                 wyglad_:shortint;
                 odbijasie_:boolean;
                 czas_do_wybuchu:integer;rez1_:integer=0;rez2_:integer=0;rez3_:integer=0;
                 nieodbijaj_:byte=0);
  procedure ruszaj_pociski;
  procedure rysuj_pociski;

implementation
uses unit1, unitEfekty, UnitWybuchy, powertypes, unitsyfki, unitkolesie, unitbomble, unitrysowanie;

{rodzaje pociskow:
   0: pocisk z bazuki - obraca sie w kierunku, w ktorym leci
   1: granat, bomba - obraca sie stale
   2: pocisk ze strzelby itp
   3: odlamek bomby - obraca sie i tez dymi
   4: napalm
   5: ogien
   6: pocisk, ktory robi tunele, wbija sie w ziemie
   7: pocisk z bazuki samonaprowadzanej - obraca sie w kierunku, w ktorym leci
   8: kula ognista
   9: dynamit
  10: pilka
  11: pocisk z napalmem - obraca sie w kierunku, w ktorym leci
  12: pocisk bfg
  13: pocisk protonowy
  14: jak napalm, ale to miotacz ognia. roznica niewielka, ale bedzie kapalo
  15: noze
  16: chmura
  17: pocisk bazuka z gazem
  18: bomba na cialo
  19: roller
  20: bomba atomowa

 wyglady pociskow:
  -1: pocisk z karabinu/minigana
   0: pocisk z bazuki
   1: granat
   2: bomba
   3: odlamek bomby
   4: napalm
   5: ogien
   6: z gwozdziami
   7: duzy granat
   8: kula ognista (animacja z napalmu. przynajmniej na razie!)
   9: dynamit
  10: pilka
  11: pocisk z napalmem - obraca sie w kierunku, w ktorym leci
  12: pocisk bfg
  13: pocisk protonowy
  14: jak napalm, ale to miotacz ognia. roznica niewielka, ale bedzie kapalo
  15: noze
  16: chmura
  17: bomba z gazem
  18: bazuka z gazem
  19: molotov
  20: gaz
  21: bazuka naprowadzana
  22: bomba z gwozdziami
  23: bomba na cialo
  24: roller
  25: rakieta
  26: pocisk wbijany (tunel)
  27: bloto
  28: bomba z gazem
  29: bomba atomowa
}


{strzela pociskiem:
   rodzajliczenia:
     0 - sdx, sdy to delta dla x i y
     1 - sdx = kat, sdy = sila strzalu
}
procedure strzel(sx,sy, sdx,sdy :real;
                 rodzajliczenia:byte;
                 czyj_pocisk:longint;
                 sila_wybuchu,
                 rodzaj_pocisku,
                 waga_do_odrzutu,
                 szybkosc_spadania:smallint;
                 wyglad_:shortint;
                 odbijasie_:boolean;
                 czas_do_wybuchu:integer;rez1_:integer=0;rez2_:integer=0;rez3_:integer=0;
                 nieodbijaj_:byte=0);
var a,b:longint;
begin
a:=poc_nowy;
b:=0;
while (b<max_poc) and (poc[a].jest) do begin
   inc(a);
   inc(b);
   if a>=max_poc then a:=0;
end;
if not poc[a].jest then with poc[a] do begin
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
   czyj:=czyj_pocisk;
   sila:=sila_wybuchu;
   rodzaj:=rodzaj_pocisku;
   waga:=waga_do_odrzutu;
   spadanie:=szybkosc_spadania;
   czasdowybuchu:=czas_do_wybuchu;
   odbijasie:=odbijasie_;
   case rodzaj of
     4,5,8,14:klatka:=random(26);
     12:klatka:=random(20);
     16:klatka:=random*10;
     else
        klatka:=random(60);
   end;
   wyglad:=wyglad_;
   rez1:=rez1_;
   if rodzaj=5 then rez2:=random(2)
      else rez2:=rez2_;
   rez3:=rez3_;
   lezy:=false;
   nieodbijaj:=nieodbijaj_;
end;

end;

procedure ruszaj_pociski;
const minrozm:array[0..2] of byte=(5,5,8);
var
a,k:longint;
k1,k2:real;
wielokrotnosc,dowielokrotnosc:byte;
d:shortint;
wysadz:boolean;
ps:single;
jest_ogien,bool:boolean;
wyswodywx:integer;
b1,b2,b3:byte;
e:integer;

kk0:real;
begin
jest_ogien:=false;
for a:=0 to max_poc do
  if poc[a].jest then with poc[a] do begin
   if poc[a].rodzaj=2 then wielokrotnosc:=4 else wielokrotnosc:=0;
   dowielokrotnosc:=0;
   wysadz:=false;
   wyswodywx:=wyswody(x);
   if ((abs(warunki.wiatr)>0.4) or (not lezy)) and
      ((warunki.typ_wody=0) or (y<wyswodywx)) then dx:=dx+warunki.wiatr/(waga/2.5);
   while (dowielokrotnosc<=wielokrotnosc) and (not wysadz) and (jest) do begin

      x:=x+dx;
      y:=y+dy;
      wyswodywx:=wyswody(x);
      lezy:= (odbijasie) and //uwaga: dodane pozniej, zeby pocisk nie "stal" na ziemi; nie wiem czy cos innego sie od tego nie zjebalo
             (abs(dx)<=0.1) and (abs(dy)<=0.1) and (x>=0) and (y>=0) and
             (x<=teren.width-1) and (y<=teren.height+30) and
             (teren.maska[trunc(x),trunc(y)+1]>0);
      if random(2)=0 then dx:=dx*0.995;
      if random(2)=0 then dy:=dy*0.999;
      if ((x<0) and (dx<=0)) or
         ((x>teren.Width) and (dx>=0)) or
         (y>=teren.Height+31) then begin
         jest:=false;
      end;
      if (((wyglad=-1) or (rodzaj in [12,13,16])) and (y<-100)) or
         (y<-2000) then jest:=false;

      if wyglad in [2,9] then begin
         if random(7)=0 then
            nowysyf(x+_sin(trunc(klatka*6-45))*5,
                    y-_cos(trunc(klatka*6-45))*5,
                    (random*1.5-0.75),(random*1.5-0.95),
                    0,0,1,3,false, 0,0,cardinal( $000040ff+(random($Be) shl 8)) );

      end;

      case rodzaj of
         0,11:begin{pocisk z bazuki - dymi co chwile}
           if (random(2)=0) and (kfg.detale>=2) then nowywybuchdym(x,y,-dx/4,-dy/4,2,wd_dym,1,random(2)*(200+random(45)),170+random(85));
           if (random(3)=0) and (kfg.detale>=3) then nowywybuchdym(x,y,-dx/20,-dy/20-0.1,1,wd_dym,random(5)+1,random(2)*(120+random(130)));

           if wyglad=25 then begin //rakieta spada szybciej, kiedy wolno leci
              k1:=sqrt2(dx*dx+dy*dy);
              if k1<4 then begin
                 k2:=(0.125-k1/32)*warunki.grawitacja;
                 if (warunki.typ_wody>=1) and (y>=wyswodywx) then
                    k2:=k2/gestosci[warunki.typ_wody].maxy;

                 dy:=dy+k2;
              end;

           end;
         end;
         1,19:begin {granat, bomba, molotov, roller - obraca sie caly czas}
           ps:=dx;
           if abs(ps)<0.02 then begin
              ps:=0;
           end else
           if abs(ps)<0.1 then begin
              if ps<0 then ps:=-0.1
                      else ps:=0.1;
           end else
           if abs(ps)>4 then begin
              if ps<0 then ps:=-4
                      else ps:=4;
           end;
           klatka:=klatka+ps;
           if klatka>60 then klatka:=klatka-60;
           if klatka<0 then klatka:=klatka+60;

           {molotov sie pali}
           if (wyglad=19) and (random(6)=0) then
              strzel(x-dx,y-dy,-dx/3,-dy/3,0,czyj,10,5,4,-20-random(15),5,false,5+random(14));
           {roller strzela iskrami jak sie konczy mu czas}
           if (wyglad=24) and (czasdowybuchu<=60) and (random(10-czasdowybuchu div 6)=0) then
              nowysyf(x-4+random(9), y-4+random(9),
                      (-2+random*4),(-2+random*4),
                      0,0,1,3,false, 0,0,cardinal( $000040ff+(random($Be) shl 8)) );
           end;
        {2: pocisk ze strzelby itp}
         3:begin {odlamek bomby - obraca sie i tez dymi}
           ps:=dx;
           if abs(ps)<0.02 then begin
              ps:=0;
           end else
           if abs(ps)<0.3 then begin
              if ps<0 then ps:=-0.4
                      else ps:=0.4;
           end else
           if abs(ps)>15 then begin
              if ps<0 then ps:=-15
                      else ps:=15;
           end;
           klatka:=klatka+ps;
           if klatka>60 then klatka:=klatka-60;
           if klatka<0 then klatka:=klatka+60;
           if (random(5)=0) and (kfg.detale>=3) then nowywybuchdym(x,y,-dx/5,-dy/5-random-0.2,1,wd_dym,random(3),(120+random(110)),150+random(80));
           end;
         4,14:begin{napalm,miotacz ognia}
           if (random(70)=0) and (kfg.detale>=2) then
              nowywybuchdym(x,y-10,random/2-0.25,-random/2-0.4,3,wd_dym,random(5)+1,(100+random(154)),220-random(130));
              //nowywybuchdym(x,y-10,random/2-0.25,-random/2-0.4,0,wd_dym,random(4)+2,(100+random(80)),240-random(90));
           if random(80)=0 then wybuch(x,y,5+random(5),false,true,true,true,czyj,false);
           if random(300)=0 then rozrzuc(x,y,6+random(10),1,false,true,czyj,false);
           if random(40)=0 then begin
              if rodzaj=4 then
                 strzel(x,y-random(10)-1,-random+0.5,-random/1.6,0,czyj,10,5,10,-20-random(15),5,false,8+random(20))
              else
                 strzel(x,y,-random+0.5,random,0,czyj,10,4,40,110,4,random(5)=0,30+random(50));
           end;

           klatka:=klatka+1;
           if klatka>=26 then klatka:=0;
           dx:=dx+(random/5-0.1);
           jest_ogien:=true;
           end;
         5:begin{ogien}
           klatka:=klatka+1;
           if klatka>=26 then klatka:=0;
           dx:=dx+(random/5-0.1);
           if rez1=0 then jest_ogien:=true;
           if (random(10)=0) then
              wybuch(x,y,5+random(5),false,false,true,true,czyj,false);
           end;
         6:begin{pocisk wbijany}
           if (random(2)=0) and (kfg.detale>=2) then nowywybuchdym(x,y,-dx/7,-dy/7,2,wd_dym,2,random(2)*(170+random(45)));
           end;
         7:begin{pocisk z bazuki naprowadzajacej}
           if (random(2)=0) and (kfg.detale>=2) then nowywybuchdym(x,y,-dx/4,-dy/4,2,wd_dym,1,random(2)*(200+random(45)),170+random(85));
           if (random(3)=0) and (kfg.detale>=3) then nowywybuchdym(x,y,-dx/20,-dy/20-0.1,1,wd_dym,random(5)+1,random(2)*(120+random(130)));
           if dx<-3 then dx:=dx*0.9;
           if dx>3 then dx:=dx*0.9;
           if dy<-3 then dy:=dy*0.9;
           if dy>3 then dy:=dy*0.9;
           end;
         8:begin{kula ognista}
           klatka:=klatka+1;
           if klatka>=26 then klatka:=0;
           dx:=dx+(random/5-0.1);
           jest_ogien:=true;
           strzel(x-dx,y-dy,-dx/3,-dy/3,0,czyj,10,5,10,-20-random(15),5,false,8+random(20));
           end;
         9:begin {dynamit - obraca sie caly czas, spada na plasko}
           ps:=dx;
           if abs(ps)<0.02 then begin
              ps:=0;
           end else
           if abs(ps)<0.1 then begin
              if ps<0 then ps:=-0.1
                      else ps:=0.1;
           end else
           if abs(ps)>4 then begin
              if ps<0 then ps:=-4
                      else ps:=4;
           end;

           if lezy then begin
              if (klatka>1) and (klatka<=30) then klatka:=klatka-1 else
              if (klatka>30) and (klatka<=59) then klatka:=klatka+1 else
              klatka:=0;
           end else begin
              klatka:=klatka+ps;
              if klatka>60 then klatka:=klatka-60;
              if klatka<0 then klatka:=klatka+60;
           end;

           end;
         10:begin {pilka obraca sie caly czas szybko}
           {if abs(dx)>abs(dy) then }ps:=dx*2{ else ps:=dy*2};
           if abs(ps)<1 then begin
              if ps<0 then ps:=-1
                      else ps:=1;
           end else
           if abs(ps)>7 then begin
              if ps<0 then ps:=-7
                      else ps:=7;
           end;
           klatka:=klatka+ps;
           if klatka>60 then klatka:=klatka-60;
           if klatka<0 then klatka:=klatka+60;
           end;
         12,13:begin {bfg,proton}
           klatka:=klatka+1;
           if klatka>=20 then klatka:=0;
           end;
         15:begin {noze}
           ps:=sqrt2(sqr(dx)+sqr(dy));
           if abs(ps)<0.02 then begin
              ps:=0;
           end else
           if abs(ps)<0.1 then begin
              if ps<0 then ps:=-0.1
                      else ps:=0.1;
           end else
           if abs(ps)>4 then begin
              if ps<0 then ps:=-4
                      else ps:=4;
           end;
           klatka:=klatka+ps;
           while klatka>60 do klatka:=klatka-60;
           while klatka<0 do klatka:=klatka+60;
           end;
         16:begin{chmura}
           //klatka:=klatka+0.1;
           //if klatka>=10 then klatka:=0;
           ps:=sqrt2(sqr(dx)+sqr(dy));
           if ps>=0.5 then begin
              dx:=dx+(random*ps/4)-ps/8;
              dy:=dy+(random*ps/4)-ps/8;
           end;
           if abs(ps)>0.2 then rez3:=round(rez3+(ps*12))
                           else rez3:=round(rez3+2.4);
           if rez3<0 then inc(rez3,2048);
           if rez3>=2048 then dec(rez3,2048);
           if abs(dx)>0.3 then dx:=dx/1.075;
           if abs(dy)>0.3 then dy:=dy/1.075;
           {dx:=dx+(random/10-0.05);
           dy:=dy+(random/10-0.05);  }
           if rez1<254 then inc(rez1,3);
           rez2:=rez1 shr 3;

           if random(150)=0 then begin
             for k:=0 to max_kol do
                if (koles[k].jest) and
                   (x>=koles[k].x-50) and (y>=koles[k].y-50) and
                   (x<=koles[k].x+50) and (y<=koles[k].y+50) then begin
                    dec(koles[k].sila);
                    if czyj=-2 then inc(gracz.pkt);
                end;
             for k:=0 to max_zwierz do
                if (zwierz[k].jest) and
                   (x>=zwierz[k].x-50) and (y>=zwierz[k].y-50) and
                   (x<=zwierz[k].x+50) and (y<=zwierz[k].y+50) then begin
                    dec(zwierz[k].sila);
                    zwierz[k].dx:=zwierz[k].dx+random-0.5;
                    zwierz[k].dy:=zwierz[k].dy+random-0.5;
                    if czyj=-2 then inc(gracz.pkt);
                end;
           end;
           end;
         17:begin{pocisk z bazuki z gazem}
            if random(4)=0 then
               strzel(x,y,-dx/2-0.25+random/2,-dy/2-0.25+random/2,0,czyj,20,16,14,0,20,true,120+random(100),10+random(60));
            if (random(2)=0) and (kfg.detale>=2) then nowywybuchdym(x,y,-dx/4,-dy/4,2,wd_dym,1,random(2)*(200+random(45)),170+random(85));
            end;
         18:begin {bomba na cialo}
           if (rez1>=0) and (koles[rez1].jest) then begin
              if koles[rez1].anikl>=druzyna[koles[rez1].team].animacje[koles[rez1].ani].klatek then
                 koles[rez1].anikl:=0;
              x:=koles[rez1].x+koles[rez1].kierunek*druzyna[koles[rez1].team].anibombana[koles[rez1].ani][koles[rez1].anikl].x;
              y:=koles[rez1].y+druzyna[koles[rez1].team].anibombana[koles[rez1].ani][koles[rez1].anikl].y;
              dx:=koles[rez1].dx;
              dy:=koles[rez1].dy;
              if koles[rez1].kierunek=1 then
                 klatka:=druzyna[koles[rez1].team].anibombana[koles[rez1].ani][koles[rez1].anikl].klatka
              else
                 klatka:=60-druzyna[koles[rez1].team].anibombana[koles[rez1].ani][koles[rez1].anikl].klatka;
              {if koles[rez1].corobi in [cr_stoi,cr_trzyma] then klatka:=0
                 else klatka:=(58+random(7)) mod 60;}
           end else begin
               ps:=dx;
               if abs(ps)<0.02 then begin
                  ps:=0;
               end else
               if abs(ps)<0.1 then begin
                  if ps<0 then ps:=-0.1
                          else ps:=0.1;
               end else
               if abs(ps)>4 then begin
                  if ps<0 then ps:=-4
                          else ps:=4;
               end;
               klatka:=klatka+ps;
               if klatka>60 then klatka:=klatka-60;
               if klatka<0 then klatka:=klatka+60;
           end;

           end;
         20:if rez1=0 then begin {bomba atomowa - obraca sie caly czas}
           ps:=sqrt2(dx*dx+dy*dy)/3;
           if abs(ps)<0.02 then begin
              ps:=0;
           end else
           if abs(ps)<0.1 then begin
              if ps<0 then ps:=-0.1
                      else ps:=0.1;
           end else
           if abs(ps)>4 then begin
              if ps<0 then ps:=-4
                      else ps:=4;
           end;
           klatka:=klatka+ps;
           if klatka>=10 then klatka:=klatka-10;
           if klatka<0 then klatka:=klatka+10;

           if (random(2)=0) and (kfg.detale>=3) then begin
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
              k:=trunc( (kk0/(pi180)) );
              e:=trunc((obr.pocisk[24].ofsy*sila)/130);
              nowywybuchdym( x-_sin(k)*e,
                             y+_cos(k)*e,
                             -dx/20,-dy/20-0.1,1,wd_dym,0,(120+random(100)),trunc(300+sila*1.3));
           end;
           end;
      end;

      {rozpylaj gaz bombo z gazem}
      if (wyglad in [17,28]) and (random(22-sila)=0) then begin
         if rez1=1 then
            strzel(x,y,random(360),random*10,1,czyj,20,16,14,0,20,true,120+random(100),10+random(60))
            else
            strzel(x,y,random(360),random*10,1,czyj,20,16,14,0,16,true,120+random(50),10+random(60));
      end;

      if odbijasie then begin
         if ((trunc(x+dx)>=0) and (trunc(y+dy)>=0) and (trunc(x+dx)<=teren.width-1) and (trunc(y+dy)<=teren.height+30) and
             (teren.maska[trunc(x+dx),trunc(y+dy)]<>0)) or
             (y+dy>=teren.height+31) then begin
              if dx>=0 then d:=1 else d:=-1;
              if (trunc(x+d)>=0) and (trunc(y)>=0) and (trunc(x+d)<=teren.width-1) and (trunc(y)<=teren.height+30) and
                 (teren.maska[trunc(x+d),trunc(y)]<>0) then begin
                 x:=x-dx;
                 case rodzaj of
                    4:dx:=-dx/3;{napalm}
                    5,14:dx:=-dx/(6+random*3); {ogien,miotacz}
                    9,16,18:dx:=-dx/3;{dynamit,chmura}
                    10:begin
                       x:=x-dx;
                       dx:=-dx*(0.9+random/5);
                       end;
                    15:dx:=-dx;
                    19:begin {roller}
                       if (trunc(x+d)>=0) and (trunc(x+d)<=teren.width-1) and
                          (trunc(y)>=1) and (trunc(y)<=teren.height+30) and
                          (teren.maska[trunc(x+d),trunc(y-1)]=0) and
                          (trunc(x)>=0) and (trunc(x)<=teren.width-1) and
                          (trunc(y)>=1) and (trunc(y)<=teren.height+1) and
                          (teren.maska[trunc(x),trunc(y+1)]<>0) then
                          y:=y-1
                       else
                          if abs(dx)>1 then dx:=-dx/1.1
                                       else dx:=-dx;
                       end
                    else dx:=-dx/2;
                 end;
              end;
              if dy>=0 then d:=1 else d:=-1;
              if ((trunc(x)>=0) and (trunc(y+d)>=0) and (trunc(x)<=teren.width-1) and (trunc(y+d)<=teren.height+30) and
                 (teren.maska[trunc(x),trunc(y+d)]<>0))
                  then begin
                 y:=y-dy;
                 case rodzaj of
                    4:begin {napalm}
                      dy:=-dy/10;
                      dy:=dy-random/3;
                      end;
                    5,14:dy:=-dy/(6+random*3); {ogien,miotacz}
                    9,18:begin {dynamit}
                      if abs(dx)<0.3 then dy:=-dy/4
                         else begin dy:=-dy/4-0.4-random/5; dx:=dx/1.4; end;
                      end;
                    10:begin
                       y:=y-dy;
                       dy:=-dy*(0.90+random/5);
                       end;
                    15:dy:=-dy;
                    16:dy:=-dy/3; {chmura}
                    19:dy:=-dy/4; {roller}
                    else {reszta}
                      dy:=-dy/2;
                 end;
              end;
              if (rodzaj=10) and ((abs(dx)>0.3) or (abs(dy)>0.3)) then begin
                 wybuch(x,y,sila-2+random(5),false,false,true,false,czyj,false);
                 if random(2)=0 then nowywybuchdym(x,y,0,0,0,wd_odblask,1+random(2),140+random(100),130+random(100));
              end;
              if (abs(dx)>=0.3) or (abs(dy)>=0.3) then begin
                 case wyglad of
                   1:form1.graj(form1.dzw_bronie_inne.Item[0],x,y,1000);
                   2:form1.graj(form1.dzw_bronie_inne.Item[1],x,y,1300);
                   6:form1.graj(form1.dzw_bronie_inne.Item[1],x,y,3000);
                   9:form1.graj(form1.dzw_bronie_inne.Item[0],x,y,1300); {zmienic!}
                   10:form1.graj(form1.dzw_bronie_inne.Item[0],x,y,1300); {zmienic!}
                   17,28:form1.graj(form1.dzw_bronie_inne.Item[1],x,y,3000);
                   24:begin
                      if ((abs(dx)>=1) or (abs(dy)>=1)) and (random(4)=0) then
                          nowysyf(x-dx,
                                  y-dy,
                                  (random*-dx),(random*-dy),
                                  0,0,1,3,false, 0,0,cardinal( $000040ff+(random($Be) shl 8)) );
                      end;
                 end;
              end;
         end;
      end;

      if (rodzaj=6) then begin {pocisk, ktora wpada w ziemie i potem dopiero wybucha}
         if (((x>=0) and (y>=0) and (x<=teren.width-1) and (y<=teren.height+29) and
             (teren.maska[trunc(x),trunc(y)]<>0)) )
             {or (y>teren.height-1)) }then begin
            if (czasdowybuchu=-1) then begin
               czasdowybuchu:=rez1+random(5);
               wysadz:=false;
            end;

            if teren.maska[trunc(x),trunc(y)]=10 then begin
               dx:=-dx;
               dy:=-dy;
            end;

            dx:=dx/1.5;
            dy:=dy/1.5;

            wybuch(x,y,(sila-2+random(5)) div 2,true,true,false,false,czyj,false);
            if random(3)=0 then
            nowywybuchdym(x,y,0,0,0,wd_swiatlo,1,170+random(80),10+random(20)+sila);
         end;
      end;

      if (wyglad=20) and (czasdowybuchu<=0) then wysadz:=true;
      if czasdowybuchu>=0 then begin
         dec(czasdowybuchu);
         if (czasdowybuchu=0) and (wyglad<>20) then wysadz:=true;
         if (czasdowybuchu=5) and (wyglad=20) then jest:=false; {znika gaz, ktory nie wybuchl-bez wybuchu!}
      end;

      if not lezy then dy:=dy+0.001*spadanie*warunki.grawitacja
         else if odbijasie then begin
             k:=1;
             if (trunc(x+k)>=0) and (trunc(y+1)>=1) and (trunc(x+k)<=teren.width-1) and (trunc(y+1)<=teren.height+30) and
                (teren.maska[trunc(x+k),trunc(y+1)]=0) and (teren.maska[trunc(x+k),trunc(y)]=0) then begin
                dx:=dx+k/2*random;
             end else begin
                k:=-1;
                if (trunc(x+k)>=0) and (trunc(y+1)>=1) and (trunc(x+k)<=teren.width-1) and (trunc(y+1)<=teren.height+30) and
                   (teren.maska[trunc(x+k),trunc(y+1)]=0) and (teren.maska[trunc(x+k),trunc(y)]=0) then begin
                   dx:=dx+k/2*random;
                end;
             end;
         end;

      if (warunki.typ_wody>=1) and (y>=wyswodywx) then begin
         case warunki.typ_wody of
            1..max_wod:begin
              if abs(dx)>gestosci[warunki.typ_wody].maxx{0.02} then dx:=dx/gestosci[warunki.typ_wody].x;
              if (rodzaj=10) and (dy>-gestosci[warunki.typ_wody].maxy*0.4) then dy:=dy-0.11;
              if abs(dy)>(spadanie/100)*gestosci[warunki.typ_wody].maxy then dy:=dy/(1.1/gestosci[warunki.typ_wody].maxy){/1.1};
              if rodzaj in [4,5,14] then begin
                 jest:=false;
                 if random(5)=0 then
                    form1.graj(form1.dzw_rozne.item[3+random(2)],x,y,7000);
                 if random(2)=0 then
                    nowywybuchdym(x-dx,y-dy-2,random/2-0.25,-0.4-random/1.6,0,wd_dym,1+random(3),random(2)*(170+random(80)),90+random(170));
              end;
              if (rodzaj in [2,12,13]) and (random(4)=0) then jest:=false;
              if (rodzaj=16) and (random(4)=0) then begin
                 jest:=false;
                 nowybombel(x,y,-0.25+random/2,-random/2,50+random(200),20+random(200));
              end;
              if (warunki.typ_wody=2) and (random(20)=0) then wysadz:=true;
              end;
         end;
      end;
      if (not (rodzaj in [4,5,14,16])) and
         (warunki.typ_wody>=1) and
         (((y-dy>=wyswodywx-10) and (y<wyswodywx-10)) or
          ((y-dy<wyswodywx-10) and (y>=wyswodywx-10))) and
         ((abs(dx)>0.8) or (abs(dy)>0.7)) then begin
         form1.graj(form1.dzw_rozne.item[5],x,y,7000);
         for k:=0 to 3+random(5)+spadanie div 2 do
             nowysyf(x-8+random(16),wyswodywx-1,(random*2-1)+dx/2,-abs(random*dy/2),0,random(5),0,2,true, 0,warunki.typ_wody);
         if wyglad>=0 then plum(x,y,dy,9,waga/30)
                      else plum(x,y,dy,9,0.6);

      end;

      if nieodbijaj=0 then begin
        for k:=0 to max_kol do begin
          if (koles[k].jest) then begin
             {jesli to pilka, to spradz, czy nie jest odpowiednio blisko i przyciagaj do kolesia}
             if (wyglad=10) and
                (sqrt2(sqr(x-koles[k].x)+sqr(y-koles[k].y))<=200) then begin
                if (x<koles[k].x) and (dx<5) then dx:=dx+0.05 else
                if (x>koles[k].x) and (dx>-5) then dx:=dx-0.05;
                if (y<koles[k].y) and (dy<5) then dy:=dy+0.05 else
                if (y>koles[k].y) and (dy>-5) then dy:=dy-0.05;
             end;
             {spradz, czy pocisk nie trafil przypadkiem postaci}
             if (x>=koles[k].x-10) and (y>=koles[k].y-10) and
                (x<=koles[k].x+10) and (y<=koles[k].y+10) then begin
                 if (not odbijasie) or (rodzaj=5) then begin
                     //jest:=false;
                     if czyj>=0 then koles[k].zabic:=czyj;
                     wysadz:=true;
                 end else begin
                     x:=x-dx;
                     y:=y-dy;
                     dx:=-dx/2.5;
                     dy:=dy/2;
                 end;
                 if (rodzaj=10) and ((abs(dx)>0.3) or (abs(dy)>0.3)) then begin
                     wybuch(x,y,sila-2+random(5),false,false,true,false,czyj,false);
//                     if random(3)=0 then
                        //nowywybuchdym(x,y,0,0,0,wd_odblask,1+random(2),140+random(100),130+random(100));
                        nowywybuchdym(x,y,0,0,0,wd_swiatlo,1,70+random(50),trunc(40+sila/3),$FF7000+random(120) shl 8+random(200));
                 end else
                 if (rodzaj=15) and ((abs(dx)>0.01) or (abs(dy)>0.01)) then begin
                     wybuch(x,y,(sqrt(sqr(dx)+sqr(dy))+sqrt(sqr(koles[k].dx)+sqr(koles[k].dy)))*3,false,false,true,false,czyj,true);
                 end;
             end else
             {jesli nie, to moze sprobuj kopnac}
             if (vars.bron.sterowanie<>k) and
                (rodzaj in [1,9,10,18,19]) and
                (koles[k].corobi in [cr_stoi,cr_idzie,cr_biegnie]) and
                (x>=koles[k].x-15) and (y>=koles[k].y-12) and
                (x<=koles[k].x+15) and (y<=koles[k].y+15) and
                (random(45)=0) then begin
                 koles[k].corobil:=koles[k].corobi;
                 if y>=koles[k].y+2 then koles[k].corobi:=cr_kopie
                    else if y>=koles[k].y-6 then koles[k].corobi:=cr_bije
                         else koles[k].corobi:=cr_grzywa;
                 koles[k].anikl:=0;
                 koles[k].anido:=0;
                 koles[k].cochcekopnac:=2;
                 koles[k].ktoregochcekopnac:=a;
                 if x>=koles[k].x then koles[k].kierunek:=1 else koles[k].kierunek:=-1;
             end else
             {jesli nie, to jak to pocisk naprowadzany, to niech szuka postaci i leci za nia}
             if (rodzaj=7) and
                (x>=koles[k].x-200) and (y>=koles[k].y-200) and
                (x<=koles[k].x+200) and (y<=koles[k].y+200) then begin
                if (x>=koles[k].x) and (dx>-5) then dx:=dx-0.07
                   else if (dx<5) then dx:=dx+0.07;
                if (y>=koles[k].y) and (dy>-5) then dy:=dy-0.07
                   else if (dy<5) then dy:=dy+0.07;
                if (koles[k].corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_plynie]) and
                   (random(3)=0) then begin
                   if (vars.bron.sterowanie<>k) and (koles[k].corobi<>cr_plynie) then koles[k].corobi:=cr_biegnie;
                   if koles[k].x>x then koles[k].kierunek:=1
                      else koles[k].kierunek:=-1;
                   if (vars.bron.sterowanie<>k) and (random(150)=0) then koles[k].skocz:=true;
                end;
             end else
             {jesli nie trafil, to sprawdz, czy jest blisko, i moze postac bedzie uciekac?}
             if (vars.bron.sterowanie<>k) and
                ((odbijasie) or (rodzaj in [4,5,14,16])) and
                (x>=koles[k].x-130) and (y>=koles[k].y-100) and
                (x<=koles[k].x+130) and (y<=koles[k].y+60) and
                (abs(koles[k].dx)<=1) and (abs(koles[k].dy)<=1) and
                (koles[k].corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_plynie]) and
                ( ((rodzaj in [4,5,14,9]) and (random(2)=0)) or
                  ((rodzaj=18) and (rez1>=0) and (random(3)=0)) or
                  (random(30)=0)) then begin
                if (koles[k].corobi<>cr_plynie) then begin
                   koles[k].corobi:=cr_biegnie;
                   if (rodzaj=16) and (random(70)=0) then
                      form1.graj(druzyna[koles[k].team].dzwieki.Item[14],koles[k].x,koles[k].y,10000);

                end;
                if koles[k].x>x then koles[k].kierunek:=1
                   else koles[k].kierunek:=-1;
                if (random(10)=0) then koles[k].skocz:=true;
             end;
          end;
        end;
      end else dec(nieodbijaj);

      {spradz, czy pocisk nie trafil przypadkiem miesa}
      if not wysadz then
         for k:=0 to max_mieso do
          if (mieso[k].jest) and
             (x>=mieso[k].x-5) and (y>=mieso[k].y-5) and
             (x<=mieso[k].x+5) and (y<=mieso[k].y+5) and
             ((rodzaj<>10) or
              ((rodzaj=10) and ((abs(dx)>0.5) or (abs(dy)>0.5))))
             then begin
               if (not odbijasie) or (rodzaj=5) then begin
                   wysadz:=true;
               end else begin
                   x:=x-dx;
                   y:=y-dy;
                   dx:=-dx/2.5;
                   dy:=dy/2;
               end;
          end;

      {spradz, czy pocisk nie trafil przypadkiem zwierzaka}
      if not wysadz then
         for k:=0 to max_zwierz do
          if (zwierz[k].jest) and
             (x>=zwierz[k].x-5) and (y>=zwierz[k].y-5) and
             (x<=zwierz[k].x+5) and (y<=zwierz[k].y+5) and (
              (not odbijasie) or
              (abs(zwierz[k].dx)>0.6) or (abs(zwierz[k].dy)>0.6) or
              (abs(dx)>0.6) or (abs(dy)>0.6)  ) and
             ((rodzaj<>10) or
              ((rodzaj=10) and ((abs(dx)>0.5) or (abs(dy)>0.5))))
             then begin
               if (not odbijasie) or (rodzaj=5) then begin
                   wysadz:=true;
               end else begin
                   x:=x-dx;
                   y:=y-dy;
                   dx:=-dx/2.5;
                   dy:=dy/2;
               end;
               if (rodzaj=10) and ((abs(dx)>0.3) or (abs(dy)>0.3)) then begin
                   wybuch(x,y,sila-2+random(5),false,false,true,false,czyj,false);
                   if random(3)=0 then nowywybuchdym(x,y,0,0,0,wd_odblask,1+random(2),140+random(100),130+random(100));
               end else
               if (rodzaj=15) and ((abs(dx)>0.01) or (abs(dy)>0.01)) then begin
                   wybuch(x,y,(sqrt(sqr(dx)+sqr(dy))+sqrt(sqr(koles[k].dx)+sqr(koles[k].dy)))*3,false,false,true,false,czyj,true);
               end;
          end;

      {sprawdz czy pocisk nie trafil miny}
      if not wysadz and (rodzaj in [0..15,17..99]) then
         for k:=0 to max_mina do
          if (mina[k].jest) and
             (x>=mina[k].x-minrozm[mina[k].rodzaj]) and (y>=mina[k].y-minrozm[mina[k].rodzaj]) and
             (x<=mina[k].x+minrozm[mina[k].rodzaj]) and (y<=mina[k].y+minrozm[mina[k].rodzaj]) and
             ((rodzaj<>10) or
              ((rodzaj=10) and ((abs(dx)>0.5) or (abs(dy)>0.5))))
             then begin
                 mina[k].dx:=mina[k].dx+dx/2;
                 mina[k].dy:=mina[k].dy+dy/2;
                 if mina[k].rodzaj in [0..1] then mina[k].aktywna:=true;
                 if (not odbijasie) or (rodzaj=5) then begin
                     wysadz:=true;
                 end else begin
                     x:=x-dx;
                     y:=y-dy;
                     dx:=-dx/2.5;
                     dy:=dy/2;
                 end;
             end;

      {                    WYBUCH!                     }
      if (wysadz) or ((rodzaj=20) and (rez1>=1)) or
         (not odbijasie and (rodzaj<>6) and
          (((x>=0) and (y>=0) and (x<=teren.width-1) and (y<=teren.height+30) and
           (teren.maska[trunc(x),trunc(y)]<>0)) {or (y>teren.height-1)}))
         then begin
         case wyglad of
           -1:begin {pocisk z karabinu/minigana}
             form1.graj(form1.dzw_bronie_inne.Item[6+random(3)],x,y,5000);
             wybuch(x,y,sila-2+random(5),true,true,true,false,czyj,true);
             nowywybuchdym(x,y,0,0,1,wd_wybuch,1+random(3),170+random(80),20+random(50)+sila*4);
             if random(3)=0 then
                nowysyf(x-dx,y-dy,random(360),2+random*sila/6,1,random(5),0,1,false);
           end;
           0,1,3,21,23,24,25,26:begin {z bazuki, granat, etc}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             bool:=(wyglad=23) and (rez2=1);
             wybuch(x,y,sila-2+random(5),true,true,true,bool,czyj,false);
             for k:=0 to random(3)+random(trunc(sila/30)) do
                 nowywybuchdym(x,y,random/2-0.25,-0.4-random/1.6,random(1),wd_dym,1+random(5),random(2)*(170+random(80)),random(100)+sila*5);
             nowywybuchdym(x,y,0,0,random(4),wd_wybuch,1+random(4),random(2)*(220+random(35)),random(100)+sila*5);
             if (sila>=30) and (random(4)=0) then nowywybuchdym(x,y,0,0,random(2),wd_odblask,4+random(5),250);
             if (wyglad<>3) and (sila>=20) and (random(3)=0) then nowywybuchdym(x,y,0,0,0,wd_swiatlo,5,40+random(40),sila*3);

             for k:=0 to sila div 15+random(2) do
                 nowysyf(x-dx,y-dy,{(random(2)*2-1)*(1+random*4),-1+random*2,0,}random(360),2+random*sila/6,1,random(5),1,1,false);

             if wyglad=3 then begin {odlamek bomby}
                for k:=0 to random(5) do
                    nowywybuchdym(x,y,random-0.5,random-0.5,2,wd_dym,2+random(4),random(2)*(200+random(45)),150+random(140));
                if (sila>=10) and (random(3)=0) then nowywybuchdym(x,y,0,0,0,wd_swiatlo,2,50+random(40),5+sila*4, $4097ff);

             end;

           end;
           9:begin {dynamit}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             wybuch(x,y,sila-2+random(5),true,true,true,false,czyj,false);
             for k:=1 to sila div 30 do
                 wybuch(x-sila div 6+random(sila div 3),y-sila div 6+random(sila div 3),sila-2+random(5),true,true,true,false,czyj,false);

             if (kfg.detale>=2) then
                 for k:=0 to random(3)+random(trunc(sila/30)) do
                     nowywybuchdym(x,y,random/2-0.25,-0.4-random/1.6,random(1),wd_dym,1+random(5),random(2)*(170+random(80)),random(100)+sila*5);

             nowywybuchdym(x,y,
                           0,0,random(4),wd_wybuch,5+sila div 30,random(2)*(220+random(35)),random(100)+sila*5);
             for k:=0 to 2+sila div 20+random(3) do begin
                 k1:=random(360);
                 k2:=(3+random*(sila/23))/7;
                 nowywybuchdym(x,y,
                               _sin(trunc(k1))*k2, -_cos(trunc(k1))*k2,
                               random(4),wd_wybuch,1+random(4)+sila div 30,random(2)*(220+random(35)),random(50)+sila*2);
             end;
             for k:=0 to sila div 20+random(2) do
                 nowywybuchdym(x-sila div 6+random(sila div 3),y-sila div 6+random(sila div 3),
                               0,0,random(4),wd_wybuch,1+random(4)+sila div 30,random(2)*(220+random(35)),random(100)+sila*5);

             if (sila>=30) and (random(4)=0) then nowywybuchdym(x,y,0,0,random(2),wd_odblask,4+random(5),250);
             if (sila>=20) and (random(3)=0) then nowywybuchdym(x,y,0,0,0,wd_swiatlo,5,40+random(40),sila*3);

             for k:=0 to sila div 15+random(2) do
                 nowysyf(x-dx,y-dy,{(random(2)*2-1)*(1+random*4),-1+random*2,0,}random(360),2+random*sila/6,1,random(5),1,1,false);
           end;
           2:begin {bomba}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             wybuch(x,y,sila-2+random(5),true,true,true,false,czyj,false);
             for k:=0 to random(3)+random(trunc(sila/30)) do
                 nowywybuchdym(x,y,random/2-0.25,-0.4-random/1.6,random(1),wd_dym,1+random(5),random(2)*(170+random(80)),random(100)+sila*5);
             nowywybuchdym(x,y,0,0,random(4),wd_wybuch,1+random(4),random(2)*(220+random(35)),random(100)+sila*5);
             if (sila>=30) and (random(4)=0) then nowywybuchdym(x,y,0,0,random(2),wd_odblask,3+random(5),250);
             if (sila>=10) and (random(3)=0) then nowywybuchdym(x,y,0,0,0,wd_swiatlo,5,60+random(50),sila*4, $1067ff);
             d:=trunc(sila/13);
             if d<3 then d:=3;
             for k:=0 to d do
                 strzel(x,y,random(360),5+random*6,1,czyj,10+random(10),3,40,70,3,false,200+random(100));
             for k:=0 to sila div 15+random(2) do
                 nowysyf(x-dx,y-dy,{(random(2)*2-1)*(1+random*4),-1+random*2,0,}random(360),2+random*sila/6,1,random(5),1,1,false);
             for k:=0 to 10+random(15) do
                 nowywybuchdym(x,y,random-0.5,random-0.5,2,wd_dym,2+random(4),random(2)*(200+random(45)),170+random(200));
             end;
           5:begin {ogien}
             if (random(7)=0) then wybuch(x,y,5+random(5),false,true,true,true,czyj,false);
             end;
           6:begin {z gwozdziami}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             wybuch(x,y,sila-2+random(5),true,true,true,false,czyj,false);
             for k:=0 to random(4)+random(trunc(sila/50)) do
                 nowywybuchdym(x,y,random/2-0.25,-0.4-random/1.6,0,wd_dym,1+random(5),random(2)*(170+random(80)),random(100)+sila*5);
             nowywybuchdym(x,y,0,0,random(4),wd_wybuch,1+random(4),random(2)*(220+random(35)),random(100)+sila*5);
             if (sila>=30) and (random(4)=0) then nowywybuchdym(x,y,0,0,random(2),wd_odblask,2,250);
             d:=trunc(sila/1.6);
             if d<15 then d:=15;
             for k:=0 to d do
                 strzel( x, y,
                         (360/d)*k,
                         5+random*3, 1,
                         czyj,
                         10+random(10),
                         2,60,3,-1,boolean(random(2)),200+random(200));
             for k:=0 to sila div 15+random(2) do
                 nowysyf(x-dx,y-dy,{(random(2)*2-1)*(1+random*4),-1+random*2,0,}random(360),2+random*sila/6,1,random(5),1,1,false);
             end;
           7:begin {duzy granat}
             form1.graj(form1.dzw_bronie_inne.Item[4],x,y,5000);
             nowywybuchdym(x,y,0,0,0,wd_swiatlo,1,40+random(40),sila*3);
             nowywybuchdym(x,y,0,0,random(2),wd_odblask,2,250);
             for k:=0 to rez1+random(3) do
                 strzel(x-dx,y-dy,random(360),10+random*10,1,czyj,sila-5+random(10),1,30,80,1,true,rez2);
             for k:=0 to rez1+5+random(15) do
                 nowywybuchdym(x,y,random-0.5,random-0.5,2,wd_dym,2+random(4),random(2)*(200+random(45)),170+random(200));
             end;
           8:begin {kula ognista}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             wybuch(x,y,sila-2+random(5),true,true,true,true,czyj,false);
             for k:=0 to random(3)+random(trunc(sila/30)) do
                 nowywybuchdym(x,y,random/2-0.25,-0.4-random/1.6,random(1),wd_dym,1+random(5),random(2)*(170+random(80)),random(100)+sila*5);
             nowywybuchdym(x,y,0,0,random(4),wd_wybuch,1+random(4),random(2)*(220+random(35)),random(100)+sila*5+60);
             nowywybuchdym(x,y,0,0,0,wd_swiatlo,1,60+random(40),sila*5);
             nowywybuchdym(x,y,0,0,random(2),wd_odblask,2,140+sila*4);
             d:=trunc(sila/13);
             if d<3 then d:=3;
             for k:=0 to d+25 do
                 strzel(x-dx,y-dy,random(360),3+random*6,1,czyj,10+random(10),5,10,-20,5,boolean(random(2)),75-random(10));
             for k:=0 to sila div 15+random(2) do
                 nowysyf(x-dx,y-dy,random(360),2+random*sila/6,1,random(5),1,1,false);
             for k:=0 to sila div 2+random(15) do
                 nowysyf(x-dx,y-dy,random(360),3.5+random*sila/4,1,
                         0,1,3,true, 0,0,cardinal( $000040ff+(random($Be) shl 8)) );

             end;
           10:begin {pilka}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             wybuch(x,y,sila-2+random(5),true,true,true,false,czyj,false);
             for k:=0 to random(3)+random(trunc(sila/30)) do
                 nowywybuchdym(x,y,random/2-0.25,-0.4-random/1.6,random(1),wd_dym,1+random(5),random(2)*(170+random(80)),random(100)+sila*5);
             nowywybuchdym(x,y,0,0,random(4),wd_wybuch,1+random(4),random(2)*(220+random(35)),random(100)+sila*5+60);
             nowywybuchdym(x,y,0,0,0,wd_swiatlo,1,60+random(40),sila*5);
             nowywybuchdym(x,y,0,0,random(2),wd_odblask,2,140+sila*4);
             for k:=0 to sila div 15+random(2) do
                 nowysyf(x-dx,y-dy,random(360),2+random*sila/6,1,random(5),1,1,false);

             end;
           11:begin {bazuka z napalmem}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             wybuch(x,y,sila-2+random(5),true,true,true,true,czyj,false);
             for k:=0 to random(3)+random(trunc(sila/30)) do
                 nowywybuchdym(x,y,random/2-0.25,-0.4-random/1.6,random(1),wd_dym,1+random(5),random(2)*(170+random(80)),random(100)+sila*5);
             nowywybuchdym(x,y,0,0,random(4),wd_wybuch,1+random(4),random(2)*(220+random(35)),random(100)+sila*5+60);
             nowywybuchdym(x,y,0,0,0,wd_swiatlo,1,60+random(40),sila*5);
             nowywybuchdym(x,y,0,0,random(2),wd_odblask,2,140+sila*4);
             d:=trunc(sila/2);
             if d<3 then d:=3;
             for k:=0 to d+5 do
                 strzel(x-dx,y-dy,70+random(220),1+random*4,1,czyj,10+random(4),4,40,110,4,true,300+random(150));
             {for k:=0 to sila div 15+random(2) do
                 nowysyf(x-dx,y-dy,random(360),2+random*sila/6,1,random(5),1,1,false);}

             end;
           12:begin {bfg}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             wybuch(x,y,sila-2+random(5),true,true,true,false,czyj,false);
             nowywybuchdym(x,y,0,0,5,wd_wybuch,2+random(4),0,random(120)+sila*5+60);
             nowywybuchdym(x,y,0,0,0,wd_swiatlo,4,120+random(40),30+sila*5,$FF8030);
             nowywybuchdym(x,y,0,0,random(2),wd_odblask,2,140+sila*4);
             for k:=0 to max_kol do
                 if (koles[k].jest) then begin
                    ps:=sqrt2(sqr(x-koles[k].x)+sqr(y-koles[k].y));
                    if (ps<=4*sila) then begin
                       ps:=((4*sila)-ps)/6;

                       wybuch(koles[k].x,koles[k].y,ps-2+random(5),false,true,true,false,czyj,false);
                       nowywybuchdym(koles[k].x,koles[k].y,0,0,5,wd_wybuch,1,255,trunc(random(70)+ps*8+100));
                       nowywybuchdym(koles[k].x,koles[k].y,0,0,0,wd_swiatlo,1,60+random(40),trunc(30+ps*5),$FF6015);
                       nowywybuchdym(koles[k].x,koles[k].y,0,0,random(2),wd_odblask,1,trunc(140+ps*4));

                    end;
                 end;
             for k:=0 to max_zwierz do
                 if (zwierz[k].jest) then begin
                    ps:=sqrt2(sqr(x-zwierz[k].x)+sqr(y-zwierz[k].y));
                    if (ps<=4*sila) then begin
                       ps:=((4*sila)-ps)/6;

                       wybuch(zwierz[k].x,zwierz[k].y,ps-2+random(5),false,true,true,false,czyj,false);
                       nowywybuchdym(zwierz[k].x,zwierz[k].y,0,0,5,wd_wybuch,1,255,trunc(random(70)+ps*8+100));
                       nowywybuchdym(zwierz[k].x,zwierz[k].y,0,0,0,wd_swiatlo,1,60+random(40),trunc(30+ps*5),$FF6015);
                       nowywybuchdym(zwierz[k].x,zwierz[k].y,0,0,random(2),wd_odblask,1,trunc(140+ps*4));

                    end;
                 end;
             end;
           13:begin {proton}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             wybuch(x,y,sila-2+random(5),false,true,true,false,czyj,false);
             nowywybuchdym(x,y,0,0,5,wd_wybuch,1+random(3),random(2)*(175+random(80)),random(120)+sila*5+30);
             nowywybuchdym(x,y,0,0,0,wd_swiatlo,1,60+random(40),30+sila*2,$FF8030);
             nowywybuchdym(x,y,0,0,random(2),wd_odblask,1+random(2),140+sila*4,140+sila*3);
             end;
           14:begin {miotacz}
             if (random(3)=0) then wybuch(x,y,sila,false,true,true,true,czyj,false);
             end;
           15:begin {noze}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             wybuch(x,y,sila-2+random(5),true,true,true,false,czyj,false);
             nowywybuchdym(x,y,0,0,random(4),wd_wybuch,1+random(4),random(2)*(220+random(35)),random(100)+sila*5);
             if (random(5)=0) then nowywybuchdym(x,y,0,0,0,wd_swiatlo,5,40+random(40),sila*3);
             end;
           {16: chmura}
           17,28:begin {bomba z gazem}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             if rez1=1 then
                wybuch(x,y,sila-2+random(5),true,true,true,false,czyj,false)
                else
                wybuch(x,y,sila-2+random(5),false,true,false,false,czyj,false);
             for k:=0 to 3+random(3) do
                 nowywybuchdym(x,y,random/2-0.25,-0.4-random/1.6,random(1),wd_dym,1+random(5),random(2)*(170+random(80)),random(100)+sila*5);
             if rez1=1 then nowywybuchdym(x,y,0,0,0,wd_swiatlo,1,60+random(40),140+random(80),$FF30C0)
                       else nowywybuchdym(x,y,0,0,0,wd_swiatlo,1,60+random(40),140+random(80),$00FF00);

             for k:=0 to 2+random(3) do
                 nowysyf(x-dx,y-dy,random(360),2+random*2,1,random(5),1,1,false);
             end;
           18:begin {bazuka z gazem}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             d:=trunc(sila/2);
             if d<3 then d:=3;
             for k:=0 to d+5 do
                 strzel(x-dx,y-dy,random(360),1+random*15,1,czyj,20,16,14,0,16,true,120+random(150),10+random(60));
             wybuch(x,y,sila-2+random(5),true,true,true,false,czyj,false);
             for k:=0 to random(3)+random(trunc(sila/30)) do
                 nowywybuchdym(x,y,random/2-0.25,-0.4-random/1.6,random(1),wd_dym,1+random(5),random(2)*(170+random(80)),random(100)+sila*5);
             nowywybuchdym(x,y,0,0,random(4),wd_wybuch,1+random(4),random(2)*(220+random(35)),random(100)+sila*5+60);
             nowywybuchdym(x,y,0,0,0,wd_swiatlo,1,60+random(40),sila*5,$00FF00);
             nowywybuchdym(x,y,0,0,random(2),wd_odblask,2,140+sila*4);
             for k:=0 to sila div 15+random(2) do
                 nowysyf(x-dx,y-dy,random(360),2+random*sila/6,1,random(5),1,1,false);

             end;
           19:begin {molotov}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             wybuch(x,y,sila-2+random(5),false,true,true,true,czyj,false);
             //nowywybuchdym(x,y,0,0,random(4),wd_wybuch,1+random(4),random(2)*(220+random(35)),random(100)+sila*5+100);
             nowywybuchdym(x,y,0,0,0,wd_swiatlo,3,60+random(40),180+sila*3);
             d:=trunc(sila/2);
             if d<3 then d:=3;
             for k:=0 to d+5 do
                 strzel(x-dx-3+random(7),y-dy-3+random(7),random(360),1+random*4,1,czyj,10+random(4),4,40,100,4,true,50+random(150));
             for k:=0 to d+5 do
                 strzel(x-dx,y-dy,random(360),0.7+random*2.5,1,czyj,10+random(4),5,10,-20,5,boolean(random(2)),50-random(15));

             end;
           20:begin {gaz}
             form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
             wybuch(x,y,30+random(25),boolean(random(2)),true,true,false,czyj,false);
             if random(10)=0 then begin
                nowywybuchdym(x,y,random-0.5,-random*1.4,0,wd_dym,2+random(7),random(2)*(170+random(80)),200+random(200));
                nowywybuchdym(x,y,0,0,random(4),wd_wybuch,1+random(4),(100+random(155)),80+random(200));
             end;
             if random(4)=0 then
                nowywybuchdym(x,y,0,0,0,wd_swiatlo,random(10),10+random(100),100+random(100),$FF0050+random(100)-(random(100) shl 16));
           end;
           27:begin {bloto}
             form1.graj(form1.dzw_bronie_inne.Item[4],x,y,5000);
             nowywybuchdym(x,y,0,0,0,wd_swiatlo,2,40+random(40),sila*10,$154080);
             //nowywybuchdym(x,y,0,0,random(2),wd_odblask,2,250);
             for k:=0 to 5+sila div 2+random(5) do
                 nowywybuchdym(x,y,random-0.5,random-0.5,2,wd_dym,2+random(4),140+random(80),170+random(200));

             if (x>=0) and (y>=0) and
                (x<=teren.width-1) and (y<=teren.height+10) and
                (teren.maska[trunc(x),trunc(y)+1]>0) then begin
                 b1:=rysowanie.ziarna;
                 bool:=rysowanie.ztylu;
                 b2:=rysowanie.ksztaltpedzla;
                 b3:=rysowanie.maskowanie;
                 rysowanie.ziarna:=20;
                 rysowanie.ztylu:=false;
                 rysowanie.maskowanie:=2;
                 rysowanie.ksztaltpedzla:=0;
                 rysuj_kolko_kol(trunc(x),trunc(y),sila, $504015+(random(30) shl 16), rez1);
                 rysowanie.twardosc:=rez1;
                 rysowanie.ziarna:=b1;
                 rysowanie.ztylu:=bool;
                 rysowanie.ksztaltpedzla:=b2;
                 rysowanie.maskowanie:=b3;
                 for k:=0 to 3+sila div 4+random(3) do begin
                     e:=random(360);
                     nowysyf(x+_sin(e)*(sila+2),y-_cos(e)*(sila+2),e,2+random*2,1,random(5),0,1,false);
                 end;
             end else begin
                 wybuch(x,y,7+sila-2+random(5),false,false,true,false,czyj,false);
                 for k:=0 to 4+sila+random(3) do
                     nowysyf(x-dx,y-dy,random(360),2+random*2,1,random(5),0,1,false);
             end;
             end;
           29:begin {bomba atomowa}

             case rez1 of
               0:begin //poczatek
                 form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
                 wybuch(x,y,sila*2-2+random(5),false,false,true,true,czyj,false);
               //  for k:=0 to random(3)+random(trunc(sila/30)) do
                //     nowywybuchdym(x,y,random/2-0.25,-0.4-random/1.6,random(1),wd_dym,1+random(5),random(2)*(170+random(80)),random(100)+sila*5);
                //nowywybuchdym(x,y,0,0,random(2),wd_odblask,4+random(5),250);
                 nowywybuchdym(x,y,0,0,0,wd_swiatlo,60,127,170+sila*4, $90ffff);

                    end;
               2,6,12:begin
                 wybuch(x,y,(sila-2+random(5))/(rez1/2),true,true,true,false,czyj,false);
                 end;
              14:for k:=0 to 40 do
                     nowywybuchdym( x-sila div 6+random(sila div 3),
                               y-random(sila),
                               0,
                               0,
                               0,wd_dym,
                               9+random(4),
                               0,
                               trunc(800+random*sila/3),
                               $FFFFFF,
                               false);

              30:begin //wybuch sprajt
                 nowywybuchdym(x,y,0,0,1,wd_wybuch,4,200+random(35),60+sila*5);
                 nowywybuchdym(x,y,0,0,2,wd_wybuch,10,0,100+sila*5);
                 end;
             end;//case

             if rez1>=14 then
                nowywybuchdym( x-sila div 6+random(sila div 3),
                                 y-random(trunc(rez1/1.5)+sila div 2),
                                 0,
                                 0,
                                 0,wd_dym,
                                 7+random(4),
                                 0,
                                 trunc(700+random*sila/3),
                                 $FFFFFF,false);
             if rez1>=25 then
                nowywybuchdym( x,
                               y-rez1/1.5+random(sila div 3)-sila div 2,
                               (random(2)*2-1)*(random/1.2),
                               -0.3,
                               0,wd_dym,
                               3+random(4)+rez1 div 40,
                               0,
                               trunc(500+random*sila/3),
                               $FFFFFF,
                               false);

             if (rez1>=3) and (rez1<280) and (random(4)=0) then
                nowywybuchdym( x-random(sila div 2)+sila div 4,
                               y-random(sila div 2)+sila div 4,
                               random/2-0.25,
                               -random/4,
                               3,wd_dym,
                               3+random(4)+rez1 div 40,
                               200-random(130),
                               trunc(500+random*sila/3),
                               $FFFFFF,false);


             if (rez1<60) and (rez1 mod 8=0) then
                nowywybuchdym(x,y,0,0,0,wd_swiatlo,10,124-rez1*2,100+sila*4, cardinal($ffffff- byte(rez1*4) shl 16 ));

             dx:=0;
             dy:=0;
             inc(rez1);
             if rez1<340 then jest:=true
                         else jest:=false;

           end;//29:

         end;//case
         if wyglad<>29 then jest:=false;
      end;

      inc(dowielokrotnosc);
   end;
   if (lezy) and (abs(dx)<0.1) then dx:=0;
   if (lezy) and (abs(dy)<0.1) then dy:=0;

   if (ekran.iletrzes>=3) and (lezy) then begin
      dx:=dx+random/10-0.05;
      dy:=dy+random/10-0.05;
   end;

end;

if not kfg.calkiem_bez_dzwiekow then begin
    if jest_ogien and not dzwieki_ciagle.ogien and kfg.jest_dzwiek then begin
       form1.dzw_bronie_inne.Item[5].Play;
       dzwieki_ciagle.ogien:=true;
    end else
    if not jest_ogien and dzwieki_ciagle.ogien then begin
       form1.dzw_bronie_inne.Item[5].Stop;
       dzwieki_ciagle.ogien:=false;
    end;
end;

end;

procedure rysuj_pociski;
var
a,n:longint;
kk0:real;
wx,wy,b:smallint;
xsize,ysize,skala:integer;
bx,by:integer;

begin
for a:=0 to max_poc do
  if (poc[a].jest) and (poc[a].wyglad>=-1) then with poc[a] do begin
    if (x+10-ekran.px>=0) and (y+10-ekran.py>=0) and
       (x-10-ekran.px<=ekran.width) and (y-10-ekran.py<=ekran.height-ekran.menux) then begin

       if (rodzaj in [0,6,7,11,17,20]) or (wyglad in [4,14,25]) or (wyglad=-1) then begin {obraca sie w kierunku, w ktorym leci}
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

           n:=trunc( (kk0/(pi180))/6 );
       end else {ma ustalona juz klatke i ja pokazujmy}
           n:=trunc(klatka);

       if lezy then begin
          wx:=ekran.trzesx;
          wy:=ekran.trzesy;
       end else begin
           wx:=0;
           wy:=0;
       end;

       case wyglad of
        -1:{pociski z pistoletu}
           form1.PowerDraw1.RotateEffect( obr.pocisk[wyglad].surf,
                        trunc(x-obr.pocisk[wyglad].ofsx)-ekran.px,
                        trunc(y-obr.pocisk[wyglad].ofsy)-ekran.py+15,
                        trunc((kk0/(pi180))/1.40625),256,0,effectSrcAlpha or effectDiffuse);
         5:begin {ogien}
           if rez2=0 then begin
               if czasdowybuchu>=30 then skala:=200+random(55)
                  else skala:=40+trunc(czasdowybuchu*3)+random(150-czasdowybuchu*5);
               form1.drawsprajtalpha(obr.pocisk[wyglad],
                         trunc(x-obr.pocisk[wyglad].ofsx)-ekran.px+wx,
                         trunc(y-obr.pocisk[wyglad].ofsy)-ekran.py+wy,
                         n,
                         skala);
           end else
               form1.PowerDraw1.RenderEffectcol(obr.pocisk[wyglad].surf,
                         trunc(x-obr.pocisk[wyglad].ofsx)-ekran.px+wx,
                         trunc(y-obr.pocisk[wyglad].ofsy)-ekran.py+wy,
                         $FFFFFFFF,
                         n,
                         effectsrcalpha or effectadd);

           end;
         4,14:begin {napalm}
           if (dx=0) and (dy=0) then skala:=1
              else skala:=trunc( sqrt(abs(sqr(dx)+sqr(dy)))*70 );
           if skala<200 then skala:=200;
           if (abs(dx)<=0.3) and (abs(dy)<=0.3) and (x>=0) and (y>=0) and
               (x<=teren.width-1) and (y<=teren.height-30) and
               (teren.maska[trunc(x),trunc(y)+1]>0) and
               (skala<400) then begin
                   skala:=400+random(200);
                   kk0:=4.70+random/10;
           end;
           Xsize:= obr.pocisk[4].surf.PatternWidth-skala div 50;//(obr.pocisk[wyglad].surf.PatternWidth * Skala) div 256;
           Ysize:= (obr.pocisk[4].surf.PatternHeight * Skala) div 256;

           form1.powerdraw1.TextureMap( obr.pocisk[4].surf,
                                        pRotate4(trunc(x)-ekran.px+wx,
                                                 trunc(y)-ekran.py+wy,
                                                 Xsize,
                                                 Ysize,
                                                 Xsize div 2,
                                                 Ysize div 2,
                                                 trunc((kk0/(pi180))/1.40625)),
                                        cColor1(cardinal(((50+random(200)) shl 24) or $FFFFFF)),
                                        tPattern(trunc(klatka)),
                                        effectSrcAlpha or effectAdd);
           end;
         8:begin{kula ognista}
           form1.drawsprajt(obr.pocisk[4],trunc(x-obr.pocisk[4].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[4].ofsy)-ekran.py+wy,n);
           form1.PowerDraw1.TextureMap(obr.wybuchdym[wd_swiatlo,0].surf,
              pRotate4(trunc(x)-ekran.px,
                       trunc(y)-ekran.py,
                       50+sila,
                       50+sila,
                       25+sila div 2,//sx div 2,
                       25+sila div 2,//sy div 2,
                       trunc(x-ekran.px+y-ekran.py) div 2
                       ),
                       cColor1($3560EFFF),
                       tPattern(0),
                       effectSrcAlpha or effectDiffuse or effectadd);
           nowa_flara(trunc(x-ekran.px+ekran.trzesx+wx), trunc(y-ekran.py+ekran.trzesy+wy),sila*2,$4060EFFF);
           end;
         11,18:{bazuka z napalmem, z gazem}
           form1.drawsprajt(obr.pocisk[0],trunc(x-obr.pocisk[0].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[0].ofsy)-ekran.py+wy,n);
         12:begin{bfg}
           form1.drawsprajt(obr.pocisk[11],trunc(x-obr.pocisk[11].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[11].ofsy)-ekran.py+wy,n);
//           nowywybuchdym(x,y,0,0,0,wd_swiatlo,4,120+random(40),30+sila*5,$FF8030);

           form1.PowerDraw1.TextureMap(obr.wybuchdym[wd_swiatlo,0].surf,
              pRotate4(trunc(x)-ekran.px,
                       trunc(y)-ekran.py,
                       60+sila,
                       60+sila,
                       30+sila div 2,//sx div 2,
                       30+sila div 2,//sy div 2,
                       trunc(x-ekran.px+y-ekran.py) div 2
                       ),
                       cColor1($35FF8030),
                       tPattern(0),
                       effectSrcAlpha or effectDiffuse or effectadd);

           nowa_flara(trunc(x-ekran.px+ekran.trzesx+wx), trunc(y-ekran.py+ekran.trzesy+wy),sila*2,$40FF9070);
           end;
         13:{proton}
           form1.PowerDraw1.RenderEffect(obr.pocisk[11].surf,trunc(x-obr.pocisk[11].ofsx shr 1)-ekran.px+wx,trunc(y-obr.pocisk[11].ofsy shr 1)-ekran.py+wy,128,n,effectsrcalpha or effectdiffuse);
         15:{noze}
           form1.drawsprajt(obr.pocisk[12],trunc(x-obr.pocisk[12].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[12].ofsy)-ekran.py+wy,n);
         16:begin {chmura}
           if czasdowybuchu<=120 then b:=30-czasdowybuchu shr 2
                                else b:=0;
           if czasdowybuchu<=60 then skala:=czasdowybuchu*4
              else begin
                   if rez1<245 then skala:=rez1
                               else skala:=255-random(10);
                   end;
           form1.PowerDraw1.TextureMap(obr.pocisk[13].surf,
                     pRotate4c(trunc(x-ekran.px{-rez2{-b}),
                              trunc(y-ekran.py{-rez2{-b}),
                              rez2 shl 1+b shl 1,
                              rez2 shl 1+b shl 1, rez3 shr 3),
                     cColor1(cardinal( (skala shl 24) or $FFFFFF) ),
                     tPattern(n),
                     effectsrcalpha or effectdiffuse);
           end;
         17:{bomba z gazem}
           form1.drawsprajt(obr.pocisk[14],trunc(x-obr.pocisk[14].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[14].ofsy)-ekran.py+wy,n);
         19:{molotov}
           form1.drawsprajt(obr.pocisk[15],trunc(x-obr.pocisk[15].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[15].ofsy)-ekran.py+wy,n);
         20:begin {gaz}
           if czasdowybuchu<=120 then b:=30-czasdowybuchu shr 2
                                else b:=0;
           if czasdowybuchu<=60 then skala:=czasdowybuchu*4
              else begin
                   if rez1<245 then skala:=rez1
                               else skala:=255-random(10);
                   end;
           form1.PowerDraw1.TextureMap(obr.pocisk[16].surf,
                     pRotate4c(trunc(x-ekran.px{-rez2{-b}),
                              trunc(y-ekran.py{-rez2{-b}),
                              rez2 shl 1+b shl 1,
                              rez2 shl 1+b shl 1, rez3 shr 3),
                     cColor1(cardinal( (skala shl 24) or $FFFFFF) ),
                     tPattern(n),
                     effectsrcalpha or effectdiffuse);
           end;
         21:{bazuka naprowadzana}
           form1.drawsprajt(obr.pocisk[17],trunc(x-obr.pocisk[17].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[17].ofsy)-ekran.py+wy,n);
         23:{bomba na cialo}
           form1.drawsprajt(obr.pocisk[18],trunc(x-obr.pocisk[18].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[18].ofsy)-ekran.py+wy,n);
         24:{roller}
           form1.drawsprajt(obr.pocisk[19],trunc(x-obr.pocisk[19].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[19].ofsy)-ekran.py+wy,n);
         25:{rakieta}
           form1.drawsprajt(obr.pocisk[20],trunc(x-obr.pocisk[20].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[20].ofsy)-ekran.py+wy,n);
         26:{pocisk wbijany}
           form1.drawsprajt(obr.pocisk[21],trunc(x-obr.pocisk[21].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[21].ofsy)-ekran.py+wy,n);
         27:{bloto}
           form1.PowerDraw1.TextureMap(obr.pocisk[22].surf,
                     pBounds4(trunc(x-ekran.px-(4+sila) div 2),
                              trunc(y-ekran.py-(4+sila) div 2),
                              (4+sila) ,
                              (4+sila) ),
                     cWhite4,
                     tPattern(n),
                     effectsrcalpha);
           //form1.drawsprajt(obr.pocisk[0],trunc(x-obr.pocisk[0].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[0].ofsy)-ekran.py+wy,n);
         28:{bomba z gazem wyb}
           form1.drawsprajt(obr.pocisk[23],trunc(x-obr.pocisk[23].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[23].ofsy)-ekran.py+wy,n);
         29:{bomba atomowa}
           if rez1=0 then
           form1.PowerDraw1.TextureMap(obr.pocisk[24].surf,

                     pRotate4c(trunc(x-ekran.px),
                              trunc(y-ekran.py),
                              trunc((obr.pocisk[24].rx*sila)/130) ,
                              trunc((obr.pocisk[24].ry*sila)/130) ,
                              trunc(n*4.2666665)),

                     cWhite4,
                     tPattern(trunc(klatka)),
                     effectsrcalpha);
        else
          form1.drawsprajt(obr.pocisk[wyglad],trunc(x-obr.pocisk[wyglad].ofsx)-ekran.px+wx,trunc(y-obr.pocisk[wyglad].ofsy)-ekran.py+wy,n)
       end;
    end else
        if (not (wyglad in [4,5,14,16,20])) and (wyglad<>-1) then begin
        bx:=trunc(x)-ekran.px;
        by:=trunc(y)-ekran.py;
        if bx<0 then bx:=0;
        if by<0 then by:=0;
        if bx>ekran.width-1 then bx:=ekran.width-1;
        if by>ekran.height-ekran.menux-1 then by:=ekran.height-ekran.menux-1;
        form1.PowerDraw1.RenderEffectCol(obr.wskaznik.surf,bx-obr.wskaznik.ofsx,by-obr.wskaznik.ofsy,$8000FFff,0,effectsrcalpha or effectdiffuse);
    end;

  end;

end;




end.
