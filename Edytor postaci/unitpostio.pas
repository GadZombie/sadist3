unit UnitpostIO;

interface
uses classes, windows, sysutils, controls, unitstringi, stdctrls, graphics, unitprogres, forms, spin, FileCtrl;

type
Tnaglowek=array[0..8] of char;

const
naglowek:Tnaglowek=('S','3','T','e','a','m','1','0','0');

procedure zapisz_misje(nazwa:string);
procedure wczytaj_misje(nazwa:string);

function wczytaj_animacje(var ktora:TBitmap; nazwa:string; rrx:integer):boolean;

procedure spakujpliki(nazwaplikupostaci:string);
procedure Wczytajdruzyne(nazwaplikupostaci:string); {bez rozszerzenia i podkatalogow!}
procedure oczysc_pliki_tmp_druzyn;
procedure Nowadruzyna;

implementation
uses unit1, vars;
var hnd:integer;

function wartosc(s:string):int64; overload;
var i:integer;
begin
  val(s,result,i);
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

function wczytajstring2(var plik:file):string;
var
  buf:shortstring;
  bufa:array[0..254] of byte;
  d:word;
  d1:byte;
  m,dl:longint;
  t:string;
begin
    blockread(plik, dl,sizeof(dl)); {length(t):=dl}
    m:=1;
    t:='';
    while m<=dl do begin
       if dl-(m-1)>255 then d:=255
          else d:=dl-(m-1);
       blockread(plik, bufa,d);
       move(bufa,buf[1],d);
       d1:=d;
       buf[0]:=chr(d1);

       t:=t+copy(buf,1,d);
       inc(m,d);
    end;
    if t=#1#2 then t:='';
    wczytajstring2:=t;
end;

procedure zapiszstring2(var plik:file;t:string);
var
  buf:shortstring;
  d:word;
  m,l:longint;
  bufa:array[0..254] of byte;
begin
 {$I-}
    if t='' then t:=#1#2;
    l:=length(t);
    blockwrite(plik, l,sizeof(l));
    m:=1;
    while m<=length(t) do begin
       if length(t)-(m-1)>255 then d:=255
          else d:=length(t)-(m-1);
       buf:=copy(t,m,d);
       move(buf[1],bufa,d);
       blockwrite(plik, bufa,d);
       inc(m,d);
    end;
end;


procedure zapisz_misje(nazwa:string);
var p:TStream; a:integer;

 procedure zapiszB(i:boolean);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

 procedure zapiszI(i:integer);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

 procedure zapiszI64(i:int64);
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

 procedure zapiszCH(i:TCheckboxstate);
 var a1,a2:byte;
 begin
    case i of          {jest?}{MUSI}
      cbUnchecked:begin a1:=0; a2:=0 end;
      cbGrayed:   begin a1:=1; a2:=0 end;
      cbChecked:  begin a1:=1; a2:=1 end;
    end;
    p.WriteBuffer(a1,sizeof(a1));
    p.WriteBuffer(a2,sizeof(a2));
 end;

