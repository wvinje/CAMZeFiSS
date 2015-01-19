function[new_color_flag, pixel_token_value] = Test_Color_Novelty( pixel_rgb_vect, color_token_list )

new_color_flag = 1;
pixel_token_value = ( size(color_token_list,1) + 1 );

% Test for empty color token list, if so simply return the above values
if ( isempty(color_token_list) )
    return;

else
    
    len_token_list = size(color_token_list, 1); 
end


for i = 1:len_token_list, 
    if ( pixel_rgb_vect(1) == color_token_list(i, 2) ) % remember the first entry in the token list is the token number
        if ( pixel_rgb_vect(2) == color_token_list(i, 3) )
            if ( pixel_rgb_vect(3) == color_token_list(i, 4) )
                % Then the the color isn't new, so reset new color flag and
                % token value
                new_color_flag = 0;
                pixel_token_value = i;
                
            end % b if-then 
        end % g if-then
    end % r if-then
end     % i loop


