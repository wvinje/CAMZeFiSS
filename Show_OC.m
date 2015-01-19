function[ ] = Show_OC( slide_CA, boundary_pix_CA, struct_color_str, hemisphere_flag, UCS )
% This is a reworking of the old routine Struct_Stack.
% Its closest related function in the Cleaned_Code is Process_Slidestack.
% Because we have already ran Process_Slidestack on all anatomical structures
% we already possess the information held in the Boundary_Pix_CA
%
% Here our interest is to use that information to draw the open countour
% structures. 

% Now the rostral-caudal shrinkage must be corrected for
if hemisphere_flag == 'u' % remember up is left
    inter_slice_spacing = UCS.inter_slice_spacing_left;
else
    inter_slice_spacing = UCS.inter_slice_spacing_right;
end

num_slides = length( boundary_pix_CA );

lo_slide = slide_CA{1};
z_lo = (lo_slide.slide_z - 1) * inter_slice_spacing;
    % 0 is the bottom of the entire affair

boundary_pix_lo = boundary_pix_CA{1};


for i = 2:num_slides,
    
    hi_slide = slide_CA{i};
    
    % STUB FOR FUTURE USER VISUAL FEEDBACK ROUTINE
    hi_slide.filenum1
    hi_slide.filenum2
    
    % Debug trigger
    %if (hi_slide.filenum1 == 6)
    %   if (hi_slide.filenum2 == 6)
    %       
    %       debug_flag = 1;
    %   end
    %end
    
    skip_flag = 0;
    
    if (hi_slide.filenum1 == 6)
       if (hi_slide.filenum2 == 5)
           
           skip_flag = 1;
       end
       if (hi_slide.filenum2 == 4)
           
           skip_flag = 1;
       end
 
    end
    
  
    
    if (~skip_flag)
    
        boundary_pix_hi = boundary_pix_CA{i};
        
        Patch_Between_2slices_OpenCont(boundary_pix_lo, z_lo, boundary_pix_hi, (z_lo+inter_slice_spacing), UCS.step_size, struct_color_str);    
        
        z_lo = z_lo + inter_slice_spacing;
        boundary_pix_lo = boundary_pix_hi;
        lo_slide = hi_slide;
        
        clear boundary_pix_hi hi_slide
        
    else
        % then we have decided to skip the slice
        
        z_lo = z_lo + inter_slice_spacing;
        %boundary_pix_lo = boundary_pix_hi; we leave boundary_pix_lo unchanged
        lo_slide = hi_slide; % we do advance this information
        clear hi_slide
       
    end % skip flag

end % end for loop
