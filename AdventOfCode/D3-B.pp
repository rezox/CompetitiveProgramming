program D3B;

procedure GetPos(N: Integer; var ox, oy: Integer);
var
  i, m: Integer;
  d: Integer;
  x, y: Integer;

begin
  i := 1;
  while Sqr(i) < N do
    Inc(i, 2);
  if N = Sqr(i) then
  begin
    ox := i div 2;
    oy := i div 2;
    //WriteLn(+i div 2, +i div 2);
    Exit;
  end;
  Dec(i, 2);
  d := i;
{
  WriteLn('d:', d, ' d^2:', Sqr(d), ' N-d^2:', N - Sqr(d));
           37 36 35 34 33 32 31       
           38 17 16 15 14 13 30        
           39 18 05 04 03 12 29          
           40 19 06 01 02 11 28            
           41 20 07 08 09 10 27         
           42 21 22 23 24 25 26
           43 44 45 46 47 48 49
 
                TR = N^2-3N+3 
                TL = N^2-2N+2 
                BL = N^2-N+1 
                BR = N^2
}
                                    
  x := +d div 2; y := +d div 2;
  //WriteLn('x:', x, ', y:', y);
  if (Sqr(d) < N) and (N <= Sqr(d) + 1 + d) then 
  begin
    ox := x + 1;
    oy := y - (N - 1 - Sqr(d));
  end
  else if N <= Sqr(d) + 2 + 2 * d then
  begin
    ox := x + 1 - (N - Sqr(d) - d - 1);
    oy := -y - 1;
    //WriteLn('*:', x + 1 - (N - Sqr(d) - d - 1), ':', - y - 1)
  end
  else if N <= Sqr(d) + 3 + 3 * d then
  begin
    ox := -x - 1;
    oy := -y - 1 + (N - Sqr(d) - 2 - 2 * d);
    //WriteLn('*:', -x - 1, ':', -y - 1 + (N - Sqr(d) - 2 - 2 * d ))
  end
  else
  begin
    ox := -x - 1 + (N - Sqr(d) - 3 - 3 * d);
    oy := y + 1;
  //  WriteLn('*:', -x - 1 + (N - Sqr(d) - 3 - 3 * d), ':', + y + 1)
;
  end;
end;

var
  Table: array[-500..500, -500..500] of Integer;

function GetValue(x, y: Integer): Integer;
const
  dx: array [1..8] of Integer = (-1, -1, -1,  0,  0, +1, +1, +1);
  dy: array [1..8] of Integer = (-1,  0, +1, -1, +1, -1,  0, +1);
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to 8 do
    if Table[x + dx[i], y + dy[i]] <> -1 then
    begin
      Inc(Result, Table[x + dx[i], y + dy[i]]);
    end;
end;

var
  N: Integer;
  x, y: Integer;
  i: Integer;
  Current: Integer;

begin
  ReadLn(N);
  FillChar(Table, SizeOf(Table), 255);
 
  Table[0, 0] := 1;
  i := 2;
  while Current <= N do
  begin
    GetPos(i, x, y);
    Current := GetValue(x, y);
    Table[x, y] := Current;
    WriteLn(i, ':(', x, ',', y, ') ->', Current);
    Inc(i);
  end;
  
end.
