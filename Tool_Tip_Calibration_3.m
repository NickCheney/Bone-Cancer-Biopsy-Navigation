% Nick Cheney
% SN 20063624
% 2020/11/24
% CISC 330 
% Bone Cancer Biopsy Navigation
% 
% Q1.1 a) BONUS 2 Tool_Tip_Calibration_3(): This function computs accurate
% coordinates for the tip of the tool within the marker/tool coordinate
% frame by creating a system of equalities of the intersection of bisector
% planes between different poses of each tracker with pT, the tool tip in
% the tracker frame. This system is solved using the Moore-Penrose inverse.

function Tip_tool = Tool_Tip_Calibration_3(MarkerPts)
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

% First, we create 3 empty matrices Aa, Ab, Ac that will later store each
% bisector plane normal in the form Ax = [nx_1^T;...;nx_n^T]. This will
% come in handy to compute pM values later.
Aa = [];
Ab = [];
Ac = [];
% Also, create empty vectors bx which will eventually hold the dot
% products of the normal of each plane and the midpoint between each pair
% of marker points for a given marker.
ba = [];
bb = [];
bc = [];

% Now loop through input sets of tracker points to compute tracker point
% pair midpoints and bisector plane normals, and build matrices Ax and
% vectors bx
[N, ~] = size(MarkerPts);
for i = 1:N-1
    % first, store the current set of marker points Pa, Pb, Pc
    
    % Initialize points
    Pa1 = [MarkerPts(i, 1), MarkerPts(i, 2), MarkerPts(i, 3)];
    Pb1 = [MarkerPts(i, 4), MarkerPts(i, 5), MarkerPts(i, 6)];
    Pc1 = [MarkerPts(i, 7), MarkerPts(i, 8), MarkerPts(i, 9)];
    % loop again to get second point
    for j = i+1:N
        % Initialize points
        Pa2 = [MarkerPts(j, 1), MarkerPts(j, 2), MarkerPts(j, 3)];
        Pb2 = [MarkerPts(j, 4), MarkerPts(j, 5), MarkerPts(j, 6)];
        Pc2 = [MarkerPts(j, 7), MarkerPts(j, 8), MarkerPts(j, 9)];
        
        % With these pairs of points, we can now compute the midpoints and
        % bisector plane normals
        MPa = (Pa1 + Pa2) / 2;
        MPb = (Pb1 + Pb2) / 2;
        MPc = (Pc1 + Pc2) / 2;
        
        nA = (Pa1 - Pa2) / norm((Pa1 - Pa2));
        nB = (Pb1 - Pb2) / norm((Pb1 - Pb2));
        nC = (Pc1 - Pc2) / norm((Pc1 - Pc2));
        
        % now add the dot product of each normal with its respective
        % midpoint to the appropriate b vector
        ba = [ba; dot(nA, MPa)];
        bb = [bb; dot(nB, MPb)];
        bc = [bc; dot(nC, MPc)];
        
        % and add the normals to their respective A matrices
        Aa = [Aa; nA];
        Ab = [Ab; nB];
        Ac = [Ac; nC];
        
    end
end
% now, given the matrix equations A_x*p=b_x we have Ax and bx, and we can
% premultiply each side by the Moore-Penrose pseudo-inverse to get an
% approximate px. In this case, px is vector pT which is the computed
% position of the tool tip in the tracker frame based on one of the series
% of points for a given tracker
pTa = (pinv(Aa) * ba).';
pTb = (pinv(Ab) * bb).';
pTc = (pinv(Ac) * bc).';

% then average the pTx values to get a general pT:
pT = mean([pTa;pTb;pTc]);

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