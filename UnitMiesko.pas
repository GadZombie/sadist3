unit UnitMiesko;

interface
uses Graphics, Types, vars, sinusy;

    function nowemieso(sx,sy, sdx,sdy :real; rodz_:byte;team_:shortint;palisie_:boolean; klatka_poczatkowa:smallint; podpietydo_:integer=-1; kolor_:cardinal=$FFFFFFFF; st_spalenia:byte=255):integer;
    procedure ruszaj_mieso;
    procedure rysuj_mieso;
    procedure rysuj_mieso_na_terenie;

implementation
uses unit1, UnitSyfki, pdrawex, powertypes, d3d9, unitpociski, unitkolesie, unitwybuchy, unitrysowanie, unitefekty, unitstringi, unitgraglowna;
const
wlasnoscismieci:array[0..max_smieci] of record
                  waga:single;
                  odbicie:single;
                  uderza:boolean;
                end=
                ( {pilka    }(waga:0.045; odbicie:0.97 ),
                  {pilkaplaz}(waga:0.036; odbicie:0.90 ),
                  {jablko   }(waga:0.055; odbicie:0.45 ),
                  {kamol    }(waga:0.090; odbicie:0.25; uderza:true ),
                  {cegla    }(waga:0.100; odbicie:0.23; uderza:true ),
                  {sztylet  }(waga:0.060; odbicie:0.15; uderza:true ),
                  {tasak    }(waga:0.080; odbicie:0.17; uderza:true ),
                  {karabin  }(waga:0.110; odbicie:0.23; uderza:false)
                );
var
trzeba_zostawiac:boolean;

function nowemieso(sx,sy, sdx,sdy :real; rodz_:byte;team_:shortint;palisie_:boolean; klatka_poczatkowa:smallint; podpietydo_:integer=-1; kolor_:cardinal=$FFFFFFFF; st_spalenia:byte=255):integer;
var a,b:longint;
begin
a:=mieso_nowy;
b:=0;
while (b<max_mieso) and ((mieso[a].jest) or (mieso[a].zostaw)) do begin
   inc(a);
   inc(b);
   if a>=max_mieso then a:=0;
end;
if not mieso[a].jest then with mieso[a] do begin
   x:=sx;
   y:=sy;
   dx:=sdx;
   dy:=sdy;
   jest:=true;
   rodz:=rodz_;
   team:=team_;
   if klatka_poczatkowa=-1 then
      if team=-2 then obrot:=random(60)
                 else obrot:=random(druzyna[team].mieso[rodz].klatek)
   else
      obrot:=klatka_poczatkowa;
   obrsz:=0.1+random/2;
   lezy:=0;
   trzymaneprzez:=-1;
   zostaw:=false;
   if team>=-1 then krwawi:=20+random(40)
               else krwawi:=0;
   palisie:=palisie_;
   podpietydo:=podpietydo_;
   stopien_spalenia:=st_spalenia;
   kolor:=kolor_;

   result:=a;
end else result:=-1;

end;

procedure ruszaj_mieso;
var a,k:longint; px,py,b,c:integer; p1:prect; d,kt,d1,d2:real; ppx,ppy, wx,wy:integer;
wyswodywx:integer; gl:real;
begin
for a:=0 to max_mieso do
  if mieso[a].jest then with mieso[a] do begin
    if trzymaneprzez=-1 then begin
        if (podpietydo>=0) and (not mieso[podpietydo].jest) then podpietydo:=-1;

        if (podpietydo>=0) then begin
     (*      ppx:=round( mieso[podpietydo].obrot+druzyna[team].miesomiejsca[rodz].kl ) mod druzyna[team].mieso[rodz].klatek;
           if obrot<ppx then begin
              {obrot:=obrot+3;
              if obrot>ppx then }obrot:=ppx;
              obrot:=trunc(obrot) mod druzyna[team].mieso[rodz].klatek;
           end else
           if obrot>ppx then begin
              {obrot:=obrot+3;
              if obrot<ppx then} obrot:=ppx;
              obrot:=trunc(obrot) mod druzyna[team].mieso[rodz].klatek;
           end;
              *)
