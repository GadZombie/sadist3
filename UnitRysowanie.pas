unit UnitRysowanie;

interface
uses vars;

var
  teren:record
      width,height:integer;
//      tlowidth,tloheight:integer;
      tlododx,tlodody:real;

      maska:array of array of byte;
            {  0: puste, nic, powietrze oraz obrazki w tle
               1: skala - da sie normalnie rozwalac
               2-9: ciezkie do rozwalenia, kazde uszkodzenie obcina o jeden w dol, az dojdzie do 1
               10: metal - nie da sie rozwalic
            }

      ilex,iley:integer;
      ileekrx,ileekry:integer;
      end;

  wlasc_scenariusza:record
      tekstura:string;  {nazwa pliku tekstury}
      //tekstura_n:integer; {numer pliku tekstury na liscie}
      obiekty:array of record
                 naz:string; {nazwy plikow obiektow}
                 nr:integer; {numer pliku obiektu na liscie}
              end;
      wierzch:array[0..1] of record {wierzch gorny i dolny}
                ef:integer; {efekt}
                kol:cardinal; {kolor}
              end;
      ciecze:array[0..5] of boolean;
  end;

  wlasc_wczytanego_obiektu:record //do dodawania swiatelek razem z wybranym obiektem itp
     swiatla: array of //ile swiatel dodawac razem z obiektem? = dlugosc tej tablicy
        TSwiatlo; //wlasciwosci swiatla tak samo jak w TSwiatlo, lecz pozycja XY jest wzgledem lewego gornego rogu obrazka
     end;

    procedure rysuj_kolko_tex(sx,sy,r:integer; cm:byte);
    procedure rysuj_kolko_kol(sx,sy,r:integer; c:cardinal; cm:byte);
    procedure rysuj_obiekt(sx,sy:integer; cm:byte);

    procedure zrob_trawe(x1,y1,x2,y2:integer; kolg,kold:cardinal; efg,efd:byte; rysujtex:boolean);
    procedure teren_ustawrozmiary(tx,ty:integer);
    procedure rysujteren(rozmx,rozmy:integer);

implementation
uses unit1, PowerInputs, powertypes, PowerDraw3, directinput8, d3d9, pdrawex,
  AGFUnit, Graphics, unitminy, unitprzedmioty, unitmenuglowne, unitpliki, unitstringi,
  unitwybuchy;

procedure rysuj_kolko_tex(sx,sy,r:integer; cm:byte);
var
x,y:integer;

d,mn:integer;
bylo:array of byte;

LRect: TD3DLocked_Rect;
DestPtr: Pointer;
skan:pointer;

 procedure hline_x(x1,x2,y:integer; cm:byte);
   var
   x,xx:integer; g:array[0..639] of cardinal; ty:integer;
 begin
   if x1<0 then x1:=0;
   if x2>teren.width-1 then x2:=teren.width-1;
   if (x2<x1) or (y<0) or (y>=teren.height) then exit;
   ty:=y mod obr.tekstura.Height;

   DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * y) + (x1 * obr.teren.surf.BytesPerPixel));
   if (rysowanie.ztylu) then pdrawlineConv(DestPtr, @g, x2-x1+1, D3DFMT_A8R8G8B8, obr.teren.surf.Format)
      else fillchar (g, (x2-x1+1)*4, 0);

   xx:=0;
   for x:=x1 to x2 do begin
       skan:=pointer( integer(obr.tekstura.ScanLine[ty]) + integer(x mod (obr.tekstura.Width))*mn );

       {if (rysowanie.ztylu) then pdrawFormatConv(DestPtr, @g, D3DFMT_A8R8G8B8, obr.teren.surf.Format)
          else g:=0;}
       if (not rysowanie.ztylu) or (g[xx] and $FF000000=0) then begin
          if mn=3 then begin
             g[xx]:=$FF000000 or word(skan^);
             skan:=pointer( integer(obr.tekstura.ScanLine[ty]) + integer(x mod (obr.tekstura.Width))*mn+2 );
             g[xx]:=g[xx] or byte(skan^) shl 16;
          end else begin
             g[xx]:=$FF000000 or cardinal(skan^);
          end;
          //if rysowanie.maskowanie in [1,2] then pdrawFormatConv(@g, DestPtr, D3DFMT_A8R8G8B8, obr.teren.surf.Format);
          if rysowanie.maskowanie in [0,2] then teren.maska[x,y]:=cm;
       end;
       inc(xx);
   end;
   if rysowanie.maskowanie in [1,2] then
      pdrawlineConv(@g, DestPtr, x2-x1+1, D3DFMT_A8R8G8B8, obr.teren.surf.Format);

 end;


