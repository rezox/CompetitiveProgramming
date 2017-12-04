{$mode objfpc}
program CPLAY;

procedure Solve(const T: AnsiString);
var
  ScoreA, ScoreB: Integer;
  RemA, RemB: Integer;
  i: Integer;

begin
  ScoreA := 0; ScoreB := 0;
  RemA := 5; RemB := 5;
  for i := 0 to 4 do
  begin
    if T[2 * i + 1] = '1' then
      Inc(ScoreA);
    Dec(RemA);

    if ScoreA + RemA < ScoreB then
    begin
      WriteLN('TEAM-B ', 2 * i + 1);
      Exit;
    end;
    if ScoreB + RemB < ScoreA then
    begin
      WriteLN('TEAM-A ', 2 * i + 1);
      Exit;
    end;

    if T[2 * i + 2] = '1' then
      Inc(ScoreB);
    Dec(RemB);
    if ScoreA + RemA < ScoreB then
    begin
      WriteLN('TEAM-B ', 2 * i + 2);
      Exit;
    end;
    if ScoreB + RemB < ScoreA then
    begin
      WriteLN('TEAM-A ', 2 * i + 2);
      Exit;
    end;
  end;

  for i:= 5 to 9 do
  begin
    if T[2 * i + 1] < T[2 * i + 2] then
    begin
      WriteLN('TEAM-B ', 2 * i + 2);
      Exit;
    end;
    if T[2 * i + 1] > T[2 * i + 2] then
    begin
      WriteLN('TEAM-A ', 2 * i + 2);
      Exit;
    end;
  end;
  WriteLn('TIE');
end;

var
  Data: AnsiString;

begin
  while not EoF do
  begin
    ReadLn(Data);
    Solve(Data);

  end;
end.
