program D4B;
uses
  classes;

function CompareEQ(const S, T: AnsiString): Boolean;
var
  Count: array['a'..'z'] of Integer;
  i: Integer;
  c: Char;

begin
  if Length(S) <> Length(T) then
    Exit(False);

  FillChar(Count, SizeOf(Count), 0);
  for i := 1 to Length(S) do
    Inc(Count[S[i]]);
  for i := 1 to Length(T) do
    Dec(Count[T[i]]);
  
  for c := 'a' to 'z' do
    if Count[c] <> 0 then
      Exit(False);

  Result := True;
end;

var
  S: AnsiString;
  Words: TStringList;
  Count: Integer;
  Flag: Boolean;
  i, j: Integer;

begin
  Count := 0;
  Words := TStringList.Create; 
  while not Eof do
  begin
    ReadLn(S);

    Words.Clear;
    Words.Sorted := True;
    Words.Duplicates := dupAccept;
    Words.DelimitedText := S;
    Words.delimiter := ' ';
    Flag := True;

    for i := 0 to Words.Count - 1 do
    begin
      for j := i + 1 to Words.Count - 1 do
        if CompareEQ(Words[i], Words[j]) then
        begin
          Flag := False;
          break;
        end;
       if not Flag then
         break;
    end;
    if Flag then
      Inc(Count);
  end;
  WriteLn(Count);
end.
