{$mode objfpc}
program D20A;
uses
  SysUtils;
type
  TPoint = record
    x, y, z: Extended;
  end;

procedure Print(const P: TPoint);
begin
  WriteLn('x:', P.x:0:4, ' y:', P.y:0:4, ' z:', P.z:0:4);
end;

var
  Pi, Vi, Ai: array [0..1000] of TPoint;

procedure ReadData;
  function ReadPoint(var S: AnsiString): TPoint;
  begin
    Delete(S, 1, 1);
    Result.x := StrToInt(Copy(S, 1, Pos(',', S) - 1));
    Delete(S, 1, Pos(',', S));
    Result.y := StrToInt(Copy(S, 1, Pos(',', S) - 1));
    Delete(S, 1, Pos(',', S));
    Result.z := StrToInt(Copy(S, 1, Pos('>', S) - 1));
    Delete(S, 1, Pos('>', S));
  end;

var
  i: Integer;
  S: AnsiString;

begin
  i := 0;
  while not Eof do
  begin 
    ReadLn(S);

    Delete(S, 1, 2);
    Inc(i);
    Pi[i] := ReadPoint(S);
    Delete(S, 1, 4);
    Vi[i] := ReadPoint(S);
    Delete(S, 1, 4);
    Ai[i] := ReadPoint(S);

{
    WriteLn(i);
    Print(Pi[i]);
    Print(Vi[i]);
    Print(Ai[i]);
}
  end;
end;

function Solve: Integer;
  procedure Add(var Target: TPoint; Source: TPoint);
  begin
    Target.x := Target.x + Source.x;
    Target.y := Target.y + Source.y;
    Target.z := Target.z + Source.z;
  end;

  function ComputeDist(const P: TPoint): Extended;
  begin
    Result := Sqr(P.x) + Sqr(P.y) + Sqr(P.z);
  end;
var
  t, i: Integer;
  LastIndex, MinIndex: Integer;

begin
  LastIndex := -1;
  for t := 1 to 100000 do
  begin
    MinIndex := 1;
    for i := 1 to 1000 do
    begin
      Add(Vi[i], Ai[i]);
      Add(Pi[i], Vi[i]);
  
      if ComputeDist(Pi[i]) < ComputeDist(Pi[MinIndex]) then
        MinIndex := i;
    end;
    if LastIndex <> MinIndex then
    begin
      WriteLn(t, ':', LastIndex, ' -> ', MinIndex);
      LastIndex := MinIndex;
    end;
  end;
  WriteLn('MinIndex: ', MinIndex);
end;

begin
  ReadData;
  Solve;
end.
