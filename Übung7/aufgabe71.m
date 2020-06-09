A = [3, -3; -2, -3];
B = [2; 0.1];
C = [1, 0];
p = [-3; -0.1];
K = place(A,B,p);

[V, lambda] = eig(A - B*K);
#W = diag([1,1]);
W =[2, 0; 0, 1]
CVW = C*V*W;
CVWplus = CVW' * inv(CVW*CVW');
Ky = K*V*W*CVWplus;
VF = -inv(C*inv(A-B*Ky*C)*B);
A-B*Ky*C
B*VF
eig(A-B*Ky*C);