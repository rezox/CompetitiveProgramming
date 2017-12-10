program D6A;
{$mode objfpc}
uses
  fgl, Classes, SysUtils;
type
  TIntList = class(specialize TFPGList<Integer>)
  public
    function ToString: AnsiString;
    function Rotate: TIntList;
  end;

function TIntList.ToString: AnsiString;
var
  i: Integer;

begin
  Result := '';

  for i := 0 to Count - 1 do
    Result := Result + '-' + IntToStr(Items[i]);
end;

function TIntList.Rotate: TIntList;
var
  i: Integer;
  MaxIndex: Integer;
  MaxVal: Integer;

begin
  MaxIndex := 0;
  
  for i := 0 to Count - 1 do
    if Items[MaxIndex] < Items[i] then
      MaxIndex := i;

  MaxVal := Items[MaxIndex];
  Items[MaxIndex] := 0;

  for i := 1 to MaxVal do
    Items[(MaxIndex + i) mod Count] := Items[(MaxIndex + i) mod Count] + 1;
  Result := Self;
end;

function ReadData: TIntList;
var
  x: Integer;

begin
  Result := TIntList.Create;

  while not Eof(Input) do
  begin
    ReadLn(x);
    Result.Add(x);
  end;
  WriteLn(Result.ToString);
end;

var
  Banks: TIntList;
  Map: TStringList;

begin
  Banks := ReadData;
  Map := TStringList.Create;
  Map.Sorted := True;
  Map.Add(Banks.ToString);
 
  Banks.Rotate;
  while Map.IndexOf(Banks.ToString) < 0 do
  begin
    Map.Add(Banks.ToString);
    Banks.Rotate;
  end;
  WriteLn(Map.Count);
 end.
