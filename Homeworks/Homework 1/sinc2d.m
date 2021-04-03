function [sig, X, Y] = sinc2d(min,max,num_pts, alph1, alph2)
% creates a 2d sinc function
%
% sig = sinc(alph1x,alph2y)
x = linspace(min,max,num_pts);
y = x;
[X,Y] = meshgrid(x,y);
sig = sinc(X.*alph1) * sinc(Y.*alph2);
end