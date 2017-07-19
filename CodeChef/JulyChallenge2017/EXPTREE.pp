{$mode objfpc}
program EXPTREE;

{
 n * C(2n-4,n-2)
 --------------
  C(2n-2,n-1)

2 * C(0,0)
-----------
 C(2,1)

 (n-1) n
 --------------------
 2(2n-3)

n=2 => 2/2
n=3 => 6/6
n=4 => 12/10=6/5

}
 
const
  M1: Int64 = 1000000007;
  M2: Int64 = 1000000009;

function gcd(a, b: Int64): Int64;
begin
  if a < b then
    Exit(gcd(b, a));

  Result := b;
  while a mod b <> 0 do
  begin
     Result := a mod b;
     a := b;
     b := Result;
  end;
end;

function ModularMultiplicativeInverse(x, m: Int64): Int64;
var
  a, b: Int64;

  procedure RecCompute(x, m: Int64; var a, b: Int64);
  var
    a1, b1: Int64;
  begin
    if x = 1 then
    begin
      //ax + bm = 1
      b := 1;
      a := 1 - m;
    end
    else
    begin
      RecCompute(m mod x, x, a1, b1);
      // a1 m' + b1 x = 1
      // (b1 - a1k) x + a1 (kx + m') = 1
      a := b1 - a1 * (m div x);
      b := a1;
    end;
  end;

begin
  if x < m then
    RecCompute(x, m, a, b)
  else
    RecCompute(m, x, b, a);
  Assert(a * x + b * m = 1);
  Result := a;
  if Result < 0 then
    Result := m - ((m - Result) mod m);

end;


procedure Solve(N: Int64);
  procedure Simplify(var n, d: Int64);
  var
    g: Int64;
  begin 
    g := gcd(n, d);
    n := n div g;
    d := d div g;
  end;

  function Compute(n1, n2, d1, d2, M: Int64): Int64;
  var
    id1, id2: Int64;
  begin
    id1 := ModularMultiplicativeInverse(d1, M);
    id2 := ModularMultiplicativeInverse(d2, M);
    Result := ((n1 mod M) * (n2 mod M))  mod M;
    Result := (Result * id1)  mod M;
    Result := (Result * id2)  mod M;
  end;

var
  n1, n2, d1, d2: Int64;
  g: Int64;
  
begin
  if N = 1 then
    WriteLn('0 0');
  if N <= 1 then Exit;
  n1 := N - 1; n2 := N;
  d1 := 2; d2 := 2 * N - 3;

  Simplify(n1, d1);
  Simplify(n1, d2);
  Simplify(n2, d1);
  Simplify(n2, d2);

  WriteLn(Compute(n1, n2, d1, d2, M1), ' ', Compute(n1, n2, d1, d2, M2));
end;

var
  T: Integer;
  N: Int64;
begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadLn(N);
    Solve(N);
    Dec(T);
  end;
  
end.


