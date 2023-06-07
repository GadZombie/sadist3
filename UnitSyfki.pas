unit UnitSyfki;

interface
uses Graphics, Types, vars;

    procedure nowysyf(sx,sy, sdx,sdy :real; rodzajliczenia:byte; rod,slad,gatunek_:byte; zabierz_dowolny:boolean; team_:shortint=0; rodzaj_spec:byte=0; kolor_:cardinal=$00DF8030);
    procedure ruszaj_syfki;
    procedure rysuj_syfki;
    procedure rysuj_syfki_na_terenie;

implementation
uses unit1, sinusy, d3d9, pdrawex, powertypes, unitwybuchy, unitrysowanie, unitefekty;
const
tz1=1;
tz2=4;
kolory_typow_wody:array[1..5] of record k:cardinal; g:byte end=(
   {woda}(k:$00DF8030; g:2),
   {lawa}(k:$000070EF; g:2),
   {kwas}(k:$0030A050; g:2),
   {krew}(k:$00000000; g:0),
   {blot}(k:$00204050; g:2));

var
trzeba_zostawiac:boolean;
il_syf:longint;

procedure nowysyf(sx,sy, sdx,sdy :real; rodzajliczenia:byte; rod,slad,gatunek_:byte; zabierz_dowolny:boolean; team_:shortint=0; rodzaj_spec:byte=0; kolor_:cardinal=$00DF8030);
var a,b:longint;
begin
if (not zabierz_dowolny) and (il_syf>=max_syf) then exit;
if (kfg.detale<5) and (random(1+kfg.detale)=0) then exit;

if (il_syf<max_syf) then begin
    a:=syf_nowy;
    b:=0;
    while (b<max_syf) and ((syf[a].jest) or (syf[a].zostaw)) do begin
       inc(a);
       inc(b);
       if a>=max_syf then a:=0;
    end;
end else b:=max_syf;
if (zabierz_dowolny) and (gatunek_ in [0,2]) and (b>=max_syf) and (random(3)=0) then a:=random(max_syf);

if (a<0) or (a>max_syf) then exit;
if not syf[a].jest then with syf[a] do begin
   x:=sx;
   y:=sy;
   if rodzajliczenia=0 then begin
      dx:=sdx;
      dy:=sdy;
   end else begin
      dx:=_sin(trunc(sdx))*sdy/3;
      dy:=-_cos(trunc(sdx))*sdy/3;
   end;   jest:=true;
   rodz:=rod;
   if rodz>=4 then rodz:=3;
   obrot:=random(256);

   if gatunek=3 then else przezroczystosc:=255-random(80);
      przezroczystosc:=255;

   palisie:=(gatunek=1) and (slad=1) and (random(4)<=2);

   case rodzaj_spec of
      0:begin {normalny}
        gatunek:=gatunek_;
        team:=team_;
        kolor:=kolor_;
        slady:=slad;
        if gatunek=0 then przezroczystosc:=255-(random(2)*(random(140)));
        if gatunek=2 then przezroczystosc:=(80+random(140));
        end;
      1:begin {woda}
        gatunek:=2;
        team:=0;
        kolor:=$00DF8030;
        slady:=0;
        przezroczystosc:=255-(random(2)*(random(140)));
        end;
      2:begin {lawa}
        gatunek:=2;
        team:=0;
        kolor:=$000030EF+(random(100) shl 8);
        slady:=0;
        przezroczystosc:=255-(random(2)*(random(80)));
        end;
      3:begin {kwas}
        gatunek:=2;
        team:=0;
        kolor:=$0030A050;
        slady:=0;
        przezroczystosc:=255-(random(2)*(random(140)));
        end;
      4:begin {krew}
        gatunek:=0;
        team:=-1;
        kolor:=0;
        slady:=1;
        przezroczystosc:=(80+random(140));
        end;
      5:begin {bloto}
        gatunek:=2;
        team:=0;
        kolor:=$00204050;
        slady:=0;
        przezroczystosc:=255-(random(2)*(random(60)));
        end;
   end;

   if gatunek=0 then klatka:=random(4)
                else klatka:=0;

   zostaw:=false;
end;

end;

procedure ruszaj_syfki;
var
 a:longint;
 px,py:integer;
 wyswodywx:integer;

