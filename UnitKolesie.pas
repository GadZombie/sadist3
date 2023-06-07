unit UnitKolesie;

interface
uses Graphics, Types, vars, sinusy, unitstringi;
const
cr_stoi=0;
cr_idzie=1;
cr_biegnie=2;
cr_strzela=3;
cr_cieszy=4;
cr_trzyma=5;
cr_plynie=6;
cr_panika=7;
cr_kopie=8;
{cr_strzela z karabinu=9 - nieuzywane, bo to to samo co cr_rzuca, tylko inna animacja}
{cr_nurkuje=10 - nieuzywane, bo to to samo co cr_stoi, tylko inna animacja pod woda!}
cr_bije=11;
cr_wyrzuca=12;
cr_obracasie=13;
cr_spada=14;
cr_grzywa=15;
cr_pokazuje=16;
cr_skacze=17;
{cr_wspina=18;}

    procedure nowykoles(sx,sy,dx_,dy_:real; nr:longint; team_:byte);
    procedure ruszaj_kolesi;
    procedure rysuj_kolesi;
    procedure pauza_czytaj_info;
    procedure pokaz_dymek(n: integer; a:integer);

    procedure dodaj_wejscie(x,y:integer);
    procedure usun_wejscie(n:integer);
    procedure dzialaj_wejscia;
    procedure pokazuj_wejscia;

    procedure tworz_kolesi_jak_trzeba;

implementation

uses unit1, unitpociski, unitsyfki, unitmiesko, powertypes, unitbomble, unitwybuchy,
     unitgraglowna, unitmenusy, unitrysowanie, unitefekty, unitprzedmioty;

procedure nowykoles(sx,sy,dx_,dy_:real; nr:longint; team_:byte);
var a,b:longint; c:byte;
begin
if nr=-1 then begin
    a:=kol_nowy;
    b:=0;
    while (b<max_kol) and (koles[a].jest) do begin
       inc(a);
       inc(b);
       if a>=max_kol then a:=0;
    end;
end else a:=nr;

if not koles[a].jest then with koles[a] do begin
    team:=team_;
    x:=sx;
    y:=sy;
    dx:=dx_;
    dy:=dy_;
    zabic:=-1;
    zebrac:=-1;
    czaszbierania:=0;
    jest:=true;
    corobi:=cr_obracasie;
    corobil:=-1;
    kierunek:=random(2)*2-1;
    sila:=druzyna[team].startsila;
    ani:=0;
    anikl:=0;
    anisz:=0;
    anido:=0;
//    bron:=0;
//    amunicja:=0;
    ktoretrzymamieso:=-1;
    skocz:=false;
    palisie:=false;
    tlen:=druzyna[team].maxtlen;
    ktoregochcekopnac:=-1;
    cochcekopnac:=0;
    juz_sa_zwloki:=false;
    przenoszony:=false;
    ile_wspina:=0;

    gadaczas:=0;
    gadaani:=0;
    gadanr:=0;

    zainteresowanie_miesem:=-1;

    c:=255-random(50);
    kolor:=$FF000000+ c shl 16 + c shl 8 + c;
    stopien_spalenia:=255;

    amunicja:=druzyna[team].startamunicja;
    if amunicja=0 then bron:=0
       else bron:=druzyna[team].startbron;
   end;
end;

procedure pauza_czytaj_info;
var a:integer;
begin
bron.info_o_kolesiu:=-1;
for a:=0 to max_kol do
  if koles[a].jest then with koles[a] do begin
    if (vars.bron.info_o_kolesiu=-1) and
       (koles[a].x-ekran.px+koles_prx>=mysz.x) and
       (koles[a].x-ekran.px-koles_prx<=mysz.x) and
       (koles[a].y-ekran.py+koles_pry>=mysz.y) and
       (koles[a].y-ekran.py-koles_pry<=mysz.y) then begin
       vars.bron.info_o_kolesiu:=a;
    end;

    if (vars.bron.przenoszenie) and
       (not przenoszony) and
       (x-ekran.px>=mysz.x-15) and
       (x-ekran.px<=mysz.x+15) and
       (y-ekran.py>=mysz.y-15) and
       (y-ekran.py<=mysz.y+15) then przenoszony:=true;

    if przenoszony then begin
       x:=mysz.x+ekran.px;
       y:=mysz.y+ekran.py;
       dx:=(mysz.x-mysz.sx)/2;
       dy:=(mysz.y-mysz.sy)/2;
    end;

  end;
end;

procedure pokaz_dymek(n: integer; a:integer);
begin
if length(druzyna[koles[n].team].aniteksty[a])>0 then begin
   koles[n].gadaczas:=100;
   koles[n].gadaani:=a;
   koles[n].gadanr:= random( length(druzyna[koles[n].team].aniteksty[a]) );
end;
end;

procedure ruszaj_kolesi;
var
a,b,k:longint;
krx,
sdx,sdy:real;
tr:trect;
pusto_pod:boolean;
c,d:byte;
bx,by,b2x,b2y:integer;
boki:array[0..6,0..29] of boolean; {0-gora,1-prawo,2-dol,3-lewo, 4-srodek w pionie, 5-lewo na dole,6-prawo na dole}
bokiile:array[0..6] of byte; {0-gora,1-prawo,2-dol,3-lewo, 4-srodek w pionie, 5-lewo na dole,6-prawo na dole}

wyswodywx:integer;

procedure koles_strzel(n:longint; dx,dy:real);
var kdx,kdy:smallint;
begin
if (koles[n].bron=0) or (koles[n].amunicja=0) then exit;
  if koles[n].bron in [1..2,4] then begin
     kdx:=druzyna[koles[n].team].anidzialanie[3].x*koles[n].kierunek;
     kdy:=druzyna[koles[n].team].anidzialanie[3].y;
  end else begin
     kdx:=(-obr.broniekolesi[koles[n].bron].ofsx+obr.broniekolesi[koles[n].bron].rx)*koles[n].kierunek;
     kdy:=-obr.broniekolesi[koles[n].bron].ofsy+3;
  end;

 case koles[n].bron of
    1:begin {granaty}
    //     strzel(koles[n].x+kdx, koles[n].y+kdy, dx,dy, 0,n,25,1,10,10,1,true,150,0,0,0,15);

      if koles[n].strzelaWX<0 then //strzel przed siebie
         strzel(koles[n].x+kdx, koles[n].y+kdy, dx,dy, 0,n,30,1,10,15,1,true,150,0,0,0,15)
      else begin
         //strzel w wymierzonego kolesia
         strzel(koles[n].x +kdx,//+ sin(koles[n].katStrzalu*pi180)*10,
                koles[n].y +kdy,//- cos(koles[n].katStrzalu*pi180)*10,
                koles[n].katStrzalu,
                5,
                1,
                n,30,1,10,15,1,true,150,0,0,0,15);
         if koles[n].x>koles[n].strzelaWX then koles[n].kierunek:=-1
                                          else koles[n].kierunek:=1;
      end;


      form1.graj(form1.dzw_bronie_strzaly.Item[1],koles[n].x+kdx,koles[n].y,1000);
      end;
    2:begin {bomby}
    //   strzel(koles[n].x+kdx, koles[n].y+kdy, dx,dy, 0,n,30,1,30,70,2,true,150,0,0,0,15);

      if koles[n].strzelaWX<0 then //strzel przed siebie
         strzel(koles[n].x+kdx, koles[n].y+kdy, dx,dy, 0,n,34,1,30,70,2,true,150,0,0,0,15)
      else begin
         //strzel w wymierzonego kolesia
         strzel(koles[n].x +kdx,//+ sin(koles[n].katStrzalu*pi180)*10,
                koles[n].y +kdy,//- cos(koles[n].katStrzalu*pi180)*10,
                koles[n].katStrzalu,
                5,
                1,
                n,34,1,30,70,2,true,150,0,0,0,15);
         if koles[n].x>koles[n].strzelaWX then koles[n].kierunek:=-1
                                          else koles[n].kierunek:=1;
      end;



      form1.graj(form1.dzw_bronie_strzaly.Item[1],koles[n].x+kdx,koles[n].y,1000);
      end;
    3:begin {karabin}
      if koles[n].strzelaWX<0 then //strzel przed siebie
         strzel(koles[n].x+kdx, koles[n].y+kdy, dx*3,dy/4, 0,n,12,2,40,0,-1,false,-1)
      else begin
         //strzel w wymierzonego kolesia
         strzel(koles[n].x + sin(koles[n].katStrzalu*pi180)*obr.broniekolesi[koles[n].bron].ofsx,
                koles[n].y - cos(koles[n].katStrzalu*pi180)*obr.broniekolesi[koles[n].bron].ofsx,
                koles[n].katStrzalu,
                7,
                1,n,12,2,40,0,-1,false,-1);
      end;

      form1.graj(form1.dzw_bronie_strzaly.Item[3],koles[n].x+kdx,koles[n].y,1000);
      end;
    4:begin {dynamit}
      // strzel(koles[n].x+kdx, koles[n].y+kdy, dx/2,dy/2, 0,n,60,9,30,60,9,true,300,0,0,0,15);

      if koles[n].strzelaWX<0 then //strzel przed siebie
         strzel(koles[n].x+kdx, koles[n].y+kdy, dx/2,dy/2, 0,n,60,9,30,60,9,true,300,0,0,0,15)
      else begin
         //strzel w wymierzonego kolesia
         strzel(koles[n].x +kdx,//+ sin(koles[n].katStrzalu*pi180)*10,
                koles[n].y +kdy,//- cos(koles[n].katStrzalu*pi180)*10,
                koles[n].katStrzalu,
                3.5,
                1,
                n,60,9,30,60,9,true,300,0,0,0,15);
         {if koles[n].x>koles[n].strzelaWX then koles[n].kierunek:=-1
                                          else koles[n].kierunek:=1;}
      end;


      form1.graj(form1.dzw_bronie_strzaly.Item[1],koles[n].x+kdx,koles[n].y,1000);
      if (vars.bron.sterowanie<>n) then begin
         koles[n].corobi:=cr_biegnie;
         koles[n].kierunek:=-koles[n].kierunek;
         if random(2)=0 then koles[n].skocz:=true;
      end;
      end;
 end;
 dec(koles[n].amunicja);
 if koles[n].amunicja<=0 then begin
    if koles[n].bron=3 then
       nowemieso(koles[n].x,
                 koles[n].y,
                 random-0.5,-random/1.7-0.4,
                 7,-2,koles[n].palisie,random(60));

    koles[n].bron:=0;
 end;
end;

begin
kol_il:=0;
for a:=0 to max_druzyn do druzyna[a].jest_kolesi:=0;
{for a:=0 to max_kol do
  if koles[a].jest then with koles[a] do begin
    if DXDraw1.Surface.Canvas.Pixels[trunc(x),trunc(y)]=$00000000 then sila:=50;
  end;

DXDraw1.Surface.Canvas.Release;   }

