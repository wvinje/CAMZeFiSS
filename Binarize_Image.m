function[ bin_img ] = Binarize_Image( img, target_color)
%

% make sure search_color is uint8
target_color = uint8(target_color);

[num_v_pixels, num_h_pixels, num_dims] = size( img );

bin_img = zeros(num_v_pixels, num_h_pixels);

% We do a dumb, brute force search to see which pixels match the target
% color. This should be able to be parallelized
for v = 1:num_v_pixels, 
    for h = 1:num_h_pixels, 

        pixel_rgb_vect = img(v, h, 1:3);  % remember that entries are uint8
        
        % Now we test for grayscale, just to not bother checking for each
        % pixels equality
        if ( ( pixel_rgb_vect(1) ~= pixel_rgb_vect(2) ) || ( pixel_rgb_vect(1) ~= pixel_rgb_vect(3) ) || ( pixel_rgb_vect(2) ~= pixel_rgb_vect(3) ) )
                % Then it is not grayscale
                
            % Is it our target color? 
            if ( pixel_rgb_vect(1) == target_color(1) ) % remember the first entry in the token list is the token number
                if ( pixel_rgb_vect(2) == target_color(2) )
                    if ( pixel_rgb_vect(3) == target_color(3) )
                        
                        % Then the the color matches the target color
                        % So we set the pixel to 1
                        bin_img(v,h) = 1;
                
                    end % b if-then 
                end % g if-then
            end % r if-then
            
        end     % grayscale test 

    end % h loop
end % v loop