begin
obr.teren.surf.Lock(0, LRect);
setlength(bylo,teren.height);
for x:=0 to high(bylo) do bylo[x]:=0;

x:=0;
y:=r;
d:=3-2*r;

case obr.tekstura.PixelFormat of
  pf1bit:mn:=1;
  pf4bit:mn:=1;
  pf8bit:mn:=1;
  pf15bit:mn:=2;
  pf16bit:mn:=2;
  pf24bit:mn:=3;
  pf32bit:mn:=4;
end;


if r=1 then begin
   hline_x(sx,sx,sy,cm);
end else begin
   if rysowanie.ksztaltpedzla=0 then begin
       repeat
         if (sy+y>=0) and (sy+y<teren.height) and ((sx+x)-(sx-x)>=1) and (bylo[sy+y]=0) then begin
           hline_x(sx-x,sx+x,sy+y,cm);
           bylo[sy+y]:=1;
         end;
         if (sy-y>=0) and (sy-y<teren.height) and ((sx+x)-(sx-x)>=1) and (bylo[sy-y]=0) then begin
           hline_x(sx-x,sx+x,sy-y,cm);
           bylo[sy-y]:=1;
         end;
         if (sy+x>=0) and (sy+x<teren.height) and ((sx+y)-(sx-y)>=1) and (bylo[sy+x]=0) then begin
           hline_x(sx-y,sx+y,sy+x,cm);
           bylo[sy+x]:=1;
         end;
         if (sy-x>=0) and (sy-x<teren.height) and ((sx+y)-(sx-y)>=1) and (bylo[sy-x]=0) then begin
           hline_x(sx-y,sx+y,sy-x,cm);
           bylo[sy-x]:=1;
         end;
         inc(x);
         if d>=0 then begin
            dec(y);
            d:=d+2*(2*x-2*y+1);
         end else d:=d+2*(2*x+1)
       until x>y;
   end else begin
       for x:=0 to r*2-1 do
           hline_x(sx-r,sx+r-1,sy-r+x,cm);
   end;
end;

obr.teren.surf.unLock(0);
end;


procedure rysuj_kolko_kol(sx,sy,r:integer; c:cardinal; cm:byte);
var
x,y:integer;

d:integer;
bylo:array of byte;

LRect: TD3DLocked_Rect;
DestPtr: Pointer;

 procedure hline_x(x1,x2,y:integer; c:cardinal; cm:byte);
   var
   x,xx:integer; g:array[0..639] of cardinal;
   k1,b:integer;
   kr,kg,kb:integer;
 begin
   if x1<0 then x1:=0;
   if x2>teren.width-1 then x2:=teren.width-1;
   if (x2<x1) or (y<0) or (y>=teren.height) then exit;
   k1:=rysowanie.ziarna shr 1;

   DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * y) + (x1 * obr.teren.surf.BytesPerPixel));
   if (rysowanie.ztylu) then pdrawlineConv(DestPtr, @g, x2-x1+1, D3DFMT_A8R8G8B8, obr.teren.surf.Format)
      else fillchar (g, (x2-x1+1)*4, 0);
   xx:=0;
   for x:=x1 to x2 do begin

       {if (rysowanie.ztylu) then pdrawFormatConv(DestPtr, @g, D3DFMT_A8R8G8B8, obr.teren.surf.Format)
          else g:=0;}

       if (not rysowanie.ztylu) or (g[xx] and $FF000000=0) then begin
           if (rysowanie.ziarna=0) or (c=$0) then g[xx]:=c
           else begin
              b:=-k1+random(rysowanie.ziarna);
              kr:=(c and $FF0000) shr 16 +b;
              kg:=(c and $FF00) shr 8 +b;
              kb:= c and $FF +b;
              if kr<0 then kr:=0; if kr>255 then kr:=255;
              if kg<0 then kg:=0; if kg>255 then kg:=255;
              if kb<0 then kb:=0; if kb>255 then kb:=255;

              g[xx]:=$FF000000 or kr shl 16 or kg shl 8 or kb;
           end;

          //if rysowanie.maskowanie in [1,2] then pdrawFormatConv(@g, DestPtr, D3DFMT_A8R8G8B8, obr.teren.surf.Format);
          if rysowanie.maskowanie in [0,2] then teren.maska[x,y]:=cm;
       end;

       inc(xx);
   end;

   DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * y) + (x1 * obr.teren.surf.BytesPerPixel));
   if rysowanie.maskowanie in [1,2] then
      pdrawlineConv(@g, DestPtr, x2-x1+1, D3DFMT_A8R8G8B8, obr.teren.surf.Format);

 end;


