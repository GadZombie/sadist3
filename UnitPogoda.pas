unit UnitPogoda;

interface
uses Graphics, Types, vars;

var
   dzwieki_pogody:record
      ktory_dzwiek,
      nastepny_dzwiek:integer; {-1: cisza, 0..3: wiatr}
      przejscie:integer; {czas przejscia (zciszanie/zglasnianie) dziekow, liczony od 0 do 100}
      glosnosc, wysokosc, pan: real; {dzwieku, ktory wlasnie gra; przy przejsciu wazniejszy ten nowy}
   end;
   licznikwiatr:real; {leci caly czas, ale nie w czasie pauzy}

    procedure nowydeszcz(sx,sy,dx_,dy_:real; przezr_:smallint;wielkosc_:integer ;rodzaj_,wyglad_:byte);
    procedure ruszaj_deszcz;
    procedure rysuj_deszcz;

    procedure nowachmurka(sx,sy, szybkosc_:real; przezr_:smallint;wielkoscx_,wielkoscy_:integer ;wyglad_,jasnosc_:byte; z_tylu:boolean);
    procedure ruszaj_chmurki;
    procedure rysuj_chmurki(tyl:boolean);

    procedure ruszaj_chmury_deszcz_burze;

    procedure oblicz_kolory_tla;
    procedure zmieniaj_niebo;
    procedure pokaz_niebo;

    procedure graj_dzwieki_pogody;

implementation
uses unit1, d3d9, pdrawex, powertypes, unitefekty, unitwybuchy, unitgraglowna, unitrysowanie;

procedure nowydeszcz(sx,sy,dx_,dy_:real; przezr_:smallint;wielkosc_:integer ;rodzaj_,wyglad_:byte);
var a,b:longint; kk0:real;
begin
a:=0;
b:=0;
while (b<max_deszcz) and (deszcz[a].jest) do begin
   inc(a);
   inc(b);
   if a>=max_deszcz then a:=0;
end;
if b>=max_deszcz then exit;
//   a:=random(max_deszcz);
{if not deszcz[a].jest then }
with deszcz[a] do begin
   x:=sx;
   y:=sy;
   dx:=dx_;
   dy:=dy_;
   jest:=true;
   if wielkosc_=0 then begin
      wielkosc:=256;
   end else
       wielkosc:=wielkosc_;
   przezr:=byte(przezr_);
   wyglad:=wyglad_;
   rodzaj:=rodzaj_;

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
   kat:=trunc( (kk0/(pi180))/1.40625 )+128;
end;

end;

procedure ruszaj_deszcz;
var a:longint;
begin
for a:=0 to max_deszcz do
  if deszcz[a].jest then with deszcz[a] do begin
     if rodzaj=0 then begin
        x:=x+dx;
        y:=y+dy;
     end else begin
        x:=x+dx-1+random*2;
        y:=y+dy-1+random*2;
        if (abs(dx)>0.1) then begin
           dy:=dy+ ((random*dx)-dx/2)/10;
           if (dy>abs(dx)*2) then dy:=abs(dx)*2;
           if (dy<-abs(dx)*2) then dy:=-abs(dx)*2;
        end;
     end;

    if (warunki.typ_wody>=1) and (y>=warunki.wys_wody) then jest:=false;
    if ((x<-128) and (dx<=0)) or
       ((x>teren.width+128) and (dx>=0)) then jest:=false;
    if //(y>teren.height+100) or
       (y>ekran.height+ekran.py) then jest:=false;

  end;

end;


procedure rysuj_deszcz;
var a:longint; nx,ny:integer;
begin
if not niebo.widdeszsnie then exit;
for a:=0 to max_deszcz do
  if deszcz[a].jest then with deszcz[a] do begin

     nx:=trunc(x)-ekran.px;
     ny:=trunc(y)-ekran.py;

     if (nx+obr.deszcz[rodzaj].rx>=0) and (ny+obr.deszcz[rodzaj].ry>=0) and
        (nx-obr.deszcz[rodzaj].rx<ekran.width) and (ny-obr.deszcz[rodzaj].ry<ekran.height) then
         form1.PowerDraw1.TextureMap(
                   obr.deszcz[rodzaj].surf,
                   pRotate4sc(nx,
                              ny,
                              obr.deszcz[rodzaj].rx,
                              obr.deszcz[rodzaj].ry,
                              kat,
                              wielkosc),
                   ccolor1(cardinal((przezr shl 24) or $FFFFFF)),
                   tPattern(wyglad),
                   effectSrcAlpha or effectDiffuse);

