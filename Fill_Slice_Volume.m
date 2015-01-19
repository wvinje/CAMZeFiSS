function[ Vout ] = Fill_Slice_Volume( xgridvect, ygridvect, boundary_pix_list, num_x_vox, num_y_vox, UCS)
% This is a wrapper function to bind together the finding of the boundary
% list and the filling of the 

% Initialize slice volume
V = zeros(num_x_vox, num_y_vox);

% Here we figure out which of the boundary pixels should be filled
[ V ] = Interpolate_Boundary_List( xgridvect, ygridvect, boundary_pix_list, V, UCS);

% Now, the magic of Matlab's imfill function
Vout = imfill(V, 'holes');
