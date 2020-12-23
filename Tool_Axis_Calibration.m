% Nick Cheney
% SN 20063624
% 2020/11/24
% CISC 330 
% Bone Cancer Biopsy Navigation
% 
% Q1.2 a) Tool_Axis_Calibration(): This function performs rotation axis
% calibration on a tracked tool to accurately compute the tool's axis
% direction vector within the marker/tool frame.

function vax_tool = Tool_Axis_Calibration(MarkerPts)
% Takes a vector of marker points A,B and C, recorded in the tracker frame,
% from different poses of the rotation of a tracked pointer tool,
% experimentally determined through calibration, and uses these to
% calculate the axis direction vector within the tool or marker frame.
% INPUTS:
%       MarkerPts - a Nx9 vector of pts A, B, and C of recorded rotational
%       marker positions in the tracker frame of the tool, with each row
%       holding the form [[Ax, Ay, Az], [Bx, By, Bz], [Cx, Cy, Cz]]
% OUTPUTS:
%       vax_tool - the coordinates of the axis direction vector within the
%       tool frame
% SIDE EFFECTS:
%       None

% First, we need to separate the input into 3 seperate vectors of points
% for each marker so that each vector can be fed into the plane fit
% function cited below.
Apts = [MarkerPts(:,1), MarkerPts(:,2), MarkerPts(:,3)];
Bpts = [MarkerPts(:,4), MarkerPts(:,5), MarkerPts(:,6)];
Cpts = [MarkerPts(:,7), MarkerPts(:,8), MarkerPts(:,9)];

% Then, find the normal for each set of points using the cited function
[nA, ~, ~] = affine_fit(Apts);
[nB, ~, ~] = affine_fit(Bpts);
[nC, ~, ~] = affine_fit(Cpts);
% Convert them to their transposes
nA = nA.';
nB = nB.';
nC = nC.';

% Then check if each normal is going in the same direction
if (dot(nA, nB) < 0)
    % flip the sign of nB so it matches nA's direction
    nB = -nB;
end
if (dot(nA, nC) < 0)
    % flip the sign of nC so it matches nA's direction
    nC = -nC;
end

% Now that each normal should be in the same direction, we can average them
% to find vT in the tracker frame:
vT = mean([nA; nB; nC]);

% Now, run through marker points again and in each pose transform vT to the
% marker frame to get vMi

% initialize an empty matrix to hold vMi values as calculated
vM = [];

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
    % It is now worth noting we only need the rotational component of the
    % matrix, because the tool axis direction vector does not need to be
    % translated when it is moved to the tool frame.
    F_M(4,:) = [];
    F_M(:,4) = [];
    
    vMi = F_M * vT.';
    % add vMi transpose to overall vM matrix
    vM = [vM; vMi.'];
end
% Now, take the average of all vMi for the final vector of the tool axle
vax_tool = mean(vM);
end


% This function performs a plane fit on an input vector of points. It was
% taken from MATLAB file exchange. 
% Citation: 
% Adrien Leygue (2020). Plane fit
% (https://www.mathworks.com/matlabcentral/fileexchange/43305-plane-fit),
% MATLAB Central File Exchange. Retrieved November 27, 2020.
function [n,V,p] = affine_fit(X)
    %Computes the plane that fits best (lest square of the normal distance
    %to the plane) a set of sample points.
    %INPUTS:
    %
    %X: a N by 3 matrix where each line is a sample point
    %
    %OUTPUTS:
    %
    %n : a unit (column) vector normal to the plane
    %V : a 3 by 2 matrix. The columns of V form an orthonormal basis of the
    %plane
    %p : a point belonging to the plane
    %
    %NB: this code actually works in any dimension (2,3,4,...)
    %Author: Adrien Leygue
    %Date: August 30 2013
    
    %the mean of the samples belongs to the plane
    p = mean(X,1);
    
    %The samples are reduced:
    R = bsxfun(@minus,X,p);
    %Computation of the principal directions if the samples cloud
    [V,D] = eig(R'*R);
    %Extract the output from the eigenvectors
    n = V(:,1);
    V = V(:,2:end);
end