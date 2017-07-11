{$mode objfpc}
program Calc;

function IsValid(Candidate: Integer): Boolean;
begin
  Result := 0 <= Candidate;
end;

function Solve(n, b: Integer): Int64;
var
  m, k: Int64;
begin
  Result := 0;
{
Max(m * k), s.t., m + bk = n
 m = n - bk
  max((n-b k)k) 
  =max(n * k - b  k^2)
  n - 2bk = 0 => k = n/2b.
}
  k := n div (2 * b);
  m := n - b * k;
  Result := k * m;

  k := 1 + n div (2 * b);
  m := n - b * k;
  if (Result < k * m) and IsValid(k) and IsValid(m) then
    Result := k * m;

  k := n div (2 * b) - 1;
  m := n - b * k;
  if (Result < k * m) and IsValid(k) and IsValid(m) then
    Result := k * m;

end;

var
  T: Integer;
  n, b: Integer;

begin
  ReadLn(T);

  while T <> 0 do
  begin
    ReadLn(n, b);
    WriteLn(Solve(n, b));
    Dec(T);
  end;
end.
