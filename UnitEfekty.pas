unit UnitEfekty;

interface
uses Graphics, Types, vars, sysutils, sinusy;

    procedure wybuch(sx,sy, rozm:real; dziura,osmala,rozrzut,zapala:boolean; czyj_byl_pocisk:integer; tylko_jeden:boolean; liczpunkty:boolean=true);
    procedure rozrzuc(sx,sy,rozm:real; s:integer; ran,zapala:boolean; czyj_byl_pocisk:integer; tylko_jeden:boolean; liczpunkty:boolean=true);

    procedure laser(sx,sy, dx,dy:real; moc:byte; odbijasie,zapala:boolean);
    procedure piorun(sx,sy, kat:real; moc:byte; liczpunkty:boolean=true);
    procedure rysuj_lasery_itd;
    procedure rysuj_piorun;

    procedure piluj;
    procedure wal_mlotkiem(sila:real);

    procedure zemsta_wypal(sx,sila_:integer);
    procedure zemsta_dzialaj;

    procedure inicjujfale(ilefal:integer);
    procedure plum(x,y, dy:real; szerokosc:integer; sila:real);
    procedure plum_z_piana(sx,sy, rozm,ilepiany:real);
    procedure faledzialaj;
    procedure faledzialaj_pauza;
    procedure woda_wrzyj;
    function wyswody(x:real):integer;

    procedure nowezwlokikolesi(sx,sy,dx_,dy_,dz_:real; kier_:shortint; team_:byte; palisie_:boolean);
    procedure ruszaj_zwlokikolesi;
    procedure rysuj_zwlokikolesi;

const
  fal_zoomx=5;
  fal_zoomy=5;

var
fal_gestosc:array[1..5] of record
  g1:real;
  g2:real;
end=(
 {woda} ( g1:0.9857; g2:40 ),
 {lawa} ( g1:0.960; g2:70 ),
 {kwas} ( g1:0.981; g2:43 ),
 {krew} ( g1:0.979; g2:45 ),
 {blot} ( g1:0.975; g2:63 ) );

var
  fale:array of record y,dy:real; end;
  faleilosc:integer;

  zwlokikolesi:array of record
     jest: boolean;

     x,y,z,
     dx,dy,dz: real;
     klatka_ani,
     szybkosc_ani: real;
     team: byte;

     palisie:boolean;

     kier: shortint;
  end;

implementation
uses unit1, unitsyfki, unitmiesko, pdrawex, powertypes, d3d9, unitkolesie, unitwybuchy, unitmisje, unitrysowanie, UnitGraGlowna;


procedure rysuj_dziure(sx,sy,r:integer; dziura:boolean);
var
x,y:integer;

d:integer;
bylo:array of byte;
kr,kg,kb:byte;
tm:integer;

 LRect: TD3DLocked_Rect;
 DestPtr:Pointer;

 procedure hline_x(x1,x2,y:integer);
 var x,xx:integer; g:array[0..319] of cardinal; c1:integer; dz,rys,dzm:boolean;
 begin
 if x1<0 then x1:=0;
 if x2>teren.width-1 then x2:=teren.width-1;
 //if x2<x1 then exit;

 DestPtr:= Pointer(Integer(LRect.Bits) + (LRect.Pitch * y) + (x1 * obr.teren.surf.BytesPerPixel));
 pdrawlineConv(DestPtr, @g, x2-x1+1, obr.teren.surf.Format, D3DFMT_A8R8G8B8);

 xx:=0;
 for x:=x1 to x2 do begin
         dz:=false;
         dzm:=false;

         rys:=(g[xx] and $FF000000)<>0;

         c1:=trunc( ((( cos((sy-y)*(pi180/r*70)) + cos((sx-x)*(pi180/r*70)) )*130)-120) );
//         c1:=trunc(c1*(r/40))-r;
         if c1<0 then c1:=0
            else
            if c1>255 then c1:=255;

         if (dziura) and (c1>104) then begin
            if (teren.maska[x,y]=1) then dz:=true;
            if (teren.maska[x,y]=0) and (rys) then dzm:=true;
            if (teren.maska[x,y]>=1) and (teren.maska[x,y]<10) then
               dec(teren.maska[x,y]);
         end;

         if (dziura) and (
            ((c1>75) and (dz)) or
            ((c1>125) and (dzm)) ) then begin
            g[xx]:=$00ffffff;
         end else if rys then begin
            if (teren.maska[x,y]=0) and (rys) then c1:=c1-40
               else c1:=c1-20;
            if c1<0 then c1:=0;
            kr:=(g[xx] and $FF0000) shr 16;
            kg:=(g[xx] and $FF00) shr 8;
            kb:=g[xx] and $FF;

            if (kr>40) or (kg>40) or (kb>40) then begin
                tm:=kr-c1;
                if tm<0 then kr:=0
                        else kr:=tm;

                tm:=kg-c1;
                if tm<0 then kg:=0
                        else kg:=tm;

                tm:=kb-c1;
                if tm<0 then kb:=0
                        else kb:=tm;
            end;
            g[xx]:= cardinal( ($FF shl 24) or (kr shl 16) or (kg shl 8) or kb );
            end;

         //if rys or dz or dzm then

            //pdrawFormatConv(@g, DestPtr, D3DFMT_A8R8G8B8, obr.teren.surf.Format);

         inc(xx);
 end;
 //if rys or dz or dzm then
    pdrawlineConv(@g, DestPtr, x2-x1+1, D3DFMT_A8R8G8B8, obr.teren.surf.Format);

 end;


begin
obr.teren.surf.Lock(0, LRect);
setlength(bylo,teren.height);

x:=0;
y:=r;
d:=3-2*r;

   repeat
     if (sy+y>=0) and (sy+y<teren.height) and ((sx+x)-(sx-x)>=1) and (bylo[sy+y]=0) then begin
       hline_x(sx-x,sx+x,sy+y);
       bylo[sy+y]:=1;
     end;
     if (sy-y>=0) and (sy-y<teren.height) and ((sx+x)-(sx-x)>=1) and (bylo[sy-y]=0) then begin
       hline_x(sx-x,sx+x,sy-y);
       bylo[sy-y]:=1;
     end;
     if (sy+x>=0) and (sy+x<teren.height) and ((sx+y)-(sx-y)>=1) and (bylo[sy+x]=0) then begin
       hline_x(sx-y,sx+y,sy+x);
       bylo[sy+x]:=1;
     end;
     if (sy-x>=0) and (sy-x<teren.height) and ((sx+y)-(sx-y)>=1) and (bylo[sy-x]=0) then begin
       hline_x(sx-y,sx+y,sy-x);
       bylo[sy-x]:=1;
     end;
     inc(x);
     if d>=0 then begin
        dec(y);
        d:=d+2*(2*x-2*y+1);
     end else d:=d+2*(2*x+1)
   until x>y;

obr.teren.surf.unLock(0);
end;

procedure wybuch(sx,sy, rozm:real; dziura,osmala,rozrzut,zapala:boolean; czyj_byl_pocisk:integer; tylko_jeden:boolean; liczpunkty:boolean=true);
var
a,b,wx:integer;
rozm2:real;
begin
rozm2:=rozm/2;

if dziura or osmala then rysuj_dziure(trunc(sx),trunc(sy),trunc(rozm/1.3),dziura);

if rozrzut then begin
   rozrzuc(sx,sy,rozm/2,1,true,zapala,czyj_byl_pocisk,tylko_jeden, liczpunkty);
   if (rozm>10) and (dziura) then begin
      ekran.iletrzes:=ekran.iletrzes+trunc(rozm/3);
      rozm2:=(trunc(rozm/3)-3+random(7))/150;
      if rozm2>ekran.silatrzes then ekran.silatrzes:=rozm2/2;
      if ekran.iletrzes>50 then ekran.iletrzes:=50-random(5);

      if (kfg.swiatla) then begin
          a:=1;
          while (a<=ile_swiatel) do begin
              if (swiatla[a].zniszczalne) and
                 (sqrt2(sqr(swiatla[a].x-sx)+sqr(swiatla[a].y-sy))<=rozm/2) then begin
                 usun_swiatlo(a);
                 dec(a);
              end;
              inc(a);
          end;
      end;

      plum_z_piana(sx,sy,rozm,1);


   end;
end;
end;

