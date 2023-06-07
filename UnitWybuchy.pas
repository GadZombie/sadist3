unit Unitwybuchy;

interface
uses Graphics, Types, vars;
const
wd_wybuch=0;
wd_dym=1;
wd_odblask=2;
wd_swiatlo=3;
wd_krew=4;

    procedure nowywybuchdym(sx,sy,dx_,dy_:real; rod,gatun:byte;sz:byte; przezr:smallint;wielkosc_:integer=0;kolor_:tcolor=$00FFFF; wiatr_:boolean=true; odklatki:integer=0);
    procedure ruszaj_wybuchydymy;
    procedure rysuj_wybuchydymy;

    procedure dodaj_swiatlo_param(x,y:integer; kolor_:cardinal; typ_: byte; wielkosc_,kat_:word; efekt_:byte; zniszczalne_,ztylu_:boolean);
    procedure dodaj_swiatlo(x,y:integer);
    procedure usun_swiatlo(n:integer);
    procedure dzialaj_swiatla;
    procedure pokazuj_swiatla(czyztylu:boolean);

    procedure nowa_flara(x_,y_:integer; wlk: word; kolr: cardinal);
    procedure rysuj_flary;

implementation
uses unit1, powertypes, unitbomble, unitmenusy, unitrysowanie, UnitGraGlowna;
const
wyb_ilosciklatek:array[0..4,0..5] of byte=
{wybuchy}((26,26,26,30,30,35),
{dymy}    (25,25,30,36,0,0),
{odblaski}(5,7,0,0,0,0),
{swiatla} (10,0,0,0,0,0),
{krew/zie}(28,0,0,0,0,0)
          );

procedure nowywybuchdym(sx,sy,dx_,dy_:real; rod,gatun:byte;sz:byte; przezr:smallint;wielkosc_:integer;kolor_:tcolor; wiatr_:boolean; odklatki:integer);
var a,b:longint;
begin
if (kfg.detale<5) and (random(1+kfg.detale)=0) then exit;

a:=wybuchdym_nowy;
b:=0;
while (b<max_wybuchdym) and (wybuchdym[a].jest) do begin
   inc(a);
   inc(b);
   if a>=max_wybuchdym then a:=0;
end;
if b>=max_wybuchdym then
   a:=random(max_wybuchdym);
{if not wybuchdym[a].jest then }
with wybuchdym[a] do begin
   x:=sx;
   y:=sy;
   dx:=dx_;
   dy:=dy_;
   jest:=true;
   rodz:=rod;
   klatka:=odklatki;
   szyb:=sz;
   dosz:=0;
   gatunek:=gatun;
   if wielkosc_=0 then begin
      wielkosc:=256;//obr.wybuchdym[gatunek,rodz].rx;
   end else
       wielkosc:=wielkosc_;
   przezroczysty:=przezr;
   kat:=random(256);
   kolor:=kolor_;
   if (gatunek in [0..2]) and (kolor_=$00FFFF) then kolor:=$FFFFFF;
   wiatr:=wiatr_;
end;

end;

procedure ruszaj_wybuchydymy;
var a:longint;
begin
for a:=0 to max_wybuchdym do
  if wybuchdym[a].jest then with wybuchdym[a] do begin
    if (not kfg.odblaski) and (gatunek>=2) then jest:=false;
    if (not kfg.wybuchydymy) and (gatunek<=1) then jest:=false;
    x:=x+dx;
    y:=y+dy;

    if gatunek=wd_dym then begin
       kat:=kat+round( ((1+random*7)/wielkosc)*110 );
       if kat>=256 then dec(kat,256);
       if wiatr then dx:=dx+warunki.wiatr/8;
       if (trunc(x+dx)>=0)             and (trunc(y+dy)>=0) and
          (trunc(x+dx)<=teren.width-1) and (trunc(y+dy)<=teren.height+30) and
          (teren.maska[trunc(x+dx),trunc(y+dy)]<>0) then
          dy:=-dy/4;

    end else
        if gatunek=wd_krew then begin
           kat:=kat+round( ((1+random*7)/wielkosc)*110 );
           if kat>=256 then dec(kat,256);
           if dy<3 then dy:=dy+warunki.grawitacja*0.04;

           if (trunc(x)>=0)             and (trunc(y)>=0) and
              (trunc(x)<=teren.width-1) and (trunc(y)<=teren.height+30) and
              (teren.maska[trunc(x),trunc(y)]<>0) then
              jest:=false;

        end;

    inc(dosz);
    if dosz>=szyb then begin
       inc(klatka);
       if klatka>=wyb_ilosciklatek[gatunek,rodz] then jest:=false;
       if (przezroczysty=0) and (klatka>=wyb_ilosciklatek[gatunek,rodz] shr 1) then przezroczysty:=240;
       dosz:=0;
    end;
    if (przezroczysty>=25) then begin
       if gatunek=wd_swiatlo then dec(przezroczysty,3)
       else
         case szyb of
            0..1:dec(przezroczysty,3);
            2..3:dec(przezroczysty,2);
            else dec(przezroczysty);
         end;
    end;

    if (warunki.typ_wody in [1,3,4,5]) and (y>=warunki.wys_wody) and
       (((gatunek=0) and (rodz<>4)) or
        (gatunek=1) ) then begin
       if (gatunek=0) and (klatka<=3) and (random(2)=0) then begin
          rodz:=4;
       end else begin
               nowybombel(x,y,0,0,random(150)+155,random(236)+20);
               jest:=false;
               end;
    end else
    if (warunki.typ_wody in [2]) and (y>=warunki.wys_wody) and
       (gatunek=1)  then begin
       jest:=false;
    end;

  end;