end;
end;

{------chmurki--------}


procedure nowachmurka(sx,sy, szybkosc_:real; przezr_:smallint;wielkoscx_,wielkoscy_:integer ;wyglad_,jasnosc_:byte; z_tylu:boolean);
var a,b:longint;
begin
if niebo.ile_jest_chmur>warunki.iloscchmur then exit;
a:=0;
b:=0;
while (b<max_chmurki) and (chmurka[a].jest) do begin
   inc(a);
   inc(b);
   if a>=max_chmurki then a:=0;
end;
if b>warunki.iloscchmur then exit;

with chmurka[a] do begin
   x:=sx;
   y:=sy;
   szybkosc:=szybkosc_;
   jest:=true;
   wielkoscx:=wielkoscx_;
   wielkoscy:=wielkoscy_;
   ciemnosc:=(255-jasnosc_)/255;
   kolor:=byte(przezr_) shl 24+
          jasnosc_ shl 16+
          jasnosc_ shl 8+
          jasnosc_;
   wyglad:=wyglad_;
   ztylu:=z_tylu;
   odbita:=boolean(random(2));
end;

end;

procedure ruszaj_chmurki;
var a:longint; r:real;
begin
niebo.ile_jest_chmur:=0;
niebo.ile_jest_chmur_widocznych:=0;
for a:=0 to max_chmurki do
  if chmurka[a].jest then with chmurka[a] do begin
    inc(niebo.ile_jest_chmur);

    if (x>=-wielkoscx div 2) and (x<=teren.width-wielkoscx div 2) then begin
       niebo.ile_jest_chmur_widocznych:=niebo.ile_jest_chmur_widocznych+ ciemnosc*((wielkoscx/200)*(wielkoscy/150));
    end;

    r:=warunki.wiatr;
    if abs(r)<0.1 then begin
       if r>=0 then r:=0.1
               else r:=-0.1;
    end;
    x:=x+r*szybkosc;

    if ((x<-wielkoscx) and (warunki.wiatr<=0)) or
       ((x>teren.width+wielkoscx) and (warunki.wiatr>=0)) then jest:=false;
    if (y>teren.height) or (y<-wielkoscy) then jest:=false;

  end;

end;


procedure rysuj_chmurki(tyl:boolean);
var a,nx,ny:longint;
begin
if not niebo.widchmu then exit;
for a:=0 to max_chmurki do
  if (chmurka[a].jest) and (chmurka[a].ztylu=tyl) then
     with chmurka[a] do begin
        nx:=trunc(x)-ekran.px;
        if ztylu then ny:=trunc(y)-ekran.py div 2
                 else ny:=trunc(y)-ekran.py;

        if (nx+wielkoscx>=0) and (ny+wielkoscy>=0) and
           (nx-wielkoscx<ekran.width) and (ny-wielkoscy<ekran.height) then begin
           if not odbita then
            form1.PowerDraw1.TextureMap(
                       obr.chmurka.surf,
                       pPoint4( {nx, ny,
                                nx+wielkoscx, ny,
                                nx+wielkoscx, ny+wielkoscy,
                                nx, ny+wielkoscy}
                                round( nx          -((niebo.tloheight-y) /40)*abs(wielkoscx)/40 +((x-niebo.tlowidth div 2) / 20)*abs(wielkoscx)/40 ),
                                  ny,
                                round( nx+wielkoscx+((niebo.tloheight-y) /40)*abs(wielkoscx)/40 +((x-niebo.tlowidth div 2) / 20)*abs(wielkoscx)/40 ),
                                  ny,
                                nx+wielkoscx,
                                  ny+wielkoscy,
                                nx,
                                  ny+wielkoscy
                              ),

                       ccolor1(kolor),
                       tPattern(wyglad),
                       effectSrcAlpha or effectDiffuse)
           else
            form1.PowerDraw1.TextureMap(
                       obr.chmurka.surf,
                       pPoint4(
                                round( nx+wielkoscx+((niebo.tloheight-y) /40)*abs(wielkoscx)/40 +((x-niebo.tlowidth div 2) / 20)*abs(wielkoscx)/40 ),
                                  ny,
                                round( nx          -((niebo.tloheight-y) /40)*abs(wielkoscx)/40 +((x-niebo.tlowidth div 2) / 20)*abs(wielkoscx)/40 ),
                                  ny,
                                nx,
                                  ny+wielkoscy,
                                nx+wielkoscx,
                                  ny+wielkoscy
                              ),

                       ccolor1(kolor),
                       tPattern(wyglad),
                       effectSrcAlpha or effectDiffuse);
        end;

     end;
