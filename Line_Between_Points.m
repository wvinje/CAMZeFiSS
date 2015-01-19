function[ new_bp_list ] = Line_Between_Points( pnt1, pnt2, num_interp_pts )
% A minor utility function for intepolating between two points in the x-y
% plane and returning the result in the boundary points list format

new_x_vect = linspace( pnt1(1), pnt2(1), num_interp_pts );
new_y_vect = linspace( pnt1(2), pnt2(2), num_interp_pts );

new_bp_list = cat(2, new_x_vect', new_y_vect');