bron.info_o_kolesiu:=-1;
for a:=0 to max_kol do
  if koles[a].jest then with koles[a] do begin
    if (vars.bron.info_o_kolesiu=-1) and
       (koles[a].x-ekran.px+koles_prx>=mysz.x) and
       (koles[a].x-ekran.px-koles_prx<=mysz.x) and
       (koles[a].y-ekran.py+koles_pry>=mysz.y) and
       (koles[a].y-ekran.py-koles_pry<=mysz.y) then vars.bron.info_o_kolesiu:=a;
    inc(kol_il);
    inc(druzyna[team].jest_kolesi);
    {-}
    x:=x+dx;
    y:=y+dy;
    wyswodywx:=wyswody(x);
    if random(2)=0 then dx:=dx*0.95;
    if random(2)=0 then dy:=dy*0.95;
    if x<koles_prx then begin
       dx:=abs(dx)*0.95;
       x:=koles_prx;
       if (corobi in [cr_idzie,cr_biegnie,cr_plynie,cr_panika]) and (kierunek<0) then kierunek:=abs(kierunek);
    end;
    if x>teren.Width-koles_prx then begin
       dx:=-abs(dx)*0.95;
       x:=teren.Width-koles_prx;
       if (corobi in [cr_idzie,cr_biegnie,cr_plynie,cr_panika]) and (kierunek>0) then kierunek:=-abs(kierunek);
    end;
{    if y<koles_pry then begin
       dy:=abs(dy)*0.95;
       y:=koles_pry
    end;}
    if (y>teren.Height+150) or
       ((warunki.typ_wody=0) and (y>=teren.height+15)) then begin
       sila:=0;
    end;

    if niewidzialnosc>0 then dec(niewidzialnosc);
    if (kfg.dymki_kolesi>0) and (gadaczas>0) then dec(gadaczas);

    bx:=trunc(x);
    by:=trunc(y);
    //fillchar(bokiile[c],5,0);
    for c:=0 to 6 do bokiile[c]:=0;
    for c:=0 to 29 do begin
        b2x:=bx+2{8};
        b2y:=by+c-15;
        boki[1,c]:=(b2x>=0) and (b2x<teren.width) and (b2y>=0) and (b2y<teren.height+30) and (teren.maska[b2x,b2y]<>0);
        b2x:=bx-2{8};
        boki[3,c]:=(b2x>=0) and (b2x<teren.width) and (b2y>=0) and (b2y<teren.height+30) and (teren.maska[b2x,b2y]<>0);
        b2x:=bx;
        boki[4,c]:=(b2x>=0) and (b2x<teren.width) and (b2y>=0) and (b2y<teren.height+30) and (teren.maska[b2x,b2y]<>0);

        b2y:=by+c+14;
        b2x:=bx-2;
        boki[5,c]:=(b2x>=0) and (b2x<teren.width) and (b2y>=0) and (b2y<teren.height+30) and (teren.maska[b2x,b2y]<>0);
        b2x:=bx+2;
        boki[6,c]:=(b2x>=0) and (b2x<teren.width) and (b2y>=0) and (b2y<teren.height+30) and (teren.maska[b2x,b2y]<>0);

        bokiile[1]:=bokiile[1]+ord(boki[1,c]);
        bokiile[3]:=bokiile[3]+ord(boki[3,c]);
        bokiile[4]:=bokiile[4]+ord(boki[4,c]);
        bokiile[5]:=bokiile[5]+ord(boki[5,c]);
        bokiile[6]:=bokiile[6]+ord(boki[6,c]);
    end;

    for c:=7 to 22 do begin
        b2x:=bx+c-15;
        b2y:=by-13;
        boki[0,c]:=(b2x>=0) and (b2x<teren.width) and (b2y>=0) and (b2y<teren.height+30) and (teren.maska[b2x,b2y]<>0);
        b2y:=by+12;
        boki[2,c]:=(b2x>=0) and (b2x<teren.width) and (b2y>=0) and (b2y<teren.height+30) and (teren.maska[b2x,b2y]<>0);

        bokiile[0]:=bokiile[0]+ord(boki[0,c]);
        bokiile[2]:=bokiile[2]+ord(boki[2,c]);
    end;

    pusto_pod:=not boki[4,29];//bokiile[2]<=4;  //tereny.Items[2].Picture.Bitmap.Canvas.pixels[trunc(x),trunc(y+koles_pry)]=0;

    if ((abs(warunki.wiatr)>0.4) or (pusto_pod)) and
       ((warunki.typ_wody=0) or (y<wyswodywx)) then dx:=dx+warunki.wiatr/(30-13*ord(pusto_pod));

    { odbicia od scian }
    c:=0;
    sdx:=dx;
    sdy:=dy;
    if bokiile[0]>9 then begin {odbija sie w dol, o gorna krawedz}
       if abs(dy)>2 then c:=1;
       y:=y-dy;
       dy:=abs(dy)/2;
       if bokiile[2]<=7 then y:=y+1;
    end;
    if bokiile[2]>7 then begin {odbija sie w gore, o dolna krawedz}
       if abs(dy)>2 then c:=1;
       y:=y-dy;
       if abs(dy)>0.3 then dy:=-abs(dy)/2
          else if corobi<>cr_plynie then dy:=0;
    end;
    if bokiile[1]>9 then begin {odbija sie w lewo, o prawa krawedz}
       if abs(dx)>2 then c:=1;
       x:=x-dx;
       dx:=-abs(dx)/2;
       if bokiile[3]<=9 then x:=x-1;
    end;
    if bokiile[3]>9 then begin {odbija sie w prawo, o lewa krawedz}
       if abs(dx)>2 then c:=1;
       x:=x-dx;
       dx:=abs(dx)/2;
       if bokiile[1]<=9 then x:=x+1;
    end;
    {krzycz jak sie walniesz}
    if (c=1) and ((abs(sdy)>2) or (abs(sdx)>2)) then begin
        krx:=sqrt(abs(sqr(sdx)+sqr(sdy)))/2;
        if krx>=1 then
            for b:=0 to trunc(krx)+random(5) do begin
                if random(10)=0 then c:=1 else c:=0;
                nowysyf(x-5+random(10),y-7+random(14),
                        (random-0.5)*krx,
                        (random-0.5)*krx,
                        0,random(5),c,0,true,team);
            end;
        sila:=sila-trunc(krx/2);
        inc(gracz.pkt,trunc(krx/2));
        if random(10)=0 then
           form1.graj(druzyna[team].dzwieki.Item[random(3)],x,y,10000)
    end;
    {----}


    if not pusto_pod then begin
       dy:=-abs(dy)*0.5;
      // y:=y+dy/2;
    end else begin
        if (warunki.typ_wody=0) or (y<wyswodywx) then dy:=dy+(0.1*druzyna[team].waga*warunki.grawitacja)
                                                 else dy:=dy+0.1*druzyna[team].waga;
    end;

    { jak wpadnie do wody }
    if (warunki.typ_wody>=1) and (y>=wyswodywx+5) then begin
       case warunki.typ_wody of
          1..max_wod:begin
            if abs(dx)>{0.03}gestosci[warunki.typ_wody].maxx*1.5 then dx:=dx/gestosci[warunki.typ_wody].x*1.09{1.2};
            if (dy>-0.275+random/20) and (corobi in [cr_plynie]) then begin
               if bokiile[0]<=9 then begin
                  if tlen>=20 then dy:=dy-0.105*druzyna[team].waga
                              else dy:=dy-0.112*druzyna[team].waga;
               end;
            end else if (abs(dy)>gestosci[warunki.typ_wody].maxy*0.4{0.5}) then dy:=dy/(gestosci[warunki.typ_wody].y/1.12){1.05}
                    else if (dy>-0.1+random/20) and (bokiile[0]<=9) then dy:=dy-0.103*druzyna[team].waga;

            if random(6)=0 then begin
               if y>wyswodywx+15 then begin
                  if corobi=cr_plynie then nowybombel(x+kierunek*druzyna[team].anidzialanie[cr_plynie].x,y+druzyna[team].anidzialanie[cr_plynie].y,0,0,random(100)+155,random(156)+20)
                                      else nowybombel(x,y-6,0,0,random(100)+155,random(156)+20);
                  if random(15)=0 then form1.graj(form1.dzw_rozne.Item[10+random(2)],x,y,8000);
               end;
               if (vars.bron.sterowanie<>a) and
                  (random(10)=0) and
                   ((corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_trzyma]) or
                    ((corobi=cr_panika) and (not palisie))) then begin
                  corobi:=cr_plynie;
                  if kierunek=0 then kierunek:=random(2)*2-1;
               end;
               if (warunki.typ_wody<>2) and (palisie) then begin
                  palisie:=false;
                  form1.graj(form1.dzw_rozne.Item[3+random(2)],x,y,7000);
                  nowywybuchdym(x,y-15,random/2-0.25,-0.4-random/1.6,0,wd_dym,1+random(3),random(2)*(170+random(80)),90+random(170));
               end else
               if (warunki.typ_wody=2) then begin
                  palisie:=true;
                  if random(5)=0 then dec(sila);
               end;
               if (warunki.typ_wody=3) and (random(10)=0) then begin
                  nowybombel(x-6+random(13),y-13+random(27),0,0,random(200)+55,random(110)+10);
               end;
            end else
                if (corobi<>cr_plynie) and (corobi<>cr_stoi) and (random(10)=0)
                     then corobi:=cr_panika;
            end;
       end;
    end;

    {traci tlen, dusi sie}
    if (((warunki.typ_wody>=1) and (y>wyswodywx+15))
        or
        ((trunc(x)>=0) and (trunc(y-6)>=0) and (trunc(x)<=teren.width-1) and (trunc(y-6)<=teren.height+30) and
         (teren.maska[trunc(x),trunc(y-6)]<>0))
       ) then begin

        if (tlen>0) and (random(17)=0) then dec(tlen)
          else if (tlen<=0) and (random(8)=0) then begin
               sila:=sila-1;
               if (warunki.typ_wody>=1) and (y>wyswodywx+15) then begin
                  if random(10)=0 then form1.graj(druzyna[team].dzwieki.Item[8],x,y,7000)
               end else
                   if random(5)=0 then corobi:=cr_panika;
               end;

    end else
        if (tlen<druzyna[team].maxtlen) and (random(2)=0) then inc(tlen);


    if (warunki.typ_wody in [2,3]) and (y>=wyswodywx-10) then begin {chodzi po lawie... niech go boli!}
       if random(5)=0 then begin
          dec(sila);
          if random(4)=0 then corobi:=cr_panika;
          if random(30)=0 then begin
             if (y<wyswodywx+8) then
                form1.graj(druzyna[koles[a].team].dzwieki.Item[random(3)],koles[a].x,koles[a].y,10000)
             else form1.graj(druzyna[team].dzwieki.Item[8],x,y,8000);
          end;
          if (y<wyswodywx+14) then
             nowywybuchdym(x-8+random(17),wyswodywx-2,random/2-0.25,-random,1,wd_dym,random(3),(100+random(150)),200+random(100));
       end;
    end;

    if (warunki.typ_wody>=1) and
       (((y-dy>=wyswodywx-2) and (y<wyswodywx-2)) or
        ((y-dy<wyswodywx-2) and (y>=wyswodywx-2))) and
       ((abs(dx)>0.8) or (abs(dy)>0.7)) then begin
       form1.graj(form1.dzw_rozne.Item[5],x,y,7000);
       for b:=0 to 5+random(15) do
           nowysyf(x-8+random(16),wyswodywx-1,(random*2-1)+dx/2,-abs(random*dy/1.5),0,random(5),0,2,true,team,warunki.typ_wody);
       plum(x,y,dy,14,druzyna[team].waga*3);
    end;

    if (warunki.typ_wody>=1) and (corobi in [cr_idzie,cr_biegnie,cr_panika]) and
       (y>=wyswodywx-13) and (y<=wyswodywx+14) and
       (random(3)=0) then begin
       nowysyf(x-8+random(16),wyswodywx-1,-random*kierunek,-random/2,0,random(5),0,2,true,team,warunki.typ_wody);
    end;

    if zabic=a then zabic:=-1;
    if (not warunki.walka_ze_swoimi) and (zabic>=0) and (koles[zabic].jest) and
       (druzyna[team].przyjaciele[koles[zabic].team]) and (not koles[zabic].palisie) and
       (random(6+warunki.agresja*4)=0) then zabic:=-1;
    if (warunki.agresja=0) then zabic:=-1;
    if (zabic>=0) and (koles[zabic].jest) and (koles[zabic].niewidzialnosc>0) then zabic:=-1;
    if (vars.bron.sterowanie<>a) and
       (abs(dy)<1) and (abs(dx)<=1.5) and (bron>=1) and (amunicja>=1) and (not (corobi in [cr_strzela])) then begin
       {strzelaj z nudow...}
        if (bron<>4) and (warunki.agresja>0) and (random(1330-warunki.agresja*120)=0) then begin
           corobil:=corobi;
           corobi:=cr_strzela;
           anikl:=0;
           anido:=0;
           strzelaWX:=-1;
           strzelaWY:=-1;
           //koles_strzel(a,(random*3+2)*(random(2)*2-1), -random*1.5);
        end;

       {strzelaj do wroga}
        if (zabic>=0) and (not (corobi in [cr_strzela])) and (
            ((bron in [1,2]) and (random(100-warunki.agresja*9)=0)) or
            ((bron in [3]) and (random(50-warunki.agresja*5)=0)) or
            ((bron in [4]) and (random(200-warunki.agresja*19)=0)) or
            ((koles[zabic].palisie) and (random(30)=0))
            )then begin
           if bron in [1,2] then k:=300{100} {zasieg strzelania w zaleznosci od broni}
             else if bron=3 then k:=400
                else k:=200;
           if (zabic<>a) and (koles[zabic].jest) then begin
              if (koles[zabic].x>=x-k) and (koles[zabic].y>=y-150) and
                 (koles[zabic].x<=x+k) and (koles[zabic].y<=y+150) then begin
                 if (koles[zabic].x>=x) then kierunek:=1//krx:=(random*2+1)
                                        else kierunek:=-1;//krx:=-(random*2+1);
                 //koles_strzel(a,krx, -random-0.04);
                 strzelaWX:=round(koles[zabic].x);
                 strzelaWY:=round(koles[zabic].y);
                 katStrzalu:=jaki_to_kat(strzelaWX-x, strzelaWY-y);
                 corobil:=corobi;
                 corobi:=cr_strzela;
                 anikl:=0;
                 anido:=0;
              end;
           end;
        end;
    end else if vars.bron.sterowanie=a then begin
        strzelaWX:=mysz.x+ekran.px;
        strzelaWY:=mysz.y+ekran.py;
        katStrzalu:=jaki_to_kat(strzelaWX-x, strzelaWY-y);
    end;
{    if (zabic>=0) and (not koles[zabic].jest) then begin
       zabic:=-1;
       if (abs(dy)<2) and (abs(dx)<=2.5) and (corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_pokazuje,cr_trzyma,cr_wyrzuca]) then begin
          corobil:=corobi;
          corobi:=cr_cieszy;
          ani:=0;
          anido:=0;
       end;
    end;}


    if (vars.bron.sterowanie<>a) and
       (zabic>=0) and (koles[zabic].jest) and (corobi in [cr_stoi,cr_idzie,cr_biegnie]) and
       (koles[zabic].x>=x+kierunek*druzyna[team].anidzialanie[8].x-20) and (koles[zabic].y>=y+druzyna[team].anidzialanie[8].y-15) and
       (koles[zabic].x<=x+kierunek*druzyna[team].anidzialanie[8].x+20) and (koles[zabic].y<=y+druzyna[team].anidzialanie[8].y+15) and
       ((random(50-warunki.agresja*5)=0) or (koles[zabic].palisie and (random(5)=0)) )
       then begin
        if (koles[zabic].x>=x) then kierunek:=1
                               else kierunek:=-1;
        ktoregochcekopnac:=zabic;
        cochcekopnac:=0;
        corobil:=corobi;
        case random(3) of
           0:corobi:=cr_kopie;
           1:corobi:=cr_bije;
           2:corobi:=cr_grzywa;
        end;
        anikl:=0;
        anido:=0;
    end;

    //kop kursor z bliska
    if warunki.walka_z_kursorem and
       (vars.bron.sterowanie<>a) and
       (kfg.jaki_kursor<>1) and
       (corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_trzyma,cr_plynie]) and
       (not palisie) and
       (mysz.x+ekran.px>=x+kierunek*druzyna[team].anidzialanie[8].x-16) and
       (mysz.y+ekran.py>=y+druzyna[team].anidzialanie[8].y-16) and
       (mysz.x+ekran.px<=x+kierunek*druzyna[team].anidzialanie[8].x+16) and
       (mysz.y+ekran.py<=y+druzyna[team].anidzialanie[8].y+16) and
       (random(50-warunki.agresja*5)=0)
       then begin
        if (mysz.x+ekran.px>=x) then kierunek:=1
                                else kierunek:=-1;
        ktoregochcekopnac:=0;
        cochcekopnac:=5;//mysz
        corobil:=corobi;
        case random(3) of
           0:corobi:=cr_kopie;
           1:corobi:=cr_bije;
           2:corobi:=cr_grzywa;
        end;
        anikl:=0;
        anido:=0;
    end;

    {pokaz wroga kolegom... :)}
    if (zabic>=0) and (koles[zabic].jest) and (corobi in [cr_stoi,cr_idzie,cr_biegnie]) and
       ( ((sila>=15) and (random(10)=0) and
         (((koles[zabic].x>=x-120) and (koles[zabic].x<x-100)) or
          ((koles[zabic].x<=x+120) and (koles[zabic].x>x+100))))
          or
        ((sila<15) and (koles[zabic].x>=x-120) and (koles[zabic].x<=x+120) and (random(30)=0))
       )
        and
       (koles[zabic].y>=y-100) and (koles[zabic].y<=y+100)
       then begin
        if (koles[zabic].x>=x) then kierunek:=1
                               else kierunek:=-1;
        corobil:=corobi;
        corobi:=cr_pokazuje;
        anikl:=0;
        anido:=0;
    end;

    {taka niby wolna wola...}
    if (vars.bron.sterowanie<>a) and (not (corobi in [cr_obracasie])) and (random(500)=0) then begin
       if corobi<>cr_plynie then corobi:=random(3);{jedno z: cr_stoi,cr_idzie,cr_biegnie}
       ani:=0;
       case corobi of
            cr_idzie,cr_biegnie,cr_plynie:kierunek:=random(2)*2-1;
       end;
    end;
    if (vars.bron.sterowanie<>a) and
       (corobi=cr_panika) and (not palisie) and
       ((warunki.typ_wody=0) or (y<wyswodywx+5)) and (random(70)=0) then corobi:=cr_idzie;

    if ((abs(dx)>=3) or (abs(dy)>=3)) and (corobi<>cr_skacze) then begin
       if random(5)=0 then corobi:=cr_obracasie;
    end else
        if corobi=cr_obracasie then begin
           if (not pusto_pod) or
              ((abs(dx)<1) and (abs(dy)<1) and (random(20)=0)) or
              ((warunki.typ_wody>=1) and (y>=wyswodywx) and (random(20)=0)) then begin
              corobi:=cr_stoi;
              ani:=0;
              anikl:=0;
           end;
        end;


    if (vars.bron.sterowanie<>a) and
       (zainteresowanie_miesem>=0) then begin {bieganie za miesem i pilkami ;)}

       if (mieso[zainteresowanie_miesem].jest) and
          (zabic=-1) and (not palisie) and
          (mieso[zainteresowanie_miesem].x>=x-300) and (mieso[zainteresowanie_miesem].y>=y-200) and
          (mieso[zainteresowanie_miesem].x<=x+300) and (mieso[zainteresowanie_miesem].y<=y+100) and
          (abs(dx)<=2.5) and (abs(dy)<=2.5) and (corobi in [cr_stoi,cr_idzie,cr_biegnie]) then begin
          if ktoretrzymamieso<>zainteresowanie_miesem then begin
              if (random(8)=0) then begin
                  if (mieso[zainteresowanie_miesem].x>=x-10) and (mieso[zainteresowanie_miesem].y>=y-10) and
                     (mieso[zainteresowanie_miesem].x<=x+10) and (mieso[zainteresowanie_miesem].y<=y+10) and
                     ((mieso[zainteresowanie_miesem].trzymaneprzez<0) or
                      ((mieso[zainteresowanie_miesem].trzymaneprzez<0) and (random(8)=0)))
                     then corobi:=cr_stoi
                  else
                  if (mieso[zainteresowanie_miesem].x>=x-40) and
                     (mieso[zainteresowanie_miesem].x<=x+40) then corobi:=cr_idzie
                  else corobi:=cr_biegnie;

                  if x>mieso[zainteresowanie_miesem].x then kierunek:=-1
                     else kierunek:=1;

                  if (mieso[zainteresowanie_miesem].y>=y-30) and
                     (mieso[zainteresowanie_miesem].y<=y+8) and
                     (random(6)=0) then skocz:=true;
              end;
          end;

       end else zainteresowanie_miesem:=-1;

    end;



    if (vars.bron.sterowanie<>a) and
       (zebrac>=0) and (czaszbierania<=1000) and (przedm[zebrac].jest) then begin {zbieranie przedmiotow}
       if (przedm[zebrac].x>=x-200) and (przedm[zebrac].y>=y-90) and
          (przedm[zebrac].x<=x+200) and
          (((przedm[zebrac].y<=y+50) and (corobi<>cr_plynie)) or
           ((przedm[zebrac].y<=y+150) and (corobi=cr_plynie))) and
          (abs(dx)<=1) and (abs(dy)<=1) and (corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_plynie]) and
          (random(40)=0) then begin
          if corobi<>cr_plynie then corobi:=cr_biegnie
          else begin
                if (przedm[zebrac].y>y) and (tlen>40) and (dy<1.5) and (pusto_pod) then dy:=dy+0.35;
             end;
          if x>przedm[zebrac].x then kierunek:=-1
             else kierunek:=1;

          if (y>przedm[zebrac].y+5) and (random(5)=0) then skocz:=true;
       end;
       inc(czaszbierania);

    end else
    if (zebrac>=0) and (not przedm[zebrac].jest) then begin
       zebrac:=-1;
       czaszbierania:=0;
    end else
    if (vars.bron.sterowanie<>a) and
       (zabic>=0) and (sila>6) and (random(20-warunki.agresja)=0) and
       (not (corobi in [cr_plynie,cr_obracasie,cr_spada,cr_bije,cr_grzywa,cr_kopie,cr_strzela])) then begin {bieganie za tym, ktorego chce zabic}
       if koles[zabic].x<x-40 then begin corobi:=cr_biegnie;kierunek:=-1 end
          else if koles[zabic].x>x+40 then begin corobi:=cr_biegnie;kierunek:=1; end
            else if koles[zabic].x>x then begin corobi:=cr_idzie;kierunek:=1; end
              else if koles[zabic].x<x then begin corobi:=cr_idzie;kierunek:=-1; end;
    end;

    if (vars.bron.sterowanie<>a) and
       (zabic>=0) and (koles[zabic].jest) then begin {uciekanie przed tym, ktory chce go zabic}
       if (koles[zabic].sila<=6) and (koles[zabic].y>=y-100) and (koles[zabic].y<=y+100) and
          (corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_plynie,cr_panika]) then begin
          if (koles[zabic].x<x) and (koles[zabic].x>=x-100) then begin
             if (not (koles[zabic].corobi in [cr_plynie,cr_obracasie,cr_spada,cr_bije,cr_grzywa,cr_kopie,cr_strzela])) then
                koles[zabic].corobi:=cr_biegnie;
             koles[zabic].kierunek:=-1;
             if (koles[zabic].x>=x-50) and (corobi<>cr_plynie) and (random(70)=0) then skocz:=true;
          end else
          if (koles[zabic].x>=x) and (koles[zabic].x<=x+100) then begin
             if (not (koles[zabic].corobi in [cr_plynie,cr_obracasie,cr_spada,cr_bije,cr_grzywa,cr_kopie,cr_strzela])) then
                 koles[zabic].corobi:=cr_biegnie;
             koles[zabic].kierunek:=1;
             if (koles[zabic].x<=x+50) and (corobi<>cr_plynie) and (random(70)=0) then skocz:=true;
          end;
       end;

    end;

    if palisie then begin
       if random(5)=0 then begin
          strzel(x,y-10,-random+0.5,-random/1.6,0,a,10,5,10,-20-random(15),5,boolean(random(2)),8+random(20));
          corobi:=cr_panika;
       end;
       if (random(10)=0) and (kfg.detale>=2) then
        nowywybuchdym( x-4+random(9), y+4-random(15),
                       random/2-0.25,
                       -0.1-random/1.2,
                       0, wd_dym,
                       1+random(9),
                       130+random(120),
                       100+random(150));

       if random(15)=0 then sila:=sila-1;

       if (stopien_spalenia>25) and (random(3)=0) then begin
          dec(stopien_spalenia);
          if stopien_spalenia>=128 then //czerwieni sie
             kolor:=$FF0000FF or (stopien_spalenia shl 16) or (stopien_spalenia shl 8)
          else
          kolor:=$FF000000 or (stopien_spalenia shl 16) or (stopien_spalenia shl 8) or (stopien_spalenia shl 1{czyli *2});
       end;

    end;

    if (ktoretrzymamieso>=0) and (not (corobi in [cr_trzyma,cr_wyrzuca])) then begin
       if mieso[ktoretrzymamieso].jest then mieso[ktoretrzymamieso].trzymaneprzez:=-1;
       ktoretrzymamieso:=-1;
    end;
    if ile_wspina>0 then dec(ile_wspina);
    case corobi of
     cr_stoi:begin {stoi}
         ani:=0;
         if (abs(dy)<=0.4) and (abs(dx)<=1) and (abs(dx)>0.1) then begin
            if dx>0 then dx:=dx-0.1 else
            if dx<0 then dx:=dx+0.1;
         end;
         if (warunki.typ_wody>=1) and (y>=wyswodywx+5) then begin {nurkuje}
            ani:=10;
            anisz:=druzyna[team].aniszyb[ani];
            dec(anido);
            if anido<=0 then begin
               anido:=anisz;
               inc(anikl);
               if anikl>=druzyna[team].animacje[ani].klatek then anikl:=0;
            end;
         end else begin {stoi i sie nudzi}
            if (jaksienudzi>high(druzyna[team].aninudzi)) or (jaksienudzi<0) or
               (ani<>0) or
               ((anikl=druzyna[team].aninudzi[jaksienudzi].od) and (anido=anisz) and
                (druzyna[team].aninudzi[jaksienudzi].tylkoraz or
                 (not druzyna[team].aninudzi[jaksienudzi].tylkoraz and (random(3)=0))
                )
               )
               then begin
               if random(2)=0 then jaksienudzi:=0
                              else jaksienudzi:=random(length(druzyna[team].aninudzi));
               anisz:=druzyna[team].aninudzi[jaksienudzi].szyb;
               anido:=anisz;
               anikl:=druzyna[team].aninudzi[jaksienudzi].od;
               if random(5)=0 then kierunek:=-kierunek;
            end;

            dec(anido);
            if anido<=0 then begin
               anido:=anisz;
               inc(anikl);
               if anikl>=druzyna[team].aninudzi[jaksienudzi].od+druzyna[team].aninudzi[jaksienudzi].ile then anikl:=druzyna[team].aninudzi[jaksienudzi].od;
            end;

            if (kfg.dymki_kolesi>=1) and (gadaczas=0) and (random(5000-kfg.dymki_kolesi*700)=0) then pokaz_dymek(a,cr_stoi);
         end;

         //if random(30)=0 then anikl:=random(druzyna[team].animacje[ani].klatek);
         if (anikl>=druzyna[team].animacje[ani].klatek) or (anikl<0) then anikl:=0;
         end;
     cr_trzyma:begin {trzyma mieso}
         if (abs(dy)<=0.4) and (abs(dx)<=1) and (abs(dx)>0.1) then begin
            if dx>0 then dx:=dx-0.1 else
            if dx<0 then dx:=dx+0.1;
         end;
         ani:=5;
         if random(30)=0 then begin
            anikl:=random(druzyna[team].animacje[ani].klatek);
            if random(100)=0 then
               form1.graj(druzyna[team].dzwieki.Item[5],x,y,15000);
         end;
         if (anikl>=druzyna[team].animacje[ani].klatek) or (anikl<0) then anikl:=0;
         if (ktoretrzymamieso>=0) and (ktoretrzymamieso<=max_mieso) and (mieso[ktoretrzymamieso].jest) then begin
            mieso[ktoretrzymamieso].x:=x;
            mieso[ktoretrzymamieso].y:=y;
            mieso[ktoretrzymamieso].dx:=0;
            mieso[ktoretrzymamieso].dy:=0;
            mieso[ktoretrzymamieso].lezy:=0;
            mieso[ktoretrzymamieso].podpietydo:=-1;
            if random(20)=0 then begin
               if mieso[ktoretrzymamieso].team>=-1 then
                  mieso[ktoretrzymamieso].obrot:=
                     random( druzyna[mieso[ktoretrzymamieso].team].mieso[mieso[ktoretrzymamieso].rodz].klatek )
                  else
                  mieso[ktoretrzymamieso].obrot:=
                     random( obr.smieci[mieso[ktoretrzymamieso].rodz].klatek )
            end;
            if random(100)=0 then begin
                corobi:=cr_wyrzuca;
                anikl:=0;
                anido:=0;
            end;
         end else begin
             corobi:=cr_stoi;
             ani:=0;
             anikl:=0;
             ktoretrzymamieso:=-1;
         end;

         if (kfg.dymki_kolesi>=1) and (gadaczas=0) and (random(200-kfg.dymki_kolesi*70)=0) then pokaz_dymek(a,cr_trzyma);

         end;
     cr_idzie:begin {idzie}
          ani:=1;
          if ile_wspina>0 then ani:=18;
          anisz:=druzyna[team].aniszyb[ani];
          if sila<=7 then anisz:=round(anisz*1.5) else
          if sila<=15 then anisz:=round(anisz*1.25);
          dec(anido);
          if anido<=0 then begin
             anido:=anisz;
             inc(anikl);
             if anikl>=druzyna[team].animacje[ani].klatek then anikl:=0;
          end;
         if (abs(dy)<=1) and (abs(dx)<=0.3) then begin
            if (warunki.typ_wody=0) or (y<wyswodywx+10) then krx:=0.5*druzyna[team].szybkosc else krx:=0.1*druzyna[team].szybkosc;
            if sila<=7 then krx:=krx*0.4 else
            if sila<=15 then krx:=krx*0.7;
            if (bokiile[4]<=10) then begin
               c:=29;
               while (c>=22) and (boki[4,c]) do dec(c);
               if c>=22 then y:=y-(27-c);

               if bokiile[2-kierunek]<=9 then begin
                   c:=29;
                   while (c>=23) and (boki[2-kierunek,c]) do dec(c);
                   if c<=23 then begin
                      ani:=18;
                      ile_wspina:=8;
                   end;
                   if c<=26 then krx:=krx/((2.5+(27-c))/2.5);
               end;
            end;

            if (kierunek>0) and (bokiile[1]<=10) then x:=x+krx
               else if (kierunek<0) and (bokiile[3]<=10) then x:=x-krx;

            if (bokiile[2-kierunek]>10) then kierunek:=-kierunek
               else
                if not boki[5+ord(kierunek=1),0] then begin
                   c:=0;
                   while (c<15) and (not boki[5+ord(kierunek=1),c]) do inc(c);
                   if c>=15 then kierunek:=-kierunek;
                end;

            if (vars.bron.sterowanie<>a) and (random(500)=0) then skocz:=true;
         end;// else ani:=0;
         end;
     cr_biegnie:begin {biegnie}
          ani:=2;
          if ile_wspina>0 then ani:=18;
          anisz:=druzyna[team].aniszyb[ani];
          if sila<=7 then anisz:=round(anisz*1.5) else
          if sila<=15 then anisz:=round(anisz*1.25);
          dec(anido);
          if anido<=0 then begin
             anido:=anisz;
             inc(anikl);
             if anikl>=druzyna[team].animacje[ani].klatek then anikl:=0;
          end;
         if (abs(dy)<=1) and (abs(dx)<=0.3) then begin
            if (warunki.typ_wody=0) or (y<wyswodywx+10) then krx:=0.8*druzyna[team].szybkosc else krx:=0.13*druzyna[team].szybkosc;
            if sila<=7 then krx:=krx*0.4 else
            if sila<=15 then krx:=krx*0.7;
            if (bokiile[4]<=10) then begin
               c:=29;
               while (c>=22) and (boki[4,c]) do dec(c);
               if c>=22 then y:=y-(27-c);

               if bokiile[2-kierunek]<=9 then begin
                   c:=29;
                   while (c>=23) and (boki[2-kierunek,c]) do dec(c);
                   if c<=23 then begin
                      ani:=18;
                      ile_wspina:=8;
                   end;
                   if c<=26 then krx:=krx/((2.5+(27-c))/2.5);
               end;
            end;
            if (kierunek>0) and (bokiile[1]<=10) then x:=x+krx
               else if (kierunek<0) and (bokiile[3]<=10) then x:=x-krx;
            if (bokiile[2-kierunek]>10) then kierunek:=-kierunek
               else
                if not boki[5+ord(kierunek=1),0] then begin
                   c:=0;
                   while (c<15) and (not boki[5+ord(kierunek=1),c]) do inc(c);
                   if c>=15 then kierunek:=-kierunek;
                end;

            if (vars.bron.sterowanie<>a) and (random(500)=0) then skocz:=true;
         end;// else ani:=0;
         end;
     cr_panika:begin {panikuje}
          ani:=7;
          anisz:=druzyna[team].aniszyb[ani];
          if sila<=7 then anisz:=round(anisz*1.5) else
          if sila<=15 then anisz:=round(anisz*1.25);
          dec(anido);
          if anido<=0 then begin
             anido:=anisz;
             inc(anikl);
             if anikl>=druzyna[team].animacje[ani].klatek then anikl:=0;
          end;
         if (abs(dy)<=1) and (abs(dx)<=0.3) then begin
            if (warunki.typ_wody=0) or (y<wyswodywx+4) then krx:=0.8*druzyna[team].szybkosc else krx:=0.13*druzyna[team].szybkosc;
            if sila<=7 then krx:=krx*0.4 else
            if sila<=15 then krx:=krx*0.7;

            if (bokiile[4]<=7) then begin
               c:=29;
               while (c>=25) and (boki[4,c]) do dec(c);
               if c>=25 then y:=y-(27-c);

               c:=29;
               while (c>=26) and (boki[2-kierunek,c]) do dec(c);
               if c<=26 then krx:=krx/((2.5+(27-c))/2.5);
            end;
            if (kierunek>0) and (bokiile[1]<=9) then x:=x+krx
               else if (kierunek<0) and (bokiile[3]<=9) then x:=x-krx;
            if (bokiile[2-kierunek]>7) then kierunek:=-kierunek;
            if (random(100)=0) then begin
               kierunek:=-kierunek;
               if (warunki.typ_wody=0) or (y<wyswodywx+15) then
                  form1.graj(druzyna[team].dzwieki.Item[6],x,y,15000);
            end;


         end;// else ani:=0;

         if (kfg.dymki_kolesi>=1) and ((warunki.typ_wody=0) or (y<wyswodywx)) and
            (gadaczas=0) and (random(200-kfg.dymki_kolesi*70)=0) and
            (not palisie or (palisie and (random(5)=0)))
            then pokaz_dymek(a,cr_panika);

         end;
     cr_skacze:begin {skacze}
          ani:=17;
          anisz:=druzyna[team].aniszyb[ani];
          if sila<=7 then anisz:=round(anisz*1.5) else
          if sila<=15 then anisz:=round(anisz*1.25);
          dec(anido);
          if anido<=0 then begin
             anido:=anisz;
             inc(anikl);
             if anikl>=druzyna[team].animacje[ani].klatek then anikl:=0;
          end;
         if (abs(dy)<=4) and (abs(dx)<=4) then begin
            if (warunki.typ_wody>=1) and (y>=wyswodywx+10) then corobi:=cr_panika;

            if (bokiile[4]<=9) then begin
               c:=27;
               while (c>=21) and (boki[4,c]) do dec(c);
               if c>=21 then y:=y-(27-c);
            end;
            if (bokiile[2-kierunek]>9) then kierunek:=-kierunek;

            if not pusto_pod then corobi:=corobil;
         end else corobi:=cr_obracasie;
         end;
     cr_plynie:begin {plynie po wodzie}
          ani:=6;
          anisz:=druzyna[team].aniszyb[ani];
          if sila<=7 then anisz:=round(anisz*1.5) else
          if sila<=15 then anisz:=round(anisz*1.25);
          dec(anido);
          if anido<=0 then begin
             anido:=anisz;
             inc(anikl);
             if anikl>=druzyna[team].animacje[ani].klatek then anikl:=0;
          end;
         if (abs(dy)<=2) and (abs(dx)<=0.6) then begin
            krx:=(gestosci[warunki.typ_wody].maxx*20{0.4}+random/5)*druzyna[team].szybkosc;
            if sila<=7 then krx:=krx*0.4 else
            if sila<=15 then krx:=krx*0.7;
            if (kierunek>0) and (bokiile[1]<=11)    then x:=x+krx
               else
               if (kierunek<0) and (bokiile[3]<=11) then x:=x-krx;

            if (bokiile[4]<=7) then begin
               c:=27;
               while (c>=23) and (boki[4,c]) do dec(c);
               if c>=23 then y:=y-(27-c);
            end;
            if (bokiile[2-kierunek]>11) then kierunek:=-kierunek;

            if ((warunki.typ_wody=0) or (y<wyswodywx+5)) and (not pusto_pod) then corobi:=random(3);

            if (sila<=5) and (random(5)=0) then corobi:=cr_panika;

            if (wyswodywx>=y-10) and (wyswodywx<=y+10) and (random(6)=0) then begin
               plum(x,y,-random,7,1);
               for b:=0 to random(2) do
               nowysyf( x-10+random(21),wyswodywx-1,
                        -dx-krx/1.4+random/2-0.25,-(random/2)-abs(dy),
                        0,random(5),0,2,true, 0,warunki.typ_wody);
            end;

         end;// else ani:=0;
         if (warunki.typ_wody=0) or (y<wyswodywx-7) then
            corobi:=cr_panika;

         end;
     cr_strzela:begin {rzuca granatem lub strzela z karabinu}
         if (abs(dy)<=1) and (abs(dx)<=0.3) then begin
            if bron in [1,2,4] then ani:=3
               else ani:=9;

            if (kfg.dymki_kolesi>=1) and (zabic>=0) and (ani=3) and (anido=0) and (anikl=0) and
                (gadaczas=0) and
                (random(50-kfg.dymki_kolesi*10)=0) then pokaz_dymek(a,cr_strzela);

            anisz:=druzyna[team].aniszyb[ani];
            if sila<=7 then anisz:=round(anisz*1.5) else
            if sila<=15 then anisz:=round(anisz*1.25);
            dec(anido);
            if anido<=0 then begin
               if anikl=druzyna[team].anidzialanie[ani].klatka then begin
                  krx:=(random*2+1)*kierunek;
                  koles_strzel(a,krx, -random-0.04);
               end;

               anido:=anisz;
               inc(anikl);

               if anikl>=druzyna[team].animacje[ani].klatek then begin
                  if corobil>=0 then begin corobi:=corobil; corobil:=-1; end
                     else corobi:=cr_stoi;
                  ani:=0;
               end;
            end;

         end else
            if corobil>=0 then begin corobi:=corobil; corobil:=-1; end
               else corobi:=cr_stoi;
         end;
     cr_cieszy,cr_wyrzuca:begin {cieszy sie z zabicia kogos, wyrzuca miesko - to samo dzialanie, inna animacja}
         if (abs(dy)<=1.5) and (abs(dx)<=1) then begin
            if (corobi=cr_cieszy) and ((ani=0) and (anido=0)) then
               form1.graj(druzyna[team].dzwieki.Item[5],x,y,15000);

            if (ani=0) and (anido=0) then begin
               if (kfg.dymki_kolesi>=1) and (gadaczas=0) and (random(3-kfg.dymki_kolesi)=0) then pokaz_dymek(a,corobi);
            end;

            ani:=corobi;
            anisz:=druzyna[team].aniszyb[ani];
            dec(anido);
            if (corobi=cr_wyrzuca) and (anikl<druzyna[team].anidzialanie[ani].klatka) and (mieso[ktoretrzymamieso].jest) then begin
                mieso[ktoretrzymamieso].x:=x;
                mieso[ktoretrzymamieso].y:=y;
                mieso[ktoretrzymamieso].dx:=0;
                mieso[ktoretrzymamieso].dy:=0;
                mieso[ktoretrzymamieso].lezy:=0;
            end;

            if anido<=0 then begin

               if (corobi=cr_wyrzuca) and (anikl=druzyna[team].anidzialanie[ani].klatka) and (mieso[ktoretrzymamieso].jest) then begin
                  mieso[ktoretrzymamieso].x:=x;
                  mieso[ktoretrzymamieso].y:=y-13;
                  mieso[ktoretrzymamieso].dx:=random*3-1.5;
                  mieso[ktoretrzymamieso].dy:=-random*3-1;
                  mieso[ktoretrzymamieso].lezy:=0;
                  mieso[ktoretrzymamieso].trzymaneprzez:=-1;
                  ktoretrzymamieso:=-1;
               end;

               anido:=anisz;
               inc(anikl);

               if anikl>=druzyna[team].animacje[ani].klatek then begin
                  if corobil>=0 then begin corobi:=corobil; corobil:=-1; end
                     else corobi:=cr_stoi;
                  ani:=0;
               end;
            end;

         end else
            if corobil>=0 then begin corobi:=corobil; corobil:=-1; end
               else corobi:=cr_stoi;
         end;
     cr_kopie,cr_bije,cr_grzywa:begin {kopie, bije, wali z grzywy}
            {if corobi=cr_kopie then ani:=8
               else if corobi=cr_bije then ani:=11
                    else if corobi=cr_grzywa then ani:=15;}
            ani:=corobi;
            anisz:=druzyna[team].aniszyb[ani];
            if sila<=7 then anisz:=round(anisz*1.5) else
            if sila<=15 then anisz:=round(anisz*1.25);
            dec(anido);
            if anido<=0 then begin
               anido:=anisz;
               inc(anikl);
               if anikl=druzyna[team].anidzialanie[ani].klatka then begin
                  if ((cochcekopnac=0) and (ktoregochcekopnac>=0) and (koles[ktoregochcekopnac].jest) and (ktoregochcekopnac<>a)) or
                     ((cochcekopnac=1) and (ktoregochcekopnac>=0) and (mieso[ktoregochcekopnac].jest)) or
                     ((cochcekopnac=2) and (ktoregochcekopnac>=0) and (poc[ktoregochcekopnac].jest)) or
                     (cochcekopnac in [3,5]) or
                     ((cochcekopnac=4) and (ktoregochcekopnac>=0) and (zwierz[ktoregochcekopnac].jest))
                     then begin
                      if ((cochcekopnac=0) and
                         not ( {koles, ktorego mial kopnac sie juz odsunal}
                         (koles[ktoregochcekopnac].x>=x+kierunek*druzyna[team].anidzialanie[ani].x-20) and (koles[ktoregochcekopnac].y>=y+druzyna[team].anidzialanie[ani].y-15) and
                         (koles[ktoregochcekopnac].x<=x+kierunek*druzyna[team].anidzialanie[ani].x+20) and (koles[ktoregochcekopnac].y<=y+druzyna[team].anidzialanie[ani].y+15))) or
                         ((cochcekopnac=1) and
                         not ( {mieso, ktore mial kopnac sie juz odsunelo. szukaj innego, ktory tu stoi i kopnij}
                         (mieso[ktoregochcekopnac].x>=x+kierunek*druzyna[team].anidzialanie[ani].x-6) and (mieso[ktoregochcekopnac].y>=y+druzyna[team].anidzialanie[ani].y-6) and
                         (mieso[ktoregochcekopnac].x<=x+kierunek*druzyna[team].anidzialanie[ani].x+6) and (mieso[ktoregochcekopnac].y<=y+druzyna[team].anidzialanie[ani].y+6))) or
                         ((cochcekopnac=2) and
                         not ( {pocisk, ktory mial kopnac sie juz odsunal. szukaj innego, ktory tu stoi i kopnij}
                         (poc[ktoregochcekopnac].x>=x+kierunek*druzyna[team].anidzialanie[ani].x-6) and (poc[ktoregochcekopnac].y>=y+druzyna[team].anidzialanie[ani].y-6) and
                         (poc[ktoregochcekopnac].x<=x+kierunek*druzyna[team].anidzialanie[ani].x+6) and (poc[ktoregochcekopnac].y<=y+druzyna[team].anidzialanie[ani].y+6)))
                         or (cochcekopnac=3)
                        then begin

                         b:=0; {szukaj najblizszego kolesia w tym miejscu}
                         while (b<=max_kol) and
                               not ( (b<>a) and
                               (koles[b].jest) and
                               ((koles[b].x>=x+kierunek*druzyna[team].anidzialanie[ani].x-20) and (koles[b].y>=y+druzyna[team].anidzialanie[ani].y-15) and
                                (koles[b].x<=x+kierunek*druzyna[team].anidzialanie[ani].x+20) and (koles[b].y<=y+druzyna[team].anidzialanie[ani].y+15)))
                               do inc(b);
                         if (warunki.agresja>0) and (b<=max_kol) then begin
                            ktoregochcekopnac:=b;
                            cochcekopnac:=0;
                         end else begin {jesli nie ma zadnego...}
                           b:=0; {szukaj mieska w tym miejscu}
                           while (b<=max_mieso) and
                                 not ((mieso[b].jest) and
                                      (mieso[b].x>=x+kierunek*druzyna[team].anidzialanie[ani].x-6) and (mieso[b].y>=y+druzyna[team].anidzialanie[ani].y-6) and
                                      (mieso[b].x<=x+kierunek*druzyna[team].anidzialanie[ani].x+6) and (mieso[b].y<=y+druzyna[team].anidzialanie[ani].y+6)) do inc(b);
                           if b<=max_mieso then begin
                              ktoregochcekopnac:=b;
                              cochcekopnac:=1;
                           end else begin {jesli nie ma zadnego...}
                             b:=0; {szukaj granatu w tym miejscu}
                             while (b<=max_poc) and
                                   not ((poc[b].jest) and
                                        (poc[b].x>=x+kierunek*druzyna[team].anidzialanie[ani].x-6) and (poc[b].y>=y+druzyna[team].anidzialanie[ani].y-6) and
                                         (poc[b].x<=x+kierunek*druzyna[team].anidzialanie[ani].x+6) and (poc[b].y<=y+druzyna[team].anidzialanie[ani].y+6)) do inc(b);
                             if b<=max_poc then begin
                                ktoregochcekopnac:=b;
                                cochcekopnac:=2;
                             end else begin{jesli nie ma zadnego}
                               b:=0; {szukaj zwierzaka w tym miejscu}
                               while (b<=max_zwierz) and
                                     not ((zwierz[b].jest) and
                                          (zwierz[b].x>=x+kierunek*druzyna[team].anidzialanie[ani].x-6) and (zwierz[b].y>=y+druzyna[team].anidzialanie[ani].y-6) and
                                           (zwierz[b].x<=x+kierunek*druzyna[team].anidzialanie[ani].x+6) and (zwierz[b].y<=y+druzyna[team].anidzialanie[ani].y+6)) do inc(b);
                               if b<=max_zwierz then begin
                                  ktoregochcekopnac:=b;
                                  cochcekopnac:=4;
                               end else begin{jesli nie ma...}
                                 {szukaj kursora myszy w tym miejscu}
                                 if warunki.walka_z_kursorem and
                                    (mysz.x+ekran.px>=x+kierunek*druzyna[team].anidzialanie[ani].x-16) and
                                    (mysz.y+ekran.py>=y+druzyna[team].anidzialanie[ani].y-16) and
                                    (mysz.x+ekran.px<=x+kierunek*druzyna[team].anidzialanie[ani].x+16) and
                                    (mysz.y+ekran.py<=y+druzyna[team].anidzialanie[ani].y+16) then begin
                                    cochcekopnac:=5;
                                    ktoregochcekopnac:=0; //nieistotne, ale musi byc ustawione
                                 end else {jesli nie ma nic}
                                     ktoregochcekopnac:=-1;
                               end;
                             end;
                           end;
                         end;
                      end;

                      {no to teraz kopnij kolesia, jesli jakis tu byl}
                      if ktoregochcekopnac>=0 then begin
                        if (cochcekopnac=0) and (ktoregochcekopnac<=max_kol) then begin
                           koles[ktoregochcekopnac].dx:=kierunek*druzyna[team].anidzialanie[ani].dx+(-1+random*2);
                           koles[ktoregochcekopnac].dy:=druzyna[team].anidzialanie[ani].dy+(-1+random*2);
                           if (random(6-warunki.agresja div 2)=0) then koles[ktoregochcekopnac].zabic:=a;
                           dec(koles[ktoregochcekopnac].sila,trunc((3+random*7)*druzyna[team].silabicia));
                           if (niewidzialnosc>0) and (random(2)=0) then
                              koles[ktoregochcekopnac].corobi:=cr_panika;
                           case corobi of
                             cr_kopie:form1.graj(druzyna[team].dzwieki.Item[7],x,y,8000);
                             cr_bije:form1.graj(druzyna[team].dzwieki.Item[10],x,y,8000);
                             cr_grzywa:form1.graj(druzyna[team].dzwieki.Item[12],x,y,8000);
                           end;

                           for b:=0 to 5+random(10) do begin
                              if random(10)=0 then c:=1 else c:=0;
                              nowysyf(koles[ktoregochcekopnac].x-5+random(10),koles[ktoregochcekopnac].y-7+random(14),
                                      kierunek*(1+random*4),
                                      -random*4,
                                      0,random(5),c,0,true,koles[ktoregochcekopnac].team);
                           end;
                           form1.graj(druzyna[koles[ktoregochcekopnac].team].dzwieki.Item[random(3)],koles[ktoregochcekopnac].x,koles[ktoregochcekopnac].y,10000)
                        end else {jak nie bylo kolesia, to kopnij mieso, jesli tu bylo}
                        if (cochcekopnac=1) and (ktoregochcekopnac<=max_mieso) then begin
                           mieso[ktoregochcekopnac].dx:=kierunek*druzyna[team].anidzialanie[ani].dx+(-1+random*2);
                           mieso[ktoregochcekopnac].dy:=druzyna[team].anidzialanie[ani].dy+(-1+random*2);
                           mieso[ktoregochcekopnac].podpietydo:=-1;
                           case corobi of
                             cr_kopie:form1.graj(druzyna[team].dzwieki.Item[7],x,y,8000);
                             cr_bije:form1.graj(druzyna[team].dzwieki.Item[10],x,y,8000);
                             cr_grzywa:form1.graj(druzyna[team].dzwieki.Item[12],x,y,8000);
                           end;
                        end else {jak nie bylo miesa, to kopnij pocisk, jesli tu byl}
                        if (cochcekopnac=2) and (ktoregochcekopnac<=max_poc) then begin
                           poc[ktoregochcekopnac].dx:=kierunek*druzyna[team].anidzialanie[ani].dx+(-1+random*2);
                           poc[ktoregochcekopnac].dy:=druzyna[team].anidzialanie[ani].dy+(-1+random*2);
                           if (poc[ktoregochcekopnac].x>=x-10) and (poc[ktoregochcekopnac].x<=x+10) then
                              poc[ktoregochcekopnac].x:=x+11*kierunek;
                           case corobi of
                             cr_kopie:form1.graj(druzyna[team].dzwieki.Item[7],x,y,8000);
                             cr_bije:form1.graj(druzyna[team].dzwieki.Item[10],x,y,8000);
                             cr_grzywa:form1.graj(druzyna[team].dzwieki.Item[12],x,y,8000);
                           end;
                           case poc[ktoregochcekopnac].wyglad of
                             1:form1.graj(form1.dzw_bronie_inne.Item[0],x,y,1000);
                             2:form1.graj(form1.dzw_bronie_inne.Item[1],x,y,1300);
                           end;
                        end else {jak nie bylo pocisku, to kopnij zwierzaka, jesli tu byl}
                        {cochcekopnac=3 - nie kopie nic - to bylo do sterowania postacia uzyte}
                        if (cochcekopnac=4) and (ktoregochcekopnac<=max_zwierz) then begin
                           zwierz[ktoregochcekopnac].dx:=kierunek*druzyna[team].anidzialanie[ani].dx+(-1+random*2);
                           zwierz[ktoregochcekopnac].dy:=druzyna[team].anidzialanie[ani].dy+(-1+random*2);
                           case corobi of
                             cr_kopie:form1.graj(druzyna[team].dzwieki.Item[7],x,y,8000);
                             cr_bije:form1.graj(druzyna[team].dzwieki.Item[10],x,y,8000);
                             cr_grzywa:form1.graj(druzyna[team].dzwieki.Item[12],x,y,8000);
                           end;
                           dec(zwierz[ktoregochcekopnac].sila,trunc((3+random*15)*druzyna[team].silabicia));
                           //dec(zwierz[ktoregochcekopnac].sila,3+random(10));
                           for b:=0 to 5+random(10) do begin
                              if random(10)=0 then c:=1 else c:=0;
                              nowysyf(zwierz[ktoregochcekopnac].x-5+random(10),zwierz[ktoregochcekopnac].y-7+random(14),
                                      kierunek*(1+random*2),
                                      -random*2,
                                      0,random(5),c,0,true,-1);
                           end;
                        end else {jak nie bylo zwierzaka, to kopnij kursor jesli tu jest}
                        if warunki.walka_z_kursorem and (cochcekopnac=5) then begin
                           mysz.dx:=round( 4*(kierunek*druzyna[team].anidzialanie[ani].dx+(-1+random*2)) );
                           mysz.dy:=round( 4*(druzyna[team].anidzialanie[ani].dy+(-1+random*2)) );
                           case corobi of
                             cr_kopie:form1.graj(druzyna[team].dzwieki.Item[7],x,y,8000);
                             cr_bije:form1.graj(druzyna[team].dzwieki.Item[10],x,y,8000);
                             cr_grzywa:form1.graj(druzyna[team].dzwieki.Item[12],x,y,8000);
                           end;
                           {for b:=0 to 5+random(10) do begin
                              if random(10)=0 then c:=1 else c:=0;
                              nowysyf(zwierz[ktoregochcekopnac].x-5+random(10),zwierz[ktoregochcekopnac].y-7+random(14),
                                      kierunek*(1+random*2),
                                      -random*2,
                                      0,random(5),c,0,true,-1);
                           end;}
                        end;
                      end;
                  end;
                  ktoregochcekopnac:=-1;
               end;
               if anikl>=druzyna[team].animacje[ani].klatek then begin
                  if corobil>=0 then begin corobi:=corobil; corobil:=-1; end
                     else corobi:=cr_stoi;
                  ani:=0;
               end;
            end;

         end;
     cr_obracasie:begin {obraca sie}
         if dx>0 then dx:=dx-0.005 else
         if dx<0 then dx:=dx+0.005;
         ani:=13;

         anisz:=100 div druzyna[team].animacje[ani].klatek;

         if abs(dx)>abs(dy) then begin
            anido:=trunc(anido-dx);
         end else begin
            anido:=trunc(anido-dy);
         end;
         if anido<0 then begin
            anido:=anido+anisz;
            dec(anikl);
            if anikl<0 then anikl:=druzyna[team].animacje[ani].klatek-1;
         end else
         if anido>=anisz then begin
            anido:=anido-anisz;
            inc(anikl);
            if anikl>=druzyna[team].animacje[ani].klatek then
               anikl:=0;
         end;

         if (abs(dx)<2) and (abs(dy)<2) and (random(20)=0) then corobi:=cr_spada;

         if (anikl>=druzyna[team].animacje[ani].klatek) or (anikl<0) then anikl:=0;
         end;
     cr_spada:begin {spada machajac rekami}
         if dx>0 then dx:=dx-0.01 else
         if dx<0 then dx:=dx+0.01;

         if sila<=7 then krx:=2 else
         if sila<=15 then krx:=1.7 else krx:=1.4;
         if dy>krx then dy:=dy-0.18/druzyna[team].waga;
         ani:=14;
         anisz:=druzyna[team].aniszyb[ani];
         if sila<=7 then anisz:=round(anisz*1.5) else
         if sila<=15 then anisz:=round(anisz*1.25);
         dec(anido);
         if anido<=0 then begin
            anido:=anisz;
            inc(anikl);
            if anikl>=druzyna[team].animacje[ani].klatek then anikl:=0;
         end;

         if ((not pusto_pod) or  //tu bylo (not pusto_pod) or <-sprawdzamy czy lepiej bedzie z AND
            ((abs(dx)<1) and (abs(dy)<1))) and (random(10)=0) then corobi:=cr_stoi;
         if (anikl>=druzyna[team].animacje[ani].klatek) or (anikl<0) then anikl:=0;
         end;
     cr_pokazuje:begin {pokazuje wrogom przeciwnika}
          if (ani=0) and (anido=0) then 
             if (kfg.dymki_kolesi>=1) and
                ((gadaczas=0) or (gadaani<>cr_pokazuje)) and
                (random(3-kfg.dymki_kolesi)=0) then pokaz_dymek(a,corobi);

          if ((ani=1) and (anido=0)) then form1.graj(druzyna[team].dzwieki.Item[13],x,y,7000);
          ani:=corobi;
          anisz:=druzyna[team].aniszyb[ani];
          dec(anido);
          if anido<=0 then begin
             anido:=anisz;
             inc(anikl);

             if (anikl=druzyna[team].anidzialanie[ani].klatka) and (koles[zabic].jest) then begin
                for k:=0 to max_kol do
                    if (k<>a) and (koles[k].jest) and (koles[k].team=team) and (koles[k].zabic=-1) and
                       ( ((koles[k].x>=x-150) and (koles[k].x<=x+150) and
                          (koles[k].y>=y-100) and (koles[k].y<=y+100)) or
                         ((koles[k].x>=koles[zabic].x-150) and (koles[k].x<=koles[zabic].x+150) and
                          (koles[k].y>=koles[zabic].y-100) and (koles[k].y<=koles[zabic].y+100)) ) and
                          ((warunki.walka_ze_swoimi) or (not warunki.walka_ze_swoimi and (koles[zabic].team<>koles[k].team)))
                          then
                          koles[k].zabic:=zabic;
             end;

             if anikl>=druzyna[team].animacje[ani].klatek then begin
                if corobil>=0 then begin corobi:=corobil; corobil:=-1; end
                   else corobi:=cr_stoi;
                ani:=0;
             end;
          end;

         end;
    end;

    if (skocz) and (corobi in [cr_stoi,cr_idzie,cr_biegnie]) and (not pusto_pod) and (abs(dx)<0.5) and (abs(dy)<0.5) and
       (bokiile[0]<=9) then begin
       case corobi of
         cr_stoi:begin
           if sila<=7 then dy:=-1 else
              if sila<=15 then dy:=-2 else
                 dy:=-3;
           end;
         cr_idzie:begin
           if sila<=7 then begin
              dy:=-1.5;
              dx:=kierunek*0.8;
           end else
               if sila<=15 then begin
                  dy:=-2.2;
                  dx:=kierunek*1.1;
               end else begin
                   dy:=-3;
                   dx:=kierunek*1.5;
               end;
           end;
         cr_biegnie:begin
           if sila<=7 then begin
              dy:=-1.8;
              dx:=kierunek;
           end else
               if sila<=15 then begin
                  dy:=-2.7;
                  dx:=kierunek*1.5;
               end else begin
                   dy:=-3.5;
                   dx:=kierunek*1.8;
               end;
           end;
       end;
       corobil:=corobi;
       corobi:=cr_skacze;
       if random(3)=0 then
          form1.graj(druzyna[team].dzwieki.Item[11],x,y,10000);
    end else
        if skocz and ((random(40)=0) or (corobi=cr_skacze)) then skocz:=false;

    { moze znajdz sobie wroga, jak go nie masz? ;-) }
    if (warunki.walka_bez_powodu) and (zabic=-1) and (random(2000-warunki.agresja*200)=0) then begin
       for k:=0 to max_kol do
           if (k<>a) and (koles[k].jest) and
              (((not warunki.walka_ze_swoimi) and (koles[k].team<>team)) or (warunki.walka_ze_swoimi)) and
              (koles[k].x>=x-80) and (koles[k].x<=x+80) and
              (koles[k].y>=y-40) and (koles[k].y<=y+40) then
              zabic:=k;
    end;

    {jesli koles sie pali, to dla pozostalych wokolo powinien stawac sie wrogiem, zeby go ubili :)}
    if palisie and (random(400-warunki.agresja*40)=0) then begin
       for k:=0 to max_kol do
           if (k<>a) and (koles[k].jest) and (random(10)=0) and
              (koles[k].x>=x-80) and (koles[k].x<=x+80) and
              (koles[k].y>=y-40) and (koles[k].y<=y+40) then
              koles[k].zabic:=a;
    end;


    if sila<=0 then begin //SMIERC!
       if (warunki.typ_wody>=1) and (y>=wyswodywx+15) then begin
          if (warunki.typ_wody in [1,3,4,5]) then
             for d:=0 to 2 do form1.graj(form1.dzw_rozne.Item[10+random(2)],x,y,8000);
          form1.graj(druzyna[team].dzwieki.Item[9],x,y,7000);
       end else
           form1.graj(druzyna[team].dzwieki.Item[4],x,y,15000);

       if not juz_sa_zwloki then begin
          k:= nowemieso(x+druzyna[team].miesomiejsca[1].x,
                         y+druzyna[team].miesomiejsca[1].y,
                         dx,dy,
                         1,team,palisie,druzyna[team].miesomiejsca[1].kl,-1,kolor,stopien_spalenia);
          for d:=0 to 5 do
              if d<>1 then
              nowemieso(x+druzyna[team].miesomiejsca[d].x,
                         y+druzyna[team].miesomiejsca[d].y,
                         dx,dy,
                         d,team,palisie,druzyna[team].miesomiejsca[d].kl,k,kolor,stopien_spalenia);
       end;
       if (bron=3) and (amunicja>0) then
         nowemieso(x,
                   y,
                   dx/3+random*3-1.5,dy/3-random*2.3,
                   7,-2,palisie,random(60));

       if sila<=-100 then begin
          nowynapis(trunc(x),trunc(y),Gra_MEGASMIERC);
          inc(gracz.pkt,100+abs(sila));
       end;

       jest:=false;
       inc(gracz.trupow);
       gracz.czas_dzialania_kombo:=10;
       gracz.ostatnia_smierc_x:=trunc(x);
       gracz.ostatnia_smierc_y:=trunc(y);
       inc(gracz.kombo_licznik);

       if tryb_misji.wlaczony then begin
          if (tryb_misji.wygrana_gdy.zginie_min) and (team=tryb_misji.wygrana_gdy.zginie_grupa) then
             inc(tryb_misji.druzyny[tryb_misji.wygrana_gdy.zginie_grupa].zginelo);

          if (tryb_misji.przegrana_gdy.zginie_min) and (team=tryb_misji.przegrana_gdy.zginie_grupa) then
             inc(tryb_misji.druzyny[tryb_misji.przegrana_gdy.zginie_grupa].zginelo);
       end;

    end;

    if (sila<=15) and (random(sila+6)=0) then begin
       if random(10)=0 then c:=1 else c:=0;
       nowysyf(x-3+random(7),y-5+random(11),(random*2-1)*((15-sila)/6),(random*2-1)*((15-sila)/6), 0,random(2),c,0,false,team);
    end;

    if (vars.bron.przenoszenie) and
       (not przenoszony) and
       (x-ekran.px>=mysz.x-15) and
       (x-ekran.px<=mysz.x+15) and
       (y-ekran.py>=mysz.y-15) and
       (y-ekran.py<=mysz.y+15) then przenoszony:=true;

    if przenoszony then begin
       x:=mysz.x+ekran.px;
       y:=mysz.y+ekran.py;
       dx:=(mysz.x-mysz.sx)/2;
       dy:=(mysz.y-mysz.sy)/2;
    end;

    if not jest then begin
       for k:=0 to max_kol do
           if koles[k].zabic=a then begin
              koles[k].zabic:=-1;
              if (abs(koles[k].dy)<2) and (abs(koles[k].dx)<=2.5) and
                 (koles[k].corobi in [cr_stoi,cr_idzie,cr_biegnie,cr_pokazuje,cr_trzyma,cr_wyrzuca]) then begin
                  koles[k].corobil:=koles[k].corobi;
                  koles[k].corobi:=cr_cieszy;
                  koles[k].ani:=0;
                  koles[k].anido:=0;
                  koles[k].anikl:=0;
              end;
           end;
       for k:=0 to max_poc do
           if (poc[k].jest) and (poc[k].rodzaj=18) and (poc[k].rez1=a) then poc[k].rez1:=-1;
       if (ktoretrzymamieso>=0) and (mieso[ktoretrzymamieso].jest) then begin
          mieso[ktoretrzymamieso].trzymaneprzez:=-1;
          ktoretrzymamieso:=-1;
       end;
       if vars.bron.sterowanie=a then vars.bron.sterowanie:=-1;
       if sila>=-10 then koles_wyrzuc_co_trzymasz(a);
    end;

