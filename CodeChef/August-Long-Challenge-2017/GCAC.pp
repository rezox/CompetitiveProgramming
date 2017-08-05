{$mode objfpc}
program GCAC;
uses
  fgl;

type
  TIntList = specialize TFPGList<Int64>;

var
  SCount, JCount: Integer;
  MinSalary, OfferedSalary, MaxJobOffers: TIntList;
  Qual: array[0..1000, 0..1000] of Boolean;

procedure ReadData;
var
  i, j: Integer;
  x, y: Int64;
  S: AnsiString;

begin
  ReadLn(SCount, JCount);
  MinSalary := TIntList.Create; OfferedSalary := TIntList.Create; MaxJobOffers := TIntList.Create;

  MinSalary.Add(-1);
  for i := 1 to SCount do
  begin
    Read(x); 
    MinSalary.Add(x);
  end;
  ReadLn;
  OfferedSalary.Add(-1);
  MaxJobOffers.Add(-1);
  for j := 1 to JCount do
  begin
    ReadLn(x, y); 
    OfferedSalary.Add(x);
    MaxJobOffers.Add(y);
  end;

  for i := 1 to SCount do
  begin
    ReadLn(S);
    for j := 1 to JCount do
      Qual[i, j] := S[j] = '1';
  end;
end;

procedure Sort(l,r: longint; Salary, Indices: TIntList);
var
   i,j,x,y: Int64;
begin
  i:=l;
  j:=r;
  x:= Salary[Indices[(l+r) div 2]];
  repeat
    while Salary[Indices[i]]<x do
     inc(i);
    while x<Salary[Indices[j]] do
     dec(j);
    if not(i>j) then
      begin
         y:=Indices[i];
         Indices[i]:=Indices[j];
         Indices[j]:=y;
         Inc(i);
         Dec(j);
      end;
  until j < i;
  if l < j then
    Sort(l, j, Salary, Indices);
  if i < r then
    Sort(i, r, Salary, Indices);
end;


procedure Solve;
var
  i, j: Integer;
  JIndices, Cap: TIntList;
  Last: Integer;
  Hired: Integer;
  TotalSalary: Int64;
  WontHire: Integer;
begin
  JIndices := TIntList.Create; Cap := TIntList.Create;
  for i := 0 to OfferedSalary.Count - 1 do
  begin
    JIndices.Add(i);
    Cap.Add(MaxJobOffers[i]);
  end;
  Sort(1, OfferedSalary.Count - 1, OfferedSalary, JIndices);

{
  for i := 1 to OfferedSalary.Count - 1 do
    WriteLn(OfferedSalary[i]);
  WriteLn;
  for i := 1 to OfferedSalary.Count - 1 do
    WriteLn(JIndices[i], ':', OfferedSalary[JIndices[i]]);
}

  Hired := 0;
  TotalSalary := 0;
  Last := JIndices.Count - 1;
  for i := 1 to SCount do
  begin
    for j := Last downto 1 do
    begin
      if OfferedSalary[JIndices[j]] < MinSalary[i] then
        Break;
      if Qual[i, JIndices[j]] and (0 < Cap[JIndices[j]]) then
      begin
//        WriteLn(i, ' -> ', JIndices[j]);
        Inc(Hired);
        Inc(TotalSalary, OfferedSalary[JIndices[j]]);
        Cap[JIndices[j]] := Cap[JIndices[j]] - 1;
        break;
      end;
    end;
      if Cap[JIndices[Last]] = 0 then 
        Dec(Last);
  end;
  WontHire := 0;
  for j := 1 to JCount do 
    if MaxJobOffers[j] = Cap[j] then
      Inc(WontHire);
  WriteLn(Hired, ' ', TotalSalary, ' ', WontHire);

end;

var
  T: Integer;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;
    Solve;

    Dec(T);
  end;
end.
