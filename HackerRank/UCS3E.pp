{$mode objfpc}
program E;
uses
  fgl;
type
  TIntList = specialize TFPGList<Integer>;

var
  N: Integer;
  Black: TIntList;
  Neighbors: array [0..100000] of TIntList;

procedure ReadData;
var
  i: Integer;
  x, y: Integer;

begin
  ReadLn(N);
  Black := TIntList.Create;
  Black.Add(-1);

  for i := 1 to N do
  begin
    Read(x);
    x := 2 * x - 1;
    Black.Add(x);

    Neighbors[i] := TIntList.Create;
  end;
  ReadLn;

  for i := 1 to N - 1 do
  begin
    ReadLn(x, y);
    Neighbors[x].Add(y);
    Neighbors[y].Add(x);
  end;

end;

procedure Solve(const r: Integer; var PValue, NValue: Integer);
var
  Marked: TIntList;
  B_W, W_B: TIntList;

  function DFS(const v: Integer): Boolean;
  var
    i: Integer;

  begin
    if Marked[v] = 1 then
      Exit(False);
    Result := True;

    Marked[v] := 1;
    B_W[v] := Black[v];
    W_B[v] := -Black[v];
    //WriteLn('v:', v, ' pos:',  B_W[v], ' neg:', W_B[v]);

    for i := 0 to Neighbors[v].Count - 1 do
      if DFS(Neighbors[v][i]) then
      begin
        B_W[v] := B_W[v] + B_W[Neighbors[v][i]];
        W_B[v] := W_B[v] + W_B[Neighbors[v][i]];
      end;

    //WriteLn('v:', v, ' pos:',  B_W[v], ' neg:', W_B[v]);
    if B_W[v] < 0 then
      B_W[v] := 0;
    if W_B[v] < 0 then
      W_B[v] := 0;

    //WriteLn('v:', v, ' pos:',  B_W[v], ' neg:', W_B[v]);
  end;

var
  i: Integer;

begin
  Marked := TIntList.Create;
  B_W := TIntList.Create;
  W_B := TIntList.Create;
  Marked.Count := N + 1;
  B_W.Count := N + 1;
  W_B.Count := N + 1;

  DFS(r);
  
  //WriteLn('r:', r, ' pos:',  B_W[r], ' neg:', W_B[r]);
  PValue := B_W[r];
  NValue := W_B[r];

  Marked.Free;
  B_W.Free;
  W_B.Free;
end;

procedure PrintB_W(r: Integer);
var
  Nodes: TIntList;
  Marked: TIntList;
  B_W: TIntList;

  function DFS(const v: Integer): Boolean;
  var
    i: Integer;

  begin
    if Marked[v] = 1 then
      Exit(False);
    Result := True;

    Marked[v] := 1;
    B_W[v] := Black[v];

    for i := 0 to Neighbors[v].Count - 1 do
      if DFS(Neighbors[v][i]) then
      begin
        B_W[v] := B_W[v] + B_W[Neighbors[v][i]];
      end;

    //WriteLn('v:', v, ' neg:', B_W[v]);
    if B_W[v] < 0 then
      B_W[v] := 0;

    //WriteLn('v:', v, ' neg:', B_W[v]);
  end;

var
  top, i, v: Integer;

begin
  B_W := TIntList.Create;
  Nodes := TIntList.Create;
  Marked := TIntList.Create;

  Marked.Count := N + 1;
  B_W.Count := N + 1;

  DFS(r);
  Marked.Free;
  
  WriteLn(B_W[r]);
  Marked := TIntList.Create;
  Marked.Count := N + 1;
  
  Nodes.Add(r);
  Marked[r] := 1;
  top := 0;

  while top < Nodes.Count do
  begin
    r := Nodes[top];

    for i := 0 to Neighbors[r].Count - 1 do
    begin
      v := Neighbors[r][i];
      if (Marked[v] = 0) and (0 < B_W[v]) then
      begin
        Nodes.Add(v);
        Marked[v] := 1;
      end; 
    end; 
    
    Inc(top);
  end;

  Marked.Free;
  B_W.Free;

  WriteLn(Nodes.Count);
  Write(Nodes[0]);
  for i := 1 to Nodes.Count - 1 do
    Write(' ', Nodes[i]);
  WriteLn;
  Nodes.Free;
end;

procedure PrintW_B(r: Integer);
var
  Nodes: TIntList;
  Marked: TIntList;
  W_B: TIntList;

  function DFS(const v: Integer): Boolean;
  var
    i: Integer;

  begin
    if Marked[v] = 1 then
      Exit(False);
    Result := True;

    Marked[v] := 1;
    W_B[v] := -Black[v];

    for i := 0 to Neighbors[v].Count - 1 do
      if DFS(Neighbors[v][i]) then
      begin
        W_B[v] := W_B[v] + W_B[Neighbors[v][i]];
      end;

    //WriteLn('v:', v, ' neg:', W_B[v]);
    if W_B[v] < 0 then
      W_B[v] := 0;

    //WriteLn('v:', v, ' neg:', W_B[v]);
  end;

var
  top, i, v: Integer;

begin
  W_B := TIntList.Create;
  Nodes := TIntList.Create;
  Marked := TIntList.Create;

  Marked.Count := N + 1;
  W_B.Count := N + 1;

  DFS(r);
  Marked.Free;
  
  WriteLn(W_B[r]);
  Marked := TIntList.Create;
  Marked.Count := N + 1;
  
  Nodes.Add(r);
  Marked[r] := 1;
  top := 0;

  while top < Nodes.Count do
  begin
    r := Nodes[top];

    for i := 0 to Neighbors[r].Count - 1 do
    begin
      v := Neighbors[r][i];
      if (Marked[v] = 0) and (0 < W_B[v]) then
      begin
        Nodes.Add(v);
        Marked[v] := 1;
      end; 
    end; 
    
    Inc(top);
  end;

  Marked.Free;
  W_B.Free;

  WriteLn(Nodes.Count);
  Write(Nodes[0]);
  for i := 1 to Nodes.Count - 1 do
    Write(' ', Nodes[i]);
  WriteLn;
  Nodes.Free;
end;

var
  r: Integer;
  PV, NV, Max, Min: Integer;
  MaxIndex, MinIndex: Integer;

begin
  ReadData;

  Max := -1; Min := -1;
  for r := 1 to N do 
  begin
    Solve(r, PV, NV);
    if Max < PV then
    begin
      MaxIndex := r;
      Max := PV;
    end; 
    if Min < NV then
    begin
      MinIndex := r;
      Min := NV;
    end;
  end;

  //WriteLn('Max:', Max, ' ', MaxIndex);
  //WriteLn('Min:', Min, ' ', MinIndex);

  if Min < Max then
    PrintB_W(MaxIndex)
  else
    PrintW_B(MinIndex);

end.
