% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q2. Intersect-Line-And-Plane: This script contains the function
% Intersect_Line_and_Plane() that computes the intersection of a plane and
% a non-parallel line.

function int = Intersect_Line_and_Plane(A, n, P, v)
% Intersect_Line_and_Plane(A, n, P, v) finds the intersection of a plane
% (denoted by fixed point A and normal vector n) and a line given by a
% point P and a direction vector v (standard line equation). It will either
% return the intersection of the line and plane if they are parallel, or
% throw a unique error message if the line is contained in the plane, or is
% parallel and not contained. Also, the function will validate that input
% is all numerical and all has 1 x 3 dimensionality, as well as n and v
% having non-zero magnitudes, and throw an error if not. 
% INPUTS:
%       A - fixed point component of the plane
%       n - normal vector component of the plane
%       P - fixed point component of the line
%       v - direction vector component of the line
% OUTPUTS:
%       int - the intersection of the line and the plane
% SIDE EFFECTS:
%       Input is validated to ensure A, n, P and v are 1x3 numeric row
%       vectors. If any are not, an error is thrown and the function
%       terminates. An error is also thrown if n or v are zero vectors,
%       as plane normal vectors and line direction vectors cannot have
%       magnitude 0
%
%       An error is thrown and the function will terminate if the line and
%       the plane are parallel, determined by checking if the normal vector
%       n and direction vector v are orthogonal.

% first, we need to validate the input. all values must be numeric and
% vectors must have 1x3 dimensionality
classes = {'numeric'};
attributes = {'size',[1, 3]};
validateattributes(A, classes, attributes)
validateattributes(n, classes, attributes)
validateattributes(P, classes, attributes)
validateattributes(v, classes, attributes)

if (norm(n) == 0) % check if n has magnitude 0
    % n is a zero vector, thus it cannot be used as a plane's normal vector
    error("Normal vector n cannot have magnitude 0");
elseif (norm(v) == 0) % check if v has magnitude 0
    % v is a zero vector, thus it cannot be used as a direction vector
    error("Direction vector v cannot have magnitude 0");
end

% first, find the dot product of the line's direction vector and the normal
% vector of the plane. This will determine if an intersection can be found
% or not. 
vn_dot = dot(v, n);

% check if the line vector and plane normal are orthogonal (dot product is
% zero)
if (vn_dot == 0)
    % line direction vector and plane normal vector are orthogonal, and
    % therefore the line and plane are parallel
    
    % Now, we'll compute a line between the plane fixed point A and the
    % line point P, then take the dot product. If the dot product is zero,
    % then the line between A and P is in the plane, and therefore P is in
    % the plane, and since the line direction vector was already determined
    % to be parallel to the plane, the line is in the plane.
    line_A2P = P-A;
    
    %see if the dot product of the line between A and P and the vector n is
    %equal to zero
    if (dot(line_A2P, n) == 0)
        % line contained in plane, throw unique error
        error("Line is contained in plane; no intersection can be computed")
    else
        % line not contained in plane, throw unique error
        error("Line is parallel to plane; no intersection can be computed.")
    end
end
% line direction vector and plane normal vector aren't orthogonal, so line
% and plane aren't parallel and we can compute an intersection

% Given the equation of the input line, L = P + vt, we can create another
% line L-A, by adjusting t so L is equal to the point of intersection
% between the input line and the plane. At this intersection, L-A and n are
% orthogonal, so the dot product of n and L-A is zero:
% (L - A)n = 0
% By plugging in the definition of L, we get
% (P + vt - A)n = 0
% Since dot products are distributive with addition we can expand this to
% (P - A)n + vtn = 0
% And then rearranging for t we get
% t = (A - P)n/vn

% Compute matlab equivalent of above equation (vn_dot is the dot product of
% v and n from before):
t = dot((A - P), n) / vn_dot;

% Now, plugging t back into the original line equation gives us the
% intersection
int = P + t*v;
end