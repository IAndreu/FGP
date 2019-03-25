param gap;
param ge;
param n > 0 integer;
param s {i in 1..n} symbolic;
param match;
param mismatch;
param m {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])}:= if substr(s[i],p,1)== substr(s[j],q,1) then match else mismatch;

var x {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} binary;
var c {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i])-1} binary;
var f {i in 1..n-1, j in i+1..i+1, q in 1..length(s[j])-1} binary;

# Objective function:
# Sum of matches and mismatches
# sum of insertions opening
# sum of deletions opening
# sum of insertions extending
# sum of deletions extending
maximize target: (sum {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} m[i,j,p,q]* x[i,j,p,q]) 
+ (-sum {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i])-1} (1- c[i,j,p])+ sum {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i])} (1 - sum{q in 1..length(s[j])} x[i,j,p,q])) * gap
+ (-sum {i in 1..n-1, j in i+1..i+1, q in 1..length(s[j])-1} (1- f[i,j,q])+ sum {i in 1..n-1, j in i+1..i+1, q in 1..length(s[j])} (1 - sum{p in 1..length(s[i])} x[i,j,p,q])) * gap
+ sum {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i])-1} (1- c[i,j,p]) *ge
+ sum  {i in 1..n-1, j in i+1..i+1, q in 1..length(s[j])-1} (1- f[i,j,q]) *ge;


# Una posició p de i nomes pot estar alineada amb una altre de j o cap una posició q de j nomes pot estar alineada amb una altre de i o cap
subject to first {i in 1..n-1,j in i+1..i+1,p in 1..length(s[i])}: sum {q in 1..length(s[j])} x[i,j,p,q] <= 1;

# Una posició q de j nomes pot estar alineada amb una altre de i o cap
subject to second {i in 1..n-1,j in i+1..i+1,q in 1..length(s[j])}: sum {p in 1..length(s[i])} x[i,j,p,q] <= 1;


# for any three consecutive strings s[i], s[j], s[k] and positions p of s[i] and q of s[j], x[i,j,p,q] = 1 implies x[j,k,q,r] = 1 for some position r of string s[k]
subject to third {i in 1..n-2,j in i+1..i+1,k in j+1..j+1,p in 1..length(s[i]),q in 1..length(s[j])}: x[i,j,p,q] <= sum {r in 1..length(s[k])} x[j,k,q,r];
subject to fourth {i in 1..n-2,j in i+1..i+1,k in j+1..j+1,q in 1..length(s[j]),r in 1..length(s[k])}: x[j,k,q,r] <= sum {p in 1..length(s[i])} x[i,j,p,q];
 

# A l'alineament final no poden haver-hi creuaments:
subject to sixth {i in 1..n-1, j in i+1..i+1, p1 in 1..length(s[i]), q1 in 1..length(s[j]), p2 in 1..length(s[i]), q2 in 1..length(s[j])}:
if (p1>p2 and q1<q2) or (p1<p2 and q1>q2) then x[i,j,p1,q1]+x[i,j,p2,q2]<=1;

subject to c1 {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i])-1}: c[i,j,p]<= sum{q in 1..length(s[j])} (x[i,j,p+1,q]+ x[i,j,p,q]);
subject to c2 {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i])-1}: c[i,j,p]>= sum{q in 1..length(s[j])} x[i,j,p,q];
subject to c3 {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i])-1}: c[i,j,p]>= sum{q in 1..length(s[j])} x[i,j,p+1,q];
subject to f1 {i in 1..n-1, j in i+1..i+1, q in 1..length(s[j])-1}: f[i,j,q]<= sum{p in 1..length(s[i])} (x[i,j,p,q+1]+ x[i,j,p,q]);
subject to f2 {i in 1..n-1, j in i+1..i+1, q in 1..length(s[j])-1}: f[i,j,q]>= sum{p in 1..length(s[i])} x[i,j,p,q];
subject to f3 {i in 1..n-1, j in i+1..i+1, q in 1..length(s[j])-1}: f[i,j,q]>= sum{p in 1..length(s[i])} x[i,j,p,q+1];

# reset; model LCSge.mod; data LCSge.dat; solve;
# display (sum {i in 1..n-1, j in i+1..i+1} length(s[j]) )- sum {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i])-1} c[i,j,p];