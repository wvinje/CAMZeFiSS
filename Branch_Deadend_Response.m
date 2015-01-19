function[ Boundary_Pix_List ] = Branch_Deadend_Response(Boundary_Pix_List_Temp2, stripped_bin_img, UCS)

    % NB: Boundary_Pix_List_Temp2 comes from Boundary_Pix_List_Temp in
    % Contour_Following; likewise the "pre-stripping" stripped_bin_img is
    % passed in from bin_img in contour_following

        Not_Done = 1;
        num_strips = 0;
        
        while (Not_Done)
            [ stripped_bin_img ] = Zero_Last_Pixel( stripped_bin_img, Boundary_Pix_List_Temp2);
                      
            [ new_return_code, Boundary_Pix_List_Temp2 ] = Theo_Pavlides_Is_Cool( stripped_bin_img, 20, 0 );
            
            num_strips = num_strips + 1;
                        
            switch new_return_code
                case -1
                    disp('Unspecified failure of Theo Pavlides Algorithm. User investigation required.');
                    keyboard
        
                case 1
                    % Actually worked, 
                    Boundary_Pix_List = Boundary_Pix_List_Temp2; % return this as our boundary pix list
                    Not_Done = 0;                               % exit the while loop
                
                % case 2 do nothing, we probably aren't done with branch yet.
                % So we just loop again
                
                case 3
                    disp('Theo Pavlides has stopped on isolated pixel (after attempting to strip branch). User investigation required.');
                    keyboard

            end % switch
            
            if (num_strips >= UCS.strip_limit)
                disp('Theo Pavlides has stopped due to reaching branch strip limit. User investigation required.');
                keyboard
                Not_Done = 0;
            end

        end % while loop
        % Here we are done with what happens if the initial run of Theo
        % Pavlides algorithm believes it is on a branch and runs the 
        % stripping process
