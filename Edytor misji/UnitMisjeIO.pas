unit UnitMisjeIO;

interface
uses classes, windows, sysutils, controls, unitstringi, stdctrls, graphics;

type
Tnaglowek=array[0..9] of char;

const
naglowek:Tnaglowek=('S','3','M','i','s','j','a','1','0','0');

procedure zapisz_misje(nazwa:string);
procedure wczytaj_misje(nazwa:string);
procedure wczytaj_teren_z_pliku_full(nazwa:string; z_kolesiami:boolean);

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
   p:=TFileStream.Create('Missions\'+nazwa+'.S3Mis', fmCreate);

   p.writebuffer(naglowek,sizeof(naglowek));

   zapiszstring(p,ustawienia.wybranyteren);

   zapiszstring(p,form1.nnazwa.text);
   zapiszstring(p,form1.nautor.text);
   zapiszstring(p,form1.nopis.text);
   zapiszD(form1.ndatastworzenia.Date);
   zapiszI64(wartosc(form1.nnagroda.Text));

   if form1.nmuzyka.ItemIndex=0 then zapiszstring(p,'')
      else zapiszstring(p,form1.nmuzyka.text);

   zapiszB(form1.njestczas.Checked);
   zapiszcz(form1.nileczasu.Time);
   zapiszB(form1.nsterowanie.Checked);
   zapiszi(form1.nsterowanapostac.Value);
   zapiszB(form1.nwlaczonykursor.Checked);
   zapiszB(form1.nzmianawarunkow.Checked);
   zapiszB(form1.nrysowanie.Checked);
   zapiszB(form1.nzmianawejsc.Checked);
   zapiszB(form1.nzmianadruzyn.Checked);
   zapiszB(form1.nprzenoszenie.Checked);

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

   zapiszI(form1.nczestpaczek.Value);

   zapiszI(form1.nbrondomyslna.Value);

   for a:=0 to 100{max_broni} do
       if a<=max_broni then zapiszI(wartosc(form1.namunicja.Cells[1,1+a]))
                       else zapiszI(0);

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

   for a:=0 to 9 do
       zapiszC(druzyna[a].kolor_druzyny);

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
  s:string;

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

 function wczytajC:cardinal;
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
if FileExists('Missions\'+nazwa+'.S3Mis') then begin
  try
   p:=TFileStream.Create('Missions\'+nazwa+'.S3Mis',fmOpenRead);

   p.readbuffer(tmp,sizeof(tmp));

   if tmp<>naglowek then Raise EReadError.Create('Zly naglowek');

   ustawienia.wybranyteren:=wczytajstring(p);

   form1.nnazwa.text:=wczytajstring(p);
   form1.nautor.text:=wczytajstring(p);
   form1.nopis.text:=wczytajstring(p);
   form1.ndatastworzenia.Date:=wczytajD;
   form1.nnagroda.Text:=l2t(wczytajI64,0);

   s:=wczytajstring(p);
   if s='' then form1.nmuzyka.ItemIndex:=0
      else begin
           a:=0;
           while (a<form1.nmuzyka.Items.Count) and (s<>form1.nmuzyka.Items[a]) do inc(a);
           if a>=form1.nmuzyka.Items.Count then form1.nmuzyka.ItemIndex:=0
              else form1.nmuzyka.ItemIndex:=a;
           end;

   form1.njestczas.Checked:=wczytajB;
   form1.nileczasu.Time:=wczytajcz;
   form1.nsterowanie.Checked:=wczytajB;
   form1.nsterowanapostac.Value:=wczytajI;
   form1.nwlaczonykursor.Checked:=wczytajB;
   form1.nzmianawarunkow.Checked:=wczytajB;
   form1.nrysowanie.Checked:=wczytajB;
   form1.nzmianawejsc.Checked:=wczytajB;
   form1.nzmianadruzyn.Checked:=wczytajB;
   form1.nprzenoszenie.Checked:=wczytajB;

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

   form1.nczestpaczek.Value:=wczytajI;

   form1.nbrondomyslna.Value:=wczytajI;

   for a:=0 to 100{max_broni} do
       if a<=max_broni then form1.namunicja.Cells[1,1+a]:=l2t(wczytajI,0)
                       else wczytajI;

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

   for a:=0 to 9 do
       druzyna[a].kolor_druzyny:=wczytajC;

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

   p.free;
  except
     p.free;
     MessageBox(hnd, 'Blad przy odczycie pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
  end;
end else begin
   MessageBox(hnd, 'Nie ma takiego pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
end;

end;


{----------------------------------}
type
Ts3tnag=array[0..4] of char;
Ts3scenaglowek=array[0..9] of char;
const
s3tnag2:Ts3tnag=('M','a','S','k','=');
s3scenaglowek:Ts3scenaglowek=('S','3','S','c','e','n','r','1','0','0');

procedure wczytaj_teren_z_pliku_full(nazwa:string; z_kolesiami:boolean);
var
plik:TFileStream;
g:array[0..2047] of cardinal;
nagtmp:Ts3tnag;
g2:^tcolor;
a,a1,x,y,
rozmx,rozmy,tx,ty:integer;
c:byte;

 function wczytajI:integer;
 var b:integer;
 begin
    plik.ReadBuffer(b,sizeof(b));
    wczytajI:=b;
 end;

 function wczytajC:cardinal;
 var b:cardinal;
 begin
    plik.ReadBuffer(b,sizeof(b));
    wczytajC:=b;
 end;

 function wczytajB:boolean;
 var b:boolean;
 begin
    plik.ReadBuffer(b,sizeof(b));
    wczytajB:=b;
 end;

 function wczytajBt:byte;
 var b:byte;
 begin
    plik.ReadBuffer(b,sizeof(b));
    wczytajBt:=b;
 end;

 function wczytajR:real;
 var b:real;
 begin
    plik.ReadBuffer(b,sizeof(b));
    wczytajR:=b;
 end;

 function wczytajS:shortint;
 var b:shortint;
 begin
    plik.ReadBuffer(b,sizeof(b));
    wczytajS:=b;
 end;


begin
plik:=TFileStream.Create('Terrains\'+nazwa+'.s3ter', fmOpenRead);
try
   if obr.teren.surf<>nil then begin
      obr.teren.surf.Free;
      obr.teren.surf:=nil;
   end;
   if ObrTerenu<>nil then begin
      ObrTerenu.Free;
      ObrTerenu:=nil;
   end;

   ObrTerenu:=tbitmap.Create;

   teren.width:=wczytajI;
   teren.height:=wczytajI;
   rozmx:=teren.width;
   rozmy:=teren.height;

   ObrTerenu.PixelFormat:=pf24bit;
   ObrTerenu.Transparent:=false;
   ObrTerenu.Width:=teren.width;
   ObrTerenu.Height:=teren.height;

   {rysunek}

   for y:=0 to teren.height-1 do begin
       plik.ReadBuffer(g,4*teren.width);
       for x:=0 to teren.width-1 do begin
           if ((g[x] and $FF000000)=0) then
              obrterenu.Canvas.Pixels[x,y]:=clBtnFace
           else obrterenu.Canvas.Pixels[x,y]:=(g[x] and $00FF00) or ((g[x] and $FF) shl 16) or ((g[x] and $FF0000) shr 16);
           inc(g2);
       end;
   end;

//   obr.teren.surf.unLock(0);

   plik.ReadBuffer(nagtmp,sizeof(nagtmp));

   {maska}
   setlength(teren.maska, teren.width+1);
   for x:=0 to teren.width-1 do begin
       setlength(teren.maska[x],teren.height+31);
       plik.ReadBuffer(teren.maska[x,0],teren.height);
       for y:=0 to teren.height-1 do
           if ((x+y) mod 2=0) and (teren.maska[x,y]=0) then
              obrterenu.Canvas.Pixels[x,y]:=clBtnFace;
   end;

   { ======= JAKBY TRZEBA BYLO ZMIENIC COS, TO ZOSTAWIC POWYZSZE WCZYTYWANIE TERENU
             I ZMIENIAC TYLKO TO CO PONIZEJ STAD ========= }

   {---ustawienia terenu---}
   with warunki do begin
      agresja:=wczytajI;
      walka_ze_swoimi:=wczytajB;
      walka_bez_powodu:=wczytajB;
      typ_wody:=wczytajBt;
      gleb_wody:=wczytajI;
      ust_wys_wody:=wczytajI;
      wys_wody:=wczytajI;
      wiatr:=wczytajR;
      zwierzeta_same:=wczytajB;
      deszcz:=wczytajB;
      snieg:=wczytajB;
      burza:=wczytajB;
      chmurki:=wczytajB;
      silaburzy:=wczytajI;
      iloscchmur:=wczytajI;
      jakiechmury:=wczytajBt;
      czestpaczek:=wczytajI;
      grawitacja:=wczytajR;
      godzina:=wczytajI;
      paczkidowolnie:=wczytajB;
   end;


   with druzynymenu do begin
      wejsciewybrane:=wczytajI;
      ilewejsc:=wczytajI;
      lecatezzgory:=wczytajB;
   end;

   {wejscia}
   for a:=0 to max_wejsc do with wejscia[a] do begin
      x:=wczytajI;
      y:=wczytajI;
      for a1:=0 to max_druzyn do druzyny[a1]:=wczytajB;
      czest:=wczytajI;
      proc:=wczytajI;
   end;



   {niebo}
   with niebo do begin
      for a:=0 to 23 do with kolorytla[a] do begin
         zmiana:=wczytajB;
         gr:=wczytajBt;
         gg:=wczytajBt;
         gb:=wczytajBt;
         dr:=wczytajBt;
         dg:=wczytajBt;
         db:=wczytajBt;
         dlugosc:=wczytajBt;
         bierzdanez:=wczytajBt;
      end;

      kolorytlag:=wczytajC;
      kolorytlad:=wczytajC;
      kolorterenu:=wczytajC;

      rampr:=wczytajR;
      rampg:=wczytajR;
      rampb:=wczytajR;
      tlo_grad_il:=wczytajI;
      tlo_grad_skok:=wczytajI;
      kolorytlaszybkosc:=wczytajI;

      tlowidth:=wczytajI;
      tloheight:=wczytajI;

      widslon:=wczytajB;
      winksie:=wczytajB;
      widgwia:=wczytajB;
      widchmu:=wczytajB;
      widdeszsnie:=wczytajB;
   end;


   {----obiekty-----}
    {druzyny}
    for a:=0 to max_druzyn do with druzyna[a] do begin
        for a1:=1 to 4 do maxamunicji[a1]:=wczytajI;
        startsila:=wczytajI;
        startbron:=wczytajBt;
        startamunicja:=wczytajBt;
        ma_byc_kolesi:=wczytajI;
        for a1:=0 to max_druzyn do przyjaciele[a1]:=wczytajB;
    end;

    {kolesie}
    max_kol:=wczytajI;
    for a:=0 to max_kol do with koles[a] do begin
        if z_kolesiami then begin
            c:=255-random(30);
            kolor:=$FF000000+ c shl 16 + c shl 8 + c;
            team:=wczytajBt;
            x:=wczytajR;
            y:=wczytajR;
            jest:=wczytajB;
            kierunek:=wczytajS;
            sila:=wczytajI;
            bron:=wczytajBt;
            amunicja:=wczytajI;
            tlen:=wczytajI;
        end else begin
            wczytajBt;
            wczytajR;
            wczytajR;
            wczytajB;
            wczytajS;
            wczytajI;
            wczytajBt;
            wczytajI;
            wczytajI;
        end;

        dx:=0;
        dy:=0;
        zabic:=-1;
        zebrac:=-1;
        czaszbierania:=0;
        corobi:=0;
        corobil:=-1;
        ani:=0;
        anikl:=0;
        anisz:=0;
        anido:=0;
        ktoretrzymamieso:=-1;
        skocz:=false;
        palisie:=false;
        ktoregochcekopnac:=-1;
        cochcekopnac:=0;
        juz_sa_zwloki:=false;
        przenoszony:=false;
        ile_wspina:=0;
    end;

    {zwierzaki}
(*    max_zwierz:=wczytajI;
    for a:=0 to max_zwierz do with zwierz[a] do begin
        x:=wczytajR;
        y:=wczytajR;
        jest:=wczytajB;
        rodzaj:=wczytajBt;
        gatunek:=wczytajBt;
        klatka:=wczytajR;
        kierunek:=wczytajS;
        lezy:=wczytajB;
        sila:=wczytajI;

        dx:=0;
        dy:=0;
        palisie:=false;
        zabic:=-1;
        czas_zabijania:=0;
        juzzabity:=false;
        przenoszony:=false;
    end;

    {miny}
    max_mina:=wczytajI;
    for a:=0 to max_mina do with mina[a] do begin
        x:=wczytajR;
        y:=wczytajR;
        jest:=wczytajB;
        zepsuta:=wczytajB;
        klatka:=wczytajR;
        rodzaj:=wczytajBt;
        lezy:=wczytajB;
        zaczepiona:=wczytajB;
        dl_zaczep:=wczytajI;
        zaczx:=wczytajI;
        zaczy:=wczytajI;
        czasdowybuchu:=wczytajI;

        dx:=0;
        dy:=0;
        aktywna:=false;
        klatkamiganie:=random(15);
        przenoszony:=false;
    end;

    {przedmioty}
    max_przedm:=wczytajI;
    for a:=0 to max_przedm do with przedm[a] do begin
        x:=wczytajR;
        y:=wczytajR;
        jest:=wczytajB;
        rodzaj:=wczytajBt;
        klatka:=wczytajR;
        kat:=wczytajR;
        lezy:=wczytajB;

        dx:=0;
        dy:=0;
        rozwal:=false;
        przenoszony:=false;
    end;

    {chmurki}
    for a:=0 to max_chmurki do with chmurka[a] do begin
        x:=wczytajR;
        y:=wczytajR;
        szybkosc:=wczytajR;
        jest:=wczytajB;
        wyglad:=wczytajBt;
        wielkoscx:=wczytajI;
        wielkoscy:=wczytajI;
        kolor:=wczytajC;
        ciemnosc:=wczytajR;
        ztylu:=wczytajB;
        odbita:=wczytajB;
    end;

    {swiatla}
    max_swiatla:=wczytajI;
    for a:=0 to max_swiatla do with swiatla[a] do begin
        x:=wczytajI;
        y:=wczytajI;
        typ:=wczytajBt;
        wielkosc:=wczytajI;
        kat:=wczytajI;
        kolor:=wczytajC;
        zniszczalne:=wczytajB;
        efekt:=wczytajBt;
        ztylu:=wczytajB;
    end;

  *)
    {=======================================================================}

finally
   if plik<>nil then begin
      plik.Free;
      plik:=nil;
   end;
end;

end;

end.
