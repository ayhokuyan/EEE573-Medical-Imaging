% first, add the folder resource to your path by Home > Environment > Set 
% Path > Add with Subfolders and select the 'resource' and 'data' folders. 
function [T1map,T2map,T2smap,PDmap,CSHmap]=load_data()
    TISSUE_NUM = 11;
    %Load the anatomical phantom
%     [anat,info] = loadminc('data/phantom_1.0mm_normal_crisp.mnc');
    [anat,info] = loadminc('phantom_1.0mm_msles1_crisp.mnc');
    
    sizeVol = size(anat);
    
    T1map = zeros(sizeVol);
    T2map = zeros(sizeVol);
    T2smap = zeros(sizeVol);
    PDmap = zeros(sizeVol);
    CSHmap = zeros(sizeVol);
    
    for i = 1:TISSUE_NUM
        T1map(anat == i-1) = nmrparams.T1(i);
        T2map(anat == i-1) = nmrparams.T2(i);
        T2smap(anat == i-1) = nmrparams.T2s(i);
        PDmap(anat == i-1) = nmrparams.PD(i);
        CSHmap(anat == i-1) = nmrparams.CSH(i);
    end   
    
    disp(info)
end