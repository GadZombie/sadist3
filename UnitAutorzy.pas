unit UnitAutorzy;

interface
uses types, vars, unitgraglowna, dialogs, forms;

procedure dzialaj_autorzy;
procedure pokazuj_autorzy;
procedure zacznij_autorzy;
procedure zakoncz_autorzy;

const
max_slajd=8;

var
aut:record
    ktory_slajd:integer;
    czas_do_nastepnego, teraz_czasu:integer;
    slajd_obecny,slajd_ten_drugi:byte; {1 lub 2}
    alfa:array[1..2] of byte;
    alfanap:byte;
    end;

logoaut:TSprajt;
logot:integer;

czasy:array[1..max_slajd] of integer;
napisy:array[1..max_slajd] of array of record
             x,y:integer;
             t:string;
             end;

implementation
uses unit1, directinput8, powertypes, unitmenusy, PowerDraw3;

procedure dzialaj_autorzy;
begin
dec(aut.czas_do_nastepnego);
if aut.czas_do_nastepnego<=0 then begin
   inc(aut.ktory_slajd);
   if aut.ktory_slajd>=max_slajd+2 then
      aut.ktory_slajd:=1;

   aut.slajd_ten_drugi:=aut.slajd_obecny;
   inc(aut.slajd_obecny);
   if aut.slajd_obecny>=3 then
      aut.slajd_obecny:=1;

   if obr.autorzy_slajd[aut.slajd_obecny].surf<>nil then begin
      obr.autorzy_slajd[aut.slajd_obecny].surf.Free;
      obr.autorzy_slajd[aut.slajd_obecny].surf:=nil;
   end;
   if aut.ktory_slajd<=max_slajd then
      robsprajt(obr.autorzy_slajd[aut.slajd_obecny],'Data\slajd'+l2t(aut.ktory_slajd,0)+'.tga',-1,-1,32);

   if aut.ktory_slajd<=max_slajd then aut.teraz_czasu:=czasy[aut.ktory_slajd]
      else aut.teraz_czasu:=500;
   aut.czas_do_nastepnego:=aut.teraz_czasu;
end;

if aut.alfa[aut.slajd_obecny]<255 then begin
   inc(aut.alfa[aut.slajd_obecny]);
end;
if aut.alfa[aut.slajd_ten_drugi]>0 then dec(aut.alfa[aut.slajd_ten_drugi]);

if (aut.czas_do_nastepnego<=aut.teraz_czasu-50) and
   (aut.czas_do_nastepnego>=aut.teraz_czasu-200) then begin
   if aut.alfanap<255 then begin
      if aut.alfanap+2>255 then aut.alfanap:=255
         else inc(aut.alfanap,2);
   end;
end else
if aut.czas_do_nastepnego<=140 then begin
   if aut.alfanap>0 then begin
      if aut.alfanap-2<0 then aut.alfanap:=0
         else dec(aut.alfanap,2);
   end;
end;

inc(logot);
end;

procedure pokazuj_autorzy;
var tr:trect;a,b:integer; c:cardinal;
begin
form1.PowerDraw1.Clear($FF000000);
form1.PowerDraw1.BeginScene();
tr:=rect(0,0,form1.PowerDraw1.width,form1.PowerDraw1.Height);
form1.PowerDraw1.ClipRect:=tr;

if obr.autorzy_slajd[aut.slajd_ten_drugi].surf<>nil then begin
   form1.PowerDraw1.TextureMap(obr.autorzy_slajd[aut.slajd_ten_drugi].surf,
                 pBounds4(form1.PowerDraw1.Width div 2-obr.autorzy_slajd[aut.slajd_ten_drugi].rx div 2,
                          form1.PowerDraw1.Height div 2-obr.autorzy_slajd[aut.slajd_ten_drugi].ry div 2,
                          obr.autorzy_slajd[aut.slajd_ten_drugi].rx,
                          obr.autorzy_slajd[aut.slajd_ten_drugi].ry),
                          cColor1($FFFFFF + (aut.alfa[aut.slajd_ten_drugi] shl 24)),
                          tPattern(0),effectsrcalpha or effectdiffuse);
end;
if obr.autorzy_slajd[aut.slajd_obecny].surf<>nil then begin
   form1.PowerDraw1.TextureMap(obr.autorzy_slajd[aut.slajd_obecny].surf,
                 pBounds4(form1.PowerDraw1.Width div 2-obr.autorzy_slajd[aut.slajd_obecny].rx div 2,
                          form1.PowerDraw1.Height div 2-obr.autorzy_slajd[aut.slajd_obecny].ry div 2,
                          obr.autorzy_slajd[aut.slajd_obecny].rx,
                          obr.autorzy_slajd[aut.slajd_obecny].ry),
                          cColor1($FFFFFF + (aut.alfa[aut.slajd_obecny] shl 24)),
                          tPattern(0),effectsrcalpha or effectdiffuse);
end;


b:=30-trunc(cos(logot/160)*30);
c:=(b shl 24) or $FFFFFF;

form1.PowerDraw1.TextureMap(logoaut.surf,
      pRotate4(form1.powerdraw1.Width div 2,
               form1.powerdraw1.Height div 2,
               logoaut.rx, logoaut.ry,
               logoaut.ofsx, logoaut.ofsy,
               logot/7.8361),
      cColor1(c),
      tPattern(0),effectsrcalpha or effectdiffuse);

