% Reminder notes:

% Structure number key
% L3 green : col4
% LM dark red: col 5
% L2 blue : col 6
% LMD yellow : col 7
% NCM magenta : col 8
% Mid teal : col 9
% Ventricle red : col 10
% Surface : black col 11

% NB: based on Julie's remembrance:
% left is up / right is down

% First we setup the user control structure
[ UCS ] = Set_UCS();

% Start a figure
figure
hold

% Construct Slide Information Cell Arrays
% These arrays hold information such as the slide number, ordinal z-position in
% the stack and the appropriate color-key for reading the given contour
% from the slide

% Handle down
Green_Down_CA = Set_Slides_XLS('ColorKey.xlsx', 4, 0, UCS);
DeepRed_Down_CA = Set_Slides_XLS('ColorKey.xlsx', 5, 0, UCS);
Blue_Down_CA = Set_Slides_XLS('ColorKey.xlsx', 6, 0, UCS);
Yellow_Down_CA = Set_Slides_XLS('ColorKey.xlsx', 7, 0, UCS);
Magenta_Down_CA = Set_Slides_XLS('ColorKey.xlsx', 8, 0, UCS);

% Handle up
Green_Up_CA = Set_Slides_XLS('ColorKey.xlsx', 4, 1, UCS);
DeepRed_Up_CA = Set_Slides_XLS('ColorKey.xlsx', 5, 1, UCS);
Blue_Up_CA = Set_Slides_XLS('ColorKey.xlsx', 6, 1, UCS);
Yellow_Up_CA = Set_Slides_XLS('ColorKey.xlsx', 7, 1, UCS);
Magenta_Up_CA = Set_Slides_XLS('ColorKey.xlsx', 8, 1, UCS);

% Handle center
Black_CA = Set_Slides_XLS('ColorKey.xlsx', 11, 1, UCS);
Teal_CA = Set_Slides_XLS('ColorKey.xlsx', 9, 1, UCS);



%-----------------------
% Closed Structure Drawing
%-----------------------

% Step 1:
% Now we run each CA through Process_Slidestack to generate boundary pixel lists
% and then we use them all to go and make our axis space so that it
% properly emcompasses all slides

% init master cell array: each element will hold boundary pixel list from
% one of our structure cell arrays
bp_CA_all = [];
all_ind = 1;

[bp_CA_greenDwn] = Process_Slidestack( Green_Down_CA, 0, 'd', UCS);
bp_CA_all{all_ind} = bp_CA_greenDwn;
all_ind = all_ind + 1;

[bp_CA_dredDwn] = Process_Slidestack( DeepRed_Down_CA, 1, 'd', UCS);
bp_CA_all{all_ind} = bp_CA_greenDwn;
all_ind = all_ind + 1;

[bp_CA_blueDwn] = Process_Slidestack( Blue_Down_CA, 0, 'd', UCS);
bp_CA_all{all_ind} = bp_CA_blueDwn;
all_ind = all_ind + 1;

[bp_CA_yellowDwn] = Process_Slidestack( Yellow_Down_CA, 1, 'd', UCS);
bp_CA_all{all_ind} =  bp_CA_yellowDwn;
all_ind = all_ind + 1;

[bp_CA_magentaDwn] = Process_Slidestack( Magenta_Down_CA, 0, 'd', UCS);
bp_CA_all{all_ind} = bp_CA_magentaDwn;
all_ind = all_ind + 1;


[bp_CA_greenUp] = Process_Slidestack( Green_Up_CA, 0, 'u', UCS);
bp_CA_all{all_ind} = bp_CA_greenUp;
all_ind = all_ind + 1;

[bp_CA_dredUp] = Process_Slidestack( DeepRed_Up_CA, 1, 'u', UCS);
bp_CA_all{all_ind} = bp_CA_greenUp;
all_ind = all_ind + 1;

[bp_CA_blueUp] = Process_Slidestack( Blue_Up_CA, 0, 'u', UCS);
bp_CA_all{all_ind} = bp_CA_blueUp;
all_ind = all_ind + 1;

[bp_CA_yellowUp] = Process_Slidestack( Yellow_Up_CA, 1, 'u', UCS);
bp_CA_all{all_ind} =  bp_CA_yellowUp;
all_ind = all_ind + 1;

[bp_CA_magentaUp] = Process_Slidestack( Magenta_Up_CA, 0, 'u', UCS);
bp_CA_all{all_ind} = bp_CA_magentaUp;
all_ind = all_ind + 1;


% Step 2:
% Setup axis matrices for volumetric plotting
% Note: We need one axis space for each hemisphere due to different scaling
% factors 
[ ax_S_U ] = Create_Axis_Space( bp_CA_all, UCS.inter_slice_spacing_left, UCS.num_pix_perside_Vmat, UCS.z_max );
[ ax_S_D ] = Create_Axis_Space( bp_CA_all, UCS.inter_slice_spacing_right, UCS.num_pix_perside_Vmat, UCS.z_max );


% Step 3: Create volumetric matrices and draw

