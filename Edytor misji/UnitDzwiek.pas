unit UnitDzwiek;

interface
uses classes, al, altypes, alut, oooal;

type

{  TDzwiek= class(TCollectionItem)
    private
    public
      source:TAdrSampleSource;
      SoundEf: TAdrSoundEffect;
      Sound: TAdrOutputStream;
    published
      procedure Stop;
      property Ciagly: Boolean read FCiagly write FCiagly;
  end;
}
  TDzwieki = class (TCollection)
  private
    function GetItem(Index: Integer): TAlObject;
  public
    function Add: TAlObject;
    property Item[Index: Integer]: TAlObject read GetItem;
  end;

implementation

function TDzwieki.Add: TAlObject;
begin
  result := inherited Add as TAlObject;
end;

function TDzwieki.GetItem(Index: Integer): TAlObject;
begin
  result := inherited Items[Index] as TAlObject;
end;


end.
