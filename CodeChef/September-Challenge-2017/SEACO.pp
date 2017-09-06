{$mode objfpc}
{$modeswitch advancedrecords}  
program SEACO;
uses
  fgl, Math;
const
  BucketSize = 2;
  Modulo = 1000000007;

type
  TLineSegment = record
    Left, Right: Integer;
    Count: Integer;

    class operator =(const a, b: TLineSegment): Boolean;
  end;
  TIntList = specialize TFPGList<Integer>;

  TLineSegments = specialize TFPGList<TLineSegment>;
  TCommand = record
    ComType: Integer;
    Left, Right: Integer;
  end;

class operator TLineSegment.=(const a, b: TLineSegment): Boolean;
begin
  result := (a.Left = b.Left) and (a.Right = b.Right) and (a.Count = b.Count);
end;

procedure Print(const Caption: AnsiString; const AList: TLineSegments);
var
  i: Integer;

begin
  WriteLn(Caption);
  for i := 0 to AList.Count - 1 do
    Write('(', AList[i].Left, ' <->', AList[i].Right, ':', AList[i].Count, ')');
  WriteLn;
end;

function CreateLineSegment(const Left, Right: Integer; Count: Integer): TLineSegment;
begin
  Result.Left := Left;
  Result.Right := Right;
  Result.Count := Count;
end;

function CompareInt(const a, b: Integer): Integer;
begin
  Result := a - b;
end;

var
  n, m: Integer;
  Commands: array [0..100000] of TCommand;
  ASum: array of TLineSegments;

function LSAdd(var Target: TLineSegments; const ParamList: TLineSegments; const Multiplier: Integer): TLineSegments;

  function GetCount(Left, Right: Integer; var it, ip: Integer): Integer;
  begin
    if (it < Target.Count) and (Left < Target[it].Left) then
      WriteLn('ERROR: Left', Left, ' t.l:', Target[it].Left, ' it:', it);
    if (ip < ParamList.Count) and (Left < ParamList[ip].Left) then
      WriteLn('ERROR: Left', Left, ' p.l:', ParamList[ip].Left, ' ip:', ip);
    Result := (Target[it].Count + ParamList[ip].Count * Multiplier) mod Modulo;
    while Result < 0 do
      Inc(Result, Modulo);

    if (it < Target.Count) and (Right = Target[it].Right) then
      Inc(it);
    if (ip < ParamList.Count) and (Right = ParamList[ip].Right) then
      Inc(ip);
    
 
{     l<--->r
   L           R
     L             R
}
  end;

var
  i: Integer;
  it, ip: Integer;
  t, p: TLineSegment;
  Current: TLineSegment;
  Nodes, NodeIndices: TIntList;
  Last, Cur: Integer;
  v: Integer;
  
begin
  Result := TLineSegments.Create;

  if Target.Count = 0 then
  begin
    Result.Assign(ParamList);
    Exit;
  end
  else if ParamList.Count = 0 then
  begin
    Result.Assign(Target);
    Exit;
  end;

  //Print('Target:', Target);
  //Print('Param:', ParamList);

  Nodes := TIntList.Create;
  for ip := 0 to ParamList.Count - 1 do
  begin
    Nodes.Add(ParamList[ip].Left);
    Nodes.Add(ParamList[ip].Right);
  end;
  for it := 0 to Target.Count - 1 do
  begin
    Nodes.Add(Target[it].Left);
    Nodes.Add(Target[it].Right);
  end;
  Nodes.Sort(@CompareInt);

  it := 0; ip := 0;
  t := Target[it]; p := ParamList[ip];

  v := 0;
  Last := 0; 
  for i := 1 to Nodes.Count - 1 do
  begin
 //   WriteLn(i, ':', Nodes[i]);
 //   WriteLn('t:', t.Left, ' ', t.Right, ' ', t.Count);
 //   WriteLn('p:', p.Left, ' ', p.Right, ' ', p.Count);
    //if v = Nodes[i] then
    //  Continue;
    Cur := v;
    if Last <> Cur then
    begin
      Result.Add(CreateLineSegment(Last, Cur, GetCount(Last, Cur, it, ip)));
      //WriteLn('Last:', Last, ' Cur: ', Cur, ' ', GetCount(Last, Cur, it, ip));
    end;

    v := Nodes[i];
    Last := Cur;
  end;

  Nodes.Free;

  //Print('Result:', Result);
