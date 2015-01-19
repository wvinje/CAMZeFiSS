function[ Slice_V ] = Interpolate_Boundary_List( xgv, ygv, bp_list, Slice_V, UCS)

num_bp = size(bp_list, 1); 

for bp_ind = 1:(num_bp-1),
    
    % Go through List and figure out which voxel each bp point belongs in
    current_point = bp_list(bp_ind,:);
    
    x_ind_lookvect = find( xgv >= current_point(1) );
    x_ind = x_ind_lookvect(1);
    
    y_ind_lookvect = find( ygv >= current_point(2) );
    y_ind = y_ind_lookvect(1);
    
    Slice_V(x_ind, y_ind) = 1;
    
    % For each pair interpolate some points between and see if we can trigger
    % any more pixels, so we march from the lower to (almost) the higher
    % point setting everything to 1 as we go
    
    next_point = bp_list(bp_ind+1,:);
    
    [ bp_sub_list ] = Line_Between_Points( current_point, next_point, UCS.num_interp_pts );
    
    for sub_ind = 1:UCS.num_interp_pts,
        
        current_sub_point = bp_sub_list(sub_ind,:);
    
        x_sub_ind_lookvect = find( xgv >= current_sub_point(1) );
        x_sub_ind = x_sub_ind_lookvect(1);
    
        y_sub_ind_lookvect = find( ygv >= current_sub_point(2) );
        y_sub_ind = y_sub_ind_lookvect(1);
        
        Slice_V(x_sub_ind, y_sub_ind) = 1;
            
    end % loop through sub-list
    
    
end % loop through points

% Now we do the last point just for completeness

last_point = bp_list(num_bp,:);
    
    x_ind_lookvect = find( xgv >= last_point(1) );
    x_ind = x_ind_lookvect(1);
    
    y_ind_lookvect = find( ygv >= last_point(2) );
    y_ind = y_ind_lookvect(1);
    
    Slice_V(x_ind, y_ind) = 1;