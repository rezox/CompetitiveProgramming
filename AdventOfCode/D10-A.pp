{$mode objfpc}
program D10A;
uses
  SysUtils, fgl, classes;
type
  TIntList = specialize TFPGList<Integer>;

function ReadData: TIntList;
var
  S: AnsiString;
  StrList: TStringList;
  i: Integer;

begin
  StrList := TStringList.Create;
  StrList.Delimiter := ',';

  ReadLn(S);
  StrList.DelimitedText := S;

  Result := TIntList.Create;
  for i := 0 to StrList.Count - 1 do
    Result.Add(StrToInt(StrList[i]));
end;

procedure Swap(Data: TIntList; a, b: Integer);
begin
  a:= (a + Data.Count) mod Data.Count;
  b:= (b + Data.Count) mod Data.Count;
  while a < 0 do
    a:= (a + Data.Count) mod Data.Count;
  while b < 0 do
    b:= (b + Data.Count) mod Data.Count;
  if a = b then
    Exit;
  WriteLn('a:', a, ' b:', b);
  Data[a] := Data[a] xor Data[b];
  Data[b] := Data[a] xor Data[b];
  Data[a] := Data[a] xor Data[b];
end;

procedure Print(Data: TIntList);
var
  i: Integer;

begin
  for i := 0 to Data.Count - 1 do
    Write(Data[i], ' ');
  WriteLn;
end;

function Solve(Length: TIntList): Integer;
var
  Data: TIntList;
var
  Current, Skip: Integer;
  i, j: Integer;

begin
  Data := TIntList.Create;
  Data.Count := 256;
  for i := 0 to Data.Count - 1 do
    Data[i] := i;

  Current := 0;
  Skip := 0;
  for i := 0 to Length.Count - 1 do
  begin
    WriteLn('i:', i, ' Length:', Length[i]);
    WriteLn('Current:', Current, ' Skip:', Skip);
    Print(Data);
    for j := 0 to (Length[i] - 1) div 2 do
      Swap(Data, Current + j, (Length[i] + Current - 1) - j);
    Print(Data);
    Current := Current + Skip + Length[i];
    Inc(Skip);
  end;
 
  Result := Data[0] * Data[1];
end;

var
  Index: Integer;
  Length: TIntList;
  i: Integer;

begin
  Length := ReadData; 
  WriteLn(Solve(Length));
  Length.Free;
  
end.
