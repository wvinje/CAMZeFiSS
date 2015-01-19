function[ slice_CA ] = Set_Slides_XLS(xls_fn, structure_number, up_flag, UCS)

% Construct Slide Information Cell Arrays
% These arrays hold information such as the slide number, ordinal z-position in
% the stack and the appropriate color-key for reading the given contour
% from the slide


% read xls file
[num_mat, txt, raw] = xlsread(xls_fn);

% process structure
slice_CA = [];
slice_ind = 1;

num_rows = size(num_mat, 1);

for i = 1:num_rows, 
    
  if (num_mat(i, 3) == up_flag)  
    % is there a valid entry; the 666 flag is used to mark ?
    if ( (num_mat(i,structure_number) ~= 666) && ( ~isnan(num_mat(i,structure_number)) ) ),
        
       filenum1 = num_mat(i,1);
       filenum2 = num_mat(i,2);
       
       if (up_flag)
            if (filenum2 == 10),
                slide_info.slide_fn = cat(2,UCS.slide_base_fn,num2str(filenum1),'_',num2str(filenum2),'UP_New.psd');
            else
                slide_info.slide_fn = cat(2,UCS.slide_base_fn,num2str(filenum1),'_0',num2str(filenum2),'UP_New.psd');
            end              
       else    
            if (filenum2 == 10),
                slide_info.slide_fn = cat(2,UCS.slide_base_fn,num2str(filenum1),'_',num2str(filenum2),'DOWN_New.psd');
            else
                slide_info.slide_fn = cat(2,UCS.slide_base_fn,num2str(filenum1),'_0',num2str(filenum2),'DOWN_New.psd');
            end      
       end % filename test
       
       slide_info.filenum1 = filenum1;
       slide_info.filenum2 = filenum2;
       
       slide_info.slide_z = ((filenum1 - 6)*10) + filenum2;
            
       slide_info.struct_color_key = num_mat(i,structure_number);
       
       slice_CA{slice_ind} = slide_info;
       
       slice_ind = slice_ind + 1;
       clear slide_info;
       
    end % valid entry check 
    
  end % up test  
  
end % loop through rows

