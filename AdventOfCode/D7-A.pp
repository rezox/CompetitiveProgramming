{$mode objfpc}
program D7A;
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

var
  AllNodes: TStringList;
  S: AnsiString;
  NewNode : TNode;
  i: Integer;
   
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
      WriteLn((AllNodes.Objects[i] as TNode).FName);
end.