procedure rozrzuc(sx,sy,rozm:real; s:integer; ran,zapala:boolean; czyj_byl_pocisk:integer; tylko_jeden:boolean; liczpunkty:boolean=true);
var
a,b,c:integer;
kp,k1,k2,d, rozm2, mx,my:real;
begin
rozm2:=rozm*3;
    for a:=0 to max_kol do begin
        if (koles[a].jest) and
           (koles[a].sila>0) and
           (koles[a].x>=sx-rozm2) and
           (koles[a].x<=sx+rozm2) and
           (koles[a].y>=sy-rozm2) and
           (koles[a].y<=sy+rozm2) then begin
           while (koles[a].x=sx) and (koles[a].y=sy) do begin
              koles[a].x:=koles[a].x-0.1+random/5; {jesli postac jest dokladnie w centrum    }
              koles[a].y:=koles[a].y-0.1+random/5; {to przesun ja troche, zeby nie bylo RE207}
           end;
           kp:=sqrt2(abs(sqr(koles[a].x-sx)+sqr(koles[a].y-sy)));
           k1:=(koles[a].x-sx)/kp;
           k2:=(koles[a].y-sy)/kp;
           d:=trunc(rozm2-kp);
           if d>0 then begin
              koles[a].dx:=koles[a].dx+k1*s*d/10;
              koles[a].dy:=koles[a].dy+k2*s*d/15;
              if koles[a].dx>20 then koles[a].dx:=20
                 else if koles[a].dx<-20 then koles[a].dx:=-20;
              if koles[a].dy>20 then koles[a].dy:=20
                 else if koles[a].dy<-20 then koles[a].dy:=-20
           end;
           if (zapala) and (d>0) and (random(2)=0) then begin
              if (czyj_byl_pocisk=-2) and liczpunkty then inc(gracz.pkt,60);
              koles[a].palisie:=true;
           end;
           if (ran) and (d>0) then begin
              if czyj_byl_pocisk=-2 then c:=koles[a].sila;
              koles[a].sila:=koles[a].sila-trunc(d);
              if czyj_byl_pocisk=-2 then begin
                 c:=c-koles[a].sila;
                 if koles[a].sila<0 then c:=c-koles[a].sila;
                 if liczpunkty then inc(gracz.pkt,c);
              end;
              for b:=0 to trunc(d*0.8)+random(10) do begin
                  if random(10)=0 then c:=1 else c:=0;
                  nowysyf(koles[a].x-5+random(10),koles[a].y-7+random(14),
                          random*2-1{+(koles[a].x-sx)*(d/600)},
                          random*2-1{2.5+(koles[a].y-sy)*(d/600)},
                          0,random(5),c,0,true, koles[a].team);
              end;

              if kfg.detale>=2 then begin
                  b:=round(60+d*7);
                  if b>350 then b:=350;
                  nowywybuchdym(koles[a].x,koles[a].y,
                                k1*s*d/70,k2*s*d/80-0.5,
                                0,wd_krew,random(3),
                                random(2)*(180+random(70)),b,
                                druzyna[koles[a].team].kolor_krwi,true);
              end;

              if koles[a].sila<=0 then begin
                  if (koles[a].sila>=-10) then begin
                      c:=1;
                      b:=nowemieso(koles[a].x+druzyna[koles[a].team].miesomiejsca[c].x,
                                 koles[a].y+druzyna[koles[a].team].miesomiejsca[c].y,
                                 (druzyna[koles[a].team].miesomiejsca[c].x-koles_prx)/20,
                                 (druzyna[koles[a].team].miesomiejsca[c].y-koles_pry)/20,
                                 c,koles[a].team,koles[a].palisie,druzyna[koles[a].team].miesomiejsca[c].kl,-1,koles[a].kolor,koles[a].stopien_spalenia);
                      for c:=0 to 5 do
                      if c<>1 then
                       nowemieso(koles[a].x+druzyna[koles[a].team].miesomiejsca[c].x,
                                 koles[a].y+druzyna[koles[a].team].miesomiejsca[c].y,
                                 (druzyna[koles[a].team].miesomiejsca[c].x-koles_prx)/20,
                                 (druzyna[koles[a].team].miesomiejsca[c].y-koles_pry)/20,
                                 c,koles[a].team,koles[a].palisie,druzyna[koles[a].team].miesomiejsca[c].kl,b,koles[a].kolor,koles[a].stopien_spalenia);
                   end else
                   if (koles[a].sila>-100) then begin
                      if random(10)=0 then begin //wywal kolesia w strone gracza
                         nowezwlokikolesi(koles[a].x,koles[a].y,
                                          koles[a].dx/3,
                                          koles[a].dy/3,
                                          random/3,koles[a].kierunek,
                                          koles[a].team, koles[a].palisie);
                      end else begin //zabij tradycyjnie
                        c:=1;
                        b:=nowemieso(koles[a].x+druzyna[koles[a].team].miesomiejsca[c].x,
                                   koles[a].y+druzyna[koles[a].team].miesomiejsca[c].y,
                                   (druzyna[koles[a].team].miesomiejsca[c].x-koles_prx)/6,
                                   (druzyna[koles[a].team].miesomiejsca[c].y-koles_pry)/6,
                                   c,koles[a].team,koles[a].palisie,druzyna[koles[a].team].miesomiejsca[c].kl,-1,koles[a].kolor,koles[a].stopien_spalenia);
                        for c:=0 to 5 do
                        if c<>1 then
                         nowemieso(koles[a].x+druzyna[koles[a].team].miesomiejsca[c].x,
                                   koles[a].y+druzyna[koles[a].team].miesomiejsca[c].y,
                                   (druzyna[koles[a].team].miesomiejsca[c].x-koles_prx)/6,
                                   (druzyna[koles[a].team].miesomiejsca[c].y-koles_pry)/6,
                                   c,koles[a].team,koles[a].palisie,druzyna[koles[a].team].miesomiejsca[c].kl,b,koles[a].kolor,koles[a].stopien_spalenia);
                      end;
                   end else begin
                       if liczpunkty then inc(gracz.pkt,40);
                       for c:=0 to 4+random(5) do
                           nowywybuchdym(koles[a].x-5+random(11),koles[a].y-5+random(11),
                                         random/2-0.25,-random,
                                         0,wd_dym,1+random(6),(170+random(80)),70+random(250));

                       end;

                 if liczpunkty then inc(gracz.pkt,abs(koles[a].sila div 2));
                 koles[a].juz_sa_zwloki:=true;
              end;

              if (warunki.typ_wody=0) or (koles[a].y<warunki.wys_wody+15) then
                 form1.graj(druzyna[koles[a].team].dzwieki.Item[random(3)],koles[a].x,koles[a].y,10000)
                 else form1.graj(druzyna[koles[a].team].dzwieki.Item[8],koles[a].x,koles[a].y,5000);
                     //form1.graj(form1.dzw_rozne.Item[2],koles[a].x,koles[a].y,8000);
              if (czyj_byl_pocisk>=0) and (czyj_byl_pocisk<>a) and (koles[czyj_byl_pocisk].jest) then begin
                 if (random(6-warunki.agresja div 2)=0) then koles[a].zabic:=czyj_byl_pocisk;
              end;

              if (kfg.dymki_kolesi>=1) and (koles[a].gadaczas=0) and
                 (czyj_byl_pocisk>=0) and (czyj_byl_pocisk<>a) and (koles[czyj_byl_pocisk].jest) and (koles[czyj_byl_pocisk].team=koles[a].team) then
                 if (random(10-kfg.dymki_kolesi*3)=0) then pokaz_dymek(a,cr_idzie); //zdrajca!

           end;
           if tylko_jeden then break;
        end;
    end;
    for a:=0 to max_poc do begin
        if (poc[a].jest) and
           (poc[a].x>=sx-rozm2) and
           (poc[a].x<=sx+rozm2) and
           (poc[a].y>=sy-rozm2) and
           (poc[a].y<=sy+rozm2) then begin
           while (poc[a].x=sx) and (poc[a].y=sy) do begin
              poc[a].x:=poc[a].x-0.1+random/5; {jesli postac jest dokladnie w centrum    }
              poc[a].y:=poc[a].y-0.1+random/5; {to przesun ja troche, zeby nie bylo RE207}
           end;
           kp:=sqrt2(abs(sqr(poc[a].x-sx)+sqr(poc[a].y-sy)));
           k1:=(poc[a].x-sx)/kp;
           k2:=(poc[a].y-sy)/kp;
           d:=trunc(rozm2-kp);
           if d>0 then begin
              poc[a].dx:=poc[a].dx+k1*s*d/7/poc[a].waga;
              poc[a].dy:=poc[a].dy+k2*s*d/10/poc[a].waga;
              if poc[a].dx>20 then poc[a].dx:=20
                 else if poc[a].dx<-20 then poc[a].dx:=-20;
              if poc[a].dy>20 then poc[a].dy:=20
                 else if poc[a].dy<-20 then poc[a].dy:=-20;
              if (ran) and (d/1.5>=rozm) and (not (poc[a].rodzaj in [2,3,4,5,14,8,10,15,16])) and
                 (poc[a].czasdowybuchu>=1) then
                 poc[a].czasdowybuchu:=4
               else
                 if (ran) and (poc[a].wyglad=20) and (poc[a].czasdowybuchu>=5) then poc[a].czasdowybuchu:=4;
           end;
        end;
    end;
    for a:=0 to max_mina do begin
        if (mina[a].jest) and
           (mina[a].x>=sx-rozm2) and
           (mina[a].x<=sx+rozm2) and
           (mina[a].y>=sy-rozm2) and
           (mina[a].y<=sy+rozm2) then begin
           while (mina[a].x=sx) and (mina[a].y=sy) do begin
              mina[a].x:=mina[a].x-0.1+random/5; {jesli postac jest dokladnie w centrum    }
              mina[a].y:=mina[a].y-0.1+random/5; {to przesun ja troche, zeby nie bylo RE207}
           end;
           kp:=sqrt2(abs(sqr(mina[a].x-sx)+sqr(mina[a].y-sy)));
           k1:=(mina[a].x-sx)/kp;
           k2:=(mina[a].y-sy)/kp;
           d:=trunc(rozm2-kp);
           if d>0 then begin
              mina[a].dx:=mina[a].dx+k1*s*d/50;
              mina[a].dy:=mina[a].dy+k2*s*d/50;
              if mina[a].dx>20 then mina[a].dx:=20
                 else if mina[a].dx<-20 then mina[a].dx:=-20;
              if mina[a].dy>20 then mina[a].dy:=20
                 else if mina[a].dy<-20 then mina[a].dy:=-20;
              if (ran) and (d/1.5>=rozm) then begin
                 mina[a].aktywna:=true;
                 if (mina[a].czasdowybuchu<=3) then mina[a].czasdowybuchu:=3;
                 if (rozm>=90) and (mina[a].czasdowybuchu>3) then mina[a].czasdowybuchu:=3;
              end;
           end;
        end;
    end;
    for a:=0 to max_przedm do begin
        if (przedm[a].jest) and
           (przedm[a].x>=sx-rozm2) and
           (przedm[a].x<=sx+rozm2) and
           (przedm[a].y>=sy-rozm2) and
           (przedm[a].y<=sy+rozm2) then begin
           while (przedm[a].x=sx) and (przedm[a].y=sy) do begin
              przedm[a].x:=przedm[a].x-0.1+random/5; {jesli przedmiot jest dokladnie w centrum }
              przedm[a].y:=przedm[a].y-0.1+random/5; {to przesun go troche, zeby nie bylo RE207}
           end;
           kp:=sqrt2(abs(sqr(przedm[a].x-sx)+sqr(przedm[a].y-sy)));
           k1:=(przedm[a].x-sx)/kp;
           k2:=(przedm[a].y-sy)/kp;
           d:=trunc(rozm2-kp);
           if d>0 then begin
              przedm[a].dx:=przedm[a].dx+k1*s*d/20;
              przedm[a].dy:=przedm[a].dy+k2*s*d/20;
              if przedm[a].dx>20 then przedm[a].dx:=20
                 else if przedm[a].dx<-20 then przedm[a].dx:=-20;
              if przedm[a].dy>20 then przedm[a].dy:=20
                 else if przedm[a].dy<-20 then przedm[a].dy:=-20;
              if (ran) and (d/1.5>=rozm) and
                 ((random(3)=0) or
                  ((rozm2>20) and (kp<rozm/3))
                 ) then przedm[a].rozwal:=true;
           end;
        end;
    end;
    for a:=0 to max_mieso do begin
        if (mieso[a].jest) and
           (mieso[a].x>=sx-rozm2) and
           (mieso[a].x<=sx+rozm2) and
           (mieso[a].y>=sy-rozm2) and
           (mieso[a].y<=sy+rozm2) then begin
           while (mieso[a].x=sx) and (mieso[a].y=sy) do begin
              mieso[a].x:=mieso[a].x-0.1+random/5; {jesli postac jest dokladnie w centrum    }
              mieso[a].y:=mieso[a].y-0.1+random/5; {to przesun ja troche, zeby nie bylo RE207}
           end;
           kp:=sqrt2(abs(sqr(mieso[a].x-sx)+sqr(mieso[a].y-sy)));
           k1:=(mieso[a].x-sx)/kp;
           k2:=(mieso[a].y-sy)/kp;
           d:=trunc(rozm2-kp);
           if d>0 then begin
              if ran and (d>=25) and (random(50)=0) then begin {rozerwij}
                 if mieso[a].team>=-1 then
                 for b:=0 to 10+random(10) do begin
                     if random(6)=0 then c:=1 else c:=0;
                     nowysyf(mieso[a].x-4+random(9),
                             mieso[a].y-4+random(9),
                             mieso[a].dx+k1*s*d/14,
                             mieso[a].dy+k2*s*d/20,
                             0,
                             random(5),c,0,true, mieso[a].team);
                 end;
                 mieso[a].jest:=false;
              end else begin {odrzuc}
                  if (zapala) and (random(2)=0) then mieso[a].palisie:=true;
                  mieso[a].dx:=mieso[a].dx+k1*s*d/14/2;
                  mieso[a].dy:=mieso[a].dy+k2*s*d/20/2;
                  if mieso[a].dx>20 then mieso[a].dx:=20
                     else if mieso[a].dx<-20 then mieso[a].dx:=-20;
                  if mieso[a].dy>20 then mieso[a].dy:=20
                     else if mieso[a].dy<-20 then mieso[a].dy:=-20;
                  if ran and (rozm>=6) and
                     (mieso[a].podpietydo>=0) and (random(10)=0) then mieso[a].podpietydo:=-1;
              end;
           end;
        end;
    end;
    for a:=0 to max_zwierz do begin
        if (zwierz[a].jest) and
           (not zwierz[a].juzzabity) and
           (zwierz[a].x>=sx-rozm2) and
           (zwierz[a].x<=sx+rozm2) and
           (zwierz[a].y>=sy-rozm2) and
           (zwierz[a].y<=sy+rozm2) then begin
           while (zwierz[a].x=sx) and (zwierz[a].y=sy) do begin
              zwierz[a].x:=zwierz[a].x-0.1+random/5; {jesli postac jest dokladnie w centrum    }
              zwierz[a].y:=zwierz[a].y-0.1+random/5; {to przesun ja troche, zeby nie bylo RE207}
           end;
           kp:=sqrt2(abs(sqr(zwierz[a].x-sx)+sqr(zwierz[a].y-sy)));
           k1:=(zwierz[a].x-sx)/kp;
           k2:=(zwierz[a].y-sy)/kp;
           d:=trunc(rozm2-kp);
           if d>0 then begin
              if (zapala) and (random(2)=0) then begin
                 if (czyj_byl_pocisk=-2) and liczpunkty then inc(gracz.pkt,30);
                 zwierz[a].palisie:=true;
              end;
              if ran and (d>0) then begin {rozerwij}

                  if czyj_byl_pocisk=-2 then c:=zwierz[a].sila;
                  zwierz[a].sila:=zwierz[a].sila-trunc(d);
                  if czyj_byl_pocisk=-2 then begin
                     c:=c-zwierz[a].sila;
                     if zwierz[a].sila<0 then c:=c-zwierz[a].sila;
                     if liczpunkty then inc(gracz.pkt,c);
                  end;
                  for b:=0 to trunc(d)+random(10) do begin
                      if random(10)=0 then c:=1 else c:=0;
                      nowysyf(zwierz[a].x-5+random(10),zwierz[a].y-7+random(14),
                              random*2-1+zwierz[a].dx,
                              random*2-1+zwierz[a].dy,
                              0,random(5),c,0,true, -1);
                  end;
                  if zwierz[a].sila<=0 then begin
                     nowemieso(zwierz[a].x,
                               zwierz[a].y,
                               random*2-1,
                               random*2-1,
                               zwierz[a].rodzaj,-1,zwierz[a].palisie,random(60));
                     zwierz[a].juzzabity:=true;
                  end;

              end else begin {odrzuc}
                  if (zapala) and (random(2)=0) then zwierz[a].palisie:=true;
                  zwierz[a].dx:=zwierz[a].dx+k1*s*d/14/2;
                  zwierz[a].dy:=zwierz[a].dy+k2*s*d/20/2;
                  if zwierz[a].dx>20 then zwierz[a].dx:=20
                     else if zwierz[a].dx<-20 then zwierz[a].dx:=-20;
                  if zwierz[a].dy>20 then zwierz[a].dy:=20
                     else if zwierz[a].dy<-20 then zwierz[a].dy:=-20
              end;
           end;
        end;
    end;

    if tryb_misji.wlaczony and ran then begin
        a:=0;
        while a<=high(tryb_misji.flagi) do begin
            with tryb_misji.flagi[a] do begin
                 if (rodz in [2,3]) then begin
                    kp:=sqrt2(abs(sqr(x-sx)+sqr(y-sy)));
                    if kp<rozm then begin
                       for b:=0 to 5+random(10) do
                           nowysyf(x-1+random(3),y-12+random(25),random(360),random/2,1,random(5),1,1,false);

                       usunflage(a);
                       dec(a);
                       inc(tryb_misji.flag_zniszczonych);
                    end;
                 end;
            end;
            inc(a);
        end;

    end;

    for a:=0 to max_syf do begin
        if (syf[a].jest) and
           (syf[a].x>=sx-rozm2) and
           (syf[a].x<=sx+rozm2) and
           (syf[a].y>=sy-rozm2) and
           (syf[a].y<=sy+rozm2) then begin
           while (syf[a].x=sx) and (syf[a].y=sy) do begin
              syf[a].x:=syf[a].x-0.1+random/5; {jesli postac jest dokladnie w centrum    }
              syf[a].y:=syf[a].y-0.1+random/5; {to przesun ja troche, zeby nie bylo RE207}
           end;
           kp:=sqrt2(abs(sqr(syf[a].x-sx)+sqr(syf[a].y-sy)));
           k1:=(syf[a].x-sx)/kp;
           k2:=(syf[a].y-sy)/kp;
           d:=trunc(rozm2-kp);
           if d>0 then begin
              syf[a].dx:=syf[a].dx+k1*s*d/14/3;
              syf[a].dy:=syf[a].dy+k2*s*d/20/3;
              if syf[a].dx>20 then syf[a].dx:=20
                 else if syf[a].dx<-20 then syf[a].dx:=-20;
              if syf[a].dy>20 then syf[a].dy:=20
                 else if syf[a].dy<-20 then syf[a].dy:=-20
           end;
        end;
    end;

    //odrzucenie kursora myszy od pociskow kolesi
    if warunki.walka_z_kursorem and (czyj_byl_pocisk>=0) then begin
       mx:=mysz.x+ekran.px;
       my:=mysz.y+ekran.py;
       if (mx>=sx-rozm2) and
          (mx<=sx+rozm2) and
          (my>=sy-rozm2) and
          (my<=sy+rozm2) then begin
           while (mx=sx) and (my=sy) do begin
              mx:=mx-0.1+random/5; {jesli kursor jest dokladnie w centrum    }
              my:=my-0.1+random/5; {to przesun go troche, zeby nie bylo RE207}
           end;
           kp:=sqrt2(abs(sqr(mx-sx)+sqr(my-sy)));
           k1:=(mx-sx)/kp;
           k2:=(my-sy)/kp;
           d:=trunc(rozm2-kp);
           if d>0 then begin
              mysz.dx:=round(syf[a].dx+k1*s*d/2);
              mysz.dy:=round(syf[a].dy+k2*s*d/2);
              if mysz.dx>20 then mysz.dx:=20
                 else if mysz.dx<-20 then mysz.dx:=-20;
              if mysz.dy>20 then mysz.dy:=20
                 else if mysz.dy<-20 then mysz.dy:=-20
           end;
        end;

    end;

