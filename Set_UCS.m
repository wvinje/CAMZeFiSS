function[ UCS ] = Set_UCS()

% This routine is used to collect all important user set variables
% It returns a user control structure that is used throughout the program. 

% User set variables:

% Base filename used in reading slide stacks
UCS.slide_base_fn = 'GreBlu9508M_V6_A0';


% This parameter controls the maximum number of times
% the contour following algorithm will attempt to strip 
% away pixels (in order to avoid dead-ending on a branch).
UCS.strip_limit = 300;


% Here we set basic parameters about the images to scale from
% pixels to histology_mm
UCS.x_offset = 696; %700;     % center offsets
UCS.y_offset = 520; %900;
% Examination of ruler tif that is presumably scaled properly: 516 pix per 2.0 mm 
UCS.x_scale = 2/516; % mm per pix
UCS.y_scale = 2/516;




% Here we set the various shrinkage factors
% they represent how much the histology slides are estimated to have shrunken from
% in vivo true sizes
UCS.left_rc_shrinkage = 1;%0.68;
UCS.right_rc_shrinkage = 1;%0.74;

UCS.left_dv_shrinkage = 0.82;
UCS.right_dv_shrinkage = 0.73;

UCS.left_ml_shrinkage = 0.97;
UCS.right_ml_shrinkage = 1.48;


UCS.z_max = 22; % max number of slices from lowest; hardset for 8 slides. 10 per, start from 6.2 go to 8.3


% We handle inter_slice_spacine
UCS.inter_slice_spacing = 0.08; %0.05;  this is the original value 

UCS.inter_slice_spacing_left = UCS.inter_slice_spacing / UCS.left_rc_shrinkage;
UCS.inter_slice_spacing_right = UCS.inter_slice_spacing / UCS.right_rc_shrinkage;


% Volumetric visualization
UCS.num_pix_perside_Vmat = [100, 100, 100];     % This is the number of pixels per dimension used in quantifying the volumetric model

UCS.num_interp_pts = 5;

UCS.step_size = 5;


