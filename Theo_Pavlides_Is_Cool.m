function[ Return_Code, Boundary_Pix_List ] = Theo_Pavlides_Is_Cool( bin_img, search_d, debug_flag )
%
% Originally
% http://www.imageprocessingplace.com/downloads_V3/root_downloads/tutorials/contour_tracing_Abeer_George_Ghuneim/index.html
% Interpretation of the Pavlides algorithm comes from the following
% website:
%  Abeer George Ghuneim and this web site is his project for the Pattern Recognition course, 308-644B,
%  which was taught by Professor Godfried Toussaint in the winter session of the year 2000.
% He did this project while being an M.Sc.student in the School of Computer Science at McGill University. 
%
% Much of the original comments were taken from his webpage
%
% The algorithm has mutated in the addition of the gap jumping and
% back-tracking avoidance
% (At the wrapper level there is also the handling of branches) 

Num_Back_Checks = 5;
Return_Code = -1; % Default is FAIL


% Initialize Bug
% 1 = N, 2 = E, 3 = S, 4 = W
% row, col

% We start in the first ON pixel as we go in from the lower left corner
% starting at the bottom left corner of the grid, scanning each column 
% of pixels from the bottom going upwards -starting from the leftmost 
% column and proceeding to the right- until a black pixel is encountered. Declare that pixel as the "start" pixel. 
[ start_r, start_c, heading ] = Find_Start_Pixel( bin_img, debug_flag );
Start_Pixel = [start_r, start_c];

% make sure that you enter the start pixel in a direction which ensures that the left adjacent pixel to it will be ON
%  ("left" here is taken with respect to the direction in which you enter the start pixel ). 


%plot3(start_r-2, start_c-2, 0, 'Color', [0, 0, 0], 'Marker', 'x', 'MarkerSize', 20);  % -2 corrects for padding

idx = 0;
Boundary_Pix_List = [];  % This is a central data structure. It is the list of the accepted pixels in the structure boundary.

Not_Done = 1;
Current_Pixel = [start_r, start_c];

