close all; clear;
load('brainT1_mri.mat');
% convert angles to radians
flip_degree = flip_degree .* pi ./ 180; 
%% c) Display noise-free images and find T1
figure()
sgtitle('Noise-Free Images')

subplot(1,2,1)
imshow(image1, [])
title('image 1')
subplot(1,2,2)
imshow(image2, [])
title('image 2')

div = (log(image2./tan(flip_degree(2))-image1./tan(flip_degree(1)))-log(image2./sin(flip_degree(2))-image1./sin(flip_degree(1))));
T1map = real(TR./div);
figure()
imshow(T1map,[])
title('T1 Map')
%% d) 
figure; 
imshow(T1map,[]);
BW = roiellipse;
T1_est = mean(T1map(BW));
disp(T1_est)
% T1est for White Matter = 500.00
%% e)
figure; 
imshow(T1map,[]);
BW = roiellipse;
T1_est = mean(T1map(BW));
disp(T1_est)
% T1est for Gray Matter = 833.00
figure; 
imshow(T1map,[]);
BW = roiellipse;
T1_est = mean(T1map(BW));
disp(T1_est)
% T1est for CSF = 2569.00
%% f) Display noisy images and find T1
figure()
sgtitle('Noisy Images')

subplot(1,2,1)
imshow(image1_noisy, [])
title('image 1')
subplot(1,2,2)
imshow(image2_noisy, [])
title('image 2')

div = (log(image2_noisy./tan(flip_degree(2))-image1_noisy./tan(flip_degree(1)))-log(image2_noisy./sin(flip_degree(2))-image1_noisy./sin(flip_degree(1))));
T1map = real(TR./div);
figure()
imshow(abs(T1map),[0 3000])
title('T1 Map')
%% g) 
figure; 
imshow(abs(T1map),[0 3000]);
BW = roiellipse;
T1_est = mean(T1map(BW));
disp(T1_est)
% T1est for White Matter = 500.3234
figure; 
imshow(abs(T1map),[0 3000]);
BW = roiellipse;
T1_est = mean(T1map(BW));
disp(T1_est)
% T1est for Gray Matter = 837.6729
figure; 
imshow(abs(T1map),[0 3000]);
BW = roiellipse;
T1_est = mean(T1map(BW));
disp(T1_est)
% T1est for White Matter = 2537.8