begin
il_syf:=0;
for a:=0 to max_syf do
  if syf[a].jest then with syf[a] do begin
    inc(il_syf);

    if dx<-7 then dx:=dx*0.9;
    if dx>7 then dx:=dx*0.9;
    if dy<-7 then dy:=dy*0.9;
    if dy>7 then dy:=dy*0.9;

    x:=x+dx;
    y:=y+dy;
    wyswodywx:=wyswody(x);
   if ((warunki.typ_wody=0) or (y<wyswodywx)) then dx:=dx+warunki.wiatr/6;
    if random(2)=0 then begin
       dx:=dx*0.98;
       dy:=dy*0.98;
    end;
    if (x<0) or (x>teren.Width) then begin
       jest:=false;
    end;
    if (y>teren.Height+30) or (y<-1500) then begin
       jest:=false;
    end;

    if abs(dx)>=0.5 then obrot:=obrot+dx*10
       else begin
            if dx>0 then obrot:=obrot+6
                    else obrot:=obrot-6;
            end;
    if obrot<0 then obrot:=obrot+256 else
    if obrot>=256 then obrot:=obrot-256;

    if (warunki.typ_wody>=1) and (y>=wyswodywx) then begin
       case warunki.typ_wody of
          1..max_wod:begin
            if gatunek=2 then begin
               y:=wyswodywx;
               dy:=0;
               if (abs(dx)<1) then dx:=dx*1.2;
               if (random(60)=0) or (
                  (abs(dx)<0.5) and (abs(dy)<0.5) and (random(10)=0) ) then jest:=false;
            end else
            if gatunek =3 then jest:=false;

            if (y>warunki.typ_wody+1) and (abs(dx)>gestosci[warunki.typ_wody].maxx) then dx:=dx/(gestosci[warunki.typ_wody].x*1.09);
            if abs(dy)>gestosci[warunki.typ_wody].maxy*0.8{0.8} then dy:=dy/gestosci[warunki.typ_wody].y;
            if (gatunek=0) and (random(2)=0) then begin
               if przezroczystosc>=3 then przezroczystosc:=przezroczystosc-3
                  else jest:=false;
               if (rodz<3) and (random(20)=0) then inc(rodz);
            end else
                if (warunki.typ_wody=2) and (gatunek>0) and (random(50)=0) then jest:=false;

            //if przezroczystosc<=1 then jest:=false;

            //if gatunek in [2,3] then jest:=false;
            if (gatunek=0) and (warunki.typ_wody=4) then jest:=false;
            end;
       end;
    end;

    if (gatunek=3) and (random(50)=0) then jest:=false;
    if palisie and (random(40)=0) then palisie:=false;

    if (x>=0) and (y>=0) and (x<=teren.width-1) and (y<=teren.height+30) and
       (teren.maska[trunc(x),trunc(y)]<>0) then begin
       if (slady=1) and (sqrt2(abs(dx*dx+dy*dy))>0.1) then begin
          if dx>=0 then px:=1 else px:=-1;
          if dy>=0 then py:=1 else py:=-1;
          if (trunc(x)+px>=0) and (trunc(y)-py>=0) and
             (trunc(x)+px<=teren.width-1) and (trunc(y)-py<=teren.height+30) and
             (teren.maska[trunc(x)+px,trunc(y)-py]<>0) then dx:=-dx*0.7;
          if (trunc(x)-px>=0) and (trunc(y)+py>=0) and
             (trunc(x)-px<=teren.width-1) and (trunc(y)+py<=teren.height+30) and
             (teren.maska[trunc(x)-px,trunc(y)+py]<>0) then dy:=-dy*0.7;
          if (rodz>=1) and (random(7)=0) and
             ((warunki.typ_wody=0) or ((warunki.typ_wody>=1) and (y<wyswodywx))) and
             (sqrt2(dx*dx+dy*dy)>0.4) then begin
             //if gatunek=0 then form1.graj(druzyna[0].dzwieki.Item[3],x,y,7000) else
             if gatunek=1 then form1.graj(Form1.dzw_rozne.Item[1],x,y,15000);
          end;
       end else begin
           if (gatunek=0) then begin
              if (rodz>=1) or (random(5)=0) then begin
                 if (kfg.krew_mieso_zostawia_slady) {and (rodz>=1)} then begin
                    zostaw:=true;
                    trzeba_zostawiac:=true;
                 end;
                 if (y>teren.height-1) and (random(3)=0) then y:=teren.height-1;
              end;
           end else
           if (gatunek=1) and (rodz>=3) and
              (sqrt2(dx*dx+dy*dy)>0.4) and
              (random(2)=0) then begin
              nowysyf(x-dx,y-dy,random(360),random*sqrt2(dx*dx+dy*dy)*3,0, random(2), 0, 1, false);
              nowysyf(x-dx,y-dy,random(360),random*sqrt2(dx*dx+dy*dy)*3,0, random(2), 0, 1, false);
           end;
           jest:=false;
           end;
    end;

    if jest then begin
        dy:=dy+(0.05+(0.01*(3-rodz)))*warunki.grawitacja;

        if (gatunek=0) and (slady=1) and (random(3)=0) then begin
           nowysyf(x,y,random/5-0.1,0,0,0,0,0,false,team);
           if random(40)=0 then slady:=0;
        end;

        if (gatunek=1) and (slady=1) and (kfg.detale>=3) and (random(10)=0) then begin
              nowywybuchdym( x, y,
                             random/2-0.25,
                             -0.3-random/1.6,
                             0, wd_dym,
                             random(4),
                             80+random(100)+round( (rodz*10)*(0.5+random/2) ),
                             80+random(100)+round( (rodz*16)*(0.5+random/2) ));

           if random(200)=0 then slady:=0;
           if (warunki.typ_wody>=1) and (y>=wyswodywx) and (random(7)=0) then slady:=0;
        end;

        if (gatunek=0) and (random(100)=0) then jest:=false;

    end;

