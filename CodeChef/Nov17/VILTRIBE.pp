{$mode objfpc}
program VILTRIBE;

procedure Solve(const S: AnsiString);
var
  T: AnsiString;
  last: Char;
  i: Integer;
  N: array ['A'..'B'] of Integer;

begin
  Last := '.';
  T := S;
  FillChar(N, SizeOf(N), 0);
  for i := 1 to Length(S) do
  begin
    if S[i] <> '.' then
    begin
      Last := S[i];
      Inc(N[Last]);
    end
    else
      T[i] := Last;
    
  end;
//WriteLn(S);
//WriteLn(T);
Last := '.';
  for i := Length(S) downto 1 do
  begin
    if S[i] <> '.' then
      Last := S[i]
    else if T[i] = Last then
    begin
    //  WriteLn(i, '->', Last);
      Inc(N[Last]);
    end;  
  end;

  WriteLn(N['A'], ' ', N['B']);
end;

var
  T: Integer;
  S: AnsiString;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadLn(S);
    Solve(S);
    Dec(T);
  end;
end.
