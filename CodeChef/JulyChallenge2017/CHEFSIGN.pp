{$mode objfpc}
program CHEFSIGN;
uses
  fgl;

type
  TIntList = specialize TFPGList<Integer>;

function Solve(S: AnsiString): Integer;
var
  CurLen: Integer;
  Last, i, j: Integer;

begin
  //WriteLn(S);
  j := 0;
  for i := 1 to Length(S) do
    if S[i] <> '=' then
    begin
      Inc(j);
      S[j] := S[i];
    end;
  SetLength(S, j);
  //WriteLn(S);
  Result := 0;
  if S = '' then
    Exit;
    
  

  CurLen := 1;
  Last := 1;
  for i := 2 to Length(S) do
  begin
    if S[i] = S[Last] then
      Inc(CurLen)
    else
    begin
    //  WriteLn(S[Last], ' ', CurLen);
      if Result < CurLen then
        Result := CurLen;
      Last := i;
      CurLen := 1;
    end;
  end;
  //  WriteLn('Last:', Last);
  //  WriteLn(S[Last], ' ', CurLen);
  if Result < CurLen then
    Result := CurLen;
end;

var
  T: Integer;
  S: AnsiString;

begin
  ReadLn(T);

  while 0 < T do
  begin
    ReadLn(S);
    WriteLn(1 + Solve(S));
    Dec(T);
  end;
end.

