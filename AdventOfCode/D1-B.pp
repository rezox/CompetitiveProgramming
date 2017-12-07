{$mode objfpc}
program P2;
uses
  Math;
var
  S: AnsiString;
  i: Integer;
  n: Integer;
  Sum: Int64;
begin
  ReadLn(S);
  n := Length(S);
  Sum := 0;

  for i := 0 to n - 1 do
  begin
    if S[i + 1] = S[(i + n div 2) mod n + 1] then
    begin
      WriteLn(i + 1, ':', S[i + 1]);
      Inc(Sum, Ord(S[i + 1]) - 48);
    end;
  end;
  WriteLn(Sum);
end.
