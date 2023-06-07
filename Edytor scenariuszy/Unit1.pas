unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, DXDraws, Buttons, Grids, DIB, ImgList,
  unitstringi, vars, Spin, unitscenio;

type
  TForm1 = class(TForm)
    st: TPageControl;
    Ogolne: TTabSheet;
    Panel5: TPanel;
    listascenariuszy: TListBox;
    Panel6: TPanel;
    Label4: TLabel;
    oprogramie: TTabSheet;
    tekstoprogramie: TStaticText;
    skrologolne: TScrollBox;
    Label1: TLabel;
    nnazwa: TEdit;
    Label2: TLabel;
    nautor: TEdit;
    Label3: TLabel;
    ndatastworzenia: TDateTimePicker;
    Splitter2: TSplitter;
    Panel8: TPanel;
    Zapisz: TSpeedButton;
    Wczytaj: TSpeedButton;
    Obiekty: TTabSheet;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    obinazwa: TLabel;
    obiwlasciwosci: TLabel;
    Texobinazwa: TLabel;
    Texobiwlasciwosci: TLabel;
    Panel7: TPanel;
    zoomin: TSpeedButton;
    zoomout: TSpeedButton;
    zoom100: TSpeedButton;
    zoomcale: TSpeedButton;
    zoombar: TTrackBar;
    texzoomin: TSpeedButton;
    texzoomout: TSpeedButton;
    texzoom100: TSpeedButton;
    texzoomcale: TSpeedButton;
    texzoombar: TTrackBar;
    skrolpodglad: TScrollBox;
    texskrolpodglad: TScrollBox;
    Podgob: TPaintBox;
    Panel3: TPanel;
    ListaObiektow: TListBox;
    Tekstury: TTabSheet;
    Tlo: TTabSheet;
    TexListaObiektow: TListBox;
    TexPodgob: TPaintBox;
    Texwiele: TSpeedButton;
    Panel4: TPanel;
    wierzch: TPaintBox;
    spod: TPaintBox;
    ColorDialog1: TColorDialog;
    wierzchrodz: TSpeedButton;
    wierzchkol: TSpeedButton;
    spodrodz: TSpeedButton;
    spodkol: TSpeedButton;
    Panel10: TPanel;
    skroltla: TScrollBox;
    Panel9: TPanel;
    tlogora: TSpeedButton;
    tlodol: TSpeedButton;
    tloobr: TPaintBox;
    tlowl: TCheckBox;
    GroupBox1: TGroupBox;
    widslon: TCheckBox;
    winksie: TCheckBox;
    widgwia: TCheckBox;
    widchmu: TCheckBox;
    widdeszsnie: TCheckBox;
    Label5: TLabel;
    szybczas: TSpinEdit;
    czasstand: TSpeedButton;
    Panel11: TPanel;
    Panel12: TPanel;
    Label6: TLabel;
    wybtex: TLabel;
    Splitter3: TSplitter;
    wybobi: TListBox;
    Label7: TLabel;
    Panel13: TPanel;
    czyscliste: TSpeedButton;
    ciecz1: TCheckBox;
    Label8: TLabel;
    ciecz2: TCheckBox;
    ciecz3: TCheckBox;
    ciecz4: TCheckBox;
    ciecz5: TCheckBox;
    ciecz0: TCheckBox;
    podgladtla: TPaintBox;
    czastla: TTrackBar;
    tloplay: TSpeedButton;
    TimerTla: TTimer;
    Splitter4: TSplitter;
    minutytla: TTrackBar;
    TloTempo: TTrackBar;
    procedure FormCreate(Sender: TObject);

    procedure zroblistyplikow;
    procedure ListaObiektowClick(Sender: TObject);
    procedure podgterPaint(Sender: TObject);
    procedure zoominClick(Sender: TObject);
    procedure zoomoutClick(Sender: TObject);
    procedure zoom100Click(Sender: TObject);
    procedure zoomcaleClick(Sender: TObject);
    procedure zoombarChange(Sender: TObject);
    procedure ZapiszClick(Sender: TObject);
    procedure listascenariuszyClick(Sender: TObject);
    procedure WczytajClick(Sender: TObject);
    procedure wybobiDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure wybobiDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListaObiektowDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure ListaObiektowDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TexListaObiektowClick(Sender: TObject);
    procedure TexPodgobPaint(Sender: TObject);
    procedure TexzoombarChange(Sender: TObject);
    procedure TexzoominClick(Sender: TObject);
    procedure TexzoomoutClick(Sender: TObject);
    procedure Texzoom100Click(Sender: TObject);
    procedure TexzoomcaleClick(Sender: TObject);
    procedure TexwieleClick(Sender: TObject);
    procedure wierzchPaint(Sender: TObject);
    procedure wierzchkolClick(Sender: TObject);
    procedure wierzchrodzClick(Sender: TObject);
    procedure tloobrPaint(Sender: TObject);
    procedure tlogoraClick(Sender: TObject);
    procedure tlodolClick(Sender: TObject);
    procedure skroltlaResize(Sender: TObject);
    procedure tlowlClick(Sender: TObject);
    procedure czasstandClick(Sender: TObject);
    procedure czysclisteClick(Sender: TObject);
    procedure czastlaChange(Sender: TObject);
    procedure tloplayClick(Sender: TObject);
    procedure TimerTlaTimer(Sender: TObject);
    procedure minutytlaChange(Sender: TObject);
    procedure TloTempoChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

  ustawienia:record
     zoom:double;
     texzoom:double;
     wybranyobiekt,
     wybranyscen,

     wybranatex:string;

     wierzchr:array[0..1] of integer;
     wierzchk:array[0..1] of cardinal;

  end;

  obiekt,tex:tbitmap;
  hnd:integer;

  tla:array[0..23] of record
      ramka:TPanel;
      obr:TPaintBox;
      wlacz:TCheckbox;
      guzg,guzd:TSpeedButton;
  end;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var a:integer;
