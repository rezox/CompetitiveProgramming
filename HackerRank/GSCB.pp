{$mode objfpc}
program GSCBB;
uses
  fgl, Math;
type
  TIntList = specialize TFPGList<Integer>;

var
  N: Integer;
  Prices: TIntList;
  k: Int64;

procedure ReadData;
var
  i: Integer;
  p: Integer;
begin
  ReadLn(N);
  Prices := TIntList.Create;
  Prices.Add(0);

  for i := 1 to N do
  begin
    Read(p);

    Prices.Add(p);
  end;
  ReadLn;
  ReadLn(k);

end;

var
  Indices: TIntList;

procedure Sort(l,r: longint);
var
   i,j,x,y: longint;
begin
   i:=l;
   j:=r;
   x:=Prices[Indices[(l+r) div 2]];
   repeat
     while Prices[Indices[i]]<x do
      inc(i);
     while x<Prices[Indices[j]] do
      dec(j);
     if not(i>j) then
       begin
          y:=Indices[i];
          Indices[i]:=Indices[j];
          Indices[j]:=y;
          inc(i);
          j:=j-1;
       end;
   until i>j;
   if l<j then
     Sort(l,j);
   if i<r then
     Sort(i,r);
end;

function Solve: Int64;
var
  i: Integer;
  Count: Integer;

begin
  Indices := TIntList.Create;
  Indices.Count := N + 1;
  for i := 0 to N do
    Indices[i] := i;
  Sort(1, N);

  Result := 0;
  for i := 1 to N do
  begin
    Count := Min(k div Prices[Indices[i]], Indices[i]);
    Inc(Result, Count);
    Dec(k, Count * Prices[Indices[i]]);
    //WriteLn('k:', k, ' Count:', Count, ' Indices[', i, ']:', Indices[i], ' Result:', Result);
  end;
end;

begin
  ReadData;
  WriteLn(Solve);

end.
