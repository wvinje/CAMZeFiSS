function[ stripped_bin_img ] = Zero_Last_Pixel( bin_img, Boundary_Pix_List )

last_index = size(Boundary_Pix_List, 1);

last_pixel = Boundary_Pix_List(last_index, :);

stripped_bin_img = bin_img;

if (stripped_bin_img(last_pixel(1), last_pixel(2)) ~= 1)
    disp('WARNING: Boundary_Pix_List appears corrupt. User investigation required.');
    keyboard
end

stripped_bin_img(last_pixel(1), last_pixel(2)) = 0; 

% Note to readers: The actually boundary pix list is not touched.
% The reason is that the above boundary pix list will be replaced by
% the next run of the Theo Pavlides algorithm on the stripped bin img.