unit UnitPliki;

interface
uses classes,forms,
     vars, unitstringi;

   procedure zapisz_teren_do_pliku_fast(nazwa:string);
   procedure wczytaj_teren_z_pliku_fast(nazwa:string);

   procedure zapisz_teren_do_pliku_full(nazwa:string);
   procedure wczytaj_teren_z_pliku_full(nazwa:string; z_kolesiami:boolean);

   procedure zapisz_rekordy_lokalne;
   procedure wczytaj_rekordy_lokalne;
   procedure sortuj_rekordy(var rek:array of Trekordwynik);
   procedure zrob_liste_lokalna_tmp;

   procedure wczytaj_scenariusz(nazwa:string; zmieniaj_wode:boolean=true);

   procedure wczytaj_kfg;
   procedure zapisz_kfg;
   procedure przejrzyjskonczonemisje;

   procedure log(tekst:string);
   procedure kasujlog;

implementation
uses unit1, d3d9, pdrawex, sysutils, agfunit, unitrysowanie,controls, unitmenuglowne, unitgraglowna;
type
Ts3tnag=array[0..4] of char;
Ts3scenaglowek=array[0..9] of char;
const
s3tnag2:Ts3tnag=('M','a','S','k','=');
s3scenaglowek:Ts3scenaglowek=('S','3','S','c','e','n','r','1','0','0');
rekordynag:Ts3tnag=('S','3','_','h','i');

{---zapis i odczyt terenu w trybie fast (jako bitmape i bez obiektow - tylko teren)---}
procedure zapisz_teren_do_pliku_fast(nazwa:string);
var
plik:TFileStream;
LRect: TD3DLocked_Rect;
g:array[0..2047] of cardinal;
DestPtr:pointer;
il:byte;
x,y:integer;

 procedure zapiszI(b:integer);
 begin
    plik.WriteBuffer(b,sizeof(b));
 end;

