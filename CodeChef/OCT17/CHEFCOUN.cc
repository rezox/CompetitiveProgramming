#include<vector>
#include<cstdio>
#include<iostream>
#include<cstdlib>

using namespace std;

int wrongSolver(std::vector <unsigned int> a) {
  int n = a.size();
  std::vector<unsigned int> prefSum(n), sufSum(n);
  prefSum[0] = a[0];
  for (int i = 1; i < n; i++) {
    prefSum[i] = prefSum[i - 1] + a[i];
    if (prefSum[i] < a[i]) {
      printf("%d %u\n", i, prefSum[i]);
     }
  }
  sufSum[n - 1] = a[n - 1];
  for (int i = n - 2; i >= 0; i--) {
    sufSum[i] = sufSum[i + 1] + a[i];
  }
  unsigned int mn = prefSum[0] + sufSum[0];
  int where = 1;
  for (int i = 1; i < n; i++) {
     unsigned int val = prefSum[i] + sufSum[i];
     if (val < mn) {
       mn = val;
       where = i + 1;
     }
  }
  return where;
}

int Solver(std::vector <unsigned int> a) {
	int n = a.size();
	std::vector<long long> prefSum(n), sufSum(n);
	prefSum[0] = a[0];
	for (int i = 1; i < n; i++) {
		prefSum[i] = prefSum[i - 1] + a[i];
	}
	sufSum[n - 1] = a[n - 1];
	for (int i = n - 2; i >= 0; i--) {
		sufSum[i] = sufSum[i + 1] + a[i];
	}
	long long mn = prefSum[0] + sufSum[0];
	int where = 1;
	for (int i = 1; i < n; i++) {
		long long val = prefSum[i] + sufSum[i];
		if (val < mn) {
			mn = val;
			where = i + 1;
		} else if (val == mn) {
		}
	}
	return where;
}
int main() {
  int T;
  cin >> T;

  while (T != 0) {
    --T;
    int N;
    cin >> N;  
    std::vector<unsigned int> a(N);

    int r = 0, w = 0;
    long long S = a.size();
    const long long modulo = 1ll << 32;
    a[0] = 1;
    long long Sum = 1;
    for (int i = 1; i < a.size() - 1; ++i) {
      a[i] = modulo / (S - 1);
      Sum += a[i];
    }
    a[a.size() - 1] = modulo - Sum - 2;
    while (100000 < a.back()) {
      for (int i = 1; i < a.size() - 1; ++i) {
	 a[i]++;
      }
      a[a.size() - 1] -= a.size() - 1;
    }
    Sum = modulo - 2;
    
     a[0] = 1; 
    w = wrongSolver(a);
    r = Solver(a);
    //printf("w=%d r=%d\n", w, r);
    for (int i = 0; i < a.size(); ++i) {
      printf("%d ", a[i]);
    }
    printf("\n");
  }
  return 0;
}
