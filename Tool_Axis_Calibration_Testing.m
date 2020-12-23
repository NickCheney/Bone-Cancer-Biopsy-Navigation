% Nick Cheney
% SN 20063624
% 2020/11/24
% CISC 330 
% Bone Cancer Biopsy Navigation
% 
% Q1.2 b) Tool Tip Calibration Testing: This script tests the function
% Tool_Axis_Calibration() by generating N = 50 rotation poses of the tool
% markers around the y axis of the tracker frame, then feeding these points
% to Tool_Axis_Calibration() and checking whether the calibrated tool axis
% direction vector matches the ground truth prediction.

N = 50;
% First initialize a vector to hold the N = 50 rotation poses of the
% markers as they are rotated around the y axis (0-360 degrees). 
RotMarkerPts = [];

% set local tracker point variables to globally set ground truth positions
A = A0;
B = B0;
C = C0;

% fill the initialized vector with points in each pose

degIncr = 360/N;
% Compute rotation matrix around y-axis based on degree increment.
[Ry, ~] = Rotation_About_Frame_Axis("y", degIncr);
for i = 1:N
    % each iteration, record the marker positions in the tracker frame then
    % rotate by a certain increment around the y-axis and repeat. 
    RotMarkerPts = [RotMarkerPts; A, B, C];
    
    A = (Ry * A.').';
    B = (Ry * B.').';
    C = (Ry * C.').';  
end

% Using the filled vector of marker points at various points in the
% rotation, we can now pass these values to Tool_Axis_Calibration() to test
% the function and see if a correct vax_tool is returned based on the
% ground-trith set-up.
vax_tool = Tool_Axis_Calibration(RotMarkerPts);

fprintf("Expected ground truth tool axis direction vector: [0, 1, 0]\n")
fprintf("Calculated tool axis direction vector: [%.4f, %.4f, %.4f]\n\n", vax_tool(1), vax_tool(2), vax_tool(3))