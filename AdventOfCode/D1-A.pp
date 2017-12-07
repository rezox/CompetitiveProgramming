{$mode objfpc}
program P1;
var
  S: AnsiString;
  i: Integer;
  Sum: Int64;

begin
  ReadLn(S);
WriteLn(S);

  Sum := 0;
  for i := 1 to Length(S) - 1 do
    if S[i] = S[i + 1] then
    begin
       WriteLn(i, ':', S[i]);
       Inc(Sum, Ord(S[i]) - 48);
    end;
   
  if S[Length(S)] = S[1] then
  begin
    WriteLn(Length(S), ':', S[1]);
    Inc(Sum, Ord(S[1]) - 48);
  end;
  WriteLn(Sum);
end.
