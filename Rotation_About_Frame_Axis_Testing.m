% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q8 Rotation_About_Frame_Axis_Testing: This script tests the function
% Rotation_About_Frame_Axis(), which computes a rotation matrix and
% homogenous rotation matrix for a rotation around a specified axis of a
% specific angle. It does so by calling case_test() which tries calling
% Rotation_About_Frame_Axis() with various values for axis, angle and
% point.

% attempt to call function with invalid axis value
case_test('d',90,[1 0 0]);

%then 3-valid inputs:
case_test('x',90, [0,0,1]);
case_test('y',180, [1,0,0]);
case_test('z',270, [1,0,0]);

function case_test(axis, angle, P)
% case_test(axis, angle, P) attempts to call the function
% Rotation_About_Frame_Axis to generate a rotation matrice and homogenous
% rotation matrice around the axis at the specified angle. It will then
% either print these matrices, as well as the new coordinates of P when
% multiplied by the rotation matrice, or catch an error thrown by the
% function, display the error message to stderr and then terminate. 
% INPUTS:
%       axis - the specified axis to rotate about (can be 'x', 'y', or 'z')
%       angle - the angle in degrees to rotate by
%       P - a point to be rotated using matrice
% OUTPUTS:
%       None
% SIDE EFFECTS:
%       On valid input prints the two rotation matrices generated, and the
%       new coordinates of P.
% 
%       Otherwise, catches and prints any error message thrown by
%       Generate_Orthonormal_Frame() to stderr, then terminates.

fprintf("Generating a rotation matrix and homogenous rotation matrix"...
        +" for rotation of %g degrees about axis %c \n", angle, axis);
try
    % Attempt to assign variables to the output of
    % Rotation_About_Frame_Axis()
    [RM, HRM] = Rotation_About_Frame_Axis(axis, angle);
catch e 
    %error is thrown because input wasn't valid or incorrect
    fprintf(2, e.message); % print error's message to stderr
    fprintf("\n\n");
    return; % terminate
end

% Variable successfully assigned, proceed to outputting matrices
fprintf("Rotation Matrix = \n%g\t%g\t%g\n%g\t%g\t%g\n%g\t%g\t%g\n",RM(1,1)...
        ,RM(1,2),RM(1,3),RM(2,1),RM(2,2),RM(2,3),RM(3,1),RM(3,2),RM(3,3));
fprintf("Homogenous Rotation Matrix = \n%g\t%g\t%g\t%g\n%g\t%g\t%g\t%g\n"...
        +"%g\t%g\t%g\t%g\n%g\t%g\t%g\t%g\n\n",HRM(1,1),HRM(1,2),HRM(1,3),...
        HRM(1,4),HRM(2,1),RM(2,2),RM(2,3),HRM(2,4),HRM(3,1),HRM(3,2),...
        HRM(3,3),HRM(3,4),HRM(4,1),HRM(4,2),HRM(4,3),HRM(4,4));
%compute new location of point
P2 = (RM*P.').';
fprintf("Point (%g, %g, %g) rotated around %c axis by %g degrees:\n",...
        P(1),P(2),P(3),axis,angle);
fprintf("(%g, %g, %g)\n\n", P2(1),P2(2),P2(3));

end