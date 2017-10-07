{$mode objfpc}
program PERFCONT;
uses
  fgl;
type
  TIntList = specialize TFPGList<Integer>;

var
  Solved: TIntList;
  N: Integer;
  P: Int64;

procedure ReadData;
var
  i: Integer;
  si: Int64;

begin
  Solved.Free;

  ReadLn(N, P);

  Solved := TIntList.Create;

  for i := 1 to N do
  begin
    Read(si);
    Solved.Add(si);
  end;
end;

function Solve: Boolean;
var
  Easy, Hard: Integer;
  i: Integer;
begin
  Easy := 0; Hard := 0;

  for i := 0 to N - 1 do
    if P div 2 <= Solved[i] then
      Inc(Easy)
    else if Solved[i] <= P div 10 then
      Inc(Hard);
  Result := (Easy = 1) and (Hard = 2);
end;

var
  T: Integer;
  i: Integer;

begin
  Solved := nil;

  ReadLn(T);

  for i := 1 to T do
  begin
    ReadData;
    if Solve then
      WriteLn('yes')
    else
      WriteLn('no');
  end;
end.

