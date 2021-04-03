close all; clear;
x = linspace(-15,15, 1000);
R = 15; mu1 = 0.25; mu2 = 0.05; mu3 = 0.35;
fx = [];
for xi = x
    fx = [fx f(xi,R,mu1,mu2,mu3)];
end
plot(x,fx)    
disp(size(fx'))
title('Projection Sketch g(l,45)')
xlabel('x (cm)')
figure()
backproj = iradon(fx', 45, 'none');
imshow(backproj, [])



function res=f(l,r,mu1,mu2,mu3)
    if(l>(-r*sqrt(2)/2) && l<=0)
        res = mu1*(r*sqrt(2)/2 + sqrt(r^2+l^2) + 2*l) - mu2*(2*l);
    elseif(l>0 && l<=(r*sqrt(2)/2))
        res = mu1*(r*sqrt(2)/2 + sqrt(r^2-l^2) - 2*l) + mu3*(2*l);
    elseif(l>(r*sqrt(2)/2) && l<r)
        res = mu3 * (2*sqrt(r^2-l^2));
    else
        res = 0;
    end
end