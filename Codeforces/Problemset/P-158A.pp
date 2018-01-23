program P158A;
uses
  fgl;
var
  n, k: Integer;
  
function ReadAndSolve: Integer;
var
  i, x: Integer;

begin
  ReadLn(n, k);
  Result := 0;

  for i := 1 to n do
  begin
    Read(x);
    if k < x then
      Inc(Result)
    else
      break;
  end;   
end;

begin
  WriteLn(ReadAndSolve);

end.
