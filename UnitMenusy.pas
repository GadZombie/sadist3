unit UnitMenusy;

interface
uses types, vars, unitstringi, unit2;

const
iko_num:array[0..max_broni] of word=
              (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58);
var
  menju:record
     kategoria:integer; {wybrana kategoria broni w menu z broniami}
     widoczne:integer; {0-bronie, 1-rysowanie}
     aniklatka:byte; {klatka animacji wybranej broni}

     swiatlo_wybrane,
     swiatlo_ruszane:integer;
  end;


{$IFDEF MENU_UKLADANIE_BRONI}
var
dupa:integer=-1;
dup1,dup2:integer;
{$ENDIF}


    procedure ustaw_menu_widoczne;
    procedure pokaz_menu_tlo;

    procedure sprawdz_kliki_menu_bronie;
    procedure pokaz_menu_bronie; {bronie}

    procedure sprawdz_kliki_menu_rysowanie;
    procedure pokaz_menu_rysowanie; {rysowanie}

    procedure sprawdz_kliki_menu_warunki;
    procedure pokaz_menu_warunki;

    procedure sprawdz_kliki_menu_druzyny;
    procedure pokaz_menu_druzyny;

    procedure sprawdz_kliki_menu_wejscia;
    procedure pokaz_menu_wejscia;

    procedure sprawdz_kliki_menu_boczne;
    procedure pokaz_menu_boczne;

    procedure nowytultip(x_,y_:integer; tx:string; czas_:integer=50);
    procedure pokazuj_tultip;

    procedure nowynapis(x_,y_:integer; tx:string; jaki_:byte=0);
    procedure ruszaj_napis;
    procedure pokazuj_napis;

    procedure nowynapiswrogu(tx:string; czas_:integer);
    procedure pokazuj_napiswrogu;

implementation
uses unit1, PowerInputs, powertypes, PowerDraw3, directinput8, d3d9, pdrawex,
  AGFUnit, unitgraglowna, unitpogoda, unitkolesie, unitwybuchy, unitrysowanie;


procedure ustaw_menu_widoczne;
begin
   case menju.widoczne of
      0,2,3,4:bron.glownytryb:=0;
      1:begin
        if rysowanie.corobi=4 then bron.glownytryb:=6
           else bron.glownytryb:=1;
        end;
   end;
end;

procedure pokaz_menu_tlo;
var tr:trect;
begin
 tr:=rect(0,ekran.height-ekran.menux,ekran.width,ekran.height);
 form1.PowerDraw1.ClipRect:=tr;

 form1.PowerDraw1.TextureMap(obr.menud.surf,
                 pBounds4(0,ekran.height-ekran.menux,obr.menud.rx,obr.menud.ry),
                 cWhite4,
                 tPattern(menju.widoczne),
                 0);

 if ekran.width>obr.menud.rx then begin
    form1.PowerDraw1.TextureMap(obr.menudprawo.surf,
                   pBounds4(obr.menud.rx,ekran.height-ekran.menux,obr.menudprawo.rx,obr.menudprawo.ry),
                   cWhite4,
                   tPattern(0),
                   0);

 end;
end;

procedure sprawdz_kliki_menu_bronie;
const lm=10;
var a,b,d,e:integer; xx:integer;
{$IFDEF MENU_UKLADANIE_BRONI}
wyr:string;
{$ENDIF}
begin
if (mysz.menul) then begin
 a:=0;
 while (a<=high(menubronie[menju.kategoria])) and (menubronie[menju.kategoria,a]<>-1) do begin
     if mysz_w2(lm+5+a*23,ekran.height-ekran.menux+30,20,20) then begin
        bron.wybrana:=menubronie[menju.kategoria,a];
        form1.zmienobrazkiikonbroni;
        for b:=0 to 9 do
            if form1.PowerInput1.Keys[$02+b] then begin
               bron.ulubiona[b]:=menubronie[menju.kategoria,a];
               for e:=0 to 9 do
                   if (e<>b) and (bron.ulubiona[e]=menubronie[menju.kategoria,a]) then bron.ulubiona[e]:=-1;
            end;

{$IFDEF MENU_UKLADANIE_BRONI}
        for b:=0 to 9 do
            if form1.PowerInput1.Keys[16] then begin
               dupa:=menubronie[menju.kategoria,a];
               dup1:=menju.kategoria;
               dup2:=a;
            end;
        for b:=0 to 9 do
            if (dupa>=0) and (form1.PowerInput1.Keys[17]) then begin
               for d:=dup2 to high(menubronie[dup1])-1 do begin
                   menubronie[dup1,d]:=menubronie[dup1,d+1];
               end;
               if menubronie[dup1,high(menubronie[dup1])]<>-1 then
                  menubronie[dup1,high(menubronie[dup1])]:=-1;

               for d:=high(menubronie[menju.kategoria]) downto a+1 do begin
                   menubronie[menju.kategoria,d]:=menubronie[menju.kategoria,d-1];
               end;
               menubronie[menju.kategoria,a]:=dupa;
               dupa:=-1;
            end;

        form2.Memo1.Clear;
        form2.Memo1.Lines.Add('menubronie:array[0..8,0..10] of integer=(');

        for b:=0 to high(menubronie) do begin
            wyr:='(';
            for d:=0 to high(menubronie[b]) do begin
                wyr:=wyr+l2t(menubronie[b,d],2)+',';
            end;
            wyr:=wyr+'),';
            form2.Memo1.Lines.Add(wyr);
        end;
        form2.Memo1.Lines.Add(');');
        form2.Memo1.Lines.SaveToFile('menu.txt');

{$ENDIF}

     end;
     inc(a);
 end;

 a:=0;
 while (a<=high(menubroniekategorie)) and (menubroniekategorie[a]<>-1) do begin
     if mysz_w2(lm+5+a*23,ekran.height-ekran.menux+53,20,20) then
        menju.kategoria:=a;
     inc(a);
 end;

 xx:=lm+50;
 case bron.wybrana of
   4:begin {przedmioty}
     for a:=0 to ile_przedm do begin
         if mysz_w2(xx+a*23,ekran.height-ekran.menux+7,20,20) then
            bronmenuuklad[bron.wybrana][0].wartosc:=a;
     end;
     end;
   9:begin {miesko}
     if mysz_w2(xx,ekran.height-ekran.menux+7,20,20) then begin
        inc(bronmenuuklad[bron.wybrana][2].wartosc);
        if bronmenuuklad[bron.wybrana][2].wartosc>=2 then bronmenuuklad[bron.wybrana][2].wartosc:=0;
        mysz.menustop:=true;
     end;
     d:=23+23;

     for a:=0 to 7 do begin
         if mysz_w2(xx+d+a*23,ekran.height-ekran.menux+7,20,20) then
            bronmenuuklad[bron.wybrana][0].wartosc:=a;
     end;
     d:=d+a*23+23;

     for a:=0 to max_druzyn+1 do begin
         if mysz_w2(xx+d+a*23,ekran.height-ekran.menux+7,20,20) then
            bronmenuuklad[bron.wybrana][1].wartosc:=a;
     end;

     end;
  23,28:begin {ludzie,krew}
     for a:=0 to max_druzyn+1+ord(bron.wybrana=28) do begin
         if mysz_w2(xx+a*23,ekran.height-ekran.menux+7,20,20) then
            bronmenuuklad[bron.wybrana][0].wartosc:=a;
     end;
     end;
  30:begin {smieci}
     if mysz_w2(xx,ekran.height-ekran.menux+7,20,20) then begin
        inc(bronmenuuklad[bron.wybrana][2].wartosc);
        if bronmenuuklad[bron.wybrana][2].wartosc>=2 then bronmenuuklad[bron.wybrana][2].wartosc:=0;
        mysz.menustop:=true;
     end;
     d:=23+23;

     for a:=0 to max_smieci+1 do begin
         if mysz_w2(xx+d+a*23,ekran.height-ekran.menux+7,20,20) then
            bronmenuuklad[bron.wybrana][0].wartosc:=a;
     end;

     end;
  35:begin {zwierzaki}
     for a:=0 to max_rodz_zwierzaki+1 do begin
         if mysz_w2(xx+a*23,ekran.height-ekran.menux+7,20,20) then
            bronmenuuklad[bron.wybrana][0].wartosc:=a;
     end;
     end;
  39:begin {ciezkie}
     for a:=0 to 4 do begin
         if mysz_w2(xx+a*23,ekran.height-ekran.menux+7,20,20) then
            bronmenuuklad[bron.wybrana][0].wartosc:=a;
     end;
     end;
  else begin
     a:=0;
     while (a<=high(bronmenuuklad[bron.wybrana])) and (bronmenuuklad[bron.wybrana][a].typ>=1) do
        with bronmenuuklad[bron.wybrana][a] do begin
           case typ of
              10:begin {puste}
                if offset=0 then inc(xx,23+menu_odstepy_miedzy_suwakami)
                   else inc(xx,offset+menu_odstepy_miedzy_suwakami);
                end;
              1:begin {suwak}
                inc(xx,23);
                if mysz_w2(xx,ekran.height-ekran.menux+7,sz,20) then begin
                   wartosc:=round((mysz.x-xx)/(sz/(mx-mn)))+mn;
                end;
                if offset=0 then inc(xx,sz+menu_odstepy_miedzy_suwakami)
                   else inc(xx,offset+menu_odstepy_miedzy_suwakami);
                end;
              2:begin {przelacznik}
                if mysz_w2(xx,ekran.height-ekran.menux+7,20,20) then begin
                   inc(wartosc);
                   if wartosc>mx then wartosc:=mn;

                   if bron.wybrana in [10,18,19,57] then begin {miny - wszystkie rodzaje}
                      if a=2 then
                         for b:=0 to max_mina do
                             if (mina[b].jest) and (mina[b].zepsuta) then mina[b].jest := false;
                      if a=3 then
                         for b:=0 to max_mina do
                             if (mina[b].jest) and (not mina[b].zepsuta) then begin
                                mina[b].czasdowybuchu := random(4);
                                mina[b].aktywna := true;
                             end;
                   end;

                   mysz.menustop:=true;
                end;
                if offset=0 then inc(xx,20+menu_odstepy_miedzy_suwakami)
                   else inc(xx,offset+menu_odstepy_miedzy_suwakami);
              end;
           end;
           inc(a);
        end;
  end;
 end;

end;

end;


