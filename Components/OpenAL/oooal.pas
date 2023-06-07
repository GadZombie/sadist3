unit oooal;

interface

uses al, altypes, alut, sysutils, classes;

{ Shortcut methods to alut.XXX methods
  We duplicate function name here, so that
  users of oooal unit does not need to import alut unit.
}
procedure alutInit(argc: PALint; argv: array of PChar; ile_zrodel_: integer);
procedure alutExit;

const max_zrodel=32;

type
   TAlObject = class(TCollectionItem)
   private
      _waveDataLoaded: boolean;
      _buffer: TALuint;
      _source: TALuint;
      _ktore_zrodlo: integer;

      _mozna_przerwac: boolean;

      _pos: array [0..2] of TALFloat;
      _vel: array [0..2] of TALFloat;
      _pitch: TALFloat;  // can make sound higher
      _gain: TALFloat;   // how lound is played
      //_loop: TALInt;     // loop: AL_TRUE, AL_FALSE
      _loop: boolean;
          _relative: TALInt;
      procedure AllocateALBuffers;
      procedure DisposeALBuffers;

      function SourceState: TALInt;
      function PlayingState: boolean;
   protected
   public
      constructor Create;
      destructor Destroy; override;
      procedure LoadFromFile(filename: string);
      procedure Update;
      procedure Play;
      Procedure Play_gdzie(n:integer);
      procedure Pause;
      procedure Stop;
      property xpos: TALFloat read _pos[0] write _pos[0];
      property ypos: TALFloat read _pos[1] write _pos[1];
      property zpos: TALFloat read _pos[2] write _pos[2];
      property xvel: TALFloat read _vel[0] write _vel[0];
      property yvel: TALFloat read _vel[1] write _vel[1];
      property zvel: TALFloat read _vel[2] write _vel[2];
      property pitch: TALFloat read _pitch write _pitch;
      property gain: TALFloat read _gain write _gain;
      //property loop: TALInt read _loop write _loop;
      property loop: boolean read _loop write _loop;

      property mozna_przerwac: boolean read _mozna_przerwac write _mozna_przerwac;

      property state: TALInt read SourceState;
      property Playing: boolean read PlayingState;
      property relative: TALInt read _relative write _relative;
   end;

var
   ile_zrodel: integer;
   zrodla: array[0..max_zrodel-1] of TALuint;
   zrodla_ust: array[0..max_zrodel-1] of record
      wolne: boolean;
      mozna_przerwac: boolean;
      ciagly: boolean;
   end;

   procedure Zrodla_odswiez;
   function Znajdz_wolny_kanal(var coprzerwano: integer; brutalnie: boolean=false): integer;
   procedure Wyczysc_wszystkie_zrodla;

implementation
uses unit1;

procedure Zrodla_odswiez;
var
  a:integer;
  state:TAlint;
begin
for a:=0 to ile_zrodel-1 do begin
    AlGetSourcei(zrodla[a], AL_SOURCE_STATE, @state);
    zrodla_ust[a].wolne:= (state <> AL_PLAYING) and (not zrodla_ust[a].ciagly);
end;

end;

function Znajdz_wolny_kanal(var coprzerwano: integer; brutalnie: boolean=false): integer;
var
  a:integer;
  state:TAlint;
begin
coprzerwano:=-1;
a:=0;
while (a<ile_zrodel) and (not zrodla_ust[a].wolne) do
    inc(a);

if a<ile_zrodel then
   result:=a
else begin
   a:=0;
   while (a<ile_zrodel) and (not zrodla_ust[a].mozna_przerwac) do
      inc(a);
   if a<ile_zrodel then begin
      coprzerwano:=a;
      result:=a;
   end
   else begin
      if not brutalnie then
         result:=-1
      else begin //znajdz kanal, wywalajac nawet taki, ktorego nie mozna przerywac (tylko nie ciagly!)
         a:=0;
         while (a<ile_zrodel) and (zrodla_ust[a].ciagly) do
            inc(a);
         if a<ile_zrodel then begin
            coprzerwano:=a;
            result:=a;
            if zrodla_ust[a].ciagly then
               result:=-2;
         end else
            result:=-1;
      end;
   end;
