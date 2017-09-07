{$mode objfpc}
program FILLMTR;
uses
  fgl;

type
  TIntList = specialize TFPGList<Integer>;
  TIntIntMap = specialize TFPGMap<Int64, Integer>;

var
  N, Q: Int64;
  Neighbors, Costs: array [0..100000] of TIntList;
  Mat: TIntIntMap;

function GetValue(a, b: Integer): Int64;
begin
  Result := a * (N + 1);
  Inc(Result, b);
end;

procedure ReadData;
var
  a, b, v: Integer;
  i: Integer;

begin
  ReadLn(N, Q);
  Mat := TIntIntMap.Create;

  for i := 1 to N do
  begin
    Neighbors[i] := TIntList.Create;
    Costs[i] := TIntList.Create;
  end;

  for i := 1 to Q do
  begin
    ReadLn(a, b, v);
    Neighbors[a].Add(b);
    Costs[a].Add(v);
    Neighbors[b].Add(a);
    Costs[b].Add(v);

    Mat.Add(GetValue(a, b), v);
    Mat.Add(GetValue(b, a), v);
  end;

end;

var
  Marked: array[0..100000] of Integer;

function Solve: Boolean;

  function IsGood(v: Integer; ID: Integer): Boolean;
  var
    m, c: Integer;
    i: Integer;

  begin
    for i := 0 to Neighbors[v].Count - 1 do
    begin
      m := Neighbors[v][i];
      c := Costs[v][i];

      if c = 0 then
      begin
        if Marked[m] <> 0 then
        begin 
          if Odd(Marked[m]) xor Odd(ID) then
begin
//WriteLn(v, ' ', ID, ' ', m, ' ', Marked[m]);
            Exit(False);
end;
          Continue;
        end;
    
        Marked[m] := ID;
        if not IsGood(m, ID) then
          Exit(False);
      end
      else
      begin
        if Marked[m] <> 0 then
        begin 
          if not (Odd(Marked[m]) xor Odd(ID)) then
            Exit(False);
          Continue;
        end;
 
        Marked[m] := ID + 1;
        if not IsGood(m, ID + 1) then
          Exit(False);
      end;
    end;
   
    Result := True;
  end;

var
  i, j: Integer;
  ID: Integer;

begin
  FillChar(Marked, SizeOf(Marked), 0);

  for i := 1 to N do
    if Marked[i] = 0 then
    begin
      ID := 1;
      if not IsGood(i, ID) then
        Exit(False);
    end;

  Result := True;
end;

var
  i: Integer;
  T: Integer;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;
    if Solve then
      WriteLn('yes')
    else
      WriteLn('no');

    
    for i := 1 to N do
    begin
      Neighbors[i].Free;
      Costs[i].Free;
    end;

    Dec(T);
  end;
end.