% Take steps along contour
while ( Not_Done )
    
    % Figure out P1, P2, and P3 based on direction
    [ P1, P2, P3 ] = Set_P_Pix( Current_Pixel, heading );

    [ New_Pixel, P1, P2, P3, heading ] = Examine_P_Pix(P1, P2, P3, bin_img, Current_Pixel, heading);

    if (isempty( New_Pixel )) % then we have presumably got the "isolated pixel" case
        
        % Sometimes you come out of a jump on an island and need to jump
        % again!
        [jump_flag, Landing_Pixel] = Test_4_Gap2( Current_Pixel, search_d, bin_img, Boundary_Pix_List );
        
        if (jump_flag)
                % Yay, found place to jump to!
                if (debug_flag)
                    disp('JUMPING');
                end
                %plot(Landing_Pixel(1)-2, Landing_Pixel(2)-2, 'c', 'Marker', 'x', 'LineStyle', 'none');
                % Update boundary pixel list and ready for continuation
                idx = idx + 1;
                Boundary_Pix_List(idx, 1) = Landing_Pixel(1);
                Boundary_Pix_List(idx, 2) = Landing_Pixel(2);
                heading = Init_Heading( bin_img, Landing_Pixel );
                New_Pixel = Landing_Pixel;
                Current_Pixel = Landing_Pixel;
                Back_Sliding_Flag = 0;
                
        else
            Not_Done = 0;
            if (debug_flag)
                disp('Stopping on isolated pixel');
                Display_P_Pix( P1, P2, P3 );
            end
            Return_Code = 3; 
            
        end % jump case for isolated pixel
    else

        if (~isempty( Boundary_Pix_List ) )
            Back_Sliding_Flag = Check_4_Backtrack( New_Pixel, Boundary_Pix_List, Num_Back_Checks );
        else
            Back_Sliding_Flag = 0;
        end % test for valid boundary pixels 

        % 2nd & 3rd Stopping Test
        % Are you back at the start pixel?
        if ( (New_Pixel(1) == Start_Pixel(1)) && (New_Pixel(2) == Start_Pixel(2)) )
            
            Not_Done = 0;
            if (debug_flag)
                disp('Stopping on Start pixel');
            end
            Return_Code = 1; % Zuckzess! 

        elseif ( Back_Sliding_Flag )
            
            % Try to jump gap
            [jump_flag, Landing_Pixel, P1, P2, P3, heading] = Test_4_Gap( New_Pixel, heading, search_d, bin_img, Boundary_Pix_List );
            
            if (~jump_flag)
                [jump_flag, Landing_Pixel] = Test_4_Gap2( Current_Pixel, search_d, bin_img, Boundary_Pix_List );
                % Note, this routine leaves heading unchanged
            end
            
            if (jump_flag)
                % Yay, found place to jump to!
                if (debug_flag)
                    disp('JUMPING');
                end
                %plot(Landing_Pixel(1)-2, Landing_Pixel(2)-2, 'c', 'Marker', 'x', 'LineStyle', 'none');
                % Update boundary pixel list and ready for continuation
                idx = idx + 1;
                Boundary_Pix_List(idx, 1) = Landing_Pixel(1);
                Boundary_Pix_List(idx, 2) = Landing_Pixel(2);
                heading = Init_Heading( bin_img, Landing_Pixel );
                Current_Pixel = Landing_Pixel;
                Back_Sliding_Flag = 0;
                
            else
                % Couldn't find place to jump to, hence this is a real
                % stopping pixel
                Not_Done = 0;
                if (debug_flag)
                    disp('Stopping on back-track');
                end
                Return_Code = 2; 
                
            end  % if-then for jump
    
        else
            % If not stopping pixel then add pixel to boundary list 
            idx = idx + 1;
            Boundary_Pix_List(idx, 1) = New_Pixel(1);
            Boundary_Pix_List(idx, 2) = New_Pixel(2);
    
            Current_Pixel = New_Pixel;
            
            if debug_flag
                Display_Current_Pixel( Current_Pixel, heading );
                %Display_P_Pix( P1, P2, P3 );
                drawnow
                pause(0.01);
            end

        end % 2nd Test for stop

    end % empty new pix stop test
    
  end  % Main While Loop

end % Main functon

%--------------------------------------------------------------------------
function[ start_r, start_c, heading ] = Find_Start_Pixel( bin_img, debug_flag )

% We start in the first ON pixel as we go in from the lower left corner
% starting at the bottom left corner of the grid, scanning each column 
% of pixels from the bottom going upwards -starting from the leftmost 
% column and proceeding to the right- until a black pixel is encountered. Declare that pixel as the "start" pixel. 

[num_v_pixels, num_h_pixels] = size( bin_img );

%for h = 1:num_h_pixels,
%
%    %for v = num_v_pixels:-1:1,   < This puts start point on upper left
%    corner hit
%    % point plot
%    for v = 1:num_v_pixels, 

%for v = 1:num_v_pixels,
%    for h = 1:num_h_pixels,  % reverse index gives upper right corner hit
%                               / somehow normal index gives same???

v = 0;
notDone = 1;

while (notDone)

    v = v + 1;
    
    for h = 1:num_h_pixels

        if (bin_img(v,h) == 1)

            start_r = v;
            start_c = h;
            notDone = 0;

        end % first pixel test

    end % h loop

end % while

[ heading ] = Init_Heading( bin_img, [start_r, start_c] );

[ point_c ] = Find_Heading_Color( heading );

if debug_flag
    plot(start_r-2, start_c-2, 'Color', point_c, 'Marker', 'x', 'MarkerSize', 15);  % -2 corrects for padding
end 

end % Find start pix & heading 

