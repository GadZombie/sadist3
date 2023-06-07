unit UnitScenIO;

interface
uses classes, windows, sysutils, controls, unitstringi, stdctrls;

type
Tnaglowek=array[0..9] of char;

const
naglowek:Tnaglowek=('S','3','S','c','e','n','r','1','0','0');

procedure zapisz_scen(nazwa:string);
procedure wczytaj_scen(nazwa:string);

implementation
uses unit1, vars;
var hnd:integer;

function wartosc(s:string):int64; overload;
var i:integer;
begin
  val(s,result,i);
end;

function odwrocRGBnaBGR(k:cardinal):cardinal;
begin
result:=
    (k and $00FF0000) shr 16 +
    (k and $0000FF00) +
    (k and $000000FF) shl 16;
end;

function wczytajstring(var plik:TStream):string;
var
  buf:shortstring;
  bufa:array[0..254] of byte;
  d:word;
  d1:byte;
  m,dl:longint;
  t:string;
begin
    plik.readbuffer(dl,sizeof(dl)); {length(t):=dl}
    m:=1;
    t:='';
    while m<=dl do begin
       if dl-(m-1)>255 then d:=255
          else d:=dl-(m-1);
       plik.readbuffer(bufa,d);
       move(bufa,buf[1],d);
       d1:=d;
       buf[0]:=chr(d1);

       t:=t+copy(buf,1,d);
       inc(m,d);
    end;
    if t=#1#2 then t:='';
    wczytajstring:=t;
end;

procedure zapiszstring(var plik:TStream;t:string);
var
  buf:shortstring;
  d:word;
  m,l:longint;
  bufa:array[0..254] of byte;
begin
 {$I-}
    if t='' then t:=#1#2;
    l:=length(t);
    plik.WriteBuffer(l,sizeof(l));
    m:=1;
    while m<=length(t) do begin
       if length(t)-(m-1)>255 then d:=255
          else d:=length(t)-(m-1);
       buf:=copy(t,m,d);
       move(buf[1],bufa,d);
       plik.WriteBuffer(bufa,d);
       inc(m,d);
    end;
end;


procedure zapisz_scen(nazwa:string);
var p:TStream; a:integer;

 procedure zapiszB(i:boolean);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

 procedure zapiszBt(i:byte);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

 procedure zapiszI(i:integer);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

 procedure zapiszC(i:cardinal);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

 procedure zapiszD(i:tdate);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

 procedure zapiszcz(i:ttime);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