begin
ChDir(ExtractFilePath(Application.ExeName));

with ustawienia do begin
     zoom:=1;
     texzoom:=1;
     wierzchr[0]:=1;
     wierzchk[0]:=$109060;
     wierzchr[1]:=2;
     wierzchk[1]:=$000030;
end;

skrolpodglad.DoubleBuffered:=true;
texskrolpodglad.DoubleBuffered:=true;
panel10.DoubleBuffered:=true;

ndatastworzenia.DateTime:=now;
randomize;

for a:=0 to 23 do begin
    tla[a].ramka:=TPanel.create(form1);
    tla[a].ramka.parent:=skroltla;
    tla[a].ramka.width:=112;
    tla[a].ramka.height:=145;
    tla[a].ramka.tag:=a;

    tla[a].obr:=TPaintbox.create(form1);
    tla[a].obr.parent:=tla[a].ramka;
    tla[a].obr.width:=110;
    tla[a].obr.Height:=121;
    tla[a].obr.left:=1;
    tla[a].obr.top:=1;
    tla[a].obr.OnPaint:=tloobrPaint;
    tla[a].obr.tag:=a;

    tla[a].wlacz:=TCheckbox.create(form1);
    tla[a].wlacz.parent:=tla[a].ramka;
    tla[a].wlacz.width:=16;
    tla[a].wlacz.Height:=16;
    tla[a].wlacz.left:=3;
    tla[a].wlacz.top:=124;
    tla[a].wlacz.tag:=a;
    tla[a].wlacz.OnClick:=tlowlClick;

    tla[a].guzg:=TSpeedbutton.create(form1);
    tla[a].guzg.parent:=tla[a].ramka;
    tla[a].guzg.width:=41;
    tla[a].guzg.Height:=17;
    tla[a].guzg.left:=24;
    tla[a].guzg.top:=125;
    tla[a].guzg.tag:=a;
    tla[a].guzg.Caption:='GÛra';
    tla[a].guzg.Flat:=true;
    tla[a].guzg.OnClick:=tlogoraClick;

    tla[a].guzd:=TSpeedbutton.create(form1);
    tla[a].guzd.parent:=tla[a].ramka;
    tla[a].guzd.width:=41;
    tla[a].guzd.Height:=17;
    tla[a].guzd.left:=66;
    tla[a].guzd.top:=125;
    tla[a].guzd.tag:=a;
    tla[a].guzd.Caption:='DÛ≥';
    tla[a].guzd.Flat:=true;
    tla[a].guzd.OnClick:=tlodolclick;

end;
skroltlaResize(skroltla);

zroblistyplikow;

with niebo do begin
     kolorytla[0].zmiana:=true;
     kolorytla[0].gr:=$00;kolorytla[0].gg:=$00;kolorytla[0].gb:=$00;
     kolorytla[0].dr:=$00;kolorytla[0].dg:=$00;kolorytla[0].db:=$20;

     kolorytla[1].zmiana:=true;
     kolorytla[1].gr:=$00;kolorytla[1].gg:=$00;kolorytla[1].gb:=$00;
     kolorytla[1].dr:=$00;kolorytla[1].dg:=$00;kolorytla[1].db:=$00;

     kolorytla[2].zmiana:=true;
     kolorytla[2].gr:=$00;kolorytla[2].gg:=$00;kolorytla[2].gb:=$40;
     kolorytla[2].dr:=$05;kolorytla[2].dg:=$30;kolorytla[2].db:=$80;

     kolorytla[5].zmiana:=true;
     kolorytla[5].gr:=$00;kolorytla[3].gg:=$20;kolorytla[3].gb:=$60;
     kolorytla[5].dr:=$20;kolorytla[3].dg:=$60;kolorytla[3].db:=$C0;

     kolorytla[8].zmiana:=true;
     kolorytla[8].gr:=$10;kolorytla[8].gg:=$50;kolorytla[8].gb:=$B0;
     kolorytla[8].dr:=$50;kolorytla[8].dg:=$80;kolorytla[8].db:=$F0;

     kolorytla[11].zmiana:=true;
     kolorytla[11].gr:=$25;kolorytla[11].gg:=$90;kolorytla[11].gb:=$D0;
     kolorytla[11].dr:=$50;kolorytla[11].dg:=$B0;kolorytla[11].db:=$FF;

     kolorytla[13].zmiana:=true;
     kolorytla[13].gr:=$40;kolorytla[13].gg:=$90;kolorytla[13].gb:=$B0;
     kolorytla[13].dr:=$50;kolorytla[13].dg:=$98;kolorytla[13].db:=$EF;

     kolorytla[17].zmiana:=true;
     kolorytla[17].gr:=$70;kolorytla[17].gg:=$90;kolorytla[17].gb:=$80;
     kolorytla[17].dr:=$B0;kolorytla[17].dg:=$90;kolorytla[17].db:=$CF;

     kolorytla[20].zmiana:=true;
     kolorytla[20].gr:=$60;kolorytla[20].gg:=$80;kolorytla[20].gb:=$70;
     kolorytla[20].dr:=$B0;kolorytla[20].dg:=$A0;kolorytla[20].db:=$80;

     kolorytla[21].zmiana:=true;
     kolorytla[21].gr:=$30;kolorytla[21].gg:=$25;kolorytla[21].gb:=$80;
     kolorytla[21].dr:=$E0;kolorytla[21].dg:=$C0;kolorytla[21].db:=$50;

     kolorytla[22].zmiana:=true;
     kolorytla[22].gr:=$15;kolorytla[22].gg:=$10;kolorytla[22].gb:=$70;
     kolorytla[22].dr:=$A0;kolorytla[22].dg:=$90;kolorytla[22].db:=$90;

     kolorytla[23].zmiana:=true;
     kolorytla[23].gr:=$00;kolorytla[23].gg:=$00;kolorytla[23].gb:=$40;
     kolorytla[23].dr:=$40;kolorytla[23].dg:=$40;kolorytla[23].db:=$90;
