{$mode objfpc}
program TWOCOINS;
uses
  fgl, Math;
type
  TIntList = specialize TFPGList<Integer>;
  TBoolList = specialize TFPGList<Boolean>;
const
  Inf = 1000000;

var
  N: Integer;
  Neighbors: array[0..100000] of TIntList;

procedure ReadData;
var
  i: Integer;
  u, v: Integer;
begin
  ReadLn(N);

  for i := 1 to N do
    Neighbors[i] := TIntList.Create;

  for i := 1 to N - 1 do
  begin
    ReadLn(u, v);
    Neighbors[u].Add(v);
    Neighbors[v].Add(u);
  end;
end;

var
  R, C: TIntList;
  Visited: TBoolList;

function Solve: Integer;

  function ComputeR(u, ParentIndex: Integer): Integer;
  var
    i: Integer;
    NIndex: Integer;

  begin
WriteLn('ComputeR');
    Result := 1;
    for i := 0 to Neighbors[u].Count - 1 do
    begin
      NIndex := Neighbors[u][i];
      if NIndex = ParentIndex then Continue;

      Inc(Result, Min(R[NIndex], C[NIndex]));
    end;
  end;

  function ComputeC(u, ParentIndex: Integer): Integer;
  var
    MinIndex1, MinIndex2: Integer;
    MinVal1, MinVal2: Integer;
    NIndex: Integer;
    i: Integer;

  begin
    Result := 0;
    MinVal1 := Inf; MinVal2 := Inf;
    MinIndex1 := -1; MinIndex2 := -1; 

    for i := 0 to Neighbors[u].Count - 1 do
    begin
      NIndex := Neighbors[u][i];
      if NIndex = ParentIndex then Continue;

      if Math.Min(R[NIndex], C[NIndex]) < MinVal1 then
      begin
         MinVal2 := MinVal1;
         MinIndex2 := MinIndex1;
         MinVal1 := Math.Min(R[NIndex], C[NIndex]);
         MinIndex1 := NIndex;
      end
      else if Math.Min(R[NIndex], C[NIndex]) < MinVal2 then
      begin
         MinVal2 := Math.Min(R[NIndex], C[NIndex]);
         MinIndex2 := NIndex;
      end;
 
      Inc(Result, Min(R[NIndex], C[NIndex]));
    end;
    if (MinIndex1 = -1) or (MinIndex2 = -1) then
      Exit(Inf);
    Dec(Result, Min(R[MinIndex1], C[MinIndex1]));
    Dec(Result, Min(R[MinIndex2], C[MinIndex2]));
    Inc(Result, R[MinIndex1]);
    Inc(Result, R[MinIndex2]);
  end;

  procedure DFS(u: Integer);
  var
    ParentIndex: Integer;
    NIndex: Integer;
    i, j: Integer;

  begin
    WriteLn('u', u);
    Visited[u] := True;
    ParentIndex := -1;
    for i := 0 to Neighbors[u].Count - 1 do
    begin
       if Visited[Neighbors[u][i]] then
       begin
         ParentIndex := Neighbors[u][i];
         Continue;
       end;

       DFS(Neighbors[u][i]);
    end;
WriteLn('u:', u, ' parentIndex: ', ParentIndex);
    // Computing R[u]: U, itself, has a coin on it:
    R[u] := ComputeR(u, ParentIndex);
WriteLn('u:', u, ' R[u]: ', R[u]);
    // Computing C[u]: U has no a coin on it:
    C[u] := ComputeC(u, ParentIndex);
  end;

var
  i: Integer;

begin
  Visited := TBoolList.Create; Visited.Count := N + 1;
  R := TIntList.Create; C := TIntList.Create;
  R.Count := N + 1; C.Count := N + 1;

  DFS(1);
  Result := Min(R[1], C[1]);

  for i := 1 to N do
    WriteLn(i, ':', R[i], ':', C[i]);
end;

procedure ReleaseMemory;
var
  i: Integer;
begin
  for i := 1 to N do
    Neighbors[i].Free;
  Visited.Free;
  R.Free;
  C.Free;
end;

var
  T: Integer;
  
begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;
    WriteLn(Solve);
    ReleaseMemory;
    Dec(T);
  end;
  
end.
