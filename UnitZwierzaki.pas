unit UnitZwierzaki;

interface
uses Graphics, Types, vars, sinusy;

  procedure nowyzwierzak(sx,sy, sdx,sdy :real; rodz:byte);
  procedure pauza_przenos_zwierzaki;
  procedure ruszaj_zwierzaki;
  procedure rysuj_zwierzaki;


implementation
uses unit1, unitEfekty, UnitWybuchy, unitkolesie, unitsyfki, powertypes, unitpociski, unitmiesko, unitrysowanie, unitstringi;

const
zt:array[0..max_rodz_zwierzaki] of record
      atak, ucieka:boolean;
      sila:byte;
      gatunek:byte;
   end=(
    {0-netoper} (atak:true;  ucieka:false; sila:30; gatunek:0),
    {1-pirania} (atak:true;  ucieka:false; sila:30; gatunek:1),
    {2-motylek} (atak:false; ucieka:true;  sila:10; gatunek:0),
    {3-wegorz } (atak:true;  ucieka:false; sila:30; gatunek:1),
    {4-golab  } (atak:false; ucieka:true;  sila:30; gatunek:0),
    {5-rybka  } (atak:false; ucieka:true;  sila:20; gatunek:1)
   );



procedure nowyzwierzak(sx,sy, sdx,sdy :real; rodz:byte);
var a,b:longint;
begin
a:=zwierz_nowy;
b:=0;
while (b<max_zwierz) and (zwierz[a].jest) do begin
   inc(a);
   inc(b);
   if a>=max_zwierz then a:=0;
end;
if not zwierz[a].jest then with zwierz[a] do begin
   x:=sx;
   y:=sy;
   dx:=sdx;
   dy:=sdy;
   jest:=true;
   rodzaj:=rodz;
(*   case rodzaj of
      0,2:gatunek:=0; {ptaki}
      1:gatunek:=1; {ryby}
   end;*)
   gatunek:=zt[rodzaj].gatunek;
   klatka:=random(obr.zwierzaki[rodzaj,0].klatek);
   lezy:=false;
   kierunek:=1;
   palisie:=false;
   sila:=zt[rodzaj].sila;
   zabic:=-1;
   czas_zabijania:=0;
   juzzabity:=false;
   przenoszony:=false;
end;

end;

procedure pauza_przenos_zwierzaki;
var a:integer;
begin
for a:=0 to max_zwierz do
  if zwierz[a].jest then with zwierz[a] do begin
    if (vars.bron.przenoszenie) and
       (not przenoszony) and
       (x-ekran.px>=mysz.x-8) and
       (x-ekran.px<=mysz.x+8) and
       (y-ekran.py>=mysz.y-8) and
       (y-ekran.py<=mysz.y+8) then przenoszony:=true;

    if przenoszony then begin
       x:=mysz.x+ekran.px;
       y:=mysz.y+ekran.py;
       dx:=(mysz.x-mysz.sx)/2;
       dy:=(mysz.y-mysz.sy)/2;
    end;

  end;
end;

