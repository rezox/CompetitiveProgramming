{$mode objfpc}
program D20A;
uses
  fgl, SysUtils;
type
  TIntList = specialize TFPGList<Integer>;
  TBoolList = specialize TFPGList<Boolean>;
  TStatusMap = specialize TFPGMap<Int64, TIntList>;

  TPoint = record
    x, y, z: Integer;
  end;

procedure Print(const P: TPoint);
begin
  WriteLn('x:', P.x, ' y:', P.y, ' z:', P.z);
end;

var
  PCount: Integer;
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

    PCount := i;
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

  function ComputeDist(const P: TPoint): uInt64;
  begin
    Result := Sqr(P.x) + Sqr(P.y) + Sqr(P.z);
  end;

  function ComputeDist(const P, Q: TPoint): uInt64;
  begin
    Result := Sqr(P.x - Q.x) + Sqr(P.y - Q.y) + Sqr(P.z - Q.z);
  end;


var
  t, i, j, k: Integer;
  State: TStatusMap;
  Distance: Int64;
  Data: TIntList;
  OK: TBoolList;
  OKCount, LastOKCount: Integer;
  MinDistance: Int64;

begin
  OK := TBoolList.Create;
  OK.Count := PCount + 1;
  for i := 1 to PCount do
    OK[i] := True;
  OKCount := PCount;
  LastOKCount := -1;

  for t := 1 to 10000 do
  begin
    State := TStatusMap.Create;
    State.Sorted := True;

    if t mod 100 = 0 then
    begin
      MinDistance := 1 shl 20;
      for i := 1 to PCount do
        if OK[i] then
          for j := i + 1 to PCount do
            if OK[j] then
              if ComputeDist(Pi[i], Pi[j]) < MinDistance  then
                MinDistance := ComputeDist(Pi[i], Pi[j]);
      WriteLn('t:', t, ' MinDistance:', MinDistance);
    end;
    for i := 1 to PCount do
    begin
      if not OK[i] then
        continue;

      Add(Vi[i], Ai[i]);
      Add(Pi[i], Vi[i]);
  
      Distance := ComputeDist(Pi[i]);
      if State.TryGetData(Distance, Data) then
        Data.Add(i)
      else
      begin
        Data := TIntList.Create;
        Data.Add(i);
        State.Add(Distance, Data);
      end;
    end;
    
    for i := 0 to State.Count  - 1 do
    begin
      Data := State.Data[i];
   
      for j := 0 to Data.Count - 1 do
        for k := j + 1 to Data.Count - 1 do
          if ComputeDist(Pi[Data[j]], Pi[Data[k]]) = 0 then
          begin
            if OK[Data[j]] then
              Dec(OKCount);
            OK[Data[j]] := False;
            if OK[Data[k]] then
              Dec(OKCount);
            OK[Data[k]] := False;
          end;
      Data.Free;
    end;

    if OKCount <> LastOKCount then
      WriteLn('t:', t, ' LastOKCount: ', LastOKCount, ' -> ', OKCount);
    LastOKCount := OKCount;

    State.Free;
  end;
  WriteLn('OKCount: ', OKCount);
end;

begin
  ReadData;
  Solve;
end.
