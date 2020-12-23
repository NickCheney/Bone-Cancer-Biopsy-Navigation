% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q5. Reconstruct_Sphere Testing: This script tests the function
% Reconstruct_Sphere() by generating X, Y, and Z matrices of sphere
% coordinates, transforming them, and calling the function to find the
% centre and radius of the sphere, reconstructed from the input points.

[X, Y, Z] = sphere(20);

% let's choose a radius of 5 and centre of (1, 1, 1)
radius = 5;
centre = [1, 1, 1];

X = radius*X + centre(1);
Y = radius*Y + centre(2);
Z = radius*Z + centre(3);

% now, we need to reshape the matrices to easily create a matrice of row
% vectors where each vector is a point (x, y, z)
X = reshape(X,[],1);
Y = reshape(Y,[],1);
Z = reshape(Z,[],1);

% create coordinate matrix
points = [X, Y, Z];
%get size of coordinates matrix
[num_pt, ~] = size(points);

% call function with matrice of points to compute radius and centre
[cent, rad] = Reconstruct_Sphere(points);

fprintf("Computed centre and radius for %g coordinates of sphere\n"...
        +" (x - %g)^2 + (y - %g)^2 + (z - %g)^2 = %g^2:\n", num_pt, centre(1)...
        ,centre(2), centre(3), radius);
fprintf("Centre: (%g, %g, %g), Radius: %g\n\n", cent(1), cent(2), cent(3), rad);





