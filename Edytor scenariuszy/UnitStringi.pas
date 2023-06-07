unit UnitStringi;

interface
const
  max_broni=56;

const

domyslne_imie = 'Sadysta';

{napis pod logiem wczytywania}
Log_is_on = 'Log w³¹czony';
Logo_wczytywanie = 'wczytywanie';
Logo_Tworzenieterenu='Tworzenie terenu...';

{menu glowne}
Opcje_GlosZlegoPana = 'G³os Z³ego Pana';
Opcje_Dzwieki = 'DŸwiêki';
Opcje_Glosnoscdzwiekow = 'G³oœnoœæ dŸwiêków';
Opcje_Muzyka = 'Muzyka';
Opcje_Glosnoscmuzyki = 'G³oœnoœæ muzyki';
Opcje_Krewmiesozostawiasladynaterenie = 'Krew/miêso zostawia œlady na terenie';
Opcje_Chowajlicznikiwynikowwczasiebezczynnosci = 'Chowaj liczniki wyników w czasie bezczynnoœci';
Opcje_Swiatla = 'Œwiat³a';
Opcje_Wstrzasy = 'Wstrz¹sy ekranu od wybuchów';
Opcje_Liczniki = 'Pokazuj liczniki punktów i czasu na ekranie (F12)';

Nowy_Szerokoscterenu = 'Szerokoœæ terenu';
Nowy_Wysokoscterenu = 'Wysokoœæ terenu';
Nowy_Podloze = 'Pod³o¿e';
Nowy_Obiekty = 'Obiekty';
Nowy_Przedmioty = 'Przedmioty';
Nowy_Miny = 'Miny';

WczDruz_Druzyna= 'Dru¿yna';

Tereny_brakterenow = 'BRAK TERENÓW';
Misje_brakmisji = 'BRAK MISJI';
Podaj_swoje_imie= 'Podaj swoje imiê:';
Podaj_nazwe_terenu= 'Podaj nazwê terenu:';

{dolne menu rysowanie}
DM_rys_wytrzymalosc = 'wytrzyma³oœæ';
DM_rys_wielkosc = 'wielkoœæ';
DM_rys_ziarnistosc = 'ziarnistoœæ';
DM_rys_ksztalt = 'kszta³t';
DM_rys_pokazmasketeren = 'poka¿ maskê/teren';
DM_rys_zprzoduztylu = 'z przodu/z ty³u';
DM_rys_poprzedniatekstura = 'poprzednia tekstura';
DM_rys_nastepnatekstura = 'nastêpna tekstura';
DM_rys_rysujmasketeren = 'rysuj maskê/teren';
DM_rys_ilosc = 'iloœæ';
DM_rys_poprzedniobiekt = 'poprzedni obiekt';
DM_rys_nastepnyobiekt = 'nastêpny obiekt';
DM_rys_odleglosci = 'odleg³oœci';
DM_rys_kat = 'k¹t';
DM_rys_gornyefekt = 'górny efekt';
DM_rys_dolnyefekt = 'dolny efekt';
DM_rys_R = 'R (czerwony)';
DM_rys_G = 'G (zielony)';
DM_rys_B = 'B (niebieski)';
DM_rys_jasnosc = 'jasnoœæ';
DM_rys_rodzaj = 'rodzaj';
DM_rys_efekt = 'efekt';
DM_rys_zniszczalneniezniszczalne = 'zniszczalne/niezniszczalne';
DM_rys_Dodajnoweswiatlo='Dodaj nowe œwiat³o';
DM_rys_Usunwybraneswiatlo='Usuñ wybrane œwiat³o';

{dolne menu warunki}
DM_war_Kierunekwiatru='Kierunek wiatru';
DM_war_Silawiatru='Si³a wiatru';
DM_war_Zachmurzenie='Zachmurzenie';
DM_war_Typzachmurzenia='Typ zachmurzenia';
DM_war_Stopienzachmurzenia='Stopieñ zachmurzenia';
DM_war_Grawitacja='Grawitacja (%)';
DM_war_Burza='Burza';
DM_war_Silaburzy='Si³a burzy';
DM_war_Deszcz='Deszcz';
DM_war_Snieg='Œnieg';
DM_war_Bezniczego='Bez niczego';
DM_war_Woda='Woda';
DM_war_Lawa='Lawa';
DM_war_Radioaktywnykwas='Radioaktywny kwas';
DM_war_Krew='Krew';
DM_war_Bloto='B³oto';
DM_war_Poziom='Poziom';
DM_war_Czas='Czas';
DM_war_Pauza='Pauza';
DM_war_Agresja='Agresja';
DM_war_Walkabezpowodu='Walka bez powodu';
DM_war_Walkazeswoimi='Walka ze swoimi';
DM_war_Zwierzetapojawiajasiesame='Zwierzêta pojawiaj¹ siê same';
DM_war_Informacjeopostaci='Informacje o postaci';
DM_war_Wskaznikipostaci='WskaŸniki postaci';
DM_war_Muzyka='Muzyka';
DM_war_Dzwieki='DŸwiêki';

{dolne menu druzyny}
DM_dru_Ilosckolesi='Iloœæ kolesi';
DM_dru_Silapoczatkowa='Si³a pocz¹tkowa';
DM_dru_Bronpoczatkowa='Broñ pocz¹tkowa';
DM_dru_Amunicja='Amunicja';
DM_dru_Ustawieniadruzyny='Ustawienia dru¿yny ';
DM_dru_Przyjazna='Przyjazna';
DM_dru_Wroga='Wroga';
DM_dru_druzyna=' dru¿yna ';

