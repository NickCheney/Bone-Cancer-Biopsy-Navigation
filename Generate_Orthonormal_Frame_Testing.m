% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q7 Generate-Orthonormal-Frame-Testing: This script tests the function
% Generate_Orthonormal_Frame() which computes an orthonormal frame from the
% coordinates of three points. It does so by calling case_test() which
% tries calling Generate_Orthonormal_Frame() with various values for A, B
% and C. 


%start with two valid sets of points
case_test([0,0,0],[3,0,0],[0,3,0])
case_test([0,0,0],[0,3,0],[3,0,0])

%then three colinear points
case_test([0,0,0],[0,1,0],[0,2,0])

function case_test(A, B, C)
% case_test(A, B, C) attempts to call the function
% Generate_Orthonormal_Frame to return an orthonormal frame based on the
% points A, B and C. It will then either return the centre and basis
% vectors of the generated frame or catch an error thrown by the function,
% display the error message to stderr and then terminate. 
% INPUTS:
%       A - first reference point
%       B - second reference point
%       C - third reference point
% OUTPUTS:
%       None
% SIDE EFFECTS:
%       On valid input prints the orthonormal basis generated
% 
%       Otherwise, catches and prints any error message thrown by
%       Generate_Orthonormal_Frame() to stderr, then terminates.

fprintf("Generating an orthonormal frame based on points:\n");
try
    % Attempt to assign variables to the output of Intersect_Line_and_Ellipsoid()
    [ctr, v1, v2, v3] = Generate_Orthonormal_Frame(A, B, C);
catch e 
    %error is thrown because input wasn't valid or incorrect
    fprintf(2, e.message); % print error's message to stderr
    fprintf("\n\n");
    return; % terminate
end

% Variable successfully assigned, proceed to outputting points and
% generated frame
fprintf("A(%g, %g, %g), B(%g, %g, %g) and C(%g, %g, %G)\n", A(1),A(2),A(3)...
        ,B(1),B(2),B(3),C(1),C(2),C(3))
fprintf("Generated frame: Oe(%g, %g, %g), e1(%g, %g, %g), e2(%g, %g,"...
        +" %g), e3(%g, %g, %g)\n\n", ctr(1),ctr(2),ctr(3),v1(1),v1(2),...
        v1(3),v2(1),v2(2),v2(3),v3(1),v3(2),v3(3));

end