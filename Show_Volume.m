function[ ] = Show_Volume( X, Y, Z, V, color_flag)
% This function is a wrapper for the native matlab isosurface and isocaps
% functions. 
%
% It is likely that we will want to change how the colors are set in future
% versions. This version has limited flexibility. 

p = patch(isosurface(X, Y, Z, V, 0.5));
p2 = patch(isocaps(X, Y, Z, V, 0.5));
isonormals(X, Y, Z, V, p);

switch color_flag
    case 'r',
        set(p, 'FaceColor', 'red', 'EdgeColor', 'none');
        set(p2, 'FaceColor', 'red', 'EdgeColor', 'none');
    case 'b',
        set(p, 'FaceColor', 'blue', 'EdgeColor', 'none');
        set(p2, 'FaceColor', 'blue', 'EdgeColor', 'none');
    case 'g',
        set(p, 'FaceColor', 'green', 'EdgeColor', 'none');
        set(p2, 'FaceColor', 'green', 'EdgeColor', 'none');
    case 'm',
        set(p, 'FaceColor', 'magenta', 'EdgeColor', 'none');
        set(p2, 'FaceColor', 'magenta', 'EdgeColor', 'none');
    case 'y',
        set(p, 'FaceColor', 'yellow', 'EdgeColor', 'none');
        set(p2, 'FaceColor', 'yellow', 'EdgeColor', 'none');
end
