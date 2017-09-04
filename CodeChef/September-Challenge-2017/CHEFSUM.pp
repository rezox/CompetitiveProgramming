{$mode objfpc}
program CHEFSUM;
var
  N: Integer;

var
  i: Integer;
  T: Integer;
  D: Integer;
  Min, MinIndex: Integer;

begin
  ReadLn(T);
 
  while T <> 0 do
  begin
    ReadLn(N);
    Min := MaxInt;
    for i := 1 to N do
    begin
      Read(d);
      if d < Min then
      begin
        Min := d;
        MinIndex := i;
      end;
    end;

    WriteLn(MinIndex);
    Dec(T);
  end;

end.