% Handle down hemisphere
[ VgreenD ] = Volume_Fill( Green_Down_CA, bp_CA_greenDwn, ax_S_D, UCS.num_pix_perside_Vmat, 'd', UCS );
Show_Volume(ax_S_D.X, ax_S_D.Y, ax_S_D.Z, VgreenD, 'g');

[ VblueD ] = Volume_Fill( Blue_Down_CA, bp_CA_blueDwn, ax_S_D, UCS.num_pix_perside_Vmat, 'd', UCS );
Show_Volume(ax_S_D.X, ax_S_D.Y, ax_S_D.Z, VblueD, 'b');

[ VmagentaD ] = Volume_Fill( Magenta_Down_CA, bp_CA_magentaDwn, ax_S_D, UCS.num_pix_perside_Vmat, 'd', UCS );
Show_Volume(ax_S_D.X, ax_S_D.Y, ax_S_D.Z, VmagentaD, 'm');

% Handle up hemisphere
[ VgreenU ] = Volume_Fill( Green_Up_CA, bp_CA_greenUp, ax_S_U, UCS.num_pix_perside_Vmat, 'u', UCS );
Show_Volume(ax_S_U.X, ax_S_U.Y, ax_S_U.Z, VgreenU, 'g');

[ VblueU ] = Volume_Fill( Blue_Up_CA, bp_CA_blueUp, ax_S_U, UCS.num_pix_perside_Vmat, 'u', UCS );
Show_Volume(ax_S_U.X, ax_S_U.Y, ax_S_U.Z, VblueU, 'b');

[ VmagentaU ] = Volume_Fill( Magenta_Up_CA, bp_CA_magentaUp, ax_S_U, UCS.num_pix_perside_Vmat, 'u', UCS );
Show_Volume(ax_S_U.X, ax_S_U.Y, ax_S_U.Z, VmagentaU, 'm');

save('emerg_save_2015');
%-----------------------
% Open Structure Drawing
%-----------------------

% Step 1: First we handle non-ventricle structures
Show_OC( DeepRed_Down_CA, bp_CA_dredDwn, 'r', 'd', UCS );
Show_OC( Yellow_Down_CA, bp_CA_yellowDwn, 'y', 'd', UCS );

Show_OC( DeepRed_Up_CA, bp_CA_dredUp, 'r', 'u', UCS );
Show_OC( Yellow_Up_CA, bp_CA_yellowUp, 'y', 'u', UCS );

keyboard

Struct_Stack( Teal_CA, 1, 1, 'c', 'u', UCS );     % NB: choice of u is arbitrary. This needs to be handled better. 
Struct_Stack( Black_CA, 1, 1, 'k', 'u', UCS );


% Step 2: Handle ventricles

cd('/Users/bvinje/Documents/WORK_CORE/THEUNISSEN_LAB/BIRD_BRAINS/EDITED_IMAGES/Julie_Fig_VentricleHell');
% Handle vent flail #1
Ventricle_Vomit_1 = Set_Slides_XLS('ColorKey_VentriclsSUX.xlsx', 10, 0);
Struct_Stack_Vent1( Ventricle_Vomit_1, 1, 0, 'r');

cd('/Users/bvinje/Documents/WORK_CORE/THEUNISSEN_LAB/BIRD_BRAINS/EDITED_IMAGES/Julie_Fig_VentricleHell_2ndlevel');
% Handle vent flail #2
Ventricle_Vomit_2 = Set_Slides_XLS('ColorKey_VentriclesSUX_2.xlsx', 10, 0);
Struct_Stack_Vent2( Ventricle_Vomit_2, 1, 0, 'r');

cd('/Users/bvinje/Documents/WORK_CORE/THEUNISSEN_LAB/BIRD_BRAINS/EDITED_IMAGES/Julie_Fig_VentricleHell');
% Handle vent flail #1
Ventricle_Vomit_1up = Set_Slides_XLS('ColorKey_VentriclsSUX.xlsx', 10, 1);
Struct_Stack_Vent1up( Ventricle_Vomit_1up, 1, 0, 'r');

cd('/Users/bvinje/Documents/WORK_CORE/THEUNISSEN_LAB/BIRD_BRAINS/EDITED_IMAGES/Julie_Fig_VentricleHell_2ndlevel');
% Handle vent flail #2
Ventricle_Vomit_2up = Set_Slides_XLS('ColorKey_VentriclesSUX_2.xlsx', 10, 1);
Struct_Stack_Vent2up( Ventricle_Vomit_2up, 1, 1, 'r');


%-----------------------
% Electrode Array Drawing
%-----------------------

[ trodz_CA ] = Build_Trode_Array(0, 0, 0);
Draw_Trode_Array( trodz_CA, -0.25, 0, 0.6);



%-----------------------
% Set Lighting and material and view
%-----------------------

%light('Position',[1 3 2]);  % all demos previous to 10
light('Position',[0 3 -1]);  % demo 10
material metal
lighting phong
grid
view(130,25);



%-----------------------
% Set Title and Axis Descriptions
%-----------------------

title('Centerline (teal), Ventricle (red), LH (dark red), LMD (yellow), NCM (magenta), L2 (blue) and L3 (green)');
xlabel('in-vivo mm');
ylabel('in-vivo mm');
zlabel('in-vivo mm');

