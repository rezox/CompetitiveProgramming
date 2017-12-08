program D3A;
//const
//  N : Integer = 36;//1527;
var
  N: Integer;
  x, y: Integer;
  i, m: Integer;
  d: Integer;

begin
  ReadLn(N);
  i := 1;
  while Sqr(i) < N do
    Inc(i, 2);
  if N = Sqr(i) then
  begin
    WriteLn(+i div 2, +i div 2);
    Exit;
  end;
  Dec(i, 2);
  d := i;
  WriteLn('d:', d, ' d^2:', Sqr(d), ' N-d^2:', N - Sqr(d));
{
           37 36 35 34 33 32 31       
           38 17 16 15 14 13 30        
           39 18 05 04 03 12 29          
           40 19 06 01 02 11 28            
           41 20 07 08 09 10 27         
           42 21 22 23 24 25 26
           43 44 45 46 47 48 49
 
                TR = N^2-3N+3 
                TL = N^2-2N+2 
                BL = N^2-N+1 
                BR = N^2
}
                                    
  x := +d div 2; y := +d div 2;
  WriteLn('x:', x, ', y:', y);
  if (Sqr(d) < N) and (N <= Sqr(d) + 1 + d) then 
    WriteLn(x + 1, ':', y - (N - 1 - Sqr(d)))
  else if N <= Sqr(d) + 2 + 2 * d then
    WriteLn('*:', x + 1 - (N - Sqr(d) - d - 1), ':', - y - 1)
  else if N <= Sqr(d) + 3 + 3 * d then
    WriteLn('*:', -x - 1, ':', - y - 1 + (N - Sqr(d) - 2 - 2 * d ))
  else
    WriteLn('*:', -x - 1 + (N - Sqr(d) - 3 - 3 * d), ':', + y + 1)
;
 
  
  
end.