%--------------------------------------------------------------------------
function[ P1, P2, P3 ] = Set_P_Pix( Current_Pixel, heading )

    switch heading

        case 1
            P1 = [(Current_Pixel(1) - 1), (Current_Pixel(2) - 1)];
            P2 = [(Current_Pixel(1) - 1), Current_Pixel(2)];
            P3 = [(Current_Pixel(1) - 1), (Current_Pixel(2) + 1)];

        case 2
            P1 = [(Current_Pixel(1) - 1), (Current_Pixel(2) + 1)];
            P2 = [Current_Pixel(1), (Current_Pixel(2) + 1)];
            P3 = [(Current_Pixel(1) + 1), (Current_Pixel(2) + 1)];

        
        case 3
            P1 = [(Current_Pixel(1) + 1), (Current_Pixel(2) + 1)];
            P2 = [(Current_Pixel(1) + 1), Current_Pixel(2)];
            P3 = [(Current_Pixel(1) + 1), (Current_Pixel(2) - 1)];


        case 4
            P1 = [(Current_Pixel(1) + 1), (Current_Pixel(2) - 1)];
            P2 = [Current_Pixel(1), (Current_Pixel(2) - 1)];
            P3 = [(Current_Pixel(1) - 1), (Current_Pixel(2) - 1)];

    end % P determinaton

end  % Set P-Pix

%--------------------------------------------------------------------------

function[ ] = Display_Current_Pixel( Current_Pixel, heading )

    r = Current_Pixel(1) - 2;
    c = Current_Pixel(2) - 2;

    [ point_c ] = Find_Heading_Color( heading );

    plot(r, c, 'Color', point_c, 'Marker', '.', 'LineStyle', 'none');  % -2 corrects for padding
    
end % display pix


%--------------------------------------------------------------------------


function[ new_heading ] = Circularize( old_heading )

    
    if ( old_heading > 4 )
                new_heading = old_heading - 4;
    
    elseif ( old_heading < 1 )
                new_heading = old_heading + 4;

    else
                new_heading = old_heading;

    end

end % circularize

%--------------------------------------------------------------------------


function[ point_c ] = Find_Heading_Color( heading )

    switch heading

        case 1
            point_c = [1, 0, 0];
            
        case 2
            point_c = [0, 1, 0];
        
        case 3
            point_c = [0, 0, 1];

        case 4
            point_c = [0, 0, 0];
           
    end % P determinaton

end % find heading color

%--------------------------------------------------------------------------

function[] = Display_P_Pix( P1, P2, P3 )

    plot(P1(1)-2, P1(2)-2, 'Color', [0,0,0], 'Marker', '<', 'MarkerSize', 5);  % -2 corrects for padding
    plot(P2(1)-2, P2(2)-2, 'Color', [0,0,0], 'Marker', '^', 'MarkerSize', 5);  
    plot(P3(1)-2, P3(2)-2, 'Color', [0,0,0], 'Marker', '>', 'MarkerSize', 5); 

end % disp p pix

%--------------------------------------------------------------------------


function[ back_track_flag ] = Check_4_Backtrack( New_Pixel, Boundary_Pix_List, Num_Back_Checks )

    check_num = 0;
    Not_Done = 1;
    back_track_flag = 0;
    Num_Back_Checks = size(Boundary_Pix_List,1);

    while ( Not_Done )

        bp_ind = size(Boundary_Pix_List,1) - check_num;

        if (bp_ind < 1)
            Not_Done = 0;

        else

            test_pixel = Boundary_Pix_List( bp_ind, : );

            if ( (New_Pixel(1) == test_pixel(1)) && (New_Pixel(2) == test_pixel(2)) )
            % Back-sliding detected
                back_track_flag = 1;
                Not_Done = 0;
               
            end

        end % index protect if then
        check_num = check_num + 1;
    
        if (check_num > Num_Back_Checks)
            Not_Done = 0;
        end

    end  % back check while 

end % backslide test

%--------------------------------------------------------------------------
function[jump_flag, Landing_Pixel, P1, P2, P3, heading] = Test_4_Gap( Current_Pixel, heading, search_d, bin_img, Boundary_Pix_List )

jump_flag = 0;
Landing_Pixel = [];
Not_Done = 1;
num_steps = 0;
Landing_Pixel = [];
old_heading = Circularize(heading-2);  % need to reverse to account for back-tracking
% Pre-step (necessary to clear back-track zone)
switch old_heading
            case 1   % Up
                Current_Pixel = [Current_Pixel(1)-2, Current_Pixel(2)];
            case 2   % Right
                Current_Pixel = [Current_Pixel(1), Current_Pixel(2)+2];
            case 3   % Down
                Current_Pixel = [Current_Pixel(1)+2, Current_Pixel(2)];
            case 4   % Left
                Current_Pixel = [Current_Pixel(1), Current_Pixel(2)-2];
            
