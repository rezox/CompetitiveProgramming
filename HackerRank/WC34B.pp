{$mode objfpc}
program WC34B;
uses
  Classes, SysUtils, fgl;
type
  TIntList = specialize TFPGList<Integer>;

  { TFactorizationPair }

  TFactorizationPair = class(TObject)
  private
    FBase: Integer;
    FPower: Integer;
  public
    property Base: Integer read FBase write FBase;
    property Power: Integer read FPower write FPower;

    constructor Create;
    constructor Create(b, p: Integer);

  end;

  TFactorization = class(specialize TFPGObjectList<TFactorizationPair>)
  public
    procedure WriteLn;
  end;

constructor TFactorizationPair.Create;
begin
  inherited Create;

  FBase := 0;
  FPower := 0;
end;

constructor TFactorizationPair.Create(b, p: Integer);
begin
  inherited Create;

  FBase := b;
  FPower := p;
end;


function GenerateAllPrimes(Max: Integer): TIntList;
var
  IsPrime: array of Boolean;
  i, j: Integer;
begin
  Result := TIntList.Create;

  SetLength(IsPrime, Max + 1);
  FillChar(IsPrime[0], (Max + 1) * SizeOf(Boolean), True);

  IsPrime[0] := False;
  IsPrime[1] := False;

  for i := 2 to Max do
    if IsPrime[i] then
      for j := 2 to (Max div i) do
        IsPrime[i * j] := False;

  for i := 2 to Max do
    if IsPrime[i] then
      Result.Add(i);

  SetLength(IsPrime, 0);
end;

function Factorize(n: Int64; const Primes: TIntList): TFactorization;
var
  i, b, p: Integer;

begin
  Result := TFactorization.Create;
  for i := 0 to Primes.Count - 1 do
  begin
    b := Primes[i];
    p := 0;

    while n mod b = 0 do
    begin
      Inc(p);
      n := n div b;
    end;

    if p <> 0 then
      Result.Add(TFactorizationPair.Create(b, p));

    if n < b * b then
    begin
      if n <> 1 then
        Result.Add(TFactorizationPair.Create(n, 1));
      break;
    end;
  end;

end;

function CopyIntList(A: TIntList): TIntList;
var
  i: Integer;
begin
  Result := TIntList.Create;
  for i := 0 to A.Count - 1 do
    Result.Add(A[i]);
end;

type
  TBoolList=  specialize TFPGList<Boolean>;
var
  AllDivisors: array[0..1000000] of TIntList;
function RecGenerateAllDivisors(n: Integer; Primes: TIntList): TIntList;
var
  Factors : TFactorization;

  procedure RecGen(Index: Integer);
  var
    i, j, c: Integer;
    p, b2p: Integer;

  begin
    if Index = Factors.Count then
      Exit;

    c := Result.Count;
    p := Factors[Index].Base;
    b2p := p;

    for j := 1 to Factors[Index].Power do
    begin
      for i := 0 to c - 1 do
        Result.Add(Result[i] * b2p);
      b2p *= p;
    end;

    RecGen(Index + 1);
  end;

begin
  Factors := Factorize(n, Primes);
  Result := TIntList.Create;

  Result.Add(1);

  if 0 < Factors.Count then
    RecGen(0);
  Factors.Free;
end;


function GenerateAllDivisors(n: Integer; Primes: TIntList): TIntList;
var
  i: Integer;
  p: Integer;
  Last: TIntList;
  IsPrime: Boolean;
  Values: TBoolList;
  LIndex, NIndex: Integer;

begin
  IsPrime := True;
  for i := 0 to Primes.Count - 1 do
  begin
    p := Primes[i];

    if n mod p = 0 then
    begin
      IsPrime := False;
      break;
    end;

    if n < p * p then
      break;
  end;

  Result := TIntList.Create;
  if IsPrime then // n is prime.
  begin
    Result.Add(1);
    Result.Add(n);
    Exit;
  end;

  Last := AllDivisors[n div p];
  // Result := Last + Last * p;
  LIndex := 0; NIndex := 0;
  while LIndex < Last.Count do
  begin
    if Last[LIndex] < Last[NIndex] * p then
    begin
      Result.Add(Last[LIndex]);
      Inc(LIndex);
    end
    else if Last[NIndex] * p < Last[LIndex] then
    begin
      Result.Add(Last[NIndex] * p);
      Inc(NIndex);
    end
    else
    begin
      Result.Add(Last[LIndex]);
      Inc(LIndex);
      Inc(NIndex);
    end;
  end;
  while NIndex < Last.Count do
  begin
    Result.Add(Last[NIndex] * p);
    Inc(NIndex);
  end;
end;

procedure TFactorization.WriteLn;
var
  i: Integer;

begin
  for i := 0 to Self.Count - 1 do
    System.WriteLn(Self[i].Base, '^', Self[i].Power);

end;

var
  N: Integer;
  Ai, Bi: TIntList;

procedure ReadData;
var
  i, x: Integer;
begin
  ReadLn(N);
  Ai := TIntList.Create;
  Bi := TIntList.Create;
  for i := 1 to N do
  begin
    x := 2 * i; Ai.Add(x);
    // Read(x); Ai.Add(x);
  end;
  ReadLn;
  for i := 1 to N do
  begin
    x := i; Bi.Add(x);
    //Read(x); Bi.Add(x);
  end;
  ReadLn;
end;

function Sort(List: TIntList): TIntList;
var
  Values: TBoolList;
  i: Integer;

begin
  Values := TBoolList.Create; Values.Count := 1000001;
  for i := 0 to List.Count - 1 do
    Values[List[i]] := True;

  Result := TIntList.Create;
  for i := 0 to Values.Count - 1 do
    if Values[i] then
      Result.Add(i);
end;

function Solve: Integer;

  function ComputeValues(SortedList: TIntList): TIntList;
  var
    i, j: Integer;
    Divisors: TIntList;

  begin
    Result := TIntList.Create; Result.Count := 1000001;
    for i := SortedList.Count - 1 downto 0 do
    begin
      Divisors := AllDivisors[SortedList[i]];
      for j := 0 to Divisors.Count - 1 do
        if Result[Divisors[j]] = 0 then
        begin
          Result[Divisors[j]] := SortedList[i];
        end;
    end;
  end;

var
  AValues, BValues: TIntList;
  SAi, SBi: TIntList;
  i: Integer;

begin
  SAi := Sort(Ai); SBi := Sort(Bi);
  AValues := ComputeValues(SAi); BValues := ComputeValues(SBi);
  for i := 1000000 downto 1 do
    if (AValues[i] <> 0) and (BValues[i] <> 0) then
      Exit(AValues[i] + BValues[i]);
end;

var
  Primes: TIntList;
  i, j: Integer;

begin
  Primes := GenerateAllPrimes(1000);
  AllDivisors[1] := TIntList.Create; AllDivisors[1].Add(1);
  for i := 2 to 1000000 do
  begin
    AllDivisors[i] := GenerateAllDivisors(i, Primes);
    //AllDivisors[i] := RecGenerateAllDivisors(i, Primes);
    //Write(i, ':');
    //for j := 0 to AllDivisors[i].Count - 1 do
    //  Write(AllDivisors[i][j], ' ');
    //WriteLn;
  end;
  ReadData;
  WriteLn(Solve);
end.