procedure pokaz_menu_bronie;
const lm=10;
var a,b,d:integer; tr,tr2:trect; sz2,xx:integer; c:cardinal; s:string; rpx,rpy:word;
begin
 tr:=rect(0,ekran.height-ekran.menux,ekran.width,ekran.height);
 form1.PowerDraw1.ClipRect:=tr;
{-glowne guziki broni---}
 sz2:=0;
 while (sz2<=high(menubronie[menju.kategoria])) and (menubronie[menju.kategoria,sz2]<>-1) do inc(sz2);

 c:=$A09090b0;

 form1.PowerDraw1.Rectangle(lm+4,ekran.height-ekran.menux+29,sz2*23-1,22, c,c,effectsrcalpha);
 form1.PowerDraw1.Rectangle(lm+5+menju.kategoria*23,ekran.height-ekran.menux+52,22,22, c,c,effectsrcalpha);

 a:=0;
 while (a<=high(menubronie[menju.kategoria])) and (menubronie[menju.kategoria,a]<>-1) do begin
     //if obr.aniikony[menubronie[menju.kategoria,a]].surf<>nil then

        if menubronie[menju.kategoria,a]=bron.wybrana then
           form1.PowerDraw1.TextureMap(obr.aniikony.surf,
             pBounds4(lm+6+a*23,ekran.height-ekran.menux+31,20,20),
             cWhite4,
             tPattern(menju.aniklatka),
             effectSrcAlpha)
        else
           form1.PowerDraw1.TextureMap(obr.aniikonyp.surf,
             pBounds4(lm+6+a*23,ekran.height-ekran.menux+31,20,20),
             cWhite4,
             tPattern(menubronie[menju.kategoria,a]),
             effectSrcAlpha);
        (*if menubronie[menju.kategoria,a]=bron.wybrana then b:=menju.aniklatka else b:=0;
        form1.PowerDraw1.TextureMap(obr.aniikony.surf,
           pBounds4(lm+6+a*23,ekran.height-ekran.menux+31,20,20),
           cWhite4,
           tPattern({menubronie[menju.kategoria,a]*20+}b),
           effectSrcAlpha);*)
     {else
        form1.PowerDraw1.RenderEffect(obr.ikony.surf,lm+6+a*23,
                      ekran.height-ekran.menux+31,384,menubronie[menju.kategoria,a],effectSrcAlpha);
     }
     if menubronie[menju.kategoria,a]=bron.wybrana then begin
        form1.PowerDraw1.RenderEffect(obr.menukratka.surf,lm+4+a*23,ekran.height-ekran.menux+29,0,effectSrcAlpha);
        if mysz_w2(lm+4+a*23,ekran.height-ekran.menux+29,20,20) then
           nowytultip(lm+4+a*23,ekran.height-ekran.menux+18,nazwy_broni[menubronie[menju.kategoria,a]]);
     end else
     if mysz_w2(lm+4+a*23,ekran.height-ekran.menux+29,20,20) then begin
        form1.PowerDraw1.RenderEffectcol(obr.menukratka.surf,lm+4+a*23,ekran.height-ekran.menux+29,$80FFFFFF,0,effectSrcAlpha or effectdiffuse);
        nowytultip(lm+4+a*23,ekran.height-ekran.menux+18,nazwy_broni[menubronie[menju.kategoria,a]]);
     end;

     for b:=0 to 9 do
         if bron.ulubiona[b]=menubronie[menju.kategoria,a] then
            piszdowolne(l2t((b+1) mod 10,1),lm+6+a*23,ekran.height-ekran.menux+31,$90ffffff,9,9);

     if (tryb_misji.wlaczony and (tryb_misji.amunicja[menubronie[menju.kategoria,a]]=0)) or
        (not tryb_misji.wlaczony and not gracz.broniesa[menubronie[menju.kategoria,a]]) then
        form1.PowerDraw1.RenderEffectcol(obr.menukratka.surf,lm+4+a*23,ekran.height-ekran.menux+29,$f0FFFFFF,1,effectSrcAlpha or effectdiffuse);

     inc(a);
 end;

 a:=0;
 while (a<=high(menubroniekategorie)) and (menubroniekategorie[a]<>-1) do begin
     //form1.PowerDraw1.RenderEffect(obr.aniikony.surf,lm+6+a*23,ekran.height-ekran.menux+54,384,menubroniekategorie[a]*20,effectSrcAlpha);
     form1.PowerDraw1.TextureMap(obr.aniikonyp.surf,
           pBounds4(lm+6+a*23,ekran.height-ekran.menux+54,20,20),
           cWhite4,
           tPattern(menubroniekategorie[a]),
           effectSrcAlpha);

     if a=menju.kategoria then
        form1.PowerDraw1.RenderEffect(obr.menukratka.surf,lm+4+a*23,ekran.height-ekran.menux+52,0,effectSrcAlpha)
        else
        if mysz_w2(lm+4+a*23,ekran.height-ekran.menux+52,20,20) then
           form1.PowerDraw1.RenderEffectcol(obr.menukratka.surf,lm+4+a*23,ekran.height-ekran.menux+52,$80FFFFFF,0,effectSrcAlpha or effectdiffuse);

     if mysz_w2(lm+4+a*23,ekran.height-ekran.menux+52,20,20) then
        nowytultip(lm+4+a*23,ekran.height-ekran.menux+41,Menu_bronie_kategorie[a]);
     inc(a);
 end;
 //if sz2<menju.kategoria+1 then sz2:=menju.kategoria+1;

 form1.linia(lm+ 4+menju.kategoria*23, ekran.height-ekran.menux+74,
             lm+26+menju.kategoria*23, ekran.height-ekran.menux+74,
             $FF00FFFF);
 form1.linia(lm+ 3+menju.kategoria*23, ekran.height-ekran.menux+73,
             lm+ 3+menju.kategoria*23, ekran.height-ekran.menux+51,
             $FF00FFFF);
 form1.linia(lm+26+menju.kategoria*23, ekran.height-ekran.menux+73,
             lm+26+menju.kategoria*23, ekran.height-ekran.menux+51,
             $FF00FFFF);

 form1.linia(lm+ 4, ekran.height-ekran.menux+51,
             lm+ 3+menju.kategoria*23, ekran.height-ekran.menux+51,
             $FF00FFFF);
 form1.linia(lm+ 3, ekran.height-ekran.menux+50,
             lm+ 3, ekran.height-ekran.menux+28,
             $FF00FFFF);
 form1.linia(lm+ 4, ekran.height-ekran.menux+28,
             lm+ 3+sz2*23, ekran.height-ekran.menux+28,
             $FF00FFFF);
 form1.linia(lm+ 3+sz2*23, ekran.height-ekran.menux+29,
             lm+ 3+sz2*23, ekran.height-ekran.menux+51,
             $FF00FFFF);
 form1.linia(lm+ 2+sz2*23, ekran.height-ekran.menux+51,
             lm+ 26+menju.kategoria*23, ekran.height-ekran.menux+51,
             $FF00FFFF);


