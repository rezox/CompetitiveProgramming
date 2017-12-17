{$mode objfpc}
program D14A;
uses
  fgl, SysUtils;
type
  TIntList = specialize TFPGList<Integer>;

function KnotHash(const S: AnsiString): TIntList;

  function ReadData: TIntList;
  var
    i: Integer;
  
  begin
    Result := TIntList.Create;
    for i := 1 to Length(S) do
      Result.Add(Ord(S[i]));
    Result.Add(17);
    Result.Add(31);
    Result.Add(73);
    Result.Add(47);
    Result.Add(23);
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
    // WriteLn('a:', a, ' b:', b);
    Data[a] := Data[a] xor Data[b];
    Data[b] := Data[a] xor Data[b];
    Data[a] := Data[a] xor Data[b];
  end;
  
 
  function Solve(Length: TIntList): TIntList;
  const
    Mapping: array[0..15] of String = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
  var
    Data: TIntList;
  var
    Current, Skip: Integer;
    i, j, k: Integer;
  
  begin
    Data := TIntList.Create;
    Data.Count := 256;
    for i := 0 to Data.Count - 1 do
      Data[i] := i;
  
    Current := 0;
    Skip := 0;
    for k := 1 to 64 do
      for i := 0 to Length.Count - 1 do
      begin
        //WriteLn('i:', i, ' Length:', Length[i]);
        //WriteLn('Current:', Current, ' Skip:', Skip);
  
        //Print(Data);
  
          for j := 0 to (Length[i] - 1) div 2 do
            Swap(Data, Current + j, (Length[i] + Current - 1) - j);
  
        //Print(Data);
        Current := Current + Skip + Length[i];
        Inc(Skip);
      end;
    Result := TIntList.Create;
    for i := 0 to 15 do
    begin
      Current := 0;
      for j := 0 to 15 do
        Current := Current xor Data[16 * i + j];
      Result.Add(Current);
    end;
  end;
 
var
  Length: TIntList;

begin
  Length := ReadData; 
  Result := Solve(Length);
  Length.Free;
end;  

function Count(Data: TIntList): Integer;
var
  i, j: Integer;

begin
  Result := 0;
  for i := 0 to Data.Count - 1 do
  begin
    for j := 0 to 7 do
       if (Data[i] and (1 shl j)) <> 0 then
       begin
Write('1');
         Inc(Result)
       end
       else
Write('0');
  end;
end;
 
var
  S: AnsiString;
  i: Integer;
  Hash: TIntList;
  Total: Integer;

begin
  ReadLn(S);
  Total := 0;
  for i := 0 to 127 do
  begin
    Hash := KnotHash(S + '-' + IntToStr(i));
    Inc(Total, Count(Hash));
WriteLn;
  end;
  WriteLn(Total);
end.
