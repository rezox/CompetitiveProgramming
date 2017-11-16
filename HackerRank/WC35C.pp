{$mode objfpc}
program WC35C;
uses
  fgl;
var
  H, W: Integer;
  Aij: array[0..100, 0..100] of Integer;

procedure ReadData;
var
  r, c: Integer;

begin
  ReadLn(H, W);

  for r := 1 to H do
    for c := 1 to W do
      Read(Aij[r, c]);
end;

type
  TIntIntMap = specialize TFPGMap<Int64, Integer>;

function Solve: Int64;
var
  data: TIntIntMap;

  procedure AddSurface(x, y, z, dx, dy, dz: Integer);
  var
    v, dv: Integer;
  begin
    v := 10000 * (x - 1) + 100 * (y - 1) + (z - 1);
    dv := 4 * dx + 2 * dy + dz;
    if data.IndexOf(8 * v + dv) = -1 then
      data.Add(8 * v + dv, 1)
    else
      data[8 * v + dv] := data[8 * v + dv] + 1;
  end;

var
  r, c, z: Integer;

begin
  data := TIntIntMap.Create;
  data.Sorted := True;

  Result := 0;
  for r := 1 to H do
    for c := 1 to W do
      for z := 1 to Aij[r, c] do
      begin
        AddSurface(r, c, z, +1, +1, 0);
        AddSurface(r, c, z, +1, 0, +1);
        AddSurface(r, c, z, 0, +1, +1);
        AddSurface(r, c + 1, z, +1, 0, +1);
        AddSurface(r + 1, c, z, +1, 0, +1);
        AddSurface(r + 1, c , z);
        AddSurface(r - 1, c - 1, z);
        AddSurface(r - 1, c, z);
        AddSurface(r - 1, c, z);
      end;

end;

begin
  FillChar(Aij, SizeOf(Aij), 0);
  ReadData;

  WriteLn(Solve);
end.
