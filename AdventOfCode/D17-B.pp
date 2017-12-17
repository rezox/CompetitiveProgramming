{$mode objfpc}
program D17B;
uses
  fgl;
type
  TIntList = specialize TFPGList<Integer>;
const
  Step: Integer = 386;

var
  Index: Integer;
  i, j: Integer;
  Len: Integer;
  Last1: Integer;

begin
  Index := 0;
  ReadLn(Len);

  Last1 := 1;
  for i := 1 to Len do
  begin
    Index := (Index + Step) mod  i;
    if Index = 0 then
      Last1 := i;
   
  //  WriteLn(i, ':', Last1, ' ', Index);
    Index := (Index + 1) mod  (i + 1);
  end;
  WriteLn(Last1);

end.
