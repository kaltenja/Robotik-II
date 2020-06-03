% Zustandsraummodell der Regelstrecke
A=[0, 1; -5, -2]
B=[0, 0; 5, 0.25]
C=[1, 0]
D=0

strecke = ss(A, B, C, D)
#step(strecke)
impulse(strecke)