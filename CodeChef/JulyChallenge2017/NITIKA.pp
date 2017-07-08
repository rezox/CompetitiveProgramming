{$mode objfpc}
program Nitika;
uses
  classes;

function Solve(const S: AnsiString): AnsiString;
  function LowerCase(const S: AnsiString): AnsiString;
  var
    i: Integer;

  begin
    Result := S;
    for i := 1 to Length(S) do
      Result[i] := Chr(Ord(UpCase(S[i])) + 32);
  end;

  function UpperCase(const S: AnsiString): AnsiString;
  begin
    Result := UpCase(S[1]) + LowerCase(Copy(S, 2, Length(S)));
  end;

var
  StrList: TStringList;

begin
  StrList := TStringList.Create;
  StrList.DelimitedText := S;
  StrList.Delimiter := ' ';

  if StrList.Count = 1 then
    Result := UpperCase(StrList[0])
  else if StrList.Count = 2 then
    Result := UpCase(StrList[0][1]) + '. ' + UpperCase(StrList[1])
  else if StrList.Count = 3 then
    Result := UpCase(StrList[0][1]) + '. ' + UpCase(StrList[1][1]) + '. ' + 
      UpperCase(StrList[2]);
end;

var
  n: Integer;
  S: AnsiString;

begin
  ReadLn(n);

  while n <> 0 do
  begin
    ReadLn(S);
    WriteLn(Solve(S));

    Dec(n);
  end;
end.
