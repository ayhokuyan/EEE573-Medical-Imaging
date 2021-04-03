function [s0, gx_t, gy_t, t_space] = compute_k(alpha, T1sl, T2sl, T2ssl, PDsl, CSHsl, mode, contrast, pulse_type, add_noise)
    % Define TR, TE
    switch contrast
        case 'T1'
            TE = 0.014;
            TR = 0.5;
        case 'T2'
            TE = 0.03;
            TR = 4;
            if strcmp(pulse_type, 'spin')
                TE = 0.1;
            end
        case 'PD'
            TE = 0.014;
            TR = 6;                   
    end
    
    % Define space variables
    xFov = 181;
    yFov = 217;
    xSpace = -90:90;
    ySpace = -108:108;
    [kX, kY] = meshgrid(xSpace, ySpace);

    % Define G values corresponding to kspace coords
    Gx_0 = 1 / (xFov * constants.GMR * constants.TS_1);

    Gy_0 = 1.5e-7;
    Gy_area = 1 / (constants.GMR * yFov);
    Gy_duration = Gy_area / Gy_0;

    timestamps = TE + kX .* constants.TS_1; % only depends on kX since we switch to a new line every TR

    % Plot Gy, Gx pulses
    t_space = 0:0.0001:TE + constants.TS_1 * constants.xFov / 2;
    gx_t = zeros(length(t_space));
    gy_t = zeros(length(t_space));

    for i = 1:length(t_space)
        [gx_t(i), gy_t(i)] = generate_g_t(Gx_0, Gy_0, Gy_duration, TE, pulse_type, t_space(i));
    end
    
    if add_noise == 1
        noise = sqrt(constants.B_0 * 1e-3) .* randn(yFov, xFov);
    else
        noise = 0;
    end   
     
    % Acquire f(x, y)
    f_xy = (noise + constants.B_0) .* (1 - exp( - TR ./ T1sl)) .* ...
        (1 ./ (1 - cos(alpha) .* exp( - TR ./ T1sl)) );

    if mode(1) == 1
        if strcmp(pulse_type, 'grad')
            f_xy = f_xy .* exp( - timestamps ./ T2ssl);
        elseif strcmp(pulse_type, 'spin')
            f_xy = f_xy .* exp( - timestamps ./ T2sl);
        end
    end

    if mode(2) == 1
        f_xy = (1 - CSHsl) .* f_xy;
    end

    if mode(3) == 1
        f_xy = f_xy .* constants.GMR_nor.^2 * constants.PLANCK.^2 ./ ...
                (4 * constants.BOLTZMANN * constants.T) .* PDsl;
    end
    
    % Compute k_space data
    s0 = zeros(yFov, xFov); % delta x = delta y = 1
    for y = 1:yFov
        for x = 1:xFov
            s0(y, x) = sum(f_xy .* exp(- 2 * pi * 1j * constants.GMR * ...
                ((- Gx_0 * (xFov * constants.TS_1 / 2)) + kX .* Gx_0 * constants.TS_1 * x + ...
                kY .* Gy_0 * (y - floor(yFov / 2)) * Gy_duration)), 'all');
        end
    end
    
end

function [gx_t, gy_t] = generate_g_t(Gx_0, Gy_0, Gy_duration, TE, pulse_type, t)
    switch pulse_type
        case 'grad'
            if (t > TE - constants.TS_1 * constants.xFov - Gy_duration && t <= TE - constants.TS_1 * constants.xFov)
                gx_t = 0;
                gy_t = Gy_0;  
            elseif (t > TE - constants.TS_1 * constants.xFov && t <= TE - constants.TS_1 * constants.xFov / 2)
                gx_t = - Gx_0;
                gy_t = 0;
            elseif (t > TE - constants.TS_1 * constants.xFov / 2 && t <= TE + constants.TS_1 * constants.xFov / 2)
                gx_t = Gx_0;
                gy_t = 0;
            else
                gx_t = 0;
                gy_t = 0;
            end
        case 'spin'
            if (t > 0 && t <= Gy_duration)
                gx_t = 0;
                gy_t = Gy_0;  
            elseif (t > Gy_duration && t <= Gy_duration + constants.TS_1 * constants.xFov / 2)
                gx_t = Gx_0;
                gy_t = 0; 
            elseif (t > TE - constants.TS_1 * constants.xFov && t <= TE - constants.TS_1 * constants.xFov / 2)
                gx_t = Gx_0;
                gy_t = 0;
            elseif (t > TE - constants.TS_1 * constants.xFov / 2 && t <= TE + constants.TS_1 * constants.xFov / 2)
                gx_t = Gx_0;
                gy_t = 0;
            else
                gx_t = 0;
                gy_t = 0;
            end
    end
end

