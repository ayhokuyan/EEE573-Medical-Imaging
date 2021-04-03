close all; clear all;
load('MPI_data.mat');
%% PART A 
figure();
x = linspace(0,45,19);
y = linspace(0,15,11);
imshow(MPI_image, []);
axis('on');
xticks(x*(1500/45));
xticklabels(string(linspace(-45,45,19)));
yticks(y*(500/15));
yticklabels(string(linspace(-15,15,11)));

%% PART B
fwhm = [];
for i=0:2
    img = MPI_image(:,500*i+1:500*i+500);
    axis = img(:,250);
    
    [M,I] = max(axis);
  
    half_max = [];
    for i=1:size(axis)
        if(abs(axis(i) - M/2) < 0.0068 * M/2)
            half_max = [half_max i];
        end
    end
    add = (half_max(end) - half_max(1)).*3./50;
    fwhm = [fwhm add];   
end

disp(fwhm)

%% PART C
snrs = [];
for i=0:2
    img = MPI_image(:,500*i+1:500*i+500);
    %selected upper left corner, a 50x50region
    noise_region = MPI_image(1:50,1:50);
    stdev = std(noise_region, 0, 'all');
    max_val = max(img, [], 'all');
    snr = max_val./stdev;
    snrs = [snrs snr];
end

disp(snrs)

%% PART D
load('vessel.mat');
figure()
imshow(vessel_phantom, []);
figure()
subplot(1,3,1)
imshow(vessel_image_1, []);
title('Phantom Image 1');
subplot(1,3,2)
imshow(vessel_image_2, []);
title('Phantom Image 2');
subplot(1,3,3)
imshow(vessel_image_3, []);
title('Phantom Image 3');

scale = [0,44.1412];
dec = ifft2c(fft2c(vessel_image_1)./fft2c(vessel_phantom));
dec1 = ifft2c(fft2c(vessel_image_2)./fft2c(vessel_phantom));
dec2 = ifft2c(fft2c(vessel_image_3)./fft2c(vessel_phantom));
merged = [dec(750:1250,750:1250) dec1(750:1250,750:1250) dec2(750:1250,750:1250)];
figure();
imshow(merged, [scale])



    
    
    
    