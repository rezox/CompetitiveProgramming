{$mode objfpc}
program D16A;
uses
  classes, SysUtils, fgl;

function ReadData: TStringList;
var
  Line: AnsiString;

begin
  ReadLn(Line);

  Result := TStringList.Create;
  Result.Delimiter := ',';
  Result.DelimitedText := Line;

end;

type
  TStringIntMap = specialize TFPGMap<AnsiString, Integer>;

var
  Commands: TStringList;

procedure Solve;
var
  WordIndex: TStringIntMap;
  Current: AnsiString;

  function Compute: AnsiString;
  
    procedure Spin(const Command: AnsiString);
    var
      tmp: AnsiString;
      Value: Integer;
      i: Integer;
  
    begin
      Value := StrToInt(Copy(Command, 2, Length(Command)));
  
      tmp := Copy(Current, Length(Current) - Value + 1, Value);
      Delete(Current, Length(Current) - Value + 1, Value);
     
      Current := tmp + Current;
    end;
  
    procedure Exchange(const Command: AnsiString);
    var
      i1, i2: Integer;
      tmp: Char;
    begin
      i1 := StrToInt(Copy(Command, 2, Pos('/', Command) - 2)) + 1;
      i2 := StrToInt(Copy(Command, Pos('/', Command) + 1, Length(Command))) + 1;
      
      tmp := Current[i1];
      Current[i1] := Current[i2];
      Current[i2] := tmp;
    end;
  
    procedure Partner(const Command: AnsiString);
    var
      i: Integer;
      i1, i2: Integer;
      c1, c2: Char;
      tmp: Char;
  
    begin
      c1 := Copy(Command, 2, Pos('/', Command) - 2)[1];
      c2 := Copy(Command, Pos('/', Command) + 1, Length(Command))[1];
  
      for i := 1 to Length(Current) do
        if Current[i] = c1 then
          i1 := i
        else if Current[i] = c2 then
          i2 := i;
  
      tmp := Current[i1];
      Current[i1] := Current[i2];
      Current[i2] := tmp;
   
    end;
  
  var
    i: Integer;
  
  begin
 
    for i := 0 to Commands.Count - 1 do
    begin
      if Commands[i][1] = 's' then
        Spin(Commands[i])
      else if Commands[i][1] = 'x' then
        Exchange(Commands[i])
      else if Commands[i][1] = 'p' then
        Partner(Commands[i]);
      //WriteLn(Current);
    end;
    Result := Current;
  end;

const
  Target: Integer = 1000000000;

var
  Ch: Char;
  i, Index: Integer;
  CycleLen: Integer;
  
begin
  Current := '';
  for Ch := 'a' to 'p' do
    Current := Current + Ch;
 
  WordIndex := TStringIntMap.Create;
  WordIndex.Sorted := True;
  WordIndex.Add(Current, 0);

  for i := 1 to Target do
  begin
    Compute;
    if WordIndex.TryGetData(Current, Index) then
    begin
      CycleLen := i - Index;
      break;
     end;
     WordIndex.Add(Current, i);
  end;
  WriteLn(i, ' -> ', Index);

  Current := '';
  for Ch := 'a' to 'p' do
    Current := Current + Ch;
 
  for i := 1 to Target mod CycleLen do
  begin
    Compute;
  end;
  WriteLn(Current);
end;

begin
  Commands := ReadData;
  Solve;
end.