//form1.DXDraw1.Surface.Canvas.Release;
end;


procedure rysuj_wybuchydymy;
var a:longint; tr:trect; sx,sy,ef:integer; kol:cardinal; j:integer;
begin
for a:=0 to max_wybuchdym do
  if (wybuchdym[a].jest) and
     ((kfg.odblaski) or (wybuchdym[a].gatunek<=1)) and
     ((kfg.wybuchydymy) or (wybuchdym[a].gatunek>=2))
    then with wybuchdym[a] do begin
     if gatunek<>wd_swiatlo then begin
       {if (kfg.przezroczystosci) and (przezroczysty>0) then
        form1.drawsprajtalpha(obr.wybuchdym[gatunek,rodz],trunc(x-obr.wybuchdym[gatunek,rodz].ofsx)-ekran.px,trunc(y-obr.wybuchdym[gatunek,rodz].ofsy)-ekran.py,klatka,przezroczysty)
       else
        form1.drawsprajt(obr.wybuchdym[gatunek,rodz],trunc(x-obr.wybuchdym[gatunek,rodz].ofsx)-ekran.px,trunc(y-obr.wybuchdym[gatunek,rodz].ofsy)-ekran.py,klatka);}

        sx:= (obr.wybuchdym[gatunek,rodz].surf.PatternWidth * wielkosc) div 256;
        sy:= (obr.wybuchdym[gatunek,rodz].surf.PatternHeight * wielkosc) div 256;

        if przezroczysty>0 then kol:=cardinal((przezroczysty shl 24) or kolor)
           else kol:=kolor or $FF000000;

        if (gatunek=2) then ef:=effectSrcAlpha or effectadd
                     else ef:=effectSrcAlpha or effectdiffuse;
        if (trunc(x+obr.wybuchdym[gatunek,rodz].ofsx)-ekran.px>=0) and
           (trunc(x-obr.wybuchdym[gatunek,rodz].ofsx)-ekran.px<=ekran.width) and
           (trunc(y+obr.wybuchdym[gatunek,rodz].ofsy)-ekran.py>=0) and
           (trunc(y-obr.wybuchdym[gatunek,rodz].ofsy)-ekran.py<=ekran.height) then
           form1.PowerDraw1.TextureMap(obr.wybuchdym[gatunek,rodz].surf,
              pRotate4(trunc(x{-obr.wybuchdym[gatunek,rodz].ofsx})-ekran.px,
                       trunc(y{-obr.wybuchdym[gatunek,rodz].ofsy})-ekran.py,
                       sx,
                       sy,
                       sx div 2,
                       sy div 2,
                       kat),
                       cColor1(kol),
                       tPattern(klatka),
                       ef);

        if (gatunek=wd_wybuch) and (wielkosc>=35) then begin //flara

           j:= trunc( ((15-klatka) * wielkosc/5) / 6 );

           if j>=1 then begin
              if j>90 then j:=90;
              kol:=(j shl 24) or (kol and $00FFFFFF);
              nowa_flara(trunc(x-ekran.px),trunc(y-ekran.py), wielkosc div 3, kol);
           end;
        end;

     end else begin //swiatla

