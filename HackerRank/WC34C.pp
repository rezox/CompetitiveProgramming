{$mode objfpc}
program WC34C;
uses
  fgl;
type
  TIntList = specialize TFPGList<Integer>;
  TIntIntListMap = specialize TFPGMap<Integer, TIntList>;

var
  N, Q: Integer;
  Data: TIntList;

function MapCreate: TIntIntListMap;
begin
  Result := TIntIntListMap.Create;
  Result.Sorted := True;
end;

procedure ReadData;
var
  i: Integer;
  x: Integer;

begin
  ReadLn(N, Q);
  Data := TIntList.Create;
  Data.Add(-1);

  for i := 1 to N do
  begin
    Read(x);
    Data.Add(x);   
  end;
end;

var
  Mapping: TIntIntListMap;

procedure PreProcess;
var
  i: Integer;
begin
  Mapping := MapCreate;
  for i := 1 to N do
    if Mapping.IndexOf(Data[i]) <> -1 then
      Mapping[Data[i]].Add(i)
    else
    begin
      Mapping[Data[i]] := TIntList.Create;
      Mapping[Data[i]].Add(i);
    end;
end;

procedure InsertMap(Map: TIntIntListMap; Key, Value: Integer);
begin
  if Map.IndexOf(Key) = -1 then
    Map.Add(Key, TIntList.Create);
  Map[Key].Add(Value);
end;

function Solve(a, b: Integer): Integer;
var
  Map: TIntIntListMap;

  function CountA(Sum, Index: Integer): Integer;
  begin
  end;

  function CountB(Sum, Index: Integer): Integer;
  begin
  end;

var
  la, lb: TIntList;
  ia, ib, i: Integer;
  Sum: TIntList;
  NewList: TIntList;
  Indices: TIntList;
  aIndices, bIndices: TIntList;

begin
  Sum := TIntList.Create; Indices := TIntList.Create;
  NewList := TIntList.Create;
  Sum.Add(0); Indices.Add(0);
  aIndices := TIntList.Create; bIndices := TIntList.Create;
  ia := 0; ib := 0;

  Map := MapCreate;
  la := Mapping[a]; lb := Mapping[b];
  while (ia < la.Count) and (ib < lb.Count) do
  begin
    if la[ia] < lb[ib] then
    begin
      aIndices.Add(Sum.Count);
      Sum.Add(Sum.Last + 1);
      Indices.Add(+1);
      InsertMap(Map, Sum.Last, aIndices.Last);
      NewList.Add(ia);
      Inc(ia);
    end
    else
    begin
      bIndices.Add(Sum.Count);
      Sum.Add(Sum.Last - 1);
      Indices.Add(-1);
      InsertMap(bMap, Sum.Last, bIndices.Last);
      NewList.Add(ib);
      Inc(ib);
    end;
  end;

  while ia < la.Count do
  begin
    aIndices.Add(Sum.Count);
    Sum.Add(Sum.Last + 1);
    Indices.Add(+1);
    Inc(ia);
  end;
  while ib < lb.Count do
  begin
    bIndices.Add(Sum.Count);
    Sum.Add(Sum.Last - 1);
    Indices.Add(-1);
    Inc(ib);
  end;

  for i := 0 to Sum.Count - 1 do
    WriteLn(i, ':', Indices[i], ':', Sum[i]);
  Write('aIndices:');
  for i := 0 to aIndices.Count - 1 do
    Write(aIndices[i], ' ');
  WriteLn;
  Write('bIndices:');
  for i := 0 to bIndices.Count - 1 do
    Write(bIndices[i], ' ');
  WriteLn;

  ia := 0; ib := 0;
  Result := 0;
  for i := 0 to Sum.Count - 1 do
  begin
    if Indices[i] = +1 then
    begin
      WriteLn('a index:', aIndices[ia], ' sum:', Sum[i]);
      WriteLn('CountA:', CountA(Sum[i], aIndices[ia]));
      WriteLn('CountB:', CountB(Sum[i], aIndices[ia]));
      Inc(Result, CountA(Sum[i], aIndices[ia]));
      Inc(Result, CountB(Sum[i], aIndices[ia]));
      Inc(ia);

    end
    else if Indices[i] = -1 then
    begin
      WriteLn('b index:', bIndices[ib], ' sum:', Sum[i]);
      WriteLn('CountA:', CountA(Sum[i], aIndices[ia]));
      WriteLn('CountB:', CountB(Sum[i], aIndices[ia]));
      Inc(Result, CountA(Sum[i], aIndices[ia]));
      Inc(Result, CountB(Sum[i], aIndices[ia]));
      Inc(ib);

    end;
  end;
   // WriteLn(i, ':', Indices[i], ':', Sum[i]);

end;

var
  i: Integer;
  a, b: Integer;

begin
  ReadData;
  PreProcess;

  for i := 1 to Q do
  begin
    ReadLn(a, b);
WriteLn('a =', a, ' b = ', b);
    WriteLn(Solve(a, b));
  end;

end.
