unit UnitStringi;

interface
const
  max_broni=58;
  ile_przedm=5; {0..ile_przedm}
  max_rodz_zwierzaki=5;

const

domyslne_imie = 'Sadysta';

{napis pod logiem wczytywania}
Log_is_on = 'Log w³¹czony';
Logo_wczytywanie = 'wczytywanie';
Logo_Tworzenieterenu='Tworzenie terenu...';
Logo_WczytywanieDruzyny='wczytywanie dru¿yny ';

{menu glowne}
MenuGlownePodp_SzybkaGra = 'Rozpoczêcie gry z losowymi ustawieniami'#13'(zawsze tryb zwyk³ej gry)';
MenuGlownePodp_NowaGra = 'Wybór ustawieñ gry, wczytanie misji, terenu i rozpoczêcie gry'#13'lub zmiana obecnych ustawieñ';
MenuGlownePodp_ZapisOdczyt = 'Zapis na dysku obecnego terenu';
MenuGlownePodp_WybDruzyn = 'Wybór wygl¹du i ustawienia kolorów dru¿yn';
MenuGlownePodp_Opcje = 'Ustawienia ogólne gry';
MenuGlownePodp_Najwieksi = 'Lista Najwspanialszych, Najwiêkszych Sadystów,'#13'czyli prawdziwie mordercze wyniki!';
MenuGlownePodp_Autorzy = '"Lista p³ac", czyli co kto zrobi³, do czego siê przyczyni³,'#13'trochê obrazków, muzyka itp...';
MenuGlownePodp_Wyjscie = 'Wyjœcie do nudnego, smutnego, prawdziwego œwiata,'#13'gdzie mordowanie ma swoje konsekwencje,'#13'a ty nie jesteœ ju¿ wszechmog¹cy!'#13'Lepiej nie wciskaj tego guzika!!';
MenuGlowneGlobalne = 'Globalnie: ';
MenuGlowneGlobalnePkt = 'Punktów: ';
MenuGlowneGlobalneTrup = 'Trupów: ';
MenuGlowneGlobalneGier = 'Gier: ';

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
Opcje_Czestpaczek = 'Czêstotliwoœæ spadania paczek z nieba (0:brak)';
Opcje_Paczkiwdowolnychmiejscach = 'Paczki pojawiaj¹ siê w dowolnych miejscach (nie tylko spadaj¹ z nieba)';
Opcje_Poziomdetali = 'Poziom detali';
Opcje_Kursor = 'Rodzaj kursora myszy w grze (F7)';

Nowy_Szerokoscterenu = 'Szerokoœæ terenu';
Nowy_Wysokoscterenu = 'Wysokoœæ terenu';
Nowy_Podloze = 'Pod³o¿e';
Nowy_Obiekty = 'Obiekty';
Nowy_Przedmioty = 'Przedmioty';
Nowy_Miny = 'Miny';

WczDruz_Druzyna= 'Dru¿yna';

ListaNaj_datagry= 'Data gry: ';
ListaNaj_czasgry= 'Czas trwania gry: ';
ListaNaj_trupow= 'Trupów: ';
ListaNaj_pkt= 'Punktów: ';
ListaNaj_obecnagra= '*Obecna gra*';

Tereny_brakterenow = 'BRAK TERENÓW';
Misje_brakmisji = 'BRAK MISJI';
Misje_sumamisji = 'Suma wszystkich misji: ';
Misje_skonczonychmisji = 'Zakoñczonych misji: ';
Misje_nieskonczonychmisji = 'Misji do wykonania: ';
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
DM_war_Dzwieki='DŸwiêki';
DM_war_Muzyka='Muzyka';
DM_war_Muzyka_nastepne='Nastêpny utwór';

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
DM_bro_brakamunicji='brak amunicji';
DM_bro_bronniedostepna='broñ jeszcze niedostêpna';
DM_bro_bronniedostepna_jeszcze='brak';
DM_bro_bronniedostepna_pkt=' pkt:';
DM_bro_bronniedostepna_jeszczetrup=' trp:';
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

Gra_gorlicz_pkt='P:';
Gra_gorlicz_trp='T:';
Gra_gorlicz_czas='C:';

