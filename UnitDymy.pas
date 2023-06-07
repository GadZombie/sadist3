unit UnitDymy;

interface
uses Graphics, Types, vars;

{    procedure nowydym(sx,sy,dx_,dy_:real; rod:byte;sz:byte; przezr:smallint);
    procedure ruszaj_dymy;
    procedure rysuj_dymy;
}
implementation
uses unit1, DDUtil;
{const
dym_ilosciklatek:array[0..0] of byte=(25);

procedure nowydym(sx,sy,dx_,dy_:real; rod:byte;sz:byte; przezr:smallint);
var a,b:longint;
begin
a:=dym_nowy;
b:=0;
while (b<max_dym) and (dym[a].jest) do begin
   inc(a);
   inc(b);
   if a>=max_dym then a:=0;
end;
if not dym[a].jest then with dym[a] do begin
   x:=sx;
   y:=sy;
   dx:=dx_;
   dy:=dy_;
   jest:=true;
   rodz:=rod;
   klatka:=0;
   szyb:=sz;
   dosz:=0;
   przezroczysty:=przezr;
end;

end;

procedure ruszaj_dymy;
var a,k:longint; tr:trect; px,py:integer; p1,p2:prect;
begin
for a:=0 to max_dym do
  if dym[a].jest then with dym[a] do begin
    x:=x+dx;
    y:=y+dy;

    inc(dosz);
    if dosz>=szyb then begin
       inc(klatka);
       if klatka>=dym_ilosciklatek[rodz] then jest:=false;
       dosz:=0;
    end;
    if (przezroczysty>=10) then dec(przezroczysty,10);

  end;
//form1.DXDraw1.Surface.Canvas.Release;
end;


procedure rysuj_dymy;
var a,k:longint; tr:trect; px,py:integer; p1,p2:prect;
begin
for a:=0 to max_dym do
  if dym[a].jest then with dym[a] do begin
       if przezroczysty>0 then
        form1.drawsprajtalpha(obr.dym[rodz],trunc(x-obr.dym[rodz].ofsx)-ekran.px,trunc(y-obr.dym[rodz].ofsy)-ekran.py,klatka,przezroczysty)
       else
        form1.drawsprajt(obr.dym[rodz],trunc(x-obr.dym[rodz].ofsx)-ekran.px,trunc(y-obr.dym[rodz].ofsy)-ekran.py,klatka);

end;
//form1.DXDraw1.Surface.Canvas.Release;
end;


 }
end.
