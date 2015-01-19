function[ BoundaryPix_CA ] = Process_Slidestack( slide_CA, OC_Flag, hemisphere_flag, UCS )

% Initialization and setup
BoundaryPix_CA = [];
bp_ca_ind = 1;
num_slides = length( slide_CA );


% Now we set the proper inter_slice_spacing
if hemisphere_flag == 'u' % remember up is left
    inter_slice_spacing = UCS.inter_slice_spacing_left;
else
    inter_slice_spacing = UCS.inter_slice_spacing_right;
end


%----------------------------
% Handle lowest slide in stack

lo_slide = slide_CA{1};
z_lo = (lo_slide.slide_z - 1) * inter_slice_spacing;
    %Note on range of values:
    % In-vivo Z has 0 is the lowest value of lowest slide considered.
    % This corresponds to slide_z having an ordinal value of 1.
    % For a given stack the lowest slide ordinal Z value may not be 1. Thus for a given slide stack the lowest in-vivo Z might not be 0  


% Handle slice 
[ boundary_pix_lo, boundary_color ] = Contour_Following( lo_slide.slide_fn, lo_slide.struct_color_key, UCS, OC_Flag );

boundary_pix_lo = Unshrink_Brain(boundary_pix_lo, hemisphere_flag, UCS);

BoundaryPix_CA{bp_ca_ind} = boundary_pix_lo;
bp_ca_ind = bp_ca_ind + 1;
    
% Handle rest of slices
for i = 2:num_slides,
    
    hi_slide = slide_CA{i};
    
    % STUB FOR FUTURE USER VISUAL FEEDBACK ROUTINE
    hi_slide.filenum1
    hi_slide.filenum2
    
    % These are debug tools left in place for potential future use:
    % 
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
        % Then we processs the slice
        
        [ boundary_pix_hi, boundary_color ] = Contour_Following( hi_slide.slide_fn, hi_slide.struct_color_key, UCS, OC_Flag );
        
        boundary_pix_hi = Unshrink_Brain(boundary_pix_hi, hemisphere_flag, UCS);
        
        BoundaryPix_CA{bp_ca_ind} = boundary_pix_hi;
        bp_ca_ind = bp_ca_ind + 1;
        clear boundary_pix_hi
        
     end % skip flag if-then
    
    % Here we setup for the next slice by moving the formerly high-slice
    % to the low-slice position, and incrementing the in-vivo Z value
    % appropriately
        
    z_lo = z_lo + inter_slice_spacing;
    clear hi_slide


end % loop through slides