end;

end;

procedure rysuj_syfki;
var a:longint;
xsize,ysize,skala,efekt:integer;
kk0:real;
c:cardinal;
begin
for a:=0 to max_syf do
   if syf[a].jest or syf[a].zostaw then with syf[a] do begin
      if (gatunek=2) or
         ((gatunek=0) and (rodz<=3)) then begin {krew,woda}
         if dx>0 then begin
            if (dy>0) then kk0:=arctan(dy/dx)+1.570796{pi/2}
                      else kk0:=arctan(dy/dx)+1.570796{pi/2};
         end else if dx<0 then begin
            if (dy>0) then kk0:=arctan(dy/dx)+4.712389{(3/2)*pi}
                      else kk0:=arctan(dy/dx)+4.712389{(3/2)*pi};
         end else begin
            if (dy>0) then kk0:=pi
                      else kk0:=0;
         end;

         if (dx=0) and (dy=0) then skala:=1
            else skala:=trunc( sqrt(abs(sqr(dx)+sqr(dy)))*400 );
         if skala<256 then skala:=256;

         if (rodz=0) and (gatunek=0) then begin
            Xsize:=  2;
            Ysize:= (2 * Skala) div 256;
         end else begin
            Xsize:=  obr.syf[gatunek,rodz].surf.PatternWidth;
            Ysize:= (obr.syf[gatunek,rodz].surf.PatternHeight * Skala) div 256;
         end;

         if (gatunek=0) and (team>=-1) and (team<=max_druzyn) then begin
            efekt:=effectSrcAlpha or effectDiffuse;
            c:=druzyna[team].kolor_krwi;
         end else begin
             efekt:=effectSrcAlpha or effectAdd;
             c:=kolor;
             end;

         if (x+40-ekran.px>=0) and
            (x-40-ekran.px<=ekran.width) and
            (y+40-ekran.py>=0) and
            (y-40-ekran.py<=ekran.height) then
         form1.powerdraw1.TextureMap( obr.syf[gatunek,rodz].surf,
                                      pRotate4(trunc(x)-ekran.px,
                                               trunc(y)-ekran.py,
                                               Xsize,
                                               Ysize,
                                               Xsize div 2,
                                               Ysize div 5,
                                               trunc((kk0/(pi180))/1.40625)),
                                      cColor1(cardinal((przezroczystosc shl 24) or c)),
                                      tPattern(klatka),
                                      efekt);
       end else if gatunek=3 then begin {iskry}

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

         if (dx=0) and (dy=0) then skala:=1
            else skala:=trunc( sqrt(abs(sqr(dx)+sqr(dy)))*80 );
         if skala<50 then skala:=50;

         Xsize:=  1;
         Ysize:= (obr.syf[gatunek,rodz].surf.PatternHeight * Skala) div 256;

         if (x+40-ekran.px>=0) and
            (x-40-ekran.px<=ekran.width) and
            (y+40-ekran.py>=0) and
            (y-40-ekran.py<=ekran.height) then
         form1.powerdraw1.TextureMap( obr.syf[gatunek,rodz].surf,
                                      pRotate4(trunc(x)-ekran.px,
                                               trunc(y)-ekran.py,
                                               Xsize,
                                               Ysize,
                                               Xsize div 2,
                                               0{Ysize div 2},
                                               trunc((kk0/(pi180))/1.40625)),
                                      cColor1(cardinal((przezroczystosc shl 24) or kolor)),
                                      tPattern(0),
                                      effectSrcAlpha or effectAdd);
{          form1.PowerDraw1.RotateEffect(
                   obr.syf[2,rodz].surf,
                   trunc(x)-ekran.px,
                   trunc(y)-ekran.py,
                   trunc(obrot),
                   176,
                   cardinal((przezroczystosc shl 24) or kolor),
                   0,
                   effectSrcAlpha or effectAdd);}
       end else begin {kamyki}
         if (x+40-ekran.px>=0) and
            (x-40-ekran.px<=ekran.width) and
            (y+40-ekran.py>=0) and
            (y-40-ekran.py<=ekran.height) then
          form1.PowerDraw1.RotateEffect(
                   obr.syf[gatunek,rodz].surf,
                   trunc(x)-ekran.px,
                   trunc(y)-ekran.py,
                   trunc(obrot),
                   256,
                   cardinal((przezroczystosc shl 24) or $FFFFFF),
                   0,
                   effectSrcAlpha or effectDiffuse);

          if palisie then
              form1.PowerDraw1.TextureMap(obr.pocisk[5].surf,
                         pBounds4(
                         trunc(x-15)-ekran.px-1+random(3),
                         trunc(y-15)-ekran.py-3+random(5),
                         30, 30),
                         cColor1( cardinal( (80+random(70)) shl 24+$FFFFFF ) ),
                         tPattern(random(26)),
                         effectSrcAlpha or effectAdd or effectDiffuse);

       end;
   end;
