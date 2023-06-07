unit vars;

interface
uses graphics,DXSounds, agfunit, TGAReader, unitstringi, classes, UnitDzwiek;

const
  ilemiejsc_lokalnie=20;
  ilemiejsc_globalnie=100;

  kolor_przyciemnienia=$d0e0e0ff;

  pi180=pi/180;

type
Tnagloweks3p=array[0..8] of char;

const
nagloweks3p:Tnagloweks3p=('S','3','T','e','a','m','1','0','0');


type
  TmenuukladI=record
          nl:boolean;
          typ:byte; { 0-nie ma,1-suwak,2-przelacznik 1/0, 3-ikona }
          mn,mx,wartosc:integer;
          ikona:byte; {0:brak; 1..255}
          offset:integer; {o ile przesunac nastepne guziki; nie ustawienie tego daje domyslne}
          sz:word; {szerokosc suwaka w pixelach (w menu warunki!)}
          tt:string; {tultip}
    end;

  Trekordwynik=record
      pkt,
      trupy:int64;
      imie:string[30];
      data:tdatetime;
      czas:int64;
  end;

var
  listarekordow_lokalna:array[1..ilemiejsc_lokalnie] of Trekordwynik;
  listarekordow_lokalna_tmp:array[1..1+ilemiejsc_lokalnie] of Trekordwynik; {to samo co lokalna, ale z obecna gra dodana}
  listarekordow_lokalna_tmp_gdziegracz:integer;
  listarekordow_globalna:array[1..ilemiejsc_globalnie] of Trekordwynik;

const

  koles_rx=30;
  koles_ry=30;
  koles_prx=15; {polowa rx}
  koles_pry=15;

  max_druzyn=9;

  max_napis=19;

  max_wejsc=20;

var
  max_poc:word=200;
  max_mina:word=100;
  max_kol:word=100;
  max_syf:word=600;
  max_mieso:word=100;
  max_wybuchdym:word=300;
  max_bombel:word=300;
  max_przedm:word=100;
  max_zwierz:word=100;
  max_ciezkie:word=20;
  max_gwiazd:word=100;
  max_deszcz:word=300;
  max_swiatla:word=100;

  max_zwlokikolesi:word=100;

  max_flara: word = 100;
  ile_flara: word;

const
  max_chmurki=70;

const
  max_wod=5; {0..max_wod - tyle rodzajow wody, lawy, kwasu itd}

  menubroniekategorie:array[0..9] of integer=
          ( 1, 2, 5,10,11,36,42,24,39, 4);
var
menubronie:array[0..9,0..10] of integer=(
        (01,16,14,54,08,17,31,32,58,-1,-1),
        (02,15,03,13,21,52,22,34,53,-1,-1),
        (05,06,07,29,-1,-1,-1,-1,-1,-1,-1),
        (10,18,19,57,-1,-1,-1,-1,-1,-1,-1),
        (12,33,11,26,40,-1,-1,-1,-1,-1,-1),
        (36,37,38,45,51,47,-1,-1,-1,-1,-1),
        (41,42,43,44,48,55,-1,-1,-1,-1,-1),
        (24,25,27,46,-1,-1,-1,-1,-1,-1,-1),
        (49,50,00,39,56,-1,-1,-1,-1,-1,-1),
        (23,35,04,30,09,28,-1,-1,-1,-1,-1)
        );
         {(( 1,16,14, 8,17,26,31,32,38,47,53),
          ( 2, 3,13,15,21,22,34,37,51,40,52),
          ( 5, 6, 7,29,54,55,56,-1,-1,-1,-1),
          (11,12,33,36,45,-1,-1,-1,-1,-1,-1),
          (10,18,19,-1,-1,-1,-1,-1,-1,-1,-1),
          (24,25,27,46,-1,-1,-1,-1,-1,-1,-1),
          (41,42,43,44,48,-1,-1,-1,-1,-1,-1),
          ( 4,23, 9,28,30,35,-1,-1,-1,-1,-1),
          (39,49,50, 0,-1,-1,-1,-1,-1,-1,-1)
         );}
const
  menu_odstepy_miedzy_suwakami=17+20{ikona};


  dozwrozm:array[0..11] of word = (1,2,4,8,16,32,64,128,256,512,1024,2048);

