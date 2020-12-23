% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q2. Intersect-Line-And-Plane Testing: This script tests the function
% Intersect_Line_and_Plane() that computes the intersection of a line and a
% plane. To do so, it calls its function case_test(), which tries calling
% Intersect_Line_and_Plane() with various values for A, n, P and v.

%The script starts by calling Intersect_Line_and_Plane() with invalid
%input(s) via case_test()

%non-numerical argument provided
case_test("point", [0, 0, 1], [0, 0, 0], [0, 0, 1]);
%incorrect number of elements in vector argument
case_test([0,0,0,0], [0, 0, 0], [0, 0, 10], [1, 1, 0]);
%column vector argument provided instead of row vector
case_test([0,0,0], [1, 1, 1], [0, 0, 10], [1; 1; 0]);

%Then it calls case_test() with a valid input
case_test([0, 0, 0], [0, 0, 1], [0, 1, 0], [0, 0, 1]);
%And then a parallel line and plane
case_test([0, 0, 0], [0, 0, 1], [0, 0, 1], [0, 1, 0]);
%And another with the line contained in the plane
case_test([0, 0, 0], [0, 0, 1], [0, 0, 0], [0, 1, 0]);

function case_test(A, n, P, v)
% case_test(A, n, P, v) attempts to call the function
% Intersect_Line_and_Plane() to find the intersection of a plane and line,
% represented by fixed-point A and normal vector n, and point P and
% direction vector v, respectively. It will then either print the
% intersection returned from the function, or catch an error thrown by the
% function, display the error message to stderr and then terminate. 
% INPUTS:
%       A - fixed point component of the plane
%       n - normal vector component of the plane
%       P - fixed point component of the line
%       v - direction vector component of the line
% OUTPUTS:
%       None
% SIDE EFFECTS:
%       On valid input prints the intersection of a non-parallel line and
%       plane, or an error message if the two are parallel.
% 
%       Otherwise, catches and prints any error message thrown by
%       Intersect_Line_and_Plane() to stderr, then terminates.
%      
fprintf("Finding the intersection of a plane and line:\n");
try
    %attempt to assign int to output of Intersect_Line_and_Plane()
    int = Intersect_Line_and_Plane(A, n, P, v);
catch e %error is thrown because input wasn't valid or lines were parallel
    fprintf(2, e.message + "\n\n"); % print error's message to stderr
    return; % terminate
end

%variables successfully assigned, proceed to outputting equations of L1
%and L2
fprintf("Plane %g(x - %g) + %g(y - %g) + %g(z - %g) = 0; L = (%g, %g, %g) + t"...
    +"(%g, %g, %g)\n", n(1), A(1), n(2), A(2), n(3), A(3), P(1), P(2), ...
    P(3), v(1), v(2), v(3));
fprintf("Intersection: (%g, %g, %g)\n\n", int(1), int(2), int(3));
end   