(*TAK BYLO W MIESKU:
           ppx:=round( mieso[podpietydo].x+ _sin(trunc(mieso[podpietydo].obrot*6+ druzyna[team].miesomiejsca[rodz].kat ))*druzyna[team].miesomiejsca[rodz].odl );
           ppy:=round( mieso[podpietydo].y- _cos(trunc(mieso[podpietydo].obrot*6+ druzyna[team].miesomiejsca[rodz].kat ))*druzyna[team].miesomiejsca[rodz].odl );

           if x<ppx-2 then x:=ppx-2 else
           //if x<ppx-2 then dx:=dx+1 else
           if x>ppx+2 then x:=ppx+2 else
           //if x>ppx+2 then dx:=dx-1 else
              dx:=mieso[podpietydo].dx;
           if y<ppy-7 then y:=ppy-7 else
           //if y<ppy-2 then dy:=dy+1 else
           if y>ppy+2 then y:=ppy+2 else
           //if y>ppy+2 then dy:=dy-1 else
              dy:=mieso[podpietydo].dy;
*)

           if abs(mieso[podpietydo].obrsz)>=0.1 then mieso[podpietydo].obrsz:=mieso[podpietydo].obrsz/2;
           obrsz:=0;
           //pozycja, jaka powinna byc:
           wx:= druzyna[team].miesomiejsca[rodz].x - druzyna[mieso[podpietydo].team].miesomiejsca[mieso[podpietydo].rodz].x +
                druzyna[team].miesomiejsca[rodz].zaczx;
           wy:= druzyna[team].miesomiejsca[rodz].y - druzyna[mieso[podpietydo].team].miesomiejsca[mieso[podpietydo].rodz].y +
                druzyna[team].miesomiejsca[rodz].zaczy;

           kt:=jaki_to_kat_r(wx,wy);

           d2:=round( sqrt2(sqr( wx )+sqr( wy )) );

           ppx:=round( mieso[podpietydo].x+ _sin(round(mieso[podpietydo].obrot*6 + kt))*d2 );
           ppy:=round( mieso[podpietydo].y- _cos(round(mieso[podpietydo].obrot*6 + kt))*d2 );

           //taka odleglosc jest mieska od miejsca, gdzie ma byc:
           d:=round( sqrt2(sqr( x-ppx  )+sqr( y-ppy )) );
           //a taka odleglosc byc powinna:
           d1:=round( sqrt2(sqr( druzyna[team].miesomiejsca[rodz].x + druzyna[team].miesomiejsca[rodz].zaczx )+
                            sqr( druzyna[team].miesomiejsca[rodz].y + druzyna[team].miesomiejsca[rodz].zaczy )) );

           //i tera sprawdzmy czy jest w dobrej odleglosci od miejsca, gdzie powinien byc
           //if d<>d1 then begin //bo jesli nie, to
              //oblicz kat miedzy miejscem, gdzie jest, a tym gdzie powinno byc
              gl:=(d-d1)/4;
              if gl>1 then gl:=1;
              if gl<-1 then gl:=-1;

              kt:={mieso[podpietydo].obrot*6;//}jaki_to_kat_r(ppx-x, ppy-y);
              dx:=dx+sin(kt*pi180)*gl;
              dy:=dy-cos(kt*pi180)*gl;
              x:= ppx-sin(kt*pi180)*d1;
              y:= ppy+cos(kt*pi180)*d1;

              obrot:=druzyna[team].miesomiejsca[rodz].kl+kt/6 ;

           //end;

        end;


        x:=x+dx;
        y:=y+dy;
        wyswodywx:=wyswody(x);
        if team>=-1 then begin
            if (warunki.typ_wody>=1) and (y>=wyswodywx) then
               obrsz:=dy/((90+random(6))/druzyna[team].mieso[rodz].klatek)
               else
               obrsz:=dx/(60/druzyna[team].mieso[rodz].klatek);
            d:=druzyna[team].mieso[rodz].klatek*0.025;
        end else begin
            if (warunki.typ_wody>=1) and (y>=wyswodywx) then
               obrsz:=dy/((70+random(6))/obr.smieci[rodz].klatek)
               else
               obrsz:=dx/(20/obr.smieci[rodz].klatek);
            d:=obr.smieci[rodz].klatek*0.05;
        end;



        if obrsz<-d then obrsz:=-d;
        if obrsz>d then obrsz:=d;
        if abs(obrsz)<0.03 then obrsz:=0.03;
        if (abs(dx)<=0.1) and (abs(dy)<=0.1) and (x>=0) and (y>=0) and
           (x<=teren.width-1) and (y<=teren.height+30) and
           (teren.maska[trunc(x),trunc(y)+1]>0) then inc(lezy)
           else lezy:=0;
        if ((abs(warunki.wiatr)>0.5) or (lezy=0)) and
           ((warunki.typ_wody=0) or (y<wyswodywx)) then begin
           if team=-2 then dx:=dx+warunki.wiatr/(100*wlasnoscismieci[rodz].waga)
                      else dx:=dx+warunki.wiatr/8;
        end;

        if random(2)=0 then begin
           dx:=dx*0.98;
           dy:=dy*0.98;
        end;
        if (x<0) or (x>teren.Width) then begin
           jest:=false;
        end;
        if y>teren.Height+30 then begin
           jest:=false;
          { y:=DXDraw1.Height-2;
           dy:=-abs(dy)*0.91;}

        end;

        if (warunki.typ_wody>=1) and (y>=wyswodywx) then begin
           if abs(dx)>gestosci[warunki.typ_wody].maxx{0.02} then dx:=dx/gestosci[warunki.typ_wody].x*1.09{1.2};
           if abs(dy)>gestosci[warunki.typ_wody].maxy*0.7 then dy:=dy/gestosci[warunki.typ_wody].y{1.2};
           case warunki.typ_wody of
              2:begin
                if not palisie then palisie:=true;
                if (y>=wyswodywx+20) and (random(70)=0) then jest:=false;
                end;
              else begin
                if palisie then palisie:=false;
                end;
           end;
        end;
        if (warunki.typ_wody>=1) and
           //(y>=wyswodywx-10) and (y<=wyswodywx) and
           (((y-dy>=wyswodywx-2) and (y<wyswodywx-2)) or
            ((y-dy<wyswodywx-2) and (y>=wyswodywx-2))) and
           ((abs(dx)>0.8) or (abs(dy)>0.7)) {and (random(3)=0) }then begin
           form1.graj(form1.dzw_rozne.item[5],x,y,7000);
           for k:=0 to 5+random(10) do
               nowysyf(x-8+random(16),wyswodywx-1,(random*2-1)+dx/2,-abs(random*dy/2),0,random(5),0,2,true, team, warunki.typ_wody);
           if team>=-1 then plum(x,y,dy,9,1.5)
                       else plum(x,y,dy,9,30*wlasnoscismieci[rodz].waga);
        end;

        if (mieso[a].podpietydo>=0) and (random(70)=0) and
           (sqrt2(dx*dx+dy*dy)>=9) then mieso[a].podpietydo:=-1;

        if palisie then begin
           if (random(10)=0) then begin
              strzel(x,y-5,-random+0.5,-random/1.6,0,a,10,5,10,-20-random(15),5,false,8+random(20));
              if random(36)=0 then palisie:=false;
           end;
           if (random(10)=0) and (kfg.detale>=2) then
//              nowywybuchdym(x,y,random/2-0.25,-random/2,0,wd_dym,random(2)+1,random(2)*(120+random(130)));
              nowywybuchdym( x, y,
                             random/2-0.25,
                             -0.1-random/1.2,
                             0, wd_dym,
                             3+random(5),
                             160+random(90),
                             110+random(140));

           if (stopien_spalenia>5) and (random(2)=0) then begin
              dec(stopien_spalenia);
              if team>=-1 then begin
                 if (stopien_spalenia>=128) then //czerwieni sie
                    kolor:=$FF0000FF or (stopien_spalenia shl 16) or (stopien_spalenia shl 8)
                 else
                    kolor:=$FF000000 or (stopien_spalenia shl 16) or (stopien_spalenia shl 8) or (stopien_spalenia shl 1{czyli *2});
              end else
                 kolor:=$FF000000 or (stopien_spalenia shl 16) or (stopien_spalenia shl 8) or stopien_spalenia;
           end;

        end;

        if podpietydo<0 then obrot:=obrot+obrsz;
        if team>=-1 then begin
           if obrot>=druzyna[team].mieso[rodz].klatek then obrot:=obrot-druzyna[team].mieso[rodz].klatek;
           if obrot<0 then obrot:=obrot+druzyna[team].mieso[rodz].klatek;
        end else begin
           if obrot>=obr.smieci[rodz].klatek then obrot:=obrot-obr.smieci[rodz].klatek;
           if obrot<0 then obrot:=obrot+obr.smieci[rodz].klatek;
        end;

        if (trunc(x+dx)>=0) and (trunc(y+dy)>=0) and (trunc(x+dx)<=teren.width-1) and (trunc(y+dy)<=teren.height+30) and
           (teren.maska[trunc(x+dx),trunc(y+dy)]<>0) then begin
           if (sqrt2(abs(dx*dx+dy*dy))>0.08) then begin
              if (krwawi>0) and ((abs(dx)>0.3) or (abs(dy)>0.3)) then begin
                 d:=sqrt2(abs(sqr(dx)+sqr(dy)));
                 if (kfg.detale>=2) and (podpietydo=-1) or ((podpietydo>=0) and (random(5)=0)) then begin
                    if d>=0.7 then
                       nowywybuchdym(x,y,
                                  -dx/15,-dy/15-0.5,
                                  0,wd_krew,random(2),
                                  (200+random(70)),40+random(120),
                                  druzyna[team].kolor_krwi,true);

                     for px:=0 to 3+trunc(d*0.3*(krwawi/30)){random(20-krwawi div 3)} do
                         nowysyf(x-dx,y-dy,random(360),2.4+random*d*2,1,0,0,0,false,team);
                     (*for px:=0 to 3+trunc(d*(krwawi/30)){random(20-krwawi div 3)} do
                         nowysyf(x-dx,y-dy,random(360),2.4+random*d*2,1,0,0,0,false,team);*)
                 end;
                 if (mieso[a].podpietydo>=0) and (random(5)=0) and
                    (sqrt2(dx*dx+dy*dy)>=8) then mieso[a].podpietydo:=-1;

              end;
              if dx>=0 then px:=1 else px:=-1;
              if dy>=0 then py:=1 else py:=-1;
              if (trunc(x)+px>=0) and (trunc(y)-py>=0) and
                 (trunc(x)+px<=teren.width-1) and (trunc(y)-py<=teren.height+30) and
                 (teren.maska[trunc(x)+px,trunc(y)-py]<>0) then begin
                 if team>=-1 then dx:=-dx*0.7
                            else dx:=-dx*wlasnoscismieci[rodz].odbicie;
              end;
              if (trunc(x)-px>=0) and (trunc(y)+py>=0) and
                 (trunc(x)-px<=teren.width-1) and (trunc(y)+py<=teren.height+30) and
                 (teren.maska[trunc(x)-px,trunc(y)+py]<>0) then begin
                 if team>=-1 then dy:=-dy*0.7
                            else dy:=-dy*wlasnoscismieci[rodz].odbicie;
              end;
              if (random(3)=0) and (podpietydo=-1) and
                 ((warunki.typ_wody=0) or ((warunki.typ_wody>=1) and (y<wyswodywx)))
                 then begin
                   if (team>=0) and (team<=127) and (sqrt2(sqr(dx)+sqr(dy))>0.8) then begin
                      gl:=sqrt2(sqr(dx)+sqr(dy))/3;
                      if gl<0.02 then gl:=0.02;
                      if gl>1 then gl:=1;
                      form1.graj(druzyna[team].dzwieki.Item[3],x,y,7000,gl);
                   end;
              end;
           end;
        end;
        if lezy>=1 then begin
           k:=1;
           if (trunc(x+k)>=0) and (trunc(y+1)>=1) and (trunc(x+k)<=teren.width-1) and (trunc(y+1)<=teren.height+30) and
              (teren.maska[trunc(x+k),trunc(y+1)]=0) and (teren.maska[trunc(x+k),trunc(y)]=0) then begin
              dx:=dx+k/2;
           end else begin
              k:=-1;
              if (trunc(x+k)>=0) and (trunc(y+1)>=1) and (trunc(x+k)<=teren.width-1) and (trunc(y+1)<=teren.height+30) and
                 (teren.maska[trunc(x+k),trunc(y+1)]=0) and (teren.maska[trunc(x+k),trunc(y)]=0) then begin
                 dx:=dx+k/2;
              end else if lezy>=10 then begin
                 if kfg.krew_mieso_zostawia_slady then begin
                    trzeba_zostawiac:=true;
                    zostaw:=true;
                 end;
                 jest:=false;
              end;
           end;
         end;

    end else if ((trzymaneprzez<=max_kol) and (koles[trzymaneprzez].ktoretrzymamieso<>a))
                or (trzymaneprzez>max_kol) then trzymaneprzez:=-1;

    for k:=0 to max_kol do begin
        if (koles[k].jest) then begin
           if (koles[k].corobi in [cr_stoi]) and
              (x>=koles[k].x-10) and (y>=koles[k].y-10) and {moze koles zlapie mieso?}
              (x<=koles[k].x+10) and (y<=koles[k].y+10) then begin
                 if (random(2)=0) then begin
                     trzymaneprzez:=k;
                     koles[k].ktoretrzymamieso:=a;
                     koles[k].corobi:=cr_trzyma;
                 end;
           end else {a jesli nie, to moze oberwie jak to kamol?}
           if (team<-1) and (wlasnoscismieci[rodz].uderza) and
              ((abs(dx)>0.6) or (abs(dy)>0.6)) and
              (x>=koles[k].x-10) and (y>=koles[k].y-13) and
              (x<=koles[k].x+10) and (y<=koles[k].y+14) and
              (random(2)=0) then begin
                d:=sqrt(abs(sqr(dx)+sqr(dy)));
                for b:=0 to 2+random(6)+trunc(d*2) do begin
                    if random(10)=0 then c:=1 else c:=0;
                    nowysyf(x-2+random(5),koles[k].y-2+random(5),
                            random*dx/2,
                            random*dy/2,
                            0,random(5),c,0,true, koles[k].team);
                end;
                if (warunki.typ_wody=0) or (koles[k].y<wyswodywx+15) then
                   form1.graj(druzyna[koles[k].team].dzwieki.Item[random(3)],koles[k].x,koles[k].y,10000)
                   else form1.graj(druzyna[koles[k].team].dzwieki.Item[8],koles[k].x,koles[k].y,5000);
                koles[k].sila:=koles[k].sila-trunc(d);
                gracz.pkt:=gracz.pkt+trunc(d);
                if random(2)=0 then koles[k].corobi:=cr_panika;
                koles[k].dx:=koles[k].dx+dx/2;
                koles[k].dy:=koles[k].dy+dy/2;
                dx:=-dx*wlasnoscismieci[rodz].odbicie;
                dy:=-dy*wlasnoscismieci[rodz].odbicie;
           end else {a jesli nie, to moze je kopnie?}
           if (vars.bron.sterowanie<>k) and
              ((trzymaneprzez=-1) or
               ((trzymaneprzez>=0) and (koles[trzymaneprzez].team<>koles[k].team))
              ) and
              (koles[k].corobi in [cr_stoi,cr_idzie,cr_biegnie]) and
              (x>=koles[k].x-15) and (y>=koles[k].y-12) and
              (x<=koles[k].x+15) and (y<=koles[k].y+15) and
              (random(15)=0) then begin
               koles[k].corobil:=koles[k].corobi;
               if y>=koles[k].y+2 then koles[k].corobi:=cr_kopie
                  else if y>=koles[k].y-6 then koles[k].corobi:=cr_bije
                       else koles[k].corobi:=cr_grzywa;
               koles[k].anikl:=0;
               koles[k].anido:=0;
               koles[k].cochcekopnac:=1;
               koles[k].ktoregochcekopnac:=a;
               if x>=koles[k].x then koles[k].kierunek:=1 else koles[k].kierunek:=-1;
           end else {a jak jest w poblizu to moze sie tym zainteresuje?}
           if (vars.bron.sterowanie<>k) and
              (not wlasnoscismieci[rodz].uderza) and
              (koles[k].zainteresowanie_miesem=-1) and
              ((trzymaneprzez=-1) or (random(50)=0)) and
              (koles[k].zabic=-1) and (not koles[k].palisie) and
              (koles[k].corobi in [cr_stoi,cr_idzie,cr_biegnie]) and
              (x>=koles[k].x-150) and (y>=koles[k].y-130) and
              (x<=koles[k].x+150) and (y<=koles[k].y+40) and
              (random(200)=0) and
              (sprawdz_pusta_linie(trunc(koles[k].x-3+random(7)),trunc(koles[k].y-12+random(3)),
                                   trunc(x),trunc(y)))
              then begin
              koles[k].zainteresowanie_miesem:=a;

           end;

        end;
    end;


    if jest then begin
        if (lezy=0) and (trzymaneprzez=-1) then begin
           if team>=-1 then dy:=dy+(0.055+(0.01*(3-rodz)))*warunki.grawitacja
                      else dy:=dy+wlasnoscismieci[rodz].waga*warunki.grawitacja;
        end;

        if (lezy>=1) and (abs(dx)<0.1) then dx:=0;
        if (lezy>=1) and (abs(dy)<0.1) then dy:=0;

        if (ekran.iletrzes>=3) and (lezy>=1) then begin
           dx:=dx+random/10-0.05;
           dy:=dy+random/10-0.05;
        end;

        if (krwawi>0) and (podpietydo=-1) and (random(30-krwawi div 2)=0) then begin
           if random(10)=0 then
               nowysyf(x,y,random(360),4+random*6,1,0,random(2),0,false,team)
           else
               nowysyf(x,y,random/4-0.125,random/2-0.3,0,0,0,0,false,team);
           dec(krwawi);
        end;

    end;

end;
//form1.DXDraw1.Surface.Canvas.Release;
end;

procedure rysuj_mieso;
var a:longint;
begin
for a:=0 to max_mieso do
  if mieso[a].jest or mieso[a].zostaw then with mieso[a] do begin
     if team>=-1 then begin
        if rodz<>7 then
          form1.drawsprajtkolor(druzyna[team].mieso[rodz],
                 trunc(x-druzyna[team].mieso[rodz].ofsx)-ekran.px,
                 trunc(y-druzyna[team].mieso[rodz].ofsy)-ekran.py,
                 trunc(obrot), kolor)
        else
     end else
        form1.drawsprajtkolor(obr.smieci[rodz],
               trunc(x-obr.smieci[rodz].ofsx)-ekran.px,
               trunc(y-obr.smieci[rodz].ofsy)-ekran.py,
               trunc(obrot), kolor);

     if palisie then
        form1.drawsprajtalpha(obr.pocisk[5],
                   trunc(x-obr.pocisk[5].ofsx)-ekran.px-1+random(3),
                   trunc(y-obr.pocisk[5].ofsy)-ekran.py-3+random(5),
                   random(26),180+random(70));
  end;

end;


procedure rysuj_mieso_na_terenie;
var
 a:longint; px,py,px1,py1:integer;
 LRect: TD3DLocked_Rect;
 lrectr:TD3DLocked_Rect;
 DestPtr,srcptr: Pointer;
 getvalu:cardinal;
 g:array[0..20] of cardinal;
 namasce:boolean;
 n,nx:integer;
begin
if not trzeba_zostawiac then exit;
if kfg.krew_mieso_zostawia_slady then begin
    obr.teren.surf.Lock(0, LRect);
    namasce:=boolean(random(2));
    for a:=0 to max_mieso do
      if (mieso[a].zostaw) and (not mieso[a].jest) then with mieso[a] do begin
         if team>=-1 then begin {mieso}

            druzyna[team].mieso[rodz].surf.Lock(0, lrectr);
            if obrot>=druzyna[team].mieso[rodz].klatek then obrot:=obrot-druzyna[team].mieso[rodz].klatek;

            n:=trunc(obrot);
            nx:=druzyna[team].mieso[rodz].surf.ImagesPerWidth;

            for py:=0 to druzyna[team].mieso[rodz].ry-1 do
               for px:=0 to druzyna[team].mieso[rodz].rx-1 do begin
                   px1:=px+trunc(x-druzyna[team].mieso[rodz].ofsx);
                   py1:=py+trunc(y-druzyna[team].mieso[rodz].ofsy);

                   if (px1>=0) and (px1<=teren.width-1) and
                      (py1>=0) and (py1<=teren.height-1) then begin
{
                      srcPtr:= Pointer( Integer(LRectr.Bits) +
                               (LRectr.Pitch * ((druzyna[team].mieso[rodz].ry*trunc(obrot)) +py)) +
                               (px * druzyna[team].mieso[rodz].surf.BytesPerPixel));
}
                      srcPtr:=Pointer(
                               Integer(LRectr.Bits) +
                               (LRectr.Pitch * ((druzyna[team].mieso[rodz].ry * (n div nx) ) + py)) +
                               (druzyna[team].mieso[rodz].rx * (n mod nx)) * druzyna[team].mieso[rodz].surf.BytesPerPixel +
                               (px * druzyna[team].mieso[rodz].surf.BytesPerPixel)
                              );
                      pdrawFormatConv(SrcPtr, @getvalu, druzyna[team].mieso[rodz].surf.Format, D3DFMT_A8R8G8B8);

                      if (getvalu and $FF000000>$40000000) then begin
                         getvalu:=(getvalu or $FF000000);

                         if (getvalu and $FF)           >(kolor and $FF0000) shr 16 then getvalu:=(getvalu and $FFFFFF00) or ((kolor and $FF0000) shr 16);
                         if (getvalu and $FF00)         >(kolor and $FF00)          then getvalu:=(getvalu and $FFFF00FF) or (kolor and $FF00);
                         if (getvalu and $FF0000) shr 16>(kolor and $FF)            then getvalu:=(getvalu and $FF00FFFF) or ((kolor and $FF) shl 16);

                         DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * py1) + (px1 * obr.teren.surf.BytesPerPixel));
                         pdrawFormatConv(@getValu, DestPtr, D3DFMT_A8R8G8B8, obr.teren.surf.Format);

                         if namasce and
                            (teren.maska[px1,py1]=0) and
                            (px>=1) and (py>=1) and (px<=druzyna[team].mieso[rodz].ry-2) and (py<=druzyna[team].mieso[rodz].ry-2) then
                            teren.maska[px1,py1]:=1;
                      end;
                   end;
               end;
            zostaw:=false;
            druzyna[team].mieso[rodz].surf.unLock(0);
         end else begin {smieci}
            obr.smieci[rodz].surf.Lock(0, lrectr);
            while obrot>=obr.smieci[rodz].klatek do obrot:=obrot-obr.smieci[rodz].klatek;
            while obrot<0 do obrot:=obrot+obr.smieci[rodz].klatek;

            n:=trunc(obrot);
            nx:=obr.smieci[rodz].surf.ImagesPerWidth;

            for py:=0 to obr.smieci[rodz].ry-1 do
               for px:=0 to obr.smieci[rodz].rx-1 do begin
                   px1:=px+trunc(x-obr.smieci[rodz].ofsx);
                   py1:=py+trunc(y-obr.smieci[rodz].ofsy);

                   if (px1>=0) and (px1<=teren.width-1) and
                      (py1>=0) and (py1<=teren.height-1) then begin