procedure ruszaj_zwierzaki;
var
a,b:longint;
k:smallint;
d:shortint;
c,e:byte;
wez:boolean;
wyswodywx:integer;
begin
for a:=0 to max_zwierz do
  if zwierz[a].jest then with zwierz[a] do begin
    x:=x+dx;
    y:=y+dy;
    wyswodywx:=wyswody(x);

    if rodzaj=0 then
       lezy:= (abs(dx)<=0.3) and (abs(dy)<=0.3) and (x>=0) and (trunc(y)-obr.zwierzaki[rodzaj,ord(lezy)].ofsy>=0) and
             (x<=teren.width-1) and (trunc(y)-obr.zwierzaki[rodzaj,ord(lezy)].ofsy<=teren.height-1) and
             (teren.maska[trunc(x),trunc(y)-obr.zwierzaki[rodzaj,ord(lezy)].ofsy]>0)
    else
    if rodzaj in [2,4] then
       lezy:= (abs(dx)<=0.3) and (abs(dy)<=0.3) and
              (x>=0) and (trunc(y)+2>=0) and
              (x<=teren.width-1) and (trunc(y)+2<=teren.height-1) and
              (teren.maska[trunc(x),trunc(y)+2]>0)
    else
       lezy:={ (abs(dx)<=0.1) and (abs(dy)<=0.1) and (x>=0) and (y>=0) and
             (x<=teren.width-1) and (y<=teren.height+30) and
             (teren.maska[trunc(x),trunc(y)+1]>0);}
             false;

    if ((abs(warunki.wiatr)>0.5) or (not lezy)) and
       ((warunki.typ_wody=0) or (y<wyswodywx)) then dx:=dx+warunki.wiatr/40;
    if random(2)=0 then dx:=dx*0.985;
    if random(2)=0 then dy:=dy*0.989;
    if (x<-50) or (x>teren.Width+50) or (y<-50) or (y>teren.Height+50) then begin
       jest:=false;
    end;

    {uderzanie w sciany:}
    if (not lezy) and
       (trunc(x+dx)>=0) and (trunc(y+dy)>=0) and (trunc(x+dx)<=teren.width-1) and (trunc(y+dy)<=teren.height+30) and
       (teren.maska[trunc(x+dx),trunc(y+dy)]<>0) then begin
        b:=round(sqrt2(sqr(dx)+sqr(dy)));
        if b>=5 then begin {krwaw od uderzenia w skale}
           k:=1+random(b);
           dec(sila,k);
           inc(gracz.pkt,k);
           for b:=0 to 4+random(10) do begin
              if random(10)=0 then c:=1 else c:=0;
              nowysyf(x-5+random(10),y-7+random(14),
                      random*3-1.5-dx/3,
                      random*3-1.5-dy/3,
                      0,random(5),c,0,true, -1);
           end;
        end;
        x:=x-dx;
        dx:=-dx/1.2;

        y:=y-dy;
        dy:=-dy/1.2;
        if (gatunek=1) and (dy<-1.5) then dy:=-1.5;
    end;