begin
obr.teren.surf.Lock(0, LRect);
setlength(bylo,teren.height);

x:=0;
y:=r;
d:=3-2*r;

if r=1 then begin
   hline_x(sx,sx,sy,c,cm);
end else begin
   if rysowanie.ksztaltpedzla=0 then begin
       repeat
         if (sy+y>=0) and (sy+y<teren.height) and ((sx+x)-(sx-x)>=1) and (bylo[sy+y]=0) then begin
           hline_x(sx-x,sx+x,sy+y,c,cm);
           bylo[sy+y]:=1;
         end;
         if (sy-y>=0) and (sy-y<teren.height) and ((sx+x)-(sx-x)>=1) and (bylo[sy-y]=0) then begin
           hline_x(sx-x,sx+x,sy-y,c,cm);
           bylo[sy-y]:=1;
         end;
         if (sy+x>=0) and (sy+x<teren.height) and ((sx+y)-(sx-y)>=1) and (bylo[sy+x]=0) then begin
           hline_x(sx-y,sx+y,sy+x,c,cm);
           bylo[sy+x]:=1;
         end;
         if (sy-x>=0) and (sy-x<teren.height) and ((sx+y)-(sx-y)>=1) and (bylo[sy-x]=0) then begin
           hline_x(sx-y,sx+y,sy-x,c,cm);
           bylo[sy-x]:=1;
         end;
         inc(x);
         if d>=0 then begin
            dec(y);
            d:=d+2*(2*x-2*y+1);
         end else d:=d+2*(2*x+1)
       until x>y;
   end else begin
       for x:=0 to r*2-1 do
           hline_x(sx-r,sx+r-1,sy-r+x,c,cm);
   end;
end;

obr.teren.surf.unLock(0);
end;


procedure rysuj_obiekt(sx,sy:integer; cm:byte);
var
x,y,x1,y1:integer;
LRect: TD3DLocked_Rect;
DestPtr: Pointer;
skan:pointer;

g:cardinal;

begin
obr.teren.surf.Lock(0, LRect);

for y:=0 to obr.obiekt.Height-1 do begin
   y1:=sy+y;
   for x:=0 to obr.obiekt.Width-1 do begin
       x1:=sx+x;
       if (x1>=0) and (x1<=teren.width-1) and (y1>=0) and (y1<=teren.height-1) then begin
           if rysowanie.odwrocony then
              skan:=pointer( integer(obr.obiekt.ScanLine[y]) + integer((obr.obiekt.Width-1-x)*4) )
           else
              skan:=pointer( integer(obr.obiekt.ScanLine[y]) + integer(x*4) );

           if (cardinal(skan^) and $FF000000)<>$00 then begin
              DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * y1) + (x1 * obr.teren.surf.BytesPerPixel));

              pdrawFormatConv(DestPtr, @g, D3DFMT_A8R8G8B8, obr.teren.surf.Format);

              if (not rysowanie.ztylu) or (g and $FF000000=0) then begin
                 g:=$FF000000 or cardinal(skan^);
                 if rysowanie.maskowanie in [1,2] then pdrawFormatConv(@g, DestPtr, D3DFMT_A8R8G8B8, obr.teren.surf.Format);
                 if rysowanie.maskowanie in [0,2] then teren.maska[x1,y1]:=cm;
              end;
           end;
       end;
   end;
end;

obr.teren.surf.unLock(0);

if length(wlasc_wczytanego_obiektu.swiatla)>0 then begin
   for g:=0 to high(wlasc_wczytanego_obiektu.swiatla) do begin
       if rysowanie.odwrocony then x1:=obr.obiekt.Width-1-wlasc_wczytanego_obiektu.swiatla[g].x
                              else x1:=wlasc_wczytanego_obiektu.swiatla[g].x;
       dodaj_swiatlo_param(sx+x1,
                           sy+wlasc_wczytanego_obiektu.swiatla[g].y,
                           wlasc_wczytanego_obiektu.swiatla[g].kolor,
                           wlasc_wczytanego_obiektu.swiatla[g].typ,
                           wlasc_wczytanego_obiektu.swiatla[g].wielkosc,
                           wlasc_wczytanego_obiektu.swiatla[g].kat,
                           wlasc_wczytanego_obiektu.swiatla[g].efekt,
                           wlasc_wczytanego_obiektu.swiatla[g].zniszczalne,
                           wlasc_wczytanego_obiektu.swiatla[g].ztylu);

   end;
end;

end;




procedure rysuj_kolko_maska(sx,sy,r:integer; cl:byte);
var
x,y:integer;

