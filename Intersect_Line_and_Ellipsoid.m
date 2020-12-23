% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q3. Intersect-Line-And-Ellipsoid: This script contains the function
% Intersect_Line_and_Ellipsoid() that computes the intersection(s) of a line
% and a canonical ellipsoid.


function [num_ints, intersecs] = Intersect_Line_and_Ellipsoid(P, v, a, b, c)
% Intersect_Line_and_Ellipsoid(P, v, a, b, c) finds the intersection of a
% line, denoted by point P and dir. vector v, and a canonical ellipsoid
% (centered at home) with half-axis lengths a, b and c. It returns the
% number of intersections betweent the line and ellipsoid (0,1,2) and the
% list of intersections, returned as a matrice containing each intersection
% point as a row vector. The function will validate that input is all
% numerical, P and v have 1 x 3 dimensionality, a, b and c have 1 x 1
% dimensionality, and v has a non-zero magnitude, and throw
% an error if any of the above are not true. 
% INPUTS:
%       P - fixed point component of the line
%       v - direction vector component of the line
%       a - half x axis length of ellipsoid
%       b - half y axis length of ellipsoid
%       c - half z axis length of ellipsoid
% OUTPUTS:
%       num_ints, the number of intersections between the ellipsoid and the
%       line
% SIDE EFFECTS:
%       Input is validated to ensure all arguments are numeric, P and v
%       have 1x3 dimensionality, and a,b,c have 1x1 dimensionality. An
%       error is thrown if any values are invalid. Also, an error is thrown
%       if the direction vector v has magnitude 0.

% first, we need to validate the input. all values must be numeric, vectors
% must have 1x3 dimensionality and half-axes lengths must be singular
% values.
classes = {'numeric'};
vec_size = {'size',[1, 3]};
val_size = {'size',[1, 1]};
% First validate vector and point of line
validateattributes(P, classes, vec_size)
validateattributes(v, classes, vec_size)
% Then validate half-axes values
validateattributes(a, classes, val_size)
validateattributes(b, classes, val_size)
validateattributes(c, classes, val_size)

% Then, we'll check to see if the line's direction vector has magnitude 0,
% which isn't allowed for this computation.
if (norm(v) == 0)
    error("Direction vector v cannot have magnitude 0")
end

%Now, we can begin the computation. First, we'll assign the components of
%the line's point and dir. vector to their own variables for simplicity. 
Px = P(1);
Py = P(2);
Pz = P(3);
vx = v(1);
vy = v(2);
vz = v(3);

% Next, we need to consider the equations of the line and ellipsoid and
% derive a polynomial. Please see the pdf for my derivation. Eventually, we
% arrive at a quadratic equation in the form At^2 + Bt + C = 0, where t is
% the variable, and A, B, and C can be computed from the half-axes values
% and point and direction vector (broken into x,y,z components). These are
% calculated below:
A = vx^2/a^2 + vy^2/b^2 + vz^2/c^2;
B = 2*(Px*vx/a^2 + Py*vy/b^2 + Pz*vz/c^2);
C = Px^2/a^2 + Py^2/b^2 + Pz^2/c^2 - 1;

% Now, using the standard determinant of a quadratic equation, 
% D = b^2 - 4ac, we can compute the number of roots:
D = B^2 - 4*A*C;

% if D > 0 we have two real roots
if (D > 0)
    t1 = (-B + D)/(2*A); % find t value for first root using quadratic formula
    t2 = (-B - D)/(2*A); % find t value for second root
    int1 = P + t1*v; % find intersection point using first root t
    int2 = P + t2*v; % find intersection point using second root t
    num_ints = 2; % having passed condition D > 0, we know there are 2 roots
    intersecs = [int1; int2]; % return 2-D array of intersections
    
% if D = 0 we have two equivalent roots we will consider a single root
elseif (D == 0)
    t = -B/(2*A); % find t value for only root using quadratic formula
    num_ints = 1; % Here, we know there is only 1 unique intersection 
    intersecs = P + t*v; % find single intersection point
    
% And if D < 0 there are no real roots for us to consider
else
    num_ints = 0; % 0 real roots in this final case
    intersecs = []; % empty array returned since there are no intersections
end