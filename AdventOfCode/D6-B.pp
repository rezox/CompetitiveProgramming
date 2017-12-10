{$mode objfpc}
program D6B;
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
  Map, AllBanks: TStringList;
  Last: AnsiString;
  i, Index: Integer;

begin
  Banks := ReadData;
  Map := TStringList.Create;
  AllBanks := TStringList.Create;
  Map.Sorted := True;
  Map.Add(Banks.ToString);
  AllBanks.Add(Banks.ToString);
 
  Banks.Rotate;
  //WriteLn(Banks.ToString);
  while Map.IndexOf(Banks.ToString) < 0 do
  begin
    Map.Add(Banks.ToString);
    AllBanks.Add(Banks.ToString);
    Banks.Rotate;
    //WriteLn(Banks.ToString);
  end;
  Last := Banks.ToString;
  Index := -1;
  for i := AllBanks.Count - 1 downto 0 do
    if AllBanks[i] = Last then
    begin
      Index := i;
      break;
    end;
  WriteLn(Map.Count, ' ', Index, ' ', Map.Count - Index);
 end.
