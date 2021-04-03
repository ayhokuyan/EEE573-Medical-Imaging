close all; clear;
% generate phantom image
p = phantom('Modified Shepp-Logan',256);

%% a) display p
figure()
imshow(p, [])
title('Ideal Image')

%% b) take radon transform and backproject
NUM_ANGLES_SUFF = 120;
angles = linspace(0,179, NUM_ANGLES_SUFF);
projections = radon(p, angles);
figure()
subplot(1,2,1);
colormap(gray);
imagesc(projections);

title('Sinogram')
backproj = iradon(projections, angles);
subplot(1,2,2)
imshow(backproj, [])
title(['Backprojected Image for ', num2str(NUM_ANGLES_SUFF) ' Angles'])

%% c) plot projections for 0,45,90,135
% we ahve used linear spacing for angles, so we again use radon transform
% the get the desired projections. 
angles = [0,45,90,135];
[projections,xp] = radon(p, angles);
figure()
for i=1:4
    subplot(1,4,i)
    plot(xp,projections(:,i),'color', 'black');
    title(['Projection at \theta=', num2str(angles(i)), '°']);
end
sgtitle('Projections of the Ideal Image P')

%% d) repeat part b for fewer number of projections 
NUM_ANGLES_INSUF = 40;
angles = linspace(0,179,NUM_ANGLES_INSUF);
projections = radon(p, angles);
figure()
subplot(1,2,1);
colormap(gray);
imagesc(projections);
title('Sinogram')
backproj = iradon(projections, angles);
subplot(1,2,2)
imshow(backproj, [])
title(['Backprojected Image for ', num2str(NUM_ANGLES_INSUF), ' Angles'])
% This is the aliasing artifcat in CT resulting from the insufficient
% number of projections. 

%% e) repeat b with three types of filters. 
angles = linspace(0,179, NUM_ANGLES_SUFF);
projections = radon(p, angles);
figure()
filters = ["Ram-Lak", "Hamming", "none"];
num_filters = size(filters);
for i=1:num_filters(2)
    backproj = iradon(projections, angles, filters(i));
    subplot(1,num_filters(2),i)
    imshow(backproj, [])
    if i==3
        title('No filter')
    else
        title(filters(i) + ' Filter')
    end
end
sgtitle('Backprojections with Various Filters') 

%% f) repeat part e for d
angles = linspace(0,179, NUM_ANGLES_INSUF);
projections = radon(p, angles);
figure()
filters = ["Ram-Lak", "Hamming", "none"];
num_filters = size(filters);
for i=1:num_filters(2)
    backproj = iradon(projections, angles, filters(i));
    subplot(1,num_filters(2),i)
    imshow(backproj, [])
    if i==3
        title('No filter')
    else
        title(filters(i) + ' Filter')
    end
end
sgtitle('Backprojections with Various Filters') 

