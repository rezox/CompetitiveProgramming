program D13A;
uses
  fgl, SysUtils;
type
  TIntList = TFPGList<Integer>;

var
  Depth, Range: TIntList;

function Compute(Pos: Integer): Integer;
  function GetPos(t: Integer; Range: Integer): Integer;
  var
    i: Integer;
    Sign: Integer;
  begin
    Result := 0;
    Sign := +1;
    
    for i := 1 to t do
    begin
      Inc(Result, Sign);
      if Result = Range - 1 then
        Sign := -Sign;
     if Result = 0 then
       Sign := -Sign;
    end;
  end;
{
20:8
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
0 1 2 3 4 5 6 7 6 5  4  3  2  1  0  1  2  3  4  5  6
}
var
  i, t: Integer;

begin
  Result := 0;

  for i := 0 to Depth.Count - 1 do
  begin
    t := Depth[i];
    WriteLn(t, ' ', Range[i], ':', GetPos(t,  Range[i]));
    
    if GetPos(t,  Range[i]) = pos then
    begin
      WriteLn('*', i, ' -> ', t);
      Inc(Result, Depth[i] * Range[i]);
    end;
  
  end;

end;

var
  d, r: Integer;
  S: AnsiString;
  i: Integer;

begin
  Depth := TIntList.Create;
  Range := TIntList.Create;

  while not EOF do
  begin
    ReadLn(S);
    d := StrToInt(Copy(S, 1, Pos(':', S) - 1));
    Delete(S, 1, Pos(':', S));
    r := StrToInt(S);
    Depth.Add(d);
    Range.Add(r);
  end;

  WriteLn(Compute(0));
end.
