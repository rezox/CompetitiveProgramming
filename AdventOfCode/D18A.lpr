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
  TIntList = specialize TFPGList<Int64>;

function Solve(Prog: TStringList): Integer;
var
  CmdIndex: array [0..1] of Integer;
  Queue: array [0..1] of TIntList;
  BoQ: array[0..1] of Integer;
  RegisterMap: array[0..1] of TStringIntMap;
  Waiting: array[0..1] of Boolean;
  CurrentID: Integer;

  procedure Insert(Value: Integer; ID: Integer);
  begin
    Queue[ID].Add(Value);
  end;

  function QDelete(ID: Integer): Integer;
  begin
    Result := Queue[ID][BoQ[ID]];
    Inc(BoQ[ID]);
  end;

  function IsEmpty(ID: Integer): Boolean;
  begin
    Result := BoQ[ID] = Queue[ID].Count;
  end;

  function GetValue(const Cmd: AnsiString; ID: Integer): Int64;
  begin
    if Cmd[1] in ['-', '0'..'9'] then
      Exit(StrToInt(Cmd));
    if not RegisterMap[ID].TryGetData(Cmd, Result) then
      Result := 0;
  end;

  procedure AddOrSetData(const RegisterName: AnsiString; Value: Int64; ID: Integer);
  var
    tmp: Int64;

  begin
    if RegisterMap[ID].TryGetData(RegisterName, tmp) then
      RegisterMap[ID][RegisterName] := Value
    else
      RegisterMap[ID].Add(RegisterName, Value);
  end;

  procedure SetCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    Delete(Cmd, 1, Pos(' ', Cmd));
    AddOrSetData(RegisterName, GetValue(Cmd, CurrentID), CurrentID xor 1);
  end;

  procedure SndCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Cmd := Cmd + ' ';
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    Insert(GetValue(RegisterName, CurrentID), CurrentID xor 1);
    Waiting[CurrentID xor 1] := False;
  end;

  procedure AddCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    Delete(Cmd, 1, Pos(' ', Cmd));
    AddOrSetData(RegisterName, GetValue(RegisterName, CurrentID) + GetValue(Cmd, CurrentID), CurrentID);
  end;

  procedure MulCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    Delete(Cmd, 1, Pos(' ', Cmd));
    AddOrSetData(RegisterName, GetValue(RegisterName, CurrentID) * GetValue(Cmd, CurrentID), CurrentID);
  end;

  procedure ModCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    Delete(Cmd, 1, Pos(' ', Cmd));
    if GetValue(Cmd, CurrentID) = 0 then
    begin
WriteLn('---', GetValue(RegisterName, CurrentID) mod GetValue(Cmd, CurrentID));
Halt(1);
    end;
    AddOrSetData(RegisterName, GetValue(RegisterName, CurrentID) mod GetValue(Cmd, CurrentID), CurrentID);
  end;

  procedure RcvCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Cmd := Cmd + ' ';
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);
    if IsEmpty(CurrentID) then
    begin
      Dec(CmdIndex[CurrentID]);
      Waiting[CurrentID] := True;
    end
    else
    begin
      Waiting[CurrentID] := False;
      AddOrSetData(RegisterName, QDelete(CurrentID), CurrentID);
    end;
  end;

  procedure JgzCmd(Cmd: AnsiString);
  var
    RegisterName: AnsiString;

  begin
    Delete(Cmd, 1, 4);
    RegisterName := Copy(Cmd, 1, Pos(' ', Cmd) - 1);

    Delete(Cmd, 1, Pos(' ', Cmd));
    if GetValue(RegisterName, CurrentID) <> 0 then
      Inc(CmdIndex[CurrentID], GetValue(Cmd, CurrentID))
    else
      Inc(CmdIndex[CurrentID]);
  end;

  procedure PrintRegisters;
  var
    i: Integer;

  begin
    WriteLn('----');
    WriteLn('CurrentID:', CurrentID);
    WriteLn('Waiting:', Waiting[CurrentID]);
    WriteLn('Queue:', Queue[CurrentID].Count, ' BoQ:', BoQ[CurrentID]);
    //for i := BoQ[CurrentID] to Queue[CurrentID].Count -1 do
    //  Write(Queue[CurrentID][i], ' ');
    //WriteLn;
    for i := 0 to RegisterMap[CurrentID].Count - 1 do
      WriteLn(RegisterMap[CurrentID].Keys[i], ' -> ', RegisterMap[CurrentID].Data[i]);
  end;

var
  Cmd: AnsiString;
  i, j: Integer;
  Flag: Boolean;

begin
  for i := 0 to 1 do
  begin
    RegisterMap[i] := TStringIntMap.Create;
    RegisterMap[i].Sorted := True;
    Queue[i] := TIntList.Create;
    BoQ[i] := 0;
    CmdIndex[i] := 0;
    Waiting[i] := False;
    RegisterMap[i].Add('p', i);
  end;

  Result := 0;
  j := 0;
  while CmdIndex[1] < Prog.Count do
  begin
    Inc(j);
    if j mod 1000 = 0 then
    begin
      WriteLn('J:', j);
      for CurrentID := 0 to 1 do
      begin
        Cmd := '*';
        if CmdIndex[CurrentID] < Prog.Count then
          Cmd := Prog[CmdIndex[CurrentID]];
        WriteLn(CmdIndex[CurrentID], ':', Cmd);
        PrintRegisters;
      end;
    end;
    Flag := False;
    for CurrentID := 0 to 1 do
    begin
      //PrintRegisters;
      if Waiting[CurrentID] or (CmdIndex[CurrentID] >= Prog.Count) then
      begin
        //WriteLn(CurrentID, ' is waiting');
        continue;
      end
      else
        Flag := True;
      Cmd := Prog[CmdIndex[CurrentID]];
      //WriteLn(CmdIndex[CurrentID], ':', Cmd);
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
        Inc(CmdIndex[CurrentID]);
    end;

    if not Flag then
      break;
  end;

  Result := Queue[0].Count;
end;

var
  Prog: TStringList;

begin
  Prog := ReadData;
  WriteLn(Solve(Prog));

end.
