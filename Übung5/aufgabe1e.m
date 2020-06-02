clf
kp=90
s = tf('s')
g_mitV=(-kp*(kp-15)*(s+5))/((4*kp+15)*(s^2+2*s+kp-15))
g_ohneV=(kp*(s+5))/(s^2+2*s+kp-15)
step(g_ohneV,30)
#step(g_mitV,10)