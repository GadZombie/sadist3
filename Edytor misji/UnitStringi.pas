unit UnitStringi;

interface
const
  max_broni=58;
  ile_przedm=5; {0..ile_przedm}
  max_rodz_zwierzaki=5;

const

domyslne_imie = 'Sadysta';

{napis pod logiem wczytywania}
Log_is_on = 'Log w��czony';
Logo_wczytywanie = 'wczytywanie';
Logo_Tworzenieterenu='Tworzenie terenu...';
Logo_WczytywanieDruzyny='wczytywanie dru�yny ';

{menu glowne}
MenuGlownePodp_SzybkaGra = 'Rozpocz�cie gry z losowymi ustawieniami'#13'(zawsze tryb zwyk�ej gry)';
MenuGlownePodp_NowaGra = 'Wyb�r ustawie� gry, wczytanie misji, terenu i rozpocz�cie gry'#13'lub zmiana obecnych ustawie�';
MenuGlownePodp_ZapisOdczyt = 'Zapis na dysku obecnego terenu';
MenuGlownePodp_WybDruzyn = 'Wyb�r wygl�du i ustawienia kolor�w dru�yn';
MenuGlownePodp_Opcje = 'Ustawienia og�lne gry';
MenuGlownePodp_Najwieksi = 'Lista Najwspanialszych, Najwi�kszych Sadyst�w,'#13'czyli prawdziwie mordercze wyniki!';
MenuGlownePodp_Autorzy = '"Lista p�ac", czyli co kto zrobi�, do czego si� przyczyni�,'#13'troch� obrazk�w, muzyka itp...';
MenuGlownePodp_Wyjscie = 'Wyj�cie do nudnego, smutnego, prawdziwego �wiata,'#13'gdzie mordowanie ma swoje konsekwencje,'#13'a ty nie jeste� ju� wszechmog�cy!'#13'Lepiej nie wciskaj tego guzika!!';
MenuGlowneGlobalne = 'Globalnie: ';
MenuGlowneGlobalnePkt = 'Punkt�w: ';
MenuGlowneGlobalneTrup = 'Trup�w: ';
MenuGlowneGlobalneGier = 'Gier: ';

Opcje_GlosZlegoPana = 'G�os Z�ego Pana';
Opcje_Dzwieki = 'D�wi�ki';
Opcje_Glosnoscdzwiekow = 'G�o�no�� d�wi�k�w';
Opcje_Muzyka = 'Muzyka';
Opcje_Glosnoscmuzyki = 'G�o�no�� muzyki';
Opcje_Krewmiesozostawiasladynaterenie = 'Krew/mi�so zostawia �lady na terenie';
Opcje_Chowajlicznikiwynikowwczasiebezczynnosci = 'Chowaj liczniki wynik�w w czasie bezczynno�ci';
Opcje_Swiatla = '�wiat�a';
Opcje_Wstrzasy = 'Wstrz�sy ekranu od wybuch�w';
Opcje_Liczniki = 'Pokazuj liczniki punkt�w i czasu na ekranie (F12)';
Opcje_Czestpaczek = 'Cz�stotliwo�� spadania paczek z nieba (0:brak)';
Opcje_Paczkiwdowolnychmiejscach = 'Paczki pojawiaj� si� w dowolnych miejscach (nie tylko spadaj� z nieba)';
Opcje_Poziomdetali = 'Poziom detali';
Opcje_Kursor = 'Rodzaj kursora myszy w grze (F7)';

Nowy_Szerokoscterenu = 'Szeroko�� terenu';
Nowy_Wysokoscterenu = 'Wysoko�� terenu';
Nowy_Podloze = 'Pod�o�e';
Nowy_Obiekty = 'Obiekty';
Nowy_Przedmioty = 'Przedmioty';
Nowy_Miny = 'Miny';

WczDruz_Druzyna= 'Dru�yna';

ListaNaj_datagry= 'Data gry: ';
ListaNaj_czasgry= 'Czas trwania gry: ';
ListaNaj_trupow= 'Trup�w: ';
ListaNaj_pkt= 'Punkt�w: ';
ListaNaj_obecnagra= '*Obecna gra*';

Tereny_brakterenow = 'BRAK TEREN�W';
Misje_brakmisji = 'BRAK MISJI';
Misje_sumamisji = 'Suma wszystkich misji: ';
Misje_skonczonychmisji = 'Zako�czonych misji: ';
Misje_nieskonczonychmisji = 'Misji do wykonania: ';
Podaj_swoje_imie= 'Podaj swoje imi�:';
Podaj_nazwe_terenu= 'Podaj nazw� terenu:';