end;


procedure ruszaj_chmury_deszcz_burze;
var b,zx,zy,rx,ry,jasn,rodz:integer; r,sz:real; tyl:boolean;
begin
{snieg i deszcz}
if warunki.deszcz or warunki.snieg then begin
   ruszaj_deszcz;

    if warunki.deszcz then begin
       if warunki.snieg then zx:=random(2)
                        else zx:=0;
    end else
        zx:=1;

    if zx=0 then begin
       r:=5+random*10;
       b:=round(warunki.wiatr*10)
    end else begin
        r:=2+random*5;
        b:=round(warunki.wiatr*15);
    end;
    nowydeszcz(random(ekran.width+abs(b)*60)-b*60+ekran.px, //random(teren.width+abs(b)*60)-b*60,
               -obr.deszcz[0].ry+ekran.py,
               (random*b)+b*2,
               r+random*(10-zx*8.5)-zx,
               trunc(170-r*7+random(70)+zx*40),
               trunc(70+r*13+random(50)),
               zx,0);
end;
if not kfg.calkiem_bez_dzwiekow then begin
    if warunki.deszcz and not dzwieki_ciagle.deszcz and kfg.jest_dzwiek then begin
       form1.dzw_rozne.Item[6].Play;
       dzwieki_ciagle.deszcz:=true;
    end else
    if not warunki.deszcz and dzwieki_ciagle.deszcz then begin
       form1.dzw_rozne.Item[6].Stop;
       dzwieki_ciagle.deszcz:=false;
    end;
end;

{chmurki}
if warunki.chmurki then begin
   ry:=0; rx:=0; zy:=0; tyl:=false;
   jasn:=0; rodz:=0; sz:=0;
   ruszaj_chmurki;
   if random(65-round(abs(warunki.wiatr)*100))=0 then begin
      case warunki.jakiechmury of
       0:begin {czarne}
          tyl:=random(3)>=1;
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

      if warunki.wiatr>=0 then zx:=-rx-2
                         else zx:=teren.width+rx+2;

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

{burza}
if warunki.burza then begin
   if (bron.piorun_dostrzalu<=5) and (random(warunki.silaburzy)=0) then begin
      bron.piorun_dostrzalu:=30;
      piorun(random(teren.width),0,random(120)+120,20+random(40));
   end else
       if (bron.piorun_dostrzalu>=23) and (random(10)=0) then
          bron.piorun_dostrzalu:=30;

   if (random(warunki.silaburzy)=0) then begin
      if random(2)=0 then begin
         nowywybuchdym(random(teren.width+200)-100,-100+random(150),random*20-10,random*20-10,0,wd_swiatlo,0,50,700,$FF7000+random(120) shl 8+random(100));
         niebo.blyskjasnosc:=40+random(100);
         niebo.blysk:=niebo.blyskjasnosc;
         niebo.blyskkrotnosc:=random(5);
         niebo.blyskszybkosc:=17-niebo.blyskkrotnosc*3 + random(4);
      end;
      if not kfg.calkiem_bez_dzwiekow and kfg.jest_dzwiek then begin
          b:=7+random(3);
          form1.dzw_rozne.Item[b].xpos:=-2+random*4;
          form1.dzw_rozne.Item[b].ypos:=-1;
          form1.dzw_rozne.Item[b].gain:=(random(kfg.glosnosc div 2)+kfg.glosnosc div 2)/100;
          form1.dzw_rozne.Item[b].pitch:=0.3+random/2;
          form1.dzw_rozne.Item[b].Play;
      end;
   end;
end;

