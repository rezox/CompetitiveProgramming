{$mode objfpc}
program CHEFFA;
uses
  fgl;

type
  TIntList = specialize TFPGList<Integer>;

var
  N: Integer;
function ReadData: TIntList;
var
  i, x: Integer;
begin
  Result := TIntList.Create;

  ReadLn(N);
  Result.Add(0);
  for i := 1 to N do 
  begin
    Read(x);
    Result.Add(x);
  end;
  for i := N + 1 to 100 do
    Result.Add(0);
end;

const
  Modulo : Int64 = 1000000007;

function Solve(const A: TIntList): Int64;
var
  Index: Integer;
  i, j: Integer;
  ai: Integer;
  DP: array [0..100, 0..100, 0..100] of Int64;
  Maxs: array[0..100] of Int64;
  tmp: Int64;
  IndexSum: Int64;

begin
  if N = 1 then
    Exit(1);
  FillChar(DP, SizeOf(DP), 0);
  FillChar(Maxs, SizeOf(Maxs), 0);
  DP[2, 0, 0] := 1;

  Maxs[1] := A[1];
  Maxs[2] := A[2];
  Result := 0;
  for Index := 3 to A.Count - 1 do
  begin
    IndexSum := 0;
    for ai := 0 to 100 do
    begin
      if (N < Index) and (ai = 0) then
        Continue;
 
      for j := 0 to Maxs[Index - 1] do
        if ai <= A[Index - 1] + j then
        begin
          tmp := 0;
          for i := 0 to Maxs[Index - 2] do
            if (ai <= A[Index - 2] + i - j) and (DP[Index -1, i, j] <> 0) then
            begin
              tmp := (tmp + DP[Index - 1, i, j]) mod Modulo;
              //  WriteLn('Contribuing:', i, ' ', j, ' -> ', DP[Index - 1, i, j]);
            end;
            //if tmp <> 0 then
            //  WriteLn('Index:', Index, ' j:', j, ' ai:', ai, ' tmp:', tmp);
          DP[Index, j, ai] := tmp;
          IndexSum := (IndexSum + tmp) mod Modulo;

          if tmp = 0 then
          begin
            Maxs[Index] := ai;
            Break;
          end;
        end;
    end;

    if N <= Index then
    begin
      //WriteLn(Index, ':', IndexSum);
      Result := (Result + IndexSum) mod Modulo;
    end;
  end;
  if N <= 2 then
    Inc(Result);
end;

var
  T: Integer;
  A: TIntList;

begin
  ReadLn(T);

  while T <> 0 do
  begin 
    A := ReadData;
    WriteLN(Solve(A));
    A.Free;

    Dec(T);
  end;
end.
