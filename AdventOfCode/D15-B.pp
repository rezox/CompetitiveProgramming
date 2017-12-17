{$mode objfpc}
program D15B;
uses
  math, fgl;

var
  InitA, InitB: Integer;

const
  MultiplierA = 16807;
  MultiplierB =  48271;
  Modulo = 2147483647;

type
  TIntList = specialize TFPGList<Int64>;

function Generate(Init, Multiplier: Int64; OutputIf: Integer; Count: Integer): TIntList;
var
  i: Integer;

begin
  Result := TIntList.Create;
  
  while Result.Count < Count do
  begin
    Init := (Init * Multiplier) mod Modulo;
    if Init mod OutputIf = 0 then
      Result.Add(Init);
  end;
end;

function CountInCommon(A, B: TIntList): Integer;
var 
  i: Integer;

begin
  Result := 0;
  for i := 0 to Min(A.Count, B.Count) - 1 do
    if A[i] and $FFFF = B[i] and $FFFF then
      Inc(Result);
end;

var
  AList, BList: TIntList; 
  Count: Integer;

begin
  ReadLn(InitA, InitB);
  Count := 5000000;
 
  AList := Generate(InitA, MultiplierA, 4, Count);
  BList := Generate(InitB, MultiplierB, 8, Count);
  WriteLn(CountInCommon(AList, BList));
end.