begin
try
   p:=TFileStream.Create('Scenarios\'+nazwa+'.S3Sce', fmCreate);

   p.writebuffer(naglowek,sizeof(naglowek));

   zapiszstring(p,form1.nnazwa.text);
   zapiszstring(p,form1.nautor.text);
   zapiszD(form1.ndatastworzenia.Date);

   {najpierw kolory tla, zeby latwo bylo je wczytac osobno}
   for a:=0 to 23 do begin
       zapiszB(niebo.kolorytla[a].zmiana);
       zapiszBt(niebo.kolorytla[a].gr);
       zapiszBt(niebo.kolorytla[a].gg);
       zapiszBt(niebo.kolorytla[a].gb);
       zapiszBt(niebo.kolorytla[a].dr);
       zapiszBt(niebo.kolorytla[a].dg);
       zapiszBt(niebo.kolorytla[a].db);
   end;

   {potem cala reszta}
   zapiszB(form1.widslon.Checked);
   zapiszB(form1.winksie.Checked);
   zapiszB(form1.widgwia.Checked);
   zapiszB(form1.widchmu.Checked);
   zapiszB(form1.widdeszsnie.Checked);

   zapiszI(form1.szybczas.Value);

   zapiszI(Form1.wybobi.Items.Count);
   for a:=0 to Form1.wybobi.Items.Count-1 do
       zapiszstring(p,Form1.wybobi.Items[a]);

   zapiszstring(p,ustawienia.wybranatex);

   zapiszI(ustawienia.wierzchr[0]);
   zapiszC(odwrocRGBnaBGR(ustawienia.wierzchk[0]));
   zapiszI(ustawienia.wierzchr[1]);
   zapiszC(odwrocRGBnaBGR(ustawienia.wierzchk[1]));

   zapiszB(form1.ciecz0.Checked);
   zapiszB(form1.ciecz1.Checked);
   zapiszB(form1.ciecz2.Checked);
   zapiszB(form1.ciecz3.Checked);
   zapiszB(form1.ciecz4.Checked);
   zapiszB(form1.ciecz5.Checked);

   p.Free;
except
   p.Free;
   MessageBox(hnd, 'Blad przy zapisie pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
end;

end;


procedure wczytaj_scen(nazwa:string);
var
  p:TStream;
  a,b:integer;
  tmp:Tnaglowek;

 function wczytajB:boolean;
 var b:boolean;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajB:=b;
 end;

 function wczytajBt:byte;
 var b:byte;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajBt:=b;
 end;

 function wczytajI:integer;
 var b:integer;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajI:=b;
 end;

 function wczytajC:Cardinal;
 var b:cardinal;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajC:=b;
 end;

 function wczytajD:TDate;
 var b:TDate;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajD:=b;
 end;

begin
if FileExists('Scenarios\'+nazwa+'.S3Sce') then begin
  try
   p:=TFileStream.Create('Scenarios\'+nazwa+'.S3Sce',fmOpenRead);

   p.readbuffer(tmp,sizeof(tmp));

   if tmp<>naglowek then Raise EReadError.Create('Zly naglowek');

   form1.nnazwa.text:=wczytajstring(p);
   form1.nautor.text:=wczytajstring(p);
   form1.ndatastworzenia.Date:=wczytajD;

   {najpierw kolory tla, zeby latwo bylo je wczytac osobno}
   for a:=0 to 23 do begin
       niebo.kolorytla[a].zmiana:=wczytajB;
       niebo.kolorytla[a].gr:=wczytajBt;
       niebo.kolorytla[a].gg:=wczytajBt;
       niebo.kolorytla[a].gb:=wczytajBt;
       niebo.kolorytla[a].dr:=wczytajBt;
       niebo.kolorytla[a].dg:=wczytajBt;
       niebo.kolorytla[a].db:=wczytajBt;

       Tla[a].wlacz.Checked:=niebo.kolorytla[a].zmiana;
   end;

   {potem cala reszta}
   form1.widslon.Checked:=wczytajB;
   form1.winksie.Checked:=wczytajB;
   form1.widgwia.Checked:=wczytajB;
   form1.widchmu.Checked:=wczytajB;
   form1.widdeszsnie.Checked:=wczytajB;

   form1.szybczas.Value:=wczytajI;

   b:=wczytajI;
   Form1.wybobi.Clear;
   for a:=0 to b-1 do
       Form1.wybobi.Items.Add(wczytajstring(p));

   ustawienia.wybranatex:=wczytajstring(p);

   ustawienia.wierzchr[0]:=wczytajI;
   ustawienia.wierzchk[0]:=odwrocRGBnaBGR(wczytajC);
   ustawienia.wierzchr[1]:=wczytajI;
   ustawienia.wierzchk[1]:=odwrocRGBnaBGR(wczytajC);

   form1.ciecz0.Checked:=wczytajB;
   form1.ciecz1.Checked:=wczytajB;
   form1.ciecz2.Checked:=wczytajB;
   form1.ciecz3.Checked:=wczytajB;
   form1.ciecz4.Checked:=wczytajB;
   form1.ciecz5.Checked:=wczytajB;

   form1.wybtex.Caption:=ustawienia.wybranatex;

   form1.wierzchrodz.Caption:='Rodzaj= '+inttostr(ustawienia.wierzchr[0]);
   form1.spodrodz.Caption:='Rodzaj= '+inttostr(ustawienia.wierzchr[1]);
   form1.wierzch.Repaint;
   form1.spod.Repaint;

   p.free;
  except
     p.free;
     MessageBox(hnd, 'Blad przy odczycie pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
  end;
end else begin
   MessageBox(hnd, 'Nie ma takiego pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
end;

end;



end.
