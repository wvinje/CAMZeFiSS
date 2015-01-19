function[ V ] = Volume_Fill( slide_CA, bp_CA, ax_S, num_pix_perside, hemisphere_flag, UCS )

% A note on algorithm:
% It takes the contour of the low slice and finds the appropriate x-y
% pixels to fill. Repmat is then used to extend this upwards till z_hi is
% reached. This process is repeated until the high z limit is reached. 

% ax_S contains the info on xgv, ygv, X, Y ect.
V = ax_S.V; % this gets us our initial V filled with 0. 

% Now the rostral-caudal shrinkage must be corrected for
if hemisphere_flag == 'u' % remember up is left
    inter_slice_spacing = UCS.inter_slice_spacing_left;
else
    inter_slice_spacing = UCS.inter_slice_spacing_right;
end

num_slides = length( slide_CA ); 
lo_slide = slide_CA{1};
z_lo = (lo_slide.slide_z - 1) * inter_slice_spacing;
    % 0 is the bottom of the entire affair

boundary_pix_lo = bp_CA{1};

for i = 2:num_slides,
    
    hi_slide = slide_CA{i};

    % Debug trigger
    %if (hi_slide.filenum1 == 6)
    %   if (hi_slide.filenum2 == 6)
    %       
    %       debug_flag = 1;
    %   end
    %end
    
    skip_flag = 0;
    
    %if (hi_slide.filenum1 == 6)
    %   if (hi_slide.filenum2 == 6)
    %       
    %       skip_flag = 1;
    %   end
    %end
    
    if (~skip_flag)
        boundary_pix_hi = bp_CA{i};
        
        [sliceV ] = Fill_Slice_Volume( ax_S.xgv, ax_S.ygv, boundary_pix_lo, UCS.num_pix_perside_Vmat(1), UCS.num_pix_perside_Vmat(2), UCS);
    
        % Now we need repmat_factor, z_start_ind and z_end_ind
        % z_start comes from the physical units z_lo and z_end_ind derives from z_hi
        z_start_ind_lookvect = find( ax_S.zgv >= z_lo );
        if length(z_start_ind_lookvect) >= 1
            z_start_ind = z_start_ind_lookvect(1);
        else
            disp('Unable to find z start index. User intervention required.');
            keyboard
        end % test for valid ind
        
        z_end_ind_lookvect = find( ax_S.zgv >= (z_lo+inter_slice_spacing) );
        if length(z_end_ind_lookvect) >= 1
            z_end_ind = z_end_ind_lookvect(1);
        else
            % we are already at end, 
            z_end_ind = num_pix_perside(3);
        end % test for valid ind
        
        repmat_factor = (z_end_ind - z_start_ind)+1;
    
        Vchunk = repmat(sliceV,[1,1,repmat_factor]);        
   
        V(:,:,z_start_ind:z_end_ind) = Vchunk;  
    
        boundary_pix_lo = boundary_pix_hi;
        
        clear boundary_pix_hi 
             
    end % skip flag
    
    % Here we setup for the next slice by moving the formerly high-slice
    % to the low-slice position, and incrementing the in-vivo Z value
    % appropriately
    
    lo_slide = hi_slide;
    z_lo = z_lo + inter_slice_spacing;
    clear hi_slide

end


% Now multiply V by our label