(*    if (rodzaj=0) and {netoper moze siadac pod sufitem}
       (trunc(x)>=0) and (trunc(y-obr.zwierzaki[rodzaj,ord(lezy)].ofsy)>=0) and (trunc(x)<=teren.width-1) and (trunc(y-obr.zwierzaki[rodzaj,ord(lezy)].ofsy)<=teren.height) and
       (teren.maska[trunc(x),trunc(y-6)]<>0) and ((abs(dx)<0.2) or (abs(dy)<0.2)) then begin
          lezy:=true;
          dx:=0;
          dy:=0;
    end;*)

    if lezy and (abs(dx)<0.3) and (abs(dy)<0.3) then begin
       dx:=0;
       dy:=0;
    end else lezy:=false;


    case gatunek of
       0:begin
         if (warunki.typ_wody>=1) and (y>=wyswodywx) then begin
            if (y<=wyswodywx+10) and (dy>-0.5) then dy:=dy-0.1
              else
              if (y>wyswodywx+10) then begin
                 if abs(dx)>gestosci[warunki.typ_wody].maxx then dx:=dx/(gestosci[warunki.typ_wody].x*1.3);
                 if abs(dy)>gestosci[warunki.typ_wody].maxy then dy:=dy/(gestosci[warunki.typ_wody].y*1.3);
                 if random(30)=0 then dec(sila);
              end;
         end;
         end;
       1:begin
         if (warunki.typ_wody=0) or (y<=wyswodywx) then begin
            {if (dy<1.5) then }dy:=dy+0.1*warunki.grawitacja;
            if random(30)=0 then dec(sila);
         end else begin
             if abs(dx)>gestosci[warunki.typ_wody].maxy then dx:=dx/((gestosci[warunki.typ_wody].y-1)/2 +1);
             if abs(dy)>gestosci[warunki.typ_wody].maxy then dy:=dy/((gestosci[warunki.typ_wody].y-1)/2 +1);
         end;
         if (warunki.typ_wody>=1) and (y>=wyswodywx-5) and (y<=wyswodywx+5) then begin
            if (dy<1) then dy:=dy+0.1*warunki.grawitacja
         end;
         end;
    end;

    if (warunki.typ_wody>=1) and (y>=wyswodywx) then begin
       if (warunki.typ_wody=2) and (random(7)=0) then palisie:=true;
       if (warunki.typ_wody in [1,3..5]) and (random(7)=0) then palisie:=false;
       if (warunki.typ_wody in [2,3]) and (random(10)=0) then dec(sila);
    end;

    if (zabic>=0) and (zabic<=max_kol) and (koles[zabic].jest) and (koles[zabic].niewidzialnosc>0) then zabic:=-1;

    if palisie then begin
       if (random(10)=0) then begin
           strzel(x,y-6,-random+0.5,-random/1.6,0,-1,10,5,10,-20-random(15),5,boolean(random(2)),8+random(20));
           if random(3)=0 then sila:=sila-1;
           dx:=dx+random*2-1;
           dy:=dy+random*2-1;
           if random(4)=0 then zabic:=-1;
       end;
       if random(7)=0 then
        nowywybuchdym( x-3+random(7), y-4+random(7),
                       random/2-0.25,
                       -0.1-random/1.2,
                       0, wd_dym,
                       1+random(9),
                       130+random(120),
                       100+random(150));
    end;

    if (not lezy and (random(120)=0)) or
       (lezy and (random(500)=0)) then begin
       dx:=dx+random-0.5;
       if lezy and (gatunek=0) then begin
          dy:=0.2+random/2;
          lezy:=false;
       end else
           dy:=dy+random-0.5;
    end;

    if (warunki.typ_wody>=1) and
       (((y-dy>=wyswodywx-2) and (y<wyswodywx-2)) or
        ((y-dy<wyswodywx-2) and (y>=wyswodywx-2))) and
       ((abs(dx)>0.8) or (abs(dy)>0.7)) {and (random(3)=0)} then begin
       form1.graj(form1.dzw_rozne.item[5],x,y,7000);
       for k:=0 to 5+random(10) do
           nowysyf(x-8+random(16),wyswodywx-1,(random*2-1)+dx/2,-abs(random*dy/2),0,random(5),0,2,true, 0,warunki.typ_wody);
       plum(x,y,dy,14,1.5)
    end;

    if not lezy then begin
       if gatunek=0 then klatka:=klatka+1.5
       else
          klatka:=klatka+sqrt2(sqr(dx)+sqr(dy))/7+0.5;

       if klatka>=obr.zwierzaki[rodzaj,0].klatek then klatka:=klatka-obr.zwierzaki[rodzaj,0].klatek;
    end else begin
       if random(50)=0 then klatka:=random(obr.zwierzaki[rodzaj,0].klatek);
       if klatka>=obr.zwierzaki[rodzaj,0].klatek then klatka:=0;
    end;

    {duszenie sie w scianie:}
    if (trunc(x)>=0) and (trunc(y)>=0) and (trunc(x)<=teren.width-1) and (trunc(y)<=teren.height+30) and
       (teren.maska[trunc(x),trunc(y)]<>0) and (random(10)=0) then begin
        dec(sila);
        dx:=dx-1+random*2;
        dy:=dy-1+random*2;
        lezy:=false;
    end;


    if (zt[rodzaj].ucieka) and (random(10)=0) then begin {uciekaj od ludzi}
       for k:=0 to max_kol do
           if (koles[k].jest) and
              (x>=koles[k].x-70) and (y>=koles[k].y-70) and
              (x<=koles[k].x+70) and (y<=koles[k].y+70) then begin
               if (x>koles[k].x) and (dx>-1.3) then dx:=dx+random/7
                  else
               if (x<koles[k].x) and (dx<1.3) then dx:=dx-random/7;
               if (y>koles[k].y+7) and (dy>-1.3) then dy:=dy+random/7
                  else
               if (y<koles[k].y+7) and (dy<1.3) then dy:=dy-random/7;
           end;
    end;

    if (zabic=-1) and (not palisie) and (zt[rodzaj].atak) and (random(40)=0) then begin {szukaj wroga w nieduzej odleglosci}
       for k:=0 to max_kol do
           if (koles[k].jest) and (koles[k].niewidzialnosc=0) and
              (random(10)=0) and
              (x>=koles[k].x-100) and (y>=koles[k].y-100) and
              (x<=koles[k].x+100) and (y<=koles[k].y+100)
                 then begin
                      zabic:=k;
                      czas_zabijania:=0;
                      break;
                      end;
    end else
    if (zabic>=0) and (zabic<=max_kol) and (koles[zabic].jest) and (czas_zabijania<=150) then begin
       if ( ( (gatunek=0) and ((warunki.typ_wody=0) or (y<wyswodywx+5)) )
            or
            ( (gatunek=1) and ((warunki.typ_wody>=1) and (y>wyswodywx-5)) )
          ) and
          (x>=koles[zabic].x-160) and (y>=koles[zabic].y-160) and
          (x<=koles[zabic].x+160) and (y<=koles[zabic].y+160)
          then begin
               czas_zabijania:=0;
               if (x>koles[zabic].x) and (dx>-1.3) then dx:=dx-random/7
                  else
               if (x<koles[zabic].x) and (dx<1.3) then dx:=dx+random/7;
               if (y>koles[zabic].y-7) and (dy>-1.3) then dy:=dy-random/7
                  else
               if (y<koles[zabic].y-7) and (dy<1.3) and
                  ((warunki.typ_wody=0) or (y<wyswodywx) or (gatunek=1)) then dy:=dy+random/7;

               if lezy then begin
                  dy:=0.2+random/2;
                  lezy:=false;
               end;

       end else inc(czas_zabijania);
       if (x>=koles[zabic].x-9) and (y>=koles[zabic].y-15) and
          (x<=koles[zabic].x+9) and (y<=koles[zabic].y+15) then begin
          czas_zabijania:=0;
          if (vars.bron.sterowanie<>zabic) and (random(20)=0) then begin
             if (koles[zabic].corobi=cr_plynie) and (random(3)<=2) then koles[zabic].dy:=koles[zabic].dy+0.6
             else
               koles[zabic].corobi:=cr_panika;
          end;
          if (vars.bron.sterowanie<>zabic) and (random(15)=0) and (koles[zabic].corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_panika]) then begin
             if y<=koles[zabic].y+5 then begin
                case random(23) of
                   0..9:koles[zabic].corobi:=cr_grzywa;
                   10..19:koles[zabic].corobi:=cr_bije;
                   20..21:koles[zabic].corobi:=cr_kopie;
                end
             end else
                case random(12) of
                   0:koles[zabic].corobi:=cr_grzywa;
                   1:koles[zabic].corobi:=cr_bije;
                   2..11:koles[zabic].corobi:=cr_kopie;
                end;
             koles[zabic].cochcekopnac:=3;
             koles[zabic].ktoregochcekopnac:=-1;
          end;

          if (rodzaj=0) and (random(50)=0) then
             form1.graj(form1.dzw_zwierzaki.Item[0],x,y,4000);

          case rodzaj of
            3:begin {wegorz}
              if random(80)=0 then begin
                 e:=random(10)+5;
                 nowywybuchdym(x,y,0,0,0,wd_swiatlo,0,30+random(50),40+random(20)+e*3,$FF7000+random(120) shl 8+random(200));
                 for b:=0 to e do begin
                    if random(10)=0 then c:=1 else c:=0;
                    nowysyf(x-2+random(5),y-2+random(5),
                            random*2-1+dx,
                            random*2-1+dy,
                            0,random(5),c,0,true, koles[zabic].team);
                 end;
                 dec(koles[zabic].sila,e);
{dzwiek bzyk!     if random(5)=0 then begin
                    if (warunki.typ_wody=0) or (koles[zabic].y<wyswodywx+15) then
                       form1.graj(druzyna[koles[zabic].team].dzwieki.Item[random(3)],koles[zabic].x,koles[zabic].y,10000)
                       else form1.graj(druzyna[koles[zabic].team].dzwieki.Item[8],koles[zabic].x,koles[zabic].y,5000);
                 end;}
                 if (koles[zabic].zabic>=0) and (random(10)=0) then koles[zabic].zabic:=-1;
              end;
            end;
            else begin
              if random(25)=0 then begin
                 e:=random(3)+1;
                 for b:=0 to e do begin
                    if random(10)=0 then c:=1 else c:=0;
                    nowysyf(x-2+random(5),y-2+random(5),
                            random-0.5+dx,
                            random-0.5+dy,
                            0,random(5),c,0,true, koles[zabic].team);
                 end;
                 dec(koles[zabic].sila,e);
                 if random(5)=0 then begin
                    if (warunki.typ_wody=0) or (koles[zabic].y<wyswodywx+15) then
                       form1.graj(druzyna[koles[zabic].team].dzwieki.Item[random(3)],koles[zabic].x,koles[zabic].y,10000)
                       else form1.graj(druzyna[koles[zabic].team].dzwieki.Item[8],koles[zabic].x,koles[zabic].y,5000);
                 end;
                 if (koles[zabic].zabic>=0) and (random(10)=0) then koles[zabic].zabic:=-1;
              end;
            end;
          end;
       end;
    end else
        zabic:=-1;


    if dx<0 then kierunek:=-1
       else
       if dx>0 then kierunek:=1;

