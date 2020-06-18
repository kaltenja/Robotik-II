%% ************************************************************************
% Pendulum parameters

    PendulumParameters;      % Set pendulum parameters

    x0 = [0; 0; pi-0.01; 0]; % Initial state of pendulum [ x[m], xdot[m/s], theta[rad], thetadot[rad/s] ]
    
    x0hat = [0; 0; pi; 0];   % Estimated initial state of pendulum [ x[m], xdot[m/s], theta[rad], thetadot[rad/s] ]

    sigmaCart = 0;           % Standard deviation of normally distributed measurement noise for cart encoder [m]
    sigmaPend = 0;           % Standard deviation of normally distributed measurement noise for pendulum encoder [rad]


%% ************************************************************************
% Parameters of state feedback controller

    % State feedback gains
    K = [  -9.999999999999652 -12.446220010731196 -53.821668633224220  -9.969947846723787 ];

    % Time constant of low pass filter for cart and pendulum velocities in state feedback controller
    Td = 0;


%% ************************************************************************
% Luenberger observer

    % define system matrices w/o state feedback
    d = J*m - mp^2*l^2;

    A = [0, 1,          0,              0;
        0, -J*fc/d,   -mp^2*l^2/d*g,   mp*l*fp/d;
        0, 0,          0,              1;
        0, mp*l*fc/d,  m*mp*l/d*g,    -m*fp/d;];

    B = [ 0; J/d; 0; -mp*l/d];

    C = [ 1 0 0 0; 
        0 0 1 0];

    D = 0;

    % system w/o state feedback
    sys = ss(A,B,C,D);

    % check if system is fully controllable 
    if rank(ctrb(sys)) < size(A, 1)
        error('vollständig steuerbar:       x');
    else
        disp('vollständig steuerbar:       ✓');
    end

    % define desired poles and calc feeback matrix K and prefilter V
    poles = [-10, -5, -4, -1];
    K = place(A,B,poles)
    %V = -pinv(C*inv(A-B*K)*B);

    % check if system is fully observable 
    if rank(obsv(sys)) < size(A, 1)
        error('vollständig beobachtbar:     x');
    else
        disp('vollständig beobachtbar:     ✓');
    end

    % calc feedback matrix L
    L = place(A', C', 2 * poles)';



%% ************************************************************************
% Parameters of swing-up controller

    ksu = 1.3;              % Swing-up gain
    kcw = 3;                % Cart position well gain
    kvw = 3;                % Cart velocity well gain
    kem = 7;                % Energy maintenance gain
    eta = 1.05;             % Energy maintenance parameter
    E0 = 0.05;              % Desired energy for swing-up 
    xmax = 0.4;             % Distance of cart position well in both directions from rail center [m]
    vmax = 5;               % "Distance" of cart veloctiy well in both directions [m/s]
    angleSZ = 0.25;         % Limit of stabilization zone on pendulum angle for switching to state feedback controller [rad]
