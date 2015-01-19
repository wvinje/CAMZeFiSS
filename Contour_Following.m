function[ Boundary_Pix_List, target_color ] = Contour_Following( filename, color_key, UCS, OC_flag)

% Read the image from the file
[img] = readpsd( filename ); 

% Extract the color token list 
[ color_token_list ] = Read_Slide_Colors( img );

% Identify the target color using the color key information
target_color = color_token_list(color_key,2:4);

% Turn image into binary representation of target color pixels
bin_img = Binarize_Image( img, target_color );

bin_img = Pad_Image( bin_img, 10);

% The following section used to be the separate function
% Boundary_Wrapper.m
% The point is to provide a way to run the Theo_Pavlides algorithm 
% repeated after stripping points (should this prove needed). Currently
% the stripping points functionality is located in Branch_Deadend_Response.
%-----------

[ Return_Code, Boundary_Pix_List_Temp ] = Theo_Pavlides_Is_Cool( bin_img, 20, 0 ); % Debug flag set to 0.

switch Return_Code
    
    case -1
        disp('Unspecified failure of Theo Pavlides Algorithm. User investigation required.');
        keyboard
        
    case 1
        % We are done, hooray
        Boundary_Pix_List = Boundary_Pix_List_Temp;
        
    case 2
        if (~OC_flag)
            % This is the closed contour case. It is possible we are stuck
            % on the wrong arm of an x or y junction.
            % Need to decide on real back-track pixel versus just a branch
            % Run a loop game to find whether we can debranch
            [ Boundary_Pix_List ] = Branch_Deadend_Response(Boundary_Pix_List_Temp, bin_img, UCS);
        else
            % In the OC case I don't use the above technique. 
            % Thus we just have to take what we can get from the temp
            % boundary pix list
            Boundary_Pix_List = Boundary_Pix_List_Temp;
        end % open contour test
        
    case 3
        disp('Theo Pavlides has stopped on isolated pixel. User investigation required.');
        keyboard

end % switch on return value of first Theo Pavlides run