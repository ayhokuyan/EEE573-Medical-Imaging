function reconstruction = reconstruct_image(s0)
    reconstruction = ifftshift(ifft2(s0));
end