end;

{-----------lasery, prady i rejlgany--------------------}

procedure laser(sx,sy, dx,dy:real; moc:byte; odbijasie,zapala:boolean);
var
juz,trafiony:boolean;
ddx,ddy:real;
dlugosc,k,
x,y,c:integer;
kiedysprawdz, kiedysprawdz2:byte;
wyswodywx:integer;

procedure swiatlo(x,y:real; r:integer);
begin
case bron.wybrana of
  41:begin //laser
     nowywybuchdym(x,y,0,0,0,wd_swiatlo,0,30+random(70),r,$0000FF);
     end;
  42:begin //prad
     nowywybuchdym(x,y,0,0,0,wd_swiatlo,0,30+random(50),r+moc*10,$FF7000+random(120) shl 8+random(200));
     end;
  43:begin //rejlgan
     nowywybuchdym(x,y,0,0,0,wd_swiatlo,0,30+random(40),50+random(50),$FF0000+random(200) shl 8);
     end;
  44:begin //promien ufokow
     nowywybuchdym(x,y,0,0,0,wd_swiatlo,0,30+random(50),r+moc*10,$007000+random(120) shl 8);
     end;
end;
end;

begin
juz:=false;
bron.laserile:=0;
bron.laser[0].x:=trunc(sx);
bron.laser[0].y:=trunc(sy);
bron.laser[0].dx:=dx;
bron.laser[0].dy:=dy;
dlugosc:=0;
kiedysprawdz:=0;
kiedysprawdz2:=licznik2 mod 2;
bron.laser_skonczyl_w_wodzie:=false;
bron.lasermoc:=moc;
repeat
   sx:=sx+dx;
   sy:=sy+dy;

   if (sx+ekran.trzesx>=0) and (sy+ekran.trzesy>=0) and (sx+ekran.trzesx<=teren.width-1) and (sy+ekran.trzesy<=teren.height-1) and
      (dlugosc<bron.laserdlugosc) then begin
      x:=trunc(sx)+ekran.trzesx;
      y:=trunc(sy)+ekran.trzesy;
      wyswodywx:=wyswody(x);
      if teren.maska[x,y]>=1 then begin
         if odbijasie then begin
             sx:=sx-dx;
             sy:=sy-dy;

             ddx:=dx;
             ddy:=dy;

             if dx<0 then k:=1 else k:=-1;
             if (x+k>=0) and (x+k<=teren.width-1) and (teren.maska[x+k,y]>=1) then dx:=-k*abs(dx)
                else if (x-k>=0) and (x-k<=teren.width-1) and (teren.maska[x-k,y]>=1) then dx:=k*abs(dx);

             if dy<0 then k:=1 else k:=-1;
             if (y+k>=0) and (y+k<=teren.height-1) and (teren.maska[x,y+k]>=1) then dy:=-k*abs(dy)
                else if (y-k>=0) and (y-k<=teren.height-1) and (teren.maska[x,y-k]>=1) then dy:=k*abs(dy);

             inc(bron.laserile);
             bron.laser[bron.laserile].x:=x;
             bron.laser[bron.laserile].y:=y;
             bron.laser[bron.laserile].dx:=dx;
             bron.laser[bron.laserile].dy:=dy;
             if random(10)=0 then begin
                swiatlo(x,y,20+random(10));
                if random(5)=0 then
                   wybuch(x,y,5+random(4),false,true,false,zapala,-2,true);
             end;

             if (ddx=-dx) and (ddy=-dy) then begin
                if abs(dx)>=abs(dy) then dx:=dx/2
                   else dy:=dy/2;
             end;
         end else begin
             if (bron.wybrana<>43) then begin//wszystko procz rejlgan
                 juz:=true;
                 if random(5)=0 then swiatlo(x,y,30+random(20));
             end else begin//rejlgan
                 if random(20)=0 then begin
                     juz:=true;
                 end else begin
                     if random(3)=0 then
                        wybuch(x,y,5+random(4),true,true,false,zapala,-2,false);
                     teren.maska[x,y]:=0;
                 end;

                 if random(5)=0 then swiatlo(x,y,30+random(20));
             end;
         end;

      end else begin
          case bron.wybrana of
            41:begin
                if (warunki.typ_wody>=1) and
                   (((sy-dy>=wyswodywx-2) and (sy<wyswodywx-2)) or
                   ((sy-dy<wyswodywx-2) and (sy>=wyswodywx-2)) ) then begin
                     dx:=dx/gestosci[warunki.typ_wody].gest;
                     inc(bron.laserile);
                     bron.laser[bron.laserile].x:=x;
                     bron.laser[bron.laserile].y:=y;
                     bron.laser[bron.laserile].dx:=dx;
                     bron.laser[bron.laserile].dy:=dy;
                end;
               end;
            42:begin
               if (warunki.typ_wody>=1) and (sy>=wyswodywx) and (random(15)=0) then
                  woda_wrzyj;
               end;
          end;
      end;

      if (bron.wybrana=42) and
         (warunki.typ_wody in [1,3,4,5]) and
         (sy>=wyswodywx) then begin
           juz:=true;
           sy:=sy+dy*10;
           sx:=sx+dx*10;
           bron.laser_skonczyl_w_wodzie:=true;
           kiedysprawdz:=0; {niech juz nie sprawdza co trafil, tylko rozwala wode}
           bron.laserdlugosc:=dlugosc;
           if random(10)=0 then swiatlo(x-20+random(41),y,10+random(140));
           for k:=0 to max_kol do
               if (koles[k].jest) and
                  (koles[k].y+14>=wyswody(koles[k].x)) then begin
                  dec(koles[k].sila,moc);
                  inc(gracz.pkt,moc);
                  koles[k].corobi:=cr_panika;
                  koles[k].dx:=koles[k].dx-2+random*4;
                  koles[k].dy:=koles[k].dy-2+random*4;
                  if zapala and (random(10)=0) then koles[k].palisie:=true;

                  if random(10)=0 then c:=1 else c:=0;
                  nowysyf(koles[k].x-5+random(10),koles[k].y-7+random(14),
                            random*2-1+dy,
                            random*2-1+dx,
                            0,random(5),c,0,true, koles[k].team);

                  if random(5)=0 then
                     swiatlo(koles[k].x,koles[k].y,50+random(50));
               end;

           for k:=0 to max_zwierz do
               if (zwierz[k].jest) and
                  (zwierz[k].y+5>=wyswody(zwierz[k].x)) then begin
                  dec(zwierz[k].sila,moc);
                  inc(gracz.pkt,moc);
                  zwierz[k].dx:=zwierz[k].dx-2+random*4;
                  zwierz[k].dy:=zwierz[k].dy-2+random*4;
                  if zapala and (random(10)=0) then zwierz[k].palisie:=true;

                  if random(10)=0 then c:=1 else c:=0;
                  nowysyf(zwierz[k].x-5+random(10),zwierz[k].y-7+random(14),
                            random-0.5+dy,
                            random-0.5+dx,
                            0,random(5),c,0,true, -1);

                  if random(5)=0 then
                     swiatlo(zwierz[k].x,zwierz[k].y,30+random(40));

               end;

           for k:=0 to max_mina do
               if (mina[k].jest) and
                  (mina[k].y+4>=wyswody(mina[k].x)) then begin
                  mina[k].dx:=mina[k].dx-0.5+random;
                  mina[k].dy:=mina[k].dy-0.5+random;

                  mina[k].aktywna:=true;
                  if mina[k].czasdowybuchu>5 then mina[k].czasdowybuchu:=random(5)+1;

                  if random(5)=0 then
                     swiatlo(mina[k].x,mina[k].y,20+random(30));
               end;

           for k:=0 to max_mieso do
               if (mieso[k].jest) and
                  (mieso[k].y+4>=wyswody(mieso[k].x)) then begin
                  mieso[k].dx:=mieso[k].dx-0.5+random;
                  mieso[k].dy:=mieso[k].dy-0.5+random;

                  if random(5)=0 then begin
                     wybuch(mieso[k].x,mieso[k].y,5+random(5),false,true,true,zapala,-2,true);
                     swiatlo(mieso[k].x,mieso[k].y,20+random(30));
                  end;

               end;
      end else
      if (bron.wybrana=42) and
         (warunki.typ_wody=2) and
         (sy>=wyswodywx) then begin
          juz:=true;
          bron.laserdlugosc:=dlugosc;
      end;

      inc(kiedysprawdz);

      if kiedysprawdz>=10 then begin
         if (bron.wybrana=44) and (random(3)=0) then
            swiatlo(x,y,20+random(7)-moc*6);
         trafiony:=false;
         for k:=0 to max_kol do
             if (koles[k].jest) and
                (x>=koles[k].x-13) and (y>=koles[k].y-13) and
                (x<=koles[k].x+13) and (y<=koles[k].y+13) then begin
                dec(koles[k].sila,moc);
                inc(gracz.pkt,moc);
                koles[k].corobi:=cr_panika;
                if bron.wybrana<>44 then begin
                   koles[k].dx:=koles[k].dx-2+random*4+dx/4;
                   koles[k].dy:=koles[k].dy-2+random*4+dy/4;
                end else begin
                   koles[k].dx:=koles[k].dx-dx;
                   koles[k].dy:=koles[k].dy-dy;
                end;
                if zapala and (random(10)=0) then koles[k].palisie:=true;

                if random(10)=0 then c:=1 else c:=0;
                nowysyf(koles[k].x-5+random(10),koles[k].y-7+random(14),
                          random*2-1+dy,
                          random*2-1+dx,
                          0,random(5),c,0,true, koles[k].team);

                if random(5)=0 then
                   swiatlo(x,y,20+random(40));

                if bron.wybrana<>43 then begin
                   trafiony:=true;
                   juz:=true;
                   bron.laserdlugosc:=dlugosc;
                   break;
                end;
             end;

         if not trafiony then
           for k:=0 to max_zwierz do
               if (zwierz[k].jest) and
                  (x>=zwierz[k].x-7) and (y>=zwierz[k].y-7) and
                  (x<=zwierz[k].x+7) and (y<=zwierz[k].y+7) then begin
                  dec(zwierz[k].sila,moc);
                  inc(gracz.pkt,moc);
                  if bron.wybrana<>44 then begin
                     zwierz[k].dx:=zwierz[k].dx-2+random*4+dx/4;
                     zwierz[k].dy:=zwierz[k].dy-2+random*4+dy/4;
                  end else begin
                     zwierz[k].dx:=zwierz[k].dx-dx;
                     zwierz[k].dy:=zwierz[k].dy-dy;
                  end;

                  if zapala and (random(10)=0) then zwierz[k].palisie:=true;

                  if random(10)=0 then c:=1 else c:=0;
                  nowysyf(zwierz[k].x-5+random(10),zwierz[k].y-7+random(14),
                            random-0.5+dy,
                            random-0.5+dx,
                            0,random(5),c,0,true, -1);

                  if random(5)=0 then
                     swiatlo(x,y,20+random(30));

                  if bron.wybrana<>43 then begin
                     trafiony:=true;
                     juz:=true;
                     bron.laserdlugosc:=dlugosc;
                     break;
                  end;
               end;

         if not trafiony then
           for k:=0 to max_mina do
               if (mina[k].jest) and
                  (x>=mina[k].x-7) and (y>=mina[k].y-7) and
                  (x<=mina[k].x+7) and (y<=mina[k].y+7) then begin
                  if bron.wybrana<>44 then begin
                     mina[k].dx:=mina[k].dx-0.5+random+dx/6;
                     mina[k].dy:=mina[k].dy-0.5+random+dy/6;
                  end else begin
                     mina[k].dx:=mina[k].dx-dx;
                     mina[k].dy:=mina[k].dy-dy;
                  end;

                  mina[k].aktywna:=true;
                  if mina[k].czasdowybuchu>5 then mina[k].czasdowybuchu:=random(5)+1;

                  if random(5)=0 then
                     swiatlo(x,y,20+random(30));

                  if bron.wybrana<>43 then begin
                     trafiony:=true;
                     juz:=true;
                     bron.laserdlugosc:=dlugosc;
                     break;
                  end;
               end;

         if not trafiony then
           for k:=0 to max_przedm do
               if (przedm[k].jest) and
                  (x>=przedm[k].x-7) and (y>=przedm[k].y-5) and
                  (x<=przedm[k].x+7) and (y<=przedm[k].y+5) then begin
                  if bron.wybrana<>44 then begin
                     przedm[k].dx:=przedm[k].dx-0.5+random+dx/6;
                     przedm[k].dy:=przedm[k].dy-0.5+random+dy/6;
                  end else begin
                     przedm[k].dx:=przedm[k].dx-dx;
                     przedm[k].dy:=przedm[k].dy-dy;
                  end;

                  if random(5)=0 then przedm[k].rozwal:=true;

                  if random(5)=0 then
                     swiatlo(x,y,20+random(30));

                  if bron.wybrana<>43 then begin
                     trafiony:=true;
                     juz:=true;
                     bron.laserdlugosc:=dlugosc;
                     break;
                  end;
               end;

         if not trafiony then
           for k:=0 to max_mieso do
               if (mieso[k].jest) and
                  (x>=mieso[k].x-5) and (y>=mieso[k].y-5) and
                  (x<=mieso[k].x+5) and (y<=mieso[k].y+5) then begin
                  if bron.wybrana<>44 then begin
                     mieso[k].dx:=mieso[k].dx-0.5+random+dx/6;
                     mieso[k].dy:=mieso[k].dy-0.5+random+dy/6;
                  end else begin
                     mieso[k].dx:=mieso[k].dx-dx;
                     mieso[k].dy:=mieso[k].dy-dy;
                  end;

                  if random(5)=0 then
                     wybuch(x,y,5+random(5),false,true,true,zapala,-2,true);

                  if bron.wybrana<>43 then begin
                     trafiony:=true;
                     juz:=true;
                     bron.laserdlugosc:=dlugosc;
                     break;
                  end;
               end;


         if (kfg.detale>=2) and (licznik2 mod 2=0) then begin
             inc(kiedysprawdz2);
             if kiedysprawdz2>=2 then begin
                 if (bron.wybrana=42) then
                    nowywybuchdym( sx,sy,0,0,0,wd_swiatlo,0,
                                   random(10)+10+moc*2,
                                   50+moc,
                                   $FF7000+random(120) shl 8+random(30),false,8);
                 kiedysprawdz2:=0;
             end;
         end;

         kiedysprawdz:=0;
      end;

   end else begin
       juz:=true;
       end;

   if bron.laserile>=8 then juz:=true;
   inc(dlugosc);