end % first step heading switch

    % Step 1: Search Staight ahead
    while (Not_Done)
        
        % Take a step along current heading direction
        switch old_heading
            case 1   % Up
                Current_Pixel = [Current_Pixel(1)-1, Current_Pixel(2)];
            case 2   % Right
                Current_Pixel = [Current_Pixel(1), Current_Pixel(2)+1];
            case 3   % Down
                Current_Pixel = [Current_Pixel(1)+1, Current_Pixel(2)];
            case 4   % Left
                Current_Pixel = [Current_Pixel(1), Current_Pixel(2)-1];
            
        end % heading switch
        
        %Display_Current_Pixel( Current_Pixel, heading );
        
        num_steps = num_steps + 1;
        
        % Figure out P1, P2, and P3 based on direction
        [ P1, P2, P3 ] = Set_P_Pix( Current_Pixel, heading );
        
        % Test em
        [ New_Pixel, P1, P2, P3, heading ] = Examine_P_Pix(P1, P2, P3, bin_img, Current_Pixel, heading);
        
        % If New_Pixel is not empty (or zero) then we have found a place to
        % jump to!
        if ( ~isempty(New_Pixel) )
            if (bin_img(New_Pixel(1), New_Pixel(2)) == 1)
                % But is it a NEW pixel?
                novel_pix_flag = 0;
                [ novel_pix_flag ] = Check_Boundary_List( Boundary_Pix_List, New_Pixel );
                
                if (novel_pix_flag == 1)
                    Landing_Pixel = New_Pixel;
                    jump_flag = 1;
                    Not_Done = 0;
                end % novel pix test
                
            end % test for new pixel being on
        end % test for empty new pixel
        
        if (num_steps >= search_d)
            Not_Done = 0;
        end
    end % loop over search_d pixel steps
end % Test_4_Gap

%--------------------------------------------------------------------------
function[jump_flag, Landing_Pixel] = Test_4_Gap2( Current_Pixel, search_d, bin_img, Boundary_Pix_List )
% we are going to assume the immediate moore neighborhood is clear
% we are going to search the "generalized" moore neighboorhood one shell at
% a time
%
% Note: there is overlap of examination in the corners of each shell
shell_side_length = 3;
shell_index = 1;

jump_flag = 0;
Landing_Pixel = [];
Not_Done = 1;

while (Not_Done)
    
    shift = (floor(shell_side_length / 2) + 1);
    
    % scan shell and check for hit
    for j = 1:shell_side_length,
        for k = 1:shell_side_length,
            
            test_pixel(1) = Current_Pixel(1) + j - shift;
            test_pixel(2) = Current_Pixel(2) + k - shift;
            %Display_Current_Pixel( test_pixel, 1 );
            
            %plot(test_pixel(1)-2, test_pixel(2)-2, 'b', 'Marker', 'x', 'LineStyle', 'none');
            
            test_val = bin_img(test_pixel(1), test_pixel(2));
            
            if (test_val == 1)
                % if hit, is it already a boundary pixel?
                [ novel_pix_flag ] = Check_Boundary_List( Boundary_Pix_List, test_pixel );
                
                if (novel_pix_flag == 1)
                    
                    jump_flag = 1;
                    Landing_Pixel = test_pixel;
                    Not_Done = 0;
                end % novel pix test
            end % test for pix on
            
        end 
    end % loops through shell
    shell_index = shell_index + 1;
    shell_side_length = shell_side_length + 2;
    
    if (shell_index > search_d)
        Not_Done = 0;
    end 
    
end % while loop 

end % test for gap 2

