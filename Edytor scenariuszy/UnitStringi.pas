unit UnitStringi;

interface
const
  max_broni=56;

const

domyslne_imie = 'Sadysta';

{napis pod logiem wczytywania}
Log_is_on = 'Log w��czony';
Logo_wczytywanie = 'wczytywanie';
Logo_Tworzenieterenu='Tworzenie terenu...';

{menu glowne}
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

Nowy_Szerokoscterenu = 'Szeroko�� terenu';
Nowy_Wysokoscterenu = 'Wysoko�� terenu';
Nowy_Podloze = 'Pod�o�e';
Nowy_Obiekty = 'Obiekty';
Nowy_Przedmioty = 'Przedmioty';
Nowy_Miny = 'Miny';

WczDruz_Druzyna= 'Dru�yna';

Tereny_brakterenow = 'BRAK TEREN�W';
Misje_brakmisji = 'BRAK MISJI';
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
DM_war_Muzyka='Muzyka';
DM_war_Dzwieki='D�wi�ki';

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

{kolesie}
Kol_info_druz='dru�:';
Kol_info_sila='si�a:';
Kol_info_bron='bro�:';
Kol_info_amun='amun:';
Kol_info_tlen='tlen:';

{misje}
Mis_nacisnij_spacje='Naci�nij spacj� aby kontynuowa�...';
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
     {10}'miny naziemne',
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
     {56}'b�oto'
     );

const
Menu_boczne_nazwy:array[0..4] of string[9]=('bronie','rysowanie','warunki','dru�yny','wej�cia');

Menu_boczne_rysowanie_nazwy:array[0..4] of string[9]=('kolor','tekstura','obiekty','kraw�dzie','�wiat�a');


implementation

end.