until (juz) ;
inc(bron.laserile);
bron.laser[bron.laserile].x:=trunc(sx);
bron.laser[bron.laserile].y:=trunc(sy);
bron.laser[bron.laserile].dx:=dx;
bron.laser[bron.laserile].dy:=dy;
end;

procedure rysuj_lasery_itd;
var
p1,p2:TPoint;
a, b:integer;
j1,j2:word;

d,skok,s,
szer,dlu:real;
krok,kroki,rozsz:integer;
kol1,kol2:cardinal;

begin
case bron.wybrana of
   41:begin {laser}
      j1:=250;
      j2:=0;
      for a:=0 to bron.laserile-1 do begin
          p1:=point(bron.laser[a].x-ekran.px,bron.laser[a].y-ekran.py);
          p2:=point(bron.laser[a+1].x-ekran.px,bron.laser[a+1].y-ekran.py);

          j2:=j1;
          j1:=250-a*25;

          form1.PowerDraw1.WuLine(p1,p2,
                    cardinal( ($0030FF-random(50)) or (j1 shl 24)),
                    cardinal( ($0010FF-random(50)) or (j1 shl 24)),
                    effectSrcAlpha or effectAdd);
      end;
      end;
   42:begin {prad}
      a:=0;
      p1:=point(bron.laser[a].x-ekran.px,bron.laser[a].y-ekran.py);
      d:=sqrt2(sqr(bron.laser[a].x-bron.laser[a+1].x)+sqr(bron.laser[a].y-bron.laser[a+1].y));
      if d<=1 then exit;
      if (bron.laser_skonczyl_w_wodzie) and (bron.laser[0].y>=wyswody(bron.laser[0].x)) then exit;

      kroki:=round(d/5);
      skok:=d/kroki;
      rozsz:=0;

      for b:=0 to 1+bron.lasermoc div 3 do begin
          p1:=point(bron.laser[a].x-ekran.px,bron.laser[a].y-ekran.py);
          p2:=point(bron.laser[a+1].x-ekran.px,bron.laser[a+1].y-ekran.py);
          s:=0;
          krok:=0;
          kol1:=$80FFFF00;
          szer:=-6+random*12;
          dlu:=2+random*2;
          if kroki>=1 then repeat
             inc(krok);
             s:=s+skok;
             p2:=p1;
             //if random(20)=0 then szer:=-4+random*8;

             if (krok=kroki) then begin
                p1:=point(bron.laser[a+1].x-ekran.px,bron.laser[a+1].y-ekran.py);
             end else begin
                p1.X:=integer( trunc( (bron.laser[a].x-ekran.px)+bron.laser[a+1].dx*s
                             +sin(krok/dlu)*szer
                             {+random*skok-skok/2} ) );
                p1.Y:=integer( trunc( (bron.laser[a].y-ekran.py)+bron.laser[a+1].dy*s
                             +cos(krok/dlu)*szer
                             {+random*skok-skok/2} ) );
             end;

             if (bron.laser_skonczyl_w_wodzie) and
                (p1.y>=wyswody(bron.laser[a+1].x)-15-ekran.py) then begin
                if p1.y>wyswody(bron.laser[a+1].x)-1-ekran.py then p1.y:=wyswody(bron.laser[a+1].x)-1-ekran.py-random(10);
                p1.x:=p1.x + trunc((-3+random*6)*rozsz);
                if rozsz<10 then inc(rozsz);
             end;

             kol2:=kol1;
             kol1:=cardinal( $00FFE000
                   +((35+random(200)) shl 24)
                   -random($80) shl 8
                   +random(130) );

             form1.PowerDraw1.WuLine(p1,p2,
                    kol1,kol2,
                    effectSrcAlpha or effectAdd);
          until krok>=kroki;

      end;
      nowa_flara(p2.X,p2.y, 100+random(20), $80FF7000+random(120) shl 8+random(200)+random(15) shl 24);
      end;
   43:begin {rejlgan}
      j1:=bron.dostrzalu*5+5;

      for a:=0 to 2 do begin
          p1:=point(bron.laser[0].x-ekran.px-2+random(5),bron.laser[0].y-ekran.py-2+random(5));
          p2:=point(bron.laser[1].x-ekran.px-2+random(5),bron.laser[1].y-ekran.py-2+random(5));
          form1.PowerDraw1.WuLine(p1,p2,
                        cardinal( ($707070-random(50)) or (j1 shl 24) ),
                        cardinal( ($707070-random(50)) or (j1 shl 24) ),
                        effectSrcAlpha or effectAdd);
      end;

      a:=0;
      p1:=point(bron.laser[a].x-ekran.px,bron.laser[a].y-ekran.py);
      d:=sqrt2(sqr(bron.laser[a].x-bron.laser[a+1].x)+sqr(bron.laser[a].y-bron.laser[a+1].y));
      if d<=1 then exit;

      kroki:=round(d/1.5);
      skok:=d/kroki;

      p1:=point(bron.laser[0].x-ekran.px,bron.laser[0].y-ekran.py);
      p2:=point(bron.laser[1].x-ekran.px,bron.laser[1].y-ekran.py);
      s:=0;
      krok:=0;
      kol1:=$00FF8000;
      szer:=(55-bron.dostrzalu)/6;
      dlu:=1;
      repeat
         inc(krok);
         s:=s+skok;
         p2:=p1;

         if (krok=kroki) then begin
            p1:=point(bron.laser[a+1].x-ekran.px,bron.laser[a+1].y-ekran.py);
         end else begin
            p1.X:=trunc( (bron.laser[a].x-ekran.px)+bron.laser[a+1].dx*s
                         +sin(bron.dostrzalu/7+krok/dlu)*szer*((kroki-krok)/kroki) );
            p1.Y:=trunc( (bron.laser[a].y-ekran.py)+bron.laser[a+1].dy*s
                         +cos(bron.dostrzalu/7+krok/dlu)*szer*((kroki-krok)/kroki) );
         end;

         kol2:=kol1;
         kol1:=cardinal( $00FF8000
               +((50+bron.dostrzalu*4) shl 24)
               -trunc(cos(bron.dostrzalu/7+krok/dlu)*70) shl 8 );

         form1.PowerDraw1.WuLine(p1,p2,
                kol1,kol2,
                effectSrcAlpha or effectAdd);
      until krok>=kroki;
      end;
   44:begin {?}
      j1:=100+random(100);
      p1:=point(bron.laser[0].x-ekran.px-1+random(3),bron.laser[0].y-ekran.py-1+random(3));
      p2:=point(bron.laser[1].x-ekran.px-1+random(3),bron.laser[1].y-ekran.py-1+random(3));
      form1.PowerDraw1.WuLine(p1,p2,
                        cardinal( ($007000-random(80) shl 8) or (j1 shl 24) ),
                        cardinal( ($007000-random(80) shl 8) or (j1 shl 24) ),
                        effectSrcAlpha or effectAdd);


      a:=0;
      p1:=point(bron.laser[a].x-ekran.px,bron.laser[a].y-ekran.py);
      d:=sqrt2(sqr(bron.laser[a].x-bron.laser[a+1].x)+sqr(bron.laser[a].y-bron.laser[a+1].y));
      if d<=1 then exit;

      kroki:=round(d/2);
      skok:=d/kroki;

      p1:=point(bron.laser[0].x-ekran.px,bron.laser[0].y-ekran.py);
      p2:=point(bron.laser[1].x-ekran.px,bron.laser[1].y-ekran.py);
      s:=0;
      krok:=0;
      kol1:=$00008000;
      szer:=12;
      dlu:=1;
      repeat
         inc(krok);
         s:=s+skok;
         p2:=p1;

         if (krok=kroki) then begin
            p1:=point(bron.laser[a+1].x-ekran.px,bron.laser[a+1].y-ekran.py);
         end else begin
            p1.X:=trunc( (bron.laser[a].x-ekran.px)+bron.laser[a+1].dx*s
                         +sin(-bron.laserkrec/5+krok/dlu)*szer*(0.3+(kroki-krok)/kroki) );
            p1.Y:=trunc( (bron.laser[a].y-ekran.py)+bron.laser[a+1].dy*s
                         +cos(-bron.laserkrec/5+krok/dlu)*szer*(0.3+(kroki-krok)/kroki) );
         end;

         kol2:=kol1;
         kol1:=cardinal( $00008000
               +((100+random(100)) shl 24)
               -trunc(cos(-bron.laserkrec/5+krok/dlu)*$50 + sin(-bron.laserkrec/12)*$29) shl 8
               +(100+trunc( sin(-bron.laserkrec/14+krok/10)*90 )) );

         form1.PowerDraw1.WuLine(p1,p2,
                kol1,kol2,
                effectSrcAlpha or effectAdd);
      until krok>=kroki;
      end;