{dolne menu rysowanie}
DM_rys_wytrzymalosc = 'wytrzyma�o��';
DM_rys_wielkosc = 'wielko��';
DM_rys_ziarnistosc = 'ziarnisto��';
DM_rys_ksztalt = 'kszta�t';
DM_rys_pokazmasketeren = 'poka� mask�/teren';
DM_rys_zprzoduztylu = 'z przodu/z ty�u';
DM_rys_poprzedniatekstura = 'poprzednia tekstura';
DM_rys_nastepnatekstura = 'nast�pna tekstura';
DM_rys_rysujmasketeren = 'rysuj mask�/teren';
DM_rys_ilosc = 'ilo��';
DM_rys_poprzedniobiekt = 'poprzedni obiekt';
DM_rys_nastepnyobiekt = 'nast�pny obiekt';
DM_rys_odleglosci = 'odleg�o�ci';
DM_rys_kat = 'k�t';
DM_rys_gornyefekt = 'g�rny efekt';
DM_rys_dolnyefekt = 'dolny efekt';
DM_rys_R = 'R (czerwony)';
DM_rys_G = 'G (zielony)';
DM_rys_B = 'B (niebieski)';
DM_rys_jasnosc = 'jasno��';
DM_rys_rodzaj = 'rodzaj';
DM_rys_efekt = 'efekt';
DM_rys_zniszczalneniezniszczalne = 'zniszczalne/niezniszczalne';
DM_rys_Dodajnoweswiatlo='Dodaj nowe �wiat�o';
DM_rys_Usunwybraneswiatlo='Usu� wybrane �wiat�o';

{dolne menu warunki}
DM_war_Kierunekwiatru='Kierunek wiatru';
DM_war_Silawiatru='Si�a wiatru';
DM_war_Zachmurzenie='Zachmurzenie';
DM_war_Typzachmurzenia='Typ zachmurzenia';
DM_war_Stopienzachmurzenia='Stopie� zachmurzenia';
DM_war_Grawitacja='Grawitacja (%)';
DM_war_Burza='Burza';
DM_war_Silaburzy='Si�a burzy';
DM_war_Deszcz='Deszcz';
DM_war_Snieg='�nieg';
DM_war_Bezniczego='Bez niczego';
DM_war_Woda='Woda';
DM_war_Lawa='Lawa';
DM_war_Radioaktywnykwas='Radioaktywny kwas';
DM_war_Krew='Krew';
DM_war_Bloto='B�oto';
DM_war_Poziom='Poziom';
DM_war_Czas='Czas';
DM_war_Pauza='Pauza';
DM_war_Agresja='Agresja';
DM_war_Walkabezpowodu='Walka bez powodu';
DM_war_Walkazeswoimi='Walka ze swoimi';
DM_war_Zwierzetapojawiajasiesame='Zwierz�ta pojawiaj� si� same';
DM_war_Informacjeopostaci='Informacje o postaci';
DM_war_Wskaznikipostaci='Wska�niki postaci';
DM_war_Dzwieki='D�wi�ki';
DM_war_Muzyka='Muzyka';
DM_war_Muzyka_nastepne='Nast�pny utw�r';

{dolne menu druzyny}
DM_dru_Ilosckolesi='Ilo�� kolesi';
DM_dru_Silapoczatkowa='Si�a pocz�tkowa';
DM_dru_Bronpoczatkowa='Bro� pocz�tkowa';
DM_dru_Amunicja='Amunicja';
DM_dru_Ustawieniadruzyny='Ustawienia dru�yny ';
DM_dru_Przyjazna='Przyjazna';
DM_dru_Wroga='Wroga';
DM_dru_druzyna=' dru�yna ';

{dolne menu wejscia}
DM_wej_Wybranewejscie='Wybrane wej�cie';
DM_wej_Dodajnowewejscie='Dodaj nowe wej�cie';
DM_wej_Usunwybranewejscie='Usu� wybrane wej�cie';
DM_wej_Wyrzucterazwszystkichbrakujacych='Wyrzu� teraz wszystkich brakuj�cych';
DM_wej_Czestotliwoscwchodzenia='Cz�stotliwo�� wchodzenia';
DM_wej_Brakujeprocentzdruzynyzebyweszlinowi='�eby weszli nowi, musi zosta� procent z dru�yny';
DM_wej_Wchodzarowniezznieba='Wchodz� r�wnie� z nieba';
DM_wej_Tymwejsciemwchodzidruzyna='Tym wej�ciem wchodzi dru�yna ';
DM_wej_gora='g�ra';
DM_wej_Wybierzwejscieznieba='Wybierz wej�cie z nieba';

