{$mode objfpc}
program PSHTTR;
uses
  fgl;

type 
  TPair = Class(TObject)
    Node: Integer;
    Cost: Integer;

    constructor Create(n, c: Integer);
  end;
  TIntList = specialize TFPGList<Integer>;
  TPairList = specialize TFPGList<TPair>;

var
  N: Integer;
  Ui, Vi, Ci: array [0..10000] of Integer;
  Neighbors: array[0..10000] of TPairList;

constructor TPair.Create(n, c: Integer);
begin
  inherited Create;

  Node := n;
  Cost := c;
end;

procedure ReadData;
var
  i: Integer;
  Pair: TPair;
begin
  ReadLn(N);

  for i := 1 to N - 1 do
    Neighbors[i] := TPairList.Create;
  for i := 1 to N - 1 do
  begin
    ReadLn(Ui[i], Vi[i], Ci[i]);
    Pair := TPair.Create(Vi[i], Ci[i]);
    Neighbors[Ui[i]].Add(Pair);
    Pair := TPair.Create(Ui[i], Ci[i]);
    Neighbors[Vi[i]].Add(Pair);
  end;
end;

function Solve(U, V, K: Integer): Integer;

  function MaybeAdd(c, k: Integer): Integer;
  begin
    if c <= k then
      Exit(c);
    Exit(0);
  end;
var
  FQ, BQ, Costs: TIntList;
  tf, tb: Integer;
  FNode, BNode: Integer;
  FN, BN: TPairList;
  Current: Integer;
  i: Integer;

begin
  FQ := TIntList.Create; BQ := TIntList.Create; Costs := TIntList.Create;
  FQ.Add(U); BQ.Add(V); Costs.Count := N + 1;
  for i := 0 to N do
    Costs[i] := -1;
  tf := 0; tb := 0;

  while True do
  begin
    FNode := FQ[tf]; Inc(tf);
    BNode := BQ[tb]; Inc(tb); 
    FN := Neighbors[FNode]; BN := Neighbors[BNode];

    for i := 0 to FN.Count - 1 do
    begin
      if Costs[FN[i].Node] <> -1 then
        Exit(Costs[FN[i].Node] xor MaybeAdd(FN[i].Cost, K));
      Current := FN[i].Node;
      Costs[Current] := Costs[FNode] ;
    end;
  end;

  
end;

procedure ReleaseMemory;
var
  i, j: Integer;
begin
  for i := 1 to N - 1 do
  begin
    for j := 0 to Neighbors[i].Count - 1 do
      Neighbors[i][j].Free;
    Neighbors[i].Free;
  end;
end;

var
  T: Integer;
  M: Integer;
  U, V, K: Integer;
  i: Integer;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;

    ReadLn(M);
    for i := 1 to M do
    begin
      ReadLn(U, V, K);
      WriteLn(Solve(U, V, K));

    end;
    ReleaseMemeory;
    Dec(T);
  end;
end.