d:integer;
bylo:array of byte;

 procedure hline_x(x1,x2,y:integer);
   var
   x:integer;
 begin
   if x1<0 then x1:=0;
   if x2>teren.width-1 then x2:=teren.width-1;
   if (x2<x1) or (y<0) or (y>=teren.height) then exit;
   for x:=x1 to x2 do
       teren.maska[x,y]:=cl;
 end;


begin
setlength(bylo,teren.height);

x:=0;
y:=r;
d:=3-2*r;

if r=1 then begin
   hline_x(sx,sx,sy);
end else begin
       repeat
         if (sy+y>=0) and (sy+y<teren.height) and ((sx+x)-(sx-x)>=1) and (bylo[sy+y]=0) then begin
           hline_x(sx-x,sx+x,sy+y);
           bylo[sy+y]:=1;
         end;
         if (sy-y>=0) and (sy-y<teren.height) and ((sx+x)-(sx-x)>=1) and (bylo[sy-y]=0) then begin
           hline_x(sx-x,sx+x,sy-y);
           bylo[sy-y]:=1;
         end;
         if (sy+x>=0) and (sy+x<teren.height) and ((sx+y)-(sx-y)>=1) and (bylo[sy+x]=0) then begin
           hline_x(sx-y,sx+y,sy+x);
           bylo[sy+x]:=1;
         end;
         if (sy-x>=0) and (sy-x<teren.height) and ((sx+y)-(sx-y)>=1) and (bylo[sy-x]=0) then begin
           hline_x(sx-y,sx+y,sy-x);
           bylo[sy-x]:=1;
         end;
         inc(x);
         if d>=0 then begin
            dec(y);
            d:=d+2*(2*x-2*y+1);
         end else d:=d+2*(2*x+1)
       until x>y;
end;

end;






{--------------------rysowanie terenu na rozne sposoby ;)----------------------}

(* rysuje gory z jaskiniami pod spodem. proste i chujowe
procedure rysujteren;
var
a,a1,
x,y:integer;
ty,dty,tmp:array[0..16] of real;
kol:array[0..16] of byte;
il,n:byte;

gg,dg:integer;

 LRect: TD3DLocked_Rect;
 lrectr:TD3DLocked_Rect;
 DestPtr,srcptr: Pointer;
 c:cardinal;
 b:byte;
begin
obr.teren.surf.Lock(0, LRect);

gg:=300;
dg:=teren.height-1;

il:=5;

for a:=0 to il do begin
    ty[a]:=random(teren.height);
    dty[a]:=random*4-2;
end;
for x:=0 to teren.width-1 do begin
    for a:=0 to il do tmp[a]:=ty[a];

    for a:=0 to il do begin
        n:=0;
        for a1:=1 to il do begin
            if tmp[a1]<tmp[n] then n:=a1;
        end;
        kol[a]:=n;
        tmp[n]:=teren.height*10;
    end;

    n:=0;
    for y:=0 to teren.height-1 do begin
        if (y>=ty[kol[n]]) and (n<il-1) then inc(n);

        if ((n mod 2=0) and (y<ty[kol[n]])) or
           ((n mod 2=1) and (y>=ty[kol[n]])) {or
           ((n<il) and (n mod 2=0) and (abs(ty[kol[n+1]]-ty[kol[n]])<50)) }then begin
           c:=$00000000;
           b:=0
        end else begin
            //c:=$FF009000+(trunc(ty[kol[n]]) div 8-y div 6) shl 8;
            c:=$FFe0e0e8+(trunc(ty[kol[n]]) div 8-y div 6) shl 16+(trunc(ty[kol[n]]) div 8-y div 6) shl 8+(trunc(ty[kol[n]]) div 8-y div 6);
            b:=4;
        end;

        DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * y) + (x * obr.teren.surf.BytesPerPixel));
        pdrawFormatConv(@c, DestPtr, D3DFMT_A8R8G8B8, obr.teren.surf.Format);
        teren.maska[x,y]:=b;
    end;
    for a:=0 to il do begin
        ty[a]:=ty[a]+dty[a];
        dty[a]:=dty[a]+random-0.5;
        if dty[a]<-1.5 then dty[a]:=-1.5;
        if dty[a]>1.5 then dty[a]:=1.5;
        if ty[a]<gg then begin ty[a]:=gg;dty[a]:=0; end;
        if ty[a]>dg then begin ty[a]:=dg;dty[a]:=0; end;
    end;
end;

obr.teren.surf.unLock(0);
end;
*)

procedure zrob_trawe(x1,y1,x2,y2:integer; kolg,kold:cardinal; efg,efd:byte; rysujtex:boolean);
var
a,
x,y:integer;
LRect: TD3DLocked_Rect;
DestPtr: Pointer;
g:cardinal;

