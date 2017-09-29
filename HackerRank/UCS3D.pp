{$mode objfpc}
program UCS3D;
uses
  fgl, SysUtils;
type
  TIntList = specialize TFPGList<Integer>;

var
  n: Integer;
  RKings, CKings: TIntList;
  Table: array[0..1000] of AnsiString;

procedure ReadData;
var
  i, j: Integer;
begin
  ReadLn(n);
  for i := 1 to n do
    ReadLn(Table[i]);

  RKings.Free; CKings.Free;
  RKings := TIntList.Create;
  CKings := TIntList.Create;

  for i := 1 to n do
    for j := 1 to n do
      if Table[i, j] = 'K' then
      begin
        RKings.Add(i);
        CKings.Add(j);
      end;
end;

var
  GNumbers: array[0..1000, 0..1000] of Integer;

function Solve: AnsiString;
  procedure ComputeGNumber;
  var
    r, c: Integer;
    Left, Up, LU: Integer;

    function GetNextNum(a, b, c: Integer): Integer;
    begin
      Result := 0;

      while (Result = a) or (Result = b) or (Result = c) do
        Inc(Result);
    end;

 begin
    FillChar(GNumbers, SizeOf(GNumbers), 255);

    for r := 1 to n do
      for c := 1 to n do
        if Table[r, c] <> 'X' then
        begin
          Left := GNumbers[r, c - 1];
          Up := GNumbers[r - 1, c];
          LU := GNumbers[r - 1, c - 1];
          GNumbers[r, c] := GetNextNum(Left, Up, LU);
          //WriteLn('r:', r, 'c :', c, ' GN: ', GNumbers[r, c]);
        end;

  end;
var
  AllKings: Integer;
  i: Integer;
  r, c: Integer;
  CurrentKing: Integer;
  Counter: Integer;

begin
  ComputeGNumber;
  Counter := 0;

  AllKings := 0;
  for i := 0 to RKings.Count - 1 do
  begin
    r := RKings[i]; c := CKings[i];
    AllKings := AllKings xor GNumbers[r, c];
  end;
  //WriteLn('AllKings:', AllKings);
  if AllKings = 0 then
    Exit('LOSE');
for i := 0 to RKings.Count - 1 do
  begin
    r := RKings[i]; c := CKings[i];

    // Moving Left
    if (c <> 1) and (Table[r, c - 1] <> 'X') then
    begin
      CurrentKing := AllKings xor GNumbers[r, c] xor GNumbers[r, c - 1];
      if CurrentKing = 0 then
        Inc(Counter);
    end;
    // Moving Up
    if (r <> 1) and (Table[r - 1, c] <> 'X') then
    begin
      CurrentKing := AllKings xor GNumbers[r, c] xor GNumbers[r - 1, c];
      if CurrentKing = 0 then
        Inc(Counter);
    end;

  // Moving LU
    if (r <> 1) and (c <> 1) and (Table[r - 1, c - 1] <> 'X') then
    begin
      CurrentKing := AllKings xor GNumbers[r, c] xor GNumbers[r - 1, c - 1];
      if CurrentKing = 0 then
        Inc(Counter);
    end;


  end;
  Result := 'Win ' + IntToStr(Counter);
end;

var
  q: Integer;

begin
  RKings := nil; CKings := nil;
  ReadLn(q);

  while q <> 0 do
  begin
    ReadData;
    WriteLn(Solve);
    Dec(q);
  end;
end.
