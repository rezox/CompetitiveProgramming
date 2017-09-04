{$mode objfpc}
program MINPERM;
var
  T: Integer;
  N: Integer;

procedure Solve(N: Integer);
var
  i: Integer;
begin
  if not Odd(N) then
  begin
    for i := 1 to N do
    begin
      if Odd(i) then
        Write(i + 1)
      else
        Write(i - 1);
      if i <> N then
        Write(' ');
    end;
    WriteLn;
  end
  else
  begin
    for i := 1 to N - 3 do
    begin
      if Odd(i) then
        Write(i + 1)
      else
        Write(i - 1);
      Write(' ');
    end;
// N - 2, N - 1, N
    WriteLn(N - 1, ' ', N, ' ', N - 2);

  end;
end;

{
2143
21453
}
begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadLn(N);
    Solve(N);
    Dec(T);
  end;
end.