{-wybrana bron i jej ustawienia-}
 form1.PowerDraw1.TextureMap(obr.aniikony.surf,
     pBounds4(552,ekran.height-ekran.menux+33,40,40),
     cWhite4,
     tPattern({iko_num[bron.wybrana]*20+}menju.aniklatka),
     0);

 if tryb_misji.wlaczony then begin
    if (tryb_misji.amunicja[bron.wybrana]=0) then
     form1.PowerDraw1.TextureMap(obr.menukratka.surf,
         pBounds4(550,ekran.height-ekran.menux+34,40,40),
         cColor1($e0ffffff),
         tPattern(1),
         effectSrcAlpha or effectdiffuse)
    else
        if tryb_misji.amunicja[bron.wybrana]>0 then
           pisz(l2t(tryb_misji.amunicja[bron.wybrana],0),550,ekran.height-ekran.menux+31);
 end else
     if (not gracz.broniesa[bron.wybrana]) then
         form1.PowerDraw1.TextureMap(obr.menukratka.surf,
             pBounds4(550,ekran.height-ekran.menux+34,40,40),
             cColor1($e0ffffff),
             tPattern(1),
             effectSrcAlpha or effectdiffuse);

 if (tryb_misji.wlaczony or gracz.broniesa[bron.wybrana]) then //nazwa broni:
    pisz(nazwy_broni[bron.wybrana],538-length(nazwy_broni[bron.wybrana])*9,ekran.height-ekran.menux+59);

 if (tryb_misji.wlaczony and (tryb_misji.amunicja[bron.wybrana]=0)) then //tekst brak amunicji
    piszdowolne(DM_bro_brakamunicji,538,ekran.height-ekran.menux+48,$ff6060ff,8,11,1)
 else //tekst klawisz skrotu: X
 if (not tryb_misji.wlaczony and not gracz.broniesa[bron.wybrana]) then begin//tekst niedostepne
    c:=$FF606000+ ($80+trunc(sin(licznik3*pi180)*$7F));
    piszdowolne(DM_bro_bronniedostepna,538,ekran.height-ekran.menux+48,c,8,11,1);
    s:=DM_bro_bronniedostepna_jeszcze;
    if wymagane_do_broni[bron.wybrana].pkt-gracz.punktyglobalne>0 then
       s:=s+DM_bro_bronniedostepna_pkt+l2tprzec(wymagane_do_broni[bron.wybrana].pkt-gracz.punktyglobalne,0);
    if wymagane_do_broni[bron.wybrana].trup-gracz.trupyglobalne>0 then
       s:=s+DM_bro_bronniedostepna_jeszczetrup+l2tprzec(wymagane_do_broni[bron.wybrana].trup-gracz.trupyglobalne,0);
    if wymagane_do_broni[bron.wybrana].pacz-gracz.paczkiglobalne>0 then
       s:=s+DM_bro_bronniedostepna_jeszczepacz+l2tprzec(wymagane_do_broni[bron.wybrana].pacz-gracz.paczkiglobalne,0);

    piszdowolne(s,538,ekran.height-ekran.menux+59,$FF3050FF,6,11,1)

 end else begin//tekst klawisz skrotu: X
     for b:=0 to 9 do
         if bron.ulubiona[b]=bron.wybrana then begin
            s:=DM_bro_klawiszskrotu+'"'+l2t((b+1) mod 10,1)+'"';
                piszdowolne(s,538-length(s)*8,ekran.height-ekran.menux+48,$ff80ff80,8,11);
         end;
 end;

 xx:=lm+50;
 form1.PowerDraw1.TextureMap(obr.aniikony.surf,
       pBounds4(lm+5,ekran.height-ekran.menux+7,20,20),
       cWhite4,
       tPattern({iko_num[bron.wybrana]*20+}menju.aniklatka),
       effectSrcAlpha);

 if tryb_misji.wlaczony then begin
    if (tryb_misji.amunicja[bron.wybrana]=0) then
       form1.PowerDraw1.RenderEffectcol(obr.menukratka.surf,lm+4,ekran.height-ekran.menux+6,$f0FFFFFF,1,effectSrcAlpha or effectdiffuse)
    else
        if tryb_misji.amunicja[bron.wybrana]>0 then
           pisz(l2t(tryb_misji.amunicja[bron.wybrana],0),lm+24,ekran.height-ekran.menux+7);
 end else
     if (not gracz.broniesa[bron.wybrana]) then
       form1.PowerDraw1.RenderEffectcol(obr.menukratka.surf,lm+4,ekran.height-ekran.menux+6,$f0FFFFFF,1,effectSrcAlpha or effectdiffuse);

 case bron.wybrana of
   4:begin {przedmioty}
     for a:=0 to ile_przedm do begin
         if mysz_w2(xx+a*23,ekran.height-ekran.menux+7,20,20) then begin
            c:=$FFFFFFFF;
            if a>=1 then nowytultip(xx+a*23,ekran.height-ekran.menux-3,nazwy_przedmiotow[a-1]);
         end else
            c:=kolor_przyciemnienia;

         if a<>bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+a*23-1,ekran.height-ekran.menux+6,2,effectSrcAlpha);
         if a=0 then
            form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                 pBounds4(xx+a*23,ekran.height-ekran.menux+7,20,20),
                 ccolor1(c),
                 tPattern(3),
                 effectSrcAlpha or effectDiffuse)
         else
            form1.PowerDraw1.TextureMap(obr.przedm[a-1].surf,
                 pBounds4(xx+a*23+3,ekran.height-ekran.menux+7+4,13,12),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectDiffuse);
         if a=bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+a*23-1,ekran.height-ekran.menux+6,0,effectSrcAlpha);
     end;
     end;
   9:begin {miesko}
     if mysz_w2(xx,ekran.height-ekran.menux+7,20,20) then
         c:=$FFFFFFFF else
         c:=kolor_przyciemnienia;

     form1.PowerDraw1.RenderEffectCol(obr.menuikony.surf,
                       xx,
                       ekran.height-ekran.menux+7,
                       c,
                       24+(bronmenuuklad[bron.wybrana][2].wartosc),
                       effectSrcAlpha or effectdiffuse);

     d:=23+23;

     if bronmenuuklad[bron.wybrana][1].wartosc=0 then b:=0
        else b:=bronmenuuklad[bron.wybrana][1].wartosc-1;
     for a:=0 to 7 do begin
         if mysz_w2(xx+d+a*23,ekran.height-ekran.menux+7,20,20) then
            c:=$FFFFFFFF else
            c:=kolor_przyciemnienia;

         if a<>bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+d+a*23-1,ekran.height-ekran.menux+6,2,effectSrcAlpha);
         if a=0 then
            form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                 pBounds4(xx+d+a*23,ekran.height-ekran.menux+7,20,20),
                 ccolor1(c),
                 tPattern(3),
                 effectSrcAlpha or effectDiffuse)
         else
         if a=7 then
            form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                 pBounds4(xx+d+a*23,ekran.height-ekran.menux+7,20,20),
                 ccolor1(c),
                 tPattern(23),
                 effectSrcAlpha or effectDiffuse)
         else begin
            rpx:=druzyna[b].mieso[a-1].rx;
            rpy:=druzyna[b].mieso[a-1].ry;
            if rpx>20 then rpx:=20;
            if rpy>20 then rpy:=20;
            form1.PowerDraw1.TextureMap(druzyna[b].mieso[a-1].surf,
                 pBounds4(xx+d+a*23+10-rpx shr 1,ekran.height-ekran.menux+7+10-rpy shr 1,rpx,rpy),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectDiffuse);
            end;
         if a=bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+d+a*23-1,ekran.height-ekran.menux+6,0,effectSrcAlpha);
     end;
     d:=d+a*23+23;

     for a:=0 to max_druzyn+1 do begin
         if mysz_w2(xx+d+a*23,ekran.height-ekran.menux+7,20,20) then
            c:=$FFFFFFFF else
            c:=kolor_przyciemnienia;

         if a<>bronmenuuklad[bron.wybrana][1].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+d+a*23-1,ekran.height-ekran.menux+6,2,effectSrcAlpha);
         if a=0 then
            form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                 pBounds4(xx+d+a*23,ekran.height-ekran.menux+7,20,20),
                 ccolor1(c),
                 tPattern(3),
                 effectSrcAlpha or effectDiffuse)
         else begin
             form1.powerdraw1.FillRect(xx+d+a*23,ekran.height-ekran.menux+7,20,20,
                 cardinal($50000000 or druzyna[a-1].kolor_druzyny),
                 effectSrcAlpha or effectDiffuse);
             form1.PowerDraw1.TextureMap(druzyna[a-1].animacje[0].surf,
               pBounds4(xx+d+a*23,ekran.height-ekran.menux+7,20,20),
               ccolor1(c),
               tPattern(0),
               effectSrcAlpha or effectDiffuse);
         end;
         if a=bronmenuuklad[bron.wybrana][1].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+d+a*23-1,ekran.height-ekran.menux+6,0,effectSrcAlpha)
     end;


     end;
  23,28:begin {ludzie,krew}
     for a:=0 to max_druzyn+1+ord(bron.wybrana=28) do begin
         if mysz_w2(xx+a*23,ekran.height-ekran.menux+7,20,20) then
            c:=$FFFFFFFF else
            c:=kolor_przyciemnienia;

         if a<>bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+a*23-1,ekran.height-ekran.menux+6,2,effectSrcAlpha);
         if a=0 then
            form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                 pBounds4(xx+a*23,ekran.height-ekran.menux+7,20,20),
                 ccolor1(c),
                 tPattern(3),
                 effectSrcAlpha or effectDiffuse)
         else
         if a=max_druzyn+2 then begin
            form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                 pBounds4(xx+a*23,ekran.height-ekran.menux+7,20,20),
                 ccolor1(c),
                 tPattern(29),
                 effectSrcAlpha or effectDiffuse);
            if bron.wybrana=28 then
                form1.powerdraw1.TextureMap( obr.syf[0,3].surf,
                   pBounds4(xx+a*23+3,ekran.height-ekran.menux+10,14,14),
                   cColor1(cardinal(((c and $FF000000) or druzyna[-1].kolor_krwi))),
                   tPattern(0),
                   effectSrcAlpha or effectDiffuse);
         end else begin
           form1.powerdraw1.FillRect(xx+a*23,ekran.height-ekran.menux+7,20,20,
                 cardinal($50000000 or druzyna[a-1].kolor_druzyny),
                 effectSrcAlpha or effectDiffuse);
           form1.PowerDraw1.TextureMap(druzyna[a-1].animacje[0].surf,
             pBounds4(xx+a*23,ekran.height-ekran.menux+7,20,20),
             ccolor1(c),
             tPattern(0),
             effectSrcAlpha or effectDiffuse);

            if bron.wybrana=28 then
               form1.powerdraw1.TextureMap( obr.syf[0,3].surf,
                 pBounds4(xx+a*23+3,ekran.height-ekran.menux+10,14,14),
                 cColor1(cardinal(((c and $FF000000) or druzyna[a-1].kolor_krwi))),
                 tPattern(0),
                 effectSrcAlpha or effectDiffuse);
         end;
         if a=bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+a*23-1,ekran.height-ekran.menux+6,0,effectSrcAlpha);
     end;
     end;
  30:begin {smieci}
     if mysz_w2(xx,ekran.height-ekran.menux+7,20,20) then
         c:=$FFFFFFFF else
         c:=kolor_przyciemnienia;

     form1.PowerDraw1.RenderEffectCol(obr.menuikony.surf,
                       xx,
                       ekran.height-ekran.menux+7,
                       c,
                       24+(bronmenuuklad[bron.wybrana][2].wartosc),
                       effectSrcAlpha or effectdiffuse);

     d:=23+23;

     if bronmenuuklad[bron.wybrana][1].wartosc=0 then b:=0
        else b:=bronmenuuklad[bron.wybrana][1].wartosc-1;
     for a:=0 to max_smieci+1 do begin
         if mysz_w2(xx+d+a*23,ekran.height-ekran.menux+7,20,20) then begin
            c:=$FFFFFFFF;
            if a>=1 then nowytultip(xx+d+a*23,ekran.height-ekran.menux-3,nazwy_smieci[a-1]);
         end else
            c:=kolor_przyciemnienia;

         if a<>bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+d+a*23-1,ekran.height-ekran.menux+6,2,effectSrcAlpha);
         if a=0 then
            form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                 pBounds4(xx+d+a*23,ekran.height-ekran.menux+7,20,20),
                 ccolor1(c),
                 tPattern(3),
                 effectSrcAlpha or effectDiffuse)
         else begin
            rpx:=obr.smieci[a-1].rx;
            rpy:=obr.smieci[a-1].ry;
            if rpx>20 then rpx:=20;
            if rpy>20 then rpy:=20;
            form1.PowerDraw1.TextureMap(obr.smieci[a-1].surf,
                 pBounds4(xx+d+a*23+10-rpx shr 1,ekran.height-ekran.menux+7+10-rpy shr 1,rpx,rpy),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectDiffuse);
         end;
         if a=bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+d+a*23-1,ekran.height-ekran.menux+6,0,effectSrcAlpha);
     end;
     end;
  35:begin {zwierzaki}
     for a:=0 to max_rodz_zwierzaki+1 do begin
         if mysz_w2(xx+a*23,ekran.height-ekran.menux+7,20,20) then begin
            c:=$FFFFFFFF;
            if a>=1 then nowytultip(xx+a*23,ekran.height-ekran.menux-3,nazwy_zwierzat[a-1]);
         end else
            c:=kolor_przyciemnienia;

         if a<>bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+a*23-1,ekran.height-ekran.menux+6,2,effectSrcAlpha);
         if a=0 then
            form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                 pBounds4(xx+a*23,ekran.height-ekran.menux+7,20,20),
                 ccolor1(c),
                 tPattern(3),
                 effectSrcAlpha or effectDiffuse)
         else begin
            rpx:=obr.zwierzaki[a-1,0].rx;
            rpy:=obr.zwierzaki[a-1,0].ry;
            if rpx>20 then rpx:=20;
            if rpy>20 then rpy:=20;
            form1.PowerDraw1.TextureMap(obr.zwierzaki[a-1,0].surf,
             pBounds4(xx+a*23+10-rpx shr 1,ekran.height-ekran.menux+7+10-rpy shr 1,rpx,rpy),
             ccolor1(c),
             tPattern(0),
             effectSrcAlpha or effectDiffuse);
         end;
         if a=bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+a*23-1,ekran.height-ekran.menux+6,0,effectSrcAlpha);
     end;
     end;
   39:begin {ciezkie}
     for a:=0 to 4 do begin
         if mysz_w2(xx+a*23,ekran.height-ekran.menux+7,20,20) then begin
            c:=$FFFFFFFF;
            if a>=1 then nowytultip(xx+a*23,ekran.height-ekran.menux-3,nazwy_ciezkich[a-1]);
         end else
            c:=kolor_przyciemnienia;

         if a<>bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+a*23-1,ekran.height-ekran.menux+6,2,effectSrcAlpha);
         if a=0 then
            form1.PowerDraw1.TextureMap(obr.menuikony.surf,
                 pBounds4(xx+a*23,ekran.height-ekran.menux+7,20,20),
                 ccolor1(c),
                 tPattern(3),
                 effectSrcAlpha or effectDiffuse)
         else
            form1.PowerDraw1.TextureMap(obr.ciezkie[a-1].surf,
                 pBounds4(xx+a*23,ekran.height-ekran.menux+7,20,20),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectDiffuse);
         if a=bronmenuuklad[bron.wybrana][0].wartosc then
            form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+a*23-1,ekran.height-ekran.menux+6,0,effectSrcAlpha);
     end;
     end;
  else begin
     a:=0;
     while (a<=high(bronmenuuklad[bron.wybrana])) and (bronmenuuklad[bron.wybrana][a].typ>=1) do
        with bronmenuuklad[bron.wybrana][a] do begin
           case typ of
              10:begin {puste}
                if offset=0 then inc(xx,23+menu_odstepy_miedzy_suwakami)
                   else inc(xx,offset+menu_odstepy_miedzy_suwakami);
                end;
              1:begin {suwak}
                inc(xx,23);
                if mysz_w2(xx,ekran.height-ekran.menux+7,sz,20) then begin
                   c:=$FFFFFFFF;
                   if tt<>'' then s:=tt+': ' else s:='';
                   nowytultip(xx,ekran.height-ekran.menux-3,s+l2t(wartosc,0));
                end else
                   c:=kolor_przyciemnienia;

                b:=trunc((wartosc-mn)*sz/(mx-mn));

                if wartosc<mx then begin
                   tr2:=rect(xx+b+1,ekran.height-ekran.menux+7,xx+150,ekran.height-ekran.menux+30);
                   form1.PowerDraw1.ClipRect:=tr2;
                   form1.PowerDraw1.TextureMap(obr.menusuwaktlo.surf,
                     pBounds4(xx,ekran.height-ekran.menux+7,sz,20),
                     ccolor1(c),
                     tPattern(0),
                     effectSrcAlpha or effectdiffuse);
                end;

                tr2:=rect(xx,ekran.height-ekran.menux+7,xx+b,ekran.height-ekran.menux+30);
                form1.PowerDraw1.ClipRect:=tr2;

                form1.PowerDraw1.TextureMap(obr.menusuwakwyp.surf,
                     pBounds4(xx,ekran.height-ekran.menux+7,sz,20),
                     ccolor1(c),
                     tPattern(0),
                     effectSrcAlpha or effectdiffuse);
                form1.PowerDraw1.ClipRect:=tr;

                form1.drawsprajt(obr.menusuwak,
                                 xx-obr.menusuwak.ofsx +b,
                                 ekran.height-ekran.menux+7,
                                 0);

                if ikona>=1 then
                   form1.PowerDraw1.RenderEffectCol(obr.menuikony.surf,
                                 xx-24,
                                 ekran.height-ekran.menux+7,
                                 c,
                                 ikona-1,
                                 effectSrcAlpha or effectdiffuse);

                if offset=0 then inc(xx,sz+menu_odstepy_miedzy_suwakami)
                   else inc(xx,offset+menu_odstepy_miedzy_suwakami);
              end;
              2:begin {przelacznik}
                if mysz_w2(xx,ekran.height-ekran.menux+7,20,20) then begin
                   c:=$FFFFFFFF;
                   if tt<>'' then nowytultip(xx,ekran.height-ekran.menux-3,tt);
                end else
                   c:=kolor_przyciemnienia;

                form1.PowerDraw1.RenderEffectCol(obr.menuikony.surf,
                                 xx,
                                 ekran.height-ekran.menux+7,
                                 c,
                                 ikona-1+(wartosc),
                                 effectSrcAlpha or effectdiffuse);

                if offset=0 then inc(xx,20+menu_odstepy_miedzy_suwakami)
                   else inc(xx,offset+menu_odstepy_miedzy_suwakami);
              end;
           end;
           inc(a);
        end;
     if bron.wybrana in [10,18,19,57] then begin {miny - wszystkie rodzaje}
        piszdowolne(l2t(ile_min,0)+'/'+l2t(max_mina,0),lm+50,ekran.height-ekran.menux+12,$FFFFFFFF,10,10);
     end;
  end;
 end;

end;