%--------------------------------------------------------------------------
function[ New_Pixel, P1, P2, P3, heading ] = Examine_P_Pix(P1, P2, P3, bin_img, Current_Pixel, heading)
New_Pixel = [];  % If this is returned empty it is an important signalling event
 
    % Examine P1
    if (bin_img(P1(1),P1(2)) == 1)
        % First, check pixel P1. If  P1 is black, then declare P1 to be your current boundary pixel and 
        % move one step forward followed by one step to your current left to land on P1.
        New_Pixel = P1;
        heading = heading - 1;
        heading = Circularize( heading );

    % Examine P2
    elseif (bin_img(P2(1),P2(2)) == 1)
        % If  P2 is black, then declare P2 to be your current boundary pixel and
        % move one step forward to land on P2.
        New_Pixel = P2;
        % No change in heading, straight aheard

    % Examine P3
    elseif (bin_img(P3(1),P3(2)) == 1)
        % If P3 is black, then declare P3 to be your current boundary pixel and
        % move one step to your right followed by one step to your current left 
        New_Pixel = P3;
        % If I read above right, there is still no heading change
        % (asymmetric from P1 case). 
    
    else
    % P1, P2 and P3 all OFF
    %else
    % if all 3 pixels in front of you are white?
    % Three-loop of potential examinations to make
        n = 0;
        while n < 4

            % Then, you rotate (while standing on the current boundary pixel) 90 degrees clockwise to face a new set of 3 pixels in front of you.
            % You can rotate 3 times (each through 90 degrees clockwise) before checking out the whole Moore neighborhood of the pixel. 
            %If you rotate 3 times without finding any black pixels, this means that you are standing on an isolated pixel 
            % i.e. not connected to any other black pixel. That's why the algorithm will allow you to rotate 3 times before it terminates. 

            n = n + 1;
    
            heading = heading + 1;
            heading = Circularize(heading);
        
            clear P1 P2 P3;

            [ P1, P2, P3 ] = Set_P_Pix( Current_Pixel, heading );
            if (bin_img(P1(1),P1(2)) == 1)
                New_Pixel = P1;
                n = 5; % to quite inner while loop


            elseif (bin_img(P2(1),P2(2)) == 1)
                New_Pixel = P2;
                n = 5;

        
            elseif (bin_img(P3(1),P3(2)) == 1)
                New_Pixel = P3;
                n = 5;

            end % test of new P pix
    
        % If maybe done test for anything else in nearby zone
        end % 2nd while loop 

    end % big else-if tree
    
end % Examine P Pix


%--------------------------------------------------------------------------
function[ novel_pix_flag ] = Check_Boundary_List( Boundary_Pix_List, test_pixel )
    
    bindex = 1;
    Not_Done = 1;
    novel_pix_flag = 1;
    num_el = size(Boundary_Pix_List,1);
    
    while (Not_Done)
        
        
        if ( (Boundary_Pix_List(bindex,1) == test_pixel(1)) && (Boundary_Pix_List(bindex,2) == test_pixel(2)) )
            Not_Done = 0;
            novel_pix_flag = 0; % Not, novel
        end
        
        bindex = bindex + 1;
        
        if (bindex > num_el)
            Not_Done = 0;
        end % test for end of list
        
    end % while loop
end % check boundary list

%--------------------------------------------------------------------------
function[ heading ] = Init_Heading( bin_img, start_pixel )
% make sure that you enter the start pixel in a direction which ensures that the left adjacent pixel to it will be ON
%  ("left" here is taken with respect to the direction in which you enter the start pixel ). 

% We work our way through the headings possible and look for an appropriate
% one
% 1 = N, 2 = E, 3 = S, 4 = W

% I am interpretting this as looking for a pixel that heading points to that is on

% first we test for up-left diag pixel to be on 
if ( bin_img( (start_pixel(1) - 1), (start_pixel(2)) ) == 1 )

        heading = 1;

elseif ( bin_img( (start_pixel(1)), (start_pixel(2) - 1) ) == 1 )

        heading = 2;

elseif ( bin_img( (start_pixel(1) + 1), (start_pixel(2)) ) == 1 )

        heading = 3;

elseif ( bin_img( (start_pixel(1)), (start_pixel(2) + 1) ) == 1 )

        heading = 4;

else
    heading = 1;
    disp('Heading panic in bug init! INITIATING SELF DESTRUCT SEQUENCE');
    %keyboard

end  % heading if-then

end % init heading