{dolne menu wejscia}
DM_wej_Wybranewejscie='Wybrane wejœcie';
DM_wej_Dodajnowewejscie='Dodaj nowe wejœcie';
DM_wej_Usunwybranewejscie='Usuñ wybrane wejœcie';
DM_wej_Wyrzucterazwszystkichbrakujacych='Wyrzuæ teraz wszystkich brakuj¹cych';
DM_wej_Czestotliwoscwchodzenia='Czêstotliwoœæ wchodzenia';
DM_wej_Brakujeprocentzdruzynyzebyweszlinowi='¯eby weszli nowi, musi zostaæ procent z dru¿yny';
DM_wej_Wchodzarowniezznieba='Wchodz¹ równie¿ z nieba';
DM_wej_Tymwejsciemwchodzidruzyna='Tym wejœciem wchodzi dru¿yna ';
DM_wej_gora='góra';
DM_wej_Wybierzwejscieznieba='Wybierz wejœcie z nieba';

{dolne menu bronie}
DM_bro_klawiszskrotu='klawisz skrótu: ';
DM_bro_zbierzminy='Zbierz wszystkie uszkodzone miny';
DM_bro_wysadzminy='WysadŸ wszystkie dzia³aj¹ce miny';

{GRA}
Gra_odtwarzane='Odtwarzane: ';
Gra_Muzykawylaczona='Muzyka wy³¹czona';
Gra_pauza='-PAUZA-';
Gra_xkombo='xKOMBO';
Gra_MEGASMIERC='MEGAŒMIERÆ!';
{liczniki w grze}
Gra_licz_czas='Czas: ';
Gra_licz_zebraneflagi='Zebrane flagi: ';
Gra_licz_zniszczoneflagi='Zniszczone flagi: ';
Gra_licz_zginelo='Zginê³o postaci: ';
Gra_licz_znalazlosiedobrze='W dobrym miejscu jest ju¿ postaci: ';
Gra_licz_znalazlosiezle='W z³ym miejscu jest ju¿ postaci: ';
Gra_licz_z_grupy=' z dru¿yny ';

{kolesie}
Kol_info_druz='dru¿:';
Kol_info_sila='si³a:';
Kol_info_bron='broñ:';
Kol_info_amun='amun:';
Kol_info_tlen='tlen:';

{misje}
Mis_nacisnij_spacje='Naciœnij spacjê aby kontynuowaæ...';
Mis_nacisnij_spacje_wygrana='Naciœnij SPACJÊ aby graæ dalej w trybie zwyk³ej gry lub'#13#10'ESC by wróciæ do menu i wybraæ nastêpna misjê.';
Mis_czas='Czas na wype³nienie misji: ';
Mis_czasieograniczony='Nieograniczony';
Mis_nagroda='Nagroda za wype³nienie: ';
Mis_punktow=' pkt.';
Mis_misjawypelniona='Misja zakoñczona sukcesem!';
Mis_otrzymujesz='Otrzymujesz ';
Mis_maszpkt='Masz ju¿ ';
Mis_misjaprzegrana='Nie uda³o ci siê wype³niæ misji!';
Mis_nacisnij_spacje_przegrana='Naciœnij SPACJÊ aby graæ dalej w trybie zwyk³ej gry lub'#13#10'ESC by wróciæ do menu i wybraæ jeszcze raz'#13#10'tê misjê lub inn¹.';
Mis_autor='Twórca misji: ';

{kolesie}
const
Kol_bron_nazwy:array[0..4] of string[10]=('brak','granat','bomba','karabin','dynamit');

const
nazwy_broni:array[0..max_broni] of string[30]=(
     { 0}'wentylator',
     { 1}'bazuka',
     { 2}'granat rêczny',
     { 3}'bomba od³amkowa',
     { 4}'przedmioty',
     { 5}'minigan',
     { 6}'karabin maszynowy',
     { 7}'strzelba',
     { 8}'od³amki',
     { 9}'miêso',
     {10}'miny naziemne',
     {11}'napalm',
     {12}'ogieñ',
     {13}'bomba z gwoŸdziami',
     {14}'pocisk wbijany',
     {15}'wielki granat',
     {16}'rakieta naprowadzana',
     {17}'ognista kula',
     {18}'mina wodna p³ywajaca',
     {19}'mina podwodna na linie',
     {20}'',
     {21}'dynamit',
     {22}'pi³ka',
     {23}'kolesie',
     {24}'nalot bombowy',
     {25}'nalot naprowadzany',
     {26}'pocisk napalmowy',
     {27}'nalot napalmowy',
     {28}'krew',
     {29}'snajperka',
     {30}'œmieci',
     {31}'dzia³o megafotonowe',
     {32}'dzia³ko protonowe',
     {33}'miotacz ognia',
     {34}'pi³y tarczowe',
     {35}'zwierzaki',
     {36}'radioaktywny dym',
     {37}'gaz w puszkach',
     {38}'bomba gazowa',
     {39}'ciê¿kie obiekty',
     {40}'koktajl molotov',
     {41}'laser',
     {42}'pr¹d',
     {43}'rejlgan',
     {44}'hiperradioaktywny promieñ',
     {45}'gaz wybuchaj¹cy',
     {46}'nalot gazowy',
     {47}'rakieta z gazem',
     {48}'piorun',
     {49}'pi³a ³añcuchowa',
     {50}'m³otek',
     {51}'gaz wybuchaj¹cy w puszkach',
     {52}'bomba na cia³o',
     {53}'roller',
     {54}'rakieta',
     {55}'promieñ zemsty',
     {56}'b³oto'
     );

const
Menu_boczne_nazwy:array[0..4] of string[9]=('bronie','rysowanie','warunki','dru¿yny','wejœcia');

Menu_boczne_rysowanie_nazwy:array[0..4] of string[9]=('kolor','tekstura','obiekty','krawêdzie','œwiat³a');


implementation

end.