procedure sprawdz_kliki_menu_rysowanie;
var a:integer; xx,xxp,yy:integer; poprawswiatlo:boolean;
begin
if (rysowanie.corobi=4) and (ile_swiatel>=1) and
   (menju.swiatlo_wybrane>=0) and (menju.swiatlo_wybrane<=ile_swiatel) then begin
   rysmenuuklad[4][1].wartosc:=(swiatla[menju.swiatlo_wybrane].kolor and $FF000000) shr 24;
   rysmenuuklad[4][7].wartosc:=(swiatla[menju.swiatlo_wybrane].kolor and $FF0000) shr 16;
   rysmenuuklad[4][4].wartosc:=(swiatla[menju.swiatlo_wybrane].kolor and $FF00) shr 8;
   rysmenuuklad[4][0].wartosc:=(swiatla[menju.swiatlo_wybrane].kolor and $FF) ;
   rysmenuuklad[4][5].wartosc:=swiatla[menju.swiatlo_wybrane].kat;
   rysmenuuklad[4][6].wartosc:=swiatla[menju.swiatlo_wybrane].typ;
   rysmenuuklad[4][8].wartosc:=swiatla[menju.swiatlo_wybrane].wielkosc;
   rysmenuuklad[4][9].wartosc:=swiatla[menju.swiatlo_wybrane].efekt;
   rysmenuuklad[4][10].wartosc:=ord(swiatla[menju.swiatlo_wybrane].zniszczalne);
   rysmenuuklad[4][11].wartosc:=ord(swiatla[menju.swiatlo_wybrane].ztylu);
end;

//klawisze
if (form1.PowerInput1.KeyPressed[klawisze[25]]) then begin //poprzednia textura/obiekt
   if (rysowanie.corobi in [1,2]) then begin
      dec(rysmenuuklad[rysowanie.corobi][3].wartosc);
      if rysmenuuklad[rysowanie.corobi][3].wartosc<rysmenuuklad[rysowanie.corobi][3].mn then rysmenuuklad[rysowanie.corobi][3].wartosc:=rysmenuuklad[rysowanie.corobi][3].mx;

      rysmenuuklad[rysowanie.corobi][4].wartosc:=rysmenuuklad[rysowanie.corobi][3].wartosc;

      if rysowanie.corobi=1 then form1.wczytajteksture(listyplikow[1][rysmenuuklad[rysowanie.corobi][3].wartosc]);
      if rysowanie.corobi=2 then form1.wczytajobiekt(listyplikow[0][rysmenuuklad[rysowanie.corobi][3].wartosc]);

   end;
end;

if (form1.PowerInput1.KeyPressed[klawisze[26]]) then begin //nastepna textura/obiekt
   if (rysowanie.corobi in [1,2]) then begin
      inc(rysmenuuklad[rysowanie.corobi][3].wartosc);
      if rysmenuuklad[rysowanie.corobi][3].wartosc>rysmenuuklad[rysowanie.corobi][3].mx then rysmenuuklad[rysowanie.corobi][3].wartosc:=rysmenuuklad[rysowanie.corobi][3].mn;

      rysmenuuklad[rysowanie.corobi][4].wartosc:=rysmenuuklad[rysowanie.corobi][3].wartosc;

      if rysowanie.corobi=1 then form1.wczytajteksture(listyplikow[1][rysmenuuklad[rysowanie.corobi][3].wartosc]);
      if rysowanie.corobi=2 then form1.wczytajobiekt(listyplikow[0][rysmenuuklad[rysowanie.corobi][3].wartosc]);

   end;
end;

if (form1.PowerInput1.Keys[klawisze[27]]) then begin //zmniejsz pedzel
   if (rysowanie.corobi in [0..1]) then begin
      dec(rysowanie.rozmiar);
      if rysowanie.rozmiar<rysmenuuklad[rysowanie.corobi][2].mn then rysowanie.rozmiar:=rysmenuuklad[rysowanie.corobi][2].mn;
      rysmenuuklad[rysowanie.corobi][2].wartosc:=rysowanie.rozmiar;
   end else
   if (rysowanie.corobi =2) then begin
      dec(rysowanie.dlugosc);
      if rysowanie.dlugosc<rysmenuuklad[rysowanie.corobi][2].mn then rysowanie.dlugosc:=rysmenuuklad[rysowanie.corobi][2].mn;
      rysmenuuklad[rysowanie.corobi][2].wartosc:=rysowanie.dlugosc;
   end;
end;
if (form1.PowerInput1.Keys[klawisze[28]]) then begin //zwieksz pedzel
   if (rysowanie.corobi in [0..1]) then begin
      inc(rysowanie.rozmiar);
      if rysowanie.rozmiar>rysmenuuklad[rysowanie.corobi][2].mx then rysowanie.rozmiar:=rysmenuuklad[rysowanie.corobi][2].mx;
      rysmenuuklad[rysowanie.corobi][2].wartosc:=rysowanie.rozmiar;
   end else
   if (rysowanie.corobi =2) then begin
      inc(rysowanie.dlugosc);
      if rysowanie.dlugosc>rysmenuuklad[rysowanie.corobi][2].mx then rysowanie.dlugosc:=rysmenuuklad[rysowanie.corobi][2].mx;
      rysmenuuklad[rysowanie.corobi][2].wartosc:=rysowanie.dlugosc;
   end;
end;

if (form1.PowerInput1.KeyPressed[klawisze[29]]) then begin //rysuj maskê/teren
   if (rysowanie.corobi in [0..2]) then begin
      rysowanie.pokaz_maske:=not rysowanie.pokaz_maske;

      rysmenuuklad[0][8].wartosc:=ord(rysowanie.pokaz_maske);
      rysmenuuklad[1][8].wartosc:=ord(rysowanie.pokaz_maske);
      rysmenuuklad[2][9].wartosc:=ord(rysowanie.pokaz_maske);
   end;
end;

if (form1.PowerInput1.KeyPressed[klawisze[30]]) then begin //pokaz maskê/teren
   if (rysowanie.corobi in [0..2]) then begin
      inc(rysowanie.maskowanie);
      if rysowanie.maskowanie>=3 then rysowanie.maskowanie:=0;

      rysmenuuklad[0][7].wartosc:=rysowanie.maskowanie;
      rysmenuuklad[1][7].wartosc:=rysowanie.maskowanie;
      rysmenuuklad[2][8].wartosc:=rysowanie.maskowanie;
   end;
end;

//kliki myszki:
if (mysz.menul) then begin
 xxp:=98;
 xx:=xxp;
 yy:=ekran.height-ekran.menux+7;
 poprawswiatlo:=true;

 a:=0;
 while (a<=high(rysmenuuklad[rysowanie.corobi])) do
    with rysmenuuklad[rysowanie.corobi][a] do begin
       if nl then begin
          xx:=xxp;
          inc(yy,23);
       end;
       case typ of
          0:{nic}
            inc(xx,150+menu_odstepy_miedzy_suwakami);
          1:begin {suwak}
            if mysz_w2(xx,yy,sz,20) then begin
               wartosc:=round((mysz.x-xx)/(sz/(mx-mn)))+mn;
            end;
            if offset=0 then inc(xx,sz+menu_odstepy_miedzy_suwakami)
               else inc(xx,offset+menu_odstepy_miedzy_suwakami);
            end;
          2:begin {przelacznik}
            if mysz_w2(xx,yy,20,20) then begin
               if (rysowanie.corobi in [1,2]) and (a=3) then begin
                  dec(wartosc);
                  if wartosc<mn then wartosc:=mx;
               end else begin
                   inc(wartosc);
                   if wartosc>mx then wartosc:=mn;
               end;
               mysz.menustop:=true;
            end;

            if (rysowanie.corobi in [1,2]) and (a=3) then rysmenuuklad[rysowanie.corobi][4].wartosc:=rysmenuuklad[rysowanie.corobi][3].wartosc
               else
            if (rysowanie.corobi in [1,2]) and (a=4) then rysmenuuklad[rysowanie.corobi][3].wartosc:=rysmenuuklad[rysowanie.corobi][4].wartosc;

            if (mysz_w2(xx,yy,20,20)) and (rysowanie.corobi in [1,2]) and (a in [3,4]) then begin
               rysmenuuklad[rysowanie.corobi][3].wartosc:=rysmenuuklad[rysowanie.corobi][4].wartosc;
               if rysowanie.corobi=1 then form1.wczytajteksture(listyplikow[1][rysmenuuklad[rysowanie.corobi][3].wartosc]);
               if rysowanie.corobi=2 then form1.wczytajobiekt(listyplikow[0][rysmenuuklad[rysowanie.corobi][3].wartosc]);
            end;

            if (rysowanie.corobi=4) and (mysz_w2(xx,yy,20,20)) then begin
               case a of
                  2:bron.glownytryb:=4;
                  3:if menju.swiatlo_wybrane>=0 then begin
                       usun_swiatlo(menju.swiatlo_wybrane);
                       poprawswiatlo:=false;
                    end;
               end;
            end;

            if offset=0 then inc(xx,150+menu_odstepy_miedzy_suwakami)
               else inc(xx,offset+menu_odstepy_miedzy_suwakami);
          end;
       end;
       inc(a);
    end;

 case rysowanie.corobi of
  0:begin
    rysowanie.kolor:= $FF000000 or
                   (byte(rysmenuuklad[0][0].wartosc) shl 16) or
                   (byte(rysmenuuklad[0][3].wartosc) shl 8) or
                   byte(rysmenuuklad[0][6].wartosc);
    rysowanie.twardosc:=rysmenuuklad[0][1].wartosc; rysmenuuklad[1][1].wartosc:=rysmenuuklad[0][1].wartosc; rysmenuuklad[2][1].wartosc:=rysmenuuklad[0][1].wartosc;
    rysowanie.rozmiar:=rysmenuuklad[0][2].wartosc; rysmenuuklad[1][2].wartosc:=rysmenuuklad[0][2].wartosc;
    rysowanie.ziarna:=rysmenuuklad[0][4].wartosc;
    rysowanie.ksztaltpedzla:=rysmenuuklad[0][5].wartosc; rysmenuuklad[1][5].wartosc:=rysmenuuklad[0][5].wartosc;
    rysowanie.ztylu:=boolean(rysmenuuklad[0][9].wartosc); rysmenuuklad[1][9].wartosc:=rysmenuuklad[0][9].wartosc; rysmenuuklad[2][10].wartosc:=rysmenuuklad[0][9].wartosc;
    rysowanie.maskowanie:=rysmenuuklad[0][7].wartosc; rysmenuuklad[1][7].wartosc:=rysmenuuklad[0][7].wartosc; rysmenuuklad[2][8].wartosc:=rysmenuuklad[0][7].wartosc;
    rysowanie.pokaz_maske:=boolean(rysmenuuklad[0][8].wartosc); rysmenuuklad[1][8].wartosc:=rysmenuuklad[0][8].wartosc; rysmenuuklad[2][9].wartosc:=rysmenuuklad[0][8].wartosc;
    end;
  1:begin
    rysowanie.twardosc:=rysmenuuklad[1][1].wartosc; rysmenuuklad[0][1].wartosc:=rysmenuuklad[1][1].wartosc; rysmenuuklad[2][1].wartosc:=rysmenuuklad[1][1].wartosc;
    rysowanie.rozmiar:=rysmenuuklad[1][2].wartosc; rysmenuuklad[0][2].wartosc:=rysmenuuklad[1][2].wartosc;
    rysowanie.ksztaltpedzla:=rysmenuuklad[1][5].wartosc; rysmenuuklad[0][5].wartosc:=rysmenuuklad[1][5].wartosc;
    rysowanie.ztylu:=boolean(rysmenuuklad[1][9].wartosc); rysmenuuklad[0][9].wartosc:=rysmenuuklad[1][9].wartosc; rysmenuuklad[2][10].wartosc:=rysmenuuklad[1][9].wartosc;
    rysowanie.maskowanie:=rysmenuuklad[1][7].wartosc; rysmenuuklad[0][7].wartosc:=rysmenuuklad[1][7].wartosc; rysmenuuklad[2][8].wartosc:=rysmenuuklad[1][7].wartosc;
    rysowanie.pokaz_maske:=boolean(rysmenuuklad[1][8].wartosc); rysmenuuklad[0][8].wartosc:=rysmenuuklad[1][8].wartosc; rysmenuuklad[2][9].wartosc:=rysmenuuklad[1][8].wartosc;
    end;
  2:begin
    rysowanie.twardosc:=rysmenuuklad[2][1].wartosc; rysmenuuklad[0][1].wartosc:=rysmenuuklad[2][1].wartosc; rysmenuuklad[1][1].wartosc:=rysmenuuklad[2][1].wartosc;
    rysowanie.dlugosc:=rysmenuuklad[2][2].wartosc;
    rysowanie.odleglosci:=rysmenuuklad[2][5].wartosc;
    rysowanie.kat:=rysmenuuklad[2][6].wartosc;
    rysowanie.ztylu:=boolean(rysmenuuklad[2][10].wartosc); rysmenuuklad[0][9].wartosc:=rysmenuuklad[2][10].wartosc; rysmenuuklad[1][9].wartosc:=rysmenuuklad[2][10].wartosc;
    rysowanie.maskowanie:=rysmenuuklad[2][8].wartosc; rysmenuuklad[1][7].wartosc:=rysmenuuklad[2][8].wartosc; rysmenuuklad[0][7].wartosc:=rysmenuuklad[2][8].wartosc;
    rysowanie.pokaz_maske:=boolean(rysmenuuklad[2][9].wartosc); rysmenuuklad[1][8].wartosc:=rysmenuuklad[2][9].wartosc; rysmenuuklad[0][8].wartosc:=rysmenuuklad[2][9].wartosc;
    end;
  3:begin
    rysowanie.cien.kolorg:= $FF000000 or
                            (byte(rysmenuuklad[3][0].wartosc) shl 16) or
                            (byte(rysmenuuklad[3][3].wartosc) shl 8) or
                             byte(rysmenuuklad[3][6].wartosc);
    rysowanie.cien.kolord:= $FF000000 or
                            (byte(rysmenuuklad[3][1].wartosc) shl 16) or
                            (byte(rysmenuuklad[3][4].wartosc) shl 8) or
                             byte(rysmenuuklad[3][7].wartosc);
    rysowanie.cien.efg:=rysmenuuklad[3][2].wartosc;
    rysowanie.cien.efd:=rysmenuuklad[3][5].wartosc;
    end;
  4:begin
    if (poprawswiatlo) and
       (menju.swiatlo_wybrane>=0) and (menju.swiatlo_wybrane<=ile_swiatel) then begin
       swiatla[menju.swiatlo_wybrane].kolor:=cardinal(
                   (rysmenuuklad[4][1].wartosc shl 24) or
                   (rysmenuuklad[4][7].wartosc shl 16) or
                   (rysmenuuklad[4][4].wartosc shl 8) or
                   rysmenuuklad[4][0].wartosc);
       swiatla[menju.swiatlo_wybrane].typ:=rysmenuuklad[4][6].wartosc;
       swiatla[menju.swiatlo_wybrane].wielkosc:=rysmenuuklad[4][8].wartosc;
       swiatla[menju.swiatlo_wybrane].kat:=rysmenuuklad[4][5].wartosc;
       swiatla[menju.swiatlo_wybrane].efekt:=rysmenuuklad[4][9].wartosc;
       swiatla[menju.swiatlo_wybrane].zniszczalne:=boolean(rysmenuuklad[4][10].wartosc);
       swiatla[menju.swiatlo_wybrane].ztylu:=boolean(rysmenuuklad[4][11].wartosc);
    end;
    end;
 end;