{dolne menu bronie}
DM_bro_klawiszskrotu='klawisz skr�tu: ';
DM_bro_brakamunicji='brak amunicji';
DM_bro_bronniedostepna='bro� jeszcze niedost�pna';
DM_bro_bronniedostepna_jeszcze='brak';
DM_bro_bronniedostepna_pkt=' pkt:';
DM_bro_bronniedostepna_jeszczetrup=' trp:';
DM_bro_zbierzminy='Zbierz wszystkie uszkodzone miny';
DM_bro_wysadzminy='Wysad� wszystkie dzia�aj�ce miny';

{GRA}
Gra_odtwarzane='Odtwarzane: ';
Gra_Muzykawylaczona='Muzyka wy��czona';
Gra_pauza='-PAUZA-';
Gra_xkombo='xKOMBO';
Gra_MEGASMIERC='MEGA�MIER�!';
{liczniki w grze}
Gra_licz_czas='Czas: ';
Gra_licz_zebraneflagi='Zebrane flagi: ';
Gra_licz_zniszczoneflagi='Zniszczone flagi: ';
Gra_licz_zginelo='Zgin�o postaci: ';
Gra_licz_znalazlosiedobrze='W dobrym miejscu jest ju� postaci: ';
Gra_licz_znalazlosiezle='W z�ym miejscu jest ju� postaci: ';
Gra_licz_z_grupy=' z dru�yny ';

Gra_gorlicz_pkt='P:';
Gra_gorlicz_trp='T:';
Gra_gorlicz_czas='C:';

{kolesie}
Kol_info_druz='dru�:';
Kol_info_sila='si�a:';
Kol_info_bron='bro�:';
Kol_info_amun='amun:';
Kol_info_tlen='tlen:';

{misje}
Mis_nacisnij_spacje='Naci�nij spacj� lub F8 aby kontynuowa�...';
Mis_nacisnij_spacje_wygrana='Naci�nij SPACJ� aby gra� dalej w trybie zwyk�ej gry lub'#13#10'ESC by wr�ci� do menu i wybra� nast�pna misj�.';
Mis_czas='Czas na wype�nienie misji: ';
Mis_czasieograniczony='Nieograniczony';
Mis_nagroda='Nagroda za wype�nienie: ';
Mis_punktow=' pkt.';
Mis_misjawypelniona='Misja zako�czona sukcesem!';
Mis_otrzymujesz='Otrzymujesz ';
Mis_maszpkt='Masz ju� ';
Mis_misjaprzegrana='Nie uda�o ci si� wype�ni� misji!';
Mis_nacisnij_spacje_przegrana='Naci�nij SPACJ� aby gra� dalej w trybie zwyk�ej gry lub'#13#10'ESC by wr�ci� do menu i wybra� jeszcze raz'#13#10't� misj� lub inn�.';
Mis_autor='Tw�rca misji: ';

{kolesie}
const
Kol_bron_nazwy:array[0..4] of string[10]=('brak','granat','bomba','karabin','dynamit');

