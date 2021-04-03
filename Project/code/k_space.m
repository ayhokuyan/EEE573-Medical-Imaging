%% load the anatomical data and create respective parameter maps. 
[T1map,T2map,T2smap,PDmap,CSHmap] = load_data();
dims = size(T1map);
%% get alphas slice_selection
close all;

B_0 = 3; %T
G_z = 4e-2; %4G/cm in T/m
V_LOW = 0; %0
V_HIGH = 281028000; %281MHz
V_DIF = V_HIGH - V_LOW;
v_bar = V_DIF * 0.5; %Hz
delta_v = 1703200; %such that slice thickness is 1mm
v_base = linspace(V_LOW, V_HIGH, dims(3));
tp = 1e10; %s
A = 1./(4 * constants.GMR);

[alpha, z] = rf(v_base, A, delta_v, v_bar, B_0, G_z);
%% get the slice(s)
T1sl = T1map(:,:,alpha>0);
T2sl = T2map(:,:,alpha>0);
T2ssl = T2smap(:,:,alpha>0);
PDsl = PDmap(:,:,alpha>0);
CSH_sl = CSHmap(:,:,alpha>0);

%% Create k-space
s0 = compute_k(alpha, T1sl, T2sl, T2ssl, PDsl, CSH_sl, 'Ideal');
reconstruction = reconstruct_image(s0);
figure;
imshow(abs(fftshift(reconstruction)), [])

function [T1sl, T2sl, T2ssl, PDsl, CSHsl] = select_slice(T1map,T2map,T2smap,PDmap,CSHmap,B_0, G_z, v_bar_frac, delta_v_mul)
    dims = size(T1map);
    
    V_LOW = 0; %0
    V_HIGH = 281028000; %281MHz
    V_DIF = V_HIGH - V_LOW;
    v_base = linspace(V_LOW,V_HIGH,dims(3)); % given such that the z_base covers from [-90,90] mms (181 slices)
    
    tp = 1e10; %s
    A = 1./(4*constants.GMR);
end