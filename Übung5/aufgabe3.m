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
    
%sys = ss(A,B,C,0)
    
% get current eigenvalues
% eigen =
%         0
%   -5.5931
%   -0.5787
%    5.5108
eigen = eig(A)

% move poles so that all are negative
poles = eigen - 6

% calc K Matrix
K = place(A,B,poles);
disp("K =")
disp(K)