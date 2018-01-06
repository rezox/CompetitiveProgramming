program RECTANGL;
var
  data: array[0..10000] of Integer;

procedure ReadData;
var
  d: Integer;
  i: Integer;
begin
  FillChar(data, SizeOf(data), 0);

  for i := 1 to 4 do
  begin
    Read(d);
    Inc(data[d]);
  end;
end;

function Solve: Boolean;
var
  i: Integer;

begin
  for i := 1 to High(data) do
    if Odd(data[i]) then
      Exit(False);
end;

var
  T: Integer;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;
    if Solve then
      WriteLn('YES')
    else
      WriteLn('NO');
    Dec(T);
  end;
end.


