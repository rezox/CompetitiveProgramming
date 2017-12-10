{$mode objfpc}
program CHEFUNI;
uses
  Math;

var
  x, y, z, a, b, c: Integer;

procedure Sort(var x, y, z: Integer);
var
  i, j: Integer;
  Ms: array [0..3] of Integer;

begin
  Ms[1] := x; Ms[2] := y; Ms[3] := z;
  for i := 1 to 3 do
    for j := i + 1 to 3 do
      if Ms[i] < Ms[j] then
      begin
        Ms[i] := Ms[i] xor Ms[j];
        Ms[j] := Ms[i] xor Ms[j];
        Ms[i] := Ms[i] xor Ms[j];
      end;
  x := Ms[1]; y := Ms[2]; z := Ms[3];
end;


function Solve(x, y, z: Integer): Integer; // No c.
var
  i, j: Integer;
  d: Integer;

begin
  if 2 * a <= b then
    Exit((x + y + z) * a);
  Sort(x, y, z);
  Result := 0;
  while y <> 0 do
  begin
    Dec(x, 1); Dec(y, 1);
    Sort(x, y, z);
    Inc(Result);
  end;
  Result := Result * B;
  if x <> 0 then
    Result := Result + x * A;

end;

function Solve(x, y, z: Integer; dbg: Boolean): Int64;
var
  i: Integer;
  tmp : Integer;

begin 
  Result := MaxInt;
  if 3 * A < C then
    Exit(Solve(x, y, z));

  if 3 * B < 2 * C then
  begin
    for i := 0 to 1 do
    begin
      tmp := Solve(x - i, y - i, z - i);
       //WriteLn('i:', i, 'tmp:', tmp, ' tmp+ I *c:', tmp + i * C);
      if Result < i * C then
        break;
      if tmp + i * C < Result then
        Result := tmp + i * C;
    end;
    Exit;
  end;

  for i := 0 to Min(Min(x, y), z) do 
  begin
    tmp := Solve(x - i, y - i, z - i);
     // WriteLn('i:', i, 'tmp:', tmp, ' tmp+ I *c:', tmp + i * C);
    if Result < i * C then
      break;
    if tmp + i * C < Result then
      Result := tmp + i * C;
  end;
end;

procedure ReadData;
begin
  ReadLN(x, y, z, a, b, c);
  Sort(x, y, z);
end;

procedure GenData;
begin
  x := 1 + Random(10); y := 1 + Random(10); z := 1 + Random(10);
  a := Random(100); b := Random(100); c := Random(100);
end;


function NSolve(dbg: Boolean = False): Integer;
var
  a1, a2, a3, b12, b23, b13, c123: Integer;
  ma1, ma2, ma3, mb12, mb23, mb13, mc123: Integer;

begin
if dbg then
  WriteLn('NSolve');
  Result := MaxInt;
  for c123 := 0 to Min(Min(x, y), z) do
    for a1 := 0 to x - c123 do
      for a2 := 0 to y - c123 do
        for a3 := 0 to z - c123 do
          for b12 := 0 to Min(x - a1 - c123, y - a2 - c123) do
            for b13 := 0 to Min(x - a1 - c123 - b12, z - a3 - c123) do
              for b23 := 0 to Min(y - a2 - c123 - b12, z - a3 - c123 - b13) do
                if (x = a1 + b12 + b13 + c123) and (y = a2 + b12 + b23 + c123) and (z = a3 + b13 + b23 + c123) and 
                  (A * (a1 + a2 + a3) + B * (b12 + b13 + b23) + C * c123 < Result) then
                begin
                  Result := A * (a1 + a2 + a3) + B * (b12 + b13 + b23) + C * c123;
                  ma1 := a1; ma2 := a2; ma3 := a3; mb12 := b12; mb13 := b13; mb23 := b23; mc123 := c123;
                end;
  if dbg then
    WriteLn('a:', ma1, ' a2:', ma2, ' a3:', ma3, ' b12:', mb12, ' b13:', mb13, ' b23:', mb23, ' c123:', mc123);
end;

var
  T: Integer;
begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;

     GenData;
    if Solve(x, y, z, False) <> NSolve then
    begin
  WRiteLn(x, ' ', y, ' ', z, ' ', a, ' ', b, ' ', c);
      NSolve(True);
      Solve(x, y, z, True);
      WriteLn('NSolve:', NSolve(False));
      WriteLn('Solve:', Solve(x, y, z, False));
     
break;
    end;
    Inc(T);
    if T mod 100 = 0 then
      WriteLn(T);
continue;

    WriteLn(Solve(x, y, z, False));
    Dec(T);
  end;
end.
