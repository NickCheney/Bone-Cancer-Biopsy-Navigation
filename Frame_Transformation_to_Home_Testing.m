% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q9 Frame-Transformation-To-Home-Testing: This script tests the function
% Frame_Transformation_To_Home_Testing() which computes the tranformation
% matrice which takes the perspective v to home. It does so by calling
% case_test() which tries calling Frame_Transformation_To_Home() with
% various values for Ov, v1, v2, and v3.

% start with two pure translations
case_test([0,0,1],[1,0,0],[0,1,0],[0,0,1]);
case_test([0,1,0],[1,0,0],[0,1,0],[0,0,1]);
% then two pure rotations
case_test([0,0,0],[0,0,1],[1,0,0],[0,1,0]);
case_test([0,0,0],[0,0,1],[0,1,0],[-1,0,0]);
% then a combination
case_test([0,0,1],[0,0,1],[1,0,0],[0,1,0]);
case_test([0,1,0],[0,0,1],[0,1,0],[-1,0,0]);

function case_test(Ov, v1, v2, v3)
% case_test(Ov, v1, v2, v3) attempts to call the function
% Frame_Transformation_to_Home to return a transformation matrix that
% translates and rotates the perspective of Frame v to home. It will either
% return the matrix of the transformation or catch an error thrown by the
% function, display the error message to stderr and then terminate. 
% INPUTS:
%       Ov - central point of arbitrary frame v
%       v1 - first base vector of frame v
%       v2 - second base vector of frame v
%       v3 - third base vector of frame v
% OUTPUTS:
%       None
% SIDE EFFECTS:
%       On valid input prints the transformation matrix generated
% 
%       Otherwise, catches and prints any error message thrown by
%       Frame_Transformation_to_Home() to stderr, then terminates.

fprintf("Finding the transformation matrix to take the persective of the"...
        +" frame v to home:\n");
try
    % Attempt to assign variable to the output of
    % Frame_Transformation_to_Home()
    F_hv = Frame_Transformation_to_Home(Ov, v1, v2, v3);
catch e 
    %error is thrown because input wasn't valid or incorrect
    fprintf(2, e.message); % print error's message to stderr
    fprintf("\n\n");
    return; % terminate
end

% Variable successfully assigned, proceed to outputting matrice
fprintf("Frame V: Ov(%g, %g, %g), v1(%g, %g, %g), v2(%g, %g, %g), v3(%g"...
        +",%g,%g)\n", Ov(1),Ov(2),Ov(3),v1(1),v1(2),v1(3),v2(1),v2(2),...
        v2(3),v3(1),v3(2),v3(3));
fprintf("Transformation matrice=\n%g\t%g\t%g\t%g\n%g\t%g\t%g\t%g"...
        +"\n%g\t%g\t%g\t%g\n%g\t%g\t%g\t%g\n\n",F_hv(1,1),F_hv(1,2),F_hv(1,3)...
        ,F_hv(1,4),F_hv(2,1),F_hv(2,2),F_hv(2,3),F_hv(2,4),F_hv(3,1),...
        F_hv(3,2),F_hv(3,3),F_hv(3,4),F_hv(4,1),F_hv(4,2),F_hv(4,3),F_hv(4,4));

end