(*    if (lezy) and (abs(dx)<0.1) then dx:=0;
    if (lezy) and (abs(dy)<0.1) then dy:=0;
  *)
    if (ekran.iletrzes>=3) and (lezy) then begin
       dx:=dx+random/10-0.05;
       dy:=dy+random/10-0.05;
    end;

    if sila<=0 then begin {zdycha}
       if not juzzabity then begin
          for b:=0 to 10+random(10) do begin
              if random(10)=0 then c:=1 else c:=0;
              nowysyf(x-5+random(10),y-7+random(14),
                      random*3-1.5+dx,
                      random*3-1.5+dy,
                      0,random(5),c,0,true, -1);
          end;
          nowemieso(x,
                     y,
                     random*2-1,
                     random*2-1,
                     rodzaj,-1,palisie,random(60));

       end;
       jest:=false;
       if (rodzaj=0) and (random(2)=0) then
          form1.graj(form1.dzw_zwierzaki.Item[0],x,y,4000);
    end;
    if (sila<=8) and (random(sila*2+8)=0) then begin
       if random(10)=0 then c:=1 else c:=0;
       nowysyf(x-3+random(7),y-5+random(11),(random*2-1)*((15-sila)/6),(random*2-1)*((15-sila)/6), 0,random(2),c,0,false,-1);
    end;

    if (vars.bron.przenoszenie) and
       (not przenoszony) and
       (x-ekran.px>=mysz.x-8) and
       (x-ekran.px<=mysz.x+8) and
       (y-ekran.py>=mysz.y-8) and
       (y-ekran.py<=mysz.y+8) then przenoszony:=true;

    if przenoszony then begin
       x:=mysz.x+ekran.px;
       y:=mysz.y+ekran.py;
       dx:=(mysz.x-mysz.sx)/2;
       dy:=(mysz.y-mysz.sy)/2;
    end;


    if (klatka<0) or (trunc(klatka)>=obr.zwierzaki[rodzaj,ord(lezy)].klatek) then
        klatka:=0;