end;
end;

{-----------pioruny--------------------}

procedure piorun(sx,sy, kat:real; moc:byte; liczpunkty:boolean=true);
var
juz,trafiony:boolean;
ddx,ddy,dx,dy:real;
k,b,
x,y,c:integer;
kiedysprawdz:byte;
dlugfragm,a, b1,b2,
dlugosc,dlug2:integer;
wyswodywx:integer;

 procedure swiatlo(x,y:real; r:integer);
 begin
   nowywybuchdym(x,y,0,0,0,wd_swiatlo,0,30+random(50),r+moc*5,$FF7000+random(120) shl 8+random(200));
 end;

begin
juz:=false;
bron.piorun_gl_ile:=0;
bron.piorun[bron.piorun_gl_ile].p[0].x:=trunc(sx);
bron.piorun[bron.piorun_gl_ile].p[0].y:=trunc(sy);
bron.piorun[bron.piorun_gl_ile].p[0].dx:=_sin(trunc(kat));
bron.piorun[bron.piorun_gl_ile].p[0].dy:=-_cos(trunc(kat));
bron.piorun[bron.piorun_gl_ile].ile:=0;
kiedysprawdz:=0;
bron.piorun[bron.piorun_gl_ile].piorun_skonczyl_w_wodzie:=false;

dx:=bron.piorun[bron.piorun_gl_ile].p[0].dx;
dy:=bron.piorun[bron.piorun_gl_ile].p[0].dy;
dlugfragm:=0;

