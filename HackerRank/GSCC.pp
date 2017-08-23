program GSCC;
{$mode objfpc}
uses
  Math;

var
  k: Integer;
  n: Integer;
  Prices: array[0..30] of Integer;
  Inf: Integer;

procedure ReadData;
var
  i: Integer;

begin
  ReadLn(k);
  Read(n);
  for i := 1 to n do
    Read(Prices[i]);
  ReadLn;
end;

//type
//  TLastStatus = (lsBuy = 0, lsSell = 1);
const
  lsBuy = 0;
  lsSell = 1;

var
  DP: array [0..30, -1..30, 0..1] of Integer;
// DP[DayIndex, BayCount, LastAction]

function Min(a, b, c: Integer): Integer;
begin
  Result := Math.Min(a, Math.Min(b, c));
end;

function Max(a, b, c: Integer): Integer;
begin
  Result := Math.Max(a, Math.Max(b, c));
end;


function GetValue(DayIndex, BCount, LastAction, Addition: Integer): Integer;
begin
  if BCount < 0 then
    Exit(-Inf);
  if DP[DayIndex, BCount, LastAction] = -Inf then
    Exit(-Inf);
  Result := DP[DayIndex, BCount, LastAction] + Addition;
{
  if (DayIndex = 0) and ((Buy <> 0) or (Sell <> 0)) then
    Exit(-Inf);
  if (DayIndex = 0) and ((Buy = 0) or (Sell = 0)) then
    Exit(0 + Addition);
  Result := -Inf;
  if (Buy < 0) or (Sell < 0) or (Buy < Sell) then
  begin
 //   WriteLn('Exiting Result:', Result);
    Exit;
  end;
  if Sell + 1 < Buy then
    Exit;

  if DP[DayIndex, Buy, Sell] = -Inf then
  begin
    //WriteLn('Inf Exiting Result:', Result);
    Exit;
  end;

  Result := DP[DayIndex, Buy, Sell] + Addition;
  //WriteLn('Result:', Result);
}
end;

function Solve: Integer;
var
  i, Buy: Integer;
  LastAction: Integer;

begin
  for i := 0 to n do
    for Buy := 0 to 30 do
      for LastAction := 0 to 1 do
        DP[i, Buy, LastAction] := -Inf;
  DP[0, 0, lsSell] := 0;

  for i := 1 to n do
  begin
    for Buy := 0 to i do
    begin
      // Buy
      DP[i, Buy, lsBuy] := Math.Max(
        GetValue(i - 1, Buy, lsBuy, 0),
        GetValue(i - 1, Buy - 1, lsSell, - Prices[i])
      );
      //WriteLn(i, ' B:', Buy, ' lsBuy ,_.', DP[i, Buy, lsBuy]);
      // Sell
      DP[i, Buy, lsSell] := Math.Max(
        GetValue(i - 1, Buy, lsSell, 0),
        GetValue(i - 1, Buy, lsBuy, + Prices[i])
      );
     //WriteLn(i, ' B:', Buy, ' lsSell <->', DP[i, Buy, lsSell]);
    end;
  end;
  
 
  Result := DP[n, k, lsSell];
  for i := k downto 0 do
    if Result < DP[n, i, lsSell] then
      Result := DP[n, i, lsSell];

end;

var
  q: Integer;

begin
  FillChar(Inf, SizeOf(Inf), 127);
  ReadLn(q);

  while q <> 0 do
  begin
    ReadData;
    WriteLn(Solve);

    Dec(q);
  end;

end.
