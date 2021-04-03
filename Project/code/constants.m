classdef constants
    properties (Constant = true)
        GMR = 42.58 * 10^6; %Gyromagnetic Ratio of 1H Hz/T
        GMR_nor = 42.58 * 10^6 / (2 * pi);
        PLANCK = 6.62607004 * 10^-34; %Planck's constant
        BOLTZMANN = 1.38064852 * 10^-23; %Boltzmann's constant
        T = 300; %IDK YET
        TR = 0.6; % Test value
        TE = 0.02; % Test value
        TS_1 = 25e-6; % Time spent sampling 1 mm of kspace
        xFov = 181;
        yFov = 217;
        % Tissue values are measured in 1.5T scanner, 
        B_0 = 1.5 %Static Magnetic Field T
        B_0_var = 3e-6 % Magnetic Variation
    end
end