{         tr:=rect( trunc(x-wielkosc div 2-ekran.px),
                   trunc(y-wielkosc div 2-ekran.py),
                   trunc(x+wielkosc div 2-ekran.px),
                   trunc(y+wielkosc div 2-ekran.py));

        if (tr.Right>=0) and
           (tr.Left<=ekran.width) and
           (tr.Bottom>=0) and
           (tr.Top<=ekran.height) then
         form1.PowerDraw1.RenderEffectCol(obr.wybuchdym[gatunek,rodz].surf,
                  tr,
                  cardinal((przezroczysty shl 25) or kolor),
                  0,
                  effectSrcAlpha or effectadd or effectdiffuse);}

{         if (przezroczysty shl 25<0) or (przezroczysty>$7F) then begin
              nowa_flara(trunc(x-ekran.px),trunc(y-ekran.py), wielkosc div 3, kol);
         end;}
         if przezroczysty>$7F then przezroczysty:=$7F;
         if przezroczysty<0 then przezroczysty:=0;

        if (trunc(x+obr.wybuchdym[gatunek,rodz].ofsx)-ekran.px>=0) and
           (trunc(x-obr.wybuchdym[gatunek,rodz].ofsx)-ekran.px<=ekran.width) and
           (trunc(y+obr.wybuchdym[gatunek,rodz].ofsy)-ekran.py>=0) and
           (trunc(y-obr.wybuchdym[gatunek,rodz].ofsy)-ekran.py<=ekran.height) then
           form1.PowerDraw1.TextureMap(obr.wybuchdym[gatunek,rodz].surf,
              pRotate4(trunc(x{-obr.wybuchdym[gatunek,rodz].ofsx})-ekran.px,
                       trunc(y{-obr.wybuchdym[gatunek,rodz].ofsy})-ekran.py,
                       wielkosc,
                       wielkosc,
                       wielkosc div 2,
                       wielkosc div 2,
                       kat+round(klatka*(szyb/2)+dosz)),
                       cColor1(cardinal((przezroczysty shl 25) or kolor)),
                       tPattern(0),
                       effectSrcAlpha or effectadd or effectdiffuse);



         //nowa_flara(trunc(x-ekran.px),trunc(y-ekran.py), wielkosc*3, kol);
     end;
end;
//form1.DXDraw1.Surface.Canvas.Release;
end;

{-------------swiatla----------------------------------------------------------}

procedure dodaj_swiatlo_param(x,y:integer; kolor_:cardinal; typ_: byte; wielkosc_,kat_:word; efekt_:byte; zniszczalne_,ztylu_:boolean);
begin
if (ile_swiatel<max_swiatla) and
   (x>=0) and (y>=0) and
   (x<=teren.width) and (y<=teren.height) then begin
   inc(ile_swiatel);
   swiatla[ile_swiatel].x:=x;
   swiatla[ile_swiatel].y:=y;
   swiatla[ile_swiatel].kolor:= kolor_;
   swiatla[ile_swiatel].typ:=typ_;
   swiatla[ile_swiatel].wielkosc:=wielkosc_;
   swiatla[ile_swiatel].kat:=kat_;
   swiatla[ile_swiatel].efekt:=efekt_;
   swiatla[ile_swiatel].zniszczalne:=zniszczalne_;
   swiatla[ile_swiatel].ztylu:=ztylu_;

   menju.swiatlo_wybrane:=ile_swiatel;
end;

end;

procedure dodaj_swiatlo(x,y:integer);
begin
if ile_swiatel<max_swiatla then begin
   dodaj_swiatlo_param(x,y,
              cardinal(
               (rysmenuuklad[4][1].wartosc shl 24) or
               (rysmenuuklad[4][7].wartosc shl 16) or
               (rysmenuuklad[4][4].wartosc shl 8) or
               rysmenuuklad[4][0].wartosc ),
              rysmenuuklad[4][6].wartosc,
              rysmenuuklad[4][8].wartosc,
              rysmenuuklad[4][5].wartosc,
              rysmenuuklad[4][9].wartosc,
              boolean(rysmenuuklad[4][10].wartosc),
              boolean(rysmenuuklad[4][11].wartosc)
          );

end;

end;

