{$mode objfpc}
program CHEFHAM;
uses
  fgl;
type
  TIntList = specialize TFPGList<Int64>;
  TIntIntMap = array[0..200000] of Integer;

function ReadData: TIntList;
var
  N: Integer;
  i: Integer;
  m: Int64;

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

function GenData: TIntList;
var
  N: Integer;
  i: Integer;
  m: Int64;
  CountMap: TIntIntMap;

begin
FillChar(CountMap, SizeOf(CountMap), 0);
N := 10;

  Result := TIntList.Create;
  Result.Capacity := N;
  for i := 1 to N do
  begin
m := Random(1000);
     Inc(CountMap[m]);
     while CountMap[m] > 2 do
       Inc(m);
     Result.Add(m)
  end;
end;


procedure Solve(Ai: TIntList);
var
  CountMap: TIntIntMap;
  i: Integer;
  Once, Twice: TIntList;
  Count: Int64;
  N: Int64;
  OMapping, TMapping1, TMapping2: TIntIntMap;
  IsMarked: array[0..100000] of Boolean;

begin
  FillChar(OMapping, SizeOf(OMapping), 255);
  FillChar(TMapping1, SizeOf(TMapping1), 255);
  FillChar(TMapping2, SizeOf(TMapping2), 255);
  FillChar(IsMarked, SizeOf(IsMarked), 0);

  Once := TIntList.Create;
  Twice := TIntList.Create;

  FillChar(CountMap, SizeOf(CountMap), 0);
  for i := 0 to Ai.Count - 1 do
    Inc(CountMap[Ai[i]]);
  for i := 0 to Ai.Count - 1 do
  begin
    if CountMap[Ai[i]] = 1 then
    begin
      Once.Add(Ai[i]);
      OMapping[Ai[i]] := Ai[i];
    end
    else if (CountMap[Ai[i]] = 2) and (not IsMarked[Ai[i]]) then
    begin
      IsMarked[Ai[i]] := True;
      Twice.Add(Ai[i]);
      TMapping1[Ai[i]] := Ai[i];
      TMapping2[Ai[i]] := Ai[i];
    end;
  end;
  if Twice.Count * 2 + Once.Count <> Ai.Count then
    Halt(2);

  for i := 0 to Once.Count - 1 do
    OMapping[Once[i]] := Once[(i + 1) mod Once.Count];

  for i := 0 to Twice.Count - 1 do
  begin
    TMapping1[Twice[i]] := Twice[(i + 1) mod Twice.Count];
    TMapping2[Twice[i]] := Twice[(i + 1) mod Twice.Count];
  end;

  N := Ai.Count;
  Count := N;

  if Twice.Count = 1 then
  begin
    if Once.Count = 0 then
      Count := 0
    else if Once.Count = 1 then
    begin // 1 2 2
          // 2 1 2
      Count := 2;
      TMapping1[Twice[0]] := Once[0];
      OMapping[Once[0]] := Twice[0];
    end
    else  // 1 2 3 4 5 5
    begin // 2 1 5 5 3 4
      Count := N;
      OMapping[Once[Once.Count - 2]] := Twice[0];
      OMapping[Once[Once.Count - 1]] := Twice[0];
      TMapping1[Twice[0]] := Once[Once.Count - 2];
      TMapping2[Twice[0]] := Once[Once.Count - 1];
      if Once.Count = 3 then
        Count := N - 1;
      for i := 0 to Once.Count - 3 do
        OMapping[Once[i]] := Once[(i + 1) mod (Once.Count - 2)];
    end;
  end
  else if Once.Count = 1 then
  begin
    if Twice.Count = 0 then
      Count := 0
    else if Twice.Count = 1 then
    begin
      //booo!
    end
    else   // 1 1 2 2 3 
    begin  // 2 2 1 3 1
      Count := N;
      TMapping2[Twice.Last] := Once[0];
      OMapping[Once[0]] := Twice[0];
    end;
  end;

  WriteLn(Count);
  for i := 0 to Ai.Count - 1 do
    CountMap[Ai[i]] := 0;
  for i := 0 to Ai.Count - 1 do
  begin
    if i <> 0 then
      Write(' ');
    if OMapping[Ai[i]] <> -1 then
    begin
      Write(OMapping[Ai[i]]);
      if OMapping[Ai[i]] <> Ai[i] then
        Dec(Count);
    end
    else if (TMapping1[Ai[i]] <> -1) and (CountMap[Ai[i]] = 0) then
    begin
      Write(TMapping1[Ai[i]]);
      if TMapping1[Ai[i]] <> Ai[i] then
        Dec(Count);
    end
    else if (TMapping2[Ai[i]] <> -1) and (CountMap[Ai[i]] = 1) then
    begin
      Write(TMapping2[Ai[i]]);
      if TMapping2[Ai[i]] <> Ai[i] then
        Dec(Count);
    end;
    CountMap[Ai[i]] := CountMap[Ai[i]] + 1;
  end;
  WriteLn;

  Once.Free;
  Twice.Free;
  if Count <> 0 then
  begin
WriteLn(Ai.Count);
    for i := 0 to Ai.Count -1 do
      Write(Ai[i], ' ');
WriteLn;
WriteLn('Count = ', Count);
Halt(1);
  end;
end;

var
  T: Integer;
  ai: TIntList;

begin
T := 10000;
  ReadLn(T);

  while T <> 0 do
  begin
    Ai := ReadData;
    //Ai := GenData;
    Solve(ai);
    Ai.Free;

    Dec(T);
  end;
end.
