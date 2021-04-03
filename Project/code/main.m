% first, add the folder resource to your path by Home > Environment > Set 
% Path > Add with Subfolders and select the 'resource' and 'data' folders. 

%% load the anatomical data and create respective parameter maps. 
[T1map, T2map, T2smap, PDmap, CSHmap] = load_data();

%% select slice
G_z = 4e-2; %4G/cm in T/m
v_bar_frac = 0.5;
slice_thic = 1;
tp = 1e-6;
[T1sl, T2sl, T2ssl, PDsl, CSHsl, alpha] = slice_select(T1map, T2map, T2smap, ...
                                        PDmap,CSHmap, G_z, v_bar_frac, ...
                                        slice_thic);
                                    
[s0, gx_t, gy_t] = compute_k(alpha, T1sl, T2sl, T2ssl, PDsl, CSHsl, 'Proton Density');
reconstruction = reconstruct_image(s0);
figure;
imshow(abs((reconstruction)), [])