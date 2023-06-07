unit UnitMiny;

interface
uses Graphics, Types, vars, sinusy;

  procedure rzucmine(sx,sy, sdx,sdy :real;
                 rodzajliczenia:byte;
                 zepsuta_:boolean;
                 rodzaj_:byte;
                 zaczepiona_:boolean=false; zaczx_:integer=0;zaczy_:integer=0);
  procedure pauza_przenos_miny;
  procedure ruszaj_miny;
  procedure rysuj_miny;

implementation
uses unit1, unitEfekty, UnitWybuchy, unitsyfki, unitkolesie, unitrysowanie, unitpociski;

{strzela minaiskiem:
   rodzajliczenia:
     0 - sdx, sdy to delta dla x i y
     1 - sdx = kat, sdy = sila strzalu
}
procedure rzucmine(sx,sy, sdx,sdy :real;
                 rodzajliczenia:byte;
                 zepsuta_:boolean;
                 rodzaj_:byte;
                 zaczepiona_:boolean=false; zaczx_:integer=0;zaczy_:integer=0);
var a,b:longint;
begin
a:=mina_nowy;
b:=0;
while (b<max_mina) and (mina[a].jest) do begin
   inc(a);
   inc(b);
   if a>=max_mina then a:=0;
end;
if not mina[a].jest then with mina[a] do begin
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
   rodzaj:=rodzaj_;
   case rodzaj_ of
     0:begin
       czasdowybuchu:=150+random(10); //ladowa
       klatka:=random(60);
       end;
     1:begin
       czasdowybuchu:=10+random(10);  //wodna
       klatka:=random(60);
       end;
     2:begin
       czasdowybuchu:=4+random(20);  //beczka
       klatka:=random(2)*30;
       end;
   end;
   aktywna:=false;
   zepsuta:=zepsuta_;

   klatkamiganie:=random(15);
   lezy:=false;
   zaczepiona:=zaczepiona_;
   zaczx:=zaczx_;
   zaczy:=zaczy_;
   dl_zaczep:=trunc(sqrt(sqr(abs(x-zaczx))+sqr(abs(y-zaczy))));
   przenoszony:=false;

end;

end;

procedure pauza_przenos_miny;
var a:integer;
begin
for a:=0 to max_mina do
  if mina[a].jest then with mina[a] do begin
    if (vars.bron.przenoszenie) and
       (not przenoszony) and
       (x-ekran.px>=mysz.x-6) and
       (x-ekran.px<=mysz.x+6) and
       (y-ekran.py>=mysz.y-6) and
       (y-ekran.py<=mysz.y+6) then przenoszony:=true;

    if przenoszony then begin
       x:=mysz.x+ekran.px;
       y:=mysz.y+ekran.py;
       dx:=(mysz.x-mysz.sx)/2;
       dy:=(mysz.y-mysz.sy)/2;
    end;

  end;
end;


