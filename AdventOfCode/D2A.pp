program D2A;
var
  n, Min, Max: Int64;
  Sum: Int64;

begin
  Sum := 0;
  while not Eof do
  begin
    Min := MaxInt;
    Max := -1;

    while not Eoln do
    begin
      Read(n);
      if Max < n then
        Max := n;
      if n < Min then
        Min := n;
    end;
    ReadLn;
    WriteLn(Min, ':', Max);
    Inc(Sum, Max - Min);
  end;
  WriteLn(Sum);
 
end.
