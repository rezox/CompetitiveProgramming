{$mode objfpc}
program P71A;
uses
  SysUtils;

function Solve(const S: AnsiString): AnsiString;
begin
  if Length(S) <= 10 then
    Exit(S);
  Result := Format('%s%d%s', [S[1], Length(S) - 2, S[Length(S)]])
end;

var
  S: AnsiString;
  n: Integer;

begin
  ReadLn(n);

  while n <> 0 do
  begin
    ReadLn(S);
    WriteLn(Solve(S));

    Dec(n);
  end;
end.
