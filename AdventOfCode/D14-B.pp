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
  tmp: TIntList;
  i, j: Integer;

begin
  Length := ReadData; 
  tmp := Solve(Length);
  Result := TIntList.Create;

  for i := 0 to tmp.Count - 1 do
    for j := 7 downto 0 do
      Result.Add(((tmp[i] shr j) and 1));
  tmp.Free;
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
  Hashes: array [0..128] of TIntList;

function CountComps: Integer;
var
  Marked: array[0..128, 0..1024] of Integer;
  Queue: array[0..128 * 1024] of Integer;
  FoQ, EoQ: Integer;

  procedure Insert(v: Integer);
  begin
    Queue[EoQ] := v;
    Inc(EoQ);
  end;

  function IsEmpty: Boolean;
  begin
    Result := FoQ = EoQ;
  end;
  
  function Delete: Integer;
  begin
    Result := Queue[FoQ];
    Inc(FoQ);
  end;
const
  IncX: array [0..3] of Integer = (  0,  0, +1, -1);
  IncY: array [0..3] of Integer = ( +1, -1,  0,  0);

  procedure DFS(x, y: Integer; CompIndex: Integer);
  var
    i: Integer;
  begin
    if (x < 0) or (x >= 128) then
      Exit;
    if (y < 0) or (y >= Hashes[x].Count) then
      Exit;
    if Hashes[x][y] <> 1 then
      Exit;
    if Marked[x, y] <> 0 then
      Exit;
    Marked[x, y] := CompIndex;

    for i := 0 to 3 do
      DFS(x + IncX[i], y + IncY[i], CompIndex);
  end;

var
  i, j: Integer;

begin
  FillChar(Marked, SIzeOF(Marked), 0);
  FoQ := 0; EoQ := 0;
  Result := 0;
  for i := 0 to 127 do
    for j := 0 to Hashes[i].Count - 1 do
      if (Marked[i, j] = 0) and (Hashes[i][j] = 1) then
      begin
WriteLn(i, ':', j, ':', Result);
        Inc(Result);
        DFS(i, j, Result);
      end;
end;

var
  S: AnsiString;
  i, j: Integer;
  Total: Integer;

begin
  ReadLn(S);
  Total := 0;
  for i := 0 to 127 do
    Hashes[i] := KnotHash(S + '-' + IntToStr(i));
  for i := 0 to 127 do
  begin
    for j := 0 to Hashes[i].Count - 1 do
      Write(Hashes[i][j]);
    WriteLn;
  end;
  WriteLn(CountComps);
end.
