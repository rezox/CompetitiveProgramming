package main

import (
  "fmt"
)

var n int
var d int

func ReadData() []int {
  fmt.Scanf("%d %d", &n, &d)

  var line string = ""
  fmt.Scan(&line)

  result := make([]int, 0)
  for i := 0; i < n; i++ {
    if line[i] == '1' {
      result = append(result, i)
    }
  }
  return result
}

func Solve(line []int) int {
  dp := make([]int, 1 + len(line))
  for i := 0; i < len(dp); i++ {
    dp[i] = 2 * len(line);
  }
  dp[0] = 0;
  for i := 1; i < len(line); i++ {
    current := line[i]

    result := 2 * len(dp)
    for j := i - 1; j >= 0; j-- {
      if d < current - line[j] {
        break
      }
      if dp[j] == 2 * len(dp) {
        continue
      }
      if dp[j] + 1 < result {
        result = dp[j] + 1
      }
    }
    dp[i] = result
  }

  if dp[len(line) - 1] == 2 * len(dp) {
    return -1;
  }
  return dp[len(line) - 1]
}

func main() {
  line := ReadData()
  fmt.Println(Solve(line))
}
