{$mode objfpc}
program D5A;
uses
  classes, SysUtils, fgl;
type
  TIntList = specialize TFPGList<Integer>;

function Run(Jumps: TIntList): Integer;
var
  i: Integer;
begin
  Result := 0;
  i := 0;

  while (0 <= i) and (i < Jumps.Count) do
  begin
    // WriteLn(Result, ':', i);
    Inc(Result);
    Jumps[i] := Jumps[i] + 1;
    Inc(i, Jumps[i] - 1);
  end;
end;

var
  Jumps: TIntList;
  i, j: Integer;
  S: AnsiString;

begin
  Jumps := TIntList.Create;

  while not EoF do
  begin
    ReadLn(S);
    Jumps.Add(StrToInt(S));
  end;

  WriteLn(Run(Jumps));
end.
