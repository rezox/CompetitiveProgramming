{$mode objfpc}
program D2B;
uses
  fgl;
type 
  TIntList = specialize TFPGList<Integer>;

var
  i, j: Integer;
  n: Int64;
  Line: TIntList;
  Sum: Int64;

begin
  Sum := 0;
  while not Eof do
  begin
    Line := TIntList.Create;

    while not Eoln do
    begin
      Read(n);
      Line.Add(n);
Write(n, ' ');
    end;
    ReadLn;
WriteLn;
    for i := 0 to Line.Count - 1 do
      for j := 0 to Line.Count - 1 do
        if (Line[i] mod Line[j] = 0) and (i <> j) then
        begin
          WriteLn(Line[i], ' ', Line[j]);
          Inc(Sum, Line[i] div Line[j]);
        end;
    Line.Free;
  end;
  WriteLn(Sum);
 
end.