end;

xx:=560;
yy:=ekran.height-ekran.menux+1;
if mysz.menul and (mysz_w2(xx,yy,40,75)) then begin
   a:=0;
   while (a<=4) do begin
      if mysz_w2(xx,yy,40,15) then begin
         rysowanie.corobi:=a;
         if rysowanie.corobi=4 then bron.glownytryb:=6
            else bron.glownytryb:=1;
      end;
      inc(yy,15);
      inc(a);
   end;
   ustaw_menu_widoczne;
end;


end;


procedure pokaz_menu_rysowanie;
var a,b:integer; tr,tr2:trect; sz2,xx,xxp,yy:integer; c:cardinal; s:string;
begin
 tr:=rect(0,ekran.height-ekran.menux,ekran.width,ekran.height);
 form1.PowerDraw1.ClipRect:=tr;

{-wyciecie kwadracika podgladu-}
 if rysowanie.corobi=0 then begin
    b:=ekran.height-ekran.menux+75;
    if b>ekran.height then b:=ekran.height;
    tr2:=rect(2,ekran.height-ekran.menux+2,70,b)
 end else begin
     b:=ekran.height-ekran.menux+73;
     if b>ekran.height then b:=ekran.height;
     tr2:=rect(3,ekran.height-ekran.menux+3,68,b);
 end;
 form1.PowerDraw1.ClipRect:=tr2;
{-wewnatrz kwadracika podgladu-}
 case rysowanie.corobi of
    0:begin
      form1.PowerDraw1.Rectangle(tr2,$0,cardinal($FF000000 or
                                    (rysowanie.kolor and $000000FF) shl 16 or
                                    (rysowanie.kolor and $0000FF00) or
                                    (rysowanie.kolor and $00FF0000) shr 16),
                                    0);
      end;
    1:begin
      form1.drawsprajt(obr.teksturapok,tr2.left,tr2.top,0)
      end;
    2:begin
      form1.PowerDraw1.Rectangle(tr2,$0,$ff000000,0);
      form1.PowerDraw1.TextureMap(obr.obiektpok.surf,
         pBounds4(36-obr.obiektpok.ofsx,ekran.height-ekran.menux+39-obr.obiektpok.ofsy,obr.obiektpok.rx,obr.obiektpok.ry),
         cWhite4,
         tPattern(0),
         effectSrcAlpha)
      end;
    3:begin
      case rysowanie.cien.efg of
        1:form1.PowerDraw1.Rectangle(rect(tr2.Left,tr2.Top,tr2.Right,(tr2.Bottom-tr2.Top) div 2+tr2.Top+1),
                                    $0,cardinal($FF000000 or
                                    (rysowanie.cien.kolorg and $000000FF) shl 16 or
                                    (rysowanie.cien.kolorg and $0000FF00) or
                                    (rysowanie.cien.kolorg and $00FF0000) shr 16),
                                    0);
        2:form1.PowerDraw1.TextureMap(obr.ryscien.surf,
                         pBounds4(tr2.Left,tr2.Top,tr2.Right-tr2.Left,(tr2.Bottom-tr2.Top) div 2+1),
                         ccolor1($FF000000),
                         tPattern(0),
                         effectSrcAlpha or effectdiffuse);
        3:form1.PowerDraw1.TextureMap(obr.ryscien.surf,
                         pBounds4(tr2.Left,tr2.Top,tr2.Right-tr2.Left,(tr2.Bottom-tr2.Top) div 2+1),
                         ccolor1($FFFFFFFF),
                         tPattern(0),
                         effectSrcAlpha or effectdiffuse);
      end;

      case rysowanie.cien.efd of
        1:form1.PowerDraw1.Rectangle(rect(tr2.Left,(tr2.Bottom-tr2.Top) div 2+tr2.Top,tr2.Right,tr2.Bottom),
                                    $0,cardinal($FF000000 or
                                    (rysowanie.cien.kolord and $000000FF) shl 16 or
                                    (rysowanie.cien.kolord and $0000FF00) or
                                    (rysowanie.cien.kolord and $00FF0000) shr 16),
                                    0);
        2:form1.PowerDraw1.TextureMap(obr.ryscien.surf,
                         pBounds4(tr2.Left,tr2.Bottom,tr2.Right-tr2.Left,-(tr2.Bottom-tr2.Top) div 2),
                         ccolor1($FF000000),
                         tPattern(0),
                         effectSrcAlpha or effectdiffuse);
        3:form1.PowerDraw1.TextureMap(obr.ryscien.surf,
                         pBounds4(tr2.Left,tr2.Bottom,tr2.Right-tr2.Left,-(tr2.Bottom-tr2.Top) div 2),
                         ccolor1($FFFFFFFF),
                         tPattern(0),
                         effectSrcAlpha or effectdiffuse);
      end;
      end;
 end;

// form1.PowerDraw1.FrameRect(tr2,$FFa0a0a0,0);

{-suwaki i ustawienia----------}
 form1.PowerDraw1.ClipRect:=tr;

 case rysowanie.corobi of
    1:begin
      s:=listyplikow[1][rysmenuuklad[1][3].wartosc];
      a:=27;
      if length(s)>a then begin
         delete(s,10,length(s)-a+3);
         insert('...',s,10);
      end;
      piszwaskie(s,85,ekran.height-ekran.menux+13);

      pisz(l2t(rysmenuuklad[1][3].wartosc+1,0)+'/'+l2t(rysmenuuklad[1][3].mx+1,0),128,ekran.height-ekran.menux+36);
      end;
    2:begin
      s:=listyplikow[0][rysmenuuklad[2][3].wartosc];
      a:=27;
      if length(s)>a then begin
         delete(s,10,length(s)-a+3);
         insert('...',s,10);
      end;
      piszwaskie(s,85,ekran.height-ekran.menux+13);
      pisz(l2t(rysmenuuklad[2][3].wartosc+1,0)+'/'+l2t(rysmenuuklad[2][3].mx+1,0),128,ekran.height-ekran.menux+36);
      end;
 end;

 xxp:=98;
 xx:=xxp;
 yy:=ekran.height-ekran.menux+7;

 a:=0;
 while (a<=high(rysmenuuklad[rysowanie.corobi])) do
    with rysmenuuklad[rysowanie.corobi][a] do begin
       if nl then begin
          xx:=xxp;
          inc(yy,23);
       end;
       case typ of
          0:{nic}
            inc(xx,150+menu_odstepy_miedzy_suwakami);
          1:begin {suwak}
            if mysz_w2(xx,yy,sz,20) then begin
               c:=$FFFFFFFF;
               if tt<>'' then s:=tt+': ' else s:='';
               nowytultip(xx,yy-10,s+l2t(wartosc,0));
            end else
               c:=kolor_przyciemnienia;

            if (mx-mn)=0 then b:=0 else
               b:=integer(trunc((wartosc-mn)*sz/(mx-mn)));

            if wartosc<mx then begin
               tr2:=rect(xx+b+1,yy,xx+sz,yy+19);
               form1.PowerDraw1.ClipRect:=tr2;
               form1.PowerDraw1.TextureMap(obr.menusuwaktlo.surf,
                 pBounds4(xx,yy,sz,20),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectdiffuse);
            end;

            tr2:=rect(xx,yy,xx+b,yy+19);
            form1.PowerDraw1.ClipRect:=tr2;

            form1.PowerDraw1.TextureMap(obr.menusuwakwyp.surf,
                 pBounds4(xx,yy,sz,20),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectdiffuse);
            form1.PowerDraw1.ClipRect:=tr;

            form1.drawsprajt(obr.menusuwak,
                             xx-obr.menusuwak.ofsx +b,
                             yy,
                             0);

            if ikona>=1 then
               form1.PowerDraw1.RenderEffectCol(obr.menuikony.surf,
                             xx-24,
                             yy,
                             c,
                             ikona-1,
                             effectSrcAlpha or effectdiffuse);

            if offset=0 then inc(xx,sz+menu_odstepy_miedzy_suwakami)
               else inc(xx,offset+menu_odstepy_miedzy_suwakami);
          end;
          2:begin {przelacznik}
            if mysz_w2(xx,yy,20,20) then begin
               c:=$FFFFFFFF;
               if tt<>'' then s:=tt+': ' else s:='';
               nowytultip(xx,yy-10,s+l2t(wartosc,0));
            end else
               c:=kolor_przyciemnienia;

            if (rysowanie.corobi in [1,2]) and (a in [3,4]) then b:=ikona
               else b:=ikona-1+(wartosc);

            form1.PowerDraw1.RenderEffectCol(obr.menuikony.surf,
                             xx,
                             yy,
                             c,
                             b,
                             effectSrcAlpha or effectdiffuse);

            if offset=0 then inc(xx,150+menu_odstepy_miedzy_suwakami)
               else inc(xx,offset+menu_odstepy_miedzy_suwakami);
          end;
       end;
       inc(a);
    end;

