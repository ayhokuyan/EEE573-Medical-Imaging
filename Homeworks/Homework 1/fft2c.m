
function d = fft2c(im) 
% d = fft2c(im)
% fft2c performs a centered fft2
d = fftshift(fft2(ifftshift(im)));
end


