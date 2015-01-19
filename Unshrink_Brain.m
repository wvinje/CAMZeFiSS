function[ bp_list_out ] = Unshrink_Brain( bp_list_in, hemisphere_flag, UCS )


%First we scale so that we are in the histology slide scale (with resulting unit of mm)
% NB: This also handles subtracting center of slide offsets
bp_list_in = Pixel2Histo_Scale(bp_list_in, UCS);


% Now we scale to the estimated size of the in vivo anatomical structure
% (units still mm). 
%
% NB: At this time we blatantly cheat! We treat matrix dim 1 as ml and matrix dim 2 as
% dv. 
% 
% In reality the slices have a slight rotation that makes the above not
% approximation incorrect and thus unsuitable for publication grade work. 
if ( hemisphere_flag == 'u' )
    
     %bp_list_out(:,1) = bp_list_in(:,1) ./ UCS.left_ml_shrinkage;
     %bp_list_out(:,2) = bp_list_in(:,2) ./ UCS.left_dv_shrinkage;

     bp_list_out(:,2) = bp_list_in(:,2) ./ UCS.left_ml_shrinkage;
     bp_list_out(:,1) = bp_list_in(:,1) ./ UCS.left_dv_shrinkage;


else
    
     %bp_list_out(:,1) = bp_list_in(:,1) ./ UCS.right_ml_shrinkage;
     %bp_list_out(:,2) = bp_list_in(:,2) ./ UCS.right_dv_shrinkage;
     
     bp_list_out(:,2) = bp_list_in(:,2) ./ UCS.right_ml_shrinkage;
     bp_list_out(:,1) = bp_list_in(:,1) ./ UCS.right_dv_shrinkage;


end