{boczne}
 xx:=560;
 yy:=ekran.height-ekran.menux+1;
 a:=0;
 while (a<=4) do begin
    if rysowanie.corobi<>a then c:=$909090
                           else c:=$E0FFFFFF;
    if mysz_w2(xx,yy,40,15) then begin
       nowytultip(xx,yy-11,Menu_boczne_rysowanie_nazwy[a]);
       c:=c or $FF000000;
       //if tt<>'' then nowytultip(xx,yy-10,tt);
    end else
       c:=c or $b0000000;

    form1.PowerDraw1.RenderEffectCol(obr.ikowybmenu.surf,
                     xx,
                     yy,
                     c,
                     5+a,
                     effectSrcAlpha or effectdiffuse);

    inc(yy,15);
    inc(a);
 end;


end;

procedure sprawdz_kliki_menu_warunki;
var a,b:integer; xx,xxp,yy:integer;
begin
warmenuuklad[1].wartosc:=ord(warunki.wiatr>=0);
warmenuuklad[2].wartosc:=round(abs(warunki.wiatr*200));
warmenuuklad[3].wartosc:=ord(warunki.chmurki);
warmenuuklad[4].wartosc:=warunki.jakiechmury;
warmenuuklad[5].wartosc:=warunki.iloscchmur;
warmenuuklad[6].wartosc:=ord(warunki.burza);
warmenuuklad[7].wartosc:=505-warunki.silaburzy;
warmenuuklad[8].wartosc:=ord(warunki.deszcz);
warmenuuklad[9].wartosc:=ord(warunki.snieg);

warmenuuklad[10].wartosc:=ord(warunki.typ_wody=0);
warmenuuklad[11].wartosc:=ord(warunki.typ_wody=1);
warmenuuklad[12].wartosc:=ord(warunki.typ_wody=2);
warmenuuklad[13].wartosc:=ord(warunki.typ_wody=3);
warmenuuklad[14].wartosc:=ord(warunki.typ_wody=4);
warmenuuklad[15].wartosc:=ord(warunki.typ_wody=5);
warmenuuklad[16].wartosc:=warunki.gleb_wody;
warmenuuklad[17].wartosc:=warunki.godzina;
warmenuuklad[18].wartosc:=ord(warunki.pauza);

warmenuuklad[19].wartosc:=warunki.agresja;
warmenuuklad[20].wartosc:=ord(warunki.walka_bez_powodu);
warmenuuklad[21].wartosc:=ord(warunki.walka_ze_swoimi);
warmenuuklad[22].wartosc:=ord(warunki.zwierzeta_same);
warmenuuklad[23].wartosc:=trunc(warunki.grawitacja*100);
warmenuuklad[24].wartosc:=ord(kfg.pokazuj_info);
warmenuuklad[25].wartosc:=ord(kfg.wskazniki_kolesi);
warmenuuklad[26].wartosc:=ord(kfg.jest_dzwiek);
warmenuuklad[27].wartosc:=ord(kfg.jest_muzyka);

if (mysz.menul) then begin
 xxp:=50;
 yy:=ekran.height-ekran.menux+7;
 a:=0;
 xx:=xxp;
 while (a<=high(warmenuuklad)) do
    with warmenuuklad[a] do begin
       if nl then begin
          xx:=xxp;
          inc(yy,23);
       end;
       case typ of
          1:begin {suwak}
            if ikona>=1 then inc(xx,23);

            if mysz_w2(xx,yy,sz,20) then begin
               wartosc:=round((mysz.x-xx)/(sz/(mx-mn)))+mn;
               if a=17 then licznik2:=0; //poprawienie czasu przy zmianie godziny (zeby kolory tla poprawilo od razu)
            end;

            if offset=0 then inc(xx,sz+3)
                        else inc(xx,sz+offset);
          end;
          2,3:begin {przelacznik}
            if mysz_w2(xx,yy,20,20) then begin
               if a in [10..15] then
                  for b:=10 to 15 do warmenuuklad[b].wartosc:=0;
               inc(wartosc);
               if wartosc>mx then wartosc:=mn;
               mysz.menustop:=true;
            end;
            if offset=0 then inc(xx,23)
                        else inc(xx,offset);
          end;
          4:begin {ikona}
            if offset=0 then inc(xx,23)
                        else inc(xx,offset);
          end;
       end;
       inc(a);
    end;

  //ponizsze opcje mozna zmieniac tylko poza trybem misji
  if not (tryb_misji.wlaczony and not tryb_misji.zmianawarunkow) then begin
      warunki.wiatr:=warmenuuklad[2].wartosc/200;
      if warmenuuklad[1].wartosc=0 then warunki.wiatr:=-abs(warunki.wiatr)
                                   else warunki.wiatr:=abs(warunki.wiatr);
      warunki.jakiechmury:=warmenuuklad[4].wartosc;
      warunki.iloscchmur:=warmenuuklad[5].wartosc;
      warunki.burza:=boolean(warmenuuklad[6].wartosc);
      warunki.silaburzy:=505-warmenuuklad[7].wartosc;
      warunki.deszcz:=boolean(warmenuuklad[8].wartosc);
      warunki.snieg:=boolean(warmenuuklad[9].wartosc);

      a:=warunki.typ_wody;
      if warmenuuklad[10].wartosc=1 then warunki.typ_wody:=0  else
      if warmenuuklad[11].wartosc=1 then warunki.typ_wody:=1  else
      if warmenuuklad[12].wartosc=1 then warunki.typ_wody:=2  else
      if warmenuuklad[13].wartosc=1 then warunki.typ_wody:=3  else
      if warmenuuklad[14].wartosc=1 then warunki.typ_wody:=4
         else warunki.typ_wody:=5;
      if a<>warunki.typ_wody then form1.popraw_dol_maski_terenu;

      warunki.gleb_wody:=warmenuuklad[16].wartosc;
      warunki.ust_wys_wody:=teren.height-warunki.gleb_wody;
      warunki.wys_wody:=warunki.ust_wys_wody;

      if warunki.godzina<>warmenuuklad[17].wartosc then begin
          warunki.godzina:=warmenuuklad[17].wartosc;
          oblicz_kolory_tla;
      end;

      warunki.agresja:=warmenuuklad[19].wartosc;
      warunki.walka_bez_powodu:=boolean(warmenuuklad[20].wartosc);
      warunki.walka_ze_swoimi:=boolean(warmenuuklad[21].wartosc);
      warunki.zwierzeta_same:=boolean(warmenuuklad[22].wartosc);
      warunki.grawitacja:=warmenuuklad[23].wartosc/100;
      warunki.pauza:=boolean(warmenuuklad[18].wartosc);
  end;

  warunki.chmurki:=boolean(warmenuuklad[3].wartosc);


  kfg.pokazuj_info:=boolean(warmenuuklad[24].wartosc);
  kfg.wskazniki_kolesi:=boolean(warmenuuklad[25].wartosc);

  if kfg.jest_dzwiek and (warmenuuklad[26].wartosc=0) then
     wylacz_dzwieki_ciagle;
  kfg.jest_dzwiek:=boolean(warmenuuklad[26].wartosc);

  if kfg.jest_muzyka and (warmenuuklad[27].wartosc=0) then begin
     form1.wylaczmuzyke;
     kfg.jest_muzyka:=boolean(warmenuuklad[27].wartosc);
     nowynapiswrogu(Gra_Muzykawylaczona,200);
  end else
      if not kfg.jest_muzyka and (warmenuuklad[27].wartosc=1) then begin
         kfg.jest_muzyka:=boolean(warmenuuklad[27].wartosc);
         //form1.grajkawalek(listyplikow[2][random(length(listyplikow[2]))],false);
         form1.graj_muzyke_w_grze(-1);
         form1.wlaczmuzyke(false);
      end;

  //nastepny utwor:
  if (warmenuuklad[28].wartosc=0) then begin
     warmenuuklad[28].wartosc:=1;
     if kfg.jest_muzyka then begin
        form1.wylaczmuzyke;
        b:=muzyka.ktory_kawalek_z_listy_gra+1;
        if b>=length(listyplikow[2]) then b:=0;
        form1.graj_muzyke_w_grze(b);
        form1.wlaczmuzyke(false);
     end;
  end;


end;

end;

procedure pokaz_menu_warunki;
var a,b:integer; tr,tr2:trect; xx,xxp,yy:integer; c:cardinal; s:string;
begin
 tr:=rect(0,ekran.height-ekran.menux,ekran.width,ekran.height);
 form1.PowerDraw1.ClipRect:=tr;

 xxp:=50;
 yy:=ekran.height-ekran.menux+7;
 a:=0;
 xx:=xxp;
 while (a<=high(warmenuuklad)) do
    with warmenuuklad[a] do begin
       if nl then begin
          xx:=xxp;
          inc(yy,23);
       end;
       case typ of
          1:begin {suwak}
            if ikona>=1 then inc(xx,23);
            if mysz_w2(xx,yy,sz,20) then begin
               c:=$FFFFFFFF;
               if tt<>'' then s:=tt+': ' else s:='';
               if a=17 then s:=s+l2t(wartosc div 100,0)+':'+l2t(trunc((wartosc mod 100)/1.666667),2)
                  else s:=s+l2t(wartosc,0);
               nowytultip(xx,yy-10,s);
            end else
               c:=kolor_przyciemnienia;

            b:=trunc((wartosc-mn)*sz/(mx-mn));

            if wartosc<mx then begin
               tr2:=rect(xx+b+1,yy,xx+sz,yy+23);
               form1.PowerDraw1.ClipRect:=tr2;
               form1.PowerDraw1.TextureMap(obr.menusuwaktlo.surf,
                 pBounds4(xx,yy,sz,20),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectdiffuse);
            end;

            tr2:=rect(xx,yy,xx+b,yy+23);
            form1.PowerDraw1.ClipRect:=tr2;

            form1.PowerDraw1.TextureMap(obr.menusuwakwyp.surf,
                 pBounds4(xx,yy,sz,20),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectdiffuse);
            form1.PowerDraw1.ClipRect:=tr;

            form1.drawsprajt(obr.menusuwak,
                             xx-obr.menusuwak.ofsx +b,
                             yy,
                             0);

            if ikona>=1 then
               form1.PowerDraw1.RenderEffectCol(obr.menuikonyw.surf,
                             xx-24,
                             yy,
                             c,
                             ikona-1,
                             effectSrcAlpha or effectdiffuse);

            if offset=0 then inc(xx,sz+3)
                        else inc(xx,sz+offset);
          end;
          2:begin {przelacznik}
            if mysz_w2(xx,yy,20,20) then begin
               c:=$FFFFFFFF;
               if tt<>'' then nowytultip(xx,yy-10,tt);
            end else
               c:=kolor_przyciemnienia;

            form1.PowerDraw1.RenderEffectCol(obr.menuikonyw.surf,
                             xx,
                             yy,
                             c,
                             ikona-1+(wartosc),
                             effectSrcAlpha or effectdiffuse);

            if offset=0 then inc(xx,23)
                        else inc(xx,offset);
          end;
          3:begin {przelacznik on/off}
            {if wartosc=0 then c:=$808080
                         else c:=$FFFFFF;}
            if mysz_w2(xx,yy,20,20) then begin
               c:={c or $FF000000}$FFFFFFFF;
               if tt<>'' then nowytultip(xx,yy-10,tt);
            end else
               c:={c or $a0000000}kolor_przyciemnienia;

            form1.PowerDraw1.RenderEffectCol(obr.menuikonyw.surf,
                             xx,
                             yy,
                             c,
                             ikona-1,
                             effectSrcAlpha or effectdiffuse);

            if wartosc=0 then
            form1.PowerDraw1.RenderEffectCol(obr.menukratka.surf,
                             xx-1,
                             yy-1,
                             c,
                             1,
                             effectSrcAlpha or effectdiffuse);

            if offset=0 then inc(xx,23)
                        else inc(xx,offset);
          end;
          4:begin {ikona}
            form1.PowerDraw1.RenderEffectCol(obr.menuikonyw.surf,
                             xx,
                             yy,
                             $FFFFFFFF,
                             ikona-1,
                             effectSrcAlpha or effectdiffuse);

            if offset=0 then inc(xx,23)
                        else inc(xx,offset);
          end;
       end;
       inc(a);
    end;

end;


procedure sprawdz_kliki_menu_druzyny;
var a,b:integer; xx,xxp,yy:integer;
begin
druzmenuuklad[0].wartosc:=druzyna[druzynymenu.wybrana].ma_byc_kolesi;
druzmenuuklad[1].wartosc:=druzyna[druzynymenu.wybrana].startsila;
druzmenuuklad[2].wartosc:=druzyna[druzynymenu.wybrana].startbron;
druzmenuuklad[3].wartosc:=druzyna[druzynymenu.wybrana].startamunicja;