end;

procedure rysuj_syfki_na_terenie;
var
 a:longint; px,py,px1,py1:integer;
 LRect: TD3DLocked_Rect;
 DestPtr:Pointer;
 getvalu:cardinal;
 g:array[0..20] of cardinal;
begin
a:=0;
if not trzeba_zostawiac then exit;

if kfg.krew_mieso_zostawia_slady then begin
    obr.teren.surf.Lock(0, LRect);

    for a:=0 to max_syf do
      if (syf[a].zostaw) and (not syf[a].jest) and
         (syf[a].x>=syf[a].rodz div 2) and (syf[a].x<=teren.width-1-syf[a].rodz div 2) and
         (syf[a].y>=syf[a].rodz div 2) and (syf[a].y<=teren.height+7)
         then with syf[a] do begin

         for py:=0 to 1+rodz do begin

             py1:=py+trunc(y-rodz div 2);

             if (py1>=0) and (py1<=teren.height-1) then begin
                 DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * py1) + (trunc(x-rodz div 2) * obr.teren.surf.BytesPerPixel));
                 pdrawlineConv(DestPtr, @g, 1+rodz ,obr.teren.surf.Format,D3DFMT_A8R8G8B8);

                 for px:=0 to 1+rodz do begin
                     px1:=px+trunc(x-rodz div 2);

                     if (px1>=0) and (px1<=teren.width-1) then begin
                        getvalu:=druzyna[team].syfslad[rodz][px,py];
                        //if getvalu=$FFFF00FF then getvalu:=$00000000;
                        if (getvalu<>$FFFF00FF) then begin
                           {DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * py1) + (px1 * obr.teren.surf.BytesPerPixel));
                           pdrawFormatConv(@getValu, DestPtr, D3DFMT_A8R8G8B8, obr.teren.surf.Format);}
                           g[px]:=getvalu;
                        end;
                     end;
                 end;
                 DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * py1) + (trunc(x-rodz div 2) * obr.teren.surf.BytesPerPixel));
                 pdrawlineConv(@g, DestPtr, 1+rodz ,D3DFMT_A8R8G8B8, obr.teren.surf.Format);
             end;
         end;
         zostaw:=false;
      end else if syf[a].zostaw then begin syf[a].zostaw:=false; syf[a].jest:=false; end;

    obr.teren.surf.unLock(0);
end;
trzeba_zostawiac:=false;
end;

end.
