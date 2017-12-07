{$mode objfpc}
program GIT01;
uses
  StrUtils, Math;
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
  Cost: Integer;

begin
  Result := MaxInt;
 
  Cost := 0;
  for r := 1 to Rows do
    for c := 1 to Cols do
      if Table[r][c] <> IfThen((r + c) and 1 = 1, 'R', 'G')[1] then
        Inc(Cost, IfThen(Table[r][c] = 'R', 5, 3));
  if Cost < Result then
      Result := Cost;

  Cost := 0;
  for r := 1 to Rows do
    for c := 1 to Cols do
      if Table[r][c] <> IfThen((r + c) and 1 = 1, 'G', 'R')[1] then
        Inc(Cost, IfThen(Table[r][c] = 'R', 5, 3));
  if Cost < Result then
      Result := Cost;


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