if niebo.blysk>0 then begin
   dec(niebo.blysk,niebo.blyskszybkosc);
   if niebo.blysk<0 then begin
      dec(niebo.blyskkrotnosc);
      if niebo.blyskkrotnosc>=0 then
         niebo.blysk:=niebo.blyskjasnosc
      else niebo.blysk:=0;
   end;
end;
end;

procedure oblicz_kolory_tla;
var a,krok, nastepny:integer;
begin
a:=warunki.godzina div 100;
krok:=warunki.godzina - niebo.kolorytla[a].bierzdanez*100;

nastepny:= (niebo.kolorytla[a].bierzdanez + niebo.kolorytla[a].dlugosc) mod 24;

with niebo do begin
  if (kolorytla[a].dlugosc<24) then begin
     kolorytlag:= $FF000000+
                  (kolorytla[kolorytla[a].bierzdanez].gb + trunc( ((kolorytla[nastepny].gb-kolorytla[kolorytla[a].bierzdanez].gb)/(kolorytla[kolorytla[a].bierzdanez].dlugosc*100))*krok) ) shl 16+
                  (kolorytla[kolorytla[a].bierzdanez].gg + trunc( ((kolorytla[nastepny].gg-kolorytla[kolorytla[a].bierzdanez].gg)/(kolorytla[kolorytla[a].bierzdanez].dlugosc*100))*krok) ) shl  8+
                  (kolorytla[kolorytla[a].bierzdanez].gr + trunc( ((kolorytla[nastepny].gr-kolorytla[kolorytla[a].bierzdanez].gr)/(kolorytla[kolorytla[a].bierzdanez].dlugosc*100))*krok) )
                  ;
     kolorytlad:= $FF000000+
                  (kolorytla[kolorytla[a].bierzdanez].db + trunc( ((kolorytla[nastepny].db-kolorytla[kolorytla[a].bierzdanez].db)/(kolorytla[kolorytla[a].bierzdanez].dlugosc*100))*krok) ) shl 16+
                  (kolorytla[kolorytla[a].bierzdanez].dg + trunc( ((kolorytla[nastepny].dg-kolorytla[kolorytla[a].bierzdanez].dg)/(kolorytla[kolorytla[a].bierzdanez].dlugosc*100))*krok) ) shl  8+
                  (kolorytla[kolorytla[a].bierzdanez].dr + trunc( ((kolorytla[nastepny].dr-kolorytla[kolorytla[a].bierzdanez].dr)/(kolorytla[kolorytla[a].bierzdanez].dlugosc*100))*krok) )
                  ;
  end else begin
     kolorytlag:=$FF000000+
                       kolorytla[0].gb shl 16+
                       kolorytla[0].gg shl 8+
                       kolorytla[0].gr;
     kolorytlad:=$FF000000+
                       kolorytla[0].db shl 16+
                       kolorytla[0].dg shl 8+
                       kolorytla[0].dr;
  end;
end;

end;

