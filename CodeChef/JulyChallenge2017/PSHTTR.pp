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
  Ui, Vi, Ci: array [0..100000] of Integer;
  Neighbors: array[0..100000] of TPairList;

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
  N := 100000;

  for i := 1 to N do
    Neighbors[i] := TPairList.Create;
  for i := 1 to N - 1 do
  begin
    ReadLn(Ui[i], Vi[i], Ci[i]);
    Ui[i] := i; Vi[i] := (i + 1); Ci[i] := i;
    Pair := TPair.Create(Vi[i], Ci[i]);
    Neighbors[Ui[i]].Add(Pair);
    Pair := TPair.Create(Ui[i], Ci[i]);
    Neighbors[Vi[i]].Add(Pair);
  end;
end;

type
  TIntIntMap = specialize TFPGMap<Integer, Integer>;

var
  Values: array [0..100000] of TIntIntMap;

function GetOrDefault(const InputMap: TIntIntMap; const Key: Integer; const Default: Integer): Integer;
begin
  Result := Default;
  if InputMap.IndexOf(Key) <> -1 then
    Result := InputMap[Key];
end;

procedure PrintMap(const InputMap: TIntIntMap);
var
  i, key: Integer;

begin
  for i := 0 to InputMap.Count - 1 do
  begin
    key := InputMap.Keys[i];
    Write('(', key, ':', InputMap[key], ')');
  end;
    
  WriteLn;
end;

function CopyMap(const InputMap: TIntIntMap): TIntIntMap;
var
  i, key: Integer;

begin
  Result := TIntIntMap.Create;
  Result.Sorted := True;
  for i := 0 to InputMap.Count - 1 do
  begin
    key := InputMap.Keys[i];
    Result[key] := InputMap[key];
  end;
end;

procedure AddOrSetData(Map: TIntIntMap; const Key, Value: Integer);
begin
  if Map.IndexOf(Key) = -1 then
    Map.Add(Key, Value)
  else
    Map[Key] := Value;
end;

procedure PreprocessData;
  function SelectRoot: Integer;
  var
    Q, Distance: TIntList;
    ToQ: Integer;
    Current: Integer;
    i: Integer;
    MaxDistance: Integer;

  begin
    Distance := TIntList.Create;
    Q := TIntList.Create;
    Distance.Count := N + 1;
    Q.Add(1);
    Distance[1] := 1;
    ToQ := 0;
    MaxDistance := 1;
    while ToQ < Q.Count do
    begin
      Current := Q[ToQ];
      Inc(ToQ);
      for i := 0 to Neighbors[Current].Count - 1 do
      begin
        if Distance[Neighbors[Current][i].Node] <> 0 then
          Continue;
        Q.Add(Neighbors[Current][i].Node);
        Distance[Neighbors[Current][i].Node] :=  Distance[Current] + 1;
      end;
    end;
    MaxDistance := (1 + Distance[Current]) div 2;
    Result := -1;
    for i := 1 to N do
      if Distance[i] = MaxDistance then
      begin
        Result := i;
        break;
      end;
     Distance.Free; Q.Free;
  end;

  procedure ComputeDistance(Parent, Child: Integer; Cost: Integer);
  var
    i: Integer;
    Pair: TPair;

  begin
    Values[Child] := CopyMap(Values[Parent]);
    AddOrSetData(Values[Child], Cost, GetOrDefault(Values[Parent], Cost, 0) + 1);
   
    for i := 0 to Neighbors[Child].Count - 1 do
    begin
      Pair := Neighbors[Child][i];

      if Values[Pair.Node] <> nil then
        Continue;
      ComputeDistance(Child, Pair.Node, Pair.Cost);
    end;
  end;

var
  i, j: Integer;
  r: Integer;
  CurrentState: TIntIntMap;

begin
  r := SelectRoot;
  FillChar(Values, SizeOf(Values), 0);

  CurrentState := TIntIntMap.Create;
  CurrentState.Sorted := True;
  Values[r] := CurrentState;

  for i := 0 to Neighbors[r].Count - 1 do
    ComputeDistance(r, Neighbors[r][i].Node, Neighbors[r][i].Cost);
end;

function Solve(U, V, K: Integer): Integer;
var
  UMap, VMap: TIntIntMap;
  UVMap: TIntIntMap;
  i, j: Integer;
  Key, Value: Integer;

begin
  UMap := Values[U];
  VMap := Values[V];
  UVMap := TIntIntMap.Create;

  for i := 0 to UMap.Count - 1 do
  begin
    Key := UMap.Keys[i];
    Value := UMap[Key];
    if Key <= K then
      AddOrSetData(UVMap, Key, Value);
  end;

  for i := 0 to VMap.Count - 1 do
  begin
    Key := VMap.Keys[i];
    Value := VMap[Key];

    if Key <= K then
      AddOrSetData(UVMap, Key, GetOrDefault(UVMap, Key, 0) + Value);
  end;
  //WriteLn('U:', u);
  //PrintMap(UMap);
  //WriteLn('V:', V);
  //PrintMap(VMap);
  //WriteLn('UVMap');
  //PrintMap(UVMap);

  Result := 0;
  for i := 0 to UVMap.Count - 1 do
  begin
    Key := UVMap.Keys[i];
    Value := UVMap[Key];
    if Odd(Value) then
      Result := Result xor Key;
    //WriteLn('Key:', Key, ' Value:', Value, ' Result:', Result);
  end;
  UVMap.Free;
end;

procedure ReleaseMemory;
var
  i, j: Integer;
begin
  for i := 1 to N  do
  begin
    for j := 0 to Neighbors[i].Count - 1 do
      Neighbors[i][j].Free;
    Neighbors[i].Free;
  end;
  for i := 1 to N do
    Values[i].Free;
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
    PreprocessData;


    ReadLn(M);
    for i := 1 to M do
    begin
      ReadLn(U, V, K);
      WriteLn(Solve(U, V, K));

    end;
    ReleaseMemory;
    Dec(T);
  end;
end.