ty,mn:integer;
skan:pointer;

w:byte;
b1,r1,g1:smallint;
begin
obr.teren.surf.Lock(0, LRect);
case obr.tekstura.PixelFormat of
  pf1bit:mn:=1;
  pf4bit:mn:=1;
  pf8bit:mn:=1;
  pf15bit:mn:=2;
  pf16bit:mn:=2;
  pf24bit:mn:=3;
  pf32bit:mn:=4;
  else mn:=1;
end;

if y1>y2 then begin
   a:=y1;
   y1:=y2;
   y2:=a;
end;
if x1>x2 then begin
   a:=x1;
   x1:=x2;
   x2:=a;
end;

if y1<0 then y1:=0;
if x1<0 then x1:=0;
if y2>teren.height-1 then y2:=teren.height-1;
if x2>teren.width-1 then x2:=teren.width-1;

if (y1>teren.height-1) or
   (x1>teren.width-1) or
   (y2<0) or (x2<0) then exit;

for y:=y1 to y2 do
    for x:=x1 to x2 do begin
        DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * y) + (x * obr.teren.surf.BytesPerPixel));
        if teren.maska[x,y]>0 then begin
           if rysujtex then begin
               ty:=y mod obr.tekstura.Height;
               skan:=pointer( integer(obr.tekstura.ScanLine[ty]) + integer(x mod (obr.tekstura.Width))*mn );

               if mn=3 then begin
                  g:=$FF000000 or word(skan^);
                  skan:=pointer( integer(obr.tekstura.ScanLine[ty]) + integer(x mod (obr.tekstura.Width))*mn+2 );
                  g:=g or byte(skan^) shl 16;
               end else begin
                  g:=$FF000000 or cardinal(skan^);
               end;
           end else begin
               pdrawFormatConv(DestPtr, @g, D3DFMT_A8R8G8B8, obr.teren.surf.Format)
           end;

           {od dolu zaciemnienie}
           a:=0;
           w:=22-random(5);

           while (y+a<=teren.height-1) and (teren.maska[x,y+a]>=1) and (a<w) do inc(a);

           if (y+a<=teren.height-1) and (a<w) then begin
              case efd of
                1:begin {brak efektu - kolor}
                  a:=abs(a);

                  r1:=round(  (g and $FF    )        *(a/w) +  (kold and $FF            )*((w-a)/w) );
                  if r1>255 then r1:=255;

                  g1:=round( ((g and $FF00  ) shr 8 )*(a/w) + ((kold and $FF00  ) shr 8 )*((w-a)/w) );
                  if g1>255 then g1:=255;

                  b1:=round( ((g and $FF0000) shr 16)*(a/w) + ((kold and $FF0000) shr 16)*((w-a)/w) );
                  if b1>255 then b1:=255;

                  g:=$FF000000 + (b1 shl 16) + (g1 shl 8) + r1 ;
                  end;
                2:begin {zaciemnianie}
                  a:=(w-a)*4;
                  r1:=(g and $FF) - a;
                  if r1<0 then r1:=0;

                  g1:=(g and $FF00) shr 8 - a;
                  if g1<0 then g1:=0;

                  b1:=(g and $FF0000) shr 16 - a;
                  if b1<0 then b1:=0;

                  g:=$FF000000 + (b1 shl 16) + (g1 shl 8) + r1 ;
                  end;
                3:begin {rozjasnianie}
                  a:=(w-a)*4;
                  r1:=(g and $FF) + a;
                  if r1>255 then r1:=255;

                  g1:=(g and $FF00) shr 8 + a;
                  if g1>255 then g1:=255;

                  b1:=(g and $FF0000) shr 16 + a;
                  if b1>255 then b1:=255;

                  g:=$FF000000 + (b1 shl 16) + (g1 shl 8) + r1 ;
                  end;
              end;
           end;

           {od gory trawa}
           a:=0;
           w:=22-random(5);
           while (y+a>=0) and (teren.maska[x,y+a]>=1) and (a>-w) do dec(a);

           if (a>-w) then begin
              case efg of
                1:begin {brak efektu - kolor}
                  a:=abs(a);

                  r1:=round(  (g and $FF    )        *(a/w) +  (kolg and $FF            )*((w-a)/w) );
                  if r1>255 then r1:=255;

                  g1:=round( ((g and $FF00  ) shr 8 )*(a/w) + ((kolg and $FF00  ) shr 8 )*((w-a)/w) );
                  if g1>255 then g1:=255;

                  b1:=round( ((g and $FF0000) shr 16)*(a/w) + ((kolg and $FF0000) shr 16)*((w-a)/w) );
                  if b1>255 then b1:=255;

                  g:=$FF000000 + (b1 shl 16) + (g1 shl 8) + r1 ;
                  end;
                2:begin {zaciemnianie}
                  a:=(w-abs(a))*4;;
                  r1:=(g and $FF) - a;
                  if r1<0 then r1:=0;

                  g1:=(g and $FF00) shr 8 - a;
                  if g1<0 then g1:=0;

                  b1:=(g and $FF0000) shr 16 - a;
                  if b1<0 then b1:=0;

                  g:=$FF000000 + (b1 shl 16) + (g1 shl 8) + r1 ;
                  end;
                3:begin {rozjasnianie}
                  a:=(w-abs(a))*4;;
                  r1:=(g and $FF) + a;
                  if r1>255 then r1:=255;

                  g1:=(g and $FF00) shr 8 + a;
                  if g1>255 then g1:=255;

                  b1:=(g and $FF0000) shr 16 + a;
                  if b1>255 then b1:=255;

                  g:=$FF000000 + (byte(b1) shl 16) + (byte(g1) shl 8) + r1 ;
                  end;
              end;
           end;

        end else
           g:=$00000000;

        if (teren.maska[x,y]>0) or (rysujtex) then
           pdrawFormatConv(@g, DestPtr, D3DFMT_A8R8G8B8, obr.teren.surf.Format);
    end;

