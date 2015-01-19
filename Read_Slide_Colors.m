function[ color_token_list ] = Read_Slide_Colors( img )
%
% color_token_list: each row has columns token_unique_id, r, g, b

color_token_list = [];

[num_v_pixels, num_h_pixels, num_dims] = size( img );   

% We inspect each pixel and test for grayscale
% If not grayscale we decide whether the pixel is a newly encountered
% color.
% If it is new then it is assigned a color key value and put in the
% color_token_list

for v = 1:num_v_pixels, 
    for h = 1:num_h_pixels, 

        pixel_rgb_vect = img(v, h, 1:3);  % remember that entries in image are uint8
        
        % Now we test for grayscale
        if ( ( pixel_rgb_vect(1) ~= pixel_rgb_vect(2) ) || ( pixel_rgb_vect(1) ~= pixel_rgb_vect(3) ) || ( pixel_rgb_vect(2) ~= pixel_rgb_vect(3) ) )
                % Then it is not grayscale
                
                % Is it new color? If not, return existing token value for
                % pixel color
                [new_color_flag, pixel_token_value] = Test_Color_Novelty( pixel_rgb_vect, color_token_list ); 

                % If new add it to the color_token_list
                if (new_color_flag)
                    if (isempty( color_token_list ))
                        % Then it is time to start the color_token_list
                        color_token_list(1, 1) = 1; 
                        color_token_list(1, 2:4) = pixel_rgb_vect;   
                        
                    else
                        % Add a row to existing token_list
                        color_token_list(pixel_token_value, 1) = pixel_token_value; 
                        color_token_list(pixel_token_value, 2:4) = pixel_rgb_vect;   
                       
                    end % test for first entry in list
                    
                end     % test for new color
                    
        end     % equality test 

    end % h loop
end % v loop