begin
try
   p:=TFileStream.Create('Teams\'+nazwa+'.S3P', fmCreate);

   p.writebuffer(naglowek,sizeof(naglowek));

{   zapiszstring(p,ustawienia.wybranyteren);

   zapiszstring(p,form1.nnazwa.text);
   zapiszstring(p,form1.nautor.text);
   zapiszstring(p,form1.nopis.text);
   zapiszD(form1.ndatastworzenia.Date);
   zapiszI64(wartosc(form1.nnagroda.Text));

   zapiszB(form1.njestczas.Checked);
   zapiszcz(form1.nileczasu.Time);
   zapiszB(form1.nsterowanie.Checked);
   zapiszi(form1.nsterowanapostac.Value);
   zapiszB(form1.nwlaczonykursor.Checked);
   zapiszB(form1.nzmianawarunkow.Checked);
   zapiszB(form1.nrysowanie.Checked);
   zapiszB(form1.nzmianawejsc.Checked);
   zapiszB(form1.nzmianadruzyn.Checked);

   zapiszCH(form1.nwyp_czas.State);
   zapiszCH(form1.nwyp_zginie.State);
   zapiszI(form1.nwyp_zginieile.Value);
   zapiszI(form1.nwyp_zginiegrup.Value);
   zapiszCH(form1.nwyp_dojdzie.State);
   zapiszI(form1.nwyp_dojdzieile.Value);
   zapiszI(form1.nwyp_dojdziegrup.Value);
   zapiszCH(form1.nwyp_zebrane.State);
   zapiszI(form1.nwyp_zebraneile.Value);
   zapiszCH(form1.nwyp_zniszczone.State);
   zapiszI(form1.nwyp_zniszczoneile.Value);

   zapiszCH(form1.nprzeg_czas.State);
   zapiszCH(form1.nprzeg_zginie.State);
   zapiszI(form1.nprzeg_zginieile.Value);
   zapiszI(form1.nprzeg_zginiegrup.Value);
   zapiszCH(form1.nprzeg_dojdzie.State);
   zapiszI(form1.nprzeg_dojdzieile.Value);
   zapiszI(form1.nprzeg_dojdziegrup.Value);
   zapiszCH(form1.nprzeg_zebrane.State);
   zapiszI(form1.nprzeg_zebraneile.Value);
   zapiszCH(form1.nprzeg_zniszczone.State);
   zapiszI(form1.nprzeg_zniszczoneile.Value);

   for a:=0 to max_broni do
       zapiszI(wartosc(form1.namunicja.Cells[1,1+a]));

   zapiszI(high(flagi));
   for a:=0 to high(flagi) do begin
       zapiszI(flagi[a].x);
       zapiszI(flagi[a].y);
       zapiszI(flagi[a].rodz);
   end;
   zapiszI(high(prostokaty));
   for a:=0 to high(prostokaty) do begin
       zapiszI(prostokaty[a].x1);
       zapiszI(prostokaty[a].y1);
       zapiszI(prostokaty[a].x2);
       zapiszI(prostokaty[a].y2);
       zapiszI(prostokaty[a].rodz);
   end;

   for a:=0 to max_druzyn do begin
       zapiszstring(p,form1.ndruzyny.Cells[1,1+a]);
       zapiszI(wartosc(form1.ndruzyny.Cells[2,1+a]));
       zapiszI(wartosc(form1.ndruzyny.Cells[3,1+a]));
       zapiszB(boolean(wartosc(form1.ndruzyny.Cells[4,1+a])));
       zapiszI(wartosc(form1.ndruzyny.Cells[5,1+a]));
       zapiszI(wartosc(form1.ndruzyny.Cells[6,1+a]));
       zapiszI(wartosc(form1.ndruzyny.Cells[7,1+a]));
       zapiszI(wartosc(form1.ndruzyny.Cells[8,1+a]));
   end;

   zapiszI(ile_kolesi);
   for a:=0 to ile_kolesi-1 do begin
       zapiszI(koles[a].team);
       zapiszI(trunc(koles[a].x));
       zapiszI(trunc(koles[a].y));
       zapiszI(koles[a].sila);
       zapiszI(koles[a].kierunek);
       zapiszI(koles[a].corobi);
       zapiszI(koles[a].bron);
       zapiszI(koles[a].amunicja);
       zapiszB(koles[a].palisie);
   end;
}
   p.Free;
except
   p.Free;
   MessageBox(hnd, 'Blad przy zapisie pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
end;

end;


procedure wczytaj_misje(nazwa:string);
var
  p:TStream;
  a:integer;
  tmp:Tnaglowek;

 function wczytajB:boolean;
 var b:boolean;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajB:=b;
 end;

 function wczytajI:integer;
 var b:integer;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajI:=b;
 end;

 function wczytajI64:int64;
 var b:int64;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajI64:=b;
 end;

 function wczytajD:TDate;
 var b:TDate;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajD:=b;
 end;

 function wczytajcz:TTime;
 var b:TTime;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajcz:=b;
 end;

 function wczytajCH:TCheckBoxState;
 var a1,a2:byte;
 begin
    p.ReadBuffer(a1,sizeof(a1));
    p.ReadBuffer(a2,sizeof(a2));
    if (a1=0) and (a2=0) then wczytajCH:=cbUnchecked;
    if (a1=1) and (a2=0) then wczytajCH:=cbGrayed;
    if (a1=1) and (a2=1) then wczytajCH:=cbChecked;
 end;

begin
if FileExists('Teams\'+nazwa+'.S3P') then begin
  try
   p:=TFileStream.Create('Teams\'+nazwa+'.S3P',fmOpenRead);

   p.readbuffer(tmp,sizeof(tmp));

   if tmp<>naglowek then Raise EReadError.Create('Zly naglowek');

{   ustawienia.wybranyteren:=wczytajstring(p);

   form1.nnazwa.text:=wczytajstring(p);
   form1.nautor.text:=wczytajstring(p);
   form1.nopis.text:=wczytajstring(p);
   form1.ndatastworzenia.Date:=wczytajD;
   form1.nnagroda.Text:=l2t(wczytajI64,0);

   form1.njestczas.Checked:=wczytajB;
   form1.nileczasu.Time:=wczytajcz;
   form1.nsterowanie.Checked:=wczytajB;
   form1.nsterowanapostac.Value:=wczytajI;
   form1.nwlaczonykursor.Checked:=wczytajB;
   form1.nzmianawarunkow.Checked:=wczytajB;
   form1.nrysowanie.Checked:=wczytajB;
   form1.nzmianawejsc.Checked:=wczytajB;
   form1.nzmianadruzyn.Checked:=wczytajB;

   form1.nwyp_czas.State:=wczytajCH;
   form1.nwyp_zginie.State:=wczytajCH;
   form1.nwyp_zginieile.Value:=wczytajI;
   form1.nwyp_zginiegrup.Value:=wczytajI;
   form1.nwyp_dojdzie.State:=wczytajCH;
   form1.nwyp_dojdzieile.Value:=wczytajI;
   form1.nwyp_dojdziegrup.Value:=wczytajI;
   form1.nwyp_zebrane.State:=wczytajCH;
   form1.nwyp_zebraneile.Value:=wczytajI;
   form1.nwyp_zniszczone.State:=wczytajCH;
   form1.nwyp_zniszczoneile.Value:=wczytajI;

   form1.nprzeg_czas.State:=wczytajCH;
   form1.nprzeg_zginie.State:=wczytajCH;
   form1.nprzeg_zginieile.Value:=wczytajI;
   form1.nprzeg_zginiegrup.Value:=wczytajI;
   form1.nprzeg_dojdzie.State:=wczytajCH;
   form1.nprzeg_dojdzieile.Value:=wczytajI;
   form1.nprzeg_dojdziegrup.Value:=wczytajI;
   form1.nprzeg_zebrane.State:=wczytajCH;
   form1.nprzeg_zebraneile.Value:=wczytajI;
   form1.nprzeg_zniszczone.State:=wczytajCH;
   form1.nprzeg_zniszczoneile.Value:=wczytajI;

   for a:=0 to max_broni do
       form1.namunicja.Cells[1,1+a]:=l2t(wczytajI,0);

   a:=wczytajI;
   setlength(flagi,a+1);
   for a:=0 to high(flagi) do begin
       flagi[a].x:=wczytajI;
       flagi[a].y:=wczytajI;
       flagi[a].rodz:=wczytajI;
   end;
   a:=wczytajI;
   setlength(prostokaty,a+1);
   for a:=0 to high(prostokaty) do begin
       prostokaty[a].x1:=wczytajI;
       prostokaty[a].y1:=wczytajI;
       prostokaty[a].x2:=wczytajI;
       prostokaty[a].y2:=wczytajI;
       prostokaty[a].rodz:=wczytajI;
   end;

   for a:=0 to max_druzyn do begin
       form1.ndruzyny.Cells[1,1+a]:=wczytajstring(p);
       form1.ndruzyny.Cells[2,1+a]:=l2t(wczytajI,0);
       form1.ndruzyny.Cells[3,1+a]:=l2t(wczytajI,0);
       form1.ndruzyny.Cells[4,1+a]:=l2t(ord(wczytajB),0);
       form1.ndruzyny.Cells[5,1+a]:=l2t(wczytajI,0);
       form1.ndruzyny.Cells[6,1+a]:=l2t(wczytajI,0);
       form1.ndruzyny.Cells[7,1+a]:=l2t(wczytajI,0);
       form1.ndruzyny.Cells[8,1+a]:=l2t(wczytajI,0);
   end;

   ile_kolesi:=wczytajI;
   for a:=0 to ile_kolesi-1 do begin
       koles[a].jest:=true;
       koles[a].team:=wczytajI;
       koles[a].x:=wczytajI;
       koles[a].y:=wczytajI;
       koles[a].sila:=wczytajI;
       koles[a].kierunek:=wczytajI;
       koles[a].corobi:=wczytajI;
       koles[a].bron:=wczytajI;
       koles[a].amunicja:=wczytajI;
       koles[a].palisie:=wczytajB;
   end;
}
   p.free;
  except
     p.free;
     MessageBox(hnd, 'Blad przy odczycie pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
  end;
end else begin
   MessageBox(hnd, 'Nie ma takiego pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
end;

end;


function wczytaj_animacje(var ktora:TBitmap; nazwa:string; rrx:integer):boolean;
var
nag:TGAHeader;
p:TStream;
x,y:integer;
c:cardinal;
k:tcolor;

 function wczytajC:cardinal;
 var b:cardinal;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajC:=b;
 end;

begin
try
  p:=TFileStream.Create(nazwa,fmOpenRead);
//  p.readbuffer(nag,sizeof(nag));

  with nag do begin
     p.ReadBuffer(idlength,sizeof(idlength));
     p.ReadBuffer(colourmaptype,sizeof(colourmaptype));
     p.ReadBuffer(datatypecode,sizeof(datatypecode));
     p.ReadBuffer(colourmaporigin,sizeof(colourmaporigin));
     p.ReadBuffer(colourmaplength,sizeof(colourmaplength));
     p.ReadBuffer(colourmapdepth,sizeof(colourmapdepth));
     p.ReadBuffer(x_origin,sizeof(x_origin));
     p.ReadBuffer(y_origin,sizeof(y_origin));
     p.ReadBuffer(width,sizeof(width));
     p.ReadBuffer(height,sizeof(height));
     p.ReadBuffer(bitsperpixel,sizeof(bitsperpixel));
     p.ReadBuffer(imagedescriptor,sizeof(imagedescriptor));
  end;


  if nag.bitsperpixel<>32 then raise Exception.Create('Z³a iloœæ kolorów. TGA musi byæ 32-bitowa.');
  if rrx>0 then begin
     if nag.width<>rrx then raise Exception.Create('Szerokoœæ obrazka musi byæ równa 30 pixeli.');
     if nag.height mod rrx<>0 then raise Exception.Create('Wysokoœæ obrazka musi byæ wielokrotnoœci¹ '+inttostr(rrx)+' pixeli.');
  end;
  if nag.datatypecode<>2 then raise Exception.Create('TGA nie mo¿e byæ skompresowana.');

  if ktora<>nil then begin
     ktora.free;
     ktora:=nil;
  end;
  ktora:=tbitmap.create;
  ktora.PixelFormat:=pf32bit;
  ktora.Width:=nag.width;
  ktora.Height:=nag.height;

  for y:=0 to nag.height-1 do begin
      for x:=0 to nag.width-1 do begin
          c:=wczytajC;
          if (c and $FF000000) shr 24=0 then begin
             if rrx>0 then begin
                if ((x div 4+(y mod rrx) div 4) mod 2)=0 then k:=$FFFFFF
                   else k:=$dfdfdf;
             end else k:=$FF00FF;
          end else
              k:=(c and $FF) shl 16 +
                 (c and $FF00) +
                 (c and $FF0000) shr 16;
          ktora.canvas.pixels[x,nag.height-1-y]:=k;
      end;
  end;

  p.free;
  result:=true;
except
  on e: Exception do begin
      MessageBox(hnd, pchar(E.Message), 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
      p.free;
      result:=false;
      exit;
     end;
  else begin
    MessageBox(hnd, 'Blad przy odczycie pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
    p.free;
    result:=false;
    exit;
  end;
end;

end;

procedure spakujpliki(nazwaplikupostaci:string);
var
  listarozm:array[0..70] of int64;
  ToF: file;
  a,b,b1,n:integer;
  suma:int64;
  d:TDate;
  c:cardinal;

  function rozmiarpliku(nazwa:string):int64;
  var f:file;
  begin
    AssignFile(F, nazwa);
    filemode:=0;
    Reset(F, 1);
    result:=filesize(f);
    closefile(f);
  end;

  procedure dograjplik(nazwa:string);
  var
    FromF: File;
    NumRead, NumWritten: Integer;
    Buf: array[1..2048] of Char;
    s,s1:int64;
  begin
    if (nazwa='') then exit;
    AssignFile(FromF, nazwa);
    filemode:=0;
    Reset(FromF, 1);
    s:=filesize(fromf);
    s1:=0;
    repeat
      BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
      BlockWrite(ToF, Buf, NumRead, NumWritten);
      s1:=s1+numwritten;
    until (NumRead = 0) or (NumWritten <> NumRead);
    CloseFile(FromF);

    formprogres.memo1.lines.add(nazwa+': rozmiar='+inttostr(s)+', zgrano='+inttostr(s1));

    formprogres.pasek.Progress:=formprogres.pasek.Progress+s;
    application.processmessages;
  end;

  procedure zapiszwartosc(s:tspinedit);
  var i:integer;
  begin
    i:=s.value;
    blockwrite(tof, i, sizeof(i));
  end;

begin
  formprogres.pasek.Progress:=0;
  formprogres.Zamknij.Enabled:=false;
  formprogres.Caption:='Zapisywanie pliku';
  formprogres.nazwapl.Caption:=nazwaplikupostaci;
  formprogres.memo1.clear;
  formprogres.show;

  n:=-1;

  AssignFile(ToF, nazwaplikupostaci);
try
  filemode:=1;
  Rewrite(ToF, 1);

  //naglowek
  blockwrite(ToF, naglowek, sizeof(naglowek));

  //ustawienia 1 czesc
  zapiszstring2(Tof, form1.nnazwa.Text);
  zapiszstring2(Tof, form1.nautor.Text);
  d:=form1.ndatastworzenia.date;
  blockwrite(Tof, d, sizeof(d));

  formprogres.memo1.lines.add('** Rozmiary plikow: pozycja pliku:'+inttostr(filepos(tof)) );
  //pliki
  suma:=0;
  for a:=0 to max_ani do begin
      inc(n);
      listarozm[n]:=rozmiarpliku(form1.ani_edity[a].Text);
      //formprogres.memo1.lines.add(inttostr(n)+') '+inttostr(listarozm[n])+' b.');
      inc(suma, listarozm[n]);
  end;
  for a:=0 to max_mies do begin
      inc(n);
      listarozm[n]:=rozmiarpliku(form1.mies_ani_edity[a].Text);
      //formprogres.memo1.lines.add(inttostr(n)+') '+inttostr(listarozm[n])+' b.');
      inc(suma, listarozm[n]);
  end;
  for a:=0 to max_dzw do begin
      inc(n);
      listarozm[n]:=rozmiarpliku(form1.dzwieki_edity[a].Text);
      //formprogres.memo1.lines.add(inttostr(n)+') '+inttostr(listarozm[n])+' b.');
      inc(suma, listarozm[n]);
  end;
  formprogres.pasek.MaxValue:=suma;

  //najpierw zgrywamy kolejne rozmiary plikow
  for a:=0 to n do
      blockwrite(ToF, listarozm[a], sizeof(int64));

  formprogres.memo1.lines.add('** Animacje postaci: pozycja pliku:'+inttostr(filepos(tof)) );
  n:=-1;
  //potem kopie samych plikow
  for a:=0 to max_ani do begin
      inc(n);
      if listarozm[n]>=1 then dograjplik(form1.ani_edity[a].Text);
  end;

  formprogres.memo1.lines.add('** Animacje miesa: pozycja pliku:'+inttostr(filepos(tof)) );
  for a:=0 to max_mies do begin
      inc(n);
      if listarozm[n]>=1 then dograjplik(form1.mies_ani_edity[a].Text);
  end;

  formprogres.memo1.lines.add('** DŸwiêki: pozycja pliku:'+inttostr(filepos(tof)) );
  for a:=0 to max_dzw do begin
      inc(n);
      if listarozm[n]>=1 then dograjplik(form1.dzwieki_edity[a].Text);
  end;

  //ustawienia 2 czesc
  formprogres.memo1.lines.add('** Ustawienia (1): pozycja pliku:'+inttostr(filepos(tof)) );
  zapiszwartosc(form1.ustpocsila);
  zapiszwartosc(form1.ustmaxsily);
  zapiszwartosc(form1.ustmaxtlen);

  zapiszwartosc(form1.ustszyb);
  zapiszwartosc(form1.ustwaga);
  zapiszwartosc(form1.ustsilabicia);

  zapiszwartosc(form1.ustamun0);
  zapiszwartosc(form1.ustamun1);
  zapiszwartosc(form1.ustamun2);
  zapiszwartosc(form1.ustamun3);

  c:=form1.nkolorkrwi.Brush.Color;
  blockwrite(Tof, c, sizeof(c));

  formprogres.memo1.lines.add('** Ustawienia (2): pozycja pliku:'+inttostr(filepos(tof)) );
  for a:=0 to max_ani do begin
      blockwrite(tof, druzyna[1].aniszyb[a], sizeof(druzyna[1].aniszyb[a]));
      blockwrite(tof, druzyna[1].anidzialanie[a].x, sizeof(druzyna[1].anidzialanie[a].x));
      blockwrite(tof, druzyna[1].anidzialanie[a].y, sizeof(druzyna[1].anidzialanie[a].y));
      blockwrite(tof, druzyna[1].anidzialanie[a].klatka, sizeof(druzyna[1].anidzialanie[a].klatka));
      blockwrite(tof, druzyna[1].anidzialanie[a].dx, sizeof(druzyna[1].anidzialanie[a].dx));
      blockwrite(tof, druzyna[1].anidzialanie[a].dy, sizeof(druzyna[1].anidzialanie[a].dy));
  end;

  formprogres.memo1.lines.add('** Ustawienia (3): pozycja pliku:'+inttostr(filepos(tof)) );
  for a:=0 to max_mies do begin
      blockwrite(tof, druzyna[1].miesomiejsca[a].x, sizeof(druzyna[1].miesomiejsca[a].x));
      blockwrite(tof, druzyna[1].miesomiejsca[a].y, sizeof(druzyna[1].miesomiejsca[a].y));
      blockwrite(tof, druzyna[1].miesomiejsca[a].kl, sizeof(druzyna[1].miesomiejsca[a].kl));

      blockwrite(tof, druzyna[1].miesomiejsca[a].zaczx, sizeof(druzyna[1].miesomiejsca[a].zaczx));
      blockwrite(tof, druzyna[1].miesomiejsca[a].zaczy, sizeof(druzyna[1].miesomiejsca[a].zaczy));

      blockwrite(tof, form1.mies_d_ani_wym[a], sizeof(form1.mies_d_ani_wym[a]));
      blockwrite(tof, form1.mies_d_ani_ilekl[a], sizeof(form1.mies_d_ani_ilekl[a]));
  end;

  formprogres.memo1.lines.add('** Ustawienia (4): pozycja pliku:'+inttostr(filepos(tof)) );
  for a:=0 to max_ani do begin
      b1:=length(druzyna[1].anibombana[a]);
      blockwrite(tof, b1, sizeof(b1));
      formprogres.memo1.lines.add('  Ustawienie animacji '+inttostr(a)+', klatek '+inttostr(b1) );
      if length(druzyna[1].anibombana[a])>=1 then
        for b:=0 to b1-1 do begin
            blockwrite(tof, druzyna[1].anibombana[a][b].x, sizeof(druzyna[1].anibombana[a][b].x));
            blockwrite(tof, druzyna[1].anibombana[a][b].y, sizeof(druzyna[1].anibombana[a][b].y));
            blockwrite(tof, druzyna[1].anibombana[a][b].klatka, sizeof(druzyna[1].anibombana[a][b].klatka));

            blockwrite(tof, druzyna[1].anibron[a][b].x, sizeof(druzyna[1].anibron[a][b].x));
            blockwrite(tof, druzyna[1].anibron[a][b].y, sizeof(druzyna[1].anibron[a][b].y));
            blockwrite(tof, druzyna[1].anibron[a][b].kat, sizeof(druzyna[1].anibron[a][b].kat));
        end;

  end;

  formprogres.memo1.lines.add('** Ustawienia (5): pozycja pliku:'+inttostr(filepos(tof)) );
  b1:=length(druzyna[1].aninudzi);
  blockwrite(tof, b1, sizeof(b1));
  if length(druzyna[1].aninudzi)>=1 then
    for b:=0 to b1-1 do begin
        blockwrite(tof, druzyna[1].aninudzi[b].od, sizeof(druzyna[1].aninudzi[b].od));
        blockwrite(tof, druzyna[1].aninudzi[b].ile, sizeof(druzyna[1].aninudzi[b].ile));
        blockwrite(tof, druzyna[1].aninudzi[b].szyb, sizeof(druzyna[1].aninudzi[b].szyb));
        blockwrite(tof, druzyna[1].aninudzi[b].tylkoraz, sizeof(druzyna[1].aninudzi[b].tylkoraz));
    end;

  formprogres.memo1.lines.add('** Teksty dymkow: pozycja pliku:'+inttostr(filepos(tof)) );
  for a:=0 to max_dym do begin
      b1:=form1.dymki_comboboxy[a].items.count;
      blockwrite(tof, b1, sizeof(b1));
      if b1>0 then
         for b:=0 to b1-1 do begin
             zapiszstring2(tof, form1.dymki_comboboxy[a].items[b]);
         end;
  end;

  formprogres.memo1.lines.add('** Koniec: pozycja pliku:'+inttostr(filepos(tof)) );

finally
  CloseFile(ToF);
  formprogres.Zamknij.Enabled:=true;
end;

end;

procedure Wczytajdruzyne(nazwaplikupostaci:string); {bez rozszerzenia i podkatalogow!}
var
  f:file;
  listarozm:array[0..70] of int64;
  a,b,b1,n:integer;
  suma:int64;
  d:TDate;
  c:cardinal;
  nazwatmpkat,s:string;
  nagtmp:TNaglowek;

  procedure wczytajwartosc(var s:tspinedit);
  var i:integer;
  begin
    blockread(f, i, sizeof(i));
    s.value:=i;
  end;

  procedure wypakujplik(n:integer; nazwa:string);
  var
    ToF: File;
    NumRead, NumWritten: Integer;
    Buf: array[1..2048] of Char;
    s:int64;
  begin
    AssignFile(ToF, nazwa);
    filemode:=1;
    Rewrite(ToF, 1);
    s:=0;
    repeat
      if s+sizeof(buf)<=listarozm[n] then BlockRead(F, Buf, SizeOf(Buf), NumRead)
         else BlockRead(F, Buf, listarozm[n]-s, NumRead);
      BlockWrite(ToF, Buf, NumRead, NumWritten);
      s:=s+numwritten;
    until (NumRead = 0) or (NumWritten <> NumRead);
    CloseFile(ToF);

    formprogres.memo1.lines.add(nazwa+': rozmiar='+inttostr(listarozm[n])+', wczytano='+inttostr(s));

    formprogres.pasek.Progress:=formprogres.pasek.Progress+s;
    application.processmessages;
  end;

begin
  Nowadruzyna;
  formprogres.Zamknij.Enabled:=false;
  formprogres.pasek.Progress:=0;
  formprogres.Caption:='Wczytywanie pliku';
  formprogres.nazwapl.Caption:='Teams\'+nazwaplikupostaci+'.s3p';
  formprogres.memo1.clear;
  formprogres.show;

  n:=-1;

  AssignFile(f, 'Teams\'+nazwaplikupostaci+'.s3p');
try
  filemode:=0;
  Reset(f, 1);

  //naglowek
  blockread(f, nagtmp, sizeof(nagtmp));
  if nagtmp<>naglowek then begin
     formprogres.memo1.lines.add('Z³y nag³ówek pliku!');
     raise exception.create('Z³y nag³ówek pliku!');
  end;

  //ustawienia 2 czesc
  form1.nnazwa.Text:=wczytajstring2(f);
  form1.nautor.Text:=wczytajstring2(f);
  blockread(f, d, sizeof(d));
  form1.ndatastworzenia.date:=d;

  formprogres.memo1.lines.add('** Rozmiary plikow: pozycja pliku:'+inttostr(filepos(f)) );
  //pliki
  n:=max_ani+max_mies+max_dzw+2;
  formprogres.pasek.MaxValue:=n;

  //najpierw wczytujemy kolejne rozmiary plikow
  for a:=0 to n do begin
      blockread(f, listarozm[a], sizeof(int64));
      //formprogres.memo1.lines.add(inttostr(a)+') '+inttostr(listarozm[a])+' b.');
  end;

  //tworzymy tymczasowy katalog dla plikow "wypakowanych"
  if not DirectoryExists('Teams\'+nazwaplikupostaci) then CreateDir('Teams\'+nazwaplikupostaci);

  formprogres.memo1.lines.add('** Animacje postaci: pozycja pliku:'+inttostr(filepos(f)) );
  n:=-1;
  //potem kopie samych plikow
  for a:=0 to max_ani do begin
      inc(n);
      s:='Teams\'+nazwaplikupostaci+'\anim'+inttostr(a)+'.tga';
      if listarozm[n]>=1 then begin
         wypakujplik(n,s);
         form1.ani_edity[a].Text:=GetCurrentDir+'\'+s;
         if not wczytaj_animacje(form1.d_animacje[a],s,30) then begin
            exception.Create('B³¹d przy otwieraniu animacji!');
         end;
      end;
  end;

  formprogres.memo1.lines.add('** Animacje miesa: pozycja pliku:'+inttostr(filepos(f)) );
  for a:=0 to max_mies do begin
      inc(n);
      s:='Teams\'+nazwaplikupostaci+'\anim_mies'+inttostr(a)+'.tga';
      if listarozm[n]>=1 then begin
         wypakujplik(n,s);
         form1.mies_ani_edity[a].Text:=GetCurrentDir+'\'+s;
         if not wczytaj_animacje(form1.mies_d_animacje[a],s,0) then begin
            exception.Create('B³¹d przy otwieraniu animacji!');
         end;
      end;
  end;

  formprogres.memo1.lines.add('** DŸwiêki: pozycja pliku:'+inttostr(filepos(f)) );
  for a:=0 to max_dzw do begin
      inc(n);
      s:='Teams\'+nazwaplikupostaci+'\dzw'+inttostr(a)+'.wav';
      if listarozm[n]>=1 then begin
         wypakujplik(n,s);
         form1.dzwieki_edity[a].Text:=GetCurrentDir+'\'+s;
      end;
  end;

  //ustawienia 2 czesc
  formprogres.memo1.lines.add('** Ustawienia (1): pozycja pliku:'+inttostr(filepos(f)) );
  wczytajwartosc(form1.ustpocsila);
  wczytajwartosc(form1.ustmaxsily);
  wczytajwartosc(form1.ustmaxtlen);

  wczytajwartosc(form1.ustszyb);
  wczytajwartosc(form1.ustwaga);
  wczytajwartosc(form1.ustsilabicia);

  wczytajwartosc(form1.ustamun0);
  wczytajwartosc(form1.ustamun1);
  wczytajwartosc(form1.ustamun2);
  wczytajwartosc(form1.ustamun3);

  blockread(f, c, sizeof(c));
  form1.nkolorkrwi.Brush.Color:=c;

  formprogres.memo1.lines.add('** Ustawienia (2): pozycja pliku:'+inttostr(filepos(f)) );
  for a:=0 to max_ani do begin
      blockread(f, druzyna[1].aniszyb[a], sizeof(druzyna[1].aniszyb[a]));
      blockread(f, druzyna[1].anidzialanie[a].x, sizeof(druzyna[1].anidzialanie[a].x));
      blockread(f, druzyna[1].anidzialanie[a].y, sizeof(druzyna[1].anidzialanie[a].y));
      blockread(f, druzyna[1].anidzialanie[a].klatka, sizeof(druzyna[1].anidzialanie[a].klatka));
      blockread(f, druzyna[1].anidzialanie[a].dx, sizeof(druzyna[1].anidzialanie[a].dx));
      blockread(f, druzyna[1].anidzialanie[a].dy, sizeof(druzyna[1].anidzialanie[a].dy));
  end;

  formprogres.memo1.lines.add('** Ustawienia (3): pozycja pliku:'+inttostr(filepos(f)) );
  for a:=0 to max_mies do begin
      blockread(f, druzyna[1].miesomiejsca[a].x, sizeof(druzyna[1].miesomiejsca[a].x));
      blockread(f, druzyna[1].miesomiejsca[a].y, sizeof(druzyna[1].miesomiejsca[a].y));
      blockread(f, druzyna[1].miesomiejsca[a].kl, sizeof(druzyna[1].miesomiejsca[a].kl));

      blockread(f, druzyna[1].miesomiejsca[a].zaczx, sizeof(druzyna[1].miesomiejsca[a].zaczx));
      blockread(f, druzyna[1].miesomiejsca[a].zaczy, sizeof(druzyna[1].miesomiejsca[a].zaczy));

      blockread(f, form1.mies_d_ani_wym[a], sizeof(form1.mies_d_ani_wym[a]));
      blockread(f, form1.mies_d_ani_ilekl[a], sizeof(form1.mies_d_ani_ilekl[a]));
  end;

  formprogres.memo1.lines.add('** Ustawienia (4): pozycja pliku:'+inttostr(filepos(f)) );
  for a:=0 to max_ani do begin
      blockread(f, b1, sizeof(b1));
      setlength(druzyna[1].anibombana[a],b1);
      setlength(druzyna[1].anibron[a],b1);
      formprogres.memo1.lines.add('  Ustawienie animacji '+inttostr(a)+', klatek '+inttostr(b1) );
      if length(druzyna[1].anibombana[a])>=1 then
        for b:=0 to b1-1 do begin
            blockread(f, druzyna[1].anibombana[a][b].x, sizeof(druzyna[1].anibombana[a][b].x));
            blockread(f, druzyna[1].anibombana[a][b].y, sizeof(druzyna[1].anibombana[a][b].y));
            blockread(f, druzyna[1].anibombana[a][b].klatka, sizeof(druzyna[1].anibombana[a][b].klatka));

            blockread(f, druzyna[1].anibron[a][b].x, sizeof(druzyna[1].anibron[a][b].x));
            blockread(f, druzyna[1].anibron[a][b].y, sizeof(druzyna[1].anibron[a][b].y));
            blockread(f, druzyna[1].anibron[a][b].kat, sizeof(druzyna[1].anibron[a][b].kat));
        end;
  end;

  formprogres.memo1.lines.add('** Ustawienia (5): pozycja pliku:'+inttostr(filepos(f)) );
  blockread(f, b1, sizeof(b1));
  setlength(druzyna[1].aninudzi,b1);
  if length(druzyna[1].aninudzi)>=1 then
    for b:=0 to b1-1 do begin
        blockread(f, druzyna[1].aninudzi[b].od, sizeof(druzyna[1].aninudzi[b].od));
        blockread(f, druzyna[1].aninudzi[b].ile, sizeof(druzyna[1].aninudzi[b].ile));
        blockread(f, druzyna[1].aninudzi[b].szyb, sizeof(druzyna[1].aninudzi[b].szyb));
        blockread(f, druzyna[1].aninudzi[b].tylkoraz, sizeof(druzyna[1].aninudzi[b].tylkoraz));
    end;

  formprogres.memo1.lines.add('** Teksty dymkow: pozycja pliku:'+inttostr(filepos(f)) );
  for a:=0 to max_dym do begin
      form1.dymki_comboboxy[a].items.Clear;
      blockread(f, b1, sizeof(b1));
      formprogres.memo1.lines.add(inttostr(a)+') ilosc='+inttostr(b1));
      if b1>0 then
         for b:=0 to b1-1 do begin
             form1.dymki_comboboxy[a].items.add(wczytajstring2(f));
         end;
  end;


  formprogres.memo1.lines.add('** Koniec: pozycja pliku:'+inttostr(filepos(f)) );

finally
  formprogres.Zamknij.Enabled:=true;
  CloseFile(f);
end;

end;

procedure oczysc_pliki_tmp_druzyn;
var a,b:integer; s,nazwaplikupostaci:string;
begin
for b:=0 to form1.listadruzyn.Items.Count-1 do begin
    nazwaplikupostaci:=form1.listadruzyn.Items[b];
    if DirectoryExists('Teams\'+nazwaplikupostaci) then begin
        {$I-}
        for a:=0 to max_ani do begin
            s:='Teams\'+nazwaplikupostaci+'\anim'+inttostr(a)+'.tga';
            if FileExists(s) then DeleteFile(s);
        end;
        for a:=0 to max_mies do begin
            s:='Teams\'+nazwaplikupostaci+'\anim_mies'+inttostr(a)+'.tga';
            if FileExists(s) then DeleteFile(s);
        end;
        for a:=0 to max_dzw do begin
            s:='Teams\'+nazwaplikupostaci+'\dzw'+inttostr(a)+'.wav';
            if FileExists(s) then DeleteFile(s);
        end;
        if DirectoryExists('Teams\'+nazwaplikupostaci) then RemoveDir('Teams\'+nazwaplikupostaci);
        {$I+}
        a:=ioresult;
    end;
end;
end;

procedure Nowadruzyna;
var
  f:file;
  a,b,b1,n:integer;
  suma:int64;
  d:TDate;
  c:cardinal;
  nazwatmpkat,s:string;
  nagtmp:TNaglowek;

begin
  form1.nnazwa.Text:='Nowa dru¿yna';
  form1.nautor.Text:='Autor';
  form1.ndatastworzenia.date:=now;

  for a:=0 to max_ani do begin
      form1.ani_edity[a].Text:='';
      if Form1.d_animacje[a]<>nil then begin
         Form1.d_animacje[a].Free;
         Form1.d_animacje[a]:=nil;
      end;
      setlength(druzyna[1].anibombana[a],0);
      setlength(druzyna[1].anibron[a],0);
  end;

  for a:=0 to max_mies do begin
      form1.mies_ani_edity[a].Text:='';
      if Form1.mies_d_animacje[a]<>nil then begin
         Form1.mies_d_animacje[a].Free;
         Form1.mies_d_animacje[a]:=nil;
      end;
  end;

  for a:=0 to max_dzw do begin
      form1.dzwieki_edity[a].Text:='';
  end;

  form1.ustpocsila.Value:=100; form1.ustpocsilaChange(form1.ustpocsila);
  form1.ustmaxsily.Value:=500; form1.ustmaxsilyChange(form1.ustmaxsily);
  form1.ustmaxtlen.Value:=100; form1.ustmaxtlenChange(form1.ustmaxtlen);

  form1.ustszyb.Value:=100; form1.ustszybChange(form1.ustszyb);
  form1.ustwaga.Value:=100; form1.ustwagaChange(form1.ustwaga);
  form1.ustsilabicia.Value:=100; form1.ustsilabiciaChange(form1.ustsilabicia);

  form1.ustamun0.Value:=10; form1.ustamun0Change(form1.ustamun0);
  form1.ustamun1.Value:=7;  form1.ustamun1Change(form1.ustamun1);
  form1.ustamun2.Value:=30; form1.ustamun2Change(form1.ustamun2);
  form1.ustamun3.Value:=2;  form1.ustamun3Change(form1.ustamun3);

  form1.nkolorkrwi.Brush.Color:=$000000BB;

  for a:=0 to max_ani do begin
      druzyna[1].aniszyb[a]:=2;
      druzyna[1].anidzialanie[a].x:=0;
      druzyna[1].anidzialanie[a].y:=0;
      druzyna[1].anidzialanie[a].klatka:=0;
      druzyna[1].anidzialanie[a].dx:=0;
      druzyna[1].anidzialanie[a].dy:=0;
  end;

  for a:=0 to max_mies do begin
      druzyna[1].miesomiejsca[a].x:=0;
      druzyna[1].miesomiejsca[a].y:=0;
      druzyna[1].miesomiejsca[a].kl:=0;
      druzyna[1].miesomiejsca[a].zaczx:=0;
      druzyna[1].miesomiejsca[a].zaczy:=0;

      form1.mies_d_ani_wym[a]:=0;
      form1.mies_d_ani_ilekl[a]:=0;
  end;

  setlength(druzyna[1].aninudzi,1);
  druzyna[1].aninudzi[0].od:=0;
  druzyna[1].aninudzi[0].ile:=0;
  druzyna[1].aninudzi[0].szyb:=0;
  druzyna[1].aninudzi[0].tylkoraz:=true;

  with ustawienia do begin
     zoom:=1;
     mies_zoom:=1;
     //wybranadruzyna:='';

     doklatki:=0;
     aniwybrana:=0;
     klatkawybrana:=0;

     stoi_wyb:=0;
     odtw_od:=0;
     odtw_ile:=0;

     mies_aniwybrana:=0;
     mies_klatkawybrana:=0;
     mies_anisz:=0;
  end;

  for a:=0 to max_dym do
      form1.dymki_comboboxy[a].items.Clear;

end;

end.
