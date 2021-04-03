u = linspace(0,0.5,100);
figure();
subplot(2,1,1);
plot(u,exp(-32*pi.^2*u.^2));
title('MTF(u,0)')
xlabel('u')
subplot(2,1,2);
plot(u,exp(-8*pi.^2*u.^2));
title('MTF(0,v)')
xlabel('v')
