% Zustandsraummodell der Regelstrecke
A = [0, 1; -1, 1];
B = [0; 0.5];
C = [1, 0];
D = 0;
strecke = ss(A, B, C, D);

%% Zustandsrückführung

% Voraussetzung der vollständigen Steuerbarkeit prüfen
if rank(ctrb(strecke)) < size(A, 1)
    error('Die Regelstrecke ist nicht vollständig steuerbar!');
end

% Voraussetzung der vollständigen Beobachtbarkeit prüfen
if rank(obsv(strecke)) < size(A, 1)
    error('Die Regelstrecke ist nicht vollständig beobachtbar!');
end

% Berechnung des Verstärkungsvektors K für Eigenwertvorgaben bei -3 und -4
K = place(A, B, [-3, -4]);

% Vorfilter zur Sicherung der Sollwertfolge
V = -inv(C*inv(A-B*K)*B);

% Eigenwerte des Beobachters: -9 und -12 (liegen weiter links der
% Eigenwerte des geschlossenen Regelkreies (-3, -4) und sind so gewählt, 
% dass der Realteil der Beobachtereigenwerte 3 mal größer ist)
Lt = place(A', C', [-9, -12]);
L = Lt';

% Zustandsraummodell des geschlossenen Regelkreises mit Vorfilter und Beobachter
% Zustand: [x(t); xhat(t)]
A_ZR_OBS = [A, - B*K; L*C, A-L*C-B*K];
B_ZR_OBS = [B*V; B*V];                   
C_ZR_OBS = [C, zeros(size(C))];
D_ZR_OBS = D;
kreis_beobachter = ss(A_ZR_OBS, B_ZR_OBS, C_ZR_OBS, D_ZR_OBS);

%% Simulation
t = (0:0.01:8)';

% Sollwert = Sprung
w = ones(size(t));

% Anfangszustand der Regelstrecke
x0 = [ -1; 1];

% Anfangszustand des Beobachters, Fehleinschätzung des Anfangszustands der Regelstrecke
x0hat = [ -2; 2];  

% Simulation
[y, ~, x_xhat] = lsim(kreis_beobachter, w, t, [x0; x0hat]);

% Plot der Ausgabe, Zustandsvariablen und geschätzten Zustandsvariablen
figure(1);

subplot(3,1,1);
plot(t, y);
grid on;
ylabel('Ausgabe y [cm]');

subplot(3,1,2);
plot(t, x_xhat(:,1), 'b', t, x_xhat(:,3), 'r');
grid on;
ylabel('x_1 / xhat_1  [cm]');
legend({'Zustand x_1', 'geschätzter Zustand xhat_1'});

subplot(3,1,3);
plot(t, x_xhat(:,2), 'b', t, x_xhat(:,4), 'r');
grid on;
ylabel('x_2 / xhat_2 [cm/s]');
xlabel('Zeit [s]');
legend({'Zustand x_2', 'geschätzter Zustand xhat_2'});
