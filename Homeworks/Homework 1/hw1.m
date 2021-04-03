close all; clear all;
%%
P = phantom('Modified Shepp-Logan', 512);
%% Part A
figure();
subplot(1,2,1)
imshow(P)
title("The Ideal Image P")
subplot(1,2,2)
F = fft2c(P);
imshow(log(abs(F)+1),[])
title("Magnitude Spectrum of P")

%% Part B
figure()
%% H-1
subplot(3,3,1)
x=linspace(-25,25,512); 
y=x; 
h1 = (transpose(sinc(x./8))*sinc(y./2)).^4;
surf(x,y,h1,'LineStyle','none')
title("PSF h_1 in 3-D")
subplot(3,3,2)
contour(x,y,h1)
title("Contour Plot of h_1")
subplot(3,3,3)
H1 = fft2c(h1);
imshow(log(abs(H1)+1),[])
title("Magnitude Spectrum of H_1")

%% H-2
subplot(3,3,4)
std = 2;
x = linspace(-25,25,512);
y = x;
[X,Y] = meshgrid(x,y);
h2 = (1/(2*pi*std.^2))*exp(-(X.^2+Y.^2)/(2*std.^2));
surf(X,Y,h2,'LineStyle','none')
title("PSF h_2 in 3-D")
subplot(3,3,5)
contour(X,Y,h2)
title("Contour Plot of h_2")
subplot(3,3,6)
H2 = fft2c(h2);
imshow(log(abs(H2)+1),[])
title("Magnitude Spectrum of H_2")

%% H-3
subplot(3,3,7)
min = -25; max = 25; num_pts = 512;
x = linspace(min,max,num_pts);
y = x;
h3 = rect(min,max,num_pts,1/6,1/2);
surf(x,y,h3,'LineStyle','none')
title("PSF h_3 in 3-D")
subplot(3,3,8)
contour(x,y,h3)
title("Contour Plot of h_3")
subplot(3,3,9)
H3 = fft2c(h3);
imshow(log(abs(H3)+1),[])
title("Magnitude Spectrum of H_3")

%% Part C
%% G-1
figure()
subplot(3,3,1)
G1 = F.* H1;
g1 = ifft2c(G1);
imshow(mat2gray(g1))
title("Output Image w/IFFT (H_1)")
subplot(3,3,2)
g1 = conv2(P,h1);
imshow(mat2gray(g1))
title("Output Image w/Convolution (h_1)")
subplot(3,3,3)
imshow(log(abs(G1)+1),[])
title("Magnitude Spectrum of G_1")

subplot(3,3,4)
G2 = F .* H2;
g2 = ifft2c(G2);
imshow(mat2gray(g2))
title("Output Image w/IFFT (H_2)")
subplot(3,3,5)
g2 = conv2(P,h2);
imshow(mat2gray(g2))
title("Output Image w/Convolution (h_2)")
subplot(3,3,6)
imshow(log(abs(G2)+1),[])
title("Magnitude Spectrum of G_2")

subplot(3,3,7)
G3 = F .* H3;
g3 = ifft2c(G3);
imshow(mat2gray(g3))
title("Output Image w/IFFT (H_3)")
subplot(3,3,8)
g3 = conv2(P,h3);
imshow(mat2gray(g3))
title("Output Image w/Convolution (h_3)")
subplot(3,3,9)
imshow(log(abs(G3)+1),[])
title("Magnitude Spectrum of G_3")
