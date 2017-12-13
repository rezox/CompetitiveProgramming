{$mode objfpc}
program D11A;
uses
  classes, SysUtils;
const
  Indices : array [1..8] of AnsiString =
    ('n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw');
  S = 5;
  SW = 6;
  NW = 8;
  Cords: array[1..8, 1..3] of Integer = (
     (+0, +1, -1), // n
     (+1,  0, -1), // ne
     (+0, +0, +0), // e?
     (+1, -1, 0), //se
     ( 0, -1, +1), // s
     ( -1,  0, +1), //sw
     (0, 0, 0), // w?
     (-1, +1, 0) // nw
  );
 
function GetCode(const S: AnsiString): Integer;
var
  i: Integer;

begin
   for i := 1 to 8 do
    if Indices[i] = S then
      Exit(i);
  raise Exception.Create(S + ' not found!');
end;


var
  i: Integer;
  InputString: AnsiString;
  Counts: array[0..8] of Integer;
  StrList: TStringList;
  Delta: array [0..3] of Integer;

begin
  ReadLn(InputString);
  
  StrList := TStringList.Create;
  StrList.Delimiter := ',';
  StrList.DelimitedText := InputString;

  FillChar(Counts, SizeOf(Counts), 0);

  for i := 0 to StrList.Count - 1 do
    Inc(Counts[GetCode(StrList[i])]);
  
  for i := 1 to 8 do
    WriteLn(Counts[i]);

  WriteLn('  ** ');
  for i := 1 to 4 do
  begin
    if Counts[i] < Counts[i + 4] then
    begin
      Dec(Counts[i + 4], Counts[i]);
      Counts[i] := 0;
    end
    else
    begin
      Dec(Counts[i], Counts[i + 4]);
      Counts[i + 4] := 0;
    end
  end;

  FillChar(Delta, SizeOf(Delta), 0);
  for i := 1 to 8 do
    if Counts[i] <> 0 then
    begin
      Delta[1] := Delta[1] + Counts[i] * Cords[i][1];
      Delta[2] := Delta[2] + Counts[i] * Cords[i][2];
      Delta[3] := Delta[3] + Counts[i] * Cords[i][3];
      WriteLn(Indices[i], ':', Counts[i]);
    end;

  WriteLn(Indices[S], ':', Counts[S]);
  WriteLn(Indices[SW], ':', Counts[SW]);
  WriteLn(Indices[NW], ':', Counts[NW]);
  WriteLn(Delta[1], ' ', Delta[2], ' ', Delta[3]);
end.