{kolesie}
Kol_info_druz='dru¿:';
Kol_info_sila='si³a:';
Kol_info_bron='broñ:';
Kol_info_amun='amun:';
Kol_info_tlen='tlen:';

{misje}
Mis_nacisnij_spacje='Naciœnij spacjê lub F8 aby kontynuowaæ...';
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
     {10}'mina naziemna',
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
     {56}'b³oto',
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
     { 3}'wêgorz elektryczny',
     { 4}'go³¹b',
     { 5}'ryba'
     );

wymagane_do_broni:array[0..max_broni] of record pkt,trup:int64; end=(
     { 0 - wentylator}                    ( pkt: 000000000; trup: 0000000000 ),
     { 1 - bazuka}                        ( pkt: 000000000; trup: 0000000000 ),
     { 2 - granat rêczny}                 ( pkt: 000020000; trup: 0000000100 ),
     { 3 - bomba od³amkowa}               ( pkt: 000090000; trup: 0000000300 ),
     { 4 - przedmioty}                    ( pkt: 000000000; trup: 0000000000 ),
     { 5 - minigan}                       ( pkt: 000050000; trup: 0000000400 ),
     { 6 - karabin maszynowy}             ( pkt: 000000000; trup: 0000000000 ),
     { 7 - strzelba}                      ( pkt: 000000000; trup: 0000000000 ),
     { 8 - od³amki}                       ( pkt: 000000000; trup: 0000000000 ),
     { 9 - miêso}                         ( pkt: 000000000; trup: 0000000000 ),
     {10 - mina naziemna}                 ( pkt: 000140000; trup: 0000001600 ),
     {11 - napalm}                        ( pkt: 001300000; trup: 0000008000 ),
     {12 - ogieñ}                         ( pkt: 000050000; trup: 0000000400 ),
     {13 - bomba z gwoŸdziami}            ( pkt: 000000000; trup: 0000000000 ),
     {14 - pocisk wbijany}                ( pkt: 000000000; trup: 0000000000 ),
     {15 - wielki granat}                 ( pkt: 000000000; trup: 0000000000 ),
     {16 - rakieta naprowadzana}          ( pkt: 000650000; trup: 0000006500 ),
     {17 - ognista kula}                  ( pkt: 001000000; trup: 0000009000 ),
     {18 - mina wodna p³ywajaca}          ( pkt: 000000000; trup: 0000000000 ),
     {19 - mina podwodna na linie}        ( pkt: 000000000; trup: 0000000000 ),
     {20 - }                              ( pkt: 000000000; trup: 0000000000 ),
     {21 - dynamit}                       ( pkt: 000070000; trup: 0000000600 ),
     {22 - pi³ka}                         ( pkt: 000000000; trup: 0000000000 ),
     {23 - kolesie}                       ( pkt: 000000000; trup: 0000000000 ),
     {24 - nalot bombowy}                 ( pkt: 000300000; trup: 0000002000 ),
     {25 - nalot naprowadzany}            ( pkt: 000900000; trup: 0000005000 ),
     {26 - pocisk napalmowy}              ( pkt: 000250000; trup: 0000002500 ),
     {27 - nalot napalmowy}               ( pkt: 001200000; trup: 0000006000 ),
     {28 - krew}                          ( pkt: 000000000; trup: 0000000000 ),
     {29 - snajperka}                     ( pkt: 000200000; trup: 0000003500 ),
     {30 - œmieci}                        ( pkt: 000050000; trup: 0000000300 ),
     {31 - dzia³o megafotonowe}           ( pkt: 004000000; trup: 0000010000 ),
     {32 - dzia³ko protonowe}             ( pkt: 000600000; trup: 0000003000 ),
     {33 - miotacz ognia}                 ( pkt: 000000000; trup: 0000000000 ),
     {34 - pi³y tarczowe}                 ( pkt: 000000000; trup: 0000000000 ),
     {35 - zwierzaki}                     ( pkt: 000000000; trup: 0000000000 ),
     {36 - radioaktywny dym}              ( pkt: 000450000; trup: 0000004300 ),
     {37 - gaz w puszkach}                ( pkt: 000000000; trup: 0000000000 ),
     {38 - bomba gazowa}                  ( pkt: 000000000; trup: 0000000000 ),
     {39 - ciê¿kie obiekty}               ( pkt: 000000000; trup: 0000000000 ),
     {40 - koktajl molotov}               ( pkt: 000000000; trup: 0000000000 ),
     {41 - laser}                         ( pkt: 000000000; trup: 0000000000 ),
     {42 - pr¹d}                          ( pkt: 000000000; trup: 0000000000 ),
     {43 - rejlgan}                       ( pkt: 000000000; trup: 0000000000 ),
     {44 - hiperradioaktywny promieñ}     ( pkt: 000000000; trup: 0000000000 ),
     {45 - gaz wybuchaj¹cy}               ( pkt: 001200000; trup: 0000008000 ),
     {46 - nalot gazowy}                  ( pkt: 000000000; trup: 0000000000 ),
     {47 - rakieta z gazem}               ( pkt: 000000000; trup: 0000000000 ),
     {48 - piorun}                        ( pkt: 000000000; trup: 0000000000 ),
     {49 - pi³a ³añcuchowa}               ( pkt: 000000000; trup: 0000000000 ),
     {50 - m³otek}                        ( pkt: 000000000; trup: 0000000000 ),
     {51 - gaz wybuchaj¹cy w puszkach}    ( pkt: 000000000; trup: 0000000000 ),
     {52 - bomba na cia³o}                ( pkt: 000000000; trup: 0000000000 ),
     {53 - roller}                        ( pkt: 000000000; trup: 0000000000 ),
     {54 - rakieta}                       ( pkt: 000000000; trup: 0000000000 ),
     {55 - promieñ zemsty}                ( pkt: 027000000; trup: 0000300000 ),
     {56 - b³oto}                         ( pkt: 000000000; trup: 0000000000 ),
     {57 - beczka z napalmem}             ( pkt: 000000000; trup: 0000000000 ),
     {58 - bomba atomowa'}                ( pkt: 030000000; trup: 0000300000 )
     );

const
Menu_boczne_nazwy:array[0..4] of string[9]=('bronie','rysowanie','warunki','dru¿yny','wejœcia');

Menu_boczne_rysowanie_nazwy:array[0..4] of string[9]=('kolor','tekstura','obiekty','krawêdzie','œwiat³a');


const

rodzaje_wczytywanie:array[0..0] of string=(
   'Czy wiesz, ¿e...'
   );
hasla_wczytywanie:array[1..39] of record r:integer; t:string; end=(
    (r:0; t:'Kiedy postaæ oberwie od drugiej, natychmiast próbuje siê odwzajemniæ.'),
    (r:0; t:'Kiedy postaæ ma ma³o si³y, ucieka przed wrogiem.'),
    (r:0; t:'Postaæ weŸmie przedmiot tylko wtedy, gdy go zobaczy niedaleko od siebie.'),
    (r:0; t:'Postaæ bierze broñ tylko jeœli nie ma pe³nej amunicji lub broñ jest lepsza ni¿ ma obecnie.'),
    (r:0; t:'Przechodz¹c postaci¹ obok wielu wrogów masz wiêksze szanse prze¿yæ biegn¹c szybko ni¿ próbuj¹c ich zabiæ.'),
    (r:0; t:'Postacie uciekaj¹ przed ogniem.'),
    (r:0; t:'Postacie zabijaj¹ szybko p³on¹cych, by nie zapali³y siê same.'),
    (r:0; t:'Postaæ nasy³a na wroga innych ze swojej dru¿yny.'),
    (r:0; t:'Kursorem myszy mo¿esz przenosiæ postacie, zwierzêta, miny, itd.'),
    (r:0; t:'Wymazuj¹c tylko maskê terenu i zostawiaj¹c rysunek mo¿esz tworzyæ tajne przejœcia.'),
    (r:0; t:'Podwodne miny na linie mog¹ równie¿ na niej wisieæ w powietrzu.'),
    (r:0; t:'Aby postawiæ minê na linie, najpierw zaczep myszk¹ o teren i przeci¹gnij w inne miejsce sam¹ minê.'),
    (r:0; t:'Nie wszystkie bronie dostêpne s¹ od pocz¹tku. Zbieraj punkty i zabijaj by odkrywaæ nowe bronie.'),
    (r:0; t:'Zabici przez si³y natury przynios¹ ci znacznie mniej punktów ni¿ zabici przez ciebie!'),
    (r:0; t:'Nak³adaniem trawy w innych kolorach mo¿esz symulowaæ oœwietlenie terenu w dowolnym kolorze.'),
    (r:0; t:'Jeœli warunki pogodowe zbyt mocno zwalniaj¹ grê, wy³¹cz chmury.'),
    (r:0; t:'Ka¿da z cieczy (woda, kwas, b³oto, itd.) ma swoj¹ gêstoœæ, co widaæ i po ruchu fal i prêdkoœci toniêcia w niej.'),
    (r:0; t:'Piorun lub pr¹d strzelony w wodê mo¿e natychmiast zabiæ w niej wszystkich.'),
    (r:0; t:'Wentylator mo¿e dmuchaæ i wci¹gaæ powietrze (lewy lub prawy klawisz myszy).'),
    (r:0; t:'Gaz wybuchaj¹cy mo¿na rozpyliæ i podpaliæ.'),
    (r:0; t:'Bombê na cia³o nale¿y na³o¿yæ na postaæ (ma³a si³a strza³u, kliknij na samej postaci).'),
    (r:0; t:'Postacie mog¹ wykopaæ daleko od siebie granat, dynamit, czy inn¹ broñ.'),
    (r:0; t:'Postacie uciekaj¹ przed postaci¹ z za³o¿on¹ bomb¹ na cia³o.'),
    (r:0; t:'W dolnym menu mo¿esz ustawiæ w³aœciwoœci ka¿dej dru¿yny: pocz¹tkow¹ broñ, si³ê i sposób pojawiania siê.'),
    (r:0; t:'Mo¿esz ustaliæ, która dru¿yna bêdzie zaprzyjaŸniona z któr¹. Mo¿na te¿ ustaliæ przyjaŸñ jednostronn¹, gdzie jedna dru¿yna zabija drug¹, ale nie odwrotnie.'),
    (r:0; t:'W dolnym menu ustawieñ dru¿yny, klikaj na ikonkach przyjaŸni lewym przyciskiem, by zmieniæ tylko dla wybranej dru¿yny lub prawym, by zmieniæ jednoczeœnie dla obu.'),
    (r:0; t:'Najwiêksza "twardoœæ" terenu jest ca³kowicie niezniszczalna.'),
    (r:0; t:'Rysuj¹c obiekty, prawy klawisz myszy odwraca je lustrzanie w poziomie.'),
    (r:0; t:'Mo¿esz rysowaæ na raz serie po³¹czonych ze sob¹ obiektów. Do zmiany kierunku i rozstrzelenia u¿yj prawego klawisza myszy (jak w celowniku).'),
    (r:0; t:'Celownik obs³uguje siê bardzo ³atwo: z prawym klawiszem myszy przesuwanie myszy na boki zmienia k¹t, a w górê i w dó³ zmienia si³ê.'),
    (r:0; t:'Im bardziej wymyœlne sposoby œmierci, tym wiêcej punktów.'),
    (r:0; t:'Za zabicie z du¿¹ si³¹ dostaniesz premiê punktow¹ (zobaczysz napis MEGAŒMIERÆ).'),
    (r:0; t:'Zabicie kilku postaci na raz to kombo. Im wiêksze kombo, tym wiêcej punktów dostaniesz!'),
    (r:0; t:'W trybie misji klawisz F8 ponownie poka¿e na ekranie cele misji.'),
    (r:0; t:'Klawisz F7 zmienia widok kursora myszy'),
    (r:0; t:'Klawisze F1 i F2 zmieniaj¹ wybran¹ kategoriê broni oraz broñ na nastêpn¹.'),
    (r:0; t:'W czasie pauzy prawie wszystko nadal mo¿na robiæ, tylko czas stoi.'),
    (r:0; t:'Klawisz ` pozwala ukryæ czêœæ lub ca³oœæ dolnego menu.'),
    (r:0; t:'Klawisz TAB zmienia dolne menu na nastêpne.')
  );




implementation

end.

