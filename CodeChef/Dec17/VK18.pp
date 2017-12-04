{$mode objfpc}
program VK18;
uses
  fgl;
const
  MaxN = 1000000;

type
  TIntList = specialize TFPGList<Int64>;

var
  Si, SSi, Ti: TIntList;

procedure ExtractDigits(n: Integer; Digits: TIntList);
begin
  Digits.Clear;
  
  while n <> 0 do
  begin
    Digits.Add(n mod 10);
    n := n div 10;
  end;
end;


procedure ComputeSi;
var
  i, d, j: Integer;
  Digits: TIntList;
  Sij: array[0..7] of TIntList;
  S: Int64;
  Source, Target: TIntList;

begin
  Sij[1] := TIntList.Create;
  for d := 0 to 9 do
    Sij[1].Add(d);

  for i := 2 to 7 do
  begin
    Source := Sij[i - 1];
    Target := TIntList.Create;
    Sij[i] := Target;
    Target.Capacity := Source.Capacity * 10;

    for j := 0 to Source.Count - 1 do
      for d := 0 to 9 do
        Target.Add(Source[j] + (2 * (d and 1) - 1) * d);
  end;
  Si := Target;
  SSi := TIntList.Create;
  Ssi.Count := 2 * MaxN + 1;
  SSi[0] := 0;
  for i := 0 to 2 * MaxN do
    Si[i] := Abs(Si[i]);

  for i := 1 to 2 * MaxN do
    SSi[i] := SSi[i - 1] + Abs(Si[i]);

{
  for i := 0 to 2 * MaxN do
    if i <= 20 then
      WriteLn(i, ':', Si[i]);
}
end;

{
  Ti(N + 1) <-
    Ti(N) + 2 (Si[N + 1] + ... + Si[2N - 1]) + Si[2N]
}

procedure ComputeTi;
var
  i, j: Integer;
begin
  Ti := TIntList.Create;
  Ti.Count := MaxN + 1;

  Ti[1] := 2;
  for i := 2 to MaxN do
    Ti[i] := Ti[i - 1] + 2 * (SSi[2 * i - 1] - SSi[i]) + Si[2 * i];
end;

function Naive(N: Integer): Int64;
var
  i, j, l: Integer;
  k : Integer;
  Ci: TIntList;
  S: Int64;

begin
  Ci := TIntList.Create;
  Result := 0;

  for i := 1 to  N do
    for j := 1 to N do
    begin
      k := i + j;
      ExtractDigits(k, Ci);
    
      S := 0;
      for l := 0 to Ci.Count - 1 do
        if Odd(Ci[l]) then
          Inc(S, Ci[l])
        else
          Dec(S, Ci[l]);
      Result := Result + Abs(S);
    end;

end;


var
  N: Integer;
  T: Integer;

begin
  ComputeSi;
  ComputeTi;
  ReadLn(T);

  while T <> 0 do
  begin
   ReadLn(N);
   WriteLn(Ti[N]);
//   if Ti[N] <> Naive(N) then
//     WriteLn(N, ':', Ti[N], ' :', Naive(N));

    Dec(T);
  end;
end.
