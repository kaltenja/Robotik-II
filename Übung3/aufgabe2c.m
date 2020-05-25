R1=4
R2=4
C=1
L=16

a=[-1/(R1*C) 0; 0 -R2/L]
b=[1/(R1*C);1/L]
c=[-1/R1 1]
d=[1/R1]

sys=ss(a,b,c,d)

figure(1)
step(sys)

pole(sys)
zero(sys)