{$mode objfpc}
program GSCD;
uses
  fgl, Math, SysUtils; // SegmentTreeUnit;

type
  TIntList = specialize TFPGList<Integer>;

  TNode = class(TObject)
  protected
    FLeftMostIndex, FRightMostIndex: Integer;
    FLeftNode, FRightNode: TNode;
    function GetValue: Int64; virtual; abstract;

  public
    property LeftNode: TNode read FLeftNode;
    property RightNode: TNode read FRightNode;

    constructor Create;
    destructor Destroy; override;

    function GetLeftMostIndex: Integer;
    function GetRightMostIndex: Integer;

    function GetMax(const l, r: Integer): Int64;
    function GetNode(const l, r: Integer): TNode;

    procedure Print(const Indent: AnsiString); virtual; abstract;
  end;

  TLeafNode = class(TNode)
  private
    FValue: Int64;
    FIndex: Integer;
  protected
    function GetValue: Int64; override;

  public
    property Index: Integer read FIndex;

    constructor Create(const Ind: Integer; const Val: Int64);
    destructor Destroy; override;
    
    procedure Print(const Indent: AnsiString); override;

  end;

  TNonLeafNode = class(TNode)
  private
    FValue: Int64;

  protected
    function GetValue: Int64; override;

  public

    constructor Create(const Left, Right: TNode);
    destructor Destroy; override;

    procedure Print(const Indent: AnsiString); override;
  end;


var
  n, q: Integer;
  Ti, Pi: TIntList;

procedure ReadData;
var
  i: Integer;
  t, p: Int64;
begin
  Ti := TIntList.Create; Pi := TIntList.Create;
  Ti.Add(0); Pi.Add(0);
  
  ReadLn(n, q);
  for i := 1 to n do
  begin
    Read(t);
    Ti.Add(t);
  end;

  for i := 1 to n do
  begin
    Read(p);
    Pi.Add(p);
  end;
  ReadLn;

end;

constructor TNode.Create;
begin
  inherited;

  FLeftNode := nil;
  FRightNode := nil;

end;

destructor TNode.Destroy;
begin
  FLeftNode.Free;
  FRightNode.Free;

  inherited;

end;

function TNode.GetLeftMostIndex: Integer; 
begin
  Result := FLeftMostIndex;
end;

function TNode.GetRightMostIndex: Integer; 
begin
  Result := FRightMostIndex;
end;

function TNode.GetMax(const l, r: Integer): Int64;
begin
  Assert((GetLeftMostIndex <= l) and (r <= GetRightMostIndex), 'l:' + IntToStr(l) + ' r: ' + IntToStr(r) + ' Left:' + IntToStr(GetLeftMostIndex) + ' right:' + IntToStr(GetRightMostIndex));

  //WriteLn('1) l:', l, ' r:', r, ' L:', GetLeftMostIndex, ' R:', GetRightMostIndex);
  if (l = GetLeftMostIndex) and (r = GetRightMostIndex) then
    Exit(GetValue);

  //WriteLn('2) l:', l, ' r:', r, ' L:', GetLeftMostIndex, ' R:', GetRightMostIndex);
  if r <= FLeftNode.GetRightMostIndex then
    Exit(LeftNode.GetMax(l, r));
  //WriteLn('3) l:', l, ' r:', r, ' L:', GetLeftMostIndex, ' R:', GetRightMostIndex);
  if RightNode.GetLeftMostIndex <= l then
    Exit(RightNode.GetMax(l, r));
  //WriteLn('4) l:', l, ' r:', r, ' L:', GetLeftMostIndex, ' R:', GetRightMostIndex);
  Result := Max(LeftNode.GetMax(l, LeftNode.GetRightMostIndex), 
                RightNode.GetMax(RightNode.GetLeftMostIndex, r));
end;

function TNode.GetNode(const l, r: Integer): TNode;
begin
  Assert((GetLeftMostIndex <= l) and (r <= GetRightMostIndex), 'l:' + IntToStr(l) + ' r: ' + IntToStr(r) + ' Left:' + IntToStr(GetLeftMostIndex) + ' right:' + IntToStr(GetRightMostIndex));

  //WriteLn('1) l:', l, ' r:', r, ' L:', GetLeftMostIndex, ' R:', GetRightMostIndex);
  if (l = GetLeftMostIndex) and (r = GetRightMostIndex) then
    Exit(Self);

  //WriteLn('2) l:', l, ' r:', r, ' L:', GetLeftMostIndex, ' R:', GetRightMostIndex);
  if r <= FLeftNode.GetRightMostIndex then
    Exit(LeftNode.GetNode(l, r));
  //WriteLn('3) l:', l, ' r:', r, ' L:', GetLeftMostIndex, ' R:', GetRightMostIndex);
  if RightNode.GetLeftMostIndex <= l then
    Exit(RightNode.GetNode(l, r));
  //WriteLn('4) l:', l, ' r:', r, ' L:', GetLeftMostIndex, ' R:', GetRightMostIndex);
  Result := nil;