procedure ruszaj_miny;
var
a,k,b:longint;
c:byte;
d:shortint;
ps:single;
ox,oy,d1,d2,
dx_,dy_,kk0, dd:real;
wyswodywx,
kat,px,py:integer;
gl,kt:real;
begin
ile_min:=0;
for a:=0 to max_mina do
  if mina[a].jest then with mina[a] do begin
      inc(ile_min);
      x:=x+dx;
      y:=y+dy;
      wyswodywx:=wyswody(x);
      if rodzaj=2 then
            lezy:= (abs(dx)<=0.1) and (abs(dy)<=0.1) and (x>=0) and (y>=0) and
                   (x<=teren.width-1) and (y<=teren.height+20) and
                   (teren.maska[trunc(x),trunc(y)+9]>0)
         else
           lezy:= (abs(dx)<=0.1) and (abs(dy)<=0.1) and (x>=0) and (y>=0) and
                   (x<=teren.width-1) and (y<=teren.height+26) and
                   (teren.maska[trunc(x),trunc(y)+1]>0);

      case rodzaj of
        0,1:begin //ladowa, wodna
            if ((abs(warunki.wiatr)>0.5) or (not lezy)) and
               ((warunki.typ_wody=0) or (y<wyswodywx)) then dx:=dx+warunki.wiatr/10;
         end;
        2:begin //beczka
            if lezy and (abs(warunki.wiatr)>0.5) and (random(100)=0) then lezy:=false;
            if ((abs(warunki.wiatr)>0.5) or (not lezy)) and
               ((warunki.typ_wody=0) or (y<wyswodywx)) then dx:=dx+warunki.wiatr/20;
         end;
      end;
      if random(2)=0 then dx:=dx*0.995;
      if random(2)=0 then dy:=dy*0.999;
      if ((not zaczepiona) and ((x<0) or (x>teren.Width))) or
         ((zaczepiona) and ((x<-200) or (x>200+teren.Width)))
         then begin
         jest:=false;
      end;
      if y>=teren.Height+31 then begin
         jest:=false;
         //if not odbijasie then wysadz:=true;
      end;


      case rodzaj of
         0:begin//ladowa
           if (warunki.typ_wody>=1) and (y>=wyswodywx) then ps:=dy/(2+random/5)
              else ps:=dx;
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
           end;
         1:begin//wodna
            klatka:=klatka+((1+klatkamiganie)/30)-0.25;
            if (not aktywna) and (random(2)=0) then begin
               klatkamiganie:=klatkamiganie+random(3)-1;
               if klatkamiganie<0 then klatkamiganie:=0;
               if klatkamiganie>15 then klatkamiganie:=15;
            end;
           end;
         2:begin//beczka
           if (warunki.typ_wody>=1) and (y>=wyswodywx) then ps:=dy/(2+random/5)
              else ps:=dx;
           if abs(ps)<0.02 then begin
              ps:=0;
           end else
           if abs(ps)<0.1 then begin
              if ps<0 then ps:=-0.1
                      else ps:=0.1;
           end else
           if abs(ps)>3 then begin
              if ps<0 then ps:=-3
                      else ps:=3;
           end;
           klatka:=klatka+ps;
           end;
       end;

       if klatka>60 then klatka:=klatka-60;
       if klatka<0 then klatka:=klatka+60;

       if rodzaj=2 then begin //beczka
            dd:=sqrt2(abs(dx*dx+dy*dy));
            if dd>=0.5 then begin
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
                kat:=trunc( (kk0/(pi180)) );
                dx_:=_sin(kat)*7;
                dy_:=-_cos(kat)*7;
            end else begin
                kat:=0;
                dx_:=0;
                dy_:=8;
            end;

            if ((trunc(x+dx_)>=0) and (trunc(y+dy_)>=0) and (trunc(x+dx_)<=teren.width-1) and (trunc(y+dy_)<=teren.height+30) and
               (teren.maska[trunc(x+dx_),trunc(y+dy_)]<>0)) or
               (y+dy_>=teren.height+31) then begin
               //if (dd>0.08) then begin
                  if dx>=0 then px:=1 else px:=-1;
                  if dy>=0 then py:=1 else py:=-1;
                  if (trunc(x+dx_)+px>=0) and (trunc(y+dy_)-py>=0) and
                     (trunc(x+dx_)+px<=teren.width-1) and (trunc(y+dy_)-py<=teren.height+30) and
                     (teren.maska[trunc(x+dx_)+px,trunc(y+dy_)-py]<>0) then begin
                     x:=x-dx;
                     dx:=-dx/2;
                  end;
                  if (trunc(x+dx_)-px>=0) and (trunc(y+dy_)+py>=0) and
                     (trunc(x+dx_)-px<=teren.width-1) and (trunc(y+dy_)+py<=teren.height+30) and
                     (teren.maska[trunc(x+dx_)-px,trunc(y+dy_)+py]<>0) then begin
                     y:=y-dy;
                     dy:=-dy/2;
                  end;

                  if (abs(dx)>=0.3) or (abs(dy)>=0.3) then begin
                     gl:=sqrt2(sqr(dx)+sqr(dy))/3;
                     if gl<0.02 then gl:=0.02;
                     if gl>1 then gl:=1;
                     form1.graj(form1.dzw_bronie_inne.Item[12],x,y,10000,gl);
                  end;
              // end;

                  if abs(dx)<0.1 then begin
                      if (round(klatka) mod 15>=1) and (round(klatka) mod 15<=13) then begin
                           if round(klatka) mod 15<8 then begin dx:=dx-0.2; klatka:=klatka-random*3; end
                                                     else begin dx:=dx+0.2; klatka:=klatka+random*3; end;
                           dy:=dy-0.4;
                      end;
                  end;

            end;

       end else
         if ((trunc(x+dx)>=0) and (trunc(y+dy)>=0) and (trunc(x+dx)<=teren.width-1) and (trunc(y+dy)<=teren.height+30) and
             (teren.maska[trunc(x+dx),trunc(y+dy)]<>0)) or
             (y+dy>=teren.height+31) then begin
              if dx>=0 then d:=1 else d:=-1;
              if (trunc(x+d)>=0) and (trunc(y)>=0) and (trunc(x+d)<=teren.width-1) and (trunc(y)<=teren.height+30) and
                 (teren.maska[trunc(x+d),trunc(y)]<>0) then begin
                 x:=x-dx;
                 dx:=-dx/2;
              end;
              if dy>=0 then d:=1 else d:=-1;
              if ((trunc(x)>=0) and (trunc(y+d)>=0) and (trunc(x)<=teren.width-1) and (trunc(y+d)<=teren.height+30) and
                 (teren.maska[trunc(x),trunc(y+d)]<>0))
                  then begin
                 y:=y-dy;
                 dy:=-dy/2;
              end;
              if (abs(dx)>=0.3) or (abs(dy)>=0.3) then begin
                 gl:=sqrt2(sqr(dx)+sqr(dy))/3;
                 if gl<0.02 then gl:=0.02;
                 if gl>1 then gl:=1;
                 form1.graj(form1.dzw_bronie_inne.Item[1],x,y,1300,gl);
                 if (rodzaj=1) and (random(5)=0) then aktywna:=true; //wodna
              end;
         end;

       if (zaczepiona) and
          (trunc(zaczx)>=0) and (trunc(zaczy)>=0) and
          (trunc(zaczx)<=teren.width-1) and (trunc(zaczy)<=teren.height) and
          (teren.maska[trunc(zaczx),trunc(zaczy)]=0) then begin
          if (warunki.typ_wody>=1) and (zaczy>=wyswodywx) then
             zaczy:=zaczy+1
          else
             zaczy:=zaczy+2;
       end;


      if (aktywna) and (czasdowybuchu>0) then begin
         dec(czasdowybuchu);
         inc(klatkamiganie);
         if klatkamiganie>=30 then klatkamiganie:=0;
         if klatkamiganie=20 then
            form1.graj(form1.dzw_bronie_inne.Item[3],x,y,500);
      end else
          if not aktywna and (klatkamiganie>=19) and (random(150)=0) then
             klatkamiganie:=0;

      if not lezy then dy:=dy+0.1*warunki.grawitacja
         else if rodzaj<>2 then begin
            if (klatka>1) and (klatka<=30) then klatka:=klatka-1 else
            if (klatka>30) and (klatka<=59) then klatka:=klatka+1 else
            klatka:=0;
         end;

      if (warunki.typ_wody>=1) and (y>=wyswodywx) then begin
         case warunki.typ_wody of
            1..max_wod:begin
             case rodzaj of
               0:begin//ladowa
                 if abs(dx)>gestosci[warunki.typ_wody].maxx then dx:=dx/gestosci[warunki.typ_wody].x;
                 if abs(dy)>gestosci[warunki.typ_wody].maxy then dy:=dy/gestosci[warunki.typ_wody].y;
                 end;
               1:begin//wodna
                 if abs(dx)>gestosci[warunki.typ_wody].maxx then dx:=dx/gestosci[warunki.typ_wody].x;
                 if abs(dy)>gestosci[warunki.typ_wody].maxy then dy:=dy/gestosci[warunki.typ_wody].y
                    else
                    if dy>-gestosci[warunki.typ_wody].maxy/5 then begin
                       if not zaczepiona then
                          dy:=dy-0.1*warunki.grawitacja-0.01
                       else begin
                          if (sqrt(sqr(abs(x-zaczx+dx))+sqr(abs(y-zaczy+dy)))<dl_zaczep) and
                             (round(x)<>round(zaczx)) then begin
                             dy:=dy-0.1*warunki.grawitacja-0.01;
                             if x<zaczx then dx:=dx+0.01;
                             if x>zaczx then dx:=dx-0.01;
                          end else
                             dy:=dy-0.1*warunki.grawitacja-0.01;
                       end;
                    end;
                 end;
               2:begin//beczka
                 if abs(dx)>gestosci[warunki.typ_wody].maxx then dx:=dx/gestosci[warunki.typ_wody].x;
                 if abs(dy)>gestosci[warunki.typ_wody].maxy then dy:=dy/gestosci[warunki.typ_wody].y;
                 end;
              end;
              if (warunki.typ_wody=2) and (random(20)=0) and (not zepsuta) and (czasdowybuchu>=10)  then begin
                 aktywna:=true;
                 czasdowybuchu:=3+random(7);
              end;
              end;
         end;
      end;
      if (warunki.typ_wody>=1) and
         {(y>=wyswodywx-10) and (y<=wyswodywx) and}
         (((y-dy>=wyswodywx-2) and (y<wyswodywx-2)) or
          ((y-dy<wyswodywx-2) and (y>=wyswodywx-2))) and
         ((abs(dx)>0.8) or (abs(dy)>1)) {and (random(3)=0) }then begin
         form1.graj(form1.dzw_rozne.item[5],x,y,7000);
         for k:=0 to 5+random(15) do
             nowysyf(x-8+random(16),wyswodywx-1,(random*2-1)+dx/2,-abs(random*dy/2),0,random(5),0,2,true, 0,warunki.typ_wody);
         plum(x,y,dy,12,1.8)
      end;

      if zaczepiona then begin {jak mina jest zaczepiona...}
         k:=trunc(sqrt(sqr(abs(x-zaczx+dx))+sqr(abs(y-zaczy+dy))));
         {dx:=dx/1.005;
         dy:=dy/1.01;  }

         if k>dl_zaczep then begin
           { dx:=dx-((x-zaczx)/400);
            if y<zaczy then begin
               if k>dl_zaczep+15 then dy:=dy-((y-zaczy)/400)
                  else dy:=dy+0.1;
            end else begin
               if k>dl_zaczep+15 then dy:=dy-((y-zaczy)/400)
                  else dy:=dy-0.1;
            end;}

            gl:=(k-dl_zaczep)/2;
            if gl>3 then gl:=3;
            if gl<-3 then gl:=-3;

            kt:=jaki_to_kat_r(x-zaczx, y-zaczy);
            dx:=dx-sin(kt*pi180)*gl;
            dy:=dy+cos(kt*pi180)*gl;
     {       x:=zaczx+sin(kt*pi180)*(dl_zaczep-1);
            y:=zaczy-cos(kt*pi180)*(dl_zaczep-1);  }

         end;

      end;

