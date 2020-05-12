R1=2
R2=2
C=0.5
L=2

a=[-1/R1*C 0; 0 -R2/L]
b=[1/R1*C;1/L]
c=[-1/R1 1]
d=[1/R1]

sys=ss(a,b,c,d)

figure(1)
step(sys)

pole(sys)
zero(sys)