procedure zmieniaj_niebo;
const ile=130;
var r1,r2,g1,g2,b1,b2:byte;
begin
   oblicz_kolory_tla;

   with niebo do begin
     if (niebo.ile_jest_chmur>=1) or warunki.deszcz or warunki.snieg then begin
        pog:=1-niebo.ile_jest_chmur_widocznych/(max_chmurki*1.5)-ord(warunki.deszcz or warunki.snieg)*0.08;
        if pog<0.02 then pog:=0.02;
        if pog>1 then pog:=1;
        pog2:=1-niebo.ile_jest_chmur_widocznych/(max_chmurki*1.8)-ord(warunki.deszcz or warunki.snieg)*0.08;
        if pog2<0.02 then pog2:=0.02;
        if pog2>1 then pog2:=1;

        if pog_widac<pog then begin
           pog_widac:=pog_widac+0.005;
           if pog_widac>pog then pog_widac:=pog;
        end else
        if pog_widac>pog then begin
           pog_widac:=pog_widac-0.005;
           if pog_widac<pog then pog_widac:=pog;
        end;
        if pog2_widac<pog2 then begin
           pog2_widac:=pog2_widac+0.005;
           if pog2_widac>pog2 then pog2_widac:=pog2;
        end else
        if pog2_widac>pog2 then begin
           pog2_widac:=pog2_widac-0.005;
           if pog2_widac<pog2 then pog2_widac:=pog2;
        end;

        niebo.kolorytlag:= round( (niebo.kolorytlag and $FF    )        *pog_widac)        +
                           round(((niebo.kolorytlag and $FF00  ) shr 8 )*pog_widac)  shl 8 +
                           round(((niebo.kolorytlag and $FF0000) shr 16)*pog2_widac) shl 16;

        niebo.kolorytlad:= round( (niebo.kolorytlad and $FF    )        *pog_widac)        +
                           round(((niebo.kolorytlad and $FF00  ) shr 8 )*pog_widac)  shl 8 +
                           round(((niebo.kolorytlad and $FF0000) shr 16)*pog2_widac) shl 16;

        niebo.jasnosc_nieba:=round(niebo.ile_jest_chmur_widocznych*5)+ord(warunki.deszcz or warunki.snieg)*50;

     end else
         niebo.jasnosc_nieba:=0;
   end;

   if warunki.deszcz or warunki.snieg then niebo.jasnosc_nieba:=niebo.jasnosc_nieba+20;

   if niebo.jasnosc_nieba>255 then niebo.jasnosc_nieba:=255;
   if niebo.jasnosc_nieba<0 then niebo.jasnosc_nieba:=0;

   with niebo do begin
      rampr:= ( integer(kolorytlad and $000000FF)        - integer(kolorytlag and $000000FF)        )/tlo_grad_il;
      rampg:= ( integer(kolorytlad and $0000FF00) shr 8  - integer(kolorytlag and $0000FF00) shr 8  )/tlo_grad_il;
      rampb:= ( integer(kolorytlad and $00FF0000) shr 16 - integer(kolorytlag and $00FF0000) shr 16 )/tlo_grad_il;

      if jasnosc_nieba_widac<jasnosc_nieba then begin
         inc(jasnosc_nieba_widac,4);
         if jasnosc_nieba_widac>jasnosc_nieba then jasnosc_nieba_widac:=jasnosc_nieba;
      end else
      if jasnosc_nieba_widac>jasnosc_nieba then begin
         dec(jasnosc_nieba_widac,4);
         if jasnosc_nieba_widac<jasnosc_nieba then jasnosc_nieba_widac:=jasnosc_nieba;
      end;


      r1:= kolorytlag and $000000FF;
      g1:= (kolorytlag and $0000FF00) shr 8;
      b1:= (kolorytlag and $00FF0000) shr 16;
      r2:= kolorytlad and $000000FF;
      g2:= (kolorytlad and $0000FF00) shr 8;
      b2:= (kolorytlad and $00FF0000) shr 16;

      if (r1+ile)>255 then r1:=255 else inc(r1,ile);
      if (g1+ile)>255 then g1:=255 else inc(g1,ile);
      if (b1+ile)>255 then b1:=255 else inc(b1,ile);
      if (r2+ile)>255 then r2:=255 else inc(r2,ile);
      if (g2+ile)>255 then g2:=255 else inc(g2,ile);
      if (b2+ile)>255 then b2:=255 else inc(b2,ile);

      kolorterenu:= cardinal( $FF000000+
                ((r1+r2) shr 1) +
                ((g1+g2) shr 1) shl 8+
                ((b1+b2) shr 1) shl 16);

   end;

end;

procedure pokaz_niebo;
var
a,b:integer;
tr:trect;
c,jas:cardinal;
prz:smallint;
px,py:real;
d:byte;
knr,kng,knb:integer;

{ LRect: TD3DLocked_Rect;
 DestPtr:Pointer;
 getvalu:cardinal;
 g:cardinal;    }
 sx,sy: integer;

