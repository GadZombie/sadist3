unit sinusy;
interface
{$G+}
var sintab:array[-359..449] of real;

procedure _InitCosin;
function _Sin(alfa:longint):real;
function _Cos(alfa:longint):real;

implementation

procedure _InitCosin;
var alfa:integer;
begin
  for alfa:=-359 to 449 do sintab[alfa]:=sin(alfa*Pi/180);
end;

function _Sin(alfa:longint):real;
begin
  _Sin:=sintab[alfa mod 360];
end;

function _Cos(alfa:longint):real;
begin
  _Cos:=sintab[90+(alfa mod 360)];
end;

end.