end;

function Execute(const Cmd: TCommand): TLineSegments; forward;

function ComputeSum(CommandIndex: Integer): TLineSegments;
var
  i: Integer;
  CurLine: TLineSegments;
  tmp: TLineSegments;

begin
  Result := TLineSegments.Create;
  Result.Assign(ASum[CommandIndex div BucketSize]);

  for i := (CommandIndex div BucketSize) * BucketSize + 1 to CommandIndex do
  begin
    CurLine := Execute(Commands[i]);

    tmp := LSAdd(Result, CurLine, +1);
    Result.Free;

    Result := tmp;
    CurLine.Free;
  end;
end;

function Execute(const Cmd: TCommand): TLineSegments;
var
  i, j: Integer;
  LSum, RSum: TLineSegments;

begin
  Result := TLineSegments.Create;
  if Cmd.ComType = 1 then
  begin
    Result.Add(CreateLineSegment(0, Cmd.Left, 0));
    Result.Add(CreateLineSegment(Cmd.Left, Cmd.Right + 1, 1));
    Result.Add(CreateLineSegment(Cmd.Right + 1, n + 1, 0));
    Exit;
  end;
  
  LSum := ComputeSum(Cmd.Left - 1);
  RSum := ComputeSum(Cmd.Right);
  //Print('LSum', LSum);
  //Print('RSum', RSum);
  Result := LSAdd(RSum, LSum, -1);
  LSum.Free; 
  RSum.Free;
end;

procedure Solve;
var
  i, j: Integer;
  CurLine: TLineSegments;
  SumLines, tmp: TLineSegments;

begin
  SumLines := TLineSegments.Create;
  SumLines.Add(CreateLineSegment(0, n + 1, 0));
  SetLength(ASum, 1 + m div BucketSize);
  for i := 0 to High(ASum) do
    ASum[i] := TLineSegments.Create;
  ASum[0].Assign(SumLines);

  for i := 1 to m do
  begin
    //WriteLn('Type:', Commands[i].ComType, ' L:', Commands[i].Left, 'R:', Commands[i].Right);
    CurLine := Execute(Commands[i]);
    //Print('CurLine', CurLine);
    tmp := LSAdd(SumLines, CurLine, +1);
    SumLines.Free;
    SumLines := tmp;

    //Print('->SumLines', SumLines);

    if i mod BucketSize = 0 then
      ASum[i div BucketSize].Assign(SumLines);
    CurLine.Free;

//Print('SumLines:', SumLines);
  end;

  j := 1;
  i := 0;
  for j := 1 to n do
  begin
    if j < SumLines[i].Left then
    begin
WRITELN('ERROR');
EXIT;
    end;
    if j = SumLines[i].Right then
      Inc(i);
    if (SumLines[i].Left <= j) and (j < SumLines[i].Right) then
      Write(SumLines[i].Count, ' ');
  end;
  WriteLn;
  SumLines.Free;

end;

procedure ReadData;
var
  i: Integer;
begin
  ReadLn(n, m);
  for i := 1 to m do
    ReadLn(Commands[i].ComType, Commands[i].Left, Commands[i].Right);
{
  n := 1000; m := 1000;//00;
  Commands[1].ComType := 1; Commands[1].Left := 5; Commands[1].Right := n - 5;
  for i := 2 to m do
  begin
    Commands[i].ComType := 2; Commands[i].Left := 1; Commands[i].Right := i - 1;
  end;
}
end;


var
  T: Integer;
  i, j: Integer;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;
    Solve;

    for i := 0 to High(ASum) do
      ASum[i].Free;
    Dec(T);
  end;
end.
