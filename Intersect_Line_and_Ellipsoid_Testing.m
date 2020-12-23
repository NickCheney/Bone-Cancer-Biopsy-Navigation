% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q3. Intersect-Line-and-Ellipsoid Testing: This script tests the function
% Intersect_Line_and_Ellipsoid() that computes the number of intersections
% of a line and a ellipsoid and their values. To do so, it calls its
% function case_test(), which tries calling Intersect_Line_and_Ellipsoid()
% with various values for P, v, a, b, c.

%The script starts by calling Intersect_Line_and_Ellipsoid() with invalid
%input(s) via case_test()

% string value provided as argument
case_test([0 0 0], [0 0 1], 1, 1, "z half-axis val");
% half-axis value a has wrong dimensionality
case_test([0 0 0], [0 0 1], [1 4], 2, 3)
% line point value has wrong dimensionality
case_test([0; 0; 0], [0 0 1], 1, 2, 3)

% And now for valid inputs

% Two intersections
case_test([0 0 0], [0 0 1], 2, 2, 2)

% One intersection
case_test([0 1 0], [0 0 1], 1, 1, 1)

% and none
case_test([0 2 0], [0 0 1], 1, 1, 1)

function case_test(P, v, a, b, c)
% case_test(P, v, a, b, c) attempts to call the function
% Intersect_Line_and_Ellipsoid() to find the intersection or symbolic
% intersection of a line and ellipsoid, represented by fixed-point P and
% direction vector n, and half-axes values a, b and c, respectively. It
% will then either print the number of intersections and their values
% returned from the function, or catch an error thrown by the function,
% display the error message to stderr and then terminate. 
% INPUTS:
%       P - fixed point component of the line
%       v - direction vector component of the line
%       a - half x axis length of ellipsoid
%       b - half y axis length of ellipsoid
%       c - half z axis length of ellipsoid
% OUTPUTS:
%       None
% SIDE EFFECTS:
%       On valid input prints the number of intersections of the line and
%       ellipsoid as well as their values.
% 
%       Otherwise, catches and prints any error message thrown by
%       Intersect_Line_and_Ellipsoid() to stderr, then terminates.
%   
fprintf("Finding the intersection of a line and ellipsoid:\n");
try
    % Attempt to assign variables to the output of Intersect_Line_and_Ellipsoid()
    [num_of_ints, ints] = Intersect_Line_and_Ellipsoid(P, v, a, b, c);
catch e 
    %error is thrown because input wasn't valid or lines were parallel
    fprintf(2, e.message); % print error's message to stderr
    fprintf("\n\n");
    return; % terminate
end

% Variables successfully assigned, proceed to outputting ellipsoid and line
% equations and number of intersections and intersection values
fprintf("L = (%g, %g, %g) + t(%g, %g, %g)\n", P(1), P(2), P(3), v(1),v(2), v(3))
fprintf("Ellipsoid: x^2/%g + y^2/%g + z^2/%g = 1\n", a^2, b^2, c^2)
fprintf("Number of intersections: %g\n",num_of_ints);
if (num_of_ints == 2)
    % print both intersections
    fprintf("Intersection 1: (%g, %g, %g)\n", ints(1,1), ints(1,2), ints(1,3))
    fprintf("Intersection 2: (%g, %g, %g)\n\n", ints(2,1), ints(2,2), ints(2,3))
elseif (num_of_ints == 1)
    % print single intersection
    fprintf("Intersection: (%g, %g, %g)\n\n", ints(1), ints(2), ints(3))
% otherwise, no intersections to print
end

end