procedure usun_swiatlo(n:integer);
var b:integer;
begin
if (ile_swiatel>0) and (n<=max_swiatla) then begin
   for b:=n to max_swiatla-1 do begin
       swiatla[b].x:=swiatla[b+1].x;
       swiatla[b].y:=swiatla[b+1].y;
       swiatla[b].typ:=swiatla[b+1].typ;
       swiatla[b].wielkosc:=swiatla[b+1].wielkosc;
       swiatla[b].kat:=swiatla[b+1].kat;
       swiatla[b].kolor:=swiatla[b+1].kolor;
       swiatla[b].zniszczalne:=swiatla[b+1].zniszczalne;
       swiatla[b].efekt:=swiatla[b+1].efekt;
   end;
   dec(ile_swiatel);
   if menju.swiatlo_wybrane>ile_swiatel then
      menju.swiatlo_wybrane:=ile_swiatel;
end;

end;

procedure dzialaj_swiatla;
var a:integer;
begin
if bron.glownytryb=5 then bron.glownytryb:=6;
for a:=1 to ile_swiatel do with swiatla[a] do begin
    if (((mysz.x+ekran.px>=x-15) and (mysz.y+ekran.py>=y-15) and
         (mysz.x+ekran.px<=x+15) and (mysz.y+ekran.py<=y+15) and
         (menju.swiatlo_ruszane=0))
         or
         (menju.swiatlo_ruszane=a)
       ) and
       ((mysz.l) or (mysz.r)) then begin
       menju.swiatlo_wybrane:=a;
       if mysz.l then begin
          bron.glownytryb:=5;
          menju.swiatlo_ruszane:=a;
          swiatla[menju.swiatlo_wybrane].x:=mysz.x+ekran.px;
          swiatla[menju.swiatlo_wybrane].y:=mysz.y+ekran.py;
       end;
    end;
end;
if (bron.glownytryb<>5) and (menju.swiatlo_ruszane>=1) then menju.swiatlo_ruszane:=0;
end;

procedure pokazuj_swiatla(czyztylu:boolean);
const
typy:array[0..2,0..1] of byte = ((3,0),(2,0),(2,1));

var a,b:integer; ef:integer;

begin
for a:=1 to ile_swiatel do with swiatla[a] do begin
    if (ztylu=czyztylu) and
       (x+15-ekran.px>=0) and (y+15-ekran.py>=0) and
       (x-15-ekran.px<=ekran.width) and (y-15-ekran.py<=ekran.height-ekran.menux) then begin
       {if (menju.widoczne=4) and (menju.swiatlo_wybrane=a) then c:=$ff0050FF
          else c:=$90ffffff;
       form1.PowerDraw1.RenderEffectCol(obr.wejscie.surf, x-ekran.px-15,y-ekran.py-15,c,random(3),effectSrcAlpha or effectDiffuse);}

       if kolor and $ff000000=$ff000000 then ef:=effectSrcAlpha
          else ef:=effectSrcAlpha or effectDiffuse;
       if efekt=1 then ef:=ef or effectAdd;
       form1.PowerDraw1.TextureMap(obr.wybuchdym[typy[typ,0],typy[typ,1]].surf,
          pRotate4(x-ekran.px+ekran.trzesx,
                   y-ekran.py+ekran.trzesy,
                   wielkosc,
                   wielkosc,
                   wielkosc div 2,
                   wielkosc div 2,
                   kat+trunc(x-ekran.px+y-ekran.py) div 2),
                   cColor1(kolor),
                   tPattern(0),
                   ef);

       if (menju.widoczne=1) and (rysowanie.corobi=4) and (menju.swiatlo_wybrane=a) then
          form1.PowerDraw1.Circle(x-ekran.px,y-ekran.py,wielkosc div 2, $7000ff00, effectsrcalpha or effectdiffuse);


       ///odblaski

       nowa_flara(x-ekran.px+ekran.trzesx, y-ekran.py+ekran.trzesy,wielkosc,kolor);

