% Nick Cheney
% SN 20063624
% 2020/11/24
% CISC 330 
% Bone Cancer Biopsy Navigation
% 
% Q1.1 b) Tool Tip Calibration Testing: This script tests the functions
% Tool_Tip_Calibration(), Tool_Tip_Calibration_2() and
% Tool_Tip_Calibration_3() by generating N = 100 simulated pivot poses for
% the tool within a 60 degree cone, starting from an initial ground truth
% pose, then feeding these points to
% Tool_Tip_Calibration()/Tool_Tip_Calibration_2()/Tool_Tip_Calibration_3()
% and checking whether the calibrated tool tip point matches the ground
% truth prediction.

% first initialize a vector to hold the coordinates of the markers in 100
% random poses within the 60 degree cone
RandMarkerPts = [];

% Then fill this vector with coordinates
N = 100;
for i = 1:N
    % set this iteration's marker points to ground truth values set in main
    A = A0;
    B = B0;
    C = C0;
    
    % randomly choose z or x axis as first axis of rotation
    if (rand > 0.5)
        fst_ax = "x";
    else 
        fst_ax = "z";
    end
    
    % and choose rotation in this axis, up to 30 degrees
    fst_rot = 30 * rand;
    
    % and rotate the points around the chosen axis by 0-30 degrees
    [R1, ~] = Rotation_About_Frame_Axis(fst_ax, fst_rot);
    A = (R1 * A.').';
    B = (R1 * B.').';
    C = (R1 * C.').';
    
    % then pick a degree value between 0-360 and rotate the points around
    % the y axis by this much
    snd_rot = 360 * rand;
    [R2, ~] = Rotation_About_Frame_Axis("y", snd_rot);
    A = (R2 * A.').';
    B = (R2 * B.').';
    C = (R2 * C.').';
    
    % and add these rotated points to the vector of marker points
    RandMarkerPts = [RandMarkerPts; A, B, C];
end

% With the recorded marker positions in 100 random spherical pivot poses
% within a 60-degree cone, we can now call Tool_Tip_Calibration() to
% compute the position of the tool tip within the Tool Frame, then test the
% bonus function to see if it produces the same result:
Tip_tool = Tool_Tip_Calibration(RandMarkerPts);
Tip_tool2 = Tool_Tip_Calibration_2(RandMarkerPts);
Tip_tool3 = Tool_Tip_Calibration_3(RandMarkerPts);
fprintf("Expected ground truth tool tip coordinates: [0, -20, 0]\n")
fprintf("Calculated tool tip coordinates with Moore-Penrose: [%.4f, %.4f, %.4f]\n", Tip_tool(1), Tip_tool(2), Tip_tool(3))
fprintf("Calculated tool tip coordinates with sphere fitting: [%.4f, %.4f, %.4f]\n", Tip_tool2(1), Tip_tool2(2), Tip_tool2(3))
fprintf("Calculated tool tip coordinates with plane intersection and Moore-Penrose: [%.4f, %.4f, %.4f]\n\n", Tip_tool3(1), Tip_tool3(2), Tip_tool3(3))
