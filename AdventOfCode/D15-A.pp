{$mode objfpc}
program D15A;
uses
  fgl;

var
  InitA, InitB: Integer;

const
  MultiplierA = 16807;
  MultiplierB =  48271;
  Modulo = 2147483647;

type
  TIntList = specialize TFPGList<Int64>;

function Generate(Init, Multiplier: Int64; Count: Integer): TIntList;
var
  i: Integer;

begin
  Result := TIntList.Create;
  
  Result.Add((Init * Multiplier) mod Modulo);
  for i := 2 to Count do
    Result.Add((Result.Last * Multiplier) mod Modulo);
end;

function CountInCommon(A, B: TIntList): Integer;
var 
  i: Integer;

begin
  Result := 0;
  for i := 0 to A.Count - 1 do
    if A[i] and $FFFF = B[i] and $FFFF then
      Inc(Result);

end;

var
  AList, BList: TIntList; 
  Count: Integer;

begin
  ReadLn(InitA, InitB);
  Count := 40000000;
 
  AList := Generate(InitA, MultiplierA, Count);
  BList := Generate(InitB, MultiplierB, Count);
  WriteLn(CountInCommon(AList, BList));
end.