//      if rodzaj<>2 then
       for k:=0 to max_kol do begin
          if (koles[k].jest) then begin
             {spradz, czy mina nie trafila przypadkiem postaci}
             if (x>=koles[k].x-10) and (x<=koles[k].x+10) and {uaktywnij mine}
                (((rodzaj=0) and (y>=koles[k].y-10)) or
                 ((rodzaj=1) and (y>=koles[k].y-15)) or
                 ((rodzaj=2) and (y>=koles[k].y-15)) )  and
                (y<=koles[k].y+17) then begin

                if (abs(koles[k].dx)>1) or (abs(koles[k].dy)>1) or
                     (abs(dx)>1.5) or (abs(dy)>1.5) then begin
                   ox:=koles[k].dx;
                   oy:=koles[k].dy;
                   case rodzaj of
                     0:begin
                      koles[k].dx:=-koles[k].dx/2+dx/4;
                      koles[k].dy:=-koles[k].dy/2+dy/4;
                     end;
                     1,2:begin
                      koles[k].dx:=-koles[k].dx/2+dx/3;
                      koles[k].dy:=-koles[k].dy/2+dy/3;
                     end;
                   end;

                   dx:=-dx/2+ox/6;
                   dy:=-dy/2+oy/6;
                end;

                if rodzaj<>2 then begin
                  if rodzaj=0 then aktywna:=true
                      else if (abs(dx)>=0.3) or (abs(dy)>=0.3) or
                              (abs(koles[k].dx)>=0.3) or (abs(koles[k].dy)>=0.3) and (random(3)=0) then
                                aktywna:=true;
                end;

                if (abs(koles[k].dx)>1) or (abs(koles[k].dy)>1) or
                     (abs(dx)>1) or (abs(dy)>1) then begin
                   d1:=sqrt2(sqr(abs(dx))+sqr(abs(dy)));
                   d2:=sqrt2(sqr(abs(koles[k].dx))+sqr(abs(koles[k].dy)));
                   if (abs(d1)>=3) or (abs(d2)>=3) then begin

                       for b:=0 to random(3)+trunc((d1+d2)/2) do begin
                          if random(10)=0 then c:=1 else c:=0;
                          nowysyf(koles[k].x-5+random(10),koles[k].y-7+random(14),
                                  random*(dx-koles[k].dx)/2,
                                  random*(dy-koles[k].dy)/2,
                                  0,random(5),c,0,true,koles[k].team);
                       end;
                       koles[k].sila:=koles[k].sila-trunc((d1+d2)/4);
                       inc(gracz.pkt,trunc((d1+d2)/4));
                       if (warunki.typ_wody=0) or (koles[k].y<wyswodywx+15) then
                          form1.graj(druzyna[koles[k].team].dzwieki.Item[random(3)],koles[k].x,koles[k].y,10000)
                          else form1.graj(druzyna[koles[k].team].dzwieki.Item[8],koles[k].x,koles[k].y,5000);
                       koles[k].corobi:=cr_panika;

                   end;

                   x:=x-dx;
                   y:=y-dy;
                end;
             end;
             if (vars.bron.sterowanie<>k) then begin
                 if (aktywna) and (rodzaj=0) and {na ladzie, uciekajcie przed aktywna mina!}
                    (x>=koles[k].x-130) and (y>=koles[k].y-100) and
                    (x<=koles[k].x+130) and (y<=koles[k].y+60) and
                    (abs(koles[k].dx)<=1) and (abs(koles[k].dy)<=1) and (koles[k].corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_plynie]) and
                    (random(15)=0) then begin
                    if koles[k].corobi<>cr_plynie then koles[k].corobi:=cr_biegnie;
                    if koles[k].x>x then koles[k].kierunek:=1
                       else koles[k].kierunek:=-1;
                    if random(10)=0 then koles[k].skocz:=true;
                 end else
                 if (koles[k].corobi in [cr_stoi,cr_panika]) and {w wodzie, jak nurkuje w dol, to niech wieje przed mina pod nim}
                    (warunki.typ_wody>=1) and (y>wyswodywx+3) and
                    (x>=koles[k].x-17) and (y>=koles[k].y-15) and
                    (x<=koles[k].x+17) and (y<=koles[k].y+40) and
                    (abs(koles[k].dx)<=1) and (abs(koles[k].dy)<=2) and
                    (random(4)=0)
                    then begin
                    if koles[k].x>x then koles[k].kierunek:=1
                       else koles[k].kierunek:=-1;
                    koles[k].corobi:=cr_plynie;
                 end else
                 if {(rodzaj=1) and }(koles[k].corobi in [cr_idzie,cr_biegnie,cr_plynie]) and {w wodzie, zawracaj jak blisko miny z boku}
                    (x>=koles[k].x-25) and (y>=koles[k].y-20) and
                    (x<=koles[k].x+25) and (y<=koles[k].y+20) and
                    (abs(koles[k].dx)<=1) and (abs(koles[k].dy)<=1)
                    then begin
                    if koles[k].x>x then koles[k].kierunek:=1
                       else koles[k].kierunek:=-1;
                    if random(30)=0 then begin
                       koles[k].corobi:=cr_stoi;
                       koles[k].dy:=1.3+random/3;
                    end;
                 end else
                 if {(rodzaj=1) and }(koles[k].corobi=cr_plynie) and {oplywaj miny z gory lub z dolu}
                    (x>=koles[k].x-60) and (y>=koles[k].y-50) and
                    (x<=koles[k].x+60) and (y<=koles[k].y+50) and
                    (abs(koles[k].dx)<=1) and (abs(koles[k].dy)<=1)
                    then begin
                    {if koles[k].x>x then koles[k].kierunek:=1
                       else koles[k].kierunek:=-1;}
                    if abs(koles[k].dy)<0.8 then begin
                       if koles[k].y>=y then koles[k].dy:=koles[k].dy+0.013
                                        else koles[k].dy:=koles[k].dy-0.013;
                    end;
                 end else
                 if (not aktywna) and {przeskakuj mine na ladzie}
                    (x>=koles[k].x-30) and (y>=koles[k].y+5) and
                    (x<=koles[k].x+30) and (y<=koles[k].y+23) and
                    (abs(koles[k].dx)<=1) and (abs(koles[k].dy)<=1) and
                    (koles[k].corobi in [{cr_stoi,}cr_idzie,cr_biegnie,cr_panika]) and
                    (((koles[k].x<=x+10) and (koles[k].kierunek=1)) or
                     ((koles[k].x>=x-10) and (koles[k].kierunek=-1))) and
                    (random(5)=0) then begin
                    koles[k].skocz:=true;
                 end;
             end;
          end;
      end;

      {sprawdz czy mieso nie wpadlo w mine}
      for k:=0 to max_mieso do begin
          if (mieso[k].jest) then begin
             if (x>=mieso[k].x-10) and (x<=mieso[k].x+10) and
                (y>=mieso[k].y-10) and (y<=mieso[k].y+10) then begin
                if (abs(mieso[k].dx)>2) or (abs(mieso[k].dy)>2) or
                     (abs(dx)>2) or (abs(dy)>2) then begin
                   ox:=mieso[k].dx;
                   oy:=mieso[k].dy;
                   case rodzaj of
                     0:begin
                       mieso[k].dx:=-mieso[k].dx/2+dx/3+random/5-0.1;
                       mieso[k].dy:=-mieso[k].dy/2+dy/3+random/5-0.1;
                       end;
                     1,2:begin
                       mieso[k].dx:=-mieso[k].dx/2+dx/2+random/5-0.1;
                       mieso[k].dy:=-mieso[k].dy/2+dy/2+random/5-0.1;
                       end;
                   end;

                   dx:=-dx/1.2+ox/8+random/5-0.1;
                   dy:=-dy/1.2+oy/8+random/5-0.1;
                end;

                if rodzaj=0 then aktywna:=true
                    else if (rodzaj=1) and (
                            (abs(dx)>=0.3) or (abs(dy)>=0.3) or
                            (abs(mieso[k].dx)>=0.4) or (abs(mieso[k].dy)>=0.4) and (random(3)=0)
                           ) then
                              aktywna:=true;
                if (abs(mieso[k].dx)>1) or (abs(mieso[k].dy)>1) or
                     (abs(dx)>1) or (abs(dy)>1) then begin
                   x:=x-dx;
                   y:=y-dy;
                end;
             end;
          end;
      end;

      {sprawdz czy zwierz nie wpadl w mine}
      for k:=0 to max_zwierz do
          if (zwierz[k].jest) and
             (((abs(zwierz[k].dx)>=0.3) or (abs(zwierz[k].dy)>=0.3)) or
              ((abs(dx)>=0.3) or (abs(dy)>=0.3))) then begin
              if (x>=zwierz[k].x-10) and (x<=zwierz[k].x+10) and
                 (y>=zwierz[k].y-10) and (y<=zwierz[k].y+10) then begin
                  if (abs(zwierz[k].dx)>2) or (abs(zwierz[k].dy)>2) or
                       (abs(dx)>2) or (abs(dy)>2) then begin
                     ox:=zwierz[k].dx;
                     oy:=zwierz[k].dy;

                     zwierz[k].dx:=-zwierz[k].dx/2+dx/3+random/5-0.1;
                     zwierz[k].dy:=-zwierz[k].dy/2+dy/3+random/5-0.1;

                     dx:=-dx/1.2+ox/9+random/5-0.1;
                     dy:=-dy/1.2+oy/9+random/5-0.1;
                  end;

                  if rodzaj=0 then aktywna:=true
                      else if (rodzaj=1) and (
                              (abs(dx)>=0.3) or (abs(dy)>=0.3) or
                              (abs(zwierz[k].dx)>=0.4) or (abs(zwierz[k].dy)>=0.4) and (random(3)=0)
                              ) then
                                aktywna:=true;
                  if (abs(zwierz[k].dx)>1) or (abs(zwierz[k].dy)>1) or
                       (abs(dx)>1) or (abs(dy)>1) then begin
                     x:=x-dx;
                     y:=y-dy;
                  end;
              end else
              if (
                  ((zwierz[k].gatunek=0) and ((warunki.typ_wody=0) or (zwierz[k].y<wyswodywx))) or
                  ((zwierz[k].gatunek=1) and ((warunki.typ_wody>=1) and (zwierz[k].y>=wyswodywx+5)))
                 ) and
                 (x>=zwierz[k].x-30) and (x<=zwierz[k].x+30) and
                 (y>=zwierz[k].y-30) and (y<=zwierz[k].y+30) then begin
                  if (zwierz[k].y<y) and (zwierz[k].dy>-1) then zwierz[k].dy:=zwierz[k].dy-0.2
                     else if (zwierz[k].y>y) and (zwierz[k].dy<1) then zwierz[k].dy:=zwierz[k].dy+0.2;
                  if (zwierz[k].x<x) and (zwierz[k].dx>-1) then zwierz[k].dx:=zwierz[k].dx-0.2
                     else if (zwierz[k].x>x) and (zwierz[k].dx<1) then zwierz[k].dx:=zwierz[k].dx+0.2;

              end;
          end;

      if (lezy) and (abs(dx)<0.1) then dx:=0;
      if (lezy) and (abs(dy)<0.1) then dy:=0;

      if (ekran.iletrzes>=3) and (lezy or zaczepiona) then begin
         dx:=dx+random/10-0.05;
         dy:=dy+random/10-0.05;
      end;


      if (czasdowybuchu<=0) and (not zepsuta) then begin
         jest:=false;
         form1.graj(form1.dzw_wybuchy.Item[random(5)],x,y,10000);
         wybuch(x,y,45+random(30),true,true,true,false,-2,false);
         for k:=0 to 12+random(6) do
             nowywybuchdym(x,y,random-0.5,random-0.5,2,wd_dym,2+random(4),140+random(100),170+random(250));
         nowywybuchdym(x,y,0,0,random(3),wd_wybuch,1+random(4),random(2)*(220+random(35)));
         if (random(4)=0) then nowywybuchdym(x,y,0,0,0,wd_odblask,1,80);
         for k:=0 to 1+random(8) do
             nowywybuchdym(x,y,random/2-0.25,-0.2-random,0,wd_dym,2+random(6),(200+random(50)), 150+random(130));
         for k:=0 to 2+random(3) do
             nowysyf(x-dx,y-dy,random(360),2+random*3,1,random(5),ord(random(10)=0),1,false);

         if rodzaj=2 then begin//beczka
             nowywybuchdym(x,y,0,0,0,wd_swiatlo,1,60+random(40),250);
             for k:=0 to 15+random(15) do
                 strzel(x-dx,y-dy,random(360),2+random*11,1,-2,10+random(4),4,40,110,4,true,300+random(150));

         end;

      end else
          if zepsuta and aktywna and (czasdowybuchu<=0) and (czasdowybuchu>-10) then begin
             aktywna:=false;
             czasdowybuchu:=-10;
             for k:=0 to 2+random(6) do
              nowywybuchdym( x, y,
                             random/2-0.25,
                             -0.2-random,
                             0, wd_dym,
                             2+random(8),
                             50+random(200),
                             50+random(200) );

          end;

      if (vars.bron.przenoszenie) and
         (not przenoszony) and
         (x-ekran.px>=mysz.x-6) and
         (x-ekran.px<=mysz.x+6) and
         (y-ekran.py>=mysz.y-6) and
         (y-ekran.py<=mysz.y+6) then przenoszony:=true;

      if przenoszony then begin
         x:=mysz.x+ekran.px;
         y:=mysz.y+ekran.py;
         dx:=(mysz.x-mysz.sx)/2;
         dy:=(mysz.y-mysz.sy)/2;
      end;