{                      srcPtr:= Pointer( Integer(LRectr.Bits) +
                               (LRectr.Pitch * ((obr.smieci[rodz].ry*trunc(obrot)) +py)) +
                               (px * obr.smieci[rodz].surf.BytesPerPixel));}

                      srcPtr:=Pointer(
                               Integer(LRectr.Bits) +
                               (LRectr.Pitch * ((obr.smieci[rodz].ry * (n div nx) ) + py)) +
                               (obr.smieci[rodz].rx * (n mod nx)) * obr.smieci[rodz].surf.BytesPerPixel +
                               (px * obr.smieci[rodz].surf.BytesPerPixel)
                              );

                      pdrawFormatConv(SrcPtr, @getvalu, obr.smieci[rodz].surf.Format, D3DFMT_A8R8G8B8);

                      if (getvalu and $FF000000>$90000000) then begin
                         getvalu:=(getvalu or $FF000000) and kolor;
                         DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * py1) + (px1 * obr.teren.surf.BytesPerPixel));
                         pdrawFormatConv(@getValu, DestPtr, D3DFMT_A8R8G8B8, obr.teren.surf.Format);

                         if namasce and
                            (teren.maska[px1,py1]=0) and
                            (px>=1) and (py>=1) and (px<=obr.smieci[rodz].ry-2) and (py<=obr.smieci[rodz].ry-2) then
                            teren.maska[px1,py1]:=1;
                      end;
                   end;
               end;
            zostaw:=false;
            obr.smieci[rodz].surf.unLock(0);
         end;
      end else if mieso[a].zostaw then begin mieso[a].zostaw:=false; mieso[a].jest:=false; end;

    obr.teren.surf.unLock(0);
end;
trzeba_zostawiac:=false;
end;


end.
