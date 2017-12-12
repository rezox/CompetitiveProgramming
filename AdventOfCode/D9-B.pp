{$mode objfpc}
program D9A;
uses
  SysUtils, fgl;

function Clean(const Data: AnsiString): AnsiString;
var
  i: Integer;
begin
  Result := '';
  i := 1;
  while i <= Length(Data) do
  begin
    if Data[i] = '!' then
      Inc(i, 1)
    else
      Result := Result + Data[i];
     Inc(i);
  end;
end;

var
  GarbageCount: Integer;

function GetNextToken(Ch: PChar): PChar;
  procedure SkipGargabe;
  begin
    while Ch^ <> '>' do
    begin
      if Ch^ = '!' then
      begin
        Inc(Ch);
        Dec(GarbageCount);
      end;
      Inc(Ch);
      Inc(GarbageCount);
    end;
    Inc(Ch);
    Dec(GarbageCount);
  end;

begin
  Inc(Ch);
  if Ch^ = '<' then
  begin
    SkipGargabe;
    Result := Ch;
    Exit;
  end
  else
    Result := Ch;
end;

type
  TIntList = specialize TFPGList<Integer>;

var
  ScoreCount: TIntList;

procedure RecScore(var Current: PChar; Score: Integer; Indent : AnsiString = '');
var
  i: Integer;

begin
  if Current^ <> '{' then
    raise Exception.Create('Expected { visited ' + Current^);
  Indent := Indent + '.';
  Inc(Score);
  if ScoreCount.Count <= Score then
    ScoreCount.Add(0);
  ScoreCount[Score] := 1 + ScoreCount[Score];

  WriteLn(Indent, Current^);
  Current := GetNextToken(Current);

  while True do
  begin
    if Current^ = '{' then
      RecScore(Current, Score, Indent)
    else if Current^ = '}' then
    begin
      WriteLn(Indent, Current^);
      Current := GetNextToken(Current);
      break;
    end
    else
    begin
      WriteLn(Indent, Current^);
      Current := GetNextToken(Current);
    end;
  end;
end;

var
  S: AnsiString;
  Cur: PChar;
  i, Result: Integer;

begin
  ReadLn(S);
  Cur := @S[1];
  ScoreCount := TIntList.Create;
  ScoreCount.Add(0);
  GarbageCount := 0;

  RecScore(Cur, 0, '');
  WriteLn(GarbageCount);
end.
