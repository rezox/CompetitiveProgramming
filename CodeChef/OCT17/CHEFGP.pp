{$mode objfpc}
program CHEFGP;
uses
  math, fgl;
type
  TIntList = specialize TFPGList<Integer>;
var
  s: AnsiString;
  x, y: Integer;

procedure ReadData;
begin
  ReadLn(s);
  ReadLn(x, y);
end;

function Solve: AnsiString;
var
  ABi: array [0..1] of TIntList;
  Caps: array[0..1] of Integer;
  Ni: array[0..1] of Integer;
  Ci: array[0..1] of Char;

  function SolveEQ(Current, Next, CurCount, NCount: Integer): AnsiString;
  var
    i, j: Integer;
    Sum: Integer;
    Cont: Integer;

  begin
    ABi[Current].Count := CurCount;
    ABi[Next].Count := NCount;
    for i := 0 to CurCount - 1 do
      ABi[Current][i] := 0;
    for i := 0 to NCount- 1 do
      ABi[Next][i] := 0;

    Sum := 0;
    while Sum < Ni[Current] do
    begin
      for i := 0 to ABi[Current].Count - 1 do
      begin
        ABi[Current][i] := ABi[Current][i] + 1;
        Inc(Sum);
        if Sum = Ni[Current] then
          break;
      end;
    end;

    Sum := 0;
    while Sum < Ni[Next] do
    begin
      for i := 0 to ABi[Next].Count - 1 do
      begin
        ABi[Next][i] := ABi[Next][i] + 1;
        Inc(Sum);
        if Sum = Ni[Next] then
          break;
      end;
    end;
    
Result := '';
    i := 0;
    while i < CurCount do
    begin
      Cont := 0;
      for j := 1 to ABi[Current][i] do
      begin
        if Caps[Current] = Cont then
        begin
          Result += '*';
          Cont := 0;
        end;
        Inc(Cont);
        
        Result += Ci[Current];
      end;

      Cont := 0;
      for j := 1 to ABi[Next][i] do
      begin
        if Caps[Next] = Cont then
        begin
          Result += '*';
          Cont := 0;
        end;
        Inc(Cont);

        Result += Ci[Next];
      end;
      Inc(i);
    end;
  end;

  function SolveNE(Current, Next: Integer; CurCount, NCount: Integer): AnsiString;
  var
    i, j: Integer;
    Sum: Integer;
    Cont: Integer;

  begin
    ABi[Current].Count := CurCount;
    ABi[Next].Count := NCount;
    for i := 0 to CurCount - 1 do
      ABi[Current][i] := 0;
    for i := 0 to NCount - 1 do
      ABi[Next][i] := 0;

    Sum := 0;
    while Sum < Ni[Current] do
    begin
      for i := 0 to ABi[Current].Count - 1 do
      begin
        ABi[Current][i] := ABi[Current][i] + 1;
        Inc(Sum);
        if Sum = Ni[Current] then
          break;
      end;
      if ABi[Current][0] = Caps[Current] then
        break;
    end;
    if ABi[Current].Count <> 0 then
      ABi[Current][0] := ABi[Current][0] + Ni[Current] - Sum;
    

    Sum := 0;
    while Sum < Ni[Next] do
    begin
      for i := 0 to ABi[Next].Count - 1 do
      begin
        ABi[Next][i] := ABi[Next][i] + 1;
        Inc(Sum);
        if Sum = Ni[Next] then
          break;
      end;

      if ABi[Next][0] = Caps[Next] then
        break;
    end;
    if ABi[Next].Count <> 0 then
      ABi[Next][0] := ABi[Next][0] + Ni[Next] - Sum;
    
Result := '';
    i := 0;
    while i < CurCount do
    begin
      Cont := 0;
      for j := 1 to ABi[Current][i] do
      begin
        if Caps[Current] = Cont then
        begin
          Result += '*';
          Cont := 0;
        end;
        Inc(Cont);
        Result += Ci[Current];
      end;
      if i = CurCount - 1 then break;

      Cont := 0;
      for j := 1 to ABi[Next][i] do
      begin
        if Caps[Next] = Cont then
        begin
          Result += '*';
          Cont := 0;
        end;
        Inc(Cont);
 
        Result += Ci[Next];
      end;
      Inc(i);
    end;

  end;

var
  a, b: Integer; 
  min_ab, max_ab: Integer;
  i, j: Integer;
  Sum: Integer;

begin
  Ci[0] := 'a'; Ci[1] := 'b';
  ABi[0] := TIntList.Create;
  ABi[1] := TIntList.Create;
  Caps[0] := x; Caps[1] := y;

  a := 0; b := 0;
  for i := 1 to Length(S) do
    if S[i] = 'a' then
      Inc(a)
    else if S[i] = 'b' then
      Inc(b);
 
  Ni[0] := a; Ni[1] := b;

  min_ab := Min(a, b);
  max_ab := min_ab;
  if min_ab <> Max(a, b) then
    max_ab := min_ab + 1;
  Result := '';
  if min_ab = max_ab then
    Result := SolveEQ(0, 1, min_ab, max_ab)
  else if a = min_ab then
    Result := SolveNE(1, 0, max_ab, min_ab)
  else // b = min_ab
    Result := SolveNE(0, 1, max_ab, min_ab);


  ABi[0].Free; ABi[1].Free;
end;

var
  T: Integer;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadData;
    WriteLn(Solve);
    Dec(T);
  end;

end.
