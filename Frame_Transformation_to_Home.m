% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q9 Frame_Transformation_to_Home: This script contains the function
% Frame_Transformation_to_Home() that uses the centre and base vectors of a
% particular frame to compute the frame transformation that takes the frame
% to home, represented as a 4x4 homogenous matrix. 

function Fv2h = Frame_Transformation_to_Home(Ov, v1, v2, v3)
% Frame_Transformation_to_Home uses the arbitrary frame v, defined by
% centre Ov and base vectors v1, v2, v3, to generate a homogenous
% transformation matrix that takes points in this frame to the home frame.
% The function will validate that all input is numerical and of size 1x3,
% or else it will throw an error. 
% INPUTS:
%       Ov - central point of arbitrary frame v
%       v1 - first base vector of frame v
%       v2 - second base vector of frame v
%       v3 - third base vector of frame v
% OUTPUTS:
%       Fv2h - the 4x4 homogenous transformation matrix that transforms v
%       to home
% SIDE EFFECTS:
%       Input is validated to ensure all arguments are numeric and of size
%       1x3, an error is thrown otherwise.

% first, we need to validate the input. all values must be numeric and
% must have 1x3 dimensionality.
type = {'numeric'};
size = {'size',[1, 3]};
% Validate point and vectors
validateattributes(Ov, type, size)
validateattributes(v1, type, size)
validateattributes(v2, type, size)
validateattributes(v3, type, size)

% Now we can begin the computation

% First, we can compute a homogenous rotation matrix as described in the
% notes (R_h<-v).
Rv2h = [v1(1), v2(1), v3(1), 0;...
        v1(2), v2(2), v3(2), 0;...
        v1(3), v2(3), v3(3), 0;...
        0, 0, 0, 1];

% Then, we'll compute a homogenous transformation matrix (T_h<-v), which
% will simply incorporate 3x1 transformation vector Ov into a 4x4 matrix:
Tv2h = [1, 0, 0, Ov(1);...
        0, 1, 0, Ov(2);...
        0, 0, 1, Ov(3);...
        0, 0, 0, 1];

% Finally, we can compute the overall frame transformation matrix, knowing
% the equation F_h<-v = T_h<-v * R_h<-v
Fv2h = Tv2h*Rv2h;
end