end;

end;


procedure Wyczysc_wszystkie_zrodla;
var
  a:integer;
  state:TAlint;
begin
for a:=0 to ile_zrodel-1 do begin
    AlGetSourcei(zrodla[a], AL_SOURCE_STATE, @state);
    if state = AL_PLAYING then AlSourceStop(zrodla[a]);
    zrodla_ust[a].ciagly:=false;
    zrodla_ust[a].wolne:= true;

    AlSourcei( zrodla[a], AL_BUFFER, -1);

end;

end;


//---------------------------------
procedure alutInit(argc: PALint; argv: array of PChar; ile_zrodel_: integer);
var a:integer;
begin
   alut.alutInit(argc, argv);
   ile_zrodel:=ile_zrodel_;

   for a:=0 to ile_zrodel-1 do begin
       zrodla_ust[a].wolne:=true;
       zrodla_ust[a].mozna_przerwac:=true;
       zrodla_ust[a].ciagly:=false;
   end;

   AlGenSources(ile_zrodel, @zrodla);
   if alGetError <> AL_NO_ERROR then
      raise Exception.Create('Cannot create Source');

end;

procedure alutExit;
begin
   alut.alutExit;
end;


//---------------------------------------------
constructor TalObject.Create;
begin
  AllocateALBuffers;

  // set default value attributes
  gain := 1.0;
  pitch := 1.0;
  xpos := 0.0;
  ypos := 0.0;
  zpos := 0.0;
  xvel := 0.0;
  yvel := 0.0;
  zvel := 0.0;

  mozna_przerwac:=false;

  //Update;  // update source attributes
end;

destructor TalObject.Destroy;
begin
  DisposeALBuffers;
  inherited destroy;
end;

procedure TalObject.AllocateALBuffers;
begin
  // create a buffer and source
  AlGenBuffers(1, @_buffer);
  if alGetError <> AL_NO_ERROR then
      raise Exception.Create('Cannot create Buffer');
{  AlGenSources(1, @_source);
  if alGetError <> AL_NO_ERROR then
      raise Exception.Create('Cannot create Source');}
end;

procedure TalObject.DisposeALBuffers;
begin
  Stop; // make sure its stopped

  //first delete the source
{  AlDeleteSources(1, @_source);
  if alGetError <> AL_NO_ERROR then
      raise Exception.Create('Cannot delete Source');
}
  //then delete the buffer
  AlDeleteBuffers(1, @_buffer);
  if alGetError <> AL_NO_ERROR then
      raise Exception.Create('Cannot delete Buffer');

  _waveDataLoaded := false;
end;

var
  err: TALenum;

procedure TalObject.LoadFromFile(filename: string);
var
  format: TALEnum;
  size: TALSizei;
  freq: TALSizei;
  floop: TALInt;
  data: TALVoid;

begin
  if (_waveDataLoaded) then begin
     // release previous buffer data before
     // loading a new wavedata.
     DisposeALBuffers;
     AllocateALBuffers;
  end;

  //load the wavedata from the file, then
  //assign the wavedata to the buffer
  AlutLoadWavFile(filename, format, data, size, freq, floop);
  AlBufferData(_buffer, format, data, size, freq);
  err:=alGetError;
  if err <> AL_NO_ERROR then
      raise Exception.Create('Cannot assign wave data to buffer');
  _waveDataLoaded := true;

  //remove the wavedata from memory
  AlutUnloadWav(format, data, size, freq);
  //assign the buffer to the source
//  AlSourcei( _source, AL_BUFFER, _buffer);
  _source:=zrodla[0];

  //loop := floop; // loop value from audio file
  // we always want loaded file default to loop=FALSE
  _loop := false;
{  if (floop = AL_TRUE) then begin
      AlSourcei( _source, AL_LOOPING, AL_FALSE);
  end;}
end;