obr.teren.surf.unLock(0);
end;

procedure teren_ustawrozmiary(tx,ty:integer);
begin
teren.ileekrx:=(ekran.width+128) div 128;
teren.ileekry:=(ekran.height+128) div 128;

teren.ilex:=(tx) div 128;
teren.iley:=(ty) div 128;
end;

procedure rysujteren(rozmx,rozmy:integer);
var
a,a1,oy,ox,
x,y,y1:integer;

tx,ty:integer;

dx,dy,czas,r:integer;
kk:byte;

podloze,obiekty,miny,przedmioty:boolean;
podlozeteraz, odwroctmp:boolean;

begin
log('Rysowanie terenu');

if obr.teren.surf<>nil then begin
   obr.teren.surf.Free;
   obr.teren.surf:=nil;
end;
obr.teren.surf:=TAGFImage.Create(form1.PowerDraw1);

 a:=0;
 while (a<high(dozwrozm)) and (dozwrozm[a]<rozmx) do inc(a);
 tx:=dozwrozm[a];
 a:=0;
 while (a<high(dozwrozm)) and (dozwrozm[a]<rozmy) do inc(a);
 ty:=dozwrozm[a];

log('  Inicjalizacja tekstury: rx='+l2t(rozmx,0)+', ry='+l2t(rozmy,0));
if (teren.width<=ekran.width+100) and (teren.height<=ekran.height+100) then begin
       obr.teren.surf.Initialize(tx,ty,1,teren.width,teren.height,D3DFMT_A8R8G8B8);
       teren.ilex:=0;
   end else begin
       obr.teren.surf.Initialize(tx,ty,1,128,128,D3DFMT_A8R8G8B8);
       teren_ustawrozmiary(tx,ty);
   end;


obr.teren.rx:=rozmx;
obr.teren.ry:=rozmy;
obr.teren.ofsx:=obr.teren.rx div 2;
obr.teren.ofsy:=obr.teren.ry div 2;
obr.teren.klatek:=obr.teren.surf.PatternCount;


log('  Tworzenie maski');
setlength(teren.maska, rozmx+1);
for x:=rozmx-1 downto 0 do
    setlength(teren.maska[x],rozmy+31);
form1.popraw_dol_maski_terenu;

{teren.width:=obr.teren.surf.PatternWidth;
teren.height:=obr.teren.surf.PatternHeight;}

for y:=0 to teren.height-1 do
    for x:=0 to teren.width-1 do
        teren.maska[x,y]:=0;
{}

podloze:=ustawienia_terenu.podloze;
miny:=ustawienia_terenu.miny;
przedmioty:=ustawienia_terenu.przedmioty;
obiekty:=ustawienia_terenu.obiekty;

podlozeteraz:=podloze;

if podloze then begin
    x:=0;
    r:=random(90)+60;
    y:=teren.height-random(r div 2);
    dx:=10;
    dy:=-5+random(11);
end else begin
    x:=random(teren.width-1);
    r:=random(130)+20;
    y:=(40+r*2)+random(teren.height-(40+r*2)-1);
    dx:=0;
    dy:=0;
end;

log('  Rysowanie');

czas:=6000;
kk:=4+random(6);

