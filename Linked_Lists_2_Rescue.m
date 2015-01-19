function[ node_list ] = Linked_Lists_2_Rescue( messy_pix_list )

node_list = zeros(size(messy_pix_list));

% Start first node at point 1
node_list(1,:) = messy_pix_list(1,:);
[ messy_pix_list ] = Trim_Pix_List( messy_pix_list, 1 ); % Now trim that pixel off of the pix list

not_done = 1;
ref_point = node_list(1,:);
node_index = 1;

while (not_done)
% Add a "node", since we are only going one way around we only need one
% linkage... to me this will just be the next element in an array

    node_index = node_index + 1;
  
    list_size = size(messy_pix_list,1);
    d_vect = zeros(list_size,1);
    
    % What point is closest to the first node
    for in_index = 1:list_size,
    
        test_point = messy_pix_list(in_index, :);
    
        d_vect(in_index) = ( ((test_point(1) - ref_point(1)).^2) + ((test_point(2) - ref_point(2)).^2) ).^(1/2);

        clear test_point
        
    end  % loop over remaining pix 
    
    index2mess = find( d_vect == min(d_vect) );
    
    node_list(node_index,:) = messy_pix_list(index2mess(1),:);
    
    [ messy_pix_list ] = Trim_Pix_List( messy_pix_list, index2mess(1) );

    % check for exit condition
    if node_index == size(node_list,1);
        % Then we are done
        not_done = 0;
    else    
        % Move to the new node and repeat
        ref_point = node_list(node_index,:);
        clear d_vect
    end % test for exit
    
end % loop through rest of list



function[ trimmed_list ] = Trim_Pix_List( in_list, cut_index )

trimmed_list = zeros( size(in_list,1)-1 , size(in_list,2) );
len_trimmed = size(trimmed_list,1);
len_in = size(in_list, 1);

if (cut_index == 1)
    trimmed_list = in_list(2:len_in,:);
    
elseif (cut_index == len_in)
    trimmed_list = in_list(1:(len_in-1),:);
    
else
    trimmed_list(1:cut_index-1,:) = in_list(1:cut_index-1,:);
    trimmed_list(cut_index:len_trimmed,:) = in_list(cut_index+1:len_in,:);
    
end % handling special cases