{ Update Sound properties (pitch, gain, position, velocity, looping }
Procedure TalObject.Update;
begin
 //pass the 'changed' values on to openal
 AlSourcef ( _source, AL_PITCH, _pitch );
 AlSourcef ( _source, AL_GAIN, _gain );
 AlSourcefv ( _source, AL_POSITION, @_pos);
 AlSourcefv ( _source, AL_VELOCITY, @_vel);
 if _relative=AL_FALSE then begin
    alSourcef  ( _source, AL_MIN_GAIN, 1);
    alSourcef  ( _source, AL_MAX_GAIN, 1);
 end else begin
 end;
 AlSourcei ( _source, AL_LOOPING, Bool2ALBool(_loop));

{ //pass the 'changed' values on to openal
 AlSourcef ( _source, AL_PITCH, _pitch );
 AlSourcef ( _source, AL_GAIN, _gain );
 AlSourcefv ( _source, AL_POSITION, @_pos);
 AlSourcefv ( _source, AL_VELOCITY, @_vel);
 if _relative=AL_FALSE then begin
    alSourcef  ( _source, AL_MIN_GAIN, 1);
    alSourcef  ( _source, AL_MAX_GAIN, 1);
 end else begin
 end;
 AlSourcei ( _source, AL_LOOPING, _loop);
}

end;

Procedure TalObject.Play;
var i,p:integer;
  state:TAlint;
begin
Zrodla_odswiez;
  i:=Znajdz_wolny_kanal(p,{loop}true);
  if i=-1 then exit;

  if p>=0 then begin
     AlGetSourcei(zrodla[p], AL_SOURCE_STATE, @state);
     if state = AL_PLAYING then AlSourceStop(zrodla[p]);
     zrodla_ust[p].ciagly:=false; //UWAGA: tu jest blad; zrodla[p] zwraca jakis handler i do tej tablicy to nie pasuje, wiec sie wywala
  end;

  _source:=zrodla[i];
  _ktore_zrodlo:=i;
  zrodla_ust[i].ciagly:=loop;
  zrodla_ust[i].mozna_przerwac:=mozna_przerwac;
  //assign the buffer to the source
  AlSourcei( _source, AL_BUFFER, _buffer);

  //loop := floop; // loop value from audio file
  // we always want loaded file default to loop=FALSE
//  _loop := false;
//  if (floop = AL_TRUE) then begin
  if loop then AlSourcei( _source, AL_LOOPING, AL_TRUE)
          else AlSourcei( _source, AL_LOOPING, AL_FALSE);
//  end;

  AlSourcePlay(_source);
  Update;
end;

Procedure TalObject.Play_gdzie(n:integer);
var i,p:integer;
  state:TAlint;
begin
Zrodla_odswiez;
  i:=n;
  if i=-1 then exit;

  AlGetSourcei(zrodla[i], AL_SOURCE_STATE, @state);
  if state = AL_PLAYING then AlSourceStop(zrodla[i]);
  zrodla_ust[i].ciagly:=false; //2012-10-09

  _source:=zrodla[i];
  _ktore_zrodlo:=i;
  zrodla_ust[i].ciagly:=loop;
  zrodla_ust[i].mozna_przerwac:=mozna_przerwac;
  //assign the buffer to the source
  AlSourcei( _source, AL_BUFFER, _buffer);

  //loop := floop; // loop value from audio file
  // we always want loaded file default to loop=FALSE
//  _loop := false;
//  if (floop = AL_TRUE) then begin
  if loop then AlSourcei( _source, AL_LOOPING, AL_TRUE)
          else AlSourcei( _source, AL_LOOPING, AL_FALSE);
//  end;

  AlSourcePlay(_source);
  Update;
end;


Procedure TalObject.Stop;
begin
  AlSourceStop(_source);
  zrodla_ust[_ktore_zrodlo].ciagly:=false;
end;

Procedure TalObject.Pause;
begin
  AlSourcePause(_source);
end;

{ Get sound source state:
     AL_INITIAL, AL_PLAYING, AL_STOPPED, AL_PAUSED
}
Function TalObject.SourceState: TALInt;
var
   state: TALint;
begin
   AlGetSourcei(_source, AL_SOURCE_STATE, @state);
   Result := state;
end;

Function TalObject.PlayingState: boolean;
begin
   Result := (SourceState = AL_PLAYING);
end;

end.

