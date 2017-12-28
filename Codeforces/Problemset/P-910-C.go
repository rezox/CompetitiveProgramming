package main

import (
  "fmt"
  "bufio"
  "os"
)

var n int32;
var Words[1001] string;
func ReadData() {
  fmt.Scanf("%d", &n);
  reader := bufio.NewScanner(os.Stdin)
  reader.Scan()
  
  var i int32
  i = 1
  for i <= n {
    reader.Scan()
    Words[i] = reader.Text();

    // fmt.Println(Words[i])
    i++;
  }
}

func Solve() {
  var Ten[10] int64;
  var i int32

  Zero := [10]bool {false, false, false, false, false, false, false, false, false, false};
  Ten[0] = 1
  i = 1;
  for i < 10 {
    Ten[i] = Ten[i - 1] * 10
    i++
  }

  var Coef[10] int64;
  i = 1
  for i <= n {
    c := Words[i][0] - 97
    Zero[c] = true

    for j := 0; j < len(Words[i]); j++ {
      c := Words[i][j] - 97
      Coef[c] += Ten[len(Words[i]) - 1 - j]
    }
    i++;
  }
  var Indices[10] int;
  for i := 0; i < 10; i++ {
    Indices[i] = i;
  }

  for i := 0; i < 10; i++ {
    for j := i + 1; j < 10; j++ {
       if Coef[Indices[i]] < Coef[Indices[j]] {
	 tmp := Indices[i];
         Indices[i] = Indices[j]
	 Indices[j] = tmp
       }
    }
  }

  // for i := 0; i < 10; i++ {
  //   fmt.Println("i:", i, " Ch:", Indices[i], " Coef:", Coef[Indices[i]])
  // }
  var sum int64 = 0
  var current int32 = 1
  var used0 bool = false

  for i := 0; i < 10; i++ {
    var d int = Indices[i]
    if !used0 && !Zero[d] {
      used0 = true
    } else {
      sum += (int64(current) * Coef[d])
      current += 1
    }
  }
  fmt.Println(sum)
}

func main() {
  ReadData();
  Solve()
}
