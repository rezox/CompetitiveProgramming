{$mode objfpc}
program D19A;
uses
  classes;

function ReadData: TStringList;
var
  i: Integer;
  S: AnsiString;

begin
  Result := TStringList.Create;

  while not EoF do
  begin
    ReadLn(S);
    if S = '' then
      break;

    Result.Add(S);
  end;
end;

function Solve(Table: TStringList): AnsiString;
  procedure Debug(const r, c, dr, dc: Integer);
  begin
    WriteLn(Table[r][c], '<->', r, ':', c, '(', dr, ',', dc, ')');
  end;

var
  NRow, NCol: Integer;
  r, c: Integer;
  dr, dc: Integer;
  i: Integer;
  Last: Char;
  tmp: AnsiString;

begin
  NRow := Table.Count;
  NCol := Length(Table[0]);

  for c := 1 to NCol do
    tmp := tmp + ' ';
  Table.Add(tmp);

  for i := 0 to NRow - 1 do
    Table[i] :=Table[i] + ' ';

  for i := 1 to NCol do
    if Table[0][i] = '|' then
    begin
      c := i;
      break;
    end;
  r := 0;
  dr := +1; dc := 0;
  Result := '';
  Debug(r, c, dr, dc);
  Last := '|';
  Inc(r, dr);
  Inc(c, dc);

  while (0 <= r) and (r < NRow) and (0 <= c) and (c < NCol) do
  begin
    Debug(r, c, dr, dc);
    if Table[r][c] in ['A'..'Z'] then
      Result := Result + Table[r][c]
    else if Table[r][c] = Last then
    begin
      // Do nothing
    end
    else if Table[r][c] = '+' then
    begin
      if dr <> 0 then
      begin
        if Table[r + dr][c + 1] <> ' ' then
          dc := +1
        else
          dc := -1;
        dr := 0;
      end
      else
      begin
        if Table[r + 1][c + dc] <> ' ' then
          dr := +1
        else
          dr := -1;
        dc := 0;
      end

    end;

    Inc(r, dr);
    Inc(c, dc);
  end;
end;

var
  Table: TStringList;

begin
  Table := ReadData;
  WriteLn(Solve(Table));
end.
