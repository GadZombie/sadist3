unit UnitStringi;

interface
const
  max_broni=52;

resourcestring

domyslne_imie = 'Sadysta';

{napis pod logiem wczytywania}
Logo_wczytywanie = 'wczytywanie';
Logo_Tworzenieterenu='Tworzenie terenu...';

{menu glowne}
Opcje_GlosZlegoPana = 'Glos Zlego Pana';
Opcje_Dzwieki = 'Dzwieki';
Opcje_Glosnoscdzwiekow = 'Glosnosc dzwiekow';
Opcje_Muzyka = 'Muzyka';
Opcje_Glosnoscmuzyki = 'Glosnosc muzyki';
Opcje_Krewmiesozostawiasladynaterenie = 'Krew/mieso zostawia slady na terenie';
Opcje_Chowajlicznikiwynikowwczasiebezczynnosci = 'Chowaj liczniki wynikow w czasie bezczynnosci';

Nowy_Szerokoscterenu = 'Szerokosc terenu';
Nowy_Wysokoscterenu = 'Wysokosc terenu';
Nowy_Podloze = 'Podloze';
Nowy_Obiekty = 'Obiekty';
Nowy_Przedmioty = 'Przedmioty';
Nowy_Miny = 'Miny';

WczDruz_Druzyna= 'Druzyna';


{dolne menu rysowanie}
DM_rys_wytrzymalosc = 'wytrzymalosc';
DM_rys_wielkosc = 'wielkosc';
DM_rys_ziarnistosc = 'ziarnistosc';
DM_rys_ksztalt = 'ksztalt';
DM_rys_pokazmasketeren = 'pokaz maske/teren';
DM_rys_zprzoduztylu = 'z przodu/z tylu';
DM_rys_poprzedniatekstura = 'poprzednia tekstura';
DM_rys_nastepnatekstura = 'nastepna tekstura';
DM_rys_rysujmasketeren = 'rysuj maske/teren';
DM_rys_ilosc = 'ilosc';
DM_rys_poprzedniobiekt = 'poprzedni obiekt';
DM_rys_nastepnyobiekt = 'nastepny obiekt';
DM_rys_odleglosci = 'odleglosci';
DM_rys_kat = 'kat';
DM_rys_gornyefekt = 'gorny efekt';
DM_rys_dolnyefekt = 'dolny efekt';
DM_rys_R = 'R (czerwony)';
DM_rys_G = 'G (zielony)';
DM_rys_B = 'B (niebieski)';

{dolne menu warunki}
DM_war_Kierunekwiatru='Kierunek wiatru';
DM_war_Silawiatru='Sila wiatru';
DM_war_Zachmurzenie='Zachmurzenie';
DM_war_Typzachmurzenia='Typ zachmurzenia';
DM_war_Stopienzachmurzenia='Stopien zachmurzenia';
DM_war_Burza='Burza';
DM_war_Silaburzy='Sila burzy';
DM_war_Deszcz='Deszcz';
DM_war_Snieg='Snieg';
DM_war_Bezniczego='Bez niczego';
DM_war_Woda='Woda';
DM_war_Lawa='Lawa';
DM_war_Radioaktywnykwas='Radioaktywny kwas';
DM_war_Krew='Krew';
DM_war_Bloto='Bloto';
DM_war_Poziom='Poziom';
DM_war_Czas='Czas';
DM_war_Pauza='Pauza';
DM_war_Agresja='Agresja';
DM_war_Walkabezpowodu='Walka bez powodu';
DM_war_Walkazeswoimi='Walka ze swoimi';
DM_war_Zwierzetapojawiajasiesame='Zwierzeta pojawiaja sie same';
DM_war_Informacjeopostaci='Informacje o postaci';
DM_war_Wskaznikipostaci='Wskazniki postaci';
DM_war_Muzyka='Muzyka';
DM_war_Dzwieki='Dzwieki';

