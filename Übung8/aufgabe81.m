A = [0, -1; 1, -2];
B = [0; 0.5];
C = [0, 1];
D = 0;
strecke = ss(A, B, C, D);

Lt = place(A', C', [-4, -3]);
L = Lt';

e = [0; 1];

A_STR_OBS = [A, zeros(size(A)); L*C, A-L*C];
B_STR_OBS = [B, e; B, zeros(size(e))];                   
C_STR_OBS = [C, zeros(size(C))];
D_STR_OBS = D;
strecke_beobachter = ss(A_STR_OBS, B_STR_OBS, C_STR_OBS, D_STR_OBS)
t = (0:0.01:8)';

% Anfangszustand der Regelstrecke
x0 = [ -1; 1];
% Anfangszustand des Beobachters
x0hat = [ -2; 2];

%% Sollwert = Sprung; Störgröße = 0
u = [ones(length(t),1), zeros(length(t),1)];
[y, ~, x_xhat] = lsim(strecke_beobachter, u, t, [x0; x0hat]);

% Plot der Ausgabe, Zustandsvariablen und geschätzten Zustandsvariablen
graphics_toolkit("gnuplot");
figure(1);
subplot(3,1,1);
plot(t, y);
grid on;
title('Sprungantwort ohne Störgröße');
ylabel('Ausgabe y [cm]');
subplot(3,1,2);
plot(t, x_xhat(:,1), 'b', t, x_xhat(:,3), 'r');
grid on;
ylabel('x_1 / xhat_1 [cm]');
legend({'Zustand x_1', 'geschätzter Zustand xhat_1'}, 'Location', 'SouthEast');
subplot(3,1,3);
plot(t, x_xhat(:,2), 'b', t, x_xhat(:,4), 'r');
grid on;
ylabel('x_2 / xhat_2 [cm/s]');
xlabel('Zeit [s]');
legend({'Zustand x_2', 'geschätzter Zustand xhat_2'}, 'Location', 'NorthEast');


%% Sollwert = Sprung; Störgröße = Impuls
u = [ones(length(t),1), [1/0.01;zeros(length(t)-1,1)]];
[y, ~, x_xhat] = lsim(strecke_beobachter, u, t, [x0; x0hat]);

% Plot der Ausgabe, Zustandsvariablen und geschätzten Zustandsvariablen
figure(2);
subplot(3,1,1);
plot(t, y);
grid on;
title('Sprungantwort bei IMPULSFÖRMIGER Störgröße');
ylabel('Ausgabe y [cm]');
subplot(3,1,2);
plot(t, x_xhat(:,1), 'b', t, x_xhat(:,3), 'r');
grid on;
ylabel('x_1 / xhat_1 [cm]');
legend({'Zustand x_1', 'geschätzter Zustand xhat_1'}, 'Location', 'SouthEast');
subplot(3,1,3);
plot(t, x_xhat(:,2), 'b', t, x_xhat(:,4), 'r');
grid on;
ylabel('x_2 / xhat_2 [cm/s]');
xlabel('Zeit [s]');
legend({'Zustand x_2', 'geschätzter Zustand xhat_2'}, 'Location', 'NorthEast');


%% Sollwert = Sprung; Störgröße = Sprung
u = [ones(length(t),1), 2*ones(length(t),1)];
[y, ~, x_xhat] = lsim(strecke_beobachter, u, t, [x0; x0hat]);

% Plot der Ausgabe, Zustandsvariablen und geschätzten Zustandsvariablen
figure(3);
subplot(3,1,1);
plot(t, y);
grid on;
title('Sprungantwort bei SPRUNGFÖRMIGER Störgröße');
ylabel('Ausgabe y [cm]');
subplot(3,1,2);
plot(t, x_xhat(:,1), 'b', t, x_xhat(:,3), 'r');
grid on;
ylabel('x_1 / xhat_1 [cm]');
legend({'Zustand x_1', 'geschätzter Zustand xhat_1'}, 'Location', 'SouthEast');
subplot(3,1,3);
plot(t, x_xhat(:,2), 'b', t, x_xhat(:,4), 'r');
grid on;
ylabel('x_2 / xhat_2 [cm/s]');
xlabel('Zeit [s]');
legend({'Zustand x_2', 'geschätzter Zustand xhat_2'}, 'Location', 'NorthEast');


%% Sollwert = Sprung; Störgröße = Normalverteilung mit Mittelwert 0 und Standardabweichung 2
r = 0 + 2*randn(length(t),1);
u = [ones(length(t),1), r];
[y, ~, x_xhat] = lsim(strecke_beobachter, u, t, [x0; x0hat]);

% Plot der Ausgabe, Zustandsvariablen und geschätzten Zustandsvariablen
figure(4);
subplot(3,1,1);
plot(t, y);
grid on;
title('Sprungantwort bei NORMALVERTEILTER Störgröße');
ylabel('Ausgabe y [cm]');
subplot(3,1,2);
plot(t, x_xhat(:,1), 'b', t, x_xhat(:,3), 'r');
grid on;
ylabel('x_1 / xhat_1 [cm]');
legend({'Zustand x_1', 'geschätzter Zustand xhat_1'}, 'Location', 'SouthEast');
subplot(3,1,3);
plot(t, x_xhat(:,2), 'b', t, x_xhat(:,4), 'r');
grid on;
ylabel('x_2 / xhat_2 [cm/s]');
xlabel('Zeit [s]');
legend({'Zustand x_2', 'geschätzter Zustand xhat_2'}, 'Location', 'NorthEast');
