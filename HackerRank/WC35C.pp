{$mode objfpc}
program WC35C;
uses
  fgl, math, SysUtils, Strings, classes;
var
  H, W: Integer;
  Aij: array[0..100, 0..100] of Integer;

procedure ReadData;
var
  r, c: Integer;

begin
  ReadLn(H, W);

  for r := 1 to H do
  begin
    for c := 1 to W do
      Read(Aij[r, c]);
    ReadLn;
  end;
Exit;
  H := 100;
  W := H;
  //H := 100; W := 100;
  for r := 1 to H do
    for c := 1 to W do
      Aij[r, c] := 100;
end;

type
  TIntList = specialize TFPGList<uInt64>;

function Compare(const a, b: uInt64): Integer;
begin
  if a < b then
    Result := -1
  else if b < a then
    Result := +1
  else
    Result := 0;
end;

var
  StrTable : array [0..1000] of AnsiString;

function Solve: uInt64;
var
 // data_list: array[0..200, 0..200] of TStringList;
  data_list: array[0..200, 0..200] of TIntList;

//  function Encode(x, y, z, dx, dy, dz: Int64): AnsiString;
//  begin
//    Result := StrTable[x] + '*' + StrTable[y] + '*' + StrTable[z] + '*' + StrTable[dx] + '*' + StrTable[dy] + '*' + StrTable[dz];
//  end;
//
  function Encode(x, y, z, dx, dy, dz: Int64): Int64;
  begin
    //Result := '*' + StrTable[z] + '*' + StrTable[dx] + '*' + StrTable[dy] + '*' + StrTable[dz];
    Result := z * 8 + dx * 4 + dy * 2 + dz;
    //Result := z + 200 * y + 40000 * x;
  end;


  procedure AddSurfaceList(x, y, z, dx, dy, dz: Int64);
  var
    v: Int64;
  begin
    // v := Encode(x, y, z, dx, dy, dz);
    v := Encode(x, y, z, dx, dy, dz);
    data_list[x, y].Add(v);
  end;

var
  r, c, z: Integer;
  i, LastIndex: Integer;
  Last: Int64;
  active_data: TIntList;

begin
  //WriteLn(Encode(100, 100, 100, 1, 1, 0));
  //data := TIntIntMap.Create;
  //data.Sorted := True;
  for r := 0 to H + 1 do
    for c := 0 to W + 1 do
      data_list[r, c] := TIntList.Create;

  for r := 1 to H do
    for c := 1 to W do
      for z := 1 to Aij[r, c] do
      begin
        AddSurfaceList(r, c, z, +1, +1, 0);
        AddSurfaceList(r, c, z, +1, 0, +1);
        AddSurfaceList(r, c, z, 0, +1, +1);
        AddSurfaceList(r, c, z + 1, +1, +1, 0);
        AddSurfaceList(r, c + 1, z, +1, 0, +1);
        AddSurfaceList(r + 1, c, z, 0, +1, +1);
      end;


  Result := 0;

  for r := 0 to H + 1 do
    for c := 0 to W + 1 do
     begin
       active_data := data_list[r, c];
         if active_data.Count = 0 then
           continue;
         active_data.Sort(@Compare);
         LastIndex := 0;
  
         Last := active_data[0];
  //Writ eLn('Result:', r, c, ' cur:', last);
         i := 0;
         //WriteLn('active_data.Count:', active_.Count);
         for i := 1 to active_data.Count - 1 do
         begin
  //WriteLn('Result:', r, c, ' cur:', active_data[i]);
  //WriteLn('Result:', Result, ' Last:', Last, ' cur:', active_data[i]);
         if active_data[i] <> Last then
         begin
           if LastIndex + 1 = i then
             Inc(Result);
  
           LastIndex := i;
           Last := active_data[LastIndex];
         end;
       end;
       if LastIndex + 1 = active_data.Count then
         Inc(Result);
      end;
end;

var
  i: Integer;

begin
  for i := 0 to High(StrTable) do
    StrTable[i] := IntToStr(i);

  FillChar(Aij, SizeOf(Aij), 0);
  ReadData;

  WriteLn(Solve);
end.
