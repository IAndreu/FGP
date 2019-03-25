param gap;
param n > 0 integer;
param s {i in 1..n} symbolic;
param match;
param mismatch;
param m {i in 1..n-1, p in 1..length(s[i]), q in 1..length(s[i+1])}:= if substr(s[i],p,1)== substr(s[i+1],q,1) then match else mismatch;

var x {i in 1..n-1,  p in 1..length(s[i]), q in 1..length(s[i+1])} binary;

# Objective function:
# Sum of matches and mismatches
# sum of insertions
# sum of deletions
maximize target: (sum {i in 1..n-1, p in 1..length(s[i]), q in 1..length(s[i+1])} m[i,p,q]* x[i,p,q]) 
+ sum {i in 1..n-1, p in 1..length(s[i])} (1 - sum{q in 1..length(s[i+1])} x[i,p,q]) * gap
+ sum {i in 1..n-1,  q in 1..length(s[i+1])} (1 - sum{p in 1..length(s[i])} x[i,p,q]) * gap;

# Una posició p de i nomes pot estar alineada amb una altre de j o cap una posició q de j nomes pot estar alineada amb una altre de i o cap
subject to first {i in 1..n-1,p in 1..length(s[i])}: sum {q in 1..length(s[i+1])} x[i,p,q] <= 1;

# Una posició q de j nomes pot estar alineada amb una altre de i o cap
subject to second {i in 1..n-1, q in 1..length(s[i+1])}: sum {p in 1..length(s[i])} x[i,p,q] <= 1;


# for any three consecutive strings s[i], s[j], s[k] and positions p of s[i] and q of s[j], x[i,j,p,q] = 1 implies x[j,k,q,r] = 1 for some position r of string s[k]
subject to third {i in 1..n-2,p in 1..length(s[i]),q in 1..length(s[i+1])}: x[i,p,q] <= sum {r in 1..length(s[i+2])} x[i+1,q,r];
subject to fourth {i in 1..n-2, q in 1..length(s[i+1]),r in 1..length(s[i+2])}: x[i+1,q,r] <= sum {p in 1..length(s[i])} x[i,p,q];
 

# A l'alineament final no poden haver-hi creuaments:
subject to sixth {i in 1..n-1, p1 in 1..length(s[i]), q1 in 1..length(s[i+1]), p2 in 1..length(s[i]), q2 in 1..length(s[i+1])}:
if (p1>p2 and q1<q2) or (p1<p2 and q1>q2) then x[i,p1,q1]+x[i,p2,q2]<=1;

# reset; model LCSalignment.mod; data LCSalignment.dat; solve;

###########################################################