end;
end;

procedure pokaz_tekst_kolesia(n:integer);
var x,y, dx1,dx2,  wys,sz:integer; s:string;
    jast,jastx,jasr:byte; kl: cardinal; ef:cardinal; pk:Tpoint;
begin
s:=druzyna[koles[n].team].aniteksty[koles[n].gadaani][koles[n].gadanr];

if koles[n].gadaczas<=10 then jastx:=koles[n].gadaczas*25
   else
   if koles[n].gadaczas>=95 then jastx:=(100-koles[n].gadaczas)*50
      else jastx:=255;
jasr:=jastx div 2;
jast:=jastx div 3;

sz:=length(s)*6+10;
wys:=10+5;

x:=trunc(koles[n].x)-sz div 4;
y:=trunc(koles[n].y)-15-wys-15;

if x<0 then x:=0;
if y<0 then y:=0;
if x+sz>teren.width then x:=teren.width-sz;
if y+wys>teren.height then y:=teren.height-wys;

x:=x-ekran.px;
y:=y-ekran.py;

dx1:=x+sz div 3-6;
dx2:=x+sz div 3+6;
if dx1<x then dx1:=x;
if dx1>x+sz then dx1:=x+sz;
if dx2<x then dx2:=x;
if dx2>x+sz then dx2:=x+sz;