druzmenuuklad[3].mx:=druzyna[druzynymenu.wybrana].maxamunicji[druzmenuuklad[2].wartosc];
if druzmenuuklad[3].wartosc>druzmenuuklad[3].mx then begin
   druzmenuuklad[3].wartosc:=druzmenuuklad[3].mx;
   druzyna[druzynymenu.wybrana].startamunicja:=druzmenuuklad[3].wartosc;
end;

b:=0;
for a:=0 to max_druzyn do
    if a<>druzynymenu.wybrana then inc(b,druzyna[a].ma_byc_kolesi);

druzmenuuklad[0].mx:=max_kol-b;
if druzmenuuklad[0].wartosc>druzmenuuklad[0].mx then
   druzmenuuklad[0].wartosc:=druzmenuuklad[0].mx;

xxp:=50;
yy:=ekran.height-ekran.menux+7;

if not (tryb_misji.wlaczony and not tryb_misji.zmianadruzyn) then begin
    if (mysz.menul) then begin
       a:=0;
       xx:=xxp;
       while (a<=high(druzmenuuklad)) do
          with druzmenuuklad[a] do begin
             if offset>0 then inc(xx,offset);
             if nl then begin
                xx:=xxp;
                inc(yy,23);
             end;
             case typ of
                1:begin {suwak}
                  if ikona>=1 then inc(xx,23);

                  if mysz_w2(xx,yy,sz,20) then begin
                     wartosc:=round((mysz.x-xx)/(sz/(mx-mn)))+mn;
                  end;

                  inc(xx,sz+3);
                end;
                2,3:begin {przelacznik}
                  if mysz_w2(xx,yy,20,20) then begin
                     if a in [10..15] then
                        for b:=10 to 15 do druzmenuuklad[b].wartosc:=0;
                     inc(wartosc);
                     if wartosc>mx then wartosc:=mn;
                     mysz.menustop:=true;
                  end;
                  inc(xx,23);
                end;
                4:begin {ikona}
                  inc(xx,23);
                end;
             end;
             inc(a);
          end;

       druzyna[druzynymenu.wybrana].startbron:=druzmenuuklad[2].wartosc;
       druzyna[druzynymenu.wybrana].startamunicja:=druzmenuuklad[3].wartosc;
       druzyna[druzynymenu.wybrana].startsila:=druzmenuuklad[1].wartosc;
       druzyna[druzynymenu.wybrana].ma_byc_kolesi:=druzmenuuklad[0].wartosc;
    end;

    if (mysz.menul) or (mysz.menur) then begin
       xx:=xxp;
       yy:=ekran.height-ekran.menux+53;
       for a:=0 to max_druzyn do
           if mysz_w2(xx+a*50,yy,42,20) then begin
              druzyna[druzynymenu.wybrana].przyjaciele[a]:=not druzyna[druzynymenu.wybrana].przyjaciele[a];
              if mysz.menur then
                 druzyna[a].przyjaciele[druzynymenu.wybrana]:=druzyna[druzynymenu.wybrana].przyjaciele[a];
              mysz.menustop:=true;
           end;
    end;
end;

if (mysz.menul) then begin
   xx:=xxp;
   yy:=ekran.height-ekran.menux+7;
   for a:=0 to max_druzyn do
       if mysz_w2(xx+a*23,yy,20,20) then begin
          druzynymenu.wybrana:=a;
       //   mysz.menustop:=true;
       end;
end;

end;

procedure pokaz_menu_druzyny;
var a,b:integer; tr,tr2:trect; xx,xxp,yy:integer; c:cardinal; s:string;
begin
 tr:=rect(0,ekran.height-ekran.menux,ekran.width,ekran.height);
 form1.PowerDraw1.ClipRect:=tr;

 xxp:=50;
 yy:=ekran.height-ekran.menux+7;
 a:=0;
 xx:=xxp;
 while (a<=high(druzmenuuklad)) do
    with druzmenuuklad[a] do begin
       if offset>0 then inc(xx,offset);
       if nl then begin
          xx:=xxp;
          inc(yy,23);
       end;
       case typ of
          1:begin {suwak}
            if ikona>=1 then inc(xx,23);
            if mysz_w2(xx,yy,sz,20) then begin
               c:=$FFFFFFFF;
               if tt<>'' then s:=tt+': ' else s:='';
               if a=17 then s:=s+l2t(wartosc div 100,0)+':'+l2t(trunc((wartosc mod 100)/1.666667),2)
                  else s:=s+l2t(wartosc,0);
               nowytultip(xx,yy-10,s);
            end else
               c:=kolor_przyciemnienia;

            if mx>0 then b:=trunc((wartosc-mn)*sz/(mx-mn))
               else b:=0;

            if (wartosc<mx) or (mx=0) then begin
               tr2:=rect(xx+b+1,yy,xx+sz,yy+23);
               form1.PowerDraw1.ClipRect:=tr2;
               form1.PowerDraw1.TextureMap(obr.menusuwaktlo.surf,
                 pBounds4(xx,yy,sz,20),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectdiffuse);
            end;

            tr2:=rect(xx,yy,xx+b,yy+23);
            form1.PowerDraw1.ClipRect:=tr2;

            form1.PowerDraw1.TextureMap(obr.menusuwakwyp.surf,
                 pBounds4(xx,yy,sz,20),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectdiffuse);
            form1.PowerDraw1.ClipRect:=tr;

            form1.drawsprajt(obr.menusuwak,
                             xx-obr.menusuwak.ofsx +b,
                             yy,
                             0);

            if ikona>=1 then
               form1.PowerDraw1.RenderEffectCol(obr.menuikonydruz.surf,
                             xx-24,
                             yy,
                             c,
                             ikona-1,
                             effectSrcAlpha or effectdiffuse);

            inc(xx,sz+3);
          end;
          2:begin {przelacznik}
            if mysz_w2(xx,yy,20,20) then begin
               c:=$FFFFFFFF;
               if tt<>'' then nowytultip(xx,yy-10,tt);
            end else
               c:=kolor_przyciemnienia;

            form1.PowerDraw1.RenderEffectCol(obr.menuikonydruz.surf,
                             xx,
                             yy,
                             c,
                             ikona-1+(wartosc),
                             effectSrcAlpha or effectdiffuse);

            inc(xx,23);
          end;
          3:begin {przelacznik on/off}
            if wartosc=0 then c:=$808080
                         else c:=$FFFFFF;
            if mysz_w2(xx,yy,20,20) then begin
               c:=c or $FF000000;
               if tt<>'' then nowytultip(xx,yy-10,tt);
            end else
               c:=c or $a0000000;

            form1.PowerDraw1.RenderEffectCol(obr.menuikonydruz.surf,
                             xx,
                             yy,
                             c,
                             ikona-1,
                             effectSrcAlpha or effectdiffuse);

            inc(xx,23);
          end;
          4:begin {ikona}
            form1.PowerDraw1.RenderEffectCol(obr.menuikonydruz.surf,
                             xx,
                             yy,
                             $FFFFFFFF,
                             ikona-1,
                             effectSrcAlpha or effectdiffuse);

            inc(xx,23);
          end;
       end;
       inc(a);
    end;

   xx:=xxp;
   yy:=ekran.height-ekran.menux+7;
   for a:=0 to max_druzyn do begin
       if mysz_w2(xx+a*23,yy,20,20) then begin
          c:=$FFFFFFFF;
          nowytultip(xx+a*23,yy-10,DM_dru_Ustawieniadruzyny+l2t(a+1,0));
       end else
          c:=kolor_przyciemnienia;

       form1.powerdraw1.FillRect(xx+a*23,yy,20,20,
             cardinal($50000000 or druzyna[a].kolor_druzyny),
             effectSrcAlpha or effectDiffuse);
       form1.PowerDraw1.TextureMap(druzyna[a].animacje[0].surf,
         pBounds4(xx+a*23,yy,20,20),
         ccolor1(c),
         tPattern(0),
         effectSrcAlpha or effectDiffuse);

       if a=druzynymenu.wybrana then
          form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+a*23-1,yy-1,0,effectSrcAlpha);

       piszdowolne(l2t(druzyna[a].jest_kolesi,0),xx+a*23+19,yy-1,$c0ffffff,6,8,1);
       piszdowolne(l2t(druzyna[a].ma_byc_kolesi,0),xx+a*23+19,yy-1+14,$c0ffffff,6,8,1);
   end;

   pisz('n='+l2t(druzyna[druzynymenu.wybrana].jest_kolesi,0)+'/'+l2t(druzyna[druzynymenu.wybrana].ma_byc_kolesi,0),510,ekran.height-ekran.menux+10);

   xx:=xxp;
   yy:=ekran.height-ekran.menux+53;
   for a:=0 to max_druzyn do begin
       if mysz_w2(xx+a*50,yy,42,20) then begin
          c:=$FFFFFFFF;
          if druzyna[druzynymenu.wybrana].przyjaciele[a] then s:=DM_dru_Przyjazna
             else s:=DM_dru_Wroga;
          nowytultip(xx+a*50,yy-10,s+DM_dru_druzyna+l2t(a+1,0));
       end else
          c:=kolor_przyciemnienia;

       form1.powerdraw1.FillRect(xx+a*50,yy,20,20,
             cardinal($50000000 or druzyna[a].kolor_druzyny),
             effectSrcAlpha or effectDiffuse);
       form1.PowerDraw1.TextureMap(druzyna[a].animacje[0].surf,
         pBounds4(xx+a*50,yy,20,20),
         ccolor1(c),
         tPattern(0),
         effectSrcAlpha or effectDiffuse);

       form1.PowerDraw1.RenderEffectCol(obr.menuikonydruz.surf,
                       xx+a*50+22,
                       yy,
                       c,
                       1+ord(druzyna[druzynymenu.wybrana].przyjaciele[a]),
                       effectSrcAlpha or effectdiffuse);

       if a=druzynymenu.wybrana then
          form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+a*50-1,yy-1,0,effectSrcAlpha);
   end;

end;


procedure sprawdz_kliki_menu_wejscia;
var a,b,c:integer; xx,xxp,yy:integer; wybierz_niebo:boolean;
begin
wybierz_niebo:=false;
//if druzynymenu.wejsciewybrane>=1 then begin
   wejmenuuklad[4].wartosc:=wejscia[druzynymenu.wejsciewybrane].czest;
   wejmenuuklad[5].wartosc:=wejscia[druzynymenu.wejsciewybrane].proc;
{end else begin
   wejmenuuklad[4].wartosc:=wejmenuuklad[4].mn;
   wejmenuuklad[5].wartosc:=wejmenuuklad[5].mn;
end;}

wejmenuuklad[6].wartosc:=ord(druzynymenu.lecatezzgory);

xxp:=50;
yy:=ekran.height-ekran.menux+7;

if (mysz.menul) then begin
   a:=0;
   xx:=xxp;
   while (a<=high(wejmenuuklad)) do
      with wejmenuuklad[a] do begin
         if nl then begin
            xx:=xxp;
            inc(yy,23);
         end;
         if offset>0 then inc(xx,offset);
         case typ of
            1:begin {suwak}
              if ikona>=1 then inc(xx,23);

              if mysz_w2(xx,yy,sz,20) then begin
                 wartosc:=round((mysz.x-xx)/(sz/(mx-mn)))+mn;
              end;

              inc(xx,sz+3);
            end;
            2,3:begin {przelacznik}
              if (a=0) and (mysz_w2(xx,yy,20,20)) then begin
                 c:=0;
                 b:=0;
                 while (b<=max_druzyn) and (c=0) do begin
                     if not wejscia[druzynymenu.wejsciewybrane].druzyny[b] then begin
                        c:=1; //jest jakis wylaczony, wiec zaznacz wszystkie
                        b:=max_druzyn;
                     end;
                     inc(b);
                 end;
                 if c=1 then begin
                    for b:=0 to max_druzyn do
                        wejscia[druzynymenu.wejsciewybrane].druzyny[b]:=true;
                 end else
                    for b:=0 to max_druzyn do
                        wejscia[druzynymenu.wejsciewybrane].druzyny[b]:=false;

              end;
              if mysz_w2(xx,yy,20,20) then begin
                 case a of
                    1:bron.glownytryb:=2;
                    2:if druzynymenu.wejsciewybrane>=1 then usun_wejscie(druzynymenu.wejsciewybrane);
                    3:begin
                      for b:=0 to max_druzyn do
                          if wejscia[druzynymenu.wejsciewybrane].druzyny[b] then
                             wejscia[druzynymenu.wejsciewybrane].sypie[b]:=true;
                      end;
                 end;
                 inc(wartosc);
                 if wartosc>mx then wartosc:=mn;
                 mysz.menustop:=true;
              end;
              inc(xx,23);
            end;
            4:begin {ikona}
              if (a=7) and (mysz_w2(xx,yy,20,20)) then begin
                 wybierz_niebo:=true;
                 mysz.menustop:=true;
              end;
              inc(xx,23);
            end;
         end;
         inc(a);
      end;

   wejscia[druzynymenu.wejsciewybrane].czest:=wejmenuuklad[4].wartosc;
   wejscia[druzynymenu.wejsciewybrane].proc:=wejmenuuklad[5].wartosc;
   druzynymenu.lecatezzgory:=boolean(wejmenuuklad[6].wartosc);