form1.graj(form1.dzw_rozne.Item[7+random(3)],sx,sy,5000);
nowywybuchdym(sx+dx*50,sy+dy*50,dx*10,dy*10,0,wd_swiatlo,0,50,700,$FF7000+random(120) shl 8+random(100));
repeat
    dlugosc:=0;
    dlug2:=0;
    repeat
       if (dlugfragm>=10) and (random(4)=0) and (bron.piorun[bron.piorun_gl_ile].ile<98) then begin
           kat:=kat-10+random(21);
           if kat<0 then kat:=kat+360;
           if kat>=360 then kat:=kat-360;
           dx:=_sin(trunc(kat));
           dy:=-_cos(trunc(kat));
           dlugfragm:=0;
           inc(bron.piorun[bron.piorun_gl_ile].ile);
           bron.piorun[bron.piorun_gl_ile].p[bron.piorun[bron.piorun_gl_ile].ile].x:=trunc(sx);
           bron.piorun[bron.piorun_gl_ile].p[bron.piorun[bron.piorun_gl_ile].ile].y:=trunc(sy);
           bron.piorun[bron.piorun_gl_ile].p[bron.piorun[bron.piorun_gl_ile].ile].dx:=dx;
           bron.piorun[bron.piorun_gl_ile].p[bron.piorun[bron.piorun_gl_ile].ile].dy:=dy;
       end;

       sx:=sx+dx;
       sy:=sy+dy;
       inc(dlugfragm);

       inc(dlugosc);
       if dlugosc>=20 then begin
          {przezr}
          b1:=17+moc div 2-dlug2 div 2;
          if b1<10 then b1:=10;
          if b1>126 then b1:=126;
          {wielk}
          b2:=80+moc div 2-dlug2;
          if b2<10 then b2:=10;
          if b2>200 then b2:=200;
          nowywybuchdym(sx,sy,0,0,0,wd_swiatlo,0,b1,b2,$FF7000+random(120) shl 8+random(100));
          dlugosc:=0;
          inc(dlug2);
       end;


       if (sx+ekran.trzesx>=0) and (sy+ekran.trzesy>=0) and (sx+ekran.trzesx<=teren.width-1) and (sy+ekran.trzesy<=teren.height+29) then begin
          x:=trunc(sx)+ekran.trzesx;
          y:=trunc(sy)+ekran.trzesy;
          wyswodywx:=wyswody(x);
          if teren.maska[x,y]>=1 then begin
             juz:=true;

             for k:=0 to moc div 2+random(15) do
                 nowysyf(x-dx,y-dy,random(360),3.5+random*moc/6,1,
                         0,1,3,true, 0,0,cardinal( $000040ff+(random($Be) shl 8)) );
             wybuch(x,y,5+moc div 3,false,true,true,true,-2,true, liczpunkty);
             swiatlo(x,y,50+random(50));
          end;

          if (warunki.typ_wody in [1,3,4,5]) and
             (sy>=wyswodywx) then begin
               if sy<=wyswodywx+22 then begin
                   form1.graj(form1.dzw_rozne.Item[5],sx,sy,7000);
                   for b:=0 to 3+moc div 4+random(10) do
                       nowysyf(sx-4+random(9),wyswodywx-1,
                               ((random*2-1)+dx)*(1+moc/30),-abs(random*dy)*(1+moc/30),
                               0,random(5),0,2,true,0,warunki.typ_wody);
                   plum(sx,sy,moc/5,1+random(4),1+moc/20);
                   woda_wrzyj;
               end;
               juz:=true;
               sy:=sy+dy*10;
               sx:=sx+dx*10;
               bron.piorun[bron.piorun_gl_ile].piorun_skonczyl_w_wodzie:=true;
               kiedysprawdz:=0; {niech juz nie sprawdza co trafil, tylko rozwala wode}
               swiatlo(x-20+random(41),y,10+random(140));
               for k:=0 to max_kol do
                   if (koles[k].jest) and
                      (koles[k].y+14>=wyswody(koles[k].x)) then begin
                      dec(koles[k].sila,moc*3);
                      if liczpunkty then inc(gracz.pkt,moc);
                      koles[k].corobi:=cr_panika;
                      koles[k].dx:=koles[k].dx-2+random*4;
                      koles[k].dy:=koles[k].dy-2+random*4;
                      if random(2)=0 then koles[k].palisie:=true;

                      if random(10)=0 then c:=1 else c:=0;
                      nowysyf(koles[k].x-5+random(10),koles[k].y-7+random(14),
                                random*2-1+dy,
                                random*2-1+dx,
                                0,random(5),c,0,true, koles[k].team);

                      swiatlo(koles[k].x,koles[k].y,20+random(30));
                   end;

               for k:=0 to max_zwierz do
                   if (zwierz[k].jest) and
                      (zwierz[k].y+5>=wyswody(zwierz[k].x)) then begin
                      dec(zwierz[k].sila,moc*3);
                      if liczpunkty then inc(gracz.pkt,moc);
                      zwierz[k].dx:=zwierz[k].dx-2+random*4;
                      zwierz[k].dy:=zwierz[k].dy-2+random*4;
                      if random(10)=0 then zwierz[k].palisie:=true;

                      if random(10)=0 then c:=1 else c:=0;
                      nowysyf(zwierz[k].x-5+random(10),zwierz[k].y-7+random(14),
                                random-0.5+dy,
                                random-0.5+dx,
                                0,random(5),c,0,true, -1);

                      swiatlo(zwierz[k].x,zwierz[k].y,30+random(30));

                   end;

               for k:=0 to max_mina do
                   if (mina[k].jest) and
                      (mina[k].y+4>=wyswody(mina[k].x)) then begin
                      mina[k].dx:=mina[k].dx-1+random*2;
                      mina[k].dy:=mina[k].dy-1+random*2;

                      mina[k].aktywna:=true;
                      if mina[k].czasdowybuchu>5 then mina[k].czasdowybuchu:=random(5)+1;

                      swiatlo(mina[k].x,mina[k].y,20+random(30));
                   end;

               for k:=0 to max_mieso do
                   if (mieso[k].jest) and
                      (mieso[k].y+4>=wyswody(mieso[k].x)) then begin
                      mieso[k].dx:=mieso[k].dx-1+random*2;
                      mieso[k].dy:=mieso[k].dy-1+random*2;

                      if random(5)=0 then begin
                         for a:=0 to moc div 2+random(15) do
                             nowysyf(x-dx,y-dy,random(360),3.5+random*moc/6,1,
                                     0,1,3,true, 0,0,cardinal( $000040ff+(random($Be) shl 8)) );
                         wybuch(mieso[k].x,mieso[k].y,5+random(5),false,true,true,true,-2,true, liczpunkty);
                         swiatlo(mieso[k].x,mieso[k].y,20+random(30));
                      end;

                   end;
          end else
          if (warunki.typ_wody=2) and
             (sy>=wyswodywx) then begin
              juz:=true;
          end;

          inc(kiedysprawdz);

          if kiedysprawdz>=10 then begin
             trafiony:=false;
             for k:=0 to max_kol do
                 if (koles[k].jest) and
                    (x>=koles[k].x-13) and (y>=koles[k].y-13) and
                    (x<=koles[k].x+13) and (y<=koles[k].y+13) then begin

                    for a:=0 to moc div 2+random(15) do
                        nowysyf(x-dx,y-dy,random(360),3.5+random*moc/6,1,
                                0,1,3,true, 0,0,cardinal( $000040ff+(random($Be) shl 8)) );
                    wybuch(x,y,15+moc,false,true,true,true,-2,true, liczpunkty);
                    koles[k].corobi:=cr_panika;
                    koles[k].dx:=koles[k].dx-2+random*4+dx;
                    koles[k].dy:=koles[k].dy-2+random*4+dy;
                    dec(koles[k].sila,moc*2);

                    swiatlo(x,y,20+random(40));

                    trafiony:=true;
                    juz:=true;
                    break;
                 end;

             if not trafiony then
               for k:=0 to max_zwierz do
                   if (zwierz[k].jest) and
                      (x>=zwierz[k].x-7) and (y>=zwierz[k].y-7) and
                      (x<=zwierz[k].x+7) and (y<=zwierz[k].y+7) then begin

                      for a:=0 to moc div 2+random(15) do
                          nowysyf(x-dx,y-dy,random(360),3.5+random*moc/6,1,
                                  0,1,3,true, 0,0,cardinal( $000040ff+(random($Be) shl 8)) );
                      wybuch(x,y,15+moc div 2,false,true,true,true,-2,true, liczpunkty);
                      swiatlo(x,y,20+random(30));
                      zwierz[k].dx:=zwierz[k].dx-2+random*4+dx;
                      zwierz[k].dy:=zwierz[k].dy-2+random*4+dy;
                      dec(zwierz[k].sila,moc*2);

                      trafiony:=true;
                      juz:=true;
                      break;
                   end;

             if not trafiony then
               for k:=0 to max_mina do
                   if (mina[k].jest) and
                      (x>=mina[k].x-7) and (y>=mina[k].y-7) and
                      (x<=mina[k].x+7) and (y<=mina[k].y+7) then begin
                      for a:=0 to moc div 2+random(15) do
                          nowysyf(x-dx,y-dy,random(360),3.5+random*moc/6,1,
                                  0,1,3,true, 0,0,cardinal( $000040ff+(random($Be) shl 8)) );
                      wybuch(x,y,5+moc div 2,false,true,true,true,-2,true, liczpunkty);
                      swiatlo(x,y,20+random(30));
                      mina[k].dx:=mina[k].dx-1+random*2+dx;
                      mina[k].dy:=mina[k].dy-1+random*2+dy;

                      trafiony:=true;
                      juz:=true;
                      break;
                   end;

             if not trafiony then
               for k:=0 to max_przedm do
                   if (przedm[k].jest) and
                      (x>=przedm[k].x-7) and (y>=przedm[k].y-5) and
                      (x<=przedm[k].x+7) and (y<=przedm[k].y+5) then begin
                      for a:=0 to moc div 2+random(15) do
                          nowysyf(x-dx,y-dy,random(360),3.5+random*moc/6,1,
                                  0,1,3,true, 0,0,cardinal( $000040ff+(random($Be) shl 8)) );
                      wybuch(x,y,5+moc div 2,false,true,true,true,-2,true, liczpunkty);
                      swiatlo(x,y,20+random(30));
                      przedm[k].dx:=przedm[k].dx-1+random*2+dx;
                      przedm[k].dy:=przedm[k].dy-1+random*2+dy;

                      trafiony:=true;
                      juz:=true;
                      break;
                   end;

             if not trafiony then
               for k:=0 to max_mieso do
                   if (mieso[k].jest) and
                      (x>=mieso[k].x-5) and (y>=mieso[k].y-5) and
                      (x<=mieso[k].x+5) and (y<=mieso[k].y+5) then begin
                      for a:=0 to moc div 2+random(15) do
                          nowysyf(x-dx,y-dy,random(360),3.5+random*moc/6,1,
                                  0,1,3,true, 0,0,cardinal( $000040ff+(random($Be) shl 8)) );
                      wybuch(x,y,5+moc div 2,false,true,true,true,-2,true, liczpunkty);
                      swiatlo(x,y,20+random(30));
                      mieso[k].dx:=mieso[k].dx-1+random*2+dx;
                      mieso[k].dy:=mieso[k].dy-1+random*2+dy;
                      trafiony:=true;
                      juz:=true;
                      break;
                   end;


             kiedysprawdz:=0;
          end;

       end else begin
           juz:=true;
           end;

       if bron.piorun[bron.piorun_gl_ile].ile>=98 then juz:=true;

       if (bron.piorun_gl_ile=0) and (dlug2>=80) and (random(300)=0) then juz:=true
       else
       if (bron.piorun_gl_ile>0) and (dlug2>=7) and (random(500)=0) then juz:=true;

    until (juz) ;
    inc(bron.piorun[bron.piorun_gl_ile].ile);
    bron.piorun[bron.piorun_gl_ile].p[bron.piorun[bron.piorun_gl_ile].ile].x:=trunc(sx);
    bron.piorun[bron.piorun_gl_ile].p[bron.piorun[bron.piorun_gl_ile].ile].y:=trunc(sy);
    bron.piorun[bron.piorun_gl_ile].p[bron.piorun[bron.piorun_gl_ile].ile].dx:=dx;
    bron.piorun[bron.piorun_gl_ile].p[bron.piorun[bron.piorun_gl_ile].ile].dy:=dy;

    {dym tylko jak nie wyszedl za ekran}
    if (sx+ekran.trzesx>=0) and (sy+ekran.trzesy>=0) and (sx+ekran.trzesx<=teren.width-1) and (sy+ekran.trzesy<=teren.height+29) then
        for a:=0 to 3+random(10)+moc div 6 do
            nowywybuchdym( sx-2+random(5), sy-2+random(5),
                           random/2-0.25,
                           -0.01-random,
                           0, wd_dym,
                           3+random(8),
                           130+random(120),
                           100+random(250));

    if (bron.piorun_gl_ile<15) and (bron.piorun[0].ile>=3) and (random(2)=0) then begin
       inc(bron.piorun_gl_ile);
       a:=1+random(bron.piorun[0].ile-2);
       bron.piorun[bron.piorun_gl_ile].p[0].x:=bron.piorun[0].p[a].x;
       bron.piorun[bron.piorun_gl_ile].p[0].y:=bron.piorun[0].p[a].y;
       bron.piorun[bron.piorun_gl_ile].p[0].dx:=bron.piorun[0].p[a].dx-0.5+random;
       bron.piorun[bron.piorun_gl_ile].p[0].dy:=bron.piorun[0].p[a].dy-0.5+random;

       if bron.piorun[bron.piorun_gl_ile].p[0].dx<-1 then bron.piorun[bron.piorun_gl_ile].p[0].dx:=-1;
       if bron.piorun[bron.piorun_gl_ile].p[0].dx>1 then bron.piorun[bron.piorun_gl_ile].p[0].dx:=1;
       if bron.piorun[bron.piorun_gl_ile].p[0].dy<-1 then bron.piorun[bron.piorun_gl_ile].p[0].dy:=-1;
       if bron.piorun[bron.piorun_gl_ile].p[0].dy>1 then bron.piorun[bron.piorun_gl_ile].p[0].dy:=1;

       bron.piorun[bron.piorun_gl_ile].ile:=0;
       kiedysprawdz:=0;
       bron.piorun[bron.piorun_gl_ile].piorun_skonczyl_w_wodzie:=false;

       sx:=bron.piorun[0].p[a].x;
       sy:=bron.piorun[0].p[a].y;
       dx:=bron.piorun[bron.piorun_gl_ile].p[0].dx;
       dy:=bron.piorun[bron.piorun_gl_ile].p[0].dy;
       kat:=jaki_to_kat(dx,dy);
       dlugfragm:=0;

       if moc>=15 then dec(moc,3+random(7));

       juz:=false;
    end else juz:=true;

until juz;
end;

procedure rysuj_piorun;
var
p1,p2:TPoint;
a, a1:integer;
kol1:cardinal;

begin
for a1:=0 to bron.piorun_gl_ile do begin
  for a:=0 to bron.piorun[a1].ile-1 do begin

      p1:=point(bron.piorun[a1].p[a].x-ekran.px,bron.piorun[a1].p[a].y-ekran.py);
      p2:=point(bron.piorun[a1].p[a+1].x-ekran.px,bron.piorun[a1].p[a+1].y-ekran.py);

      kol1:= cardinal( $0CFF5f00
                       +cardinal( ((random(30)+bron.piorun_dostrzalu*6) shl 24) )
                       +cardinal( (random(40)+bron.piorun_dostrzalu*4) shl 8 )
                       +cardinal( random(50)+bron.piorun_dostrzalu*6 ) );

         form1.PowerDraw1.WuLine(p1,p2,
                kol1,kol1,
                effectSrcAlpha or effectAdd);


  end;

  nowa_flara(p2.X,p2.y, 80+bron.piorun_dostrzalu*2, kol1);

end;
//niebo.kolorterenu:=$FFFFC090

end;