begin
 b:=0;
 a:=0;
 px:=ekran.px*teren.tlododx;
 py:=ekran.py*teren.tlodody;
 jas:=cardinal( (niebo.jasnosc_nieba_widac shl 24) );
 while b<niebo.tloheight do begin
     tr.Left:=0;
     tr.top:=b-trunc(py);
     tr.Right:=ekran.width;
     tr.Bottom:=b+niebo.tlo_grad_skok-trunc(py);

     knr:=(niebo.kolorytlag and $FF) + trunc(a*niebo.rampr+niebo.blysk);
     if knr>255 then knr:=255;
     if knr<0 then knr:=0;
     kng:=(niebo.kolorytlag and $FF00) shr 8 + trunc(a*niebo.rampg+niebo.blysk);
     if kng>255 then kng:=255;
     if kng<0 then kng:=0;
     knb:=(niebo.kolorytlag and $FF0000) shr 16 + trunc(a*niebo.rampb+niebo.blysk);
     if knb>255 then knb:=255;
     if knb<0 then knb:=0;

     c:=cardinal(
        (knb shl 16) +
        (kng shl 8) +
         knr );
     form1.PowerDraw1.FillRect(tr,c,0);
     inc(b,niebo.tlo_grad_skok);
     inc(a);
 end;

 if (niebo.widgwia) and
    ((warunki.godzina<900) or (warunki.godzina>1900)) then
     for a:=0 to high(niebo.gwiazdy) do
         if (niebo.gwiazdy[a].x-obr.gwiazda.ofsx-px>=-obr.gwiazda.ofsx) and
            (niebo.gwiazdy[a].x-obr.gwiazda.ofsx-px<=ekran.width+obr.gwiazda.ofsx) and
            (niebo.gwiazdy[a].y-obr.gwiazda.ofsy-py>=-obr.gwiazda.ofsy) and
            (niebo.gwiazdy[a].y-obr.gwiazda.ofsy-py<=ekran.height+obr.gwiazda.ofsy)
         then begin
             prz:=niebo.gwiazdy[a].przezr;
             if (warunki.godzina>=400) and (warunki.godzina<900) then prz:=prz-(warunki.godzina-400) div 2+((ekran.height-niebo.gwiazdy[a].y) div 20)
             else
             if warunki.godzina>1900 then prz:=prz-(2400-warunki.godzina) div 2+((ekran.height-niebo.gwiazdy[a].y) div 20);
             prz:=prz+random(61)-30-niebo.jasnosc_nieba_widac;
             if prz>255 then prz:=255;
             if prz>=0 then
                Form1.PowerDraw1.RenderEffectCol(obr.gwiazda.surf,
                              trunc(niebo.gwiazdy[a].x-obr.gwiazda.ofsx-px),
                              trunc(niebo.gwiazdy[a].y-obr.gwiazda.ofsy-py),
                              niebo.gwiazdy[a].wielk,
                              cardinal((prz shl 24) or $FFFFFF),
                              0,
                              effectSrcAlpha or effectDiffuse);
         end;

 // form1.drawsprajt(obr.slonce,trunc(niebo.slonce.x-obr.slonce.ofsx-px),trunc(niebo.slonce.y-obr.slonce.ofsy-py),0);
 if (niebo.widslon) then begin
     if (niebo.slonce.x>niebo.tlowidth shr 1) and (niebo.slonce.y>=niebo.tloheight-255) then begin
        a:=niebo.tloheight-trunc(niebo.slonce.y+255) div 2;
        if a<0 then a:=0;
        if a>255 then a:=255;
        d:=a;
        c:=$FFFF00FF or (d shl 8) - jas;
     end else
         c:=$FFFFFFFF- jas;

     form1.PowerDraw1.RenderEffectCol(obr.slonce.surf,trunc(niebo.slonce.x-obr.slonce.ofsx-px),trunc(niebo.slonce.y-obr.slonce.ofsy-py),c,0,effectSrcAlpha or effectDiffuse);
     if (kfg.efekty_soczewki) and
        (niebo.slonce.x-px>=0) and (niebo.slonce.x-px<ekran.width) and
        (niebo.slonce.y-py>=0) and (niebo.slonce.y-py<ekran.height-ekran.menux) then begin

        //obr.teren.surf.Lock(0, LRect);

        sx:=trunc(niebo.slonce.x-px)+ekran.px-ekran.trzesx;
        sy:=trunc(niebo.slonce.y-py)+ekran.py-ekran.trzesy;

        if (sx>=0) and (sx<=high(teren.maska)) and
           (sy>=0) and (sy<=high(teren.maska[0])) then begin

        {DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * sy) + (sx * obr.teren.surf.BytesPerPixel));
        pdrawFormatConv(DestPtr, @g, obr.teren.surf.Format,D3DFMT_A8R8G8B8);}

        //obr.teren.surf.unLock(0);

        {if (g and $FF000000=$00) then}
          if (teren.maska[sx][sy]=0) then begin


              form1.PowerDraw1.TextureMap(obr.wybuchdym[wd_swiatlo,0].surf,
                pRotate4(trunc(niebo.slonce.x-px),trunc(niebo.slonce.y-py),
                         120,
                         120,
                         60,
                         60,
                         trunc(niebo.slonce.x-ekran.px+niebo.slonce.y-ekran.py) div 2
                         ),
                         cColor1((c and $008FeFFF) or $80000000),
                         tPattern(0),
                         effectSrcAlpha or effectDiffuse or effectadd);

             nowa_flara(trunc(niebo.slonce.x-px),trunc(niebo.slonce.y-py), 150, (c and $008FeFFF) or $80000000);
          end;
        end;
     end;
 end;

 if (niebo.winksie) then begin
     if (warunki.godzina>=1850) and (warunki.godzina<=2150) then prz:=(warunki.godzina-1850) div 3+155
        else
     if (warunki.godzina>=500) and (warunki.godzina<=900) then prz:=(900-warunki.godzina) div 2+55
        else prz:=255;
     prz:=prz-niebo.jasnosc_nieba_widac;
     if prz>255 then prz:=255;
     if prz>0 then begin
        form1.PowerDraw1.RenderEffectCol(
              obr.ksiezyc.surf,
              trunc(niebo.ksiezyc.x-obr.ksiezyc.ofsx-px),
              trunc(niebo.ksiezyc.y-obr.ksiezyc.ofsy-py),
              cardinal((prz shl 24) or $00FFFFFF),
              0,
              effectsrcalpha or effectdiffuse);

         if (kfg.efekty_soczewki) and
            (niebo.ksiezyc.x-px>=0) and (niebo.ksiezyc.x-px<ekran.width) and
            (niebo.ksiezyc.y-py>=0) and (niebo.ksiezyc.y-py<ekran.height-ekran.menux) then begin

            sx:=trunc(niebo.ksiezyc.x-px)+ekran.px-ekran.trzesx;
            sy:=trunc(niebo.ksiezyc.y-py)+ekran.py-ekran.trzesy;

            if (sx>=0) and (sx<=high(teren.maska)) and
               (sy>=0) and (sy<=high(teren.maska[0])) then begin
              if (teren.maska[sx][sy]=0) then begin
                prz:=prz div 2; //dzielimy przezroczystosc na 2, zeby poswiata byla o polowe ciemniejsza
                form1.PowerDraw1.TextureMap(obr.wybuchdym[wd_swiatlo,0].surf,
                  pRotate4(trunc(niebo.ksiezyc.x-px),trunc(niebo.ksiezyc.y-py),
                           90,
                           90,
                           45,
                           45,
                           trunc(niebo.ksiezyc.x-ekran.px+niebo.ksiezyc.y-ekran.py) div 2
                           ),
                           cColor1((prz shl 24) or $00FFFFFF),
                           tPattern(0),
                           effectSrcAlpha or effectDiffuse or effectadd);
                prz:=prz div 2; //i znowu na dwa, zeby flara byla jeszcze ciemniejsza
                nowa_flara(trunc(niebo.ksiezyc.x-px),trunc(niebo.ksiezyc.y-py), 110, (prz shl 24) or $00FFFFFF);
              end;
            end;
         end;

     end;
 end;