begin
log('Zapisywanie terenu w trybie FAST do pliku: '+nazwa);
form1.pokaz_wczytywanie('Zapisywanie terenu');
plik:=TFileStream.Create('Terrains\'+nazwa, fmCreate);
try

   zapiszI(teren.width);
   zapiszI(teren.height);

   obr.teren.surf.Lock(0, LRect);

   {rysunek}
   il:=0;
   for y:=0 to teren.height-1 do begin
       DestPtr:=Pointer(Integer(LRect.Bits) + (LRect.Pitch * y));
       pdrawLineConv(DestPtr, @g, teren.width, D3DFMT_A8R8G8B8, obr.teren.surf.Format);
       plik.WriteBuffer(g,4*teren.width);
   end;

   obr.teren.surf.unLock(0);

   plik.WriteBuffer(s3tnag2,sizeof(s3tnag2));

   {maska}
   il:=0;
   for x:=0 to teren.width-1 do
       plik.WriteBuffer(teren.maska[x,0],teren.height);

finally
   if plik<>nil then begin
      plik.Free;
      plik:=nil;
      log('Zapis terenu w trybie FAST zakonczony powodzeniem');  //trzeba tu zrobic try..except i dodac bledy!
   end;
end;

form1.schowaj_wczytywanie;

end;

procedure wczytaj_teren_z_pliku_fast(nazwa:string);
var
plik:TFileStream;
LRect: TD3DLocked_Rect;
g:array[0..2047] of cardinal;
DestPtr:pointer;
nagtmp:Ts3tnag;
a,x,y,
rozmx,rozmy,tx,ty:integer;

 function wczytajI:integer;
 var b:integer;
 begin
    plik.ReadBuffer(b,sizeof(b));
    wczytajI:=b;
 end;

begin
log('Wczytywanie terenu w trybie FAST z pliku: '+nazwa);
plik:=TFileStream.Create('Terrains\'+nazwa, fmOpenRead);
form1.pokaz_wczytywanie('Wczytywanie terenu');
try
   if obr.teren.surf<>nil then begin
      obr.teren.surf.Free;
      obr.teren.surf:=nil;
   end;
   obr.teren.surf:=TAGFImage.Create(form1.PowerDraw1);

   teren.width:=wczytajI;
   teren.height:=wczytajI;
   rozmx:=teren.width;
   rozmy:=teren.height;

   a:=0;
   while (a<high(dozwrozm)) and (dozwrozm[a]<rozmx) do inc(a);
   tx:=dozwrozm[a];
   a:=0;
   while (a<high(dozwrozm)) and (dozwrozm[a]<rozmy) do inc(a);
   ty:=dozwrozm[a];

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


   obr.teren.surf.Lock(0, LRect);

   {rysunek}

   for y:=0 to teren.height-1 do begin
       DestPtr:=Pointer(Integer(LRect.Bits) + (LRect.Pitch * y));
       plik.ReadBuffer(g,4*teren.width);
       pdrawLineConv(@g, DestPtr, teren.width, obr.teren.surf.Format, D3DFMT_A8R8G8B8);
   end;

   obr.teren.surf.unLock(0);

   plik.ReadBuffer(nagtmp,sizeof(nagtmp));

   {maska}
   for x:=0 to teren.width-1 do
       plik.ReadBuffer(teren.maska[x,0],teren.height);

finally
   if plik<>nil then begin
      plik.Free;
      plik:=nil;
      log('Odczyt terenu w trybie FAST zakonczony powodzeniem'); //trzeba tu zrobic try..except i dodac bledy!
   end;
end;

form1.schowaj_wczytywanie;
end;


{---zapis i odczyt terenu w wersji pelnej (z kompresja i obiektami-------------}
procedure zapisz_teren_do_pliku_full(nazwa:string);
var
plik:TFileStream;
LRect: TD3DLocked_Rect;
g:array[0..2047] of cardinal;
DestPtr:pointer;
il:byte;
a,a1,x,y:integer;

 procedure zapiszI(b:integer);
 begin
    plik.WriteBuffer(b,sizeof(b));
 end;

 procedure zapiszB(b:boolean);
 begin
    plik.WriteBuffer(b,sizeof(b));
 end;

 procedure zapiszBt(b:byte);
 begin
    plik.WriteBuffer(b,sizeof(b));
 end;

 procedure zapiszR(b:real);
 begin
    plik.WriteBuffer(b,sizeof(b));
 end;

 procedure zapiszS(b:shortint);
 begin
    plik.WriteBuffer(b,sizeof(b));
 end;

 procedure zapiszC(b:cardinal);
 begin
    plik.WriteBuffer(b,sizeof(b));
 end;

begin
log('Zapisywanie terenu w trybie PELNYM do pliku: '+nazwa);
form1.pokaz_wczytywanie('Zapisywanie terenu');
plik:=TFileStream.Create('Terrains\'+nazwa+'.s3ter', fmCreate);
try

   zapiszI(teren.width);
   zapiszI(teren.height);

   obr.teren.surf.Lock(0, LRect);

   {rysunek}
   for y:=0 to teren.height-1 do begin
       DestPtr:=Pointer(Integer(LRect.Bits) + (LRect.Pitch * y));
       pdrawLineConv(DestPtr, @g, teren.width, D3DFMT_A8R8G8B8, obr.teren.surf.Format);
       plik.WriteBuffer(g,4*teren.width);
   end;

   obr.teren.surf.unLock(0);

   plik.WriteBuffer(s3tnag2,sizeof(s3tnag2));

   {maska}
   for x:=0 to teren.width-1 do
       plik.WriteBuffer(teren.maska[x,0],teren.height);

   {---ustawienia terenu---}
   with warunki do begin
      zapiszI(agresja);
      zapiszB(walka_ze_swoimi);
      zapiszB(walka_bez_powodu);
      zapiszBt(typ_wody);
      zapiszI(gleb_wody);
      zapiszI(ust_wys_wody);
      zapiszI(wys_wody);
      zapiszR(wiatr);
      zapiszB(zwierzeta_same);
      zapiszB(deszcz);
      zapiszB(snieg);
      zapiszB(burza);
      zapiszB(chmurki);
      zapiszI(silaburzy);
      zapiszI(iloscchmur);
      zapiszBt(jakiechmury);
      zapiszI(czestpaczek);
      zapiszR(grawitacja);
      zapiszI(godzina);
      zapiszB(paczkidowolnie);
   end;

   with druzynymenu do begin
      zapiszI(wejsciewybrane);
      zapiszI(ilewejsc);
      zapiszB(lecatezzgory);
   end;

   {wejscia}
   for a:=0 to max_wejsc do with wejscia[a] do begin
      zapiszI(x);
      zapiszI(y);
      for a1:=0 to max_druzyn do zapiszB(druzyny[a1]);
      zapiszI(czest);
      zapiszI(proc);
   end;

   {niebo}
   with niebo do begin
      for a:=0 to 23 do with kolorytla[a] do begin
         zapiszB(zmiana);
         zapiszBt(gr);
         zapiszBt(gg);
         zapiszBt(gb);
         zapiszBt(dr);
         zapiszBt(dg);
         zapiszBt(db);
         zapiszBt(dlugosc);
         zapiszBt(bierzdanez);
      end;

      zapiszC(kolorytlag);
      zapiszC(kolorytlad);
      zapiszC(kolorterenu);

      zapiszR(rampr);
      zapiszR(rampg);
      zapiszR(rampb);
      zapiszI(tlo_grad_il);
      zapiszI(tlo_grad_skok);
      zapiszI(kolorytlaszybkosc);

      zapiszI(tlowidth);
      zapiszI(tloheight);

      zapiszB(widslon);
      zapiszB(winksie);
      zapiszB(widgwia);
      zapiszB(widchmu);
      zapiszB(widdeszsnie);
   end;

   {----obiekty-----}
    {druzyny}
    for a:=0 to max_druzyn do with druzyna[a] do begin
        for a1:=1 to 4 do zapiszI(maxamunicji[a1]);
        zapiszI(startsila);
        zapiszBt(startbron);
        zapiszBt(startamunicja);
        zapiszI(ma_byc_kolesi);
        for a1:=0 to max_druzyn do zapiszB(przyjaciele[a1]);
    end;

    {kolesie}
    zapiszI(max_kol);
    for a:=0 to max_kol do with koles[a] do begin
        zapiszBt(team);
        zapiszR(x);
        zapiszR(y);
        zapiszB(jest);
        zapiszS(kierunek);
        zapiszI(sila);
        zapiszBt(bron);
        zapiszI(amunicja);
        zapiszI(tlen);
    end;

    {zwierzaki}
    zapiszI(max_zwierz);
    for a:=0 to max_zwierz do with zwierz[a] do begin
        zapiszR(x);
        zapiszR(y);
        zapiszB(jest);
        zapiszBt(rodzaj);
        zapiszBt(gatunek);
        zapiszR(klatka);
        zapiszS(kierunek);
        zapiszB(lezy);
        zapiszI(sila);
    end;

    {miny}
    zapiszI(max_mina);
    for a:=0 to max_mina do with mina[a] do begin
        zapiszR(x);
        zapiszR(y);
        zapiszB(jest);
        zapiszB(zepsuta);
        zapiszR(klatka);
        zapiszBt(rodzaj);
        zapiszB(lezy);
        zapiszB(zaczepiona);
        zapiszI(dl_zaczep);
        zapiszI(zaczx);
        zapiszI(zaczy);
        zapiszI(czasdowybuchu);
    end;

    {przedmioty}
    zapiszI(max_przedm);
    for a:=0 to max_przedm do with przedm[a] do begin
        zapiszR(x);
        zapiszR(y);
        zapiszB(jest);
        zapiszBt(rodzaj);
        zapiszR(klatka);
        zapiszR(kat);
        zapiszB(lezy);
    end;

    {chmurki}
    for a:=0 to max_chmurki do with chmurka[a] do begin
        zapiszR(x);
        zapiszR(y);
        zapiszR(szybkosc);
        zapiszB(jest);
        zapiszBt(wyglad);
        zapiszI(wielkoscx);
        zapiszI(wielkoscy);
        zapiszC(kolor);
        zapiszR(ciemnosc);
        zapiszB(ztylu);
        zapiszB(odbita);
    end;

    {swiatla}
    zapiszI(max_swiatla);
    for a:=0 to max_swiatla do with swiatla[a] do begin
        zapiszI(x);
        zapiszI(y);
        zapiszBt(typ);
        zapiszI(wielkosc);
        zapiszI(kat);
        zapiszC(kolor);
        zapiszB(zniszczalne);
        zapiszBt(efekt);
        zapiszB(ztylu);
    end;


finally
   if plik<>nil then begin
      plik.Free;
      plik:=nil;
      log('Zapis terenu w trybie PELNYM zakonczony powodzeniem');  //trzeba tu zrobic try..except i dodac bledy!
   end;
end;

form1.schowaj_wczytywanie;

end;

procedure wczytaj_teren_z_pliku_full(nazwa:string; z_kolesiami:boolean);
var
plik:TFileStream;
LRect: TD3DLocked_Rect;
g:array[0..2047] of cardinal;
DestPtr:pointer;
nagtmp:Ts3tnag;
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
log('Wczytywanie terenu w trybie PELNYM z pliku: '+nazwa);
plik:=TFileStream.Create('Terrains\'+nazwa+'.s3ter', fmOpenRead);
form1.pokaz_wczytywanie('Wczytywanie terenu');
try
   if obr.teren.surf<>nil then begin
      obr.teren.surf.Free;
      obr.teren.surf:=nil;
   end;
   obr.teren.surf:=TAGFImage.Create(form1.PowerDraw1);

   teren.width:=wczytajI;
   teren.height:=wczytajI;
   rozmx:=teren.width;
   rozmy:=teren.height;

   a:=0;
   while (a<high(dozwrozm)) and (dozwrozm[a]<rozmx) do inc(a);
   tx:=dozwrozm[a];
   a:=0;
   while (a<high(dozwrozm)) and (dozwrozm[a]<rozmy) do inc(a);
   ty:=dozwrozm[a];

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


   obr.teren.surf.Lock(0, LRect);

   {rysunek}

   for y:=0 to teren.height-1 do begin
       DestPtr:=Pointer(Integer(LRect.Bits) + (LRect.Pitch * y));
       plik.ReadBuffer(g,4*teren.width);
       pdrawLineConv(@g, DestPtr, teren.width, obr.teren.surf.Format, D3DFMT_A8R8G8B8);
   end;

   obr.teren.surf.unLock(0);

   plik.ReadBuffer(nagtmp,sizeof(nagtmp));

   {maska}
   setlength(teren.maska, teren.width+1);
   for x:=0 to teren.width-1 do begin
       setlength(teren.maska[x],teren.height+31);
       plik.ReadBuffer(teren.maska[x,0],teren.height);
   end;

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

        stopien_spalenia:=255;
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
    max_zwierz:=wczytajI;
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


finally
   if plik<>nil then begin
      plik.Free;
      plik:=nil;
      log('Odczyt terenu w trybie PELNYM zakonczony powodzeniem'); //trzeba tu zrobic try..except i dodac bledy!
   end;
end;

form1.schowaj_wczytywanie;
end;

{----------------rekordy-------------------------------------------------------}

procedure zapisz_rekordy_lokalne;
var
p:file; i:integer;
begin
log('Zapis rekordow lokalnyh');
assignfile(p,'hiscore.hi');
{$I-}
filemode:=1;
rewrite(p,1);
{$I+}
if ioresult=0 then begin
   {$I-}

   blockwrite(p,rekordynag,sizeof(rekordynag));

   for i:=1 to ilemiejsc_lokalnie do begin
       blockwrite(p,listarekordow_lokalna[i].pkt,sizeof(listarekordow_lokalna[i].pkt));
       blockwrite(p,listarekordow_lokalna[i].trupy,sizeof(listarekordow_lokalna[i].trupy));
       blockwrite(p,listarekordow_lokalna[i].imie,sizeof(listarekordow_lokalna[i].imie));
       blockwrite(p,listarekordow_lokalna[i].data,sizeof(listarekordow_lokalna[i].data));
       blockwrite(p,listarekordow_lokalna[i].czas,sizeof(listarekordow_lokalna[i].czas));
   end;

   closefile(p);
   {$I+}
   i:=ioresult;
   if i<>0 then log('BLAD podczas zapisu rekordow lokalnych!');
end else
    log('BLAD przy probie zapisu rekordow lokalnych!');
end;

procedure wczytaj_rekordy_lokalne;
var
p:file; i:integer;
tmp:Ts3tnag;
begin
log('Wczytywanie rekordow lokalnyh');
for i:=1 to ilemiejsc_lokalnie do begin
    listarekordow_lokalna[i].pkt:=random(5000);
    listarekordow_lokalna[i].trupy:=random(100);
    listarekordow_lokalna[i].imie:=domyslne_imie;
    listarekordow_lokalna[i].data:=now;
    listarekordow_lokalna[i].czas:=0;
end;

assignfile(p,'hiscore.hi');
{$I-}
filemode:=0;
reset(p,1);
{$I+}
if ioresult=0 then begin
   {$I-}
   blockread(p,tmp,sizeof(tmp));

   if tmp=rekordynag then begin
       for i:=1 to ilemiejsc_lokalnie do begin
           blockread(p,listarekordow_lokalna[i].pkt,sizeof(listarekordow_lokalna[i].pkt));
           blockread(p,listarekordow_lokalna[i].trupy,sizeof(listarekordow_lokalna[i].trupy));
           blockread(p,listarekordow_lokalna[i].imie,sizeof(listarekordow_lokalna[i].imie));
           blockread(p,listarekordow_lokalna[i].data,sizeof(listarekordow_lokalna[i].data));
           blockread(p,listarekordow_lokalna[i].czas,sizeof(listarekordow_lokalna[i].czas));
       end;
   end;

   closefile(p);
   {$I+}
   i:=ioresult;
   if i<>0 then log('BLAD podczas odczytu rekordow lokalnych!');
end else
    log('BLAD przy probie odczytu rekordow lokalnych!');

sortuj_rekordy(listarekordow_lokalna);
end;

procedure sortuj_rekordy(var rek:array of Trekordwynik);
var
a:integer; ok:boolean;
tmp:Trekordwynik;
begin
log('Sortowanie rekordow');
repeat
   ok:=true;

   for a:=low(rek) to high(rek)-1 do begin
       if rek[a].pkt<rek[a+1].pkt then begin
          tmp:=rek[a];
          rek[a]:=rek[a+1];
          rek[a+1]:=tmp;
          ok:=false;
       end;
   end;

until ok;
end;

procedure zrob_liste_lokalna_tmp;
var a:integer;
teraz:tdatetime;
begin
log('Tworzenie domyslnej listy rekordow lokalnych');
  for a:=1 to ilemiejsc_lokalnie do
     listarekordow_lokalna_tmp[a]:=listarekordow_lokalna[a];

 teraz:=now;

 listarekordow_lokalna_tmp[ilemiejsc_lokalnie+1].pkt:=gracz.pkt;
 listarekordow_lokalna_tmp[ilemiejsc_lokalnie+1].trupy:=gracz.trupow;
 listarekordow_lokalna_tmp[ilemiejsc_lokalnie+1].imie:=gracz.imie;
 listarekordow_lokalna_tmp[ilemiejsc_lokalnie+1].data:=teraz;
 listarekordow_lokalna_tmp[ilemiejsc_lokalnie+1].czas:=gracz.czas;

 sortuj_rekordy(listarekordow_lokalna_tmp);

 for a:=1 to ilemiejsc_lokalnie+1 do
     if (listarekordow_lokalna_tmp[a].data=teraz) and
        (listarekordow_lokalna_tmp[a].imie=gracz.imie) and
        (listarekordow_lokalna_tmp[a].pkt=gracz.pkt) and
        (listarekordow_lokalna_tmp[a].trupy=gracz.trupow) then
        listarekordow_lokalna_tmp_gdziegracz:=a;

end;


procedure wczytaj_scenariusz(nazwa:string; zmieniaj_wode:boolean=true);
var
  p:TStream;
  a,b,a1:integer;
  tmp:Ts3scenaglowek;

  st:string;
  sd:Tdate;

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

   if tmp<>s3scenaglowek then Raise EReadError.Create('Zly naglowek');

   {form1.nnazwa.text}st:=wczytajstring(p);
   {form1.nautor.text}st:=wczytajstring(p);
   {form1.ndatastworzenia.Date}sd:=wczytajD;

   {najpierw kolory tla, zeby latwo bylo je wczytac osobno}
   for a:=0 to 23 do begin
       niebo.kolorytla[a].zmiana:=wczytajB;
       niebo.kolorytla[a].gr:=wczytajBt;
       niebo.kolorytla[a].gg:=wczytajBt;
       niebo.kolorytla[a].gb:=wczytajBt;
       niebo.kolorytla[a].dr:=wczytajBt;
       niebo.kolorytla[a].dg:=wczytajBt;
       niebo.kolorytla[a].db:=wczytajBt;
   end;

   {potem cala reszta}
   niebo.widslon:=wczytajB;
   niebo.winksie:=wczytajB;
   niebo.widgwia:=wczytajB;
   niebo.widchmu:=wczytajB;
   niebo.widdeszsnie:=wczytajB;

   niebo.kolorytlaszybkosc:=wczytajI;

   b:=wczytajI;
   setlength(wlasc_scenariusza.obiekty,0);
   for a:=0 to b-1 do begin
       st:=wczytajstring(p)+'.tga';
       a1:=0;
       while (a1<=high(listyplikow[0])) and (uppercase(listyplikow[0][a1])<>uppercase(st)) do
             inc(a1);
       if a1<=high(listyplikow[0]) then begin
          setlength(wlasc_scenariusza.obiekty,length(wlasc_scenariusza.obiekty)+1);
          wlasc_scenariusza.obiekty[high(wlasc_scenariusza.obiekty)].naz:=st;
          wlasc_scenariusza.obiekty[high(wlasc_scenariusza.obiekty)].nr:=a1;
       end;
   end;

   wlasc_scenariusza.tekstura:=wczytajstring(p);
   //dodac sprawdzenie czy wybrana tekstura istnieje!!

   wlasc_scenariusza.wierzch[0].ef:=wczytajI;
   wlasc_scenariusza.wierzch[0].kol:=wczytajC;
   wlasc_scenariusza.wierzch[1].ef:=wczytajI;
   wlasc_scenariusza.wierzch[1].kol:=wczytajC;

   b:=0;
   for a:=0 to 5 do begin
       wlasc_scenariusza.ciecze[a]:=wczytajB;
       if wlasc_scenariusza.ciecze[a] then b:=1;
   end;
   if b=0 then wlasc_scenariusza.ciecze[0]:=true;

   if zmieniaj_wode then begin
       repeat
          a:=random(1+max_wod);
       until wlasc_scenariusza.ciecze[a];
       warunki.typ_wody:=a;
   end;

   p.free;
  except
     p.free;
     //MessageBox(hnd, 'Blad przy odczycie pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
  end;
end else begin
   //MessageBox(hnd, 'Nie ma takiego pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
end;
end;

{-- konfig -------------------------------------------------------------------}
procedure wczytaj_kfg;
var p:TStream;

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

 function wczytajBt:byte;
 var b:byte;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajBt:=b;
 end;

 function wczytajS:single;
 var b:single;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajS:=b;
 end;

 function wczytajR:real;
 var b:real;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajR:=b;
 end;

var b:boolean;a,a1:integer;
begin
log('Odczyt konfiguracji ogolnej Sadist 3');
if FileExists('S3konfig.kfg') then begin
  try
   p:=TFileStream.Create('S3konfig.kfg',fmOpenRead);

   kfg.ekran.width:=wczytajI;
   kfg.ekran.height:=wczytajI;
   kfg.ekran.bitdepth:=wczytajI;
   kfg.ekran.refresh:=wczytajI;
   kfg.glebokosc_tekstur:=wczytajI;

   kfg.ekran.antialias:=wczytajB;
   kfg.ekran.dithering:=wczytajB;
   kfg.ekran.vsync:=wczytajB;
   kfg.ekran.windowed:=not wczytajB;
   b:=wczytajB;
   if b then kfg.ekran.buffers:=3
        else kfg.ekran.buffers:=2;

   max_poc:=wczytajI;
   max_syf:=wczytajI;
   max_mieso:=wczytajI;
   max_wybuchdym:=wczytajI;
   max_bombel:=wczytajI;
   max_ciezkie:=wczytajI;
   max_gwiazd:=wczytajI;
   max_deszcz:=wczytajI;

   max_kol:=wczytajI;
   max_zwlokikolesi:=max_kol;
   max_zwierz:=wczytajI;
   max_mina:=wczytajI;
   max_przedm:=wczytajI;

   kfg.calkiem_bez_dzwiekow:=wczytajB;
   kfg.calkiem_bez_muzyki:=wczytajB;
   kfg.ile_kanalow:=wczytajBt;

   for a:=0 to 30 do klawisze[a]:=wczytajBt;

   if p<>nil then begin
      p.Free;
      p:=nil
   end;
  except
   if p<>nil then begin
      p.Free;
      p:=nil
   end;
   log('BLAD podczas odczytu konfiguracji ogolnej');
  end;
end else begin
    log('BLAD przy probie odczytu konfiguracji ogolnej: plik nie istnieje');
    wywalblad('B³¹d przy próbie odczytu konfiguracji ogólnej: plik nie istnieje.'#13#10'Uruchom najpierw konfiguracjê gry!');
    exit;
end;

{-------------------------------------------}
log('Odczyt konfiguracji Sadist 3');
if FileExists('S3normkonfig.kfg') then begin
  try
   p:=TFileStream.Create('S3normkonfig.kfg',fmOpenRead);


   with kfg do begin
      glosnosc:=wczytajI;
      glosnoscmuzyki:=wczytajS;
      jest_muzyka:=wczytajB;
      jest_dzwiek:=wczytajB;
      glos_zlego_pana:=wczytajB;
      odblaski:=wczytajB;
      wybuchydymy:=wczytajB;
      swiatla:=wczytajB;
      krew_mieso_zostawia_slady:=wczytajB;
      jaki_kursor:=wczytajBt;
      pokazuj_info:=wczytajB;
      wskazniki_kolesi:=wczytajB;
      chowaj_liczniki:=wczytajB;
      trzesienie:=wczytajB;
      detale:=wczytajI;
      efekty_soczewki:=wczytajB;
      sterowanie:=wczytajBt;
      dymki_kolesi:=wczytajBt;
   end;

   with druzynymenu do begin
      lecatezzgory:=wczytajB;
      wybrana:=wczytajI;
   end;
   with ekran do begin
      pokazuj_wyniki:=wczytajB;
      menux:=wczytajI;
      menu_widoczne:=wczytajBt;
   end;
   with bron do begin
      wybrana:=wczytajI;
      kat:=wczytajI;
      sila:=wczytajI;
      for a:=0 to 9 do
          ulubiona[a]:=wczytajI;
      for a:=0 to max_broni do begin
          for a1:=0 to high(bronmenuuklad[a]) do
              bronmenuuklad[a][a1].wartosc:=wczytajI;
{          ustawienia[a].w1:=wczytajI;
          ustawienia[a].w2:=wczytajI;
          ustawienia[a].w3:=wczytajI;}
      end;
   end;
   with gracz do begin
      imie:=wczytajstring(p);
      punktyglobalne_od:=wczytajI64;  punktyglobalne:=punktyglobalne_od;
      trupyglobalne_od:=wczytajI64;   trupyglobalne:=trupyglobalne_od;
      paczkiglobalne_od:=wczytajI64;   paczkiglobalne:=paczkiglobalne_od;
      globalniebylogier:=wczytajI64 + 1;
   end;
   with warunki do begin
      agresja:=wczytajI;
      walka_ze_swoimi:=wczytajB;
      walka_bez_powodu:=wczytajB;
      zwierzeta_same:=wczytajB;
      chmurki:=wczytajB;
      grawitacja:=wczytajR;
      czestpaczek:=wczytajI;
      paczkidowolnie:=wczytajB;
      walka_z_kursorem:=wczytajB;
   end;
   with rysowanie do begin
      kolor:=wczytajC;
      twardosc:=wczytajBt;
      rozmiar:=wczytajBt;
      ziarna:=wczytajBt;
      corobi:=wczytajBt;
      odwrocony:=wczytajB;
      ztylu:=wczytajB;
      ksztaltpedzla:=wczytajBt;
      dlugosc:=wczytajBt;
      kat:=wczytajI;
      odleglosci:=wczytajI;
      maskowanie:=wczytajBt;
      pokaz_maske:=wczytajB;
      cien.kolorg:=wczytajC;
      cien.kolord:=wczytajC;
      cien.efg:=wczytajBt;
      cien.efd:=wczytajBt;
      rysmenuuklad[0][0].wartosc:=(kolor and $00FF0000) shr 16;
      rysmenuuklad[0][3].wartosc:=(kolor and $0000FF00) shr 8;
      rysmenuuklad[0][6].wartosc:=kolor and $000000FF;
      rysmenuuklad[0][1].wartosc:=twardosc; rysmenuuklad[1][1].wartosc:=rysmenuuklad[0][1].wartosc; rysmenuuklad[2][1].wartosc:=rysmenuuklad[0][1].wartosc;
      rysmenuuklad[0][2].wartosc:=rozmiar; rysmenuuklad[1][2].wartosc:=rysmenuuklad[0][2].wartosc;
      rysmenuuklad[0][4].wartosc:=ziarna;
      rysmenuuklad[0][5].wartosc:=ksztaltpedzla; rysmenuuklad[1][5].wartosc:=rysmenuuklad[0][5].wartosc;
      rysmenuuklad[0][8].wartosc:=ord(ztylu); rysmenuuklad[1][8].wartosc:=rysmenuuklad[0][8].wartosc; rysmenuuklad[2][9].wartosc:=rysmenuuklad[0][8].wartosc;
      rysmenuuklad[0][7].wartosc:=maskowanie; rysmenuuklad[1][7].wartosc:=rysmenuuklad[0][7].wartosc; rysmenuuklad[2][8].wartosc:=rysmenuuklad[0][7].wartosc;
   end;

   for a:=0 to 9 do
       druzyna[a].kolor_druzyny:=wczytajC;

   for a:=0 to 9 do
       druzyna[a].numerplikunaliscie:=wczytajI;

   menumisje.wybrana:=wczytajI;
   menutereny.wybrany:=wczytajI;
   menuscen.wybrany:=wczytajI;

   with ustawienia_terenu do begin
      width:=wczytajI;
      height:=wczytajI;
      podloze:=wczytajB;
      obiekty:=wczytajB;
      przedmioty:=wczytajB;
      miny:=wczytajB;
      ustawienia_terenu.nazwaterenu:=wczytajstring(p);
   end;

   wejscia[0].czest:=wczytajI;
   wejscia[0].proc:=wczytajI;

   if p<>nil then begin
      p.Free;
      p:=nil
   end;
  except
   if p<>nil then begin
      p.Free;
      p:=nil
   end;
   log('BLAD podczas odczytu konfiguracji');
  end;
end else begin
    log('BLAD przy probie odczytu konfiguracji: plik nie istnieje');
end;



end;

procedure zapisz_kfg;
var p:TStream; a,a1:integer;

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

 procedure zapiszBt(i:byte);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

 procedure zapiszS(i:single);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

 procedure zapiszR(i:real);
 begin
    p.WriteBuffer(i,sizeof(i));
 end;

begin
log('Zapis konfiguracji Sadist 3');
try
   p:=TFileStream.Create('S3normkonfig.kfg', fmCreate);

   with kfg do begin
      zapiszI(glosnosc);
      zapiszS(glosnoscmuzyki);
      zapiszB(jest_muzyka);
      zapiszB(jest_dzwiek);
      zapiszB(glos_zlego_pana);
      zapiszB(odblaski);
      zapiszB(wybuchydymy);
      zapiszB(swiatla);
      zapiszB(krew_mieso_zostawia_slady);
      zapiszBt(jaki_kursor);
      zapiszB(pokazuj_info);
      zapiszB(wskazniki_kolesi);
      zapiszB(chowaj_liczniki);
      zapiszB(trzesienie);
      zapiszI(detale);
      zapiszB(efekty_soczewki);
      zapiszBt(sterowanie);
      zapiszBt(dymki_kolesi);
   end;

   with druzynymenu do begin
      zapiszB(lecatezzgory);
      zapiszI(wybrana);
   end;
   with ekran do begin
      zapiszB(pokazuj_wyniki);
      zapiszI(menux);
      zapiszBt(menu_widoczne);
   end;
   with bron do begin
      zapiszI(wybrana);
      zapiszI(kat);
      zapiszI(sila);
      for a:=0 to 9 do
          zapiszI(ulubiona[a]);
      for a:=0 to max_broni do begin
          for a1:=0 to high(bronmenuuklad[a]) do
              zapiszI(bronmenuuklad[a][a1].wartosc);
{          zapiszI(ustawienia[a].w1);
          zapiszI(ustawienia[a].w2);
          zapiszI(ustawienia[a].w3);}
      end;
   end;
   with gracz do begin
      zapiszstring(p,imie);
      zapiszI64(punktyglobalne);
      zapiszI64(trupyglobalne);
      zapiszI64(paczkiglobalne);
      zapiszI64(globalniebylogier);
   end;
   with warunki do begin
      zapiszI(agresja);
      zapiszB(walka_ze_swoimi);
      zapiszB(walka_bez_powodu);
      zapiszB(zwierzeta_same);
      zapiszB(chmurki);
      zapiszR(grawitacja);
      zapiszI(czestpaczek);
      zapiszB(paczkidowolnie);
      zapiszB(walka_z_kursorem);
   end;
   with rysowanie do begin
      zapiszC(kolor);
      zapiszBt(twardosc);
      zapiszBt(rozmiar);
      zapiszBt(ziarna);
      zapiszBt(corobi);
      zapiszB(odwrocony);
      zapiszB(ztylu);
      zapiszBt(ksztaltpedzla);
      zapiszBt(dlugosc);
      zapiszI(kat);
      zapiszI(odleglosci);
      zapiszBt(maskowanie);
      zapiszB(pokaz_maske);
      zapiszC(cien.kolorg);
      zapiszC(cien.kolord);
      zapiszbt(cien.efg);
      zapiszbt(cien.efd);
      rysmenuuklad[0][0].wartosc:=(kolor and $00FF0000) shr 16;
      rysmenuuklad[0][3].wartosc:=(kolor and $0000FF00) shr 8;
      rysmenuuklad[0][6].wartosc:=kolor and $000000FF;
      rysmenuuklad[0][1].wartosc:=twardosc; rysmenuuklad[1][1].wartosc:=rysmenuuklad[0][1].wartosc; rysmenuuklad[2][1].wartosc:=rysmenuuklad[0][1].wartosc;
      rysmenuuklad[0][2].wartosc:=rozmiar; rysmenuuklad[1][2].wartosc:=rysmenuuklad[0][2].wartosc;
      rysmenuuklad[0][4].wartosc:=ziarna;
      rysmenuuklad[0][5].wartosc:=ksztaltpedzla; rysmenuuklad[1][5].wartosc:=rysmenuuklad[0][5].wartosc;
      rysmenuuklad[0][8].wartosc:=ord(ztylu); rysmenuuklad[1][8].wartosc:=rysmenuuklad[0][8].wartosc; rysmenuuklad[2][9].wartosc:=rysmenuuklad[0][8].wartosc;
      rysmenuuklad[0][7].wartosc:=maskowanie; rysmenuuklad[1][7].wartosc:=rysmenuuklad[0][7].wartosc; rysmenuuklad[2][8].wartosc:=rysmenuuklad[0][7].wartosc;
   end;

   for a:=0 to 9 do
       zapiszC(druzyna[a].kolor_druzyny);

   for a:=0 to 9 do
       zapiszI(druzyna[a].numerplikunaliscie);

   zapiszI(menumisje.wybrana);
   zapiszI(menutereny.wybrany);
   zapiszI(menuscen.wybrany);

   with ustawienia_terenu do begin
      zapiszI(width);
      zapiszI(height);
      zapiszB(podloze);
      zapiszB(obiekty);
      zapiszB(przedmioty);
      zapiszB(miny);
      zapiszstring(p,ustawienia_terenu.nazwaterenu);
   end;

   zapiszI(wejscia[0].czest);
   zapiszI(wejscia[0].proc);

   p.Free;
except
   p.Free;
   log('Blad podczas zapisu pliku konfiguracji Sadist 3');
end;

{----------------------}
log('Zapis listy ukoñczonych misji');
try
   p:=TFileStream.Create('S3miskonfig.kfg', fmCreate);

   //najpierw zlicz ile ich jest
   a1:=0;
   for a:=0 to high(skonczonemisje) do begin
       if skonczonemisje[a] then inc(a1);
   end;

   zapiszI(a1);
   log('Suma:'+l2t(a1,0));

   //zapisz wszystkie
   for a:=0 to high(skonczonemisje) do begin
       if skonczonemisje[a] then begin
          zapiszstring(p, listyplikow[5][a]);
          log(' - '+listyplikow[5][a]);
       end;
   end;

   p.Free;
except
   p.Free;
   log('Blad podczas zapisu pliku listy ukoñczonych misji');
end;




end;

//odczytuje z pliku liste skonczonych misji i je oznacza w tablicy
procedure przejrzyjskonczonemisje;
var a,b,ile:integer; s:string; p:TStream;

 function wczytajI:integer;
 var b:integer;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajI:=b;
 end;

begin
log('Odczyt listy ukoñczonych misji i jej sprawdzenie');
if FileExists('S3miskonfig.kfg') then begin
  try
   p:=TFileStream.Create('S3miskonfig.kfg',fmOpenRead);

   //najpierw suma
   ile:=wczytajI;

   for a:=0 to ile-1 do begin
       s:=wczytajstring(p);
       log(' - '+s);
       s:=UpperCase(s);

       b:=0;
       while (b<=high(listyplikow[5])) and (s<>UpperCase(listyplikow[5][b])) do inc(b);
       if b<=high(listyplikow[5]) then begin
          skonczonemisje[b]:=true;
          log('    Znaleziono misje na liscie, oznaczono jako skonczona');
       end else
           log('    Nie znaleziono misji na liscie, nie oznaczono jako skonczona, usunieto z listy skonczonych misji');

   end;

   p.Free;
  except
   if p<>nil then begin
      p.Free;
      p:=nil
   end;
   log('Blad podczas odczytu pliku listy ukoñczonych misji!');
  end;
end else begin
   log('Blad podczas odczytu pliku listy ukoñczonych misji: plik nie istnieje');
end;

end;


//-----------------------------------------------------------------------------
procedure log(tekst:string);
var f:text; s:string;
begin
if not kfg.log then exit;

assignfile(f,'sadistlog.log');
if not FileExists('sadistlog.log') then rewrite(f)
   else Append(f);

DateTimeToString(s, 'yy-mm-dd hh:nn:ss.zzz',now);
writeln(f,'('+s+') '+tekst);

closefile(f);

{ form1.PowerDraw1.BeginScene();
Form1.PowerDraw1.FillRect(0,ekran.height-10,ekran.width,9,$FF000000,0);
piszdowolne(tekst,0,ekran.height-10,$FF00ff00, 8,9,0);
 form1.PowerDraw1.EndScene();
 form1.PowerDraw1.Present();}
end;

procedure kasujlog;
begin
if not kfg.log then exit;

if FileExists('sadistlog.old') then DeleteFile('sadistlog.old');
if FileExists('sadistlog.log') then RenameFile('sadistlog.log','sadistlog.old');
end;



end.
