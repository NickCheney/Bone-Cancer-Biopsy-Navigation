% Nick Cheney
% SN 20063624
% 2020/11/24
% CISC 330 
% Bone Cancer Biopsy Navigation
% 
% Q1.1 a) BONUS Tool_Tip_Calibration_2(): This function uses the
% concentric sphere fitting method of calibrating a tracking tool tip
% (pivot calibration) to compute accurate coordinates for the tip of the
% tool within the marker/tool coordinate frame.

function Tip_tool = Tool_Tip_Calibration_2(MarkerPts)
% Takes a vector of marker points A,B and C, recorded in the tracker frame,
% from different poses of a tracked pointer tool, experimentally determined
% through calibration, and uses these to calculate the position of the tool
% tip within the tool or marker frame.
% INPUTS:
%       MarkerPts - a Nx9 vector of pts A, B, and C of recorded marker
%       positions in the tracker frame of the tool, with each row holding
%       the form [[Ax, Ay, Az], [Bx, By, Bz], [Cx, Cy, Cz]]
% OUTPUTS:
%       Tip_tool - the coordinates of the tool tip within the tool frame
% SIDE EFFECTS:
%       None

% Start by splitting input marker points into three separate vectors for
% sphere fitting, then use a function from assingment one to get the
% computed centres of the 3 spheres from A points, B points, and C points
Apts = [MarkerPts(:,1), MarkerPts(:,2), MarkerPts(:,3)];
Bpts = [MarkerPts(:,4), MarkerPts(:,5), MarkerPts(:,6)];
Cpts = [MarkerPts(:,7), MarkerPts(:,8), MarkerPts(:,9)];

% Next, feed these points through the sphere fitting module to get three
% values for the coordinates of the tool tip in the tracker frame
[Ca, ~] = Reconstruct_Sphere(Apts);
[Cb, ~] = Reconstruct_Sphere(Bpts);
[Cc, ~] = Reconstruct_Sphere(Cpts);

% then average these three centre points to get a pT value
pT = mean([Ca;Cb;Cc]);

% Now, run through marker points and in each pose transform pT to the
% marker frame to get pMi

% initialize an empty matrix to hold pMi values as calculated
pM = [];

% get size of MarkerPts list
[N, ~] = size(MarkerPts);
for i = 1:N
    % first, use the current set of marker points Pa, Pb, Pc to compute the
    % frame of the tool in the current pose.
    
    % Initialize points
    Pa = [MarkerPts(i, 1), MarkerPts(i, 2), MarkerPts(i, 3)];
    Pb = [MarkerPts(i, 4), MarkerPts(i, 5), MarkerPts(i, 6)];
    Pc = [MarkerPts(i, 7), MarkerPts(i, 8), MarkerPts(i, 9)];
    
    % Generate tool frame
    [F_tool,v1, v2, v3] = Generate_Orthonormal_Frame(Pa, Pb, Pc);
    
    % generate the transformation matrix from the tool frame to the tracker
    % frame
    F_T = Frame_Transformation_to_Home(F_tool,v1, v2, v3);
    % And invert this to get a transformation from the tracker frame back
    % to the marker/tool frame
    F_M = inv(F_T);
    
    pMi = F_M * [pT.'; 1];
    
    % unpad pMi
    pMi(4,:) = [];
    % add pMi transpose to overall vM matrix
    pM = [pM; pMi.'];
end
% Now, take the average of all pMi for the final tool tip point in the tool
% frame
Tip_tool = mean(pM);

end