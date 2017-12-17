{$mode objfpc}
program D17A;
uses
  fgl;
type
  TIntList = specialize TFPGList<Integer>;

var
  Step: Integer;
  Current: TIntList;
  Index: Integer;
  i, j: Integer;

begin
  Current := TIntList.Create;
  Current.Add(0);
  Index := 0;

  ReadLn(Step);
  for i := 1 to 2017 do
  begin
    Index := (Index + Step) mod  Current.Count;
    Current.Insert(Index + 1, i);
    //for j := 0 to Current.Count - 1 do
    //  Write(Current[j], ',');
    //WriteLn;
    if Index + 2 = Current.Count then
      WriteLn('*')
    else
      WriteLn(Current[Index + 2]);
    Index := (Index + 1) mod  Current.Count;
  end;

end.
