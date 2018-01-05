{$mode objfpc}
program P4A;
var
  w: Integer;

begin
  ReadLn(w);
  if w <= 2 then
    WriteLn('NO')
  else if Odd(w) then
    WriteLn('NO')
  else
    WriteLn('YES')
end.