end;
end;

procedure rysuj_miny;
var
a,n:longint;
wx,wy:smallint;

begin
for a:=0 to max_mina do
  if mina[a].jest then with mina[a] do begin
     n:=trunc(klatka);

     if lezy then begin
        wx:=ekran.trzesx;
        wy:=ekran.trzesy;
     end else begin
         wx:=0;
         wy:=0;
     end;
     case rodzaj of
       0:begin//ladowa
         form1.drawsprajt( obr.mina[ord(klatkamiganie>=19)],
                       trunc(x-obr.mina[ord(klatkamiganie>=19)].ofsx)-ekran.px+wx,
                       trunc(y-obr.mina[ord(klatkamiganie>=19)].ofsy)-ekran.py+wy,
                       n)
         end;
       1:begin//wodna
         if zaczepiona then begin
            form1.drawsprajt( obr.mina[3],
                            zaczx-ekran.px+ekran.trzesx-obr.mina[3].ofsx,
                            zaczy-ekran.py+ekran.trzesy-obr.mina[3].ofsy,
                            0);
            form1.PowerDraw1.WuLine( point(zaczx-ekran.px+ekran.trzesx,zaczy-ekran.py+ekran.trzesy),
                                   point(trunc(x)-ekran.px+wx,trunc(y)-ekran.py+wy),
                                   $ff808080,$ff808080,0);
         end;
         form1.drawsprajt( obr.mina[2],
                        trunc(x-obr.mina[ord(klatkamiganie>=19)].ofsx)-ekran.px+wx,
                        trunc(y-obr.mina[ord(klatkamiganie>=19)].ofsy)-ekran.py+wy,
                        n);
         end;
       2:begin//beczka
         form1.drawsprajt( obr.mina[4],
                       trunc(x-obr.mina[4].ofsx)-ekran.px+wx,
                       trunc(y-obr.mina[4].ofsy)-ekran.py+wy,
                       n);
    {    pisz(l2t(trunc(klatka),0),                       trunc(x-obr.mina[4].ofsx)-ekran.px+wx,
                       trunc(y-obr.mina[4].ofsy)-ekran.py+wy);}

         end;
     end;

end;
end;




end.