ef:=effectsrcalpha or effectdiffuse;

form1.PowerDraw1.FillRect(x+1,y+1,sz-2,wys-2,druzyna[koles[n].team].kolor_druzyny or (jast shl 24),ef);

pk:= point(trunc(koles[n].x-ekran.px),trunc(koles[n].y-17-ekran.py));

form1.PowerDraw1.FillPoly( pPoint4( dx1,y+wys-1, dx1,y+wys-1,
                                    pk.X+2, pk.y,
                                    dx2,y+wys-1),
                           cColor1(druzyna[koles[n].team].kolor_druzyny or (jast shl 24)),ef);

kl:=druzyna[koles[n].team].kolor_druzyny or (jasr shl 24);

form1.PowerDraw1.Line( Point(x+1,y), Point(x+sz-1,y), kl,kl,ef);
form1.PowerDraw1.Line( Point(x+sz-1,y+1), Point(x+sz-1,y+wys-1), kl,kl,ef);
form1.PowerDraw1.Line( Point(x+sz-2,y+wys-1), Point(dx2-1,y+wys-1), kl,kl,ef);
form1.PowerDraw1.Line( Point(dx2-1,y+wys-1), pk, kl,kl,ef);
form1.PowerDraw1.Line( pk, Point(dx1,y+wys-1), kl,kl,ef);
form1.PowerDraw1.Line( Point(dx1+1,y+wys-1), Point(x,y+wys-1), kl,kl,ef);
form1.PowerDraw1.Line( Point(x,y+wys-2), Point(x,y), kl,kl,ef);