end;

for a:=0 to 23 do begin
    tla[a].wlacz.Checked:=niebo.kolorytla[a].zmiana;
end;

end;

function sprawdzpoprawnosc(a:string; min_:integer=-1; max_:integer=-2):string;
var wart,i:integer;
begin
  val(a,wart,i);
  if (i<>0) then begin
     if min_<=max_ then a:=inttostr(min_)
        else a:='0';
  end
  else if ((min_<=max_) and ((wart<min_) or (wart>max_))) then a:=inttostr(min_);
  result:=a;
end;

function wartosc(s:string):integer;
var i:integer;
begin
  val(s,result,i);
end;


procedure TForm1.podgterPaint(Sender: TObject);
var tr:trect; a,sx,sy:integer;
begin
if obiekt<>nil then begin
   form1.podgob.canvas.Font.Height:=13;
   form1.podgob.canvas.Font.Name:='Tahoma';
   form1.podgob.canvas.Font.style:=[];
   form1.podgob.canvas.brush.style:=bsSolid;

//   bmp.PixelFormat:=pf32bit;
   sx:=(skrolpodglad.Width-4) div 2;
   sy:=(skrolpodglad.Height-4) div 2;

   tr.TopLeft:=point( sx-trunc(obiekt.Width*ustawienia.zoom) div 2,
                      sy-trunc(obiekt.Height*ustawienia.zoom) div 2);
   tr.bottomright:=point( tr.left+trunc(obiekt.Width*ustawienia.zoom),
                          tr.top+trunc(obiekt.Height*ustawienia.zoom));

   form1.Podgob.canvas.stretchdraw(tr,obiekt);

   obinazwa.Caption:=ustawienia.wybranyobiekt;
   obiwlasciwosci.Caption:=inttostr(obiekt.Width)+'x'+inttostr(obiekt.Height);
end else begin
    obinazwa.Caption:='-';
    obiwlasciwosci.Caption:='-';
end;
end;

procedure wczytaj_obiekt(nazwa:string);
var
nag:TGAHeader;
p:TStream;
x,y:integer;
c:cardinal;
k:tcolor;

 function wczytajC:cardinal;
 var b:cardinal;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajC:=b;
 end;