while czas>0 do begin
   if random(20)=0 then begin
      r:=r-10+random(21);
      if r<20+ord(podlozeteraz)*40 then r:=20+ord(podlozeteraz)*40;
      if r>150 then r:=150;
   end;
   if not podlozeteraz and (random(10)=0) then begin
      dx:=random(20)-11;
   end;
   if random(10)=0 then begin
      dy:=random(20)-11;
   end;

   if not podlozeteraz and (random(400)=0) then begin
      x:=random(teren.width-1);
      r:=random(140)+10;
      y:=(40+r*2)+random(teren.height-(40+r*(2+ord(podloze)*3))-1);
      kk:=random(2)*(4+random(6));
   end;

   x:=x+dx;
   y:=y+dy;

   if x<0 then dx:=abs(dx);
   if not podlozeteraz and (y<40+r*2) then dy:=abs(dy);
   if podlozeteraz and (y<teren.height-r div 2) then dy:=abs(dy);
   if not podlozeteraz and (x>teren.width-1) then dx:=-abs(dx);
   if podlozeteraz and (x>teren.width-1) then begin
      podlozeteraz:=false;
      x:=random(teren.width-1);
      r:=random(140)+10;
      y:=(40+r*2)+random(teren.height-(40+r*5)-1);
   end;
   if not podlozeteraz and (y>teren.height-1-(ord(podloze)*r*2)) then dy:=-abs(dy);
   if podlozeteraz and (y>teren.height) then dy:=-abs(dy);

   rysuj_kolko_maska(x,y,r,kk);

   dec(czas);
end;


{cieniowanie}
log('  Cieniowanie');
//form1.wczytajteksture(listyplikow[1][random(rysmenuuklad[1][3].mx+1)]);
form1.wczytajteksture(wlasc_scenariusza.tekstura+'.tga');

zrob_trawe(0,0,teren.width-1,teren.height-1,
           wlasc_scenariusza.wierzch[0].kol,wlasc_scenariusza.wierzch[1].kol,
           wlasc_scenariusza.wierzch[0].ef,wlasc_scenariusza.wierzch[1].ef,
           true);

//zrob_trawe(0,0,teren.width-1,teren.height-1, $efefff,$202090,1,2,true);
//zrob_trawe(0,0,teren.width-1,teren.height-1, $30A010,$202090,1,2,true);

{stawianie obiektow}
if (obiekty) and (length(wlasc_scenariusza.obiekty)>=1) then begin
    log('  Obiekty');
    rysowanie.maskowanie:=1;
    czas:=5+random(60);
    odwroctmp:=rysowanie.odwrocony;
    while czas>0 do begin
       {losuj miejsce}
       x:=random(teren.width-1);
       y:=random(teren.height-3)+1;

       if (teren.maska[x,y]>=1) then begin
          while (y>0) and (teren.maska[x,y]>=1) do dec(y);
       end else
       begin
          while (y<teren.height-1) and (teren.maska[x,y]=0) do inc(y);
       end;

       {znalezione miejsce}
       if (y>0) and (y<teren.height-1) then begin
          a:=0;
          {wkop sie 10 pixeli}
          while (y<teren.height-1) and (teren.maska[x,y]>=1) and (a<10) do begin
                inc(y);
                inc(a);
          end;

          {wczytaj losowy obiekt}
          //form1.wczytajobiekt(listyplikow[0][random(rysmenuuklad[2][3].mx+1)]);
          form1.wczytajobiekt(listyplikow[0][ wlasc_scenariusza.obiekty[ random(length(wlasc_scenariusza.obiekty)) ].nr ]);

          oy:=obr.obiekt.Height;
          repeat
              dec(oy);
              a:=0;
              while (a<obr.obiekt.Width) and {obr.obiekt.Canvas.Pixels[a,obr.obiekt.Height-1]}
                    (cardinal(pointer( integer(obr.obiekt.ScanLine[oy]) + integer(a*4) )^) and $FF000000=0) do inc(a);

              a1:=obr.obiekt.Width-1;
              while (a1>0) and //(obr.obiekt.Canvas.Pixels[a1,obr.obiekt.Height-1) do dec(a);
                    (cardinal(pointer( integer(obr.obiekt.ScanLine[oy]) + integer(a1*4) )^) and $FF000000=0) do dec(a1);

          until (a<=a1) or (y<=0); {powtarzaj jak nie znaleziono ani pixela na dole}
          if (oy>=0) then begin {jesli w ogole znaleziono cos... raczej zawsze powinno byc!}
             rysowanie.odwrocony:=boolean(random(2));
         //    rysowanie.odwrocony:=true;
             if rysowanie.odwrocony then ox:=obr.obiekt.Width-((a1-a) div 2+a)
                                    else ox:=(a1-a) div 2+a;
             rysowanie.ztylu:=true;//boolean(random(2));