type
  BMPHeader = record
    bfType           : Word;
    bfSize,
    bfReserved,
    bfOffBits,
    biSize,
    biWidth,
    biHeight         : longint;
    biPlanes,
    biBitCount       : Word;
    biCompression,
    biSizeImage,
    biXPelsPerMeter,
    biYPelsPerMeter,
    biClrUsed,
    biClrImportant   : longint;
  end;
  TGAHeader = record
   idlength:byte;
   colourmaptype:byte;
   datatypecode:byte;
   colourmaporigin:smallint;
   colourmaplength:smallint;
   colourmapdepth:byte;
   x_origin:smallint;
   y_origin:smallint;
   width:word;
   height:word;
   bitsperpixel:byte;
   imagedescriptor:byte;
  end;

  Tmysz=record
     x,y,
     sx,sy,
     ekranx,ekrany,
     gmarg,dmarg:integer;
     l,r,
     menul,menur,menustop:boolean;
     wyglad:smallint;
     jest_obracanie:boolean; {czy w tej chwili mozna obracac celownik?}

     dx,dy: integer;
  end;

  TSprajt=record
        surf:TAGFImage;
        rx,ry:integer;
        ofsx,ofsy:integer;
        klatek:integer;
        end;

  Tkoles=record
        team:byte;
        x,y,dx,dy:real;
        zebrac:integer; {ktory przedmiot chce zebrac; -1: zaden}
        czaszbierania:integer; {jak dlugo probuje zebrac; jak bedzie za duzo, to rezygnuje}
        zabic:integer; {ktorego chce zabic; -1: zaden (wiekszy priorytet ma zebranie)}
        jest:boolean;

        corobi:shortint;
        corobil:shortint; {po zrobieniu niektorych czynnosci powraca do 'corobil'; -1 oznacza, ze nie ma do czego wracac}
        skocz:boolean; {jak tylko da rade, to zaraz skoczy}
        ile_wspina:byte; {0:nie wspina sie; >=1:ma sie wspinac jeszcze x klatek}

        kierunek:shortint;
        sila:integer;
        ktoretrzymamieso:integer;

        bron:byte; {0-zadna(kopie,bije), 1-granaty }
        amunicja:smallint;
        tlen:integer;
        niewidzialnosc: integer; {jesli >0, to koles jest niewidzialny}

        cochcekopnac:byte; {co chce kopnac: 0-koles, 1-mieso}
        ktoregochcekopnac:integer; {numer kolesia, ktorego bedzie teraz mial kopnac, po zaczeciu animacji kopania}
        strzelaWX,strzelaWY:integer; {miejsce, gdzie koles zamierza strzelic}
        katStrzalu:integer; {do ustawienia giwery}

        palisie:boolean;

        juz_sa_zwloki:boolean; {jesli false, a sila<=0 to przed jest:=false zostana "postawione" w tym miejscu kawalki miesa}

        stopien_spalenia:byte; {od 255 do 5 idzie i jest to po prostu sciemnienie koloru mieska az do czerni :>}
        kolor:cardinal;

        zainteresowanie_miesem: integer; {zadnym=-1; ktorym miesem czy smieciem interesuje sie postac i za nim biega}

        ani, {numer animacji}
        anikl, {klatka animacji}
        anisz, {szybkosc animacji: co ile iteracji zmieniac klatke}
        anido  {caly czas sie zmniejsza. jak dojdzie do 0 to zmiana klatki}
         :integer;
        jaksienudzi:integer; {ktora animacja nudzenia wlasnie jest, kiedy stoi?}

        gadaczas, gadaani, gadanr: integer;
        
        przenoszony:boolean; {myszka, z shiftem}
        end;

  Tdruzyna=record
        dzwieki:TDzwieki;
        dzwieki_init:boolean;
        {0-stoi,                              T
         1-idzie,                             T = tekst 'zdrajca!'
         2-biegnie,
         3-rzuca,                             T
         4-cieszysie,                         T
         5-trzyma,                            T
         6-plynie w bok,
         7-panikuje,                          T
         8-kopie,
         9-strzela(jak rzuca),
         10-nurkuje(jak stoi),
         11-bije,
         12-wyrzuca to co trzyma,             T
         13-obraca sie w powietrzu,
         14-spada machajac rekami,
         15-wali z grzywy,
         16-pokazuje przeciwnika kolegom ;)   T
         17-skacze
         18-wspina sie w gore
        }
        animacje:array[0..18] of TSprajt;
        anidzialanie:array[0..18] of record {w odpowiednich animacjach dzialanie, w ktorej klatce i}
            x,y:shortint;{licz od srodka!} {w ktorym miejscu klatki (np. do strzelania, kopania)}
            klatka:byte;                   {w ktorej klatce}
            dx,dy:single;                  {wektor kierunku - tez nie wszedzie potrzebny,glownie do bicia i kopania}
            end;
        aniszyb:array[0..18] of word;
        aninudzi:array of record
            od,ile,szyb:word;
            tylkoraz:boolean;
            end;
        anibombana:array[0..18] of array of record  {w odpowiednich animacjach gdzie i w ktora strone ma wisiec bomba zalozona}
            x,y:integer;{licz od srodka!} {w ktorym miejscu klatki}
            klatka:byte;                   {w ktorej klatce}
            end;

        aniteksty:array[0..18] of array of string; {tablice tekstow do dymkow dla poszczegolnych animacji}

        mieso:array[0..5] of TSprajt; {0-glowa,1-brzuch,2-lewa noga,3-prawa noga,4-lewa reka,5-prawa reka}
        miesomiejsca:array[0..5] of record {pozycje kolejnych kawalkow miejsca na sprajcie,kiedy ginie}
            x,y:smallint;
            kl:smallint; {klatka, od ktorej mieso zaczyna swoja animacje}
            kat,odl:integer;
            zaczx,zaczy:smallint;
            end;

        bronmiejsca:array[0..18] of array of record {pozycje broni w kazdej klatce kazdej animacji}
            x,y:integer;
            kat:byte;
            end;

        maxamunicji:array[1..4] of integer; {maxymalna ilosc amunicji poszczegolnych broni}
        maxtlen, {maxymalna ilosc tlenu}
        maxsila,
        startsila:integer; {sila, z jaka zaczyna}
        szybkosc,waga,silabicia:real;

        kolor_krwi, kolor_druzyny:cardinal;
        syfslad:array[0..4] of array[0..6,0..6] of cardinal; {sprajty sladow krwi w kolorze krwi druzyny}


        {ponizsze dotyczy wychodzenia kolesi z tej druzyny, zmiana w dolnym menu, nie zapisywane w plikach druzyn!}
        startbron:byte;
        startamunicja:byte;
        {'startsila' zmieniane jest w dolnym menu, ale wczytywane z druzyny}
        jest_kolesi,
        ma_byc_kolesi:word; {ilosc ustawionych i obecnych kolesi z tej druzyny}
        jest_procent:byte;

        przyjaciele:array[0..max_druzyn] of boolean; {jesli true, to nie bij go, jesli false, to mozesz bic :)}

        {-}
        numerplikunaliscie:integer; {numer pliku, z ktorego wczytywany jest zestaw postaci, na liscie listyplikow[3] }
        end;

  Tpocisk=record
        x,y,dx,dy:real;
        czyj:integer;   {0..XX - kolesi, -1 - niczyj, -2 - gracza}
        jest:boolean;
        sila:byte;
        rodzaj:byte;
        waga,
        spadanie:smallint;
        odbijasie:boolean;
        czasdowybuchu:integer; {-1: bez czasu}
        klatka:single;
        wyglad:shortint;
        lezy:boolean; {true, jesli lezy na ziemi}
        rez1,rez2,rez3:integer; {rozne wartosci, w zaleznosci od rodzaju pocisku}
        nieodbijaj:byte; {przy strzelaniu tym przez kolesi: przez chwile poczatkowo nie odbijaj pocisku od ludzi; spada wciaz do zera}
        end;

  Tmina=record
        x,y,dx,dy:real;
        jest:boolean;
        czasdowybuchu:integer; {-1: bez czasu}
        aktywna,         {aktywna, czyli miga i leci jej czas; nieaktywna - czas nie leci,nie wybucha}
        zepsuta:boolean;
        klatkamiganie:shortint;
        klatka:single;
        rodzaj:byte; {0-zwykla, 1-wodna, 2-beczka}
        lezy:boolean; {true, jesli lezy na ziemi}

        zaczepiona:boolean;
        dl_zaczep:integer; {max dlugosc zaczepienia}
        zaczx,zaczy:integer; {x i y miejsca zaczepienia}

        przenoszony:boolean; {myszka, z shiftem}
        end;
  Tsyf=record
        x,y,dx,dy:real;
        jest:boolean;
        rodz,
        slady,
        klatka:byte; {klatka tylko dla krwi - jedna z 4 klatek animacji}
        obrot:single;
        gatunek:byte; {0-krew, 1-kamyczek, 2-woda, 3-iskry}
        przezroczystosc:byte;
        kolor:cardinal;
        team:shortint; {dla krwi: druzyna, z ktorej poleciala ta krew. istotne dla koloru! -1:czerwona krew}
        palisie:boolean; 

        zostaw:boolean; {w najblizszej klatce zostanie narysowany na terenie w tym miejscu gdzie jest}
        end;
  Tmieso=record
        x,y,dx,dy:real;
        jest:boolean;
        rodz,lezy:byte;
        team:shortint;
        obrot,obrsz:single;
        trzymaneprzez:integer; {kto trzyma to mieso? -1: nikt}
        zostaw:boolean; {w najblizszej klatce zostanie narysowany na terenie w tym miejscu gdzie jest}
        krwawi:byte;
        palisie:boolean;
        podpietydo:integer; {nr kawalka miesa, ktorego sie ma trzymac; -1: do zadnego}

        stopien_spalenia:byte; {od 255 do 5 idzie i jest to po prostu sciemnienie koloru mieska az do czerni :>}
        kolor:cardinal; {kolor, jaki sie robi od spalania}
        end;
  Tciezkie=record
        x,y,dx,dy:real;
        jest,lezy:boolean;
        rodz:byte;
        obrot,obrsz:single;
        zostaw:boolean; {w najblizszej klatce zostanie narysowany na terenie w tym miejscu gdzie jest}
        przenoszony:boolean; {myszka, z shiftem}
        end;
  TwybuchDym=record
        x,y,dx,dy:real;
        jest:boolean;
        rodz,
        gatunek:byte; {0-wybuch, 1-dym, 2-blysk, 3-swiatlo}
        klatka,szyb,dosz:shortint;
        przezroczysty:smallint;
        wielkosc:integer; {0:normalna, >=1: w pixelach szerokosc i wysokosc}
        kat:smallint;
        kolor:tcolor; {dla swiatel}
        wiatr:boolean; {czy reaguje na wiatr?}
        end;
  Tbombel=record
        x,y,dx,dy:real;
        jest:boolean;
        przezroczysty:byte;
        wielkosc:integer; {0:normalna, >=1: w pixelach szerokosc i wysokosc}
        end;
  Tprzedmiot=record
        x,y,dx,dy:real;
        jest:boolean;
        rodzaj:byte;
        klatka, kat:single;
        rozwal:boolean; {czy przy najblizszej okazji przedmiot ma byc rozwalony?}
        lezy:boolean; {true, jesli lezy na ziemi}
        przenoszony:boolean; {myszka, z shiftem}
        amunicja: integer; {amunicja broni}
        niebierz: integer; {czas schodzacy do zera, kiedy >0 zadna postac nie bierze przedmiotu}
        end;
  Tzwierzak=record
        x,y,dx,dy:real;
        jest:boolean;
        rodzaj,       {wyglad}
        gatunek:byte; {typ:    0-ptak, 1-ryba}
        klatka:single;
        kierunek:shortint;
        lezy:boolean; {true, jesli lezy na ziemi}
        palisie:boolean;
        sila:smallint;
        zabic,czas_zabijania:integer;
        juzzabity:boolean;
        przenoszony:boolean; {myszka, z shiftem}
        end;

  Tdeszcz=record
        x,y,dx,dy:real;
        jest:boolean;
        wyglad,        {numer klatki animacji}
        rodzaj:byte;   {0-deszcz, 1-snieg}
        przezr:byte;
        wielkosc:smallint; {256 - 100%}
        kat:smallint;
        end;
  Tchmurka=record
        x,y, szybkosc:real;
        jest:boolean;
        wyglad:byte;    {numer klatki animacji}
        wielkoscx,wielkoscy:smallint;
        kolor:cardinal;
        ciemnosc:single;
        ztylu,odbita:boolean;
        end;
  Tswiatlo=record
        x,y:integer;
        typ:byte;
        wielkosc,
        kat:word;
        kolor:cardinal;
        zniszczalne:boolean;
        efekt:byte;
        ztylu:boolean;
        end;
  Tflara=record
        x,y:integer;
        kolor: cardinal;
        wielkosc: word;
        end;


