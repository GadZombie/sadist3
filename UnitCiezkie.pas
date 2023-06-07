unit UnitCiezkie;

interface
uses Graphics, Types, vars, sinusy;

    procedure noweciezkie(sx,sy, sdx,sdy :real; rodz_:byte);
    procedure pauza_przenos_ciezkie;
    procedure ruszaj_ciezkie;
    procedure rysuj_ciezkie;
    procedure rysuj_ciezkie_na_terenie;

implementation
uses unit1, UnitSyfki, pdrawex, powertypes, d3d9, unitpociski, unitkolesie, unitwybuchy,
     unitmiesko, unitbomble, AGFUnit, unitrysowanie, unitefekty;

const
rodzaje_c:array[0..3] of record
                         maska:byte;
                         dzwiek:byte;
                         end=
                         ((maska:10; dzwiek:9),
                          (maska:9; dzwiek:10),
                          (maska:10; dzwiek:9),
                          (maska:1; dzwiek:11));
var
trzeba_zostawiac_c:boolean;


procedure noweciezkie(sx,sy, sdx,sdy :real; rodz_:byte);
var a,b:longint;
begin
a:=ciezkie_nowy;
b:=0;
while (b<max_ciezkie) and ((ciezkie[a].jest) or (ciezkie[a].zostaw)) do begin
   inc(a);
   inc(b);
   if a>=max_ciezkie then a:=0;
end;
if not ciezkie[a].jest then with ciezkie[a] do begin
   x:=sx;
   y:=sy;
   dx:=sdx;
   dy:=sdy;
   jest:=true;
   rodz:=rodz_;
   obrot:=0;
   obrsz:=0;
   lezy:=false;
   zostaw:=false;
   przenoszony:=false;
end;

end;

procedure pauza_przenos_ciezkie;
var a:integer;
begin
for a:=0 to max_ciezkie do
  if ciezkie[a].jest then with ciezkie[a] do begin
    if (vars.bron.przenoszenie) and
       (not przenoszony) and
       (x-ekran.px>=mysz.x-21) and
       (x-ekran.px<=mysz.x+21) and
       (y-ekran.py>=mysz.y-21) and
       (y-ekran.py<=mysz.y+21) then przenoszony:=true;

    if przenoszony then begin
       x:=mysz.x+ekran.px;
       y:=mysz.y+ekran.py;
       dx:=(mysz.x-mysz.sx)/6;
       dy:=(mysz.y-mysz.sy)/6;
    end;

  end;
end;

