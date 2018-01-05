{$mode objfpc}
program P1A;
var
  n, m, a: Int64;

begin
  ReadLn(n, m, a);

  WriteLn(((n + a - 1) div a) * (m + a - 1) div a);
end.
