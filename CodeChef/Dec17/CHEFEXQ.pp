{$mode objfpc}
program CHEFEXQ;
uses
  fgl;
type
  TIntList = specialize TFPGList<Int64>;

var
  XorResults: TIntList;
  A: TIntList;

procedure Update(Index, V: Integer);
var
  d: Integer;
  i: Integer;
  Delta: Integer;

begin
  d := A[Index];
  A[Index] := V;
  Delta := v xor d;
  for i := Index to XorResults.Count - 1 do
    XorResults[i] := XorResults[i] xor Delta;
{
  for i := 0 to XorResults.Count - 1 do
    Write(A[i], ' ');
  WriteLn;
  for i := 0 to XorResults.Count - 1 do
    Write(XorResults[i], ' ');
  WriteLn;
}
end;

function Run(LIndex, y: Integer): Int64;
var
  i: Integer;

begin
  Result := 0;

  for i := 1 to LIndex do
    if XorResults[i] = y then
      Inc(Result);
end;

var
  N, Q: Integer;
  i: Integer;
  XorResult: Integer;
  k, x, y: Integer;

begin
  ReadLn(N, Q);

  A := TIntList.Create;
  XorResults := TIntList.Create;
  A.Add(0);
  XorResults.Add(0);

  XorResult := 0;
  for i := 1 to N do
  begin
    Read(x);
    A.Add(x);
    XorResult := XorResult xor x;
    XorResults.Add(XorResult);
  end;

  for i := 1 to Q do
  begin
    Read(k);
    if k = 1 then
    begin
      ReadLn(x, y);
      Update(x, y);
    end
    else
    begin
      ReadLn(x, y);
      WriteLn(Run(x, y));
    end;
   
  end;

end.
