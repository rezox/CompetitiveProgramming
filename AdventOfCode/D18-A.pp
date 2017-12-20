{$mode objfpc}
program D18A;
uses
 fgl, classes, SysUtils;

function ReadData: TStringList;
var
  S: AnsiString;

begin
  Result := TStringList.Create;

  while not EoF do
  begin
    ReadLn(S);
    Result.Add(S);
  end;
end;

type
  TStringIntMap = specialize TFPGMap<String, Int64>;

var
  RegisterMap: TStringIntMap; 
 
function Solve(Prog: TStringList): Integer;
var
  LastSound: Integer;
  CmdIndex: Integer;

  function GetValue(const Cmd: AnsiString): Int64;
  begin
    if Cmd[1] in ['-', '0'..'9'] then
      Exit(StrToInt(Cmd));
    if not RegisterMap.TryGetData(Cmd, Result) then
      Result := 0;
  end;

  procedure AddOrSetData(const RegisterName: AnsiString; Value: Int64);
  var
    tmp: Int64;

  begin
    if RegisterMap.TryGetData(RegisterName, tmp) then
      RegisterMap[RegisterName] := Value
    else
      RegisterMap.Add(RegisterName, Value);
  end;

  procedure SetCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    Delete(Cmd, 1, Pos(' ', Cmd));
    AddOrSetData(RegisterName, GetValue(Cmd));
  end;

  procedure SndCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Cmd := Cmd + ' ';
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    LastSound := GetValue(RegisterName);
  end;

  procedure AddCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    Delete(Cmd, 1, Pos(' ', Cmd));
    AddOrSetData(RegisterName, GetValue(RegisterName) + GetValue(Cmd));
  end;

  procedure MulCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    Delete(Cmd, 1, Pos(' ', Cmd));
    AddOrSetData(RegisterName, GetValue(RegisterName) * GetValue(Cmd));
  end;

  procedure ModCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    Delete(Cmd, 1, Pos(' ', Cmd));
    AddOrSetData(RegisterName, GetValue(RegisterName) mod GetValue(Cmd));
  end;

  procedure RcvCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Cmd := Cmd + ' ';
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    if GetValue(RegisterName) <> 0 then
    begin
      WriteLn('Value:', LastSound);
      CmdIndex := Prog.Count;
    end;
  end;

  procedure JgzCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);

    Delete(Cmd, 1, Pos(' ', Cmd));
    if GetValue(RegisterName) <> 0 then
      Inc(CmdIndex, GetValue(Cmd))
    else
      Inc(CmdIndex);
  end;
  
  procedure PrintRegisters;
  var
    i: Integer;

  begin
    for i := 0 to RegisterMap.Count - 1 do
      WriteLn(RegisterMap.Keys[i], ' -> ', RegisterMap.Data[i]);
  end;

var
  Cmd: AnsiString;

begin
  RegisterMap := TStringIntMap.Create;
  RegisterMap.Sorted := True;

  Result := 0;
  CmdIndex := 0;
  while CmdIndex < Prog.Count do
  begin
    Cmd := Prog[CmdIndex];
    PrintRegisters;
    WriteLn(CmdIndex, ':', Cmd);
    if Copy(Cmd, 1, 3) = 'snd' then
      SndCmd(Cmd)
    else if Copy(Cmd, 1, 3) = 'set' then
      SetCmd(Cmd)
    else if Copy(Cmd, 1, 3) = 'add' then
      AddCmd(Cmd)
    else if Copy(Cmd, 1, 3) = 'mul' then
      MulCmd(Cmd)
    else if Copy(Cmd, 1, 3) = 'mod' then
      ModCmd(Cmd)
    else if Copy(Cmd, 1, 3) = 'rcv' then
      RcvCmd(Cmd)
    else if Copy(Cmd, 1, 3) = 'jgz' then
      JgzCmd(Cmd);
    if Copy(Cmd, 1, 3) <> 'jgz' then
      Inc(CmdIndex);
  end;
end;

var
  Prog: TStringList;
 
begin
  Prog := ReadData;
  WriteLn(Solve(Prog));

end.