const
nazwy_broni:array[0..max_broni] of string[30]=(
     { 0}'wentylator',
     { 1}'bazuka',
     { 2}'granat r�czny',
     { 3}'bomba od�amkowa',
     { 4}'przedmioty',
     { 5}'minigan',
     { 6}'karabin maszynowy',
     { 7}'strzelba',
     { 8}'od�amki',
     { 9}'mi�so',
     {10}'mina naziemna',
     {11}'napalm',
     {12}'ogie�',
     {13}'bomba z gwo�dziami',
     {14}'pocisk wbijany',
     {15}'wielki granat',
     {16}'rakieta naprowadzana',
     {17}'ognista kula',
     {18}'mina wodna p�ywajaca',
     {19}'mina podwodna na linie',
     {20}'',
     {21}'dynamit',
     {22}'pi�ka',
     {23}'kolesie',
     {24}'nalot bombowy',
     {25}'nalot naprowadzany',
     {26}'pocisk napalmowy',
     {27}'nalot napalmowy',
     {28}'krew',
     {29}'snajperka',
     {30}'�mieci',
     {31}'dzia�o megafotonowe',
     {32}'dzia�ko protonowe',
     {33}'miotacz ognia',
     {34}'pi�y tarczowe',
     {35}'zwierzaki',
     {36}'radioaktywny dym',
     {37}'gaz w puszkach',
     {38}'bomba gazowa',
     {39}'ci�kie obiekty',
     {40}'koktajl molotov',
     {41}'laser',
     {42}'pr�d',
     {43}'rejlgan',
     {44}'hiperradioaktywny promie�',
     {45}'gaz wybuchaj�cy',
     {46}'nalot gazowy',
     {47}'rakieta z gazem',
     {48}'piorun',
     {49}'pi�a �a�cuchowa',
     {50}'m�otek',
     {51}'gaz wybuchaj�cy w puszkach',
     {52}'bomba na cia�o',
     {53}'roller',
     {54}'rakieta',
     {55}'promie� zemsty',
     {56}'b�oto',
     {57}'beczka z napalmem',
     {58}'bomba atomowa'
     );

nazwy_przedmiotow:array[0..ile_przedm] of string[30]=(
     { 0}'apteczka',
     { 1}'granaty',
     { 2}'bomby',
     { 3}'karabin',
     { 4}'dynamit',
     { 5}'tlen'
     );

nazwy_zwierzat:array[0..max_rodz_zwierzaki] of string[30]=(
     { 0}'nietoperz',
     { 1}'pirania',
     { 2}'motylek',
     { 3}'w�gorz elektryczny',
     { 4}'go��b',
     { 5}'ryba'
     );

