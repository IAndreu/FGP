param n > 0 integer;
param s {i in 1..n} symbolic;
param m {p in 1..length(s[1]) ,i in 2..n, q in 1..length(s[i])}:= if substr(s[1],p,1)==substr(s[i],q,1) then 1 else 0;
param m1 {p in 1..length(s[1]) ,i in 2..n}:= max {q in 1..length(s[i])} m[p,i,q];
param m2 {p in 1..length(s[1])}:= sum {i in 2..n} m1[p,i];
param m3 {p in 1..length(s[1])}:= if m2[p]=n-1 then 1 else 0;
param m4 := sum {p in 1..length(s[1])} m3[p];

var x {p in 1..length(s[1])} binary;
var lcs>=0 integer; #length of the lcsubsequece

maximize target: lcs;

subject to first: m4>=lcs; # length of lcs must be smaller or equal than the amount of common characters between all strings

subject to second: lcs = sum {p in 1..length(s[1])} x[p]; # #length of the lcsubsequece

subject to third {p in 1..length(s[1])}: x[p]<=m3[p]; # positions of the solution lcs for string 1 must be in all the other strings

subject to fourth { p in 1..length(s[1])-1, i in 2..n, q in 1..length(s[i]), r in 1..length(s[i])}: if (if m[p,i, q]==1 then q else -1) > (if m[p+1,i,r]==1 then r else q+1) then x[p]=1 elsex[p]=0;


# reset; model subsequence.mod; data subsequence.dat; solve;