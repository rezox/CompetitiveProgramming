{$mode objfpc}
program CHEFMOVR;
uses
  fgl;

type
  TIntList = specialize TFPGList<Int64>;

var
  N, D: Integer;
  Ai: TIntList;

procedure ReadData;
var
  i: Integer;
  x: Int64;

begin
  ReadLn(N, D);
  
  Ai := TIntList.Create;

  for i := 1 to N do
  begin
    Read(x);
    Ai.Add(x);
  end;
end;

function Solve: Int64;
var
  i: Integer;
  Sum, Target: Int64;
  Delta: Int64;
  

begin
  Sum := 0;
  for i := 0 to Ai.Count - 1 do
    Inc(Sum, Ai[i]);
  
  if Sum mod N <> 0 then
    Exit(-1);
  Target := Sum div N;

  Result := 0;
  for i:= 0 to Ai.Count - 1 - D do
  begin
    Delta := Target - Ai[i];
    Inc(Result, Abs(Delta));

    Ai[i] := Target;
    Ai[i + D] :=  Ai[i + D] - Delta;
  end;

  for i:= Ai.Count - D to Ai.Count - 1 do
    if Ai[i] <> Target then
      Exit(-1);
end;

var
  T: Integer;

begin
  ReadLn(T);

  while T <> 0 do 
  begin
    ReadData;
    WriteLn(Solve);
    Ai.Free;
     
    Dec(T);
  end;
 
end.