end;


procedure graj_dzwieki_pogody;
var
w,r:integer;
g:real;
begin
if not kfg.calkiem_bez_dzwiekow then begin
    if not warunki.pauza then licznikwiatr:=licznikwiatr+0.006;

    dzwieki_pogody.glosnosc:=0.35+abs(warunki.wiatr)*1.3 + sin(licznikwiatr)*cos(licznikwiatr/4.372)*0.3;
    if dzwieki_pogody.glosnosc<0 then dzwieki_pogody.glosnosc:=0;
    if dzwieki_pogody.glosnosc>2 then dzwieki_pogody.glosnosc:=2;

    dzwieki_pogody.pan:=-warunki.wiatr*0.5 + listenerpos[0] + sin(licznikwiatr/3.4)*cos(licznikwiatr/1.472)*0.3;

    if dzwieki_pogody.przejscie=0 then begin
        w:=round(abs(warunki.wiatr)*200);
        case w of
           0..3:   r:=-1;
           4..25:  begin r:=0; dzwieki_pogody.wysokosc:=0.9+w/100; end;
           26..50: begin r:=1; dzwieki_pogody.wysokosc:=0.9+(w-26)/100; end;
           51..75: begin r:=2; dzwieki_pogody.wysokosc:=0.9+(w-51)/100; end;
           else    begin r:=3; dzwieki_pogody.wysokosc:=0.9+(w-76)/100; end;
        end;

        dzwieki_pogody.wysokosc:=dzwieki_pogody.wysokosc + cos(licznikwiatr*1.23)*cos(licznikwiatr/6.312)*0.2;
        if dzwieki_pogody.wysokosc<0 then dzwieki_pogody.wysokosc:=0;
    //    if dzwieki_pogody.wysokosc>1 then dzwieki_pogody.wysokosc:=1;

        if (dzwieki_pogody.ktory_dzwiek>=0) and (not form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].playing) then
           form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].Play;

        if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain<>dzwieki_pogody.glosnosc then begin
           if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain<dzwieki_pogody.glosnosc then begin
              form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain:=form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain+0.02;
              if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain>dzwieki_pogody.glosnosc then
                 form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain:=dzwieki_pogody.glosnosc;
           end else
           if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain>dzwieki_pogody.glosnosc then begin
              form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain:=form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain-0.02;
              if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain<dzwieki_pogody.glosnosc then
                 form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain:=dzwieki_pogody.glosnosc;
           end;
           form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].Update;
        end;

        if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].pitch<>dzwieki_pogody.wysokosc then begin
           if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].pitch<dzwieki_pogody.wysokosc then begin
              form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].pitch:=form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].pitch+0.02;
              if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].pitch>dzwieki_pogody.wysokosc then
                 form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].pitch:=dzwieki_pogody.wysokosc;
           end else
           if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].pitch>dzwieki_pogody.wysokosc then begin
              form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].pitch:=form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].pitch-0.02;
              if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].pitch<dzwieki_pogody.wysokosc then
                 form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].pitch:=dzwieki_pogody.wysokosc;
           end;
           form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].Update;
        end;

        if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].xpos<>dzwieki_pogody.pan then begin
           form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].xpos:=dzwieki_pogody.pan;
           form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].Update;
        end;


        if dzwieki_pogody.ktory_dzwiek<>r then begin
           dzwieki_pogody.nastepny_dzwiek:=r;
           dzwieki_pogody.przejscie:=1;
        end;

    end else begin
        inc(dzwieki_pogody.przejscie);

        if dzwieki_pogody.ktory_dzwiek>=0 then begin
           g:=1 - dzwieki_pogody.przejscie/200;
           if form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain>g then begin
              form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].gain:=g;
              form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].Update;
           end;
        end;
        if dzwieki_pogody.nastepny_dzwiek>=0 then begin
           g:=dzwieki_pogody.przejscie/200;
           if g>dzwieki_pogody.glosnosc then g:=dzwieki_pogody.glosnosc;

           if not form1.dzw_rozne.Item[13+dzwieki_pogody.nastepny_dzwiek].playing then
              form1.dzw_rozne.Item[13+dzwieki_pogody.nastepny_dzwiek].Play;

           if form1.dzw_rozne.Item[13+dzwieki_pogody.nastepny_dzwiek].gain<g then begin
              form1.dzw_rozne.Item[13+dzwieki_pogody.nastepny_dzwiek].gain:=g;
              form1.dzw_rozne.Item[13+dzwieki_pogody.nastepny_dzwiek].Update;
           end;
        end;

        if dzwieki_pogody.przejscie>=200 then begin
           if dzwieki_pogody.ktory_dzwiek>=0 then
              form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].Stop;
           dzwieki_pogody.przejscie:=0;
           dzwieki_pogody.ktory_dzwiek:=dzwieki_pogody.nastepny_dzwiek;
        end;

    end;

    if dzwieki_pogody.ktory_dzwiek>=0 then begin
       form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].xpos:=listenerpos[0];
       form1.dzw_rozne.Item[13+dzwieki_pogody.ktory_dzwiek].ypos:=listenerpos[1];
    end;
end;

end;


end.