b:=30+trunc(cos(logot/160)*30);
c:=(b shl 24) or $FFFFFF;

form1.PowerDraw1.TextureMap(logoaut.surf,
      pRotate4(form1.powerdraw1.Width div 2,
               form1.powerdraw1.Height div 2,
               logoaut.rx, logoaut.ry,
               logoaut.ofsx, logoaut.ofsy,
               -logot/6.1234),
      cColor1(c),
      tPattern(0),effectsrcalpha or effectdiffuse);

a:=logot mod 824;
if (a>=0) and (a<=100) then begin

    b:=trunc(  10-cos( (a*3.6) * (pi/180) )*10  );
    c:=(b shl 24) or $FFFFFF;

    form1.PowerDraw1.TextureMap(logoaut.surf,
          pBounds4(form1.powerdraw1.Width div 2 -a*5,
                   form1.powerdraw1.Height div 2 -a*5,
                   a*10, a*10

                   ),
          cColor1(c),
          tPattern(0),effectsrcalpha or effectdiffuse);

end;

if (aut.ktory_slajd>=1) and (aut.ktory_slajd<=max_slajd) then begin
   if aut.alfanap<=70 then b:=17+70-aut.alfanap
      else b:=17;
   for a:=0 to high(napisy[aut.ktory_slajd]) do
       piszdowolne(napisy[aut.ktory_slajd][a].t,
                   napisy[aut.ktory_slajd][a].x,//+(b-17)*4*((-1)*(a mod 2)+((a+1) mod 2)),
                   napisy[aut.ktory_slajd][a].y-(b-17)/2,
                   $FFFFFF+ (aut.alfanap shl 24),16,b);
end;

form1.PowerDraw1.EndScene();
form1.PowerDraw1.Present();
end;

procedure zrob_napis(n,x,y:integer; t1:array of string);
var a,il,dl:integer;
begin
il:=length(t1);
setlength(napisy[n],length(t1));
dl:=0;
for a:=0 to il-1 do begin
    napisy[n][a].x:=x-length(t1[a])*8;
    napisy[n][a].y:=y-length(t1)*10+a*20;
    napisy[n][a].t:=t1[a];
    dl:=dl+length(t1[a]);
end;
czasy[n]:=dl*15;
if czasy[n]<500 then czasy[n]:=500;
end;

procedure zacznij_autorzy;
var
 sx,sy:integer;
begin
glowne_co_widac:=2;
//Form1.pokaz_wczytywanie('wczytywanie');
with aut do begin
   ktory_slajd:=0;
   czas_do_nastepnego:=0;
   slajd_obecny:=1;
   slajd_ten_drugi:=2;
   alfa[1]:=0;
   alfa[2]:=0;
   alfanap:=0;
end;

logot:=0;

sx:=form1.PowerDraw1.Width div 2;
sy:=form1.PowerDraw1.Height div 2;

zrob_napis(1,sx,sy,['SADIST 3','','PRAWDZIWI ZABÓJCY']);
zrob_napis(2,sx,sy,['Pomys³ i program:','Grzegorz "GAD" Drozd']);
zrob_napis(3,sx,sy,['Grafika:','Grzegorz "GAD" Drozd']);
zrob_napis(4,sx,sy,['Pomys³ intro:','Grzegorz "GAD" Drozd','oraz','Krzysztof Kucharz']);
zrob_napis(5,sx,sy,['Intro wykona³:','Krzysztof Kucharz']);
zrob_napis(6,sx,sy,['Muzyka','Pro-Creation','http://pro-creation.com.pl/','http://www.myspace.com/prosiaki']);
//zrob_napis(7,sx,sy,['W skladzie:','Fater','Ktos tam','i jeszcze paru...','itd','potem sie bede tym zajmowal']);
zrob_napis(7,sx,sy,['ATARI XL/XE','rulez!','Commodore 64','suxx! :-)']);
zrob_napis(8,sx,sy,['8-bit rulez','2D rulez','Old-school rulez']);

robsprajt(logoaut,'Graphics\logoautorzy.tga',480,480);

//Form1.schowaj_wczytywanie;
form1.PowerTimer1.MayRender:= True;
form1.PowerTimer1.MayProcess:= True;

form1.wylaczmuzyke;
form1.grajkawalek('..\Data\autorzy.mp3',true);
form1.wlaczmuzyke(true);
end;

procedure zakoncz_autorzy;
var
 a:Integer;
begin
form1.PowerTimer1.MayRender:=false;
form1.PowerTimer1.MayProcess:=false;

 if logoaut.surf<>nil then begin
    logoaut.surf.Free;
    logoaut.surf:=nil;
 end;

for a:=1 to max_slajd do
    setlength(napisy[a],0);

if obr.autorzy_slajd[1].surf<>nil then begin
   obr.autorzy_slajd[1].surf.Free;
   obr.autorzy_slajd[1].surf:=nil;
end;
if obr.autorzy_slajd[2].surf<>nil then begin
   obr.autorzy_slajd[2].surf.Free;
   obr.autorzy_slajd[2].surf:=nil;
end;
end;

end.
