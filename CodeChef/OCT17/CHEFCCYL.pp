{$mode objfpc}
program CHECCCYL;
uses
  fgl;
type
  TIntList = specialize TFPGList<Integer>;

var
  N, Q: Integer;
  ai: array [0..100000] of TIntList;
  v1, v2, w: TIntList;

procedure ReadGraph;
var
  i, j: Integer;
  x, y, z: Integer;

begin
  for i := 1 to N do
  begin
    ai[i] := TIntList.Create;

    Read(x);
    for j := 1 to x do
    begin
      Read(y);
      ai[i].Add(y);
    end;
  end;

  v1 := TIntList.Create; v2 := TIntList.Create; w := TIntList.Create;
  for i := 1 to N do
  begin
    ReadLn(x, y, z);
    v1.Add(x); v2.Add(y); w.Add(z);
  end;
end;
 
var
  NodeCycles: array[0..100000] of TIntList;

procedure PreProcess;
var
  i, j: Integer;
begin
  for i := 1 to N do
  begin
    for j := 1 to ai.Count do
    begin
      if NodeCycles[j] = nil then
        NodeCycles[j] := TIntList.Create;
      NodeCycles[j].Add(i);
    end;
  end;
end;

function Solve(v1, c1, v2, c2: Integer): Integer;
begin
//v1 -> v2
end;

var
  i: Integer;
  T: Integer;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadLn(N, Q);
    ReadGraph;
    PreProcess;
    
    for i := 1 to Q do
    begin
      ReadLn(v1, c1, v2, c2);
      WriteLn(Solve(v1, c1, v2, c2));
    end;
    Dec(T);

    for i := 1 to N do
      ai[i].Free;
    v1.Free; v2.Free; w.Free;
  end;

end.