end;
end;

procedure rysuj_zwierzaki;
var
a,n,k:longint;
wx,wy:smallint;
tr:trect;
kk0:real;
begin
for a:=0 to max_zwierz do
  if zwierz[a].jest then with zwierz[a] do begin
     n:=trunc(klatka);

     if lezy then begin
        wx:=ekran.trzesx;
        wy:=ekran.trzesy;
     end else begin
         wx:=0;
         wy:=0;
     end;

     if gatunek=0 then begin {ptaki}
        if lezy then begin
           if kierunek>0 then
              tr:=rect( trunc(x-obr.zwierzaki[rodzaj,ord(lezy)].ofsx)-ekran.px+wx,trunc(y-obr.zwierzaki[rodzaj,ord(lezy)].ofsy)-ekran.py+wy,
                        trunc(x-obr.zwierzaki[rodzaj,ord(lezy)].ofsx)-ekran.px+wx+obr.zwierzaki[rodzaj,ord(lezy)].rx,trunc(y-obr.zwierzaki[rodzaj,ord(lezy)].ofsy)-ekran.py+wy+obr.zwierzaki[rodzaj,ord(lezy)].ry)
           else
              tr:=rect( trunc(x-obr.zwierzaki[rodzaj,ord(lezy)].ofsx)-ekran.px+wx+obr.zwierzaki[rodzaj,ord(lezy)].rx,trunc(y-obr.zwierzaki[rodzaj,ord(lezy)].ofsy)-ekran.py+wy,
                        trunc(x-obr.zwierzaki[rodzaj,ord(lezy)].ofsx)-ekran.px+wx,trunc(y-obr.zwierzaki[rodzaj,ord(lezy)].ofsy)-ekran.py+wy+obr.zwierzaki[rodzaj,ord(lezy)].ry);

           form1.PowerDraw1.TextureMap(obr.zwierzaki[rodzaj,ord(lezy)].surf,
                        pRect4(tr), cWhite4, tPattern(n), effectSrcAlpha);
        end else begin
            if kierunek>0 then begin{prawo}
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

               k:=trunc( ((kk0/(pi180)-90)/1.40625)/1.5 );

               form1.PowerDraw1.TextureMap(obr.zwierzaki[rodzaj,ord(lezy)].surf,
                          pRotate4( trunc(x{-obr.zwierzaki[rodzaj,ord(lezy)].ofsx})-ekran.px+wx,
                                    trunc(y{-obr.zwierzaki[rodzaj,ord(lezy)].ofsy})-ekran.py+wy,
                                    obr.zwierzaki[rodzaj,ord(lezy)].rx,
                                    obr.zwierzaki[rodzaj,ord(lezy)].ry,
                                    obr.zwierzaki[rodzaj,ord(lezy)].ofsx,
                                    obr.zwierzaki[rodzaj,ord(lezy)].ofsy,
                                    k), cWhite4, tPattern(n), effectSrcAlpha);
            end else begin
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

               k:=trunc( (-(kk0/(pi180))/1.40625)/1.5 );

               form1.PowerDraw1.TextureMap(obr.zwierzaki[rodzaj,ord(lezy)].surf,
                pFlip4( pRotate4( trunc(x)-ekran.px+wx,
                                    trunc(y)-ekran.py+wy,
                                    obr.zwierzaki[rodzaj,ord(lezy)].rx,
                                    obr.zwierzaki[rodzaj,ord(lezy)].ry,
                                    obr.zwierzaki[rodzaj,ord(lezy)].ofsx,
                                    obr.zwierzaki[rodzaj,ord(lezy)].ofsy,
                                    k) ), cWhite4, tPattern(n), effectSrcAlpha);
            end;
        end;

     end else begin {rybki}
         if kierunek>0 then begin{prawo}
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

             k:=trunc( (kk0/(pi180)-90)/1.40625 );

             form1.PowerDraw1.TextureMap(obr.zwierzaki[rodzaj,ord(lezy)].surf,
                        pRotate4( trunc(x{-obr.zwierzaki[rodzaj,ord(lezy)].ofsx})-ekran.px+wx,
                                  trunc(y{-obr.zwierzaki[rodzaj,ord(lezy)].ofsy})-ekran.py+wy,
                                  obr.zwierzaki[rodzaj,ord(lezy)].rx,
                                  obr.zwierzaki[rodzaj,ord(lezy)].ry,
                                  obr.zwierzaki[rodzaj,ord(lezy)].ofsx,
                                  obr.zwierzaki[rodzaj,ord(lezy)].ofsy,
                                  k), cWhite4, tPattern(n), effectSrcAlpha);
          end else begin
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

             k:=trunc( -(kk0/(pi180)-90)/1.40625 );

             form1.PowerDraw1.TextureMap(obr.zwierzaki[rodzaj,ord(lezy)].surf,
              pFlip4( pRotate4( trunc(x)-ekran.px+wx,
                                  trunc(y)-ekran.py+wy,
                                  obr.zwierzaki[rodzaj,ord(lezy)].rx,
                                  obr.zwierzaki[rodzaj,ord(lezy)].ry,
                                  obr.zwierzaki[rodzaj,ord(lezy)].ofsx,
                                  obr.zwierzaki[rodzaj,ord(lezy)].ofsy,
                                  k) ), cWhite4, tPattern(n), effectSrcAlpha);
          end;

     (*         if dx>0 then begin
            if (dy>0) then kk0:=arctan(dy/dx)+pi/2
                      else kk0:=arctan(dy/dx)+pi/2;
         end else if dx<0 then begin
            if (dy>0) then kk0:=arctan(dy/dx)+(3/2)*pi
                      else kk0:=arctan(dy/dx)+(3/2)*pi;
         end else begin
            if (dy>0) then kk0:=pi
                      else kk0:=0;
         end;

         k:=trunc( (kk0/(pi180)-90)/1.40625 );

         form1.PowerDraw1.TextureMap(obr.zwierzaki[rodzaj,ord(lezy)].surf,
                    pRotate4( trunc(x{-obr.zwierzaki[rodzaj,ord(lezy)].ofsx})-ekran.px+wx,
                              trunc(y{-obr.zwierzaki[rodzaj,ord(lezy)].ofsy})-ekran.py+wy,
                              obr.zwierzaki[rodzaj,ord(lezy)].rx,
                              obr.zwierzaki[rodzaj,ord(lezy)].ry,
                              obr.zwierzaki[rodzaj,ord(lezy)].ofsx,
                              obr.zwierzaki[rodzaj,ord(lezy)].ofsy,
                              k), cWhite4, tPattern(n), effectSrcAlpha);
*)
     end;

     if palisie then
        form1.drawsprajtalpha(obr.pocisk[5],trunc(x-obr.pocisk[5].ofsx)-ekran.px-2+random(5),trunc(y-obr.pocisk[5].ofsy)-ekran.py-random(7),random(26),180+random(70));

  end;

end;




end.