procedure ruszaj_ciezkie;
var a,k:longint; px,py,b,c,kat,n,n1:integer; p1:prect; d,kk0,_dx,_dy:real;
wyswodywx:integer; gl:real;
begin
for a:=0 to max_ciezkie do
  if ciezkie[a].jest then with ciezkie[a] do begin
    x:=x+dx;
    y:=y+dy;
    wyswodywx:=wyswody(x);
    if (warunki.typ_wody>=1) and (y>=wyswodywx) then
       obrsz:=dy/(10+random(10))
    else
       obrsz:=dx/(4);
    d:=1;

    if obrsz<-d then obrsz:=-d;
    if obrsz>d then obrsz:=d;
    if (not przenoszony) and
       (abs(dx)<=0.2) and (abs(dy)<=0.3) and
       (x>=0) and (y>=0) and
       (x<=teren.width-1) and (y<=teren.height+19) and (
       (teren.maska[trunc(x),trunc(y)+1]>0) or
       (teren.maska[trunc(x),trunc(y)+3]>0) or
       (teren.maska[trunc(x),trunc(y)+5]>0) or
       (teren.maska[trunc(x),trunc(y)+7]>0) or
       (teren.maska[trunc(x),trunc(y)+9]>0) or
       (teren.maska[trunc(x),trunc(y)+10]>0)
       )
       then lezy:=true
       else lezy:=false;
    {if ((abs(warunki.wiatr)>0.5) or (lezy=0)) and
       ((warunki.typ_wody=0) or (y<wyswodywx)) then dx:=dx+warunki.wiatr/4;}

    if random(2)=0 then begin
       dx:=dx*0.98;
       dy:=dy*0.98;
    end;
    if (not przenoszony) and ((x<0) or (x>teren.Width) or (y>teren.Height+30)) then begin
       jest:=false;
    end;

    if (warunki.typ_wody>=1) and (y>=wyswodywx) then begin
       if abs(dx)>gestosci[warunki.typ_wody].maxx*30 then dx:=dx/gestosci[warunki.typ_wody].x;
       if abs(dy)>gestosci[warunki.typ_wody].maxy*2 then dy:=dy/gestosci[warunki.typ_wody].y;
       if random(4)=0 then
          nowybombel(x-15+random(31),y+5+random(5),random/4-0.125,-random,random(150)+100,50+random(150));
    end;
    if (warunki.typ_wody>=1) and
       (((y-dy*2>=wyswodywx-2) and (y<wyswodywx-2)) or
        ((y-dy*2<wyswodywx-2) and (y>=wyswodywx-2))) and
       ((abs(dx)>0.1) or (abs(dy)>0.1)) then begin
       gl:=sqrt2(sqr(dx)+sqr(dy))/20;
       if gl<0.02 then gl:=0.02;
       if gl>1 then gl:=1;
       form1.graj(form1.dzw_rozne.item[5],x,y,7000,gl);
       for k:=0 to 20+random(10)+trunc(5*sqrt2(abs(dx*dx+dy*dy))) do
           nowysyf(x-15+random(31),wyswodywx-1,(random*4-2)+dx/2,-abs(random*dy),0,random(5),0,2,true, 0, warunki.typ_wody);
       plum(x,y,dy,20,6);
    end;

    obrot:=obrot+obrsz;
    if obrot>=60 then obrot:=obrot-60;
    if obrot<0 then obrot:=obrot+60;


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
    _dx:=_sin(kat)*10;
    _dy:=-_cos(kat)*10;
    d:=sqrt2(abs(dx*dx+dy*dy));

    if (trunc(x+_dx)>=0) and (trunc(y+_dy)>=0) and (trunc(x+_dx)<=teren.width-1) and (trunc(y+_dy)<=teren.height+30) and
       (teren.maska[trunc(x+_dx),trunc(y+_dy)]<>0) then begin
       if (d>0.08) then begin
          if dx>=0 then px:=1 else px:=-1;
          if dy>=0 then py:=1 else py:=-1;
          if (trunc(x+_dx)+px>=0) and (trunc(y+_dy)-py>=0) and
             (trunc(x+_dx)+px<=teren.width-1) and (trunc(y+_dy)-py<=teren.height+30) and
             (teren.maska[trunc(x+_dx)+px,trunc(y+_dy)-py]<>0) then begin
             x:=x-dx;
             dx:=-dx*0.4;
          end;
          if (trunc(x+_dx)-px>=0) and (trunc(y+_dy)+py>=0) and
             (trunc(x+_dx)-px<=teren.width-1) and (trunc(y+_dy)+py<=teren.height+30) and
             (teren.maska[trunc(x+_dx)-px,trunc(y+_dy)+py]<>0) then begin
             y:=y-dy;
             dy:=-dy*0.4;
          end;

          ekran.iletrzes:=ekran.iletrzes+trunc(d*2);
          if d/40>ekran.silatrzes then ekran.silatrzes:=d/40;
          if ekran.iletrzes>60 then ekran.iletrzes:=60-random(5);

          form1.graj(form1.dzw_bronie_inne.Item[rodzaje_c[rodz].dzwiek],x,y,4000);
          if d>=1 then
             for b:=0 to trunc(d) do
                 nowysyf(x-dx,y-dy,random(360),d,1,{random*2-1+dx, random*2-1+dy,0,}  random(5),0,1,false);
       end;
    end;
    if lezy then begin
       k:=random(2)*2-1;
       if (trunc(x+_dx+k)>=0) and (trunc(y+_dy+1)>=1) and (trunc(x+_dx+k)<=teren.width-1) and (trunc(y+_dy+1)<=teren.height+30) and
          (teren.maska[trunc(x+_dx+k),trunc(y+_dy+1)]=0) and (teren.maska[trunc(x+_dx+k),trunc(y+_dy)]=0) then begin
          dx:=dx+k/2;
       end else begin
          k:=-k;
          if (trunc(x+_dx+k)>=0) and (trunc(y+_dy+1)>=1) and (trunc(x+_dx+k)<=teren.width-1) and (trunc(y+_dy+1)<=teren.height+30) and
             (teren.maska[trunc(x+_dx+k),trunc(y+_dy+1)]=0) and (teren.maska[trunc(x+_dx+k),trunc(y+_dy)]=0) then begin
             dx:=dx+k/2;
          end else begin
             trzeba_zostawiac_c:=true;
             zostaw:=true;
             jest:=false;
          end;
       end;
     end;

    if ((abs(dx)>0.3) or (abs(dy)>0.3)) and (not lezy) then begin
       for k:=0 to max_kol do
        if (koles[k].jest) then begin
           if (x>=koles[k].x-30) and (y>=koles[k].y-30) and
              (x<=koles[k].x+30) and (y<=koles[k].y+30) then begin

                if kfg.detale>=2 then begin
                    b:=round(random(100)+120+d*13);
                    if b>350 then b:=350;
                    nowywybuchdym(koles[k].x,koles[k].y,
                                  dx/20,dy/20-0.5,
                                  0,wd_krew,random(3),
                                  random(2)*(180+random(70)),b,
                                  druzyna[koles[a].team].kolor_krwi,true);
                end;

                d:=sqrt(abs(sqr(dx)+sqr(dy)))*20;
                for b:=0 to 2+random(6)+trunc(d/4) do begin
                    if random(10)=0 then c:=1 else c:=0;
                    nowysyf(koles[k].x-3+random(7),
                            koles[k].y-3+random(7),
                            kat-40+random(91),
                            (d/20)+random*8,
                            1,random(5),c,0,true, koles[k].team);
                end;
                for b:=0 to 2+random(6)+trunc(d/3) do begin
                    if random(10)=0 then c:=1 else c:=0;
                    nowysyf(koles[k].x-3+random(7),
                            koles[k].y-3+random(7),
                            350+random(21),
                            (d/20)+random*8,
                            1,random(5),c,0,true, koles[k].team);
                end;
                if (warunki.typ_wody=0) or (koles[k].y<wyswodywx+15) then
                   form1.graj(druzyna[koles[k].team].dzwieki.Item[random(3)],koles[k].x,koles[k].y,10000)
                   else form1.graj(druzyna[koles[k].team].dzwieki.Item[8],koles[k].x,koles[k].y,5000);

                c:=koles[k].sila;
                koles[k].sila:=koles[k].sila-trunc(d*0.8);
                c:=c-koles[k].sila;
                if koles[k].sila<0 then c:=c-koles[k].sila;
                inc(gracz.pkt,c);

                if koles[k].sila<=0 then begin
                    if (koles[k].sila>=-6) then begin
                       c:=1;
                       n:=nowemieso(koles[k].x-koles_prx+druzyna[koles[k].team].miesomiejsca[c].x,
                                   koles[k].y-koles_pry+druzyna[koles[k].team].miesomiejsca[c].y,
                                   (druzyna[koles[k].team].miesomiejsca[c].x-koles_prx)/20,
                                   (druzyna[koles[k].team].miesomiejsca[c].y-koles_pry)/20,
                                   c,koles[k].team,koles[k].palisie,druzyna[koles[k].team].miesomiejsca[c].kl);

                        for c:=0 to 5 do begin
                            if random(10)=0 then n1:=-1 else n1:=n;
                            if c<>1 then
                             nowemieso(koles[k].x-koles_prx+druzyna[koles[k].team].miesomiejsca[c].x,
                                       koles[k].y-koles_pry+druzyna[koles[k].team].miesomiejsca[c].y,
                                       (druzyna[koles[k].team].miesomiejsca[c].x-koles_prx)/20,
                                       (druzyna[koles[k].team].miesomiejsca[c].y-koles_pry)/20,
                                       c,koles[k].team,koles[k].palisie,druzyna[koles[k].team].miesomiejsca[c].kl,n1);
                        end;
                     end else
                     if (koles[k].sila>=-120) then begin
                       c:=1;
                        n:=nowemieso(koles[k].x-koles_prx+druzyna[koles[k].team].miesomiejsca[c].x,
                                   koles[k].y-koles_pry+druzyna[koles[k].team].miesomiejsca[c].y,
                                   (druzyna[koles[k].team].miesomiejsca[c].x-koles_prx)/6,
                                   (druzyna[koles[k].team].miesomiejsca[c].y-koles_pry)/6,
                                   c,koles[k].team,koles[k].palisie,druzyna[koles[k].team].miesomiejsca[c].kl);
                        for c:=0 to 5 do begin
                            if random(5)=0 then n1:=-1 else n1:=n;
                            if c<>1 then
                             nowemieso(koles[k].x-koles_prx+druzyna[koles[k].team].miesomiejsca[c].x,
                                       koles[k].y-koles_pry+druzyna[koles[k].team].miesomiejsca[c].y,
                                       (druzyna[koles[k].team].miesomiejsca[c].x-koles_prx)/6,
                                       (druzyna[koles[k].team].miesomiejsca[c].y-koles_pry)/6,
                                       c,koles[k].team,koles[k].palisie,druzyna[koles[k].team].miesomiejsca[c].kl,n1);
                            end;
                     end else
                         inc(gracz.pkt,80);

                   inc(gracz.pkt,abs(koles[k].sila div 2));
                   koles[k].juz_sa_zwloki:=true;
                   //koles[k].sila:=0;
                end;

                if random(2)=0 then koles[k].corobi:=cr_panika;
                koles[k].dx:=koles[k].dx+dx;
                koles[k].dy:=koles[k].dy+dy;
                dx:=dx/1.5;
                dy:=dy/1.5;
           end else
           if ((x+_dx*10>=koles[k].x-70) and (y+_dy*10>=koles[k].y-80) and
               (x+_dx*10<=koles[k].x+70) and (y+_dy*10<=koles[k].y+80)) or
              ((x+_dx*20>=koles[k].x-70) and (y+_dy*20>=koles[k].y-80) and
               (x+_dx*20<=koles[k].x+70) and (y+_dy*20<=koles[k].y+80)) then begin
              if not (koles[k].corobi in [cr_plynie,cr_panika,cr_obracasie,cr_spada,cr_skacze]) then
                 koles[k].corobi:=cr_biegnie;
              if not (koles[k].corobi in [cr_panika,cr_obracasie]) then begin
                 if koles[k].x<x+_dx*10 then koles[k].kierunek:=-1
                                        else koles[k].kierunek:=1;
                 if (koles[k].zabic>=0) and (random(5)=0) then koles[k].zabic:=-1;
                 if (koles[k].zebrac>=0) and (random(5)=0) then koles[k].zebrac:=-1;
              end;
           end;
        end;

       for k:=0 to max_zwierz do
        if (zwierz[k].jest) then begin
           if (x>=zwierz[k].x-20) and (y>=zwierz[k].y-20) and
              (x<=zwierz[k].x+20) and (y<=zwierz[k].y+20) then begin
                d:=sqrt(abs(sqr(dx)+sqr(dy)))*10;
                for b:=0 to 2+random(6)+trunc(d/3) do begin
                    if random(10)=0 then c:=1 else c:=0;
                    nowysyf(zwierz[k].x-3+random(7),
                            zwierz[k].y-3+random(7),
                            kat-40+random(91),
                            (d/20)+random*8,
                            1,random(5),c,0,true, -1);
                end;
                {if (warunki.typ_wody=0) or (zwierz[k].y<wyswodywx+15) then
                   form1.graj(druzyna[zwierz[k].team].dzwieki.Item[random(3)],zwierz[k].x,zwierz[k].y,10000)
                   else form1.graj(druzyna[zwierz[k].team].dzwieki.Item[8],zwierz[k].x,zwierz[k].y,5000);}

                c:=zwierz[k].sila;
                zwierz[k].sila:=zwierz[k].sila-trunc(d);
                c:=c-zwierz[k].sila;
                if zwierz[k].sila<0 then c:=c-zwierz[k].sila;
                inc(gracz.pkt,c);

                if zwierz[k].sila<=0 then begin
                   nowemieso(zwierz[k].x,
                             zwierz[k].y,
                             random*2-1+dx,
                             random*2-1+dy,
                             zwierz[k].rodzaj,-1,zwierz[k].palisie,random(60));
                   zwierz[k].juzzabity:=true;
                end;

                zwierz[k].dx:=zwierz[k].dx+dx;
                zwierz[k].dy:=zwierz[k].dy+dy;
                dx:=dx/1.05;
                dy:=dy/1.05;
           end else
           if (x+_dx*10>=zwierz[k].x-50) and (y+_dy*10>=zwierz[k].y-50) and
              (x+_dx*10<=zwierz[k].x+50) and (y+_dy*10<=zwierz[k].y+50) then begin
              if zwierz[k].y<y+_dy*10 then zwierz[k].dy:=zwierz[k].dy-0.5
                                      else zwierz[k].dy:=zwierz[k].dy+0.5;
              if zwierz[k].x<x+_dx*10 then zwierz[k].dx:=zwierz[k].dx-0.5
                                      else zwierz[k].dx:=zwierz[k].dx+0.5;

              if zwierz[k].dx>2 then zwierz[k].dx:=2;
              if zwierz[k].dx<-2 then zwierz[k].dx:=-2;
              if zwierz[k].dy>2 then zwierz[k].dy:=2;
              if zwierz[k].dy<-2 then zwierz[k].dy:=-2;

           end;
        end;


       for k:=0 to max_mina do
           if (mina[k].jest) and
              (x>=mina[k].x-20) and (y>=mina[k].y-20) and
              (x<=mina[k].x+20) and (y<=mina[k].y+20) then begin
              mina[k].czasdowybuchu:=1+random(5);
              mina[k].aktywna:=true;
              mina[k].dx:=mina[k].dx+dx/2-0.125+random/4;
              mina[k].dy:=mina[k].dy+dy/2-0.125+random/4;
              if mina[k].dx>5 then mina[k].dx:=5;
              if mina[k].dx<-5 then mina[k].dx:=-5;
              if mina[k].dy>5 then mina[k].dy:=5;
              if mina[k].dy<-5 then mina[k].dy:=-5;
           end;

       for k:=0 to max_przedm do
           if (przedm[k].jest) and
              (x>=przedm[k].x-20) and (y>=przedm[k].y-20) and
              (x<=przedm[k].x+20) and (y<=przedm[k].y+20) then begin
              przedm[k].rozwal:=true;
              przedm[k].dx:=przedm[k].dx+dx/2-0.125+random/4;
              przedm[k].dy:=przedm[k].dy+dy/2-0.125+random/4;
           end;

       for k:=0 to max_mieso do
           if (mieso[k].jest) and
              (x>=mieso[k].x-20) and (y>=mieso[k].y-20) and
              (x<=mieso[k].x+20) and (y<=mieso[k].y+20) then begin
              mieso[k].dx:=mieso[k].dx+dx/2-0.125+random/4;
              mieso[k].dy:=mieso[k].dy+dy/2-0.125+random/4;
              if (sqrt2(sqr(mieso[k].dx)+sqr(mieso[k].dy))>=6) and (random(15)=0) and
                 (mieso[k].team>=-1) then begin
                 for b:=0 to 10+random(10) do begin
                     if random(6)=0 then c:=1 else c:=0;
                     nowysyf(mieso[k].x-4+random(9),
                             mieso[k].y-4+random(9),
                             mieso[k].dx/3+dx-1+random*2,
                             mieso[k].dy/3+dy-1+random*2,
                             0,
                             random(5),c,0,true, mieso[k].team);
                 end;
                 mieso[k].jest:=false;
              end else begin
                  if mieso[k].dx>5 then mieso[k].dx:=5;
                  if mieso[k].dx<-5 then mieso[k].dx:=-5;
                  if mieso[k].dy>5 then mieso[k].dy:=5;
                  if mieso[k].dy<-5 then mieso[k].dy:=-5;
              end;
           end;

    end;

    if jest then begin
        if not lezy then dy:=dy+0.15*warunki.grawitacja;

        if (lezy) and (abs(dx)<0.1) then dx:=0;
        if (lezy) and (abs(dy)<0.1) then dy:=0;

        if (ekran.iletrzes>=3) and (lezy) then begin
           dx:=dx+random/10-0.05;
           dy:=dy+random/10-0.05;
        end;

        if (vars.bron.przenoszenie) and
           (not przenoszony) and
           (x-ekran.px>=mysz.x-21) and
           (x-ekran.px<=mysz.x+21) and
           (y-ekran.py>=mysz.y-21) and
           (y-ekran.py<=mysz.y+21) then przenoszony:=true;

        if przenoszony then begin
           x:=mysz.x+ekran.px;
           y:=mysz.y+ekran.py;
           dx:=(mysz.x-mysz.sx)/6;
           dy:=(mysz.y-mysz.sy)/6;
        end;
    end;

