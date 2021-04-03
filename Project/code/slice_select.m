function [T1sl, T2sl, T2ssl, PDsl, CSHsl, alpha_mat] = slice_select(T1map,T2map,T2smap, ...
                                        PDmap,CSHmap, G_z, v_bar_frac, ...
                                        slice_thic, contrast_mode, pulse_type, tp)
    % get data dimensions
    dims = size(T1map);
    Z_max = dims(3);
    
    % find the frequrncy range for the anatomical model
    V_LOW = constants.GMR * constants.B_0;
    V_DIF = constants.GMR * G_z * Z_max;
    V_HIGH = V_LOW + V_DIF; %281MHz
        
    % set location using a multiplier on the min-max frequency range 
    v_bar = V_LOW + V_DIF * v_bar_frac; %Hz
    
    % set slice thickness over unit slice  (1mm)
    delta_v_unit = constants.GMR * G_z; %1703200;
    delta_v = delta_v_unit * slice_thic;
    
    % set the freqency axis 
    v_base = linspace(V_LOW, V_HIGH, dims(3));
    
    % set the realistic rect width for realistic slice selection (NOT USED)
    % tp = 1e10; %s
    
    % set alpha
    if strcmp(contrast_mode, 'T2') && strcmp(pulse_type, 'grad')
        A = pi / 9;
    else
        A = pi / 2;
    end
    
    % find the alpha angles for z-axis
    if nargin == 10
        [alpha, z] = rf(v_base, A, delta_v, v_bar, G_z);
    elseif nargin == 11
        [alpha, z] = rf(v_base, A, delta_v, v_bar, G_z, tp);
    else
        error('Wrong number of input arguments in slice selection');
    end

    % select slices
    T1sl = T1map(:,:,alpha>0);
    T2sl = T2map(:,:,alpha>0);
    T2ssl = T2smap(:,:,alpha>0);
    PDsl = PDmap(:,:,alpha>0);
    CSHsl = CSHmap(:,:,alpha>0);
    
    alpha = alpha(alpha > 0);
    alpha_mat = zeros(dims(1),dims(2), slice_thic);
    for z = 1:slice_thic
        alpha_mat(:,:,z) = alpha(z);
    end
       
end