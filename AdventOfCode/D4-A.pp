program D4A;
uses
  classes;
var
  S: AnsiString;
  Words: TStringList;
  Count: Integer;
  i: Integer;

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

    for i := 0 to Words.Count - 2 do
    begin
      if Words[i] = Words[i + 1] then
      begin
        Dec(Count);
        break;
      end;
    end;
    Inc(Count);
  end;
  WriteLn(Count);
end.
