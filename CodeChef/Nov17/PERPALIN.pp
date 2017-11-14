{$mode objfpc}
program PERPALIN;
var
  N, P: Integer;

function Solve: AnsiString;
var
  i, j: Integer;
  Period: AnsiString;
{
  P <> 2:
    T=baaaab
    TT...TT

  P = 2:
    T = ab
    abababab
}
begin
  if P = 1 then
    Exit('impossible');
  if P = 2 then
    Exit('impossible');
  Result := '';
  SetLength(Period, P);
  Period[1] := 'b';
  for i := 2 to P - 1 do
    Period[i] := 'a';
  Period[P] := 'b';
  SetLength(Result, N);

  for i := 0 to N div P - 1 do
    for j := 1 to P do
      Result[i * P + j] := Period[j];

end;

var
  T: Integer;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadLn(N, P);
    WriteLn(Solve);

    Dec(T);
  end;
end.
