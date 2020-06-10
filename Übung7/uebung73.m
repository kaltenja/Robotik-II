% ***************************************************************************************************************************
% Pendulum parameters

PendulumParameters;     % Set pendulum parameters
    
% ***************************************************************************************************************************

% Common denominator
d = J*m - mp^2*l^2;
    
% System matrix
A = [0, 1,          0,              0;
     0, -J*fc/d,   -mp^2*l^2/d*g,   mp*l*fp/d;
     0, 0,          0,              1;
     0, mp*l*fc/d,  m*mp*l/d*g,    -m*fp/d;];
    
% Input matrix
B = [ 0; J/d; 0; -mp*l/d];
    
% Output matrix: only cart position and pendulum position are measured
C = [ 1 0 0 0; 
     0 0 1 0];
 
D = 0;
    
sys = ss(A,B,C,D);

if rank(ctrb(sys)) < size(A, 1)
    error('nicht vollst. steuerbar')
else
    disp('vollst. steuerbar')
end

q = 1;  % default
%q = 100;  % "optimiert"
Q = q * eye(4);  % default
%Q = diag([1000 0.1 0.1 0.1])  % optimiert
R = 1;  % default

if ~issymmetric(Q)
    error('nicht symmetrisch')
else
    disp('symmetrisch')
end

[Qtilde, p] = chol(Q);

if p > 0
    error('nicht positiv definit')
else
    disp('positiv definit')
end

if rank(obsv(A, Qtilde)) < size(A, 1)
    error('A, Qtilde nicht vollst. beobachtbar')
else
    disp('A, Qtilde vollst. beobachtbar')
end

K = lqr(A, B, Q, R)

V = -pinv(C*inv(A-B*K)*B)  % Pseudoinverse, weil Matrix nicht quadratisch

sys = ss(A-B*K, B*V, C, D);

x0 = [0.3; 0; -0.15; 0];

[y, t, x] = initial(sys, x0, 20);
%initial(sys, x0, 20)

%Wagenposition: 
POSITION = lsiminfo(y(:,1), t, 0)
%Pendelwinkel:
WINKEL = lsiminfo(y(:,2), t, 0)

% R=1 q=0.1 => t_settle=8.9112
% R=1 q=1 => t_settle=5.0712
% R=1 q=10 => t_settle=4.0640
% R=1 q=100 => t_settle=3.8378
% R=1 q=1000 => t_settle=3.4455
% R=0.01 Q=diag(10^6 0.1 0.1 0.1) => t_settle=0.6829
lsiminfo(y(:,1),t,0,'SettlingTimeThreshold', 0.02/max(abs(y(:,1))))

1.0e04