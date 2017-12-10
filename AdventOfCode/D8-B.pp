{$mode objfpc}
program D8A;
uses
  fgl, Classes, SysUtils;
type
  TRegisterMap = specialize TFPGMap<AnsiString, Integer>;

function GetOrDefault(const Map: TRegisterMap; Name: AnsiString; DefaultValue: Integer): Integer;
var
  Index: Integer;
begin
  if not Map.Find(Name, Index) then
    Exit(DefaultValue);
  Result := Map.Data[Index];

end;

function RunCommand(const Command: TStringList; RegisterMap: TRegisterMap): Integer;
var
  Target, Source: AnsiString;
  Operation: AnsiString;
  SourceValue, Value, TargetValue: Integer;
  State: Boolean;

begin
  Target := Command[0];
  Source := Command[4];
  SourceValue := GetOrDefault(RegisterMap, Source, 0);

  Operation := Command[5];
  Value := StrToInt(Command[6]);
  if Operation = '<' then
    State := SourceValue < Value
  else if Operation = '<=' then
    State := SourceValue <= Value
  else if Operation = '==' then
    State := SourceValue = Value
  else if Operation = '>=' then
    State := SourceValue >= Value
  else if Operation = '>' then
    State := SourceValue > Value
  else if Operation = '!=' then
    State := SourceValue <> Value
  else
    raise Exception.Create('Invalid Operation: "' + Operation + '"');

  TargetValue := GetOrDefault(RegisterMap, Target, 0);
  Value := StrToInt(Command[2]);
  if Command[1] = 'inc' then
    Inc(TargetValue, Value)
  else if Command[1] = 'dec' then
    Dec(TargetValue, Value)
  else
    raise Exception.Create('Invalid Command: "' + Command[1] + '"');
  if State then
  begin
    RegisterMap.AddOrSetData(Target, TargetValue);
    Result := TargetValue;
  end
  else
    Result := -1;
end;

function PrintMap(const RegisterMap: TRegisterMap): Integer;
var
  i: Integer;
begin
  if RegisterMap.Count <> 0 then
    Result := RegisterMap.Data[0];
  for i := 0 to RegisterMap.Count - 1 do
  begin
    WriteLn(RegisterMap.Keys[i], '->', RegisterMap.Data[i]);
    if Result < RegisterMap.Data[i] then
      Result := RegisterMap.Data[i];
  end;
end;

var
  Registers: TRegisterMap;
  Command: AnsiString;
  CommandParts: TStringList;
  MaxVal: Integer;
  Tmp: Integer;
 
begin
  Registers := TRegisterMap.Create;
  Registers.Sorted := True;

  CommandParts := TStringList.Create;
  MaxVal := -1;
 
  while not EOF do
  begin
    ReadLn(Command);


    CommandParts.Clear;
    CommandParts.Delimiter := ' ';
    CommandParts.DelimitedText := Command;
    tmp := RunCommand(CommandParts, Registers);
    if MaxVal < tmp then
      MaxVal := tmp;
    // PrintMap(Registers);
  end;
  WriteLn(MaxVal);
end.
