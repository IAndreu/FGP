param n > 0 integer default 2;	# number of strings
param s {i in 1..n} symbolic;	# n strings
param lcp {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} := max {k in 0..min(length(s[i])-p+1, length(s[j])-q+1): substr(s[i],p,k)== substr(s[j],q,k)} k;
# lcp is a String(i) vs String(j) matrix where lcp[i,j,p,q] is the length of the longest common substring that starts in position p for String i and in q for string j.  

# 1 if a solution appears at position p of s[i] and position q of s[j]
var x {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} binary;

maximize target: sum {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} lcp[i,j,p,q]*x[i,j,p,q];

subject to first {i in 1..n-1, j in i+1..i+1}: sum {p in 1..length(s[i]),q in 1..length(s[j])} x[i,j,p,q] = 1;

#subject to equal {i in 1..n-2, j in i+1..i+1,p in 1..length(s[i]), q in 1..length(s[j]), t in 1..length(s[i+1]), u in 1..length(s[j+1])}: match(substr(s[i],p,lcp[i,j,p,q]),substr(s[i+1],t,lcp[i+1,j+1,t,u])>0;