{-pila-}
procedure piluj;
var
c,b,d,a,cx,cy:integer;
sx,sy,dx,dy,
_dx,_dy, dd,kk:real;
juz:boolean;
begin
if random(20)=0 then begin
   mysz.x:=mysz.x+random(3)-1;
   mysz.y:=mysz.y+random(3)-1;
end;

sx:=mysz.x+ekran.px;
sy:=mysz.y+ekran.py;
dx:=_sin(trunc(bron.kat));
dy:=-_cos(trunc(bron.kat));
bron.piluje:=true;

if (bron.kat>=300) and (bron.skat<=60) then
   dd:=abs(bron.kat-360-bron.skat)/5
  else
if (bron.skat>=300) and (bron.kat<=60) then
   dd:=abs(bron.kat+360-bron.skat)/5
  else dd:=abs(bron.kat-bron.skat)/5;

_dx:={_sin(trunc(bron.kat)) } abs(dd)*_cos(trunc(bron.kat-bron.skat))+ (mysz.x-mysz.sx)/20;
_dy:={-_cos(trunc(bron.kat)) +} abs(dd)*_sin(trunc(bron.kat-bron.skat))+ (mysz.y-mysz.sy)/20;

if bron.kat-bron.skat>=0 then kk:=bron.kat+90
                         else kk:=bron.kat+270;

bron.pilujebardzo:=false;

for a:=0 to max_kol do
  if (koles[a].jest) then begin
     d:=7;
     juz:=false;
     repeat
        dec(d);
        cx:=round(sx+d*dx*11);
        cy:=round(sy+d*dy*11);
        if (cx>=koles[a].x-20) and (cy>=koles[a].y-20) and
           (cx<=koles[a].x+20) and (cy<=koles[a].y+20) then begin

           for b:=0 to random(3) do
            if random(2)=0 then begin
                if random(10)=0 then c:=1 else c:=0;
                nowysyf(koles[a].x-5+random(11),
                        koles[a].y-5+random(11),
                        random(360),
                        1+random*10,
                        1,
                        random(5),c,0,true, koles[a].team);
            end else begin
                if random(10)=0 then c:=1 else c:=0;
                nowysyf(koles[a].x-5+random(11),
                        koles[a].y-5+random(11),
                        kk-10+random(21),dd-1+random*2,
                        1,
                        random(5),c,0,true, koles[a].team);
            end;

            if random(10)=0 then begin
                if (warunki.typ_wody=0) or (koles[a].y<wyswody(koles[a].x)+15) then
                   form1.graj(druzyna[koles[a].team].dzwieki.Item[random(3)],koles[a].x,koles[a].y,10000)
                   else form1.graj(druzyna[koles[a].team].dzwieki.Item[8],koles[a].x,koles[a].y,5000);
            end;

            c:=koles[a].sila;
            koles[a].sila:=koles[a].sila-1;
            c:=c-koles[a].sila;
            if koles[a].sila<0 then c:=c-koles[a].sila;
            inc(gracz.pkt,c);

            koles[a].dx:=koles[a].dx+_dx;
            koles[a].dy:=koles[a].dy+_dy;

            if koles[a].x>cx then koles[a].x:=koles[a].x-random*5;
            if koles[a].x<cx then koles[a].x:=koles[a].x+random*5;
            if koles[a].y>cy then koles[a].y:=koles[a].y-random*5;
            if koles[a].y<cy then koles[a].y:=koles[a].y+random*5;

            koles[a].corobi:=cr_panika;

            bron.pilujebardzo:=true;
            juz:=true;
        end;
     until (d<=3) or (juz);
  end;

for a:=0 to max_zwierz do
  if (zwierz[a].jest) then begin
     d:=7;
     juz:=false;
     repeat
        dec(d);
        cx:=round(sx+d*dx*11);
        cy:=round(sy+d*dy*11);
        if (cx>=zwierz[a].x-10) and (cy>=zwierz[a].y-10) and
           (cx<=zwierz[a].x+10) and (cy<=zwierz[a].y+10) then begin

           for b:=0 to random(3) do
            if random(2)=0 then begin
                if random(10)=0 then c:=1 else c:=0;
                nowysyf(zwierz[a].x-5+random(11),
                        zwierz[a].y-5+random(11),
                        random(360),
                        1+random*10,
                        1,
                        random(5),c,0,true, -1);
            end else begin
                if random(10)=0 then c:=1 else c:=0;
                nowysyf(zwierz[a].x-5+random(11),
                        zwierz[a].y-5+random(11),
                        kk-10+random(21),dd-1+random*2,
                        1,
                        random(5),c,0,true, -1);
            end;

{            if random(10)=0 then begin
                if (warunki.typ_wody=0) or (zwierz[a].y<warunki.wys_wody+15) then
                   form1.graj(druzyna[zwierz[a].team].dzwieki.Item[random(3)],zwierz[a].x,zwierz[a].y,10000)
                   else form1.graj(druzyna[zwierz[a].team].dzwieki.Item[8],zwierz[a].x,zwierz[a].y,5000);
            end;}

            c:=zwierz[a].sila;
            zwierz[a].sila:=zwierz[a].sila-1;
            c:=c-zwierz[a].sila;
            if zwierz[a].sila<0 then c:=c-zwierz[a].sila;
            inc(gracz.pkt,c);

            zwierz[a].dx:=zwierz[a].dx+_dx;
            zwierz[a].dy:=zwierz[a].dy+_dy;

            if zwierz[a].x>cx then zwierz[a].x:=zwierz[a].x-random*5;
            if zwierz[a].x<cx then zwierz[a].x:=zwierz[a].x+random*5;
            if zwierz[a].y>cy then zwierz[a].y:=zwierz[a].y-random*5;
            if zwierz[a].y<cy then zwierz[a].y:=zwierz[a].y+random*5;

            bron.pilujebardzo:=true;
            juz:=true;
        end;
     until (d<=3) or (juz);
  end;

end;

{-mlotek-}
procedure wal_mlotkiem(sila:real);
var
c,b,a:integer;
sx,sy,dx,dy,
_dx,_dy:real;
begin
dx:=_cos(trunc(bron.kat +_sin(bron.mlotek_ani*9)*90 ));
dy:=_sin(trunc(bron.kat +_sin(bron.mlotek_ani*9)*90 ));
sx:=mysz.x+ekran.px+dx*120;
sy:=mysz.y+ekran.py+dy*120;

_dx:=_sin(trunc(bron.kat))*sila;
_dy:=-_cos(trunc(bron.kat))*sila;

for a:=0 to max_kol do
  if (koles[a].jest) and
     (sx>=koles[a].x-25) and (sy>=koles[a].y-25) and
     (sx<=koles[a].x+25) and (sy<=koles[a].y+25) then begin

     if kfg.detale>=2 then begin
          nowywybuchdym(koles[a].x,koles[a].y,
                        _dx/15,_dy/15-0.5,
                        0,wd_krew,random(3),
                        random(2)*(180+random(70)),random(100)+170,
                        druzyna[koles[a].team].kolor_krwi,true);
     end;

     for b:=0 to trunc(5+sila+random(10)) do
        if random(6)=0 then begin
            if random(10)=0 then c:=1 else c:=0;
            nowysyf(koles[a].x-5+random(11),
                    koles[a].y-5+random(11),
                    random(360),
                    1+random*10,
                    1,
                    random(5),c,0,true, koles[a].team);
        end else begin
            if random(10)=0 then c:=1 else c:=0;
            nowysyf(koles[a].x-5+random(11),
                    koles[a].y-5+random(11),
                    _dx-1+random*2,
                    _dy-1+random*2,
                    0,
                    random(5),c,0,true, koles[a].team);
        end;

     if (warunki.typ_wody=0) or (koles[a].y<wyswody(koles[a].x)+15) then
        form1.graj(druzyna[koles[a].team].dzwieki.Item[random(3)],koles[a].x,koles[a].y,10000)
        else form1.graj(druzyna[koles[a].team].dzwieki.Item[8],koles[a].x,koles[a].y,5000);

     c:=koles[a].sila;
     koles[a].sila:=koles[a].sila-trunc(abs(sila)*2);
     c:=c-koles[a].sila;
     if koles[a].sila<0 then c:=c-koles[a].sila;
     inc(gracz.pkt,c);

     koles[a].dx:=koles[a].dx+_dx;
     koles[a].dy:=koles[a].dy+_dy;

     koles[a].corobi:=cr_panika;

  end;

for a:=0 to max_zwierz do
  if (zwierz[a].jest) and
     (sx>=zwierz[a].x-15) and (sy>=zwierz[a].y-15) and
     (sx<=zwierz[a].x+15) and (sy<=zwierz[a].y+15) then begin
     for b:=0 to trunc(5+sila+random(10)) do
        if random(6)=0 then begin
            if random(10)=0 then c:=1 else c:=0;
            nowysyf(zwierz[a].x-5+random(11),
                    zwierz[a].y-5+random(11),
                    random(360),
                    1+random*10,
                    1,
                    random(5),c,0,true, -1);
        end else begin
            if random(10)=0 then c:=1 else c:=0;
            nowysyf(zwierz[a].x-5+random(11),
                    zwierz[a].y-5+random(11),
                    _dx-1+random*2,
                    _dy-1+random*2,
                    0,
                    random(5),c,0,true, -1);
        end;


     c:=zwierz[a].sila;
     zwierz[a].sila:=zwierz[a].sila-trunc(abs(sila)*2);
     c:=c-zwierz[a].sila;
     if zwierz[a].sila<0 then c:=c-zwierz[a].sila;
     inc(gracz.pkt,c);

     zwierz[a].dx:=zwierz[a].dx+_dx*1.2;
     zwierz[a].dy:=zwierz[a].dy+_dy*1.2;

  end;

for a:=0 to max_mieso do
  if (mieso[a].jest) and
     (sx>=mieso[a].x-15) and (sy>=mieso[a].y-15) and
     (sx<=mieso[a].x+15) and (sy<=mieso[a].y+15) then begin
     if mieso[a].team>=-1 then
       for b:=0 to trunc(4+sila/2+random(8)) do
          if random(6)=0 then begin
              if random(10)=0 then c:=1 else c:=0;
              nowysyf(mieso[a].x-5+random(11),
                      mieso[a].y-5+random(11),
                      random(360),
                      1+random*10,
                      1,
                      random(5),c,0,true, mieso[a].team);
          end else begin
              if random(10)=0 then c:=1 else c:=0;
              nowysyf(mieso[a].x-5+random(11),
                      mieso[a].y-5+random(11),
                      _dx-2+random*4,
                      _dy-2+random*4,
                      0,
                      random(5),c,0,true, mieso[a].team);
          end;


     mieso[a].dx:=mieso[a].dx+_dx;
     mieso[a].dy:=mieso[a].dy+_dy;

  end;


end;

{--zemsta boga--}

procedure zemsta_wypal(sx,sila_:integer);
begin
with bron.zemsta do begin
     x:=sx;
     y:=0;
     czaswdol:=sila div 4;
     leci:=true;
     sila:=sila_;
end;
end;

procedure zemsta_dzialaj;
const szyb=20;
var
a,cx:integer;
ilejuz,sz:integer;

//     nowywybuchdym(x,y,0,0,0,wd_swiatlo,0,30+random(50),r+moc*10,$FF7000+random(120) shl 8+random(200));
begin
ilejuz:=0;
repeat
   inc(ilejuz);
   bron.zemsta.y:=bron.zemsta.y+1;

   a:=-bron.zemsta.sila div 4;
   while a<=bron.zemsta.sila div 4 do begin
       cx:=bron.zemsta.x+a;
       if (cx>=0) and (cx<=teren.width-1) and (bron.zemsta.y<=teren.height-1) and
          (teren.maska[cx][bron.zemsta.y]<>0) then begin
                                              if teren.maska[cx][bron.zemsta.y]<10 then begin
                                                 inc(ilejuz,teren.maska[cx][bron.zemsta.y]);
                                                 dec(bron.zemsta.czaswdol);
                                              end else begin
                                                  ilejuz:=szyb;
                                                  bron.zemsta.czaswdol:=0;
                                              end;
                                              a:=bron.zemsta.sila div 2;
                                              end;
       inc(a);
   end;
   if (bron.zemsta.y>=teren.height-1) or (bron.zemsta.czaswdol<=0) then begin
      ilejuz:=szyb;
      bron.zemsta.czaswdol:=0;
   end;
