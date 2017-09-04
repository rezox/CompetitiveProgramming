{$mode objfpc}
program CHEFPDIG;

var
  RCount: array [0..100001,'0'..'9'] of Boolean; 

procedure Solve(const N: AnsiString);
var
  Count: array[$0..$FF] of Boolean;
  c: Char;
  i, j: Integer;
begin
  FillChar(Count, SizeOf(Count), 0);
  FillChar(RCount, SizeOf(RCount), 0);

  for i := Length(N) + 1 downto 1 do
  begin
    RCount[i] := RCount[i + 1];
    Inc(RCount[i][N[i]]);
  end;
{
  for i := 1 to Length(N) do
  begin
     Write(i, ':', N[i], ':');
     for c := '0' to '9' do
       if RCount[i, c] then
         Write('+ ')
       else
         Write('- ');
     WriteLn;
  end;
}


  for i := Length(N) downto 1 do
  begin
    for c := '0' to '9' do
      if RCount[i + 1, c] then
        Count[10 * Ord(N[i]) - 528 + Ord(c)] := True;
    for c := '0' to '9' do
      if RCount[i + 1, c] then
        Count[10 * Ord(c) + Ord(N[i]) - 528] := True;

  end;

  for i := 65 to 90 do
    if Count[i] then
      Write(Chr(i));
  WriteLn;
end;

var
  T: Integer;
  N: AnsiString;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadLn(N);
    Solve(N);
    Dec(T);
  end;
end.

