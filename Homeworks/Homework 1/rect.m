function sig=rect(min,max,num_pts, alph1, alph2)
% 2-D rectangle function
% g(x,y) = rect(alph1*x,alph2*y)
% Takes two separate 1-D rectangle functions and multiplies them 
width = 0.5;
base = linspace(min,max,num_pts);
sigx = double(abs(base) <= width./alph1);
sigy = double(abs(base) <= width./alph2);
sig = transpose(sigx) * sigy;
end
