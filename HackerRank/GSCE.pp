{$mode objfpc}
program GSCE;
uses
  Math, SysUtils, Classes;

const
  Modulo = 1000000007;
  Lns : array [1..10] of Extended = (ln(1), ln(2), ln(3), ln(4), ln(5), ln(6), ln(7), ln(8), ln(9), ln(10));

type
  TNumber = array[0..10] of Integer;
  TMat = array[0..20, 0..20] of TNumber;

var
  n: Integer;
  x, s, f, m: Integer;
  Ai: TMat;

procedure ReadData;
var
  i, j, a: Integer;
begin
  FillChar(Ai, SizeOf(Ai), 0);
  ReadLn(n);

  ReadLn(x, s, f, m);
  Inc(s); Inc(f);
  for i := 1 to n do
  begin
    for j := 1 to n do
    begin
      Read(a);
      if a = 0 then
        Continue;
      Ai[i, j][1] := 1;
      while a <> 1 do
      begin
        if a mod 2 = 0 then
        begin
          Inc(Ai[i, j][2]);
          a := a div 2;
        end
        else if a mod 3 = 0 then
        begin
          Inc(Ai[i, j][3]);
          a := a div 3;
        end
        else if a mod 5 = 0 then
        begin
          Inc(Ai[i, j][5]);
          a := a div 5;
        end
        else if a mod 7 = 0 then
        begin
          Inc(Ai[i, j][7]);
          a := a div 7;
        end;
      end;
    end;
     ReadLn;
  end;
end;

procedure Print(const n: TNumber; const Caption: AnsiString);
var
  i: Integer;
  Flag: Boolean;
begin
  Flag := False;
  for i := 1 to 10 do
    if n[i] <> 0 then
      Flag := True;
  if not Flag then
    Exit;
  WriteLn(Caption);
  for i := 1 to 10 do
    if n[i] <> 0 then
      Write(i, ':', n[i], ' ');
  WriteLn;
end;

procedure Print(Mat: TMat);
var
  i, j: Integer;

begin
  for i := 1 to N do
    for j := 1 to N do
    begin
      Print(Mat[i, j], 'Mat[' + IntToStr(i) + ',' + IntToStr(j) + ']');
    end;
end;

function Solve: Integer;

  function Mul(const n1, n2: TNumber): TNumber;
  var
    i: Integer;

  begin
    for i := 2 to 7 do
       Result[i] := n1[i] + n2[i];
  end;

  function IsLessthan(const n1, n2: TNumber): Boolean;
  var
    i: Integer;
    Value: Extended;
  begin
    Value := 0;
    Value := Value + Lns[2] * (n1[2] - n2[2]);
    Value := Value + Lns[3] * (n1[3] - n2[3]);
    Value := Value + Lns[5] * (n1[5] - n2[5]);
    Value := Value + Lns[7] * (n1[7] - n2[7]);
    Result := Value < 0;  
  end;

  function RecSolve(m: Integer): TMat;
  var
    i, j, k: Integer;
    Tmp1, Tmp2: TMat;

  begin
    if m = 0 then
    begin
      m := 1 div m;
      Exit;
    end;
    if m = 1 then
      Exit(Ai);

    Tmp1 := RecSolve(m div 2);
    Tmp2 := Tmp1;
    FillChar(Result, SizeOf(Result), 0);
    for i := 1 to N do
      for j := 1 to N do
        for k := 1 to N do
          if IsLessthan(Result[i, j], Mul(Tmp1[i, k], Tmp2[k, j])) then
          begin
             Result[i, j] := Mul(Tmp1[i, k], Tmp2[k, j]);
          end;

    if not Odd(m) then
      Exit;
    Tmp1 := Result;
    Tmp2 := Ai;
    FillChar(Result, SizeOf(Result), 0);
    for i := 1 to N do
      for j := 1 to N do
        for k := 1 to N do
          if IsLessthan(Result[i, j], Mul(Tmp1[i, k], Tmp2[k, j])) then
          begin
             Result[i, j] := Mul(Tmp1[i, k], Tmp2[k, j]);
          end;

  end;
var
  Mat: TMat;
  i, j: Integer;

begin
  FillChar(Mat, SizeOf(Mat), 0);
  Mat := RecSolve(m);

  Result := x;
  for i := 1 to 10 do
    for j := 1 to Mat[s, f][i] do
      Result := (Result * i) mod Modulo;

end;

begin
  ReadData;
  WriteLn(Solve);
end.