piszdowolne_dymki(s, x+5,y+2,$00FFFFFF or (jastx shl 24),8,10);

end;


procedure rysuj_kolesi;
var
a:longint;
tr:trect;
bx,by,katbroni:integer;
b,k:byte;
ko,ofx:integer;
col:cardinal;
begin
for a:=max_kol downto 0 do
  if koles[a].jest then with koles[a] do begin
    if niewidzialnosc=0 then col:=$FFFFFFFF
       else begin
            if niewidzialnosc>25 then col:=$08FFFFFF
               else col:=$00FFFFFF or ((255-niewidzialnosc*10) shl 24);
       end;
    if (x+koles_prx-3-ekran.px>=0) and (y+koles_pry-3-ekran.py>=0) and
       (x-koles_prx+3-ekran.px<=ekran.width) and (y-koles_pry-ekran.py<=ekran.height-ekran.menux) then begin
         if anikl>=druzyna[team].animacje[ani].klatek then anikl:=0;
         if kierunek=1 then
            tr:=rect( trunc(x-koles_prx)-ekran.px,trunc(y-koles_pry)-ekran.py,
                      trunc(x-koles_prx)-ekran.px+koles_rx,trunc(y-koles_pry)-ekran.py+koles_ry)
         else
            tr:=rect( trunc(x-koles_prx)-ekran.px+koles_rx,trunc(y-koles_pry)-ekran.py,
                      trunc(x-koles_prx)-ekran.px,trunc(y-koles_pry)-ekran.py+koles_ry);

         form1.PowerDraw1.TextureMap(druzyna[team].animacje[ani].surf, pRect4(tr),
                          cColor1(kolor and col),
                          tPattern(anikl),
                          effectSrcAlpha or effectDiffuse
                          );

         if bron=3 then begin
            {if kierunek=1 then
               tr:=rect( trunc(x+druzyna[team].bronmiejsca[ani][anikl].x)-ekran.px,trunc(y-druzyna[team].bronmiejsca[ani][anikl].y)-ekran.py,
                         trunc(x+druzyna[team].bronmiejsca[ani][anikl].x)-ekran.px+obr.broniekolesi[bron].rx,trunc(y-druzyna[team].bronmiejsca[ani][anikl].y)-ekran.py+obr.broniekolesi[bron].ry)
            else
               tr:=rect( trunc(x-druzyna[team].bronmiejsca[ani][anikl].x)-ekran.px,trunc(y-druzyna[team].bronmiejsca[ani][anikl].y)-ekran.py,
                         trunc(x-druzyna[team].bronmiejsca[ani][anikl].x)-ekran.px-obr.broniekolesi[bron].rx,trunc(y-druzyna[team].bronmiejsca[ani][anikl].y)-ekran.py+obr.broniekolesi[bron].ry);
}
            if (corobi=cr_strzela) and
               ((anikl>=druzyna[team].anidzialanie[ani].klatka) and
                ((anikl<=druzyna[team].anidzialanie[ani].klatka+5) {and (anido>=anisz div 2)})
               ) then b:=1+random(2) else b:=0;

            if (corobi=cr_strzela) and (strzelaWX>=0) then begin
               katbroni := trunc((katStrzalu-90) / 1.40625);
               if kierunek=-1 then katbroni:= katbroni+128;
            end else begin
                if kierunek=1 then katbroni := druzyna[team].bronmiejsca[ani][anikl].kat
                              else katbroni := 256-druzyna[team].bronmiejsca[ani][anikl].kat;
            end;

            if kierunek=1 then
                form1.PowerDraw1.TextureMap(obr.broniekolesi[bron].surf,
                    pRotate4( trunc(x+druzyna[team].bronmiejsca[ani][anikl].x)-ekran.px,
                              trunc(y+druzyna[team].bronmiejsca[ani][anikl].y)-ekran.py,
                              obr.broniekolesi[bron].rx, obr.broniekolesi[bron].ry,
                              6,5, katbroni)
                              , cColor1(col), tPattern(b), effectSrcAlpha or effectDiffuse)
                else
                form1.PowerDraw1.TextureMap(obr.broniekolesi[bron].surf,
                 pRotate4mirror( trunc(x+druzyna[team].bronmiejsca[ani][anikl].x)-ekran.px,
                              trunc(y+druzyna[team].bronmiejsca[ani][anikl].y)-ekran.py,
                              obr.broniekolesi[bron].rx, obr.broniekolesi[bron].ry,
                              34-6,5, katbroni)
                              , cColor1(col), tPattern(b), effectSrcAlpha or effectDiffuse)
         end;

