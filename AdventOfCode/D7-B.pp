{$mode objfpc}
program D7B;
uses
  Classes, fgl, SysUtils;
type
  TNode = class;

  TNodeList= specialize TFPGList<TNode>;
  TNode = class(TObject)
  private
    FName: AnsiString;
    FWeight: Integer;
    FParent: TNode;
    FChildren: TNodeList;
    FChildrenNames: TStringList;

  public
    constructor Create;
    constructor Parse(Line: AnsiString);

     procedure Compile(const AllNodes: TStringList);
  end;

constructor TNode.Create;
begin
  inherited Create;

  FChildren := TNodeList.Create;
  FParent := nil;
end;

constructor TNode.Parse(Line: AnsiString);
var
  i: Integer;
begin
  inherited Create;

  FName := Copy(Line, 1, Pos(' ', Line) - 1);
  Delete(Line, 1, Pos(' ', Line));
  if Line[1] <> '(' then
    raise Exception.Create('Expect "(" BUT visited ' + Line);
  Delete(Line, 1, 1);
  FWeight := StrToInt(Copy(Line, 1, Pos(')', Line) - 1));
  Delete(Line, 1, Pos(')', Line));

  
  FChildrenNames := TStringList.Create;
  if Line = '' then
    Exit;
  if Copy(Line, 1, 4) <> ' -> ' then
    raise Exception.Create('Expect " -> " BUT visited ' + Line);

  Delete(Line, 1, 4);
  FChildrenNames.Sorted := True;
  FChildrenNames.Delimiter := ',';
  FChildrenNames.DelimitedText := Line;

{  WriteLN(FName);
  WriteLN(FWeight);
  WriteLn(Line);
  for i := 0 to FChildrenNames.Count - 1 do
    WriteLn(FChildrenNames[i]);
  WriteLn('--');
}
end;

procedure TNode.Compile(const AllNodes: TStringList);
var
  i: Integer;
  ChildNode: TNode;
begin
  FChildren := TNodeList.Create;
  
  for i := 0 to FChildrenNames.Count - 1 do
  begin
    if AllNodes.IndexOf(FChildrenNames[i]) < 0 then 
      raise Exception.Create(FChildrenNames[i] + ' not found!');
    ChildNode := AllNodes.Objects[AllNodes.IndexOf(FChildrenNames[i])] as TNode;
    ChildNode.FParent := Self;
    FChildren.Add(ChildNode);
  end;

end;

function RecSolve(Root: TNode; var FirstBadNode: TNode): Integer;
var
  i: Integer;
  ChildSum, tmp: Integer;
begin
  if Root.FChildren.Count = 0 then
    Exit(Root.FWeight);

  Result := Root.FWeight;
  ChildSum := -1;
  
  for i := 0 to Root.FChildren.Count - 1 do
  begin
    tmp := RecSolve(Root.FChildren[i], FirstBadNode);
    if ChildSum = -1 then
      ChildSum := tmp;

    if tmp <> ChildSum then
    begin
      if FirstBadNode = nil then
        FirstBadNode := Root;
      Exit;
      WriteLn(Root.FName, ':', Root.FChildren[0].FName, ' ', Root.FChildren[i].FName);
      WriteLn(ChildSum, ' ', tmp);
    end;

    Inc(Result, tmp);
  end;
end;

var
  AllNodes: TStringList;
  S: AnsiString;
  NewNode, BadNode : TNode;
  Root: TNode;
  i: Integer;
  tmp: Integer;
  S1Count, S2Count: Integer;
  Sum1, Sum2: Integer;
  NodeS1, NodeS2, tmpNode: TNode;
   
begin
  AllNodes := TStringList.Create;

  while not Eof do
  begin
    ReadLn(S);
    NewNode := TNode.Parse(S);
    AllNodes.AddObject(NewNode.FName, NewNode);
  end;
  AllNodes.Sort;

  for i := 0 to AllNodes.Count - 1 do
    (AllNodes.Objects[i] as TNode).Compile(AllNodes);

  for i := 0 to AllNodes.Count - 1 do
    if (AllNodes.Objects[i] as TNode).FParent = nil then
    begin
      Root := AllNodes.Objects[i] as TNode;
      break;
    end;
 
  BadNode := nil; 
  RecSolve(Root, BadNode);
  WriteLn(BadNode.FName);

  Sum1 := -1; Sum2 := -1;
  S1Count := 0; S2Count := 0;
  for i := 0 to BadNode.FChildren.Count - 1 do
  begin
    tmp := RecSolve(BadNode.FChildren[i], tmpNode);

    if Sum1 = -1 then
    begin
      NodeS1 := BadNode.FChildren[i];
      Sum1 := tmp;
      S1Count := 1;
    end
    else if Sum1 = tmp then
       Inc(S1Count)
    else if Sum2 = -1 then
    begin
      NodeS2 := BadNode.FChildren[i];
      Sum2 := tmp;
      S2Count := 1;
    end
    else if Sum2 = tmp then
       Inc(S2Count)
    else
      WriteLn('ERROR');
  end;
  WriteLn(Sum1, ' ', NodeS1.FName, ' ', S1Count);
  WriteLn(Sum2, ' ', NodeS2.FName, ' ', S2Count);

  if S2Count < S1Count then
  begin
    tmpNode := NodeS1;
    NodeS1 := NodeS2;
    NodeS2 := tmpNode;
    S1Count := S1Count xor S2Count;
    S2Count := S1Count xor S2Count;
    S1Count := S1Count xor S2Count;
    Sum1 := Sum1 xor Sum2;
    Sum2 := Sum1 xor Sum2;
    Sum1 := Sum1 xor Sum2;
  end;
  if S1Count <> 1 then 
    raise Exception.Create('Invalid S1Count');
  // Sum1 - NodeS1.FWeight + NodeS1.NewWeight = Sum2
  WriteLn(NodeS1.FName, ' ', NodeS1.FWeight, ' -> ', Sum2 - Sum1 + NodeS1.FWeight);

end.
