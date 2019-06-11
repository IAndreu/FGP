param n > 0 integer;
param s {i in 1..n} symbolic;
param m {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} := if substr(s[i],p,1) == substr(s[j],q,1) then 1 else 0;
param l := sum {i in 1..n} length(s[i]);
param M = max {i in 1..n} length(s[i]);

var x {i in 1..n, p in 1..length(s[i])} >= 1 integer;
var y_1 {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} binary;
var y_2 {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j])} binary;

minimize target: sum {i in 1..n, p in 1..length(s[i])} x[i,p];

# creixent
subject to first {i in 1..n,  p in 1..length(s[i])-1}: x[i,p] <= x[i,p+1]-1;
# mes petit que la suma total de les llargades de les sequencies
subject to second {i in 1..n,  p in 1..length(s[i])}: x[i,p] <= l;
# nomes poden estar alineats si son iguals
subject to third {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j]): m[i,j,p,q]=0}: y_1[i,j,p,q]+y_2[i,j,p,q] = 1;
subject to fourth {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j]): m[i,j,p,q]=0}: x[j,q]+0.5 <= x[i,p] + M*(1-y_1[i,j,p,q]);
subject to fifth {i in 1..n-1, j in i+1..i+1, p in 1..length(s[i]), q in 1..length(s[j]): m[i,j,p,q]=0}: x[i,p]+0.5 <= x[j,q] + M*(1-y_2[i,j,p,q]);

#solve;

#display x;

end;

