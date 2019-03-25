param n > 0 integer;
param s {i in 1..n} symbolic;
param lcp {i in 1..n-1,j in i+1..i+1,p in 1..length(s[i]),q in 1..length(s[j])} := max {k in 0..min(length(s[i])-p+1,length(s[j])-q+1): substr(s[i],p,k) == substr(s[j],q,k)} k;

# 1 iff a solution occur at position p of s[i] and position q of s[j]
var x {i in 1..n-1,j in i+1..i+1,p in 1..length(s[i]),q in 1..length(s[j])} binary;

# length of a longest common substring
var lcs >=0 integer;

maximize target: lcs;

# choose only one longest common substring between each two consecutive strings s[i] and s[j]
subject to first {i in 1..n-1,j in i+1..i+1}: sum {p in 1..length(s[i]),q in 1..length(s[j])} x[i,j,p,q] = 1;

# a solution cannot be longer than a longest common substring of any two consecutive strings s[i] and s[j]
subject to second {i in 1..n-1,j in i+1..i+1}: lcs <= sum {p in 1..length(s[i]),q in 1..length(s[j])} lcp[i,j,p,q]*x[i,j,p,q];

# for any three consecutive strings s[i], s[j], s[k] and positions p of s[i] and q of s[j], x[i,j,p,q] = 1 implies x[j,k,q,r] = 1 for some position r of string s[k]
subject to third {i in 1..n-2,j in i+1..i+1,k in j+1..j+1,p in 1..length(s[i]),q in 1..length(s[j])}: x[i,j,p,q] <= sum {r in 1..length(s[k])} x[j,k,q,r];