end;

if wybierz_niebo then druzynymenu.wejsciewybrane:=0;

if (druzynymenu.ilewejsc=0) then druzynymenu.lecatezzgory:=true;

if (mysz.menul) then begin
   if druzynymenu.wejsciewybrane>=1 then begin
       xx:=xxp+55;
       yy:=ekran.height-ekran.menux+7;
       for a:=0 to max_druzyn do
           if mysz_w2(xx+a*23,yy,20,20) then begin
              wejscia[druzynymenu.wejsciewybrane].druzyny[a]:=not wejscia[druzynymenu.wejsciewybrane].druzyny[a];
              mysz.menustop:=true;
           end;
   end;
end;

end;

procedure pokaz_menu_wejscia;
var a,b:integer; tr,tr2:trect; xx,xxp,yy:integer; c:cardinal; s:string;
begin
 tr:=rect(0,ekran.height-ekran.menux,ekran.width,ekran.height);
 form1.PowerDraw1.ClipRect:=tr;

 xxp:=50;
 yy:=ekran.height-ekran.menux+7;
 a:=0;
 xx:=xxp;
 while (a<=high(wejmenuuklad)) do
    with wejmenuuklad[a] do begin
       if nl then begin
          xx:=xxp;
          inc(yy,23);
       end;
       if offset>0 then inc(xx,offset);
       case typ of
          1:begin {suwak}
            if ikona>=1 then inc(xx,23);
            if mysz_w2(xx,yy,sz,20) then begin
               c:=$FFFFFFFF;
               if tt<>'' then s:=tt+': ' else s:='';
               if a=17 then s:=s+l2t(wartosc div 100,0)+':'+l2t(trunc((wartosc mod 100)/1.666667),2)
                  else s:=s+l2t(wartosc,0);
               nowytultip(xx,yy-10,s);
            end else
               c:=kolor_przyciemnienia;

            b:=trunc((wartosc-mn)*sz/(mx-mn));

            if wartosc<mx then begin
               tr2:=rect(xx+b+1,yy,xx+sz,yy+23);
               form1.PowerDraw1.ClipRect:=tr2;
               form1.PowerDraw1.TextureMap(obr.menusuwaktlo.surf,
                 pBounds4(xx,yy,sz,20),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectdiffuse);
            end;

            tr2:=rect(xx,yy,xx+b,yy+23);
            form1.PowerDraw1.ClipRect:=tr2;

            form1.PowerDraw1.TextureMap(obr.menusuwakwyp.surf,
                 pBounds4(xx,yy,sz,20),
                 ccolor1(c),
                 tPattern(0),
                 effectSrcAlpha or effectdiffuse);
            form1.PowerDraw1.ClipRect:=tr;

            form1.drawsprajt(obr.menusuwak,
                             xx-obr.menusuwak.ofsx +b,
                             yy,
                             0);

            if ikona>=1 then
               form1.PowerDraw1.RenderEffectCol(obr.menuikonydruz.surf,
                             xx-24,
                             yy,
                             c,
                             ikona-1,
                             effectSrcAlpha or effectdiffuse);

            inc(xx,sz+3);
          end;
          2:begin {przelacznik}
            if mysz_w2(xx,yy,20,20) then begin
               c:=$FFFFFFFF;
               if tt<>'' then nowytultip(xx,yy-10,tt);
            end else
               c:=kolor_przyciemnienia;

            form1.PowerDraw1.RenderEffectCol(obr.menuikonydruz.surf,
                             xx,
                             yy,
                             c,
                             ikona-1+(wartosc),
                             effectSrcAlpha or effectdiffuse);

            inc(xx,23);
          end;
          3:begin {przelacznik on/off}
            if wartosc=0 then c:=$808080
                         else c:=$FFFFFF;
            if mysz_w2(xx,yy,20,20) then begin
               c:=c or $FF000000;
               if tt<>'' then nowytultip(xx,yy-10,tt);
            end else
               c:=c or $a0000000;

            form1.PowerDraw1.RenderEffectCol(obr.menuikonydruz.surf,
                             xx,
                             yy,
                             c,
                             ikona-1,
                             effectSrcAlpha or effectdiffuse);

            inc(xx,23);
          end;
          4:begin {ikona}
            form1.PowerDraw1.RenderEffectCol(obr.menuikonydruz.surf,
                             xx,
                             yy,
                             $FFFFFFFF,
                             ikona-1,
                             effectSrcAlpha or effectdiffuse);

            if mysz_w2(xx,yy,20,20) then begin
               c:=c or $FF000000;
               if tt<>'' then nowytultip(xx,yy-10,tt);
            end else
               c:=c or $a0000000;

            inc(xx,23);
          end;
       end;
       inc(a);
    end;

   xx:=xxp+55;
   yy:=ekran.height-ekran.menux+7;
   for a:=0 to max_druzyn do begin
       if mysz_w2(xx+a*23,yy,20,20) then begin
          c:=$FFFFFFFF;
          nowytultip(xx+a*23,yy-10,DM_wej_Tymwejsciemwchodzidruzyna+l2t(a+1,0));
       end else
          c:=kolor_przyciemnienia;

       form1.powerdraw1.FillRect(xx+a*23,yy,20,20,
             cardinal($50000000 or druzyna[a].kolor_druzyny),
             effectSrcAlpha or effectDiffuse);
       form1.PowerDraw1.TextureMap(druzyna[a].animacje[0].surf,
         pBounds4(xx+a*23,yy,20,20),
         ccolor1(c),
         tPattern(0),
         effectSrcAlpha or effectDiffuse);

       if (druzynymenu.wejsciewybrane>=1) and
          (wejscia[druzynymenu.wejsciewybrane].druzyny[a]) then
          form1.PowerDraw1.RenderEffect(obr.menukratka.surf,xx+a*23-1,yy-1,0,effectSrcAlpha);
   end;

   if druzynymenu.wejsciewybrane=0 then
      pisz(DM_wej_gora,10,ekran.height-ekran.menux+8)
    else
      pisz(l2t(druzynymenu.wejsciewybrane,0)+'/'+l2t(druzynymenu.ilewejsc,0),10,ekran.height-ekran.menux+8);

end;




procedure sprawdz_kliki_menu_boczne;
var a:integer; xx,yy:integer;
begin
xx:=600;
yy:=ekran.height-ekran.menux+1;
if mysz.menul and (mysz_w2(xx,yy,40,75)) then begin
   a:=0;
   while (a<=4) do begin
      if mysz_w2(xx,yy,40,15) then menju.widoczne:=a;
      inc(yy,15);
      inc(a);
   end;
   ustaw_menu_widoczne;
end;

end;

procedure pokaz_menu_boczne;
var a:integer; tr:trect; xx,yy:integer; c:cardinal;
begin
 tr:=rect(0,ekran.height-ekran.menux,ekran.width,ekran.height);
 form1.PowerDraw1.ClipRect:=tr;

 xx:=600;
 yy:=ekran.height-ekran.menux+1;
 a:=0;
 while (a<=4) do begin
    if menju.widoczne<>a then c:=$909090
                         else c:=$E0FFFFFF;
    if mysz_w2(xx,yy,40,15) then begin
       nowytultip(xx,yy-11,Menu_boczne_nazwy[a]);
       c:=c or $FF000000;
       //if tt<>'' then nowytultip(xx,yy-10,tt);
    end else
       c:=c or $B0000000;

    form1.PowerDraw1.RenderEffectCol(obr.ikowybmenu.surf,
                     xx,
                     yy,
                     c,
                     a,
                     effectSrcAlpha or effectdiffuse);

    inc(yy,15);
    inc(a);
 end;

end;











procedure nowytultip(x_,y_:integer; tx:string; czas_:integer);

 function dlugtext(s:string):integer;
 var i,d,m:integer;
 begin
   m:=0; //max znalezione
   d:=0; //dlug wlasnie liczona
   i:=1; //index po stringu
   while i<=length(s) do begin
      if (s[i]=#13) or (i=length(s)) then begin
         if i=length(s) then inc(d);
         if d>m then m:=d;
         d:=0;
      end else if s[i]=#10 then begin
      end else inc(d);
      inc(i);
   end;
   result:=m;
 end;

var n:integer;
begin
with tultip do begin
   if x_=-1 then begin
      x:=mysz.x-length(tx)*3;
      y:=mysz.y-13;
   end else begin
       x:=x_;
       y:=y_;
   end;
   tekst:=tx;

   if x<0 then x:=0;
   if y<0 then y:=0;
   n:=dlugtext(tekst);
   if x+n*6>=ekran.width-3 then x:=ekran.width-n*6-3;
   if y+10>=ekran.height then y:=ekran.height-10;

   czas:=czas_;
end;
end;

procedure pokazuj_tultip;
var k:cardinal;
begin
with tultip do begin
   if czas<=0 then exit;

   if czas<=15 then k:=cardinal( (czas shl 28) or $FFFFFF )
      else k:=$FFFFFFFF;
   unitgraglowna.piszwaskie(tekst,x,y,k);

   dec(czas);
end;
end;

procedure nowynapis(x_,y_:integer; tx:string; jaki_:byte=0);
var a,b:longint;
begin
a:=mieso_nowy;
b:=0;
while (b<max_napis) and (napis[a].czas>0) do begin
   inc(a);
   inc(b);
   if a>=max_napis then a:=0;
end;
if napis[a].czas=0 then
   with napis[a] do begin
     x:=x_;
     y:=y_;
     jaki:=jaki_;
     tekst:=tx;
     czas:=95;
   end;
end;

procedure ruszaj_napis;
var a:integer;
begin
for a:=0 to max_napis do
    with napis[a] do begin
       if czas>0 then dec(czas);
    end;
end;

procedure pokazuj_napis;
var k:cardinal; a:integer;
begin
for a:=0 to max_napis do
  with napis[a] do
     if czas>0 then begin

       if czas<=20{31} then k:=cardinal( (czas shl 27) or $FFFFFF )
          else k:=$A0FFFFFF;

       case jaki of
        0:
         unitgraglowna.piszdowolne( tekst,
                                    x-(length(tekst)*(32-czas div 3)) div 2 -ekran.px,
                                    y-ekran.py-(96-czas),
                                    k,
                                    32-czas div 3,
                                    32-czas div 3);
        1:
         unitgraglowna.piszdowolne( tekst,
                                    x-(length(tekst)*6) div 2 -ekran.px,
                                    y-ekran.py-(96-czas) div 2,
                                    k,
                                    6,
                                    9);
       end;
     end;
end;

procedure nowynapiswrogu(tx:string; czas_:integer);
begin
with napiswrogu do begin
   tekst:=tx;
   czas:=czas_;
end;
end;

procedure pokazuj_napiswrogu;
var k:cardinal;
begin
with napiswrogu do begin
   if czas<=0 then exit;

   if czas<15 then k:=cardinal( (byte(czas) shl 28) or $FFFFFF )
      else k:=$FFFFFFFF;
   unitgraglowna.piszdowolne(tekst,0,0,k,8,10);

   dec(czas);
end;
end;


end.
