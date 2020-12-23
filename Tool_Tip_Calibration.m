% Nick Cheney
% SN 20063624
% 2020/11/24
% CISC 330 
% Bone Cancer Biopsy Navigation
% 
% Q1.1 a) Tool_Tip_Calibration(): This function uses the Moore-Penrose
% pseudo-inverse method of calibrating a tracking tool tip (pivot
% calibration) to compute accurate coordinates for the tip of the tool
% within the marker/tool coordinate frame.

function Tip_tool = Tool_Tip_Calibration(MarkerPts)
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

% First, we create an empty matrix A that will later store the Rotational
% component of each frame transformation taking a a point from the tool
% coordinate frame to the tracker coordinate frame (Ri) combined with an
% equivalent number of negative identity matrices in the form 
% A = [[R1, -I];...;[Rn, -I]]. This will come in handy to compute pM values
% later.
A = [];
% Also, create an empty vector t which will eventually hold negatives of
% transformation constants t1...tn
t = [];

% Now loop through input sets of tracker points to compute frame
% transformations from tool to tracker frames, and build matrix A and
% vector t
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
    
    % from this frame transformation, we can extract the translation vector
    % from C_tool to C_tracker and add it's negative to the transformation
    % constant vector
    ti = [F_T(1,4), F_T(2,4), F_T(3,4)];
    t = [t; -ti.'];
    
    % then crop the matrix to get the Rotational component and add this,
    % along with a 3x3 -I matrix to the A matrix
    F_T(4,:) = [];
    F_T(:,4) = [];
    Ri = F_T;
    A = [A; Ri -eye(3)];  
end
% now, given the matrix equation Ax=b we have A and b (a.k.a. t), and we
% can premultiply each side by the Moore-Penrose pseudo-inverse to get
% an approximate x. In this case, x is a matrix contain repeats of points
% pM and pT, the computed positions of the tool tip in the tool frame and
% tracker frame, respectively
x = pinv(A) * t;

% Given the resulting x vector, we can take the first three rows to give us
% the approximated pM coordinates in the tool frame
Tip_tool = [x(1) x(2) x(3)];

end