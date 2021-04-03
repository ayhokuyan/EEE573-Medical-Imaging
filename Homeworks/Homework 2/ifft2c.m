
function im = ifft2c(d)
% im = ifft2c(d)
% ifft2c performs an centered ifft2
im = fftshift(ifft2(ifftshift(d)));
end