{       for zz:=0 to 5 do
        form1.drawsprajt(druzyna[team].mieso[zz],
             trunc(x-koles_prx+druzyna[team].miesomiejsca[zz].x-druzyna[team].mieso[zz].ofsx)-ekran.px,
             trunc(y-koles_pry+druzyna[team].miesomiejsca[zz].y-druzyna[team].mieso[zz].ofsy)-ekran.py,
             anikl);}

        if palisie then  begin
//           form1.drawsprajtalpha(obr.pocisk[5],trunc(x-obr.pocisk[5].ofsx)-ekran.px-2+random(5),trunc(y-obr.pocisk[5].ofsy)-ekran.py-random(7),random(26),180+random(70));
           if corobi in [cr_stoi,cr_strzela,cr_cieszy,cr_trzyma,cr_kopie,cr_bije,cr_wyrzuca,cr_spada,cr_grzywa,cr_pokazuje] then begin
              ko:=256;
              ofx:=0;
           end else
               if kierunek>0 then begin
                  ko:=192;
                  ofx:=-6;
               end else begin
                   ko:=64;
                   ofx:=6;
                   end;

           for k:=0 to 1 do
              form1.PowerDraw1.TextureMap(obr.pocisk[5].surf,
                         {pBounds4(
                         trunc(x-obr.pocisk[5].ofsx)-ekran.px-2+random(5),
                         trunc(y-obr.pocisk[5].ofsy)-ekran.py-random(7)-3+k*8,
                          obr.pocisk[5].rx, obr.pocisk[5].ry),}
                         pRotate4c(
                         trunc(x)-ekran.px-1+random(3)+ofx,
                         trunc(y)-ekran.py-random(5)-3+k*8,
                          obr.pocisk[5].rx, obr.pocisk[5].ry, random(30)-15+ko),
                         cColor1( cardinal( (180+random(70)) shl 24+$FFFFFF ) ),
                         tPattern(random(26)),
                         effectSrcAlpha or effectDiffuse);
        end;

     {   if zebrac>=0 then
           form1.PowerDraw1.Line(point(trunc(x)-ekran.px,trunc(y)-ekran.py),
                                 point(trunc(przedm[zebrac].x)-ekran.px,trunc(przedm[zebrac].y)-ekran.py),
                                 $c00000ff,$100000ff, effectSrcAlpha);
        if zabic>=0 then
           form1.PowerDraw1.Line(point(trunc(x)-ekran.px,trunc(y)-ekran.py),
                                 point(trunc(koles[zabic].x)-ekran.px,trunc(koles[zabic].y)-ekran.py),
                                 $c000ff00,$1000ff00, effectSrcAlpha); }

        if vars.bron.sterowanie=a then begin
           b:=trunc(_sin(unitgraglowna.licznik2*4)*$60+$90);
           form1.PowerDraw1.RenderEffectCol(
               obr.wskaznik2.surf,trunc(x)-ekran.px-obr.wskaznik2.ofsx,trunc(y-koles_pry-14-trunc(abs(_sin(unitgraglowna.licznik2*6)*6)))-ekran.py,
                      cardinal((b shl 24) or druzyna[team].kolor_druzyny), 0,
                      effectSrcAlpha or effectDiffuse);
        end;

  end else begin
      bx:=trunc(x)-ekran.px;
      by:=trunc(y)-ekran.py;
      if bx<0 then bx:=0;
      if by<0 then by:=0;
      if bx>ekran.width-1 then bx:=ekran.width-1;
      if by>ekran.height-ekran.menux then by:=ekran.height-ekran.menux-1;
      form1.PowerDraw1.RenderEffectcol(obr.wskaznik.surf, bx-obr.wskaznik.ofsx,by-obr.wskaznik.ofsy, col and $7fffffff, 0, effectSrcAlpha or effectDiffuse);
  end;
