function[ ax_S ] = Create_Axis_Space( boundary_pix_CA_CA, inter_slice_distance, num_pix_perside, z_max )
% boundary_pix_CA_CA
% This is a actually a cell array of cell arrays

max_x_vect = [];
max_y_vect = [];
min_x_vect = [];
min_y_vect = [];

num_areas = length(boundary_pix_CA_CA);
 
for area_ind = 1:num_areas,
    
    boundary_pix_CA = boundary_pix_CA_CA{area_ind};

    num_slices = length( boundary_pix_CA );

    % Find range of each slice
    for slice_ind = 1:num_slices,
        
        boundary_pix_list = boundary_pix_CA{slice_ind};
    
        max_x = max( boundary_pix_list(:,1) );
        max_x_vect = cat(2, max_x_vect, max_x);
        clear max_x
    
        max_y = max( boundary_pix_list(:,2) );
        max_y_vect = cat(2, max_y_vect, max_y);
        clear max_y
    
        min_x = min( boundary_pix_list(:,1) );
        min_x_vect = cat(2, min_x_vect, min_x);
        clear min_x
    
        min_y = min( boundary_pix_list(:,2) );
        min_y_vect = cat(2, min_y_vect, min_y);
        clear min_y

        clear boundary_pix_list
    
    end % loop over slices
    
    clear boundary_pix_CA

end % loop over areas


% Find max range
x_range = [min(min_x_vect), max(max_x_vect)];
y_range = [min(min_y_vect), max(max_y_vect)];


% Compute Z range
% due to my numbering scheme 0 is the begining of z space.
% z_max and inter_slice_distance are passed in from Main_Batch
z_range = [0, (z_max * inter_slice_distance)];


% Compute X, Y, Z
xgv = linspace( x_range(1), x_range(2), num_pix_perside(1) );
ygv = linspace( y_range(1), y_range(2), num_pix_perside(2) );
zgv = linspace( z_range(1), z_range(2), num_pix_perside(3) );

stepsize_x = (x_range(2) - x_range(1)) / num_pix_perside(1);
stepsize_y = (y_range(2) - y_range(1)) / num_pix_perside(2);


% Now the magic of meshgrid
[X, Y, Z] = meshgrid(xgv, ygv, zgv);


% Make the big volume matrix, intialized to 0. 
V = zeros(num_pix_perside(1), num_pix_perside(2), num_pix_perside(3));


% Finally pack the information into our output structure
ax_S.X = X; 
ax_S.Y = Y; 
ax_S.Z = Z;
ax_S.V = V;
ax_S.xgv = xgv;
ax_S.ygv = ygv;
ax_S.zgv = zgv;
ax_S.stepsize_x = stepsize_x;
ax_S.stepsize_y = stepsize_y;
ax_S.V = V;
