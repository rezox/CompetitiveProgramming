{$mode objfpc}
program GIT01;
var
  Rows, Cols: Integer;
  Table: array[0..100] of AnsiString;

procedure ReadData;
var
  r: Integer;

begin
  ReadLn(Rows, Cols);
  for r := 1 to Rows do
    ReadLn(Table[r]);
end;

function Solve: Integer;
var
  r, c: Integer;
  i, j: Integer;
  Count: Integer;

begin
  Result := MaxInt;

  for i := 0 to Cols do
  begin // R^iG^(n-i)
    Count := 0;
    for r := 1 to Rows do
    begin
      for c := 1 to i do
        if Table[r][c] <> 'R' then
          Inc(Count);
      for c := i + 1 to Cols do
        if Table[r][c] <> 'G' then
          Inc(Count);
    end;
    if Count < Result then
      Result := Count;
  end;
  for i := 0 to Cols do
  begin // G^iR^(n-i)
    Count := 0;
    for r := 1 to Rows do
    begin
      for c := 1 to i do
        if Table[r][c] <> 'G' then
          Inc(Count);
      for c := i + 1 to Cols do
        if Table[r][c] <> 'R' then
          Inc(Count);
    end;
    if Count < Result then
      Result := Count;
  end;

end;

var
  T: Integer;
begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;
    WriteLn(Solve);

    Dec(T);
  end; 
end.