begin
try
  p:=TFileStream.Create('Objects\'+nazwa+'.tga',fmOpenRead);
//  p.readbuffer(nag,sizeof(nag));

  with nag do begin
     p.ReadBuffer(idlength,sizeof(idlength));
     p.ReadBuffer(colourmaptype,sizeof(colourmaptype));
     p.ReadBuffer(datatypecode,sizeof(datatypecode));
     p.ReadBuffer(colourmaporigin,sizeof(colourmaporigin));
     p.ReadBuffer(colourmaplength,sizeof(colourmaplength));
     p.ReadBuffer(colourmapdepth,sizeof(colourmapdepth));
     p.ReadBuffer(x_origin,sizeof(x_origin));
     p.ReadBuffer(y_origin,sizeof(y_origin));
     p.ReadBuffer(width,sizeof(width));
     p.ReadBuffer(height,sizeof(height));
     p.ReadBuffer(bitsperpixel,sizeof(bitsperpixel));
     p.ReadBuffer(imagedescriptor,sizeof(imagedescriptor));
  end;


  if nag.bitsperpixel<>32 then raise Exception.Create('Z-a iloùä kolor°w. TGA musi byä 32-bitowa.');
  if nag.datatypecode<>2 then raise Exception.Create('TGA nie mo¨e byä skompresowana.');

  if obiekt<>nil then begin
     obiekt.free;
     obiekt:=nil;
  end;
  obiekt:=tbitmap.create;
  obiekt.PixelFormat:=pf32bit;
  obiekt.Width:=nag.width;
  obiekt.Height:=nag.height;

  for y:=0 to nag.height-1 do begin
      for x:=0 to nag.width-1 do begin
          c:=wczytajC;
          if (c and $FF000000) shr 24=0 then begin
             if ((x div 4+y div 4) mod 2)=0 then k:=$FFFFFF
                else k:=$dfdfdf;
          end else
              k:=(c and $FF) shl 16 +
                 (c and $FF00) +
                 (c and $FF0000) shr 16;
          obiekt.canvas.pixels[x,nag.height-1-y]:=k;
      end;
  end;

  p.free;
except
  on e: Exception do begin
      MessageBox(hnd, pchar(E.Message), 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
      p.free;
      exit;
     end;
  else begin
    MessageBox(hnd, 'Blad przy odczycie pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
    p.free;
    exit;
  end;
end;

end;

procedure tform1.zroblistyplikow;
var
  sr: TSearchRec;
  FileAttrs: Integer;
begin
  ListaObiektow.Clear;
  FileAttrs := faAnyFile;
  if FindFirst('Objects\*.tga', FileAttrs, sr)=0 then begin
     repeat
        sr.Name:=copy(sr.Name,1,length(sr.name)-4);
        ListaObiektow.Items.Add(sr.name);
     until FindNext(sr) <>0;
     FindClose(sr);
  end;

  listascenariuszy.Clear;
  FileAttrs := faAnyFile;
  if FindFirst('Scenarios\*.s3sce', FileAttrs, sr)=0 then begin
     repeat
        sr.Name:=copy(sr.Name,1,length(sr.name)-6);
        listascenariuszy.Items.Add(sr.name);
     until FindNext(sr) <>0;
     FindClose(sr);
  end;

  TexListaObiektow.Clear;
  FileAttrs := faAnyFile;
  if FindFirst('Textures\*.tga', FileAttrs, sr)=0 then begin
     repeat
        sr.Name:=copy(sr.Name,1,length(sr.name)-4);
        TexListaObiektow.Items.Add(sr.name);
     until FindNext(sr) <>0;
     FindClose(sr);
  end;

end;

procedure TForm1.ListaObiektowClick(Sender: TObject);
begin
if (sender as tlistbox).ItemIndex>=0 then begin
   ustawienia.wybranyobiekt:=(sender as tlistbox).items[(sender as tlistbox).ItemIndex];
   wczytaj_obiekt(ustawienia.wybranyobiekt);
   Zapisz.Enabled:=true;
end;
Podgob.Repaint;
end;

procedure TForm1.zoominClick(Sender: TObject);
begin
ustawienia.zoom:=ustawienia.zoom*2;
zoombar.Position:=round(ustawienia.zoom*100);
end;

procedure TForm1.zoomoutClick(Sender: TObject);
begin
ustawienia.zoom:=ustawienia.zoom/2;
zoombar.Position:=round(ustawienia.zoom*100);
end;

procedure TForm1.zoom100Click(Sender: TObject);
begin
ustawienia.zoom:=1;
zoombar.Position:=round(ustawienia.zoom*100);
end;

procedure TForm1.zoomcaleClick(Sender: TObject);
var r:double;
begin
ustawienia.zoom:=(form1.skrolpodglad.width-5)/obiekt.width;
r:=(form1.skrolpodglad.height-5)/obiekt.height;
if r<ustawienia.zoom then ustawienia.zoom:=r;
zoombar.Position:=round(ustawienia.zoom*100);
{form1.podgter.width:=trunc(form1.ObrTerenu.Picture.width*ustawienia.zoom);
form1.podgter.height:=trunc(form1.ObrTerenu.Picture.height*ustawienia.zoom);

form1.podgter.Repaint;}
end;

procedure TForm1.zoombarChange(Sender: TObject);
begin
ustawienia.zoom:=zoombar.Position/100;
form1.Podgob.width:=trunc(obiekt.width*ustawienia.zoom);
form1.podgob.height:=trunc(obiekt.height*ustawienia.zoom);

form1.Podgob.Repaint;
end;

procedure TForm1.ZapiszClick(Sender: TObject);
begin
zapisz_scen(nnazwa.Text);
zroblistyplikow;
end;

procedure TForm1.listascenariuszyClick(Sender: TObject);
var a:integer;
begin
if (sender as tlistbox).ItemIndex>=0 then begin
   ustawienia.wybranyscen:=(sender as tlistbox).items[(sender as tlistbox).ItemIndex];
   Wczytaj.Enabled:=true;
   a:=(sender as tlistbox).ItemIndex;
   zroblistyplikow;
   (sender as tlistbox).ItemIndex:=a;
end;
end;

procedure TForm1.WczytajClick(Sender: TObject);
begin
wczytaj_scen(ustawienia.wybranyscen);
Zapisz.Enabled:=true;
end;

procedure TForm1.wybobiDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TListbox) and ( (Source as TListbox).tag=0 );
end;

procedure TForm1.wybobiDragDrop(Sender, Source: TObject; X, Y: Integer);
var w:string; a:integer;
begin
if (Sender is TListBox) and (Source is TListbox) and
   ((source as TListbox).ItemIndex>=0) and ((source as TListbox).ItemIndex<=(source as TListbox).Items.Count-1) then begin
   w:=(source as TListbox).items[(source as TListbox).ItemIndex];
   a:=0;
   while (a<(sender as TListbox).items.Count) and ((sender as TListbox).items[a]<>w) do inc(a);
   if a>=(sender as TListbox).items.Count then (sender as TListbox).items.Add(w);
end;

end;

procedure TForm1.ListaObiektowDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TListbox) and ( (Source as TListbox).tag=1 );
end;

procedure TForm1.ListaObiektowDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
if (Sender is TListBox) and (Source is TListbox) then begin
   (source as TListbox).Items.Delete( (source as TListbox).ItemIndex );
end;
end;

procedure wczytaj_tex(nazwa:string);
type
 tbufline=array[0..65535] of cardinal;
var
nag:TGAHeader;
p:TStream;
x,y:integer;
c:cardinal;
k:tcolor;

 bufline:^tbufline;

 function wczytajC:cardinal;
 var b:cardinal;
 begin
    p.ReadBuffer(b,sizeof(b));
    wczytajC:=b;
 end;

 function wczytajC24:cardinal;
 var b1,b2,b3:byte;
 begin
    p.ReadBuffer(b1,sizeof(b1));
    p.ReadBuffer(b2,sizeof(b2));
    p.ReadBuffer(b3,sizeof(b3));
    wczytajC24:=cardinal($FF shl 24+  b3 shl 16+ b2 shl 8+ b1);
 end;

begin
try
  p:=TFileStream.Create('Textures\'+nazwa+'.tga',fmOpenRead);
//  p.readbuffer(nag,sizeof(nag));

  with nag do begin
     p.ReadBuffer(idlength,sizeof(idlength));
     p.ReadBuffer(colourmaptype,sizeof(colourmaptype));
     p.ReadBuffer(datatypecode,sizeof(datatypecode));
     p.ReadBuffer(colourmaporigin,sizeof(colourmaporigin));
     p.ReadBuffer(colourmaplength,sizeof(colourmaplength));
     p.ReadBuffer(colourmapdepth,sizeof(colourmapdepth));
     p.ReadBuffer(x_origin,sizeof(x_origin));
     p.ReadBuffer(y_origin,sizeof(y_origin));
     p.ReadBuffer(width,sizeof(width));
     p.ReadBuffer(height,sizeof(height));
     p.ReadBuffer(bitsperpixel,sizeof(bitsperpixel));
     p.ReadBuffer(imagedescriptor,sizeof(imagedescriptor));
  end;


  if not (nag.bitsperpixel in [24,32]) then raise Exception.Create('Z-a iloùä kolor°w. TGA musi byä 24- lub 32-bitowa.');
  if nag.datatypecode<>2 then raise Exception.Create('TGA nie mo¨e byä skompresowana.');

  if tex<>nil then begin
     tex.free;
     tex:=nil;
  end;
  tex:=tbitmap.create;
  tex.PixelFormat:=pf32bit;
  tex.Width:=nag.width;
  tex.Height:=nag.height;

  for y:=0 to nag.height-1 do begin
      bufline:=tex.ScanLine[y];
      for x:=0 to nag.width-1 do begin
          if nag.bitsperpixel=24 then k:=wczytajc24
          else begin
              c:=wczytajC;
              if (c and $FF000000) shr 24=0 then begin
                 if ((x div 4+y div 4) mod 2)=0 then k:=$FFFFFF
                    else k:=$dfdfdf;
              end else
                  k:=(c and $FF) shl 16 +
                     (c and $FF00) +
                     (c and $FF0000) shr 16;
          end;
          //tex.canvas.pixels[x,nag.height-1-y]:=k;
          bufline[x]:=k;//x,nag.height-1-y]:=k;
      end;
  end;

  p.free;
except
  on e: Exception do begin
      MessageBox(hnd, pchar(E.Message), 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
      p.free;
      exit;
     end;
  else begin
    MessageBox(hnd, 'Blad przy odczycie pliku', 'Blad', MB_OK+MB_TASKMODAL+MB_ICONERROR);
    p.free;
    exit;
  end;
end;

end;

procedure TForm1.TexListaObiektowClick(Sender: TObject);
begin
if (sender as tlistbox).ItemIndex>=0 then begin
   Screen.Cursor:=crHourGlass;
   ustawienia.wybranatex:=(sender as tlistbox).items[(sender as tlistbox).ItemIndex];
   wczytaj_tex(ustawienia.wybranatex);
   wybtex.Caption:=ustawienia.wybranatex;
   Zapisz.Enabled:=true;
   Screen.Cursor:=crDefault;
end;
TexPodgob.Repaint;
end;

procedure TForm1.TexPodgobPaint(Sender: TObject);
var tr:trect; a,sx,sy,x,y:integer;
begin
if tex<>nil then begin
   form1.podgob.canvas.Font.Height:=13;
   form1.podgob.canvas.Font.Name:='Tahoma';
   form1.podgob.canvas.Font.style:=[];
   form1.podgob.canvas.brush.style:=bsSolid;

//   bmp.PixelFormat:=pf32bit;
   sx:=(texskrolpodglad.Width-4) div 2;
   sy:=(texskrolpodglad.Height-4) div 2;

   if not Texwiele.Down then begin
       tr.TopLeft:=point( sx-trunc(tex.Width*ustawienia.texzoom) div 2,
                          sy-trunc(tex.Height*ustawienia.texzoom) div 2);
       tr.bottomright:=point( tr.left+trunc(tex.Width*ustawienia.texzoom),
                              tr.top+trunc(tex.Height*ustawienia.texzoom));

       form1.TexPodgob.canvas.stretchdraw(tr,tex);
   end else begin
       for y:=0 to trunc( ((sender as tpaintbox).height-1) / (tex.Height*ustawienia.texzoom) ) do
          for x:=0 to trunc( ((sender as tpaintbox).width -1) / (tex.Width*ustawienia.texzoom) ) do begin
              tr.TopLeft:=point( trunc( x* tex.Width*ustawienia.texzoom),
                                 trunc( y* tex.Height*ustawienia.texzoom) );
              tr.bottomright:=point( tr.left+trunc(tex.Width*ustawienia.texzoom),
                                     tr.top+trunc(tex.Height*ustawienia.texzoom));
              form1.TexPodgob.canvas.stretchdraw(tr,tex);
          end;
   end;

   Texobinazwa.Caption:=ustawienia.wybranatex;
   Texobiwlasciwosci.Caption:=inttostr(tex.Width)+'x'+inttostr(tex.Height);
end else begin
    obinazwa.Caption:='-';
    obiwlasciwosci.Caption:='-';
end;
end;

procedure TForm1.TexzoombarChange(Sender: TObject);
begin
ustawienia.texzoom:=texzoombar.Position/100;
form1.TexPodgob.width:=trunc(tex.width*ustawienia.Texzoom);
form1.Texpodgob.height:=trunc(Tex.height*ustawienia.Texzoom);

form1.TexPodgob.Repaint;
end;

procedure TForm1.TexzoominClick(Sender: TObject);
begin
ustawienia.texzoom:=ustawienia.texzoom*2;
texzoombar.Position:=round(ustawienia.texzoom*100);
end;

procedure TForm1.TexzoomoutClick(Sender: TObject);
begin
ustawienia.texzoom:=ustawienia.texzoom/2;
texzoombar.Position:=round(ustawienia.texzoom*100);
end;

procedure TForm1.Texzoom100Click(Sender: TObject);
begin
ustawienia.texzoom:=1;
texzoombar.Position:=round(ustawienia.texzoom*100);
end;

procedure TForm1.TexzoomcaleClick(Sender: TObject);
var r:double;
begin
ustawienia.texzoom:=(form1.texskrolpodglad.width-5)/tex.width;
r:=(form1.texskrolpodglad.height-5)/tex.height;
if r<ustawienia.texzoom then ustawienia.texzoom:=r;
texzoombar.Position:=round(ustawienia.texzoom*100);
end;

procedure TForm1.TexwieleClick(Sender: TObject);
begin
TexPodgob.Repaint;
end;

procedure TForm1.wierzchPaint(Sender: TObject);
var tr:trect;
begin
tr.TopLeft:=point(0,0);
tr.BottomRight:=point((sender as tpaintbox).Width,(sender as tpaintbox).Height);
with (sender as tpaintbox).Canvas do begin
    pen.Color:=clblack;
    case ustawienia.wierzchr[(sender as tpaintbox).tag] of
       0:begin
         Brush.Color:=clBtnShadow;
         Rectangle(tr);
         Pen.color:=clred;
         moveto(0,0);
         lineto((sender as TPaintbox).width,(sender as TPaintbox).height);
         end;
       1:begin
         Brush.Color:=TColor(ustawienia.wierzchk[(sender as tpaintbox).tag]);
         Rectangle(tr);
         end;
       3:begin
         Brush.Color:=$e0e0e0;
         Rectangle(tr);
         end;
       2:begin
         Brush.Color:=$303030;
         Rectangle(tr);
         end;
    end;
end;

end;

procedure TForm1.wierzchkolClick(Sender: TObject);
begin
ColorDialog1.Color:=ustawienia.wierzchk[(sender as TSpeedbutton).tag];
if ColorDialog1.Execute then
   ustawienia.wierzchk[(sender as TSpeedbutton).tag]:=ColorDialog1.Color;
wierzch.Repaint;
spod.Repaint;
end;

procedure TForm1.wierzchrodzClick(Sender: TObject);
begin
inc(ustawienia.wierzchr[(sender as TSpeedbutton).tag]);
if ustawienia.wierzchr[(sender as TSpeedbutton).tag]>=4 then ustawienia.wierzchr[(sender as TSpeedbutton).tag]:=0;
(sender as TSpeedbutton).Caption:='Rodzaj= '+inttostr(ustawienia.wierzchr[(sender as TSpeedbutton).tag]);
wierzch.Repaint;
spod.Repaint;
end;

procedure TForm1.tloobrPaint(Sender: TObject);
var
r,g,b:byte;
a,a1:integer;
n:byte;
s:string;

gr,gg,gb,
dr,dg,db: byte;
kod,kdo,ile:integer;
kn:real;

  function Dec2Hex(num: cardinal): string;
  var
     b: word;
     s, h: string;
  begin
     h:= '0123456789ABCDEF';
     s:= '';
     b:= 0;
     repeat
        b:= num and 15;
        num:= num shr 4;
        s:= h[b + 1] + s;
     until num = 0;
     while length(s)<6 do insert('0',s,1);

     Dec2Hex:= s;
  end;

begin
n:=(sender as TPaintbox).tag;
with (sender as TPaintbox).canvas do begin

{     if (tla[(sender as TPaintbox).tag].wlacz<>nil) and (tla[(sender as TPaintbox).tag].wlacz.Checked) then begin
         gr:=niebo.kolorytla[n].gr;
         gg:=niebo.kolorytla[n].gg;
         gb:=niebo.kolorytla[n].gb;
         dr:=niebo.kolorytla[n].dr;
         dg:=niebo.kolorytla[n].dg;
         db:=niebo.kolorytla[n].db;
     end else }
     kn:=0;
     if not ((tla[(sender as TPaintbox).tag].wlacz<>nil) and (tla[(sender as TPaintbox).tag].wlacz.Checked)) then begin
         a1:=(sender as TPaintbox).tag;
         while ((tla[a1].wlacz<>nil) and (not tla[a1].wlacz.Checked)) do begin
               dec(a1);
               if a1<0 then a1:=23;
               kn:=kn+1;
         end;
         kod:=a1;
     end else begin
         kod:=(sender as TPaintbox).tag;
     end;

     a:=(sender as TPaintbox).tag+1;
     if a>=24 then a:=0;
     if not ((tla[a].wlacz<>nil) and (tla[a].wlacz.Checked)) then begin
         a1:=a;
         while ((tla[a1].wlacz<>nil) and (not tla[a1].wlacz.Checked)) do begin
               inc(a1);
               if a1>23 then a1:=0;
         end;
         kdo:=a1;
     end else kdo:=a;

         ile:=(kdo-kod+24) mod 24;

         if ile=0 then ile:=1;

         if (sender as TPaintbox).Name='podgladtla' then begin
            kn:=kn+ minutytla.Position/60;
         end;

         gr:= niebo.kolorytla[kod].gr+ trunc( (niebo.kolorytla[kdo].gr - niebo.kolorytla[kod].gr)*( (kn/ile)) );
         gg:= niebo.kolorytla[kod].gg+ trunc( (niebo.kolorytla[kdo].gg - niebo.kolorytla[kod].gg)*( (kn/ile)) );
         gb:= niebo.kolorytla[kod].gb+ trunc( (niebo.kolorytla[kdo].gb - niebo.kolorytla[kod].gb)*( (kn/ile)) );

         dr:= niebo.kolorytla[kod].dr+ trunc( (niebo.kolorytla[kdo].dr - niebo.kolorytla[kod].dr)*( (kn/ile)) );
         dg:= niebo.kolorytla[kod].dg+ trunc( (niebo.kolorytla[kdo].dg - niebo.kolorytla[kod].dg)*( (kn/ile)) );
         db:= niebo.kolorytla[kod].db+ trunc( (niebo.kolorytla[kdo].db - niebo.kolorytla[kod].db)*( (kn/ile)) );

    // end;

    for a:=1 to (sender as TPaintbox).height-1 do begin
         r:=trunc( gr + (dr-gr) * (a/(sender as TPaintbox).height) );
         g:=trunc( gg + (dg-gg) * (a/(sender as TPaintbox).height) );
         b:=trunc( gb + (db-gb) * (a/(sender as TPaintbox).height) );
         pen.Color:=r+g shl 8+b shl 16;
         moveto(0,a);
         lineto((sender as TPaintbox).Width,a);
    end;
    if (tla[(sender as TPaintbox).tag].wlacz<>nil) and (not tla[(sender as TPaintbox).tag].wlacz.Checked) and
       ((sender as TPaintbox).Name<>'podgladtla') then begin
           brush.color:=$808080;
           pen.Width:=2;
           brush.Style:=bsDiagCross;
      //     Rectangle(0,0,(sender as TPaintbox).Width,(sender as TPaintbox).height);
           brush.Style:=bsSolid;

           Pen.color:=clblack;
           moveto(0,2);
           lineto((sender as TPaintbox).Width,(sender as TPaintbox).Width+2);
           moveto(0,(sender as TPaintbox).Width+2);
           lineto((sender as TPaintbox).Width,2);
           Pen.color:=clred;
           moveto(0,1);
           lineto((sender as TPaintbox).Width,(sender as TPaintbox).Width+1);
           moveto(0,(sender as TPaintbox).Width+1);
           lineto((sender as TPaintbox).Width,1);
    end else begin
        brush.Style:=bsClear;
        font.Name:='Arial';
        font.size:=8;
        font.Style:=[];
        //s:='$'+Dec2Hex(cardinal(niebo.kolorytla[n].gb+niebo.kolorytla[n].gg shl 8+ niebo.kolorytla[n].gr shl 16));
        s:='$'+Dec2Hex(cardinal(gb+gg shl 8+ gr shl 16));
        font.Color:=clblack;
        TextOut((sender as TPaintbox).Width-TextWidth(s)-1,2,s);
        font.Color:=clYellow;
        TextOut((sender as TPaintbox).Width-TextWidth(s)-1,1,s);

//        s:='$'+Dec2Hex(cardinal(niebo.kolorytla[n].db+niebo.kolorytla[n].dg shl 8+ niebo.kolorytla[n].dr shl 16));
        s:='$'+Dec2Hex(cardinal(db+dg shl 8+ dr shl 16));
        font.Color:=clblack;
        TextOut((sender as TPaintbox).Width-TextWidth(s)-1,(sender as TPaintbox).Height-TextHeight(s)-1,s);
        font.Color:=clYellow;
        TextOut((sender as TPaintbox).Width-TextWidth(s)-1,(sender as TPaintbox).Height-TextHeight(s)-2,s);
    end;
    brush.Style:=bsClear;
    font.Name:='Arial';
    font.size:=9;
    font.Style:=[fsbold];
    if (sender as TPaintbox).Name='podgladtla' then begin
       s:=':'+l2t(minutytla.Position,2);
    end else s:=':00';
    font.Color:=clblack;
    TextOut(2,2,l2t((sender as TPaintbox).tag,2)+s);
    font.Color:=clWhite;
    TextOut(3,1,l2t((sender as TPaintbox).tag,2)+s);

end;

end;

procedure TForm1.tlogoraClick(Sender: TObject);
var a:integer;
begin
ColorDialog1.Color:=niebo.kolorytla[(sender as TSpeedButton).tag].gr+
                    niebo.kolorytla[(sender as TSpeedButton).tag].gg shl 8+
                    niebo.kolorytla[(sender as TSpeedButton).tag].gg shl 16;
if ColorDialog1.Execute then begin
   niebo.kolorytla[(sender as TSpeedButton).tag].gr:=ColorDialog1.Color and $FF;
   niebo.kolorytla[(sender as TSpeedButton).tag].gg:=(ColorDialog1.Color and $FF00) shr 8;
   niebo.kolorytla[(sender as TSpeedButton).tag].gb:=(ColorDialog1.Color and $FF0000) shr 16;
end;
for a:=0 to 23 do tla[a].obr.Repaint;
end;

procedure TForm1.tlodolClick(Sender: TObject);
var a:integer;
begin
ColorDialog1.Color:=niebo.kolorytla[(sender as TSpeedButton).tag].dr+
                    niebo.kolorytla[(sender as TSpeedButton).tag].dg shl 8+
                    niebo.kolorytla[(sender as TSpeedButton).tag].dg shl 16;
if ColorDialog1.Execute then begin
   niebo.kolorytla[(sender as TSpeedButton).tag].dr:=ColorDialog1.Color and $FF;
   niebo.kolorytla[(sender as TSpeedButton).tag].dg:=(ColorDialog1.Color and $FF00) shr 8;
   niebo.kolorytla[(sender as TSpeedButton).tag].db:=(ColorDialog1.Color and $FF0000) shr 16;
end;
for a:=0 to 23 do tla[a].obr.Repaint;
end;

procedure TForm1.skroltlaResize(Sender: TObject);
var a,sz:integer;
begin
sz:=((sender as TScrollbox).clientWidth div 120)*120;
if sz<120 then sz:=120;
for a:=0 to 23 do if tla[a].ramka<>nil then begin
    tla[a].ramka.left:=(a*120) mod sz-(sender as TScrollbox).HorzScrollBar.Position;
    tla[a].ramka.top:=((a*120) div sz) *150-(sender as TScrollbox).VertScrollBar.Position;
end;

end;

procedure TForm1.tlowlClick(Sender: TObject);
var a:integer;
begin
niebo.kolorytla[(sender as TCheckbox).tag].zmiana:=(sender as TCheckbox).Checked;
for a:=0 to 23 do tla[a].obr.Repaint;
end;

procedure TForm1.czasstandClick(Sender: TObject);
begin
szybczas.Value:=40;
end;

procedure TForm1.czysclisteClick(Sender: TObject);
begin
wybobi.Clear;
end;

procedure TForm1.czastlaChange(Sender: TObject);
begin
podgladtla.Tag:=(sender as TTrackBar).Position;
podgladtla.Repaint;
end;

procedure TForm1.tloplayClick(Sender: TObject);
begin
TimerTla.Enabled:=(Sender as TSpeedButton).Down;
end;

procedure TForm1.TimerTlaTimer(Sender: TObject);
begin
if minutytla.Position=minutytla.Max then begin
   minutytla.Position:=0;
   if czastla.Position=czastla.Max then czastla.Position:=0
      else czastla.Position:=czastla.Position+1;
end else
    minutytla.Position:=minutytla.Position+1;
end;

procedure TForm1.minutytlaChange(Sender: TObject);
begin
if (TimerTla.Enabled) and (minutytla.Position=0) then exit;
podgladtla.Repaint;
end;

procedure TForm1.TloTempoChange(Sender: TObject);
begin
 TimerTla.Interval:=(sender as ttrackbar).Position;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
canclose:=MessageBox(form1.Handle,'czy chcesz wyjúÊ?','pytanie', MB_YESNO or MB_ICONQUESTION or MB_TASKMODAL)=IDYES;
end;

end.
