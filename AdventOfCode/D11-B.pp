{$mode objfpc}
program D11B;
uses
  classes, SysUtils, Math;

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

function Max(const a, b, c: Integer): Integer;
begin
  Result := Math.Max(Math.Max(a, b), c);
end;

var
  i: Integer;
  InputString: AnsiString;
  Index: Integer;
  StrList: TStringList;
  Delta: array [0..3] of Integer;
  MaxVal: Integer;

begin
  ReadLn(InputString);
  
  StrList := TStringList.Create;
  StrList.Delimiter := ',';
  StrList.DelimitedText := InputString;

  MaxVal := -1;
  FillChar(Delta, SizeOf(Delta), 0);
  for i := 0 to StrList.Count - 1 do
  begin
    Index := GetCode(StrList[i]);
    
    Delta[1] := Delta[1] + Cords[Index][1];
    Delta[2] := Delta[2] + Cords[Index][2];
    Delta[3] := Delta[3] + Cords[Index][3];

    if MaxVal < Max(Delta[1], Delta[2], Delta[3]) then
      MaxVal := Max(Delta[1], Delta[2], Delta[3]);
  end;
  WriteLn(MaxVal);
end.
