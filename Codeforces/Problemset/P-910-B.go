package main

import (
  "fmt"
)

var n int32
var a int32
var b int32

func ReadData() {
  fmt.Scan(&n);
  fmt.Scan(&a);
  fmt.Scan(&b);
}

func Solve(na int32, nb int32, current int32, dbg bool) int {
  if na == 0 && nb == 0 {
    return 0;
  }

  var r0 int = 10000;
  var r1 int = 10000;
  var r2 int = 10000;
  var mode int = 4;

  if 0 < na && a <= current {
    r0 = Solve(na - 1, nb, current - a, false);
  }
  if 0 < nb && b <= current {
    r1 = Solve(na, nb - 1, current - b, false);
  }
  if current != n {
    r2 = 1 + Solve(na, nb, n, false);
  }

  result := r0
  mode = 0
  if r1 < result {
    result = r1
    mode = 1
  }
  if r2 < result {
    result = r2
    mode = 2
  }

  if dbg {
    if mode == 0 {
      Solve(na - 1, nb, current - a, true);
    } else if mode == 1 {
      Solve(na, nb - 1, current - b, true);
    } else if mode == 2 {
    r2 = 1 + Solve(na, nb, n, true);
    }
    fmt.Println("na: ", na, " nb: ", nb, " current: ", current, " result: ", result, " mode: ", mode)
  }
  return result
}

func main() {
  ReadData();
  fmt.Println(Solve(4, 2, 0, false));
}
