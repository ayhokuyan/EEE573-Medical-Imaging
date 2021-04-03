close all; clear all;

TOTAL_PIXEL = 512;
DETECTOR_LEN = 128;
MU_0 = 0.03;
Z_1 = [50, 150];

x_range = linspace(-DETECTOR_LEN/2, DETECTOR_LEN/2, TOTAL_PIXEL);


figure();
for z=[1:2]
    subplot(1,2,z)
    plot(x_range, calcInt(x_range, MU_0, Z_1(z)));
    xlabel('x (cm)')
    ylabel('I_d/I_0')
    title(sprintf('Normalized Intensity for z_1 = %d cm', Z_1(z)));
end
    


function cos = cos_theta(t)
    cos = 200./sqrt(200.^2 + t.^2);
end

function int = intensity1(x)
    int = cos_theta(x).^3;
end

function int = intensity2(x, mu, z)
    int = intensity1(x) .* exp((- mu ./ cos_theta(x)) .* ...
                        ((2000.*sqrt(3)./abs(x)) - ...
                        (z.*200.*sqrt(3)./(200.*sqrt(3)-abs(x)))) );
end

function int = intensity3(x, mu ,z)
    int = intensity1(x) .* exp((- mu ./ cos_theta(x)) .* ...
                     (((z+40).*200.*sqrt(3)./(abs(x) + 200.*sqrt(3))) - ...
                     (z.*200.*sqrt(3)./(200.*sqrt(3)-abs(x)))) );
end

function int = intensity(x,mu,z)
    if(abs(x) >= 2000.*sqrt(3)/(z+10))
        int = intensity1(x);
    elseif 2000.*sqrt(3)/(z+30) <= abs(x) && abs(x) < 2000.*sqrt(3)/(z+10)
        int = intensity2(x,mu,z);
    elseif abs(x) < 2000.*sqrt(3)/(z+30)
        int = intensity3(x,mu,z);
        disp(int)
    end
end

function int_vec = calcInt(x_vec, mu, z)
    int_vec = [];
    for x = x_vec
        int_vec = [int_vec intensity(x,mu,z)];
    end
end
                 
      
      

