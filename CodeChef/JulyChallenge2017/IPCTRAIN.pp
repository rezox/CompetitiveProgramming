{$mode objfpc}
program IPCTrain;
uses
  fgl;
type
  TIntList = specialize TFPGLisT<Int64>;

var
  N, D: Integer;
  Di, Ti, Si: TIntList;

procedure ReadData;
var
  i: Integer;
  a, b, c: Integer;
begin
  ReadLn(N, D);
  Di := TIntList.Create; Ti := TIntList.Create; Si := TIntList.Create;
  Di.Count := N + 1; Ti.Count := N + 1; Si.Count := N + 1;
  for i := 1 to N do
  begin
    ReadLn(a, b, c);
   Di[i] := a; Ti[i] := b; Si[i] := c;
  end;
Exit;
  N := 100000; D := 100000;
  Di := TIntList.Create; Ti := TIntList.Create; Si := TIntList.Create;
  Di.Count := N + 1; Ti.Count := N + 1; Si.Count := N + 1;
  for i := 1 to N do
  begin
    //ReadLn(a, b, c);
    a := 1; b := D; c := 100000;
   Di[i] := a; Ti[i] := b; Si[i] := c;
  end;
  for i := 1 to N do
end;

function Solve: UInt64;
var
  i, j: Integer;
  TrainerPointers: TIntList;
  DayTrainer: TIntList;
  UnmatchedTrainer: TIntList;
  ToQ: Integer;
  CandidTrainer: Integer;
  CandidDay: Integer;

begin
  TrainerPointers := TIntList.Create; TrainerPointers.Count := N + 1;
  for i := 1 to N do
    TrainerPointers[i] := Di[i];
  DayTrainer := TIntList.Create; DayTrainer.Count := D + 1;
  for i := 1 to D do
    DayTrainer[i] := -1;

  Sort;
  UnmatchedTrainer := TIntList.Create;
  Result := 0;
  for i := 1 to N do
  begin
    for j := 1 to Ti[i] do
      UnmatchedTrainer.Add(i);
  end;

  ToQ := 0;
  while ToQ < UnmatchedTrainer.Count do
  begin
    CandidTrainer := UnmatchedTrainer[ToQ];
    Inc(ToQ);
    if TrainerPointers[CandidTrainer] = D + 1 then
      Continue;
    
    while TrainerPointers[CandidTrainer] <= D do
    begin
      CandidDay := TrainerPointers[CandidTrainer];
      if DayTrainer[CandidDay] = -1 then
      begin
        TrainerPointers[CandidTrainer] := TrainerPointers[CandidTrainer] + 1;
        DayTrainer[CandidDay] := CandidTrainer;
        break;
      end
      else if Si[DayTrainer[CandidDay]] < Si[CandidTrainer] then
      begin
        UnmatchedTrainer.Add(DayTrainer[CandidDay]);

        TrainerPointers[CandidTrainer] := TrainerPointers[CandidTrainer] + 1;
        DayTrainer[CandidDay] := CandidTrainer;

        break;
      end;
      TrainerPointers[CandidTrainer] := TrainerPointers[CandidTrainer] + 1;
    end;
  end;

  for i := 1 to D do
    if DayTrainer[i] <> -1 then
      Ti[DayTrainer[i]] := Ti[DayTrainer[i]] - 1;
{
  for i := 1 to D do
    WriteLn(i, ':', DayTrainer[i]);
  WriteLn; 
}
  Result := 0;
  for i := 1 to N do
    Inc(Result, Ti[i] * Si[i]);
end;

var
  T: Integer;
  
begin
  ReadLN(T);

  while T <> 0 do
  begin
    ReadData;
    WriteLn(Solve);
    Di.Free; Ti.Free; Si.Free;
    Dec(T);
  end;
end.
