{$mode objfpc}
program PALINGAM;

function Solve(const a, b: AnsiString): Boolean;
var
  Na, Nb: array['a'..'z'] of Integer;
  i: Integer;
  c1, c2: Char;
  
begin
  FillChar(Na, SizeOf(Na), 0);
  FillChar(Nb, SizeOf(Nb), 0);

  for i := 1 to Length(a) do
    Inc(Na[a[i]]);
  for i := 1 to Length(b) do
    Inc(Nb[b[i]]);

  // axa
  for c1 := 'a' to 'z' do
    if (2 <= Na[c1]) and (Nb[c1] = 0) then
      Exit(True);

  //aa
  Result := False;
  for c1 := 'a' to 'z' do
    if (0 <> Na[c1]) and (Nb[c1] = 0) then
    begin
      Result := True;
      break;
    end;
  if not Result then
    Exit(False);


  // ax
  Result := False;
  for c1 := 'a' to 'z' do
    if (1 = Na[c1]) and (Nb[c1] = 0) then
    begin
      Result := True;

      for c2 := 'a' to 'z' do
        if (c1 <> c2) and (Nb[c2] <> 0) and (Na[c2] = 0) then
        begin
          Result := False;
          break;
        end;
      if Result then
        Exit(True);
    end;

  Result := False;
end;

var
  T: Integer;
  a, b: AnsiString;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadLn(a);
    ReadLn(b);

    if Solve(a, b) then
      WriteLn('A')
    else
      WriteLn('B');

    Dec(T);
  end;
end.
