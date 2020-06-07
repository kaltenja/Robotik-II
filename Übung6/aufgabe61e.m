A = [0, 1; -5, -2];
B = [0; 0.5];
C = [1, 0];
D = 0;
E = [0; 0.25];
BE = [B, E]

sys = ss(A, [B, E], C, D);
t = (0:0.01:15);
d = [1/0.01; zeros(length(t)-1, 1)];

%sprung - sprung
y = lsim(sys, [d, d], t);
figure
plot(t, y)
title('Antwort des geschlossenen Regelkreises (sprungförmige Führungsgröße und sprungförmige Störgröße)')
xlabel('t in s')
ylabel('y(t)')
ylim([-1 5])

% sprung - impuls
d_2 = [1/0.01 + zeros((length(t) - 1)/20, 1); zeros(length(t)-(length(t) - 1)/20, 1)];
y = lsim(sys, [d, d_2], t);
figure
plot(t, y)
title('Antwort des geschlossenen Regelkreises (sprungförmige Führungsgröße und impulsförmige Störgröße)')
xlabel('t in s')
ylabel('y(t)')
ylim([-1 5])