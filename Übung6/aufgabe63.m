A = [1 -1; -3 2];
B = [1; 1];
C = [-9 7];
D = 0;

% a)
% ZMR ohne Zustandsrückführung
sys = ss(A,B,C,D);
% gewünscht Pole
poles = [-2 -1];

% Berechnung der Regelmatrix K und Vorfilter V 
K = place(A, B, poles);
V = -inv(C * inv(A-B*K)*B);

% neues ZMR
A_ZR = A - B*K;
B_ZR = B * V;
C_ZR = C;
D_ZR = D;

% ZMR mit Zustandsrückführung
sys_2 = ss(A_ZR, B_ZR, C_ZR, D_ZR)


% b)
% Test auf vollständige Beobachtbarkeit
rank(obsv(sys))

% Test ob direkt Erstzung möglich ist
rank([C;K])
rank(C)

% direkte Ersetzung ist möglich, weil rank([C;K]) = rank(C)
% Wichtungsmatrix als Diagonalmatrix
W = diag([1,1]);
[V, lambda] = eig(A_ZR)
Ky = K * V * W * transpose(C * V * W) * inv((C * V * W) * transpose(C * V * W));

% neuer Vorfilter
Vy = -inv(C * inv(A - B * Ky * C)*B);

% ZMR mit approximierter Zustandsrückführung durch Ausgangsrückführung
A_AR = A - B*Ky*C;
B_AR = B * Vy;
C_AR = C;
D_AR = D;

sys_3 = ss(A_AR, B_AR, C_AR, D_AR)

step(sys_3)