{$mode objfpc}
program B;
uses
  math;
var
  N: Integer;
  Data: array[0..300, 0..300] of Integer;

procedure Print;
var
  xi, yi: Integer;
begin
    for xi := 0 to N - 1 do
    begin
      for yi := 0 to N - 1 do
        Write(DAta[xi, yi], ' ');
    WriteLn;
    end;
    WriteLn('----');

end;

procedure Update(x, y, w: Integer);
var
  xi, yi: Integer;
begin
  for xi := Max(0, x - w) to Min(N - 1, x + w) do
    for yi := Max(0, y - w) to Min(N - 1, y + w) do
    begin
      Inc(Data[xi, yi], w - Max(Abs(x - xi), Abs(y - yi)));
    end;
//  Print;
end;

function GetMax: Integer;
var
  x, y: Integer;

begin
  Result := Data[0, 0];
  for x := 0 to N - 1 do
    for y := 0 to N - 1 do
      if Result < Data[x, y] then
        Result := Data[x, y];
end;

var
  m: Integer;
  x, y, w: Integer;

var
  i: Integer;
  xi, yi: Integer;
begin
  FillChar(Data, SizeOf(Data), 0);

  ReadLn(N);
  ReadLn(M);
  for i := 1 to M do
  begin
    ReadLn(x, y, w);

    Update(x, y, w);
  end;
  WriteLn(GetMax);

end.
