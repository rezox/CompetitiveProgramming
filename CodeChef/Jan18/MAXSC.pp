{$mode objfpc}
program MAXSC;
uses
  fgl;
type
  TIntList = specialize TFPGList<Int64>;

var
  Seqs: array[0..700] of TIntList;
  N: Integer;

function CompareInt(const a, b: Int64): Integer;
begin
  if a < b then
    Exit(-1);
  if b < a then
    Exit(+1);
  Result := 0;
end;

procedure ReadData;
var
  i, j: Integer;
  aij: Int64;
  data: TIntList;
begin
  for i := 1 to N do
    Seqs[i].Free;

  N := 700;
  ReadLn(N);

  for i := 1 to N do
  begin
    data := TIntList.Create;
    data.Add(-1000);

    for j := 1 to N do
    begin
      Read(aij);
      data.Add(aij);

    end;
    data.Sort(@CompareInt);
    Seqs[i] := data;
    ReadLn;
  end;
end;

function Solve: Int64;

  function FindLast(const aList: TIntList; value: Int64) : Integer;
  var
    Top, Bot, Mid: Integer;

  begin
    Bot := 1; Top:= aList.Count - 1;
    Result := -1;

    while Bot <= Top do
    begin
      Mid := (Bot + Top) div 2;
      if aList[Mid] < value then
      begin
        Result := Mid;
        Bot := Mid + 1
      end
      else
        Top := Mid - 1;
    end;
  end;


var
  dp: array[0..2, 0..700] of Int64;
  i, j, k: Integer;
  Source: Integer;
  HasGoodValue: Boolean;
  Current: Int64;

begin
  FillChar(dp, SizeOf(dp), 0);

  Source := 1;
  dp[1, 0] := -1;
  for i := 1 to N do
    dp[1, i] := Seqs[1][i];

  for i := 1 to N - 1 do
  begin
    FillChar(dp[Source xor 1], SizeOf(dp[1]), 255);
    HasGoodValue := False;

    for k := 1 to N do
    begin
      j := FindLast(Seqs[i], Seqs[i + 1][k]);
      if (j < 0) or (dp[Source, j] < 0) then
        Continue;
      if dp[Source xor 1, k] < dp[Source, j] + Seqs[i + 1][k] then
      begin
        dp[Source xor 1, k] := dp[Source, j] + Seqs[i + 1][k];
        HasGoodValue := True;
      end;
    end;
    Source := Source xor 1;
    if not HasGoodValue then
      break;
  end;

  Result := -1;
  for j := 0 to N do
    if Result < dp[Source, j] then
      Result := dp[Source, j];
end;

var
  T: Integer;

begin
  ReadLn(T);
  N := 0;

  while T <> 0 do
  begin
    ReadData;
    WriteLn(Solve);

    Dec(T);
  end;
end.