end;
end;

procedure rysuj_ciezkie;
var a:longint;
begin
for a:=0 to max_ciezkie do
  if ciezkie[a].jest or ciezkie[a].zostaw then with ciezkie[a] do begin
     form1.drawsprajt(obr.ciezkie[rodz],
               trunc(x-obr.ciezkie[rodz].ofsx)-ekran.px,
               trunc(y-obr.ciezkie[rodz].ofsy)-ekran.py,
               trunc(obrot));
  end;

end;


procedure rysuj_ciezkie_na_terenie;
var
 a:longint;
 px,py,px1,py1,
 n, nx:integer;
 LRect: TD3DLocked_Rect;
 lrectr:TD3DLocked_Rect;
 DestPtr,srcptr: Pointer;
 getvalu:cardinal;
begin
if not trzeba_zostawiac_c then exit;

obr.teren.surf.Lock(0, LRect);
for a:=0 to max_ciezkie do
  if (ciezkie[a].zostaw) and (not ciezkie[a].jest) then with ciezkie[a] do begin
        obr.ciezkie[rodz].surf.Lock(0, lrectr);
        while obrot>=obr.ciezkie[rodz].klatek do obrot:=obrot-obr.ciezkie[rodz].klatek;
        while obrot<0 do obrot:=obrot+obr.ciezkie[rodz].klatek;

        n:=trunc(obrot);
        nx:=obr.ciezkie[rodz].surf.ImagesPerWidth;

        for py:=0 to obr.ciezkie[rodz].ry-1 do
           for px:=0 to obr.ciezkie[rodz].rx-1 do begin
               px1:=px+trunc(x-obr.ciezkie[rodz].ofsx);
               py1:=py+trunc(y-obr.ciezkie[rodz].ofsy);

               if (px1>=0) and (px1<=teren.width-1) and
                  (py1>=0) and (py1<=teren.height-1) then begin

                  srcPtr:=Pointer(
                           Integer(LRectr.Bits) +
                           (LRectr.Pitch * ((obr.ciezkie[rodz].ry * (n div nx) ) + py)) +
                           (obr.ciezkie[rodz].rx * (n mod nx)) * obr.ciezkie[rodz].surf.BytesPerPixel +
                           (px * obr.ciezkie[rodz].surf.BytesPerPixel)
                          );

                  pdrawFormatConv(SrcPtr, @getvalu, obr.ciezkie[rodz].surf.Format, D3DFMT_A8R8G8B8);

                  if (getvalu and $FF000000>$90000000) then begin
                     getvalu:=getvalu or $FF000000;
                     DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * py1) + (px1 * obr.teren.surf.BytesPerPixel));
                     pdrawFormatConv(@getValu, DestPtr, D3DFMT_A8R8G8B8, obr.teren.surf.Format);

                     if //(teren.maska[px1,py1]=0) and
                        (px>=1) and (py>=1) and (px<=obr.ciezkie[rodz].ry-2) and (py<=obr.ciezkie[rodz].ry-2) then
                        teren.maska[px1,py1]:=rodzaje_c[rodz].maska;
                  end;
               end;
           end;
        zostaw:=false;
        obr.ciezkie[rodz].surf.unLock(0);
  end;

obr.teren.surf.unLock(0);
trzeba_zostawiac_c:=false;
end;


end.
