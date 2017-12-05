program CHEFHAM;
uses
  fgl;
type
  TIntList = specialize TFPList<Integer>;

function ReadData: TIntList;
var
  N: Integer;
  i: Integer;
  m: Integer;

begin
  ReadLn(N);

  Result := TIntList.Create;
  Result.Capacity := N;

  for i := 1 to N do
  begin
    Read(m);
    Result.Add(m);
  end;
end;

type
  TIntIntMap = specialize TFPGMap<Integer, Integer>;

procedure Solve(Ai: TIntList);
var
  CountMap: TIntIntMap;

begin
end;

var
  T: Integer;
  ai: TIntList;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ai := ReadData;
    Solve(ai);
    ai.Free;

    Dec(T);
  end;
end.
