{$mode objfpc}
program MEX;
uses
  fgl;
type
  TIntList = specialize TFPGList<Integer>;
var
  Numbers: TIntList;
  N, K: Integer;

procedure ReadData;
var
  i, j: Integer;
  x: Integer;

begin
  Numbers.Free;

  Numbers := TIntList.Create;

  ReadLn(N, K);
  for i := 1 to N do
  begin
    Read(x);
    Numbers.Add(x);
  end;
end;

function Compare(const n1, n2: Integer): Integer;
begin
  Result := n1 - n2;
end;

function Solve: Integer;
var
  i: Integer;

begin
  Numbers.Sort(@Compare);

  Result := 0;
  i := 0;

  while i < Numbers.Count do
  begin
    if Numbers[i] < Result then
    begin
      Inc(i);
      continue;
    end;
    if Numbers[i] = Result then
    begin
      Inc(Result);
      Inc(i);
    end
    else
    begin
      if k = 0 then
        Exit;
      Inc(Result);
      Dec(k);
    end;
  end;

  while k <> 0 do
  begin
    Dec(k);
    Inc(Result);
  end;
end;

var
  T: Integer;

begin
  Numbers := nil;
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;
    WriteLn(Solve);

    Dec(T);
  end;

end.
