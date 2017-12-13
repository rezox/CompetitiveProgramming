program D12A;
uses
  fgl, Classes, SysUtils;
type
  TIntList = specialize TFPGList<Integer>;
var
  Marked: array [0..1999] of Boolean;
  Neighbors: array[0..2000] of TIntList;

procedure DFS(v: Integer);
var
  i: Integer;

begin
  if Marked[v] then
    Exit;
  Marked[v] := True;
  for i := 0 to Neighbors[v].Count - 1 do
    DFS(Neighbors[v][i]);

end;

var
  i, j: Integer;
  S: AnsiString;
  StrList: TStringList;

begin
  StrList := TStringList.Create;

  for i := 0 to 2000 do
    Neighbors[i] := TIntList.Create;
  for i := 0 to 2000 do
  begin
    ReadLn(S);
    Delete(S, 1, Pos('>', S));
 
    StrList.Clear;
    StrList.Delimiter := ',';
    StrList.DelimitedText := S;

    for j := 0 to StrList.Count - 1 do
    begin
       Neighbors[i].Add(StrToInt(Trim(StrList[j])));
       Neighbors[StrToInt(Trim(StrList[j]))].Add(i);
    end;
  end;

  FillChar(Marked, SizeOf(Marked), 0);
  j := 0;
  for i := 0 to High(Marked) do
    if not Marked[i] then
    begin
      Inc(j);
      DFS(i);
    end;
  WriteLn(j);
end.