var
  tabznakow:array[char] of byte;

  koles:array of Tkoles;
  kol_nowy, kol_il:integer;
  zwlokikolesi_nowy: integer;

  poc:array of Tpocisk;
  poc_nowy:integer;

  mina:array of Tmina;
  mina_nowy:integer;
  ile_min:integer;

  syf:array of Tsyf;
  syf_nowy:integer;

  mieso:array of Tmieso;
  mieso_nowy:integer;

  ciezkie:array of Tciezkie;
  ciezkie_nowy:integer;

  wybuchdym:array of Twybuchdym;
  wybuchdym_nowy:integer;

  bombel:array of Tbombel;

  deszcz:array of Tdeszcz;
  chmurka:array of Tchmurka;

  przedm:array of Tprzedmiot;
  przedm_nowy:integer;

  zwierz:array of Tzwierzak;
  zwierz_nowy:integer;

  swiatla:array of Tswiatlo;
  ile_swiatel:integer;

  druzyna:array[-1..max_druzyn] of TDruzyna;

  flary:array of Tflara;

var
  mysz:Tmysz;
  tlo:integer;

  ekran:record
     px,py,dx,dy:integer;
     width,height:word;

     trzesx,trzesy:integer;
     iletrzes:integer;
     silatrzes:single;

     menux:integer;
     menu_widoczne:byte; {0-nie, 1-tak, 2-czesciowo 2/3, 3-czesciowo 1/3}

     pokazuj_wyniki:boolean;
     czasniezmienionychwynikow:integer;
     spkt,strup,spaczek:int64;
  end;

  rysowanie:record
      kolor:cardinal;
      twardosc:byte; {0=w tle, 1..9=twardosc, 10=niezniszczalny}
      rozmiar:byte; {1..255}
      ziarna:byte; {0-gladki kolor, 1..255-kolory coraz bardziej mieszane}
      corobi:byte; {0-rysowanie, 1-rysowanie textura, 2-stawianie obiektow}
      odwrocony,
      ztylu:boolean;
      ksztaltpedzla:byte; {0-kolo,1-kwadrat}
      dlugosc:byte; {1..255 dlugosc obiektu, jego wielokrotnosc pod danym katem}
      kat:integer; {0..359 kat kierunku obiektu}
      odleglosci:integer; {odleglosci miedzy kolejnymi obiektami}
      maskowanie:byte; {0=rysuje tylko maske,bez zmiany tla; 1=rysuje tylko tlo, bez maski; 2=rysuje jedno i drugie}
      pokaz_maske:boolean;

      cien:record
           kolorg,kolord:cardinal;
           efg,efd:byte;
           end;
  end;

  bron:record
       wybrana:integer;
       dostrzalu:integer;
       kat,sila,skat:integer;

       tryb, mx,my:integer; {do uzytku w zaleznosci od rodzaju broni i sytuacji. np przy przypinaniu miny lina}

       glownytryb:byte; {0-strzelanie itd, 1-rysowanie, 2-stawianie wejsc, 3-przesuwanie wejscia, 4-stawianie swiatla, 5-przesuwanie swiatla}

       sterowanie:integer; {ktorym kolesiem sie steruje; -1=zadnym}
       przenoszenie:boolean; {kolesi shiftem}

       laser:array[0..9] of record x,y:integer; dx,dy:real end;
       laserile:byte;
       laserdlugosc,laserkrec,lasermoc:integer;
       laser_skonczyl_w_wodzie:boolean;

       piorun_gl_ile:byte;
       piorun_dostrzalu:integer;
       piorun:array[0..15] of record
              p:array[0..99] of record x,y:integer; dx,dy:real end;
              ile:byte;
              piorun_skonczyl_w_wodzie:boolean;
              end;

       zemsta:record
          x,y:integer; {pozycja, gdzie obecnie jest w poziomie oraz gdzie w pionie jest dolna czesc}
          czaswdol:integer; {czas ile rozwala ziemii zanim przestanie dzialac (od X spada do zera)}
          leci:boolean; {czy juz leci?}
          sila:integer;
       end;

       mlotek_ani:byte;

       piluje, pilujebardzo: boolean;

       ulubiona:array[0..9] of integer;

       went_ani:real;
       went_szyb:integer;

       info_o_kolesiu:integer; {pokazuje info o kolesiu; o ktorym: -1=zaden, 0..max_kol}
       end;

  bronmenuuklad:array [0..max_broni] of array[0..10] of TMenuukladI=
      ( { 0dmuch}((typ:0; mn:0; mx:10; wartosc:5; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        { 1bazuk}((typ:1; mn:15; mx:100; wartosc:50; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        { 2grana}((typ:1; mn:15; mx:100; wartosc:35; ikona:1),(typ:1; mn:5; mx:1500; wartosc:200; ikona:2),() ,(),(),() ,(),(),(), (), ()),
        { 3bomba}((typ:1; mn:15; mx:100; wartosc:45; ikona:1),(typ:1; mn:5; mx:1500; wartosc:200; ikona:2),() ,(),(),() ,(),(),(), (), ()),
        { 4przed-}((wartosc:0),(),() ,(),(),() ,(),(),(), (), ()),
        { 5minig}((typ:1; mn:7; mx:40; wartosc:20; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        { 6karab}((typ:1; mn:7; mx:40; wartosc:14; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        { 7strze}((typ:1; mn:7; mx:40; wartosc:16; ikona:1),(typ:1; mn:2; mx:20; wartosc:9; ikona:3),() ,(),(),() ,(),(),(), (), ()),
        { 8odlam}((typ:1; mn:7; mx:30; wartosc:10; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        { 9mieso-}((wartosc:0),(wartosc:0),(wartosc:0) ,(),(),() ,(),(),(), (), ()),
        {10miny }((typ:10; offset: 70), (typ:2; mn:0; mx:1; wartosc:0; ikona:5; tt:DM_bro_uszkodzoneminy),(typ:2; mn:0; mx:0; wartosc:0; ikona:49; tt:DM_bro_zbierzminy),(typ:2; mn:0; mx:0; wartosc:0; ikona:50; tt:DM_bro_wysadzminy) ,(),(),() ,(),(),(), ()),
        {11napal}((typ:1; mn:50; mx:700; wartosc:380; ikona:2),(),() ,(),(),() ,(),(),(), (), ()),
        {12ogien}((),(),() ,(),(),() ,(),(),(), (), ()),
        {13bomgw}((typ:1; mn:15; mx:100; wartosc:40; ikona:1),(typ:1; mn:5; mx:1500; wartosc:200; ikona:2),() ,(),(),() ,(),(),(), (), ()),
        {14ptunl}((typ:1; mn:15; mx:100; wartosc:50; ikona:1),(typ:1; mn:10; mx:60; wartosc:15; ikona:2),() ,(),(),() ,(),(),(), (), ()),
        {15dgran}((typ:1; mn:7; mx:50; wartosc:30; ikona:1; sz:120),(typ:1; mn:1; mx:15; wartosc:4; ikona:3; sz:120),(typ:1; mn:1; mx:1000; wartosc:100; ikona:2; sz:120) ,(),(),() ,(),(),(), (), ()),
        {16bznap}((typ:1; mn:15; mx:100; wartosc:50; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        {17kulog}((typ:1; mn:15; mx:100; wartosc:60; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        {18minpw}((typ:10; offset: 70),(typ:2; mn:0; mx:1; wartosc:0; ikona:5; tt:DM_bro_uszkodzoneminy),(typ:2; mn:0; mx:0; wartosc:0; ikona:49; tt:DM_bro_zbierzminy),(typ:2; mn:0; mx:0; wartosc:0; ikona:50; tt:DM_bro_wysadzminy) ,(),(),() ,(),(),(), ()),
        {19minzc}((typ:10; offset: 70),(typ:2; mn:0; mx:1; wartosc:0; ikona:5; tt:DM_bro_uszkodzoneminy),(typ:2; mn:0; mx:0; wartosc:0; ikona:49; tt:DM_bro_zbierzminy),(typ:2; mn:0; mx:0; wartosc:0; ikona:50; tt:DM_bro_wysadzminy) ,(),(),() ,(),(),(), ()),
        {20-----}((),(),() ,(),(),() ,(),(),(), (), ()),
        {21dynam}((typ:1; mn:15; mx:100; wartosc:50; ikona:1),(typ:1; mn:5; mx:1500; wartosc:200; ikona:2),() ,(),(),() ,(),(),(), (), ()),
        {22pilka}((typ:1; mn:7; mx:60; wartosc:15; ikona:1),(typ:1; mn:5; mx:1500; wartosc:500; ikona:2),() ,(),(),() ,(),(),(), (), ()),
        {23koles-}((wartosc:0),(),() ,(),(),() ,(),(),(), (), ()),
        {24nalot}((typ:1; mn:15; mx:100; wartosc:50; ikona:1),(typ:1; mn:3; mx:20; wartosc:10; ikona:3),() ,(),(),() ,(),(),(), (), ()),
        {25nnapr}((typ:1; mn:15; mx:100; wartosc:50; ikona:1),(typ:1; mn:3; mx:20; wartosc:10; ikona:3),() ,(),(),() ,(),(),(), (), ()),
        {26baznp}((typ:1; mn:15; mx:70; wartosc:50; ikona:1),(typ:1; mn:10; mx:500; wartosc:200; ikona:2),() ,(),(),() ,(),(),(), (), ()),
        {27nnplm}((typ:1; mn:15; mx:40; wartosc:30; ikona:1; sz:120),(typ:1; mn:3; mx:14; wartosc:10; ikona:3; sz:120),(typ:1; mn:10; mx:500; wartosc:200; ikona:2; sz:120) ,(),(),() ,(),(),(), (), ()),
        {28krew -}((wartosc:0),(),() ,(),(),() ,(),(),(), (), ()),
        {29snajp}((wartosc:0),(),() ,(),(),() ,(),(),(), (), ()),
        {30smiec-}((wartosc:0),(),(wartosc:0) ,(),(),() ,(),(),(), (), ()),
        {31bfg  }((typ:1; mn:25; mx:100; wartosc:70; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        {32proto}((typ:1; mn:10; mx:40; wartosc:20; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        {33miota}((),(),() ,(),(),() ,(),(),(), (), ()),
        {34noze }((typ:1; mn:20; mx:1500; wartosc:200; ikona:2),(),() ,(),(),() ,(),(),(), (), ()),
        {35zwier}((),(),() ,(),(),() ,(),(),(), (), ()),
        {36chmur}((typ:1; mn:120; mx:1500; wartosc:600; ikona:2),(),() ,(),(),() ,(),(),(), (), ()),
        {37bmgaz}((typ:1; mn:1; mx:20; wartosc:15; ikona:1),(typ:1; mn:5; mx:500; wartosc:200; ikona:2),() ,(),(),() ,(),(),(), (), ()),
        {38bazgz}((typ:1; mn:15; mx:70; wartosc:50; ikona:1),(typ:1; mn:10; mx:500; wartosc:200; ikona:2),() ,(),(),() ,(),(),(), (), ()),
        {39ciezk-}((wartosc:0),(wartosc:0),(wartosc:0) ,(),(),() ,(),(),(), (), ()),
        {40molot}((typ:1; mn:10; mx:50; wartosc:15; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        {41laser}((typ:1; mn:1; mx:10; wartosc:1; ikona:1),(typ:1; mn:50; mx:5000; wartosc:4000; ikona:35),(typ:2; mn:0; mx:1; wartosc:1; ikona:36),(typ:2; mn:0; mx:1; wartosc:0; ikona:25) ,(),(),() ,(),(),(), ()),
        {42prad }((typ:1; mn:1; mx:10; wartosc:1; ikona:1),(typ:1; mn:50; mx:5000; wartosc:4000; ikona:35),(typ:2; mn:0; mx:1; wartosc:0; ikona:25) ,(),(),() ,(),(),(), (),()),
        {43rejlg}((),(),() ,(),(),() ,(),(),(), (),()),
        {44promi}((typ:1; mn:1; mx:10; wartosc:1; ikona:1),(typ:1; mn:50; mx:5000; wartosc:4000; ikona:35),() ,(),(),() ,(),(),(), (),()),
        {45gazwy}((typ:1; mn:120; mx:1500; wartosc:600; ikona:2),(),() ,(),(),() ,(),(),(), (), ()),
        {46nalgz}((typ:1; mn:20; mx:100; wartosc:50; ikona:1),(typ:1; mn:2; mx:10; wartosc:6; ikona:3),() ,(),(),() ,(),(),(), (), ()),
        {47bazuk}((typ:1; mn:15; mx:100; wartosc:50; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        {48pioru}((typ:1; mn:10; mx:60; wartosc:40; ikona:1),(),() ,(),(),() ,(),(),(), (),()),
        {49pila }((),(),() ,(),(),() ,(),(),(), (),()),
        {50mlote}((),(),() ,(),(),() ,(),(),(), (),()),
        {51bmgaz}((typ:1; mn:1; mx:20; wartosc:15; ikona:1),(typ:1; mn:5; mx:500; wartosc:200; ikona:2),() ,(),(),() ,(),(),(), (), ()),
        {52bmcia}((typ:1; mn:15; mx:100; wartosc:60; ikona:1),(typ:1; mn:5; mx:1500; wartosc:600; ikona:2),(typ:2; mn:0; mx:1; wartosc:1; ikona:25) ,(),(),() ,(),(),(), (), ()),
        {53rollr}((typ:1; mn:15; mx:100; wartosc:35; ikona:1),(typ:1; mn:5; mx:1500; wartosc:400; ikona:2),() ,(),(),() ,(),(),(), (), ()),
        {54rakie}((typ:1; mn:15; mx:100; wartosc:60; ikona:1),(),() ,(),(),() ,(),(),(), (), ()),
        {55zemst}((typ:1; mn:30; mx:100; wartosc:70; ikona:1),(),() ,(),(),() ,(),(),(), (),()),
        {56bloto}((typ:1; mn:3 ; mx:20;  wartosc:8; ikona:11),(typ:1; mn:1 ; mx:10; wartosc:1; ikona:10),() ,(),(),() ,(),(),(), (), ()),
        {57beczk}((typ:10; offset: 70), (typ:2; mn:0; mx:1; wartosc:0; ikona:5; tt:DM_bro_uszkodzoneminy),(typ:2; mn:0; mx:0; wartosc:0; ikona:49; tt:DM_bro_zbierzminy),(typ:2; mn:0; mx:0; wartosc:0; ikona:50; tt:DM_bro_wysadzminy) ,(),(),() ,(),(),(), ()),
        {58batom}((typ:1; mn:50; mx:200; wartosc:80; ikona:1),(),() ,(),(),() ,(),(),(), (), ())
      );

  rysmenuuklad:array [0..4] of array[0..11] of TMenuukladI=
      ( { 0rys}((typ:1; mn:0; mx:255; wartosc:5; ikona:7;tt:DM_rys_R),(typ:1; mn:0; mx:10; wartosc: 5; ikona:10; sz:105; tt:DM_rys_wytrzymalosc),(typ:1; mn:1; mx:60; wartosc:30; ikona:11; sz:105; tt:DM_rys_wielkosc) ,
                (nl:true;typ:1; mn:0; mx:255; wartosc:5; ikona:8;tt:DM_rys_G),(typ:1; mn:0; mx:50; wartosc:10; ikona:12; sz:105; tt:DM_rys_ziarnistosc),(typ:2; mn:0; mx:1 ; wartosc:0;  ikona:15;tt:DM_rys_ksztalt) ,
                (nl:true;typ:1; mn:0; mx:255; wartosc:5; ikona:9;tt:DM_rys_B),(typ:2; mn:0; mx:2 ; wartosc: 2; ikona:19; offset:1;tt:DM_rys_rysujmasketeren),(typ:2; mn:0; mx:1 ; wartosc: 0; ikona:22; offset:20; tt:DM_rys_pokazmasketeren),(typ:2; mn:0; mx:1  ; wartosc:0;  ikona:17;tt:DM_rys_zprzoduztylu), (), ()
                ),
        { 1tex}((                                       ),(typ:1; mn:0; mx:10; wartosc: 5; ikona:10; sz:105; tt:DM_rys_wytrzymalosc),(typ:1; mn:1; mx:60; wartosc:30; ikona:11;sz:105; tt:DM_rys_wielkosc) ,
                (nl:true;typ:2; mn:0; mx:0 ; wartosc: 0; ikona:27; offset:80;tt:DM_rys_poprzedniatekstura),(typ:2; mn:0; mx:0 ; wartosc: 0; ikona:28;offset:175;tt:DM_rys_nastepnatekstura),(typ:2; mn:0; mx:1  ; wartosc:0;  ikona:15;tt:DM_rys_ksztalt) ,
                (nl:true                                ),(typ:2; mn:0; mx:2 ; wartosc: 2; ikona:19;offset:1;tt:DM_rys_rysujmasketeren),(typ:2; mn:0; mx:1 ; wartosc: 0; ikona:22;offset:20; tt:DM_rys_pokazmasketeren),(typ:2; mn:0; mx:1  ; wartosc:0;  ikona:17;tt:DM_rys_zprzoduztylu), (), ()
                ),
        { 2obi}((                                       ),(typ:1; mn:0; mx:10; wartosc: 5; ikona:10; sz:105; tt:DM_rys_wytrzymalosc),(typ:1; mn:1; mx:30 ; wartosc:1;  ikona:3; sz:105; tt:DM_rys_ilosc) ,
                (nl:true;typ:2; mn:0; mx:0 ; wartosc: 0; ikona:27;offset:80;tt:DM_rys_poprzedniobiekt),(typ:2; mn:0; mx:0 ; wartosc: 0; ikona:28;offset:70-menu_odstepy_miedzy_suwakami;tt:DM_rys_nastepnyobiekt),(typ:1; mn:0; mx:200;wartosc:10; ikona:27;sz:105; tt:DM_rys_odleglosci),(typ:1; mn:0; mx:359; wartosc:90; ikona:14;sz:105; tt:DM_rys_kat) ,
                (nl:true),(typ:2; mn:0; mx:2 ; wartosc: 2; ikona:19;offset:1;tt:DM_rys_rysujmasketeren),(typ:2; mn:0; mx:1 ; wartosc: 0; ikona:22;offset:20; tt:DM_rys_pokazmasketeren),(typ:2; mn:0; mx:1  ; wartosc:0;  ikona:17;tt:DM_rys_zprzoduztylu), ()
                ),
        { 3cie}((        typ:1; mn:0; mx:255; wartosc:$30; ikona:7;tt:DM_rys_R), (typ:1; mn:0; mx:255; wartosc:$60; ikona:7;tt:DM_rys_R), (typ:2; mn:0; mx:3 ; wartosc: 1; ikona:31; tt:DM_rys_gornyefekt),
                (nl:true;typ:1; mn:0; mx:255; wartosc:$a0; ikona:8;tt:DM_rys_G), (typ:1; mn:0; mx:255; wartosc:$30; ikona:8;tt:DM_rys_G), (typ:2; mn:0; mx:3 ; wartosc: 2; ikona:31; tt:DM_rys_dolnyefekt),
                (nl:true;typ:1; mn:0; mx:255; wartosc:$10; ikona:9;tt:DM_rys_B), (typ:1; mn:0; mx:255; wartosc:$15; ikona:9;tt:DM_rys_B), (), (),(), ()
                ),
        { 4swi}((        typ:1; mn:0; mx:255; wartosc:$ff; ikona:7;tt:DM_rys_R), (typ:1; mn:5; mx:255; wartosc:$80; ikona:40; offset:150; tt:DM_rys_jasnosc),
                                 (typ:2; mn:0; mx:0;  wartosc:0;  ikona:41;  offset: 1; tt:DM_rys_Dodajnoweswiatlo),(typ:2; mn:0; mx:0;  wartosc:0;  ikona:42; offset: 1; tt:DM_rys_Usunwybraneswiatlo),
                (nl:true;typ:1; mn:0; mx:255; wartosc:$ff; ikona:8;tt:DM_rys_G), (typ:1; mn:0; mx:255; wartosc:$00;ikona:14;tt:DM_rys_kat), (typ:1; mn:0; mx:2 ; wartosc: 0; ikona:43; sz:60; tt:DM_rys_rodzaj),
                (nl:true;typ:1; mn:0; mx:255; wartosc:$ff; ikona:9;tt:DM_rys_B), (typ:1; mn:5; mx:400; wartosc:150;ikona:11;offset:120; sz:140; tt:DM_rys_wielkosc),
                                 (typ:2; mn:0; mx:1;  wartosc:0;  ikona:44; offset:1; tt:DM_rys_efekt), (typ:2; mn:0; mx:1;  wartosc:0;  ikona:46; offset:1; tt:DM_rys_zniszczalneniezniszczalne), (typ:2; mn:0; mx:1;  wartosc:0;  ikona:17; offset:1; tt:DM_rys_zprzoduztylu)
                )
      );

  warmenuuklad:array[0..28] of TmenuukladI=(
  { 0}(typ:4; ikona:1),
  { 1}(typ:2; mn:0; mx:1;   wartosc:0;  ikona:2; offset:32; tt:DM_war_Kierunekwiatru),
  { 2}(typ:1; mn:0; mx:100; wartosc:0;  ikona:0; offset:10; sz:100; tt:DM_war_Silawiatru),
  { 3}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:4;  tt:DM_war_Zachmurzenie),
  { 4}(typ:2; mn:0; mx:1;   wartosc:0;  ikona:5;  tt:DM_war_Typzachmurzenia),
  { 5}(typ:1; mn:0; mx:max_chmurki;  wartosc:10; ikona:0; offset:15; sz:80; tt:DM_war_Stopienzachmurzenia),
  { 6}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:7; tt:DM_war_Burza),
  { 7}(typ:1; mn:5; mx:500; wartosc:100;ikona:0; offset:15;  sz:100; tt:DM_war_Silaburzy),
  { 8}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:8;  tt:DM_war_Deszcz),
  { 9}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:9;  tt:DM_war_Snieg),
  {10}(nl:true;
       typ:3; mn:0; mx:1;   wartosc:0;  ikona:10; tt:DM_war_Bezniczego),
  {11}(typ:3; mn:0; mx:1;   wartosc:1;  ikona:11; tt:DM_war_Woda),
  {12}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:12; tt:DM_war_Lawa),
  {13}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:13; tt:DM_war_Radioaktywnykwas),
  {14}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:14; tt:DM_war_Krew),
  {15}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:15; tt:DM_war_Bloto),
  {16}(typ:1; mn:0; mx:100; wartosc:0;  ikona:16; sz:150; tt:DM_war_Poziom),
  {17}(typ:1; mn:0; mx:2399;wartosc:0;  ikona:17; sz:150; tt:DM_war_Czas),
  {18}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:18; tt:DM_war_Pauza),
  {19}(nl:true;
       typ:1; mn:0; mx:9;   wartosc:5;  ikona:19; offset: 15; sz:90; tt:DM_war_Agresja),
  {20}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:20; tt:DM_war_Walkabezpowodu),
  {21}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:21; tt:DM_war_Walkazeswoimi),
  {22}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:22; tt:DM_war_Zwierzetapojawiajasiesame),
  {23}(typ:1; mn:5; mx:200; wartosc:100;ikona:27; offset:25; sz:150; tt:DM_war_Grawitacja),
  {24}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:23; tt:DM_war_Informacjeopostaci),
  {25}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:26; tt:DM_war_Wskaznikipostaci),
  {26}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:25; tt:DM_war_Dzwieki),
  {27}(typ:3; mn:0; mx:1;   wartosc:0;  ikona:24; tt:DM_war_Muzyka),
  {28}(typ:3; mn:0; mx:1;   wartosc:1;  ikona:28; tt:DM_war_Muzyka_nastepne)
      );

  druzmenuuklad:array[0..3] of TmenuukladI=(
  { 0}(typ:1; mn:0; mx:30;  wartosc:0;  ikona:1;  offset: 230; sz:200; tt:DM_dru_Ilosckolesi),
  { 1}(nl:true; typ:1; mn:30; mx:900;   wartosc:100;  ikona:4;  sz:300; tt:DM_dru_Silapoczatkowa),
  { 2}(typ:2; mn:1; mx:4;    wartosc:0;    ikona:4;  offset: 10; tt:DM_dru_Bronpoczatkowa),
  { 3}(typ:1; mn:0; mx:30;   wartosc:0;    ikona:0;  offset: 10; sz:130; tt:DM_dru_Amunicja)
      );

  wejmenuuklad:array[0..7] of TmenuukladI=(
  { 0}(typ:2; mn:0; mx:0;  wartosc:0;  ikona:15;  offset:20; tt:DM_wej_Wybierzwszystkiezadne),
  { 1}(typ:2; mn:0; mx:0;  wartosc:0;  ikona:9;  offset: 260; tt:DM_wej_Dodajnowewejscie),
  { 2}(typ:2; mn:0; mx:0;  wartosc:0;  ikona:10;  tt:DM_wej_Usunwybranewejscie),
  { 3}(typ:2; mn:0; mx:0;  wartosc:0;  ikona:11;  offset: 40; tt:DM_wej_Wyrzucterazwszystkichbrakujacych),
  { 4}(nl:true;typ:1; mn:0; mx:100;  wartosc:10;  ikona:12;  offset: 20; sz:200; tt:DM_wej_Czestotliwoscwchodzenia),
  { 5}(typ:1; mn:0; mx:100;  wartosc:50;  ikona:13; offset: 40; sz:200; tt:DM_wej_Brakujeprocentzdruzynyzebyweszlinowi),
  { 6}(nl:true;typ:3; mn:0; mx:1;  wartosc:1;  ikona:14; offset: 20; tt:DM_wej_Wchodzarowniezznieba),
  { 7}(typ:4; mn:0; mx:0;  wartosc:0;  ikona:16; offset: 15; tt:DM_wej_Wybierzwejscieznieba)
      );

  druzynymenu:record
     wybrana:byte;

     wejsciewybrane,
     ilewejsc,
     wejscieruszane:integer;
     lecatezzgory:boolean;
    end;

  wejscia:array[0..max_wejsc] of record
     x,y:integer;
     druzyny:array[0..max_druzyn] of boolean;
     czest:integer;
     proc:integer;
     sypie:array[0..max_druzyn] of boolean; {czy w tej chwili sypie? jesli nie, to czeka az bedzie odpowiedni procent, a jak tak, to leca az bedzie tyle ile trzeba}
     donastepnego:integer;
     ani:single;
  end;

  klawisze:array[0..99] of byte;
  kfg:record
      calkiem_bez_dzwiekow:boolean; {totalne wylaczenie dzwiekow, wraz z funkcjami wczytujacymi}
      calkiem_bez_muzyki:boolean; {totalne wylaczenie muzyki, wraz z funkcjami wczytujacymi}
      ile_kanalow:byte;

      log:boolean;
      glosnosc:integer;
      glosnoscmuzyki:single;
      jest_muzyka,
      jest_dzwiek,
      glos_zlego_pana:boolean;
      glebokosc_tekstur:byte; {0-jak potrzeba, 1-16bit, 2-32bit}
      odblaski,
      wybuchydymy,
      swiatla,
      trzesienie,
      krew_mieso_zostawia_slady:boolean;
      jaki_kursor:byte; {0:noramalny, 1:brak, 2:przezroczysty}

      pokazuj_info, {o kolesiu}
      wskazniki_kolesi:boolean; {paski energii itp}

      dymki_kolesi: byte; {czy pojawiaja sie dymki z tekstami: 0- nie; 1-rzadko, 2-normalnie}

      chowaj_liczniki:boolean;
      efekty_soczewki:boolean;

      detale:integer; {1..5}

      sterowanie: byte; {0:normalnie; 1:kursor wskazuje kierunek strzalu}

      ekran:record
             width,height:integer;
             bitdepth:integer;
             antialias:boolean;
             dithering:boolean;
             vsync:boolean;
             windowed:boolean;
             buffers:integer;
             refresh:integer;
            end;
      end;

  warunki:record
      agresja:integer;           {stopien agresji od 0 do 9, 0-brak}
      walka_ze_swoimi,           {bija wszystkich, niezaleznie od druzyny}
      walka_bez_powodu:boolean;  {zaczepiaja sie wzajemnie, bez powodu}
      typ_wody:byte;             {0-brak, 1-woda, 2-lawa, 3-kwas, 4-krew, 5-bloto}
      gleb_wody,                 {glebokosc wody, liczona od DOLNEJ krawedzi terenu}
      ust_wys_wody,              {ustawiona wysokosc wody, liczona od GORNEJ krawedzi, bez uwzglednienia sinusow}
      wys_wody:integer;          {wysokosc wody, liczona od GORNEJ krawedzi terenu, obliczana automatycznie uwzgledniajac sinus}
      wiatr:single;              {sila wiatru; 0-bez; ujemne-w lewo; dodatnie-w prawo}
      zwierzeta_same:boolean;    {zwierzeta pojawiaja sie same na brzegach ekranu}
      deszcz:boolean;            {czy pada deszcz?}
      snieg:boolean;             {czy pada snieg?}
      burza:boolean;
      chmurki:boolean;
      silaburzy:integer;         {czestotliwosc piorunow: 5..500}
      iloscchmur:integer;        {ile chmur na raz? nie moze przekroczyc max_chmurki}
      jakiechmury:byte;          {0-czarne, 1-biale}

      czestpaczek:integer;       {czestotliwosc spadania paczek: 0-brak, 1-max}
      grawitacja:real;           {sila grawitacji, od 0.05 do 2.0}
      paczkidowolnie:boolean;    {paczki moga sie pojawiac nie tylko z niebia, ale wszedzie gdzie sie uda}

      walka_z_kursorem: boolean; {czy kolesie probuja walczyc z kursorem myszy?}

      godzina:integer; {obecna "godzina" liczona od 0 do 2399 (100 minut zamiast 60 - bo latwiej tak ;))}
      pauza:boolean;
      end;

  niebo:record
      kolorytla:array[0..23] of record
                             zmiana:boolean; {true= zmieniaj o tej godzinie kolor, false= nie zmieniaj}
                             gr,gg,gb,
                             dr,dg,db : byte;
                             dlugosc:byte; {dlugosc miedzy kolejnymi etapami zmiany kolorow. dla kazdej godziny osobno zapisana}
                             bierzdanez:byte; {z ktorej ostatniej godziny brac kolory? np. jak jest godzina 12, ale o zmiana jest o 10 i o 13 to bierz kolor z 10 i dodawaj fade}
                             end;

      kolorytlag,kolorytlad,
      kolorterenu:cardinal;

      blysk,                  {jasnosc rozblysku nieba od piorunu}
      blyskkrotnosc,          {ile razy jeszcze ma blysnac pod rzad?}
      blyskszybkosc,          {szybkosc gasniecia rozblysku}
      blyskjasnosc : integer; {ustawiona jasnosc rozblysku (potrzebne do powtorzonyh blyskow)}

      rampr,rampg,rampb:real;
      tlo_grad_il,tlo_grad_skok:integer;

      kolorytlaszybkosc:integer; {1-min, 360-max... cos jak predkosc czasu wlasciwie, bo sie godzina zmienia z ta predkoscia}

     // tlododx,tlodody:real;
      tlowidth,tloheight:integer;
      slonce,ksiezyc:record
            x,y:integer;
          end;
      gwiazdy:array of record
            kat,odl:real;
            x,y:integer;
            przezr,wielk:byte;
          end;

      widslon,
      winksie,
      widgwia,
      widchmu,
      widdeszsnie:boolean;

      ile_jest_chmur:integer;      {ile w tej chwili jest chmur?}
      ile_jest_chmur_widocznych:real; {ile chmur na ekranie? czarna=1, biala=0.5}
      jasnosc_nieba,jasnosc_nieba_widac:smallint; {o ile sciemnic niebo i slonce itp kiedy wisza chmury? 0-brak}
      pog,pog2,
      pog_widac,pog2_widac:real;
      end;

  tryb_misji:record
      wlaczony:boolean; {czy w ogole wlaczony tryb misji?}
      wstrzymana:boolean; {czeka na wcisniecie czegos, zwykle jak sie pojawiaja napisy}
      dlaczego_wstrzymana:byte; {0-na poczatku,pokazuje info, 1-wygrana, 2-przegrana}
      wstrzymana_alfa:integer; {przezroczystosc informacji z misji}
      wylaczanie_wstrzymania:boolean; {koncowka wstrzymania, czas na wygaszenie infa}
      {-------}
      nazwa, autor:string;
      opis:string;
      muzyka:string;
      nagroda:int64;
      jest_czas:boolean;
      ile_czasu:integer;
      ruszanie_postacia:boolean;
      ruszanie_postacia_ktora:integer;
      dziala_kursor,
      zmianawarunkow,
      rysowanie,
      zmianawejsc,
      zmianadruzyn,
      przenoszenie:boolean;
      wygrana_gdy, przegrana_gdy:record
         czas,czas_o:boolean;
         zginie_min, zginie_min_o:boolean; zginie_ile:integer; zginie_grupa:integer;
         dojdzie_do_prost, dojdzie_do_prost_o:boolean; dojdzie_do_prost_ile_kolesi:integer; dojdzie_do_prost_z_grupy:integer;
         zebrane_flagi, zebrane_flagi_o:boolean; zebrane_flagi_ile:integer;
         zniszczone_flagi, zniszczone_flagi_o:boolean; zniszczone_flagi_ile:integer;
         end;
      amunicja:array[0..max_broni] of integer;
      druzyny:array[0..max_druzyn] of record
         nazwa:string;
         ilosc_kolesi_w_druzynie:integer;
         max_kolesi_na_raz:integer;
         zabijac_czy_bronic:boolean; {false=zabijac, true=bronic}
         zabijac_czy_bronic_ilu:integer;
         sila_poczatkowa:integer;
         bron:byte;
         amunicja:integer;
         {to, co zmienia sie w czasie dzialania misji:}
         zginelo:integer; {ilu juz zginelo}
      end;
      flagi:array of record
         x,y,dy:real;
         rodz:byte;
         aniklatka:single;
      end;
      prostokaty:array of record x1,y1,x2,y2:integer; rodz:byte end;
      {to, co zmienia sie w czasie dzialania misji:}
      flag_zebranych, flag_zniszczonych,
      doszlo_dobrze, doszlo_zle:integer;

      wybranyteren:string; {trzeba go wczytac!}
    end;


  obr:record
     font, font2:TSprajt;

     energia:TSprajt;
     pocisk:array[-1..24] of TSprajt;
     mina:array[0..4] of TSprajt;

     teren:TSprajt;
    // tlo:TSprajt;
     kursor:TSprajt;
     celownik:TSprajt;
     wskaznik,wskaznik2,kurpodb:TSprajt;
     znakteam:TSprajt;
     syf:array[0..3,0..4] of TSprajt;

     smieci:array[0..max_smieci] of TSprajt; {0-pilka}

     wybuchdym:array[0..4,0..5] of TSprajt; {0-wybuchy, 1-dymy, 2-blyski, 3-swiatla, 4-krew/ziemia}

     flara:TSprajt;

     przedm:array[0..ile_przedm] of TSprajt;
     bombel:TSprajt;

     snajper:TSprajt;

     slonce,ksiezyc,gwiazda:TSprajt;

     broniekolesi:array[3..3] of TSprajt;

     zwierzaki:array[0..max_rodz_zwierzaki,0..1] of TSprajt;

     ciezkie:array[0..3] of TSprajt;
     pila, mlotek, wentylator,
     wejscie:TSprajt;

     flagaslup,flaga:TSprajt;

     deszcz:array[0..1] of TSprajt;
     chmurka:TSprajt;

     aniikony, aniikonyp:TSprajt;
     aniikony_wczytana:integer; {numer wczytanej ostatnio ikony, zeby nie wczytywac jej powtornie}

     menud, menudprawo:TSprajt;
     menukratka,
     menusuwaktlo, menusuwak, menusuwakwyp,
     menuikony,menuikonyw,menuikonydruz,
     ikowybmenu:TSprajt;


     glownemenu, pasekkolor :TSprajt;

     autorzy_slajd:array[1..2] of TSprajt;

     {-rysowanie-}
     teksturapok:TSprajt;
     tekstura:TBitmapEx;
     obiektpok:TSprajt;
     obiekt:TBitmapEx;
     ryscien:TSprajt;
     end;

   gracz:record
     pkt,trupow,paczek, _pkt,_trupow,_paczek:int64;

     pkt_pacz: int64; {przy ilu pkt obecnej gry ostatnio spadla paczka dla gracza? co 20000 dajemy nowa :)}

     kombo_licznik,
     czas_dzialania_kombo,
     ostatnie_kombo,
     max_kombo :integer;
     ostatnia_smierc_x,ostatnia_smierc_y:integer; {pozycja na terenie ostatniego zgonu-do miejsca komba}
     czas:int64;

     broniesa:array[0..max_broni] of boolean;

     punktyglobalne:int64; {punkty, ktore sa liczone w sumie z wszystkich gier na raz!}
     trupyglobalne:int64;  {trupy, ktore sa liczone w sumie z wszystkich gier na raz!}
     paczkiglobalne:int64;  {paczki, ktore sa liczone w sumie z wszystkich gier na raz!}

     punktyglobalne_od,      {od tylu punktow w tej grze zaczeto liczyc globalne; liczone sa stale w sposob: }
     trupyglobalne_od:int64; {punktyglobalne+pkt i tak az do wyjscia z gry, kiedy zapisywana jest ta suma i potem znowu liczone XXX_od}
     paczkiglobalne_od:int64;

     globalniebylogier:int64; {zliczanie gier, ktore sie odbyly od zainstalowania gry :)}

     imie:string;
     end;

   dzwieki_ciagle:record
      ogien,
      deszcz,
      laser,
      prad,
      miotacz,
      pilaluz, pilatnie, pilatniebardzo
               :boolean;
   end;

   tultip:record
      x,y:integer;
      czas:integer;
      tekst:string;
   end;
   napiswrogu:record
      czas:integer;
      tekst:string;
   end;
   napis:array[0..max_napis] of record
      x,y:integer;
      czas:integer;
      tekst:string;
      jaki:byte; {0=powieksza sie i znika, 1=wciaz jest maly i znika}
   end;

   listyplikow:array[0..6] of array of string[255]; {0-obiekty, 1-tekstury, 2-muzyka, 3-postaci, 4-scenariusze, 5-misje, 6-tereny}
   skonczonemisje:array of boolean; {tak samo dluga tablica jak listyplikow[5], ale tu TRUE oznacza skonczona misje}
   rozpakowanedruzyny:array of boolean; {ktore druzyny na liscie listyplikow zostaly juz rozpakowane na dysk?}


   glowne_co_widac:integer; {0-menu glowne, 1-gra}
   wroc_do_menu:integer; {numer menu na winiecie, ktore nalezy otworzyc, gdy do niego wracamy (np.po skonczonej misji)}
   jest_juz_gra,
   sa_juz_wczytane_druzyny,
   wyjscie_z_programu:boolean;

   ktore_haslo_wczytywanie_widac:integer;

var
  gestosci:array[0..max_wod] of record x,y,maxx,maxy:real; gest:single end=
         ((x:1.1 ; y:1.2 ; maxx:0.02; maxy:1   ; gest:1 ),  {powietrze-malo istotne}
          (x:1.1 ; y:1.2 ; maxx:0.02; maxy:1   ; gest:2 ),  {woda}
          (x:2   ; y:2   ; maxx:0.006;maxy:0.4 ; gest:3 ),  {lawa}
          (x:1.2 ; y:1.3 ; maxx:0.02; maxy:0.9 ; gest:2.4 ),  {kwas}
          (x:1.3 ; y:1.4 ; maxx:0.02; maxy:0.8 ; gest:2.7 ),  {krew}
          (x:1.7 ; y:1.8 ; maxx:0.01; maxy:0.5 ; gest:3.5 )); {bloto}



  bl:array[false..true] of string[5]=('false','true');

   FUNCTION l2t(liczba:longint;ilosc_lit:byte):string;
   FUNCTION l2tprzec(liczba:longint;ilosc_lit:byte):string;

   function mysz_w(x1,y1,x2,y2:integer):boolean;
   function mysz_w2(x1,y1,rx,ry:integer):boolean;
   function sqrt2(w:real):extended;
   function jaki_to_kat(dx,dy:real):smallint;
   function jaki_to_kat_r(dx,dy:real):real;

   function wczytajstring(var plik:TStream):string;
   procedure zapiszstring(var plik:TStream;t:string);

   procedure podzielnazwe(nazwa:string; var kat,plk,roz:string);

implementation

FUNCTION l2t(liczba:longint;ilosc_lit:byte):string;
var ww:string;
begin
   str(liczba,ww);
   if ilosc_lit>0 then
      while length(ww)<ilosc_lit do insert('0',ww,1);
   l2t:=ww;
end;

FUNCTION l2tprzec(liczba:longint;ilosc_lit:byte):string;
var ww:string; a:integer;
begin
   str(liczba,ww);
   if ilosc_lit>0 then
      while length(ww)<ilosc_lit do insert('0',ww,1);

   if length(ww)>3 then begin
      a:=length(ww)-2;
      while a>=2 do begin
         insert('.', ww, a);
         dec(a,3);
      end;
   end;
   l2tprzec:=ww;
end;

function mysz_w(x1,y1,x2,y2:integer):boolean;
begin
result:=(mysz.x>=x1) and (mysz.y>=y1) and (mysz.x<=x2) and (mysz.y<=y2);
end;

function mysz_w2(x1,y1,rx,ry:integer):boolean;
begin
result:=(mysz.x>=x1) and (mysz.y>=y1) and (mysz.x<=x1+rx) and (mysz.y<=y1+ry);
end;

function sqrt2(w:real):extended;
begin
if w=0 then sqrt2:=0
       else sqrt2:=sqrt(w);
end;

function jaki_to_kat(dx,dy:real):smallint;
var kk0:real;
begin
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
 result:=trunc( (kk0/(pi180)) );
end;

function jaki_to_kat_r(dx,dy:real):real;
var kk0:real;
begin
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
 result:=(kk0/(pi180)) ;
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

procedure podzielnazwe(nazwa:string; var kat,plk,roz:string);
var
a:longint;
ok:boolean;
w:string;
begin
ok:=false;
for a:=length(nazwa) downto 1 do begin
    if nazwa[a]='\' then begin ok:=true; break; end;
end;
if ok then begin {znaleziono '\' wiec jest katalog i plik}
   kat:=copy(nazwa,1,a-1);
   plk:=copy(nazwa,a+1,length(nazwa)-a);
end else begin {nie ma '\' wiec to pewnie tylko nazwa pliku}
   plk:=nazwa;
   kat:='';
end;
{szukamy rozszerzenia}
roz:='';
ok:=false;
for a:=length(plk) downto 1 do
    if plk[a]='.' then begin
       ok:=true;
       break;
    end;

if ok then begin
   roz:=copy(plk,a+1,length(plk)-a);
   w:=plk;
   plk:='';
   plk:=copy(w,1,a-1);
end;

end;

end.
