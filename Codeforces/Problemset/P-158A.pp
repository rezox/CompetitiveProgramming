program P158A;
var
  n, k: Integer;
  
function ReadAndSolve: Integer;
var
  i, x, y: Integer;

begin
  ReadLn(n, k);
  Result := 0;

  for i := 1 to k do
  begin
    Read(x);
    if x = 0 then
      Exit(i - 1);
  end;

  y := x;
  Result := k;
  for i := k + 1 to n do
  begin
    Read(x);
    if x = y then
      Inc(Result)
    else
      break;
  end;
end;

begin
  WriteLn(ReadAndSolve);

end.
