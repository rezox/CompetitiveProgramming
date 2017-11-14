{$mode objfpc}
program WC35A;
uses
  SysUtils, Classes;

var
  n: Integer;
  Names, Prices: TStringList;

procedure ReadData;
var
  i: Integer;
  S: AnsiString;
begin
  ReadLn(n);
  Names := TStringList.Create;
  Prices := TStringList.Create;


  for i := 1 to n do
  begin
    ReadLn(S);
 
    Names.Add(Copy(S, 1, Pos(' ', S) - 1));
    Prices.Add(Copy(S, Pos(' ', S) + 1, Length(S)));
  end;

end;

function Solve: AnsiString;
  function IsValid(const S: AnsiString): Boolean;
  var
    i: Integer;
    N4, N7: Integer;
  begin
    Result := True;
    N4 := 0; N7 := 0;
    for i := 1 to Length(S) do
    begin
      if (S[i] <> '4') and (S[i] <> '7') then
        Exit(False);
      if S[i] = '4' then
        Inc(N4)
      else
        Inc(N7);
    end;
    Result := N4 = N7;
  end;

var
  i: Integer;
  MinIndex, MinPrice: Integer;
begin
  MinPrice := 999999999;
  MinIndex := -1;

  for i := 0 to Names.Count - 1 do
    if IsValid(Prices[i]) and (StrToInt(Prices[i]) < MinPrice) then
    begin
      MinIndex := i;
      MinPrice := StrToInt(Prices[i]);
    end;
  if MinIndex = -1 then
    Exit('-1');
  Result := Names[MinIndex];
end;

begin
  ReadData;
  WriteLn(Solve);
end.
