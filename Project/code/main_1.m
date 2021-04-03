% first, add the folder resource to your path by Home > Environment > Set 
% Path > Add with Subfolders and select the 'resource' and 'data' folders. 

%% load the anatomical data and create respective parameter maps. 
[T1map,T2map,T2smap,PDmap,CSHmap]=load_data();

%% select slice
G_z = 4e-2; %4G/cm in T/m
v_bar_frac = 0.5;
slice_thic = 1;
tp = 1e-6;
[T1sl, T2sl, T2ssl, PDsl, CSHsl, alpha] = slice_select(T1map,T2map,T2smap, ...
                                        PDmap,CSHmap, G_z, v_bar_frac, ...
                                        slice_thic);

%% Create k-space
xFov = 181; 
yFov = 217;
xResolution = 1;
yResolution = 1;
xSpace = -90:90;
ySpace = -108:108;
[kX, kY] = meshgrid(xSpace, ySpace);

% Define G values corresponding to kspace coords (bunlar? elle hesaplad?m xd ch13-p14)
% Gx = zeros(xFov, 1) + 1 / (xFov * constants.GMR * constants.TS_1);
Gx_0 = 1 / (xFov * constants.GMR * constants.TS_1);
% Gx = zeros(xFov, 1);
% Gx(1:floor(xFov / 3)) = - Gx_0;
% Gx(floor(xFov / 3) + 1:xFov) = Gx_0;

% Enough to cover the max ky distance in a short time
Gy_0 = 1.5e-7;
Gy_area = 1 / (constants.GMR * yFov);
Gy_duration = Gy_area / Gy_0;
Gy = ySpace .* Gy_0;

timestamps = constants.TE + kX .* constants.TS_1; % only depends on kX since we switch to a new line every TR

% find chemical shifted B_0
B_0_shift = constants.B_0 * (1 - CSHsl);

% Find magnetization with Proton Density 
% M = B_0*GMR(no bar)^2*planck^2 / 4*Boltzmann*T
M_0 = (B_0_shift * constants.GMR_nor.^2 * constants.PLANCK.^2 ./ ...
    (4 * constants.BOLTZMANN * constants.T)) .* PDsl;

% sum magnetization, T1, T2, T2* over slices


% Acquire f(x, y)
f_xy = M_0 .* (1 - exp( - constants.TR ./ T1sl)) .* ...
    (1 ./ (1 - cos(alpha) .* exp( - constants.TR ./ T1sl)) ) .* ...
    exp( - timestamps ./ T2ssl);

% Compute k_space data
s0 = zeros(yFov, xFov); % delta x = delta y = 1
for y = 1:yFov
    for x = 1:xFov
        s0(y, x) = sum(f_xy .* exp(- 2 * pi * 1j * constants.GMR * ...
            ((- Gx_0 * (xFov * constants.TS_1 / 2)) + kX .* Gx_0 * constants.TS_1 * x + ...
            kY .* Gy_0 * (y - floor(yFov / 2)) * Gy_duration)), 'all');
%         s0(y, x) = sum(f_xy .* exp(- 2 * pi * 1j * constants.GMR * (kX .* Gx(x) + kY .* Gy(y))), 'all');
    end
end

reconstruction = zeros(yFov, xFov); % delta x = delta y = 1
for v = 1:yFov
    for u = 1:xFov
        reconstruction(v, u) = (1 / (xFov * yFov)) .* sum(s0 .* exp(2 * pi * 1j * (kY .* (v / yFov) + kX .* (u / xFov))), 'all');
    end
end

figure()
imshow(abs(fftshift(reconstruction)), [])