end;

if kfg.wskazniki_kolesi then
  for a:=max_kol downto 0 do
    if koles[a].jest then   with koles[a] do begin
       if (x+koles_prx-3-ekran.px>=0) and (y+koles_pry-3-ekran.py>=0) and
          (x-koles_prx+3-ekran.px<=ekran.width) and (y-koles_pry-ekran.py<=ekran.height-ekran.menux) then begin
           if niewidzialnosc=0 then col:=$8CFFFFFF
              else begin
                 if niewidzialnosc>25 then col:=$00FFFFFF
                    else col:=$00FFFFFF or (($8C-niewidzialnosc*5) shl 24);
              end;
           if sila>0 then begin
               bx:=trunc((sila/druzyna[team].startsila)*24);
               if bx>24 then bx:=24;
               tr:=rect( trunc(x-koles_prx+6)-ekran.px, trunc(y-koles_pry-6)-ekran.py,
                         trunc(x-koles_prx+6)-ekran.px+bx,trunc(y-koles_pry-6)-ekran.py+3);
               form1.PowerDraw1.TextureMap(
                  obr.energia.surf, pRect4(tr), ccolor1(col), tPattern(0), effectSrcAlpha or effectDiffuse);
           end;
           if amunicja>0 then begin
               bx:=trunc((amunicja/druzyna[team].maxamunicji[bron])*24);
               if bx>24 then bx:=24;
               tr:=rect( trunc(x-koles_prx+6)-ekran.px, trunc(y-koles_pry-9)-ekran.py,
                         trunc(x-koles_prx+6)-ekran.px+bx,trunc(y-koles_pry-9)-ekran.py+3);
               form1.PowerDraw1.TextureMap(
                  obr.energia.surf, pRect4(tr), ccolor1(col), tPattern(1), effectSrcAlpha or effectDiffuse);
           end;

           if tlen<druzyna[team].maxtlen then begin
               bx:=trunc((tlen/druzyna[team].maxtlen)*24);
               if bx>24 then bx:=24;
               tr:=rect( trunc(x-koles_prx+6)-ekran.px, trunc(y-koles_pry-12)-ekran.py,
                         trunc(x-koles_prx+6)-ekran.px+bx,trunc(y-koles_pry-12)-ekran.py+3);
               form1.PowerDraw1.TextureMap(
                  obr.energia.surf, pRect4(tr), ccolor1(col), tPattern(2), effectSrcAlpha or effectDiffuse);
           end;

           {piszwaskie(l2t(stopien_spalenia,0),trunc(x-koles_prx)-ekran.px,
                     trunc(y-koles_pry-40)-ekran.py);}

           tr:=rect( trunc(x-koles_prx)-ekran.px,
                     trunc(y-koles_pry-12)-ekran.py,
                     trunc(x-koles_prx+obr.znakteam.rx)-ekran.px,
                     trunc(y-koles_pry-12)-ekran.py+obr.znakteam.ry);
           form1.PowerDraw1.TextureMap(
                  obr.znakteam.surf, pRect4(tr), ccolor1(cardinal((col and $FF000000) or druzyna[team].kolor_druzyny)), tPattern(0), effectSrcAlpha or effectDiffuse);
        end;
    end;

