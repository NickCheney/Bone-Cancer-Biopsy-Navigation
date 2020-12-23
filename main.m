% Nick Cheney
% SN 20063624
% 2020/11/24
% CISC 330 
% Bone Cancer Biopsy Navigation
% 
% this is the main script, which initializes some global variables and
% calls all testing scripts to run once.

% global variables are set below to be used in other modules, but will
% remain unchanged.

% In Tracker frame:
% Ground-truth tool tracker points 
global A0;
A0 = [0,20,0] + [-2, -2, 0];
global B0;
B0 = [0,20,0] + [4, -2, 0];
global C0;
C0 = [0,20,0] + [-2, 4, 0];

% In Tool frame
global TIPTOOL; %position of tool tip
TIPTOOL = [0, -20, 0];
global VAXTOOL; %direction vector of primary tool axis
VAXTOOL = [0, 1, 0];

% In CT frame:
% Coordinates of patient trackers
global A_PAT_CT;
A_PAT_CT = [-2, 8, 5];
global B_PAT_CT;
B_PAT_CT = [4, 8, 5];
global C_PAT_CT;
C_PAT_CT = [-2, 14, 5];
% tumor centre coordinates
global TUM_CTR_CT;
TUM_CTR_CT = [0, 0, 0];
%tumor radius
global TUM_RAD_CT;
TUM_RAD_CT = 2;
% tumor window centre coordinates
global WIN_CTR_CT;
WIN_CTR_CT = [0, 5, 0];
% tumor window radius
global WIN_RAD_CT;
WIN_RAD_CT = 1;

fprintf("-------------Running Tool_Tip_Calibration_Testing Script-------------\n");
Tool_Tip_Calibration_Testing

fprintf("-------------Running Tool_Axis_Calibration_Testing Script-------------\n");
Tool_Axis_Calibration_Testing

fprintf("-------------Running Surgical_Navigation_Testing Script-------------\n");
Surgical_Navigation_Testing

