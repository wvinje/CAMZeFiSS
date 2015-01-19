function[scaled_boundary_pix] = Pixel2Histo_Scale( boundary_pix, UCS)
%
% This function takes boundary pixel position in pixels and scales to 
% histological mm  (As opposed to in vivo mm). Thus these are the values 
% after the brain shrinkage during histology
%
% The offsets are designed to make the 0,0 mm point the center of the raw
% image

% Scale x dim
scaled_boundary_pix(:,1) = boundary_pix(:,1) - UCS.x_offset;
scaled_boundary_pix(:,1) = scaled_boundary_pix(:,1) .* UCS.x_scale;

% Scale y dim
scaled_boundary_pix(:,2) = boundary_pix(:,2) - UCS.y_offset;
scaled_boundary_pix(:,2) = scaled_boundary_pix(:,2) .* UCS.y_scale;
