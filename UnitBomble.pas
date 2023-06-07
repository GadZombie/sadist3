unit UnitBomble;

interface
uses Graphics, Types, vars;

    procedure nowybombel(sx,sy,dx_,dy_:real; przezr:smallint;wielkosc_:integer);
    procedure ruszaj_bomble;
    procedure rysuj_bomble;

implementation
uses unit1, powertypes, unitefekty;

procedure nowybombel(sx,sy,dx_,dy_:real; przezr:smallint;wielkosc_:integer);
var a,b:longint;
begin
a:=0;
b:=0;
while (b<max_bombel) and (bombel[a].jest) do begin
   inc(a);
   inc(b);
   if a>=max_bombel then a:=0;
end;
if b>=max_bombel then
   a:=random(max_bombel);
{if not bombel[a].jest then }
with bombel[a] do begin
   x:=sx;
   y:=sy;
   dx:=dx_;
   dy:=dy_;
   jest:=true;
   if wielkosc_=0 then begin
      wielkosc:=256;
   end else
       wielkosc:=wielkosc_;
   przezroczysty:=byte(przezr);
end;

end;

procedure ruszaj_bomble;
var a:longint;
wyswodywx:integer;
begin

for a:=0 to max_bombel do
  if bombel[a].jest then with bombel[a] do begin
    x:=x+dx;
    y:=y+dy;
    wyswodywx:=wyswody(x);

    if dy>-gestosci[warunki.typ_wody].maxy*1.5 then dy:=dy-0.07;
    x:=x+random-0.5;

    if (y<=wyswodywx) or (warunki.typ_wody in [0,2]) then jest:=false;

  end;
//form1.DXDraw1.Surface.Canvas.Release;
end;


procedure rysuj_bomble;
var a:longint;
begin
for a:=0 to max_bombel do
  if bombel[a].jest then with bombel[a] do begin

    {    sx:= (obr.bombel.surf.PatternWidth * wielkosc) div 256;
        sy:= (obr.bombel.surf.PatternHeight * wielkosc) div 256;  }

        form1.PowerDraw1.RenderEffectcol(obr.bombel.surf,trunc(x)-obr.bombel.ofsx-ekran.px,trunc(y)-obr.bombel.ofsy-ekran.py,
                   wielkosc,
                   cardinal((przezroczysty shl 24) or $FFFFFF),
                   random(2),
                   effectSrcAlpha or effectDiffuse);

end;
end;



end.