until ilejuz>=szyb;

wybuch(bron.zemsta.x,bron.zemsta.y,bron.zemsta.sila div 2+random(6),true,false,true,false,-2,false);

if bron.zemsta.czaswdol>0 then sz:=0 else sz:=2;
cx:=bron.zemsta.sila div 2;
if cx<8 then cx:=8;
a:=bron.zemsta.y-random(cx);
while a>=0 do begin
      nowywybuchdym(bron.zemsta.x,a,0,0,0,wd_swiatlo,sz,30+random(50),bron.zemsta.sila,$FF7000+random(120) shl 8+random(200));
      dec(a,cx);
      if random(120-bron.zemsta.sila)=0 then
         nowywybuchdym(bron.zemsta.x,a,0,0,0,wd_swiatlo,1,40,700,$FF7000+random(120) shl 8+random(100));

end;

nowa_flara(bron.zemsta.x-ekran.px,bron.zemsta.y-ekran.py, 150, $90FF7000+random(120) shl 8+random(200));

if bron.zemsta.czaswdol<=0 then begin
   nowywybuchdym(bron.zemsta.x,bron.zemsta.y,0,0,0,wd_swiatlo,1,200,bron.zemsta.sila*2,$FF7000+random(120) shl 8+random(200));
   bron.zemsta.leci:=false;
   bron.dostrzalu:=10;
end;

end;





{--fale--}
procedure inicjujfale(ilefal:integer);
var a:integer;
begin
setlength(fale,0);

faleilosc:=ilefal;
setlength(fale,faleilosc+1);
for a:=0 to faleilosc do begin
    fale[a].y:=warunki.wys_wody;
    fale[a].dy:=0;
end;
end;

procedure plum_z_piana(sx,sy, rozm,ilepiany:real);
var b,a,wx:integer;
wdy:real;
rozm2:real;
begin
  if (warunki.typ_wody>=1) and
     (warunki.wys_wody>=sy-rozm) and (warunki.wys_wody<=sy+rozm) then begin
     for a:=0 to trunc((10+random(trunc(rozm/2))+rozm/2)/ilepiany) do begin
         b:=trunc( sx-rozm+random(trunc(rozm*2)) );
         if (b>=0) and (b<teren.width) and (teren.maska[b,warunki.wys_wody-1]=0) then
            nowysyf( b,warunki.wys_wody-1,
                     random/2-0.25,-abs(random)*abs((rozm- abs(warunki.wys_wody-sy) )/40),
                     0,random(5),0,2,true, 0,warunki.typ_wody);
     end;


     rozm2:=rozm/2;
     wx:=wyswody(sx);
     if (wx>=sy-rozm2) and (wx<=sy+rozm2) then begin
        wdy:=abs(wx-sy);
        if wx<sy then wdy:=-(rozm2-wdy)/2
                 else wdy:=rozm2-wdy/2;
        plum(sx,sy,wdy,trunc(rozm2*1.5),rozm/14);
     end;
  end;
end;

procedure plum(x,y, dy:real; szerokosc:integer; sila:real);
var a,fod,fdo:integer; b:boolean;
begin
fod:=trunc(x/fal_zoomx-szerokosc/2/fal_zoomx);
fdo:=trunc(x/fal_zoomx+szerokosc/2/fal_zoomx);
if (fod>faleilosc) or (fdo<0) then exit;
if fod<0 then fod:=0;
if fdo>faleilosc then fdo:=faleilosc;

if (abs(dy)<1) and (random(5)=0) then begin
   if dy>0 then dy:=1
           else dy:=-1;
end;

b:=boolean(random(2));
for a:=fod to fdo do begin
    fale[a].dy:=fale[a].dy+((dy/10)*sila/2);
    //if b then fale[a].y:=fale[a].y+dy/2;

end;
end;

procedure faledzialaj;
var a,b:integer;
begin
if warunki.typ_wody=0 then exit;
for a:=0 to faleilosc do begin
    if {(fale[a].y<>fale[a+1].y)} a<faleilosc then fale[a].dy:=fale[a].dy+(fale[a+1].y-fale[a].y)/fal_gestosc[warunki.typ_wody].g2;
    if {(fale[a].y<>fale[a-1].y)} a>0 then fale[a].dy:=fale[a].dy+(fale[a-1].y-fale[a].y)/fal_gestosc[warunki.typ_wody].g2;
    fale[a].y:=fale[a].y+fale[a].dy;
    fale[a].dy:=(fale[a].dy*fal_gestosc[warunki.typ_wody].g1);
    fale[a].y:=(fale[a].y-warunki.wys_wody)*fal_gestosc[warunki.typ_wody].g1+warunki.wys_wody;
 {   if fale[a].y>100 then fale[a].y:=100;
    if fale[a].y<0 then fale[a].y:=0;   }
  { if fale[a].dy<-4 then fale[a].dy:=-4;
    if fale[a].dy> 4 then fale[a].dy:=4;   }
    if (fale[a].y<warunki.wys_wody-30) then begin
       if fale[a].dy<-0.3 then fale[a].dy:=-0.3;
       fale[a].y:=warunki.wys_wody-30;
    end;
    if (fale[a].y>warunki.wys_wody+30) then begin
       if fale[a].dy>0.3 then fale[a].dy:=0.3;
       fale[a].y:=warunki.wys_wody+30;
    end;

end;
if (warunki.typ_wody<>2) and (random(trunc(10-abs(warunki.wiatr*15)))=0) then begin
   a:=random(faleilosc);
   fale[a].y:=fale[a].y+(random-0.5)*(0.4+abs(warunki.wiatr*24));
end;
if warunki.typ_wody in [2,3] then begin
   a:=random(faleilosc);
   fale[a].y:=fale[a].y+(random-0.5)*(warunki.typ_wody*2);
end else
if (warunki.typ_wody=2) and (random(70)=0) then begin
   a:=random(faleilosc);
   for b:=-2 to 2 do
       if (a+b>=0) and (a+b<=faleilosc) then begin
          fale[b+a].dy:=-3-random*8;
          fale[b+a].y:=fale[b+a].y-8-random*10;
       end;
end;

end;

procedure faledzialaj_pauza;
var a,b:integer;
begin
if warunki.typ_wody=0 then exit;
for a:=0 to faleilosc do begin
    if (fale[a].y<warunki.wys_wody-30) then begin
       if fale[a].dy<-0.3 then fale[a].dy:=-0.3;
       fale[a].y:=warunki.wys_wody-30;
    end;
    if (fale[a].y>warunki.wys_wody+30) then begin
       if fale[a].dy>0.3 then fale[a].dy:=0.3;
       fale[a].y:=warunki.wys_wody+30;
    end;

end;
end;

procedure woda_wrzyj;
var a:integer;
begin
a:=1;
while a<=faleilosc do begin
   fale[a].y:=fale[a].y+(random-0.5)*4;
   inc(a,1+random(3));
end;

end;

function wyswody(x:real):integer;
begin
if (x<0) or (x>=teren.width) then result:=warunki.wys_wody
   else result:=trunc(fale[trunc(x/fal_zoomx)].y);
end;


//------------------------------------------------------------------------------
procedure nowezwlokikolesi(sx,sy,dx_,dy_,dz_:real; kier_:shortint; team_:byte; palisie_:boolean);
var a,b:longint;
begin
//if (kfg.detale<5) and (random(1+kfg.detale)=0) then exit;

a:=0;//zwlokikolesi_nowy;
b:=0;
while (b<max_zwlokikolesi) and (zwlokikolesi[a].jest) do begin
   inc(a);
   inc(b);
   if a>=max_zwlokikolesi then a:=0;
end;
if b<max_zwlokikolesi then
  with zwlokikolesi[a] do begin
     jest:=true;
     x:=sx;
     y:=sy;
     z:=0;
     dx:=dx_;
     dy:=dy_;
     dz:=dz_;
     kier:=kier_;
     team:=team_;
     szybkosc_ani:=0.1+random/3;
     klatka_ani:=0;
     palisie:=palisie_;
  end;

end;

procedure ruszaj_zwlokikolesi;
var a:integer;
begin
for a:=0 to high(zwlokikolesi) do
    if zwlokikolesi[a].jest then
       with zwlokikolesi[a] do begin
          x:=x+dx;
          y:=y+dy;
          z:=z+dz;

          dy:=dy+(0.2*druzyna[team].waga*warunki.grawitacja)*((1+z)/20);

          klatka_ani:=klatka_ani+szybkosc_ani;
          if klatka_ani>=druzyna[team].animacje[13].klatek then
             klatka_ani:=klatka_ani-druzyna[team].animacje[13].klatek;

          if (z>=10) or (x<=100) or (x>=teren.width+100) or (y>=teren.height+100) then
             jest:=false;

       end;
end;

procedure rysuj_zwlokikolesi;
var a:longint; tr:trect; sx,sy, px,py:integer; wielkosc: real;
begin
for a:=0 to max_zwlokikolesi do
  if (zwlokikolesi[a].jest) then with zwlokikolesi[a] do begin

// druzyna[team].animacje[ani].surf, pRect4(tr), cColor1(kolor), tPattern(anikl), effectSrcAlpha or effectDiffuse);
        wielkosc:= 1+z;


        px:= trunc( x-ekran.px + (x-ekran.px)*(z-1)/10 );
        py:= trunc( y-ekran.py + (y-ekran.py)*(z-1)/10 );

        sx:= round(druzyna[team].animacje[13].surf.PatternWidth * wielkosc) ;
        sy:= round(druzyna[team].animacje[13].surf.PatternHeight * wielkosc) ;

{        if (trunc(x+obr.zwlokikolesi[gatunek,rodz].ofsx)-ekran.px>=0) and
           (trunc(x-obr.zwlokikolesi[gatunek,rodz].ofsx)-ekran.px<=ekran.width) and
           (trunc(y+obr.zwlokikolesi[gatunek,rodz].ofsy)-ekran.py>=0) and
           (trunc(y-obr.zwlokikolesi[gatunek,rodz].ofsy)-ekran.py<=ekran.height) then}
        if kier=1 then
           form1.PowerDraw1.TextureMap(druzyna[team].animacje[13].surf,
              pRotate4(px,
                       py,
                       sx,
                       sy,
                       sx div 2,
                       sy div 2,
                       0),
                       cWhite4,
                       tPattern(trunc(klatka_ani)),
                       effectSrcAlpha)
        else
           form1.PowerDraw1.TextureMap(druzyna[team].animacje[13].surf,
              pRotate4mirror(px,
                       py,
                       sx,
                       sy,
                       sx div 2,
                       sy div 2,
                       0),
                       cWhite4,
                       tPattern(trunc(klatka_ani)),
                       effectSrcAlpha);

        if palisie then
           form1.PowerDraw1.TextureMap(obr.pocisk[5].surf,
              pRotate4(px,
                       py,
                       round(sx*2),
                       round(sy*2),
                       round(sx),
                       round(sy),
                       0),
                       cColor1( cardinal( (180+random(70)) shl 24+$FFFFFF ) ),
                       tPattern(random(26)),
                       effectSrcAlpha or effectDiffuse);

end;

end;


end.
