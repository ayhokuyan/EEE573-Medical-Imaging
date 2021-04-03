classdef nmrparams
    % MRISIM: Tissue MR parameters
    % http://www.bic.mni.mcgill.ca/brainweb/
    % https://brainweb.bic.mni.mcgill.ca/brainweb/tissue_mr_parameters.txt
    % Jul 31, 1996
    properties(Constant=true)
        % T values are in second
        T1 = [0,2569,833,500,350,900,2569,0,833,500, 752].*1e-3;
        T2 = [0,329,83,70,70,47,329,0,83,70, 237].*1e-3;
        T2s = [0,58,69,61,58,30,58,0,69,61, 204].*1e-3;
        % relative proton densities
        PD = [0,1,0.86,0.77,1,1.0,1,0,0.86,0.77,0.76];
        % chemical shifts are in ppm
        CSH = [0,0,0,0,-3.5,0,0,0,0,0,0].*1e-6;
    end
end

% 0=Background, 1=CSF, 2=Grey Matter, 3=White Matter, 4=Fat, 5=Muscle/Skin, 
% 6=Skin, 7=Skull, 8=Glial Matter, 9=Connective 10=Estimated MS Legion
