{$mode objfpc}
program RAINBOWA;
uses
  fgl;
type
  TIntList = specialize TFPGList<Integer>;

var
  n: Integer;

function ReadData: TIntList;
var
  i: Integer;
  x: Integer;
begin
   ReadLn(n);
   Result := TIntList.Create;

   for i := 1 to n do
   begin
     Read(x);
     Result.Add(x);
   end;
end;

function Solve(A: TIntList): Boolean;
var
  i, j: Integer;
  ai: Integer;
  Ni, Vi: array[0..100] of Integer;
begin
  FillChar(Ni, SizeOf(Ni), 0);
  FillChar(Vi, SizeOf(Vi), 255);
  j := 0;

  Result := False;
  for i := 0 to A.Count - 1 do
  begin
    ai := A[i];
    if ai <= 0 then Exit;
    if 20 <= j then Exit;

    if Vi[j] <> ai then
    begin
      Inc(j);
      Vi[j] := ai;
      Ni[j] := 1;
    end
    else
      Inc(Ni[j]);
  end;

  for i := 1 to 7 do
    if Vi[i] <> i then
      Exit;
  for i := 7 to 13 do
    if Vi[i] <> 14 - i then
      Exit;
  for i := 1 to 13 do
    if Ni[i] <> Ni[14 - i] then
      Exit;
  Result := True;
end;

var
  T: Integer;
  Ai: TIntList;

begin
  ReadLn(T);
  while T <> 0 do
  begin
    Ai := ReadData;
    if Solve(Ai) then
      WriteLn('yes')
    else
      WriteLn('no');
    Ai.Free;
    Dec(T);
  end;
end.

