# ALignment based on the longest common subsequence problem. Version 1 (cost values are given by a matrix)

set aa;
param gap;
param n > 0 integer;
param s {i in 1..n} symbolic;
param BLOSSUM62 {aa, aa};
param m {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])}:= BLOSSUM62[substr(s[i],p,1), substr(s[j],q,1)];

var x {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} binary;

maximize target: (sum {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} m[i,j,p,q]* x[i,j,p,q]) + (sum {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i])} (1 - sum{q in 1..length(s[j])} x[i,j,p,q])+ sum {i in 1..n-1, j in i+1..i+1, q in 1..length(s[j])} (1 - sum{p in 1..length(s[i])} x[i,j,p,q]))* gap;


# A position "p" of string "i" can only be aligned with 1 position "q" for string "j" or not be aligned: 
subject to first {i in 1..n-1,j in i+1..i+1,p in 1..length(s[i])}: sum {q in 1..length(s[j])} x[i,j,p,q] <= 1;

# A position "q" of string "j" can only be aligned with 1 position "p" for string "i" or not be aligned: 
subject to second {i in 1..n-1,j in i+1..i+1,q in 1..length(s[j])}: sum {p in 1..length(s[i])} x[i,j,p,q] <= 1;

# A position is valid if it is aligned in all the strings:

# for any three consecutive strings s[i], s[j], s[k] and positions p of s[i] and q of s[j], x[i,j,p,q] = 1 implies x[j,k,q,r] = 1 for some position r of string s[k]
subject to third {i in 1..n-2,j in i+1..i+1,k in j+1..j+1,p in 1..length(s[i]),q in 1..length(s[j])}: x[i,j,p,q] <= sum {r in 1..length(s[k])} x[j,k,q,r];
subject to third2 {i in 1..n-2,j in i+1..i+1,k in j+1..j+1,q in 1..length(s[j]),r in 1..length(s[k])}: x[j,k,q,r] <= sum {p in 1..length(s[i])} x[i,j,p,q];
 
#subject to fourth {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])}: m[i,j,p,q]>=x[i,j,p,q];

# There can be no crosses in the final alignment:
subject to sixth {i in 1..n-1, j in i+1..i+1, p1 in 1..length(s[i]), q1 in 1..length(s[j]), p2 in 1..length(s[i]), q2 in 1..length(s[j])}:
if (p1>p2 and q1<q2) or (p1<p2 and q1>q2) then x[i,j,p1,q1]+x[i,j,p2,q2]<=1;

# reset; model alignment.mod; data alignment.dat; solve;

