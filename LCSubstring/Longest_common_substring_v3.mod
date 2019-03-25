param n > 0 integer;
param s {i in 1..n} symbolic;
param lcp {i in 1..1, j in i+1..i+n-1,p in 1..length(s[i]),q in 1..length(s[j])} := max {k in 0..min(length(s[i])-p+1,length(s[j])-q+1): substr(s[i],p,k) == substr(s[j],q,k)} k;
param m1 {i in 1..1, j in i+1..i+n-1, p in 1..length(s[i])} := max {q in 1..length(s[j])} lcp[i,j,p,q];
param m2 {i in 1..1, p in 1..length(s[i])} := min {j in i+1..i+n-1} m1[i,j,p];
param m3 := max {i in 1..1, p in 1..length(s[i])} m2[i,p];
param v {i in 1..1, p in 1..length(s[i])}:= if m2[i,p]==m3 then p;
#param pos:= sum {i in 1..1, p in 1..length(s[i])} v[i,p];
param pos:= max {i in 1..1, p in 1..length(s[i])} v[i,p];
param substring:= substr(s[1],pos,m3) symbolic;
param x {i in 1..n, p in 1..length(s[i])}:= if substr(s[i],p,m3)==substring then 1 else 0;

var lcs integer;

maximize target: lcs*1;

subject to first: lcs=m3;