//teksty w dymkach:
  for a:=max_kol downto 0 do
    if koles[a].jest then  with koles[a] do begin
       if (x+koles_prx-3-ekran.px>=0) and (y+koles_pry-3-ekran.py>=0) and
          (x-koles_prx+3-ekran.px<=ekran.width) and (y-koles_pry-ekran.py<=ekran.height-ekran.menux) then begin
          if koles[a].gadaczas>0 then pokaz_tekst_kolesia(a);
       end;
    end;

end;


{--------------------------wejscia kolesi--------------------------------------}

procedure dodaj_wejscie(x,y:integer);
var a:integer;
begin
if druzynymenu.ilewejsc<max_wejsc then begin
   inc(druzynymenu.ilewejsc);
   wejscia[druzynymenu.ilewejsc].x:=x;
   wejscia[druzynymenu.ilewejsc].y:=y;
   for a:=0 to max_druzyn do
       wejscia[druzynymenu.ilewejsc].druzyny[a]:=false;
   wejscia[druzynymenu.ilewejsc].czest:=10;
   wejscia[druzynymenu.ilewejsc].proc:=100;

   druzynymenu.wejsciewybrane:=druzynymenu.ilewejsc;
end;

end;

procedure usun_wejscie(n:integer);
var a,b:integer;
begin
if (druzynymenu.ilewejsc>0) and (n<=max_wejsc) then begin
   for b:=n to max_wejsc-1 do begin
       wejscia[b].x:=wejscia[b+1].x;
       wejscia[b].y:=wejscia[b+1].y;
       for a:=0 to max_druzyn do
           wejscia[b].druzyny[a]:=wejscia[b+1].druzyny[a];
       wejscia[b].czest:=wejscia[b+1].czest;
       wejscia[b].proc:=wejscia[b+1].proc;
   end;
   dec(druzynymenu.ilewejsc);
   if druzynymenu.wejsciewybrane>druzynymenu.ilewejsc then
      druzynymenu.wejsciewybrane:=druzynymenu.ilewejsc;
end;

end;

procedure dzialaj_wejscia;
var a:integer;
begin
if bron.glownytryb=3 then bron.glownytryb:=0;
for a:=1 to druzynymenu.ilewejsc do with wejscia[a] do begin
    if (((mysz.x+ekran.px>=x-15) and (mysz.y+ekran.py>=y-15) and
         (mysz.x+ekran.px<=x+15) and (mysz.y+ekran.py<=y+15) and
         (druzynymenu.wejscieruszane=0))
         or
         (druzynymenu.wejscieruszane=a)
       ) and
       ((mysz.l) or (mysz.r)) then begin
       druzynymenu.wejsciewybrane:=a;
       if mysz.l then begin
          bron.glownytryb:=3;
          druzynymenu.wejscieruszane:=a;
          wejscia[druzynymenu.wejsciewybrane].x:=mysz.x+ekran.px;
          wejscia[druzynymenu.wejsciewybrane].y:=mysz.y+ekran.py;
       end;
    end;
    ani:=ani+0.3+random*0.05;
    if ani>=30 then ani:=ani-30;
end;
if (bron.glownytryb<>3) and (druzynymenu.wejscieruszane>=1) then druzynymenu.wejscieruszane:=0;
end;

procedure pokazuj_wejscia;
var a,bx,by:integer; c:cardinal;
begin
for a:=1 to druzynymenu.ilewejsc do with wejscia[a] do begin
    if (x+20-ekran.px>=0) and (y+20-ekran.py>=0) and
       (x-20-ekran.px<=ekran.width) and (y-20-ekran.py<=ekran.height-ekran.menux) then begin
       if (menju.widoczne=4) and (druzynymenu.wejsciewybrane=a) then c:=$ff0050FF
          else c:=$ffffffff;
       form1.PowerDraw1.RenderEffectCol(obr.wejscie.surf, x-ekran.px-20,y-ekran.py-20,c,trunc(ani),effectSrcAlpha or effectDiffuse);
{       if sypie then
          form1.PowerDraw1.RenderEffectCol(obr.wejscie.surf, x-ekran.px-15,y-ekran.py-15,$FF00FF00,random(3),effectSrcAlpha or effectDiffuse);}
    end else begin
        bx:=trunc(x)-ekran.px;
        by:=trunc(y)-ekran.py;
        if bx<0 then bx:=0;
        if by<0 then by:=0;
        if bx>ekran.width-1 then bx:=ekran.width-1;
        if by>ekran.height-ekran.menux then by:=ekran.height-ekran.menux-1;
        if (menju.widoczne=4) and (druzynymenu.wejsciewybrane=a) then c:=$f00040F0
           else c:=$80f0A010;
        form1.PowerDraw1.RenderEffectCol(obr.wskaznik.surf,bx-obr.wskaznik.ofsx,by-obr.wskaznik.ofsy,c,0,effectsrcalpha or effectdiffuse);
    end;
end;

end;

procedure tworz_kolesi_jak_trzeba;
var
a,b,il,g,x:integer;
zrodla:array[0..max_wejsc] of byte;
begin
{obliczaj procent kolesi w kazdej z druzyn}
for a:=0 to max_druzyn do begin
    if druzyna[a].ma_byc_kolesi=0 then druzyna[a].jest_procent:=0
       else druzyna[a].jest_procent:=byte((100*druzyna[a].jest_kolesi) div druzyna[a].ma_byc_kolesi);
end;

for a:=0 to druzynymenu.ilewejsc do begin
    {zmniejszaj czas do wyrzucenia nastepnego kolesia}
    if wejscia[a].donastepnego>0 then dec(wejscia[a].donastepnego);
    {wlaczaj zrodlo, jesli zostal juz odpowiedni procent druzyny}
    for b:=0 to max_druzyn do
        if ((a=0) or (wejscia[a].druzyny[b])) and
           (druzyna[b].jest_procent<=wejscia[a].proc) then wejscia[a].sypie[b]:=true
        else
        if ((a=0) or (wejscia[a].druzyny[b])) and
           (druzyna[b].jest_kolesi>=druzyna[b].ma_byc_kolesi) then wejscia[a].sypie[b]:=false
end;

for a:=0 to max_druzyn do
    if druzyna[a].jest_kolesi<druzyna[a].ma_byc_kolesi then begin
       il:=-1;
       if druzynymenu.lecatezzgory and (wejscia[0].donastepnego=0) and
          (wejscia[0].sypie[a]) then begin inc(il); zrodla[il]:=0; end;

       for b:=1 to druzynymenu.ilewejsc do
           if (wejscia[b].druzyny[a]) and (wejscia[b].donastepnego=0) and
              (wejscia[b].sypie[a]) then begin inc(il); zrodla[il]:=b; end;

       if il>=0 then begin
          g:=zrodla[random(il+1)];

           if g=0 then begin
              b:=0;
              repeat
                 x:=random(teren.Width-koles_rx)+koles_prx;
                 inc(b);
              until (b>30) or (teren.maska[x,0]=0);
              if b>30 then begin
                 x:=random(teren.Width-koles_rx)+koles_prx;
                 nowykoles(x,-30,0,0,-1,a)
              end else
                 nowykoles(x,-20,0,0,-1,a);
              form1.graj(form1.dzw_rozne.Item[12],x,-20,2000);
              wejscia[g].donastepnego:=wejscia[g].czest;
           end else begin
               nowykoles(wejscia[g].x,wejscia[g].y,0,0,-1,a);
               nowywybuchdym(wejscia[g].x,wejscia[g].y,0,0,0,wd_swiatlo,1,70+random(50),70,druzyna[a].kolor_druzyny);
               form1.graj(form1.dzw_rozne.Item[12],wejscia[g].x,wejscia[g].y,2000);
               wejscia[g].donastepnego:=wejscia[g].czest;
               end;
       end;
    end;








{
for a:=0 to max_druzyn do
    if druzyna[a].jest_kolesi<druzyna[a].ma_byc_kolesi then begin
       il:=-1;
       if druzynymenu.lecatezzgory and (wejscia[0].donastepnego=0) then begin inc(il); zrodla[il]:=0; end;

       for b:=1 to druzynymenu.ilewejsc do
           if (wejscia[b].druzyny[a]) and (wejscia[b].donastepnego=0) then begin inc(il); zrodla[il]:=b; end;

       if il>=0 then begin
          g:=zrodla[random(il+1)];

           if g=0 then begin
              b:=0;
              repeat
                 x:=random(teren.Width-koles_rx)+koles_prx;
                 inc(b);
              until (b>30) or (teren.maska[x,0]=0);
              if b>30 then begin
                 x:=random(teren.Width-koles_rx)+koles_prx;
                 nowykoles(x,-30,0,0,-1,a)
              end else
                 nowykoles(x,-20,0,0,-1,a);
              form1.graj(form1.dzw_rozne.Item[8],x,-20,2000);
              wejscia[g].donastepnego:=wejscia[g].czest;
           end else begin
               nowykoles(wejscia[g].x,wejscia[g].y,0,0,-1,a);
               form1.graj(form1.dzw_rozne.Item[8],wejscia[g].x,wejscia[g].y,2000);
               wejscia[g].donastepnego:=wejscia[g].czest;
               end;
       end;
    end;
}
end;

end.
