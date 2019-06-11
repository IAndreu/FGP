# Alignment based on the longest common subsequence problem. Version 1 (cost values are given by the substitution matrix BLOSSUM62)

set aa;
param gap;
param n > 0 integer;
param s {i in 1..n} symbolic;
param BLOSSUM62 {aa,aa};
param m {i in 1..n-1,j in i+1..i+1,p in 1..length(s[i]),q in 1..length(s[j])} := BLOSSUM62[substr(s[i],p,1),substr(s[j],q,1)];

var x {i in 1..n-1,j in i+1..i+1,p in 1..length(s[i]),q in 1..length(s[j])} binary;

maximize target: (sum {i in 1..n-1,j in i+1..i+1,p in 1..length(s[i]),q in 1..length(s[j])} m[i,j,p,q]*x[i,j,p,q]) + (sum {i in 1..n-1,j in i+1..i+1,p in 1..length(s[i])} (1 - sum{q in 1..length(s[j])} x[i,j,p,q]) + sum {i in 1..n-1,j in i+1..i+1,q in 1..length(s[j])} (1 - sum{p in 1..length(s[i])} x[i,j,p,q]))*gap;

# A position "p" of string "i" can only be aligned with at most one position "q" for string "j":
subject to first {i in 1..n-1,j in i+1..i+1,p in 1..length(s[i])}: sum {q in 1..length(s[j])} x[i,j,p,q] <= 1;

# A position "q" of string "j" can only be aligned with at most one position "p" for string "i":
subject to second {i in 1..n-1,j in i+1..i+1,q in 1..length(s[j])}: sum {p in 1..length(s[i])} x[i,j,p,q] <= 1;

# A position is valid if it is aligned in all the strings:

# for any three consecutive strings s[i], s[j], s[k] and positions p of s[i] and q of s[j], x[i,j,p,q] = 1 implies x[j,k,q,r] = 1 for some position r of string s[k]
subject to third {i in 1..n-2,j in i+1..i+1,k in j+1..j+1,p in 1..length(s[i]),q in 1..length(s[j])}: x[i,j,p,q] <= sum {r in 1..length(s[k])} x[j,k,q,r];
subject to fourth {i in 1..n-2,j in i+1..i+1,k in j+1..j+1,q in 1..length(s[j]),r in 1..length(s[k])}: x[j,k,q,r] <= sum {p in 1..length(s[i])} x[i,j,p,q];

#subject to fourth {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])}: m[i,j,p,q] >= x[i,j,p,q];

# There can be no crosses in the final alignment:
subject to fifth {i in 1..n-1,j in i+1..i+1,p1 in 1..length(s[i]),q1 in 1..length(s[j]),p2 in 1..length(s[i]),q2 in 1..length(s[j])}:
if (p1 > p2 and q1 < q2) or (p1 < p2 and q1 > q2) then x[i,j,p1,q1] + x[i,j,p2,q2] <= 1;

#solve;

#display the aligned positions:
#display s;
#for {i in 1..n-1,j in i+1..i+1,p in 1..length(s[i]),q in 1..length(s[j]): x[i,j,p,q] != 0} display i, j, p, q, x[i,j,p,q];

data;

set aa := A R N D C Q E G H I L K M F P S T W Y V B Z X;
param BLOSSUM62 (tr):
   A  R  N  D  C  Q  E  G  H  I  L  K  M  F  P  S  T  W  Y  V  B  Z  X:=
A  4 -1 -2 -2  0 -1 -1  0 -2 -1 -1 -1 -1 -2 -1  1  0 -3 -2  0 -2 -1  0 
R -1  5  0 -2 -3  1  0 -2  0 -3 -2  2 -1 -3 -2 -1 -1 -3 -2 -3 -1  0 -1 
N -2  0  6  1 -3  0  0  0  1 -3 -3  0 -2 -3 -2  1  0 -4 -2 -3  3  0 -1 
D -2 -2  1  6 -3  0  2 -1 -1 -3 -4 -1 -3 -3 -1  0 -1 -4 -3 -3  4  1 -1 
C  0 -3 -3 -3  9 -3 -4 -3 -3 -1 -1 -3 -1 -2 -3 -1 -1 -2 -2 -1 -3 -3 -2 
Q -1  1  0  0 -3  5  2 -2  0 -3 -2  1  0 -3 -1  0 -1 -2 -1 -2  0  3 -1 
E -1  0  0  2 -4  2  5 -2  0 -3 -3  1 -2 -3 -1  0 -1 -3 -2 -2  1  4 -1 
G  0 -2  0 -1 -3 -2 -2  6 -2 -4 -4 -2 -3 -3 -2  0 -2 -2 -3 -3 -1 -2 -1 
H -2  0  1 -1 -3  0  0 -2  8 -3 -3 -1 -2 -1 -2 -1 -2 -2  2 -3  0  0 -1 
I -1 -3 -3 -3 -1 -3 -3 -4 -3  4  2 -3  1  0 -3 -2 -1 -3 -1  3 -3 -3 -1
L -1 -2 -3 -4 -1 -2 -3 -4 -3  2  4 -2  2  0 -3 -2 -1 -2 -1  1 -4 -3 -1
K -1  2  0 -1 -3  1  1 -2 -1 -3 -2  5 -1 -3 -1  0 -1 -3 -2 -2  0  1 -1
M -1 -1 -2 -3 -1  0 -2 -3 -2  1  2 -1  5  0 -2 -1 -1 -1 -1  1 -3 -1 -1 
F -2 -3 -3 -3 -2 -3 -3 -3 -1  0  0 -3  0  6 -4 -2 -2  1  3 -1 -3 -3 -1 
P -1 -2 -2 -1 -3 -1 -1 -2 -2 -3 -3 -1 -2 -4  7 -1 -1 -4 -3 -2 -2 -1 -2 
S  1 -1  1  0 -1  0  0  0 -1 -2 -2  0 -1 -2 -1  4  1 -3 -2 -2  0  0  0 
T  0 -1  0 -1 -1 -1 -1 -2 -2 -1 -1 -1 -1 -2 -1  1  5 -2 -2  0 -1 -1  0 
W -3 -3 -4 -4 -2 -2 -3 -2 -2 -3 -2 -3 -1  1 -4 -3 -2 11  2 -3 -4 -3 -2 
Y -2 -2 -2 -3 -2 -1 -2 -3  2 -1 -1 -2 -1  3 -3 -2 -2  2  7 -1 -3 -2 -1 
V  0 -3 -3 -3 -1 -2 -2 -3 -3  3  1 -2  1 -1 -2 -2  0 -3 -1  4 -3 -2 -1
B -2 -1  3  4 -3  0  1 -1  0 -3 -4  0 -3 -3 -2  0 -1 -4 -3 -3  4  1 -1
Z -1  0  0  1 -3  3  4 -2  0 -3 -3  1 -1 -3 -1  0 -1 -3 -2 -2  1  4 -1
X  0 -1 -1 -1 -2 -1 -1 -1 -1 -1 -1 -1 -1 -1 -2  0  0 -2 -1 -1 -1 -1 -1;
param gap := -4;

end;
