{$mode objfpc}
program WC34D;
uses
  fgl, SysUtils;
const
  Modulo = 1000000007;

type
  TIntList = specialize TFPGList<Integer>;
  TInt64List = specialize TFPGList<Int64>;
  
var
  n: Integer;
  Ci: TIntList;
  FibArray: TInt64List;
  FN, FPN: TIntList;
  Sum: TInt64List;
  Neighbors: array [0..200000] of TIntList;

function Fib(n: Integer): Int64;
begin
  if n < 0 then
    Exit(0);
  Result := FibArray[n];
end;

procedure ReadData;
var
  x, y: Integer;
  i: Integer;
begin
  ReadLn(n);

  Ci := TIntList.Create; FN := TIntList.Create; FPN := TIntList.Create;
  Ci.Count := N + 1; FN.Count := N + 1; FPN.Count := N + 1;

  for i := 1 to N do
    Neighbors[i] := TIntList.Create;

  for i := 1 to N - 1 do
  begin
    ReadLn(x, y);
    Neighbors[x].Add(y);
    Neighbors[y].Add(x);
  end;
  for i := 1 to N do
  begin
    Read(x);
    Ci[i] := x;
  end;
end;

type
  TBoolList = specialize TFPGList<Boolean>;
  TIntIntMap = specialize TFPGMap<Integer, Int64>;

function CreateList(n: Integer): TInt64List;
begin
  Result := TInt64List.Create;
  Result.Count := n;
end;

function CreateMap: TIntIntMap;
begin
  Result := TIntIntMap.Create;
  Result.Sorted := True;
end;


procedure PrintList(const Spaces: AnsiString; A: TInt64List);
var
  i: Integer;
begin
  for i := 1 to N do
    if A[i] <> 0 then
      WriteLn(Spaces, i, ':', A[i]);
end;

procedure PrintMap(const Spaces: AnsiString; A: TIntIntMap);
var
  i: Integer;
begin
  for i := 0 to A.Count - 1 do
    WriteLn(Spaces, A.Keys[i], ']', A[A.Keys[i]]);
end;

type
  TIntIntMapList = specialize TFPGList<TIntIntMap>;

function Solve: Int64;
var
  Marked: TBoolList;
  Tns, Fns: TIntIntMapList;

  procedure Compute(Tn, Fn, TCn, FCn: TIntIntMap; u: Int64);
  var
    i: Integer;
    Key: Integer;

  begin

    for i := 0 to TCn.Count - 1 do
    begin
      Key := TCn.Keys[i];
     // Fib[Ci[i] + Ci[u]] =?
     //   Fib[Ci[i] - 1] * Fib[Ci[u]] + Fib[Ci[i]] * Fib[Ci[u] + 1]
WriteLn(key, ' FCN: ', FCN[Key], ' Fib(Ci[u]):', Fib(Ci[u]), ' TCn[key]:', TCn[key], ' Fib[Ci[u] + 1]:', Fib(Ci[u] + 1));
      Tn[Key] := FCn[key] * Fib(Ci[u] - 1) + TCn[key] * Fib(Ci[u]);
// Fib(S + ci[u] - 1] = Fib(S - 1) * Fib(Ci[u] - 1) + Fib(S) * Fib(Ci[u]).
      Fn[Key] := FCn[key] * Fib(Ci[u] - 2) + TCn[key] * Fib(Ci[u] - 1);
    end;

  end;

  function DFS1(u: Integer; Tn, Fn: TIntIntMap; Spaces: AnsiString): Int64;
  var
    i: Integer;
    TCn, FCn: TIntIntMap;
  begin
    WriteLn(Spaces, 'u:', u);
    Marked[u] := True;
    Result := 0;

    for i := 0 to Neighbors[u].Count - 1 do
      if not Marked[Neighbors[u][i]] then
      begin
    WriteLn(Spaces, 'Nu:', Neighbors[u][i]);
        //TCn := CreateList(N + 1); FCn := CreateList(N + 1);
        TCn := CreateMap; FCn := CreateMap;
        Result := (Result + DFS1(Neighbors[u][i], TCn, FCn, Spaces + '  ')) mod Modulo;
        Compute(Tn, Fn, TCn, FCn, u);

    WriteLn(Spaces, 'u:', u, '<->', Result);
    PrintMap(Spaces + 'T-' + IntToStr(u) + ',', Tn);
    PrintMap(Spaces + 'F-' + IntToStr(u) + ',', Fn);
      end;

    Tn[u] := Fib(Ci[u]);
    Fn[u] := Fib(Ci[u] - 1);
    Result := 0;
    for i := 0 to Tn.Count - 1 do
      if Tn.Keys[i] <> u then
      begin
        Result := (Result + Tn[Tn.Keys[i]]) mod Modulo;
      end;
    WriteLn(Spaces, 'u:', u, '<-> Result:', Result);
    PrintMap(Spaces + 'T-' + IntToStr(u) + ',', Tn);
    PrintMap(Spaces + 'F-' + IntToStr(u) + ',', Fn);
    Tns[u] := Tn;
    Fns[u] := Fn;
  end;

  function DFS2(r: Integer): Integer;
  var
    i, j: Integer;
    Li, Lj: TIntIntMap;
  begin
     Marked[u] := True;
    Result := 0;

    for i := 0 to Neighbors[r].Count - 1 do
    begin
      if Marked[Neighbors[i]] then
        Continue;
      for j := i + 1 to Neighbors[r].Count - 1 do
      begin
        if Marked[Neighbors[j]] then
          Continue;
      end;
    end;

  end;

var
  i: Integer;
  Tn, Fn: TIntIntMap;

begin
  FibArray := CreateList(100001);
  Sum := CreateList(200001);
  Marked := TBoolList.Create; Marked.Count := 200001;

  FibArray[0] := 1; FibArray[1] := 1;
  for i := 2 to 100000 do
    FibArray[i] := (FibArray[i - 1] + FibArray[i - 2]) mod Modulo;

  Tns := TIntIntMapList.Create; Fns := TIntIntMapList.Create;
  Tns.Count := N + 1; Fns.Count := N + 1;
  Tn := CreateMap;
  Fn := CreateMap;
  Result := DFS1(1, Tn, Fn, '') * 2;
  for i := 1 to N do
    Result := (Result + Fib(Ci[i])) mod Modulo; //T[i,i]
  Marked.Free; Marked := TBoolList.Create; Marked.Count := 200001;
  Result := (Result + DFS2(1)) mod Modulo;
end;

begin
  ReadData;
  WriteLn(Solve);
end.