(*       kdx:=(x-ekran.px+ekran.trzesx) - (ekran.width div 2);
       kdy:=(y-ekran.py+ekran.trzesy) - (ekran.height div 2);

//       odleglosc:=(sqrt2(kdx*kdx + kdy*kdy) / (ekran.width/64)) / 10;
       odleglosc:=(1 - (sqrt2(sqr(kdx)+sqr(kdy))) / (300* (ekran.width/640))) ;
       if odleglosc<0 then odleglosc:=0;
       if odleglosc>1 then odleglosc:=1;

       for b:=ileflar downto 0 do begin
           jas := trunc( ((kolor and $FF000000) shr 24) * ((flary[b].przezr * odleglosc)) );
           if jas>=1 then begin
               if jas>255 then jas:=255;
               kol:= (jas shl 24) or (kolor and $00FFFFFF) ;

               rozmf:= trunc(3+ flary[b].rozm*wielkosc/250);

               form1.PowerDraw1.TextureMap(obr.flara.surf,
                  pBounds4(trunc( (ekran.width div 2) + kdx*flary[b].odl
                             -rozmf/2),
                           trunc( (ekran.height div 2) + kdy*flary[b].odl
                             -rozmf/2),
                           rozmf,rozmf
                           ),
                           cColor1(kol),
                           tPattern(flary[b].wygl),
                           effectSrcAlpha or effectDiffuse or effectAdd);
            {   pisz(l2t(kol ,0),
                     trunc( (ekran.width div 2) + kdx*flary[b].odl
                             -rozmf/2),
                           trunc( (ekran.height div 2) + kdy*flary[b].odl
                             -rozmf/2));   }
           end;

       end;
*)

    end;
end;

end;


procedure nowa_flara(x_,y_:integer; wlk: word; kolr: cardinal);
begin
if not kfg.efekty_soczewki then exit;
if wlk<=48 then exit;

if ile_flara < max_flara - 1 then
begin
  inc(ile_flara);
  with flary[ile_flara - 1] do begin
     x:=x_;
     y:=y_;
     kolor:=kolr;
     wielkosc:=wlk;
  end;
end;
end;


procedure rysuj_flary;
const
ileflar=6;
flarywygl:array[0..ileflar] of record
   odl:real;
   rozm:byte;
   wygl:byte;
   przezr:real;
 end = (
 { 0} (odl: -1.5; rozm:  90; wygl: 3; przezr: 0.2),
 { 1} (odl: -1.0; rozm:  48; wygl: 1; przezr: 0.4),
 { 2} (odl: -0.3; rozm:  28; wygl: 0; przezr: 0.8),
 { 3} (odl:  0.1; rozm:  10; wygl: 2; przezr: 1.0),
 { 4} (odl:  0.3; rozm:  24; wygl: 1; przezr: 1.0),
 { 5} (odl:  0.7; rozm:  50; wygl: 3; przezr: 0.9),
 { 6} (odl:  1.7; rozm:  80; wygl: 0; przezr: 0.2)

 );

var a,b:integer;
kdx,kdy:real;
kol: cardinal;
odleglosc: real;
jas,rozmf: integer;

ekrsrx, ekrsry: integer; //srodek ekranu
begin

ekrsrx:=ekran.width div 2;
ekrsry:=ekran.height div 2;

for a:=0 to ile_flara - 1 do
  with flary[a] do begin

       kdx:=x-ekrsrx;
       kdy:=y-ekrsry;

//       odleglosc:=(sqrt2(kdx*kdx + kdy*kdy) / (ekran.width/64)) / 10;
       odleglosc:=(1 - (sqrt2(sqr(kdx)+sqr(kdy))) / (300* (ekran.width/640))) ;
       if odleglosc<0 then odleglosc:=0;
       if odleglosc>1 then odleglosc:=1;

       for b:=ileflar downto 0 do begin
           jas := trunc( ((kolor and $FF000000) shr 24) * ((flarywygl[b].przezr * odleglosc)) );
           if jas>=1 then begin
               if jas>255 then jas:=255;
               kol:= (jas shl 24) or (kolor and $00FFFFFF) ;

               rozmf:= trunc(3+ flarywygl[b].rozm*wielkosc/250);

               form1.PowerDraw1.TextureMap(obr.flara.surf,
                  pBounds4(trunc( (ekran.width div 2) + kdx*flarywygl[b].odl
                             -rozmf/2),
                           trunc( (ekran.height div 2) + kdy*flarywygl[b].odl
                             -rozmf/2),
                           rozmf,rozmf
                           ),
                           cColor1(kol),
                           tPattern(flarywygl[b].wygl),
                           effectSrcAlpha or effectDiffuse or effectAdd);
            {   pisz(l2t(kol ,0),
                     trunc( (ekran.width div 2) + kdx*flarywygl[b].odl
                             -rozmf/2),
                           trunc( (ekran.height div 2) + kdy*flarywygl[b].odl
                             -rozmf/2));   }
           end;

       end;


  end;

end;


end.
