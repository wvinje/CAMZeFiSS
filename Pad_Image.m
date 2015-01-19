function[ new_img ] = Pad_Image( old_img, num_pad_pix )

[old_rows, old_cols] = size( old_img );

new_rows = old_rows + (2 * num_pad_pix);
new_cols = old_cols + (2 * num_pad_pix);

new_img = zeros(new_rows, new_cols);

new_img( (num_pad_pix+1):(num_pad_pix+old_rows), (num_pad_pix+1):(num_pad_pix+old_cols) ) = old_img;
