{$mode objfpc}
program WEASELTX;
uses
  fgl;
type
  TNode = class;
  TNodes = specialize TFPGList<TNode>;

  TNode = class(TObject)
  private
    FID: Integer;
    CurrentXor, LastXor: Int64;
    CurrentValue, LastValue: Int64;
    FNodes: TNodes;

    procedure AddChild(Node: TNode);
  public
    constructor Create(ID: Integer; Val: uInt64);
    destructor Destroy; override;

    procedure Print(const Indent: AnsiString);
    function Update: Boolean;
  end;

constructor TNode.Create(ID: Integer; Val: uInt64);
begin
  inherited Create;

  FID := ID;
  FNodes := TNodes.Create;
  LastXor := 0;
  CurrentXor := 0;
  CurrentValue := Val;
  LastValue := 0;
end;

destructor TNode.Destroy;
var
  i: Integer;

begin
  for i := 0 to FNodes.Count - 1 do
    FNodes[i].Free;
end;

procedure TNode.AddChild(Node: TNode);
begin
  FNodes.Add(Node);
end;

procedure TNode.Print(const Indent: AnsiString);
var
  i: Integer;
begin
  WriteLn(Indent, FID, ' xor:', CurrentXor, ' val:', CurrentValue);
  for i := 0 to FNodes.Count - 1 do
    FNodes[i].Print(Indent + '..');
end;

function TNode.Update: Boolean;
begin
end;

type
  TIntList = specialize TFPGList<Int64>;

var
  N, Q: Integer;
  Ui, Vi: array [0..200000] of Integer;
  Neighbors: array [0..200000] of TIntList;
  InitValues: array [0..200000] of Int64;
  Marked: array[0..200000] of TNode;

function BuildTree(ID: Integer; Value: Int64): TNode;
var
  i: Integer;
  m: Integer;

begin
  if Marked[ID] <> nil then
    Exit(Marked[ID]);

  Result := TNode.Create(ID, Value);
  Marked[ID] := Result;
  for i := 0 to Neighbors[ID].Count - 1 do
  begin
    m := Neighbors[ID][i];
    if Marked[m] <> nil then Continue;
    Result.AddChild(BuildTree(m, InitValues[m]));
  end;

end;

function Solve(D: uInt64): uInt64;
begin
  Result := 0;
end;

function Compare(const a, b: Int64): Integer;
begin
  if a < b then
    Exit(-1)
  else if a = b then
    Exit(0)
  else
    Exit(+1);
end;

type
  TIntIntMap = specialize TFPGMap<Int64, TIntList>;

var
  Queries: TIntIntMap;
  D: uInt64;
  i, j: Integer;
  Root: TNode;

begin
  ReadLn(N, Q);
  for i := 0 to N - 1 do
    Neighbors[i] := TIntList.Create;

  for i := 1 to N - 1 do
  begin
    ReadLn(Ui[i], Vi[i]);

    Neighbors[Ui[i]].Add(Vi[i]);
    Neighbors[Vi[i]].Add(Ui[i]);
  end;
  for i := 0 to N - 1 do
    Read(InitValues[i]);
  ReadLn;
  FillChar(Marked, SizeOf(Marked), 0);

  Root := BuildTree(0, InitValues[0]);
  Root.Print('');

  Queries := TIntIntMap.Create;
  Queries.Sorted := True;
  for i := 1 to Q do
  begin
    ReadLn(D);
    if Queries.IndexOf(D) = -1 then
      Queries.Add(D, TIntList.Create);
    Queries[D].Add(i);
  end;

  j := 0;
  for i := 0 to Queries.Count - 1 do
  begin
    D := Queries.Keys[i];
    while j < D do
    begin
      Inc(j);
      WriteLn(j);
    end;
    WriteLn(D);

  end;
end.