{dolne menu druzyny}
DM_dru_Ilosckolesi='Ilosc kolesi';
DM_dru_Silapoczatkowa='Sila poczatkowa';
DM_dru_Bronpoczatkowa='Bron poczatkowa';
DM_dru_Amunicja='Amunicja';
DM_dru_Ustawieniadruzyny='Ustawienia druzyny ';
DM_dru_Przyjazna='Przyjazna';
DM_dru_Wroga='Wroga';
DM_dru_druzyna=' druzyna ';

{dolne menu wejscia}
DM_wej_Wybranewejscie='Wybrane wejscie';
DM_wej_Dodajnowewejscie='Dodaj nowe wejscie';
DM_wej_Usunwybranewejscie='Usun wybrane wejscie';
DM_wej_Wyrzucterazwszystkichbrakujacych='Wyrzuc teraz wszystkich brakujacych';
DM_wej_Czestotliwoscwchodzenia='Czestotliwosc wchodzenia';
DM_wej_Brakujeprocentzdruzynyzebyweszlinowi='Brakuje procent z druzyny, zeby weszli nowi';
DM_wej_Wchodzarowniezznieba='Wchodza rowniez z nieba';
DM_wej_Tymwejsciemwchodzidruzyna='Tym wejsciem wchodzi druzyna ';
DM_wej_gora='gora';

{dolne menu bronie}
DM_bro_klawiszskrotu='klawisz skrotu: ';

{GRA}
Gra_odtwarzane='Odtwarzane: ';
Gra_Muzykawylaczona='Muzyka wylaczona';
Gra_pauza='-PAUZA-';
Gra_xkombo='xKOMBO';
Gra_MEGASMIERC='MEGASMIERC!';

{kolesie}
Kol_info_druz='druz:';
Kol_info_sila='sila:';
Kol_info_bron='bron:';
Kol_info_amun='amun:';
Kol_info_tlen='tlen:';


{kolesie}
const
Kol_bron_nazwy:array[0..3] of string[10]=('brak','granat','bomba','karabin');

const
nazwy_broni:array[0..max_broni] of string[30]=(
     { 0}'wentylator',
     { 1}'bazuka',
     { 2}'granat reczny',
     { 3}'bomba odlamkowa',
     { 4}'przedmioty',
     { 5}'minigan',
     { 6}'karabin maszynowy',
     { 7}'dubeltowka',
     { 8}'odlamki',
     { 9}'mieso',
     {10}'miny naziemne',
     {11}'napalm',
     {12}'ogien',
     {13}'bomba z gwozdziami',
     {14}'pocisk wbijany',
     {15}'wielki granat',
     {16}'rakieta naprowadzana',
     {17}'ognista kula',
     {18}'mina wodna plywajaca',
     {19}'mina podwodna na linie',
     {20}'',
     {21}'dynamit',
     {22}'pilka',
     {23}'kolesie',
     {24}'nalot bombowy',
     {25}'nalot naprowadzany',
     {26}'pocisk napalmowy',
     {27}'nalot napalmowy',
     {28}'krew',
     {29}'snajperka',
     {30}'smieci',
     {31}'dzialo megafotonowe',
     {32}'dzialko protonowe',
     {33}'miotacz ognia',
     {34}'pily tarczowe',
     {35}'zwierzaki',
     {36}'radioaktywny dym',
     {37}'gaz w puszkach',
     {38}'bomba gazowa',
     {39}'ciezkie obiekty',
     {40}'koktajl molotov',
     {41}'laser',
     {42}'prad',
     {43}'rejlgan',
     {44}'hiperradioaktywny promien',
     {45}'gaz wybuchajacy',
     {46}'nalot gazowy',
     {47}'rakieta z gazem',
     {48}'piorun',
     {49}'pila lancuchowa',
     {50}'mlotek',
     {51}'gaz wybuchajacy w puszkach',
     {52}'bomba na cialo'
     );
implementation

end.