end;


constructor TLeafNode.Create(const Ind: Integer; const Val: Int64);
begin
  inherited Create;

  FIndex := Ind;
  FValue := Val;
  FLeftMostIndex := Ind;
  FRightMostIndex := Ind;
end;

destructor TLeafNode.Destroy;
begin
  inherited;

end;

function TLeafNode.GetValue: Int64; 
begin
  Result := FValue;
end;

procedure TLeafNode.Print(const Indent: AnsiString);
begin
  WriteLn(Indent, '(Index:', GetLeftMostIndex, ' Value: ', GetValue, ')');
end;

procedure TNonLeafNode.Print(const Indent: AnsiString);
begin
  WriteLn(Indent+ '(');
  if LeftNode <> nil then
    LeftNode.Print(Indent + '..');
  if RightNode <> nil then
    RightNode.Print(Indent + '..');
  WriteLn(Indent+ ')');
end;


constructor TNonLeafNode.Create(const Left, Right: TNode);
begin
  inherited Create;

  FLeftNode := Left;
  FRightNode := Right;
  FLeftMostIndex := Left.GetLeftMostIndex;
  FRightMostIndex := Right.GetRightMostIndex;
  FValue := -1;

end;

destructor TNonLeafNode.Destroy;
begin
  LeftNode.Free;
  RightNode.Free;

  inherited;
end;

function TNonLeafNode.GetValue: Int64;
begin
  if FValue <> -1 then
    Exit(FValue);

  FValue := Max(LeftNode.GetValue, RightNode.GetValue);
  Result := FValue;
end;

function BuildSegmentTree(const Values: TIntList): TNode;

  function RecBuild(Left, Right: Integer): TNode;
  var
    Mid: Integer;
    LNode, RNode: TNode;
  begin
    if Left = Right then
      Exit(TLeafNode.Create(Left, Values[Left]));

    Mid := (Left + Right) div 2;
    LNode := RecBuild(Left, Mid);
    RNode := RecBuild(Mid + 1, Right);

    Result := TNonLeafNode.Create(LNode, RNode);
  end;

begin
  Result := RecBuild(1, Values.Count - 1);

end;

function Solve(t, v: Int64; const Tree: TNode): Int64;
  function Solve1(v: Int64): Int64;
  var
    Top, Bot, Mid: Integer;

  begin
    Top := N; Bot := 1;
    Result := -1;

    while Bot <= Top do
    begin
      Mid := (Bot + Top) div 2;
      if Tree.GetMax(1, Mid) < v then
        Bot := MId + 1
      else
      begin
        Result := Mid;
        Top := Mid - 1;
      end;
    end;
    if Result <> -1 then
      Result := Ti[Result];
  end;

  function Solve2(v: Int64): Int64;

    function FindIndex(t: Integer): Integer;
    var
      Top, Bot, Mid: Integer;

    begin
      Result := -1;
      Top := N; Bot := 1;
      while Bot <= Top do
      begin
         Mid := (Top + Bot) div 2;
         if Ti[Mid] < t then
         begin
           Bot := Mid + 1
         end
         else
         begin
           Result := Mid;
           Top := Mid - 1
         end
      end;
    end;

  begin
    Result := FindIndex(v);

    //WriteLn('v:', v, ' Result:', Result);
    if Result = -1 then Exit;
    if Result <= N then
      Result := Tree.GetMax(Result, N);
  end;

begin
  if t = 1 then
    Result := Solve1(v)
  else
    Result := Solve2(v)
end;

var
  t, v: Int64;
  Tree: TNode;

begin
  ReadData;
  
{
  Write('Pi: ');
  for i := 1 to N do
    Write(Pi[i], ' ');
  WriteLn;
}
  Tree := BuildSegmentTree(PI);

  while q <> 0 do
  begin
    ReadLn(t, v);
    WriteLn(Solve(t, v, Tree));

    Dec(q);
  end;
end.