//             rysuj_obiekt(x{-obr.obiekt.Width div 2}{-ox},y-oy{-obr.obiekt.Height},0);
             rysuj_obiekt(x{-obr.obiekt.Width div 2}-ox,y-oy{-obr.obiekt.Height},0);
          end;
       end;

       dec(czas);
    end;
    rysowanie.odwrocony:=odwroctmp;
end;

{stawianie min}
if miny then begin
    log('  Dodawanie min');
    czas:=1+random(15);
    while czas>0 do begin
       {losuj miejsce}
       x:=random(teren.width-1);
       y:=random(teren.height-3)+1;

       if (teren.maska[x,y]>=1) then begin
          while (y>0) and (teren.maska[x,y]>=1) do dec(y);
       end else
       begin
          while (y<teren.height-1) and (teren.maska[x,y]=0) do inc(y);
       end;

       {znalezione miejsce}
       if (y>0) and (y<teren.height-1) then begin
          if (warunki.typ_wody>=1) and (y>warunki.wys_wody) then a:=1 //miny podwodne
                                  else a:=random(2)*2; //miny ladowe lub beczki
          if a=2 then dec(y,5);
          rzucmine(x,y,0,0,0,random(5)=0,a);
       end;

       dec(czas);
    end;
    if (warunki.typ_wody=1) then begin //dodaj tez miny zawieszone
        czas:=1+random(10);
        while czas>0 do begin
           {losuj miejsce}
           x:=random(teren.width-1);
           y:=random(warunki.gleb_wody)+warunki.wys_wody;

           if (y>=0) and (y<teren.height-1) and (teren.maska[x,y]=0) then begin
              y1:=y;
              while (y<teren.height-1) and (teren.maska[x,y]=0) do inc(y);
              if (y<teren.height-1) then begin
                 {znalezione miejsce}
                 rzucmine(x,y1,0,0,0,random(10)=0,1,true,x,y);
              end;

           end;


           dec(czas);
        end;

    end;
end;

{stawianie przedmiotow}
if przedmioty then begin
    log('  Dodawanie przedmiotow');
    czas:=1+random(15);
    while czas>0 do begin
       {losuj miejsce}
       x:=random(teren.width-1);
       y:=random(teren.height-3)+1;

       if (teren.maska[x,y]>=1) then begin
          while (y>0) and (teren.maska[x,y]>=1) do dec(y);
       end else
       begin
          while (y<teren.height-1) and (teren.maska[x,y]=0) do inc(y);
       end;

       {znalezione miejsce}
       if (y>0) and (y<teren.height-1) then begin
          a:=random(ile_przedm+1);
          if (a=5) and ((warunki.typ_wody=0) or (y<warunki.wys_wody)) then a:=0;

          nowyprzedmiot(x,y,0,0,0,random(ile_przedm));
       end;

       dec(czas);
    end;
end;

{przywroc ustawienia tekstur}
log('  Przywracanie wybranej tekstury i obiektu');
form1.wczytajteksture(listyplikow[1][rysmenuuklad[1][3].wartosc]);
form1.wczytajobiekt(listyplikow[0][rysmenuuklad[2][3].wartosc]);

with rysowanie do begin
     kolor:= $FF000000 or
                   (byte(rysmenuuklad[0][0].wartosc) shl 16) or
                   (byte(rysmenuuklad[0][3].wartosc) shl 8) or
                   byte(rysmenuuklad[0][6].wartosc);
     twardosc:=rysmenuuklad[0][1].wartosc; rysmenuuklad[1][1].wartosc:=rysmenuuklad[0][1].wartosc; rysmenuuklad[2][1].wartosc:=rysmenuuklad[0][1].wartosc;
     rozmiar:=rysmenuuklad[0][2].wartosc; rysmenuuklad[1][2].wartosc:=rysmenuuklad[0][2].wartosc;
     ziarna:=rysmenuuklad[0][4].wartosc;
     ksztaltpedzla:=rysmenuuklad[0][5].wartosc; rysmenuuklad[1][5].wartosc:=rysmenuuklad[0][5].wartosc;
     ztylu:=boolean(rysmenuuklad[0][8].wartosc); rysmenuuklad[1][8].wartosc:=rysmenuuklad[0][8].wartosc; rysmenuuklad[2][9].wartosc:=rysmenuuklad[0][8].wartosc;
     maskowanie:=rysmenuuklad[0][7].wartosc; rysmenuuklad[1][7].wartosc:=rysmenuuklad[0][7].wartosc; rysmenuuklad[2][8].wartosc:=rysmenuuklad[0][7].wartosc;
end;


log('  Koniec rysowania');
end;




end.
