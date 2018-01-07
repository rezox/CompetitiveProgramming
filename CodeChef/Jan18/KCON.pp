{$mode objfpc}
program KCON;
uses
  fgl, Math;

type
  TIntList = specialize TFPGList<Int64>;

var
  N, K: Int64;
  Ai: TIntList;

procedure ReadData;
var
  a: Int64;
  i: Integer;

begin
  ReadLn(N, K);

  Ai.Free;
  Ai := TIntList.Create;
  for i := 1 to N do
  begin
    Read(a);
    Ai.Add(a);
  end;
end;

function FindMaxSum(const A: TIntList): Int64;
var
  i: Integer;
  Current: Int64;

begin
  Result := A[0];
  Current := 0;
  for i := 0 to A.Count - 1 do
  begin
    Inc(Current, A[i]);
    if Current < A[i] then
      Current := A[i];
    if Result < Current then
      Result := Current;
  end;
end;

function NMaxSum(const A: TIntList): Int64;
var
  i, j, k: Integer;
  Current: Int64;

begin
  Result := A[0];
  for i := 0 to A.Count - 1 do
    for j := i to A.Count - 1 do
    begin
      Current := 0;
      for k := i to j do
        Inc(Current, A[k]);
      if Result < Current then
        Result := Current;
    end;
end;


function Solve(const A: TIntList): Int64;

  function FindMaxPostfix(const A: TIntList): Int64;
  var
    i: Integer;
    Current: Int64;

  begin
    Current := 0;
    Result := A.Last;

    for i := A.Count - 1 downto 0 do
    begin
      Inc(Current, A[i]);
      if Result < Current then
        Result := Current;
    end;
  end;

  function FindMaxPrefix(const A: TIntList): Int64;
  var
    i: Integer;
    Current: Int64;

  begin
    Current := 0;
    Result := A[0];

    for i := 0 to A.Count - 1 do
    begin
      Inc(Current, A[i]);
      if Result < Current then
        Result := Current;
    end;
  end;

{ ai..aN TotalSum TotalSum a1...ak }
var
  TotalSum: Int64;
  i: Integer;
  MaxSum: Int64;
  Postfix, Prefix: Int64;

begin
  TotalSum := 0;
  for i := 0 to Ai.Count - 1 do
    Inc(TotalSum, Ai[i]);

  MaxSum := FindMaxSum(Ai);
  Postfix := FindMaxPostfix(Ai);
  Prefix := FindMaxPrefix(Ai);

  // WriteLn('MaxSum:', MaxSum);
  // WriteLn('Prefix:', Prefix);
  // WriteLn('Postfix:', Postfix);
  // WriteLn('TotalSum:', TotalSum);

  Result := MaxSum;
  
  if 2 <= K then
  begin
    Result := Max(Result, (K - 1) * TotalSum + Prefix);
    Result := Max(Result, Postfix + (K - 1) * TotalSum);
    Result := Max(Result, Postfix + Prefix);
    Result := Max(Result, Postfix + (K - 2) * TotalSum + Prefix);
  end;
end;

function NSolve(const Ai: TIntList): Int64;
var
  TmpList: TIntList;
  i, j: Integer;

begin
  TmpList := TIntList.Create;
  for j := 1 to K do
    for i := 0 to Ai.Count - 1 do
      TmpList.Add(Ai[i]);
{
    for i := 0 to TmpList.Count - 1 do
      Write(TmpList[i], ' ');
    WriteLn;
}
  Result := NMaxSum(TmpList);
  if NMaxSum(TmpList) <> FindMaxSum(TmpList) then
  begin
    WriteLn('NMaxSum:', NMaxSum(TmpList));
    WriteLn('FindMaxSum:', FindMaxSum(TmpList));
    Halt(1);
  end;
  TmpList.Free;
end;


procedure Test;
var
  i: Integer;
  T: Integer;

  procedure RandomReadData;
  var
    a: Int64;
    i: Integer;
  
  begin
    N := 2 + Random(10);
    k := 1; // + Random(10);
  
    Ai.Free;
    Ai := TIntList.Create;
    // Write('a:');
    for i := 1 to N do
    begin
      a := Random(20) - 15;
      Ai.Add(a);
      // Write(a, ' ');
    end;
    // WriteLn;
  end;

begin
  Ai := nil;
  ReadLn(T);
  T := 100000;

  while T <> 0 do
  begin
    RandomReadData;
    
    if Solve(Ai)<> NSolve(Ai) then
    begin
      WriteLn('Solve:', FindMaxSum(Ai));
      WriteLn('NSolve:', NMaxSum(Ai));
      WriteLn;
      WriteLn(N, ' ', K);
      for i := 0 to Ai.Count -1 do
        Write(Ai[i], ' ');
      WriteLn;
      break;
    end;
    
    //WriteLn(FindMaxSum(Ai), ' ', NMaxSum(Ai));

    Dec(T);
  end;
end;


var
  T: Integer;

begin
  Ai := nil;
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;
    WriteLn(Solve(Ai));

    Dec(T);
  end;
end.
