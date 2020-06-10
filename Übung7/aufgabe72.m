A = [0, 1; 1, 4];
B = [0; 1];
C = [1, 0]
Q = [48, 298; 298, 1866];
R = [2];
[X, L, K] = care(A, B, Q, R);
V = -inv(C*inv(A-B*K)*B);
A - B*K;
B*V