wymagane_do_broni:array[0..max_broni] of record pkt,trup:int64; end=(
     { 0 - wentylator}                    ( pkt: 000000000; trup: 0000000000 ),
     { 1 - bazuka}                        ( pkt: 000000000; trup: 0000000000 ),
     { 2 - granat r�czny}                 ( pkt: 000020000; trup: 0000000100 ),
     { 3 - bomba od�amkowa}               ( pkt: 000090000; trup: 0000000300 ),
     { 4 - przedmioty}                    ( pkt: 000000000; trup: 0000000000 ),
     { 5 - minigan}                       ( pkt: 000050000; trup: 0000000400 ),
     { 6 - karabin maszynowy}             ( pkt: 000000000; trup: 0000000000 ),
     { 7 - strzelba}                      ( pkt: 000000000; trup: 0000000000 ),
     { 8 - od�amki}                       ( pkt: 000000000; trup: 0000000000 ),
     { 9 - mi�so}                         ( pkt: 000000000; trup: 0000000000 ),
     {10 - mina naziemna}                 ( pkt: 000140000; trup: 0000001600 ),
     {11 - napalm}                        ( pkt: 001300000; trup: 0000008000 ),
     {12 - ogie�}                         ( pkt: 000050000; trup: 0000000400 ),
     {13 - bomba z gwo�dziami}            ( pkt: 000000000; trup: 0000000000 ),
     {14 - pocisk wbijany}                ( pkt: 000000000; trup: 0000000000 ),
     {15 - wielki granat}                 ( pkt: 000000000; trup: 0000000000 ),
     {16 - rakieta naprowadzana}          ( pkt: 000650000; trup: 0000006500 ),
     {17 - ognista kula}                  ( pkt: 001000000; trup: 0000009000 ),
     {18 - mina wodna p�ywajaca}          ( pkt: 000000000; trup: 0000000000 ),
     {19 - mina podwodna na linie}        ( pkt: 000000000; trup: 0000000000 ),
     {20 - }                              ( pkt: 000000000; trup: 0000000000 ),
     {21 - dynamit}                       ( pkt: 000070000; trup: 0000000600 ),
     {22 - pi�ka}                         ( pkt: 000000000; trup: 0000000000 ),
     {23 - kolesie}                       ( pkt: 000000000; trup: 0000000000 ),
     {24 - nalot bombowy}                 ( pkt: 000300000; trup: 0000002000 ),
     {25 - nalot naprowadzany}            ( pkt: 000900000; trup: 0000005000 ),
     {26 - pocisk napalmowy}              ( pkt: 000250000; trup: 0000002500 ),
     {27 - nalot napalmowy}               ( pkt: 001200000; trup: 0000006000 ),
     {28 - krew}                          ( pkt: 000000000; trup: 0000000000 ),
     {29 - snajperka}                     ( pkt: 000200000; trup: 0000003500 ),
     {30 - �mieci}                        ( pkt: 000050000; trup: 0000000300 ),
     {31 - dzia�o megafotonowe}           ( pkt: 004000000; trup: 0000010000 ),
     {32 - dzia�ko protonowe}             ( pkt: 000600000; trup: 0000003000 ),
     {33 - miotacz ognia}                 ( pkt: 000000000; trup: 0000000000 ),
     {34 - pi�y tarczowe}                 ( pkt: 000000000; trup: 0000000000 ),
     {35 - zwierzaki}                     ( pkt: 000000000; trup: 0000000000 ),
     {36 - radioaktywny dym}              ( pkt: 000450000; trup: 0000004300 ),
     {37 - gaz w puszkach}                ( pkt: 000000000; trup: 0000000000 ),
     {38 - bomba gazowa}                  ( pkt: 000000000; trup: 0000000000 ),
     {39 - ci�kie obiekty}               ( pkt: 000000000; trup: 0000000000 ),
     {40 - koktajl molotov}               ( pkt: 000000000; trup: 0000000000 ),
     {41 - laser}                         ( pkt: 000000000; trup: 0000000000 ),
     {42 - pr�d}                          ( pkt: 000000000; trup: 0000000000 ),
     {43 - rejlgan}                       ( pkt: 000000000; trup: 0000000000 ),
     {44 - hiperradioaktywny promie�}     ( pkt: 000000000; trup: 0000000000 ),
     {45 - gaz wybuchaj�cy}               ( pkt: 001200000; trup: 0000008000 ),
     {46 - nalot gazowy}                  ( pkt: 000000000; trup: 0000000000 ),
     {47 - rakieta z gazem}               ( pkt: 000000000; trup: 0000000000 ),
     {48 - piorun}                        ( pkt: 000000000; trup: 0000000000 ),
     {49 - pi�a �a�cuchowa}               ( pkt: 000000000; trup: 0000000000 ),
     {50 - m�otek}                        ( pkt: 000000000; trup: 0000000000 ),
     {51 - gaz wybuchaj�cy w puszkach}    ( pkt: 000000000; trup: 0000000000 ),
     {52 - bomba na cia�o}                ( pkt: 000000000; trup: 0000000000 ),
     {53 - roller}                        ( pkt: 000000000; trup: 0000000000 ),
     {54 - rakieta}                       ( pkt: 000000000; trup: 0000000000 ),
     {55 - promie� zemsty}                ( pkt: 027000000; trup: 0000300000 ),
     {56 - b�oto}                         ( pkt: 000000000; trup: 0000000000 ),
     {57 - beczka z napalmem}             ( pkt: 000000000; trup: 0000000000 ),
     {58 - bomba atomowa'}                ( pkt: 030000000; trup: 0000300000 )
     );

const
Menu_boczne_nazwy:array[0..4] of string[9]=('bronie','rysowanie','warunki','dru�yny','wej�cia');

Menu_boczne_rysowanie_nazwy:array[0..4] of string[9]=('kolor','tekstura','obiekty','kraw�dzie','�wiat�a');


const

rodzaje_wczytywanie:array[0..0] of string=(
   'Czy wiesz, �e...'
   );
hasla_wczytywanie:array[1..39] of record r:integer; t:string; end=(
    (r:0; t:'Kiedy posta� oberwie od drugiej, natychmiast pr�buje si� odwzajemni�.'),
    (r:0; t:'Kiedy posta� ma ma�o si�y, ucieka przed wrogiem.'),
    (r:0; t:'Posta� we�mie przedmiot tylko wtedy, gdy go zobaczy niedaleko od siebie.'),
    (r:0; t:'Posta� bierze bro� tylko je�li nie ma pe�nej amunicji lub bro� jest lepsza ni� ma obecnie.'),
    (r:0; t:'Przechodz�c postaci� obok wielu wrog�w masz wi�ksze szanse prze�y� biegn�c szybko ni� pr�buj�c ich zabi�.'),
    (r:0; t:'Postacie uciekaj� przed ogniem.'),
    (r:0; t:'Postacie zabijaj� szybko p�on�cych, by nie zapali�y si� same.'),
    (r:0; t:'Posta� nasy�a na wroga innych ze swojej dru�yny.'),
    (r:0; t:'Kursorem myszy mo�esz przenosi� postacie, zwierz�ta, miny, itd.'),
    (r:0; t:'Wymazuj�c tylko mask� terenu i zostawiaj�c rysunek mo�esz tworzy� tajne przej�cia.'),
    (r:0; t:'Podwodne miny na linie mog� r�wnie� na niej wisie� w powietrzu.'),
    (r:0; t:'Aby postawi� min� na linie, najpierw zaczep myszk� o teren i przeci�gnij w inne miejsce sam� min�.'),
    (r:0; t:'Nie wszystkie bronie dost�pne s� od pocz�tku. Zbieraj punkty i zabijaj by odkrywa� nowe bronie.'),
    (r:0; t:'Zabici przez si�y natury przynios� ci znacznie mniej punkt�w ni� zabici przez ciebie!'),
    (r:0; t:'Nak�adaniem trawy w innych kolorach mo�esz symulowa� o�wietlenie terenu w dowolnym kolorze.'),
    (r:0; t:'Je�li warunki pogodowe zbyt mocno zwalniaj� gr�, wy��cz chmury.'),
    (r:0; t:'Ka�da z cieczy (woda, kwas, b�oto, itd.) ma swoj� g�sto��, co wida� i po ruchu fal i pr�dko�ci toni�cia w niej.'),
    (r:0; t:'Piorun lub pr�d strzelony w wod� mo�e natychmiast zabi� w niej wszystkich.'),
    (r:0; t:'Wentylator mo�e dmucha� i wci�ga� powietrze (lewy lub prawy klawisz myszy).'),
    (r:0; t:'Gaz wybuchaj�cy mo�na rozpyli� i podpali�.'),
    (r:0; t:'Bomb� na cia�o nale�y na�o�y� na posta� (ma�a si�a strza�u, kliknij na samej postaci).'),
    (r:0; t:'Postacie mog� wykopa� daleko od siebie granat, dynamit, czy inn� bro�.'),
    (r:0; t:'Postacie uciekaj� przed postaci� z za�o�on� bomb� na cia�o.'),
    (r:0; t:'W dolnym menu mo�esz ustawi� w�a�ciwo�ci ka�dej dru�yny: pocz�tkow� bro�, si�� i spos�b pojawiania si�.'),
    (r:0; t:'Mo�esz ustali�, kt�ra dru�yna b�dzie zaprzyja�niona z kt�r�. Mo�na te� ustali� przyja�� jednostronn�, gdzie jedna dru�yna zabija drug�, ale nie odwrotnie.'),
    (r:0; t:'W dolnym menu ustawie� dru�yny, klikaj na ikonkach przyja�ni lewym przyciskiem, by zmieni� tylko dla wybranej dru�yny lub prawym, by zmieni� jednocze�nie dla obu.'),
    (r:0; t:'Najwi�ksza "twardo��" terenu jest ca�kowicie niezniszczalna.'),
    (r:0; t:'Rysuj�c obiekty, prawy klawisz myszy odwraca je lustrzanie w poziomie.'),
    (r:0; t:'Mo�esz rysowa� na raz serie po��czonych ze sob� obiekt�w. Do zmiany kierunku i rozstrzelenia u�yj prawego klawisza myszy (jak w celowniku).'),
    (r:0; t:'Celownik obs�uguje si� bardzo �atwo: z prawym klawiszem myszy przesuwanie myszy na boki zmienia k�t, a w g�r� i w d� zmienia si��.'),
    (r:0; t:'Im bardziej wymy�lne sposoby �mierci, tym wi�cej punkt�w.'),
    (r:0; t:'Za zabicie z du�� si�� dostaniesz premi� punktow� (zobaczysz napis MEGA�MIER�).'),
    (r:0; t:'Zabicie kilku postaci na raz to kombo. Im wi�ksze kombo, tym wi�cej punkt�w dostaniesz!'),
    (r:0; t:'W trybie misji klawisz F8 ponownie poka�e na ekranie cele misji.'),
    (r:0; t:'Klawisz F7 zmienia widok kursora myszy'),
    (r:0; t:'Klawisze F1 i F2 zmieniaj� wybran� kategori� broni oraz bro� na nast�pn�.'),
    (r:0; t:'W czasie pauzy prawie wszystko nadal mo�na robi�, tylko czas stoi.'),
    (r:0; t:'Klawisz ` pozwala ukry� cz�� lub ca�o�� dolnego menu.'),
    (r:0; t:'Klawisz TAB zmienia dolne menu na nast�pne.')
  );




implementation

end.

