{$mode objfpc}
program CLRL;
var
  N, R: Integer;
  Ai: array[0..1000000] of Integer;

procedure ReadData;
var
  i: Integer;
begin
  ReadLn(N, R);

  for i := 1 to N do
    Read(Ai[i]);
  ReadLn;
end;

function Solve: Boolean;
var
  i: Integer;
  Top, Bot: Integer;

begin
  Top := MaxInt;
  Bot := -1;

    
  for i := 1 to N do
  begin
    if (Top < Ai[i]) or (Ai[i] < Bot) then
      Exit(False);

    if Ai[i] < R then
      Bot := Ai[i]
    else if R < Ai[i] then
      Top := Ai[i]
    else
    begin
      if i <> N then
        Exit(False);
    end;
  end;
  Result := True;
end;

var
  T: Integer;
  
begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;
    if Solve then
      WriteLn('YES')
    else
      WriteLn('NO');

    Dec(T);
  end;
end.
