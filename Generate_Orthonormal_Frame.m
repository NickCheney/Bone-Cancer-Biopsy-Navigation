% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q7 Generate-Orthonormal-Frame-Testing: This script contains the function
% Generate_Orthonormal_Frame() that uses three points in a cartesian
% coordinate frame to generate an orthonormal frame.

function [Oe, e1, e2, e3] = Generate_Orthonormal_Frame(A, B, C)
% Generate_Orthonormal_Frame generates an orthonormal frame centred at the
% centre of gravity of three points A, B, and C. The function returns the
% centre of the frame and three base vectors. The function will validate
% that all input is numerical and of size 1x3, or else it will throw an
% error. It will also throw an error if the three points are colinear,
% because in that case an orthonormal frame cannot be generated.
% INPUTS:
%       A - first reference point
%       B - second reference point
%       C - third reference point
% OUTPUTS:
%       Oe - centre of orthonormal frame
%       e1 - first base vector
%       e2 - second base vector
%       e3 - third base vector
% SIDE EFFECTS:
%       Input is validated to ensure all arguments are numeric and of size
%       1x3, an error is thrown otherwise.
%       
%       An error is also thrown if cross((B-A), (C-A)) = 0 (points are
%       colinear)

% first, we need to validate the input. all values must be numeric and
% must have 1x3 dimensionality.

type = {'numeric'};
pnt_size = {'size',[1, 3]};
% Validate points
validateattributes(A, type, pnt_size)
validateattributes(B, type, pnt_size)
validateattributes(C, type, pnt_size)

% check if points are colinear
if (cross((B-A),(C-A)) == 0)
    error("Points are colinear. A frame cannot be generated.")
end

Oe = (A + B + C)/3; % assign Oe to centre of gravity of points

% compute first base vector, simply a line between two of the points
e1 = B - A; 

% compute third base vector, take the cross product of e1 and a line
% between another 2 points
e3 = cross(e1, (C - A));

%and finally compute the second by finding the cross product of e1 and e3 to
%ensure orthogonality
e2 = cross(e3, e1);

% and normalize all of them
e1 = e1/norm(e1);
e2 = e2/norm(e2);
e3 = e3/norm(e3);
end