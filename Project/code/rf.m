function [alpha,zs] = rf(v_base, A, delta_v, v_bar, G_z, tp)
    if nargin == 6
        [alpha,zs] = rf_r(v_base, A, delta_v, v_bar, G_z, tp);
    elseif nargin == 5
        [alpha,zs] = rf_nr(v_base, A, delta_v, v_bar, G_z);
    else
        error('Number of parameters are incorrect for RF')
    end
end

% realistic slice selection
function [alpha_z,z_base] = rf_r(v_base, A, delta_v, v_bar, G_z, tp)
    z_base = (v_base ./ (constants.GMR) - constants.B_0)./G_z;
    z_bar = (v_bar ./ (constants.GMR) - constants.B_0)./G_z;
    delta_z = delta_v ./ (constants.GMR.*G_z);
    z_shift = floor(length(z_base/2)); 
    sinc_inf = tp.* sinc(tp.*constants.GMR.*(constants.B_0 + G_z .* (z_base-z_shift)));
    % figure();plot(sinc_inf);title('sinc_inf')
    trunc = sinc_inf(z_shift-tp:z_shift+tp);
    % figure();plot(trunc);title('trunc')
    alpha_z = conv(rect(z_base, A, z_bar, delta_z),trunc, 'same');
end

% non-realistic slice selection
function [alpha_z,z_base] = rf_nr(v_base, A, delta_v, v_bar, G_z)
    z_base = (v_base ./ (constants.GMR) - constants.B_0)./G_z;
    z_bar = (v_bar ./ (constants.GMR) - constants.B_0)./G_z;
    delta_z = delta_v ./ (constants.GMR.*G_z);
    alpha_z = rect(z_base, A, z_bar, delta_z);
end

% to define the function Arect((x-b)/c)
function r=rect(x, A, b, c)
    %x is the base unit range vector (x,y,z,t) 
    r = zeros(size(x));
    r(abs((x-b)./c) <= 0.5) = A;
end

