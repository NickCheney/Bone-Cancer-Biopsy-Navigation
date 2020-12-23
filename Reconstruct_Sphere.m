% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q5 Reconstruct-Sphere: This script contains the function
% Reconstruct_Sphere() which recontructs the best-fitting sphere from a
% series of points.

function [C, R] = Reconstruct_Sphere(points)
% Reconstruct_Sphere(points) uses a function sphereFit() sourced from
% MATLAB file exchage (citation above function) to fit input points to a
% sphere using a least-squares method and return the centre and the radius
% of the reconstructed sphere. The function will validate that all elements
% of the input array, points, are numerical and each row has 3 elements.
% Failing these criteria, an error will be thrown. 
% INPUTS:
%       points - a matrice containing the coordinates of each point to be
%       fitted, row-wise.
% OUTPUTS:
%       C - the computed centre of the reconstructed sphere
%       R - the computed radius of the reconstructed sphere
% SIDE EFFECTS:
%       An error is thrown if points contains a non-numerical element or
%       doesn't have an nx3 dimensionality, where n is the number of points

% get first dimension of points array (number of points)
[num_points, ~] = size(points);
    
% Now, we need to validate the input. all values must be numeric, and
% each row of points must have 1x3 dimensionality.
type = {'numeric'};
attr = {'size', [num_points,3]};
validateattributes(points, type, attr);

% initilize flag to track algorithm completeness
done = false;
while ~done
    %caculate this iteration's centre of sphere and radius using
    %sphereFit()
    [C_temp, R_temp] = sphereFit(points);
    
    %set flag done to true, it will be back back to false later if any
    %outliers are detected
    done = true; 
    
    % Now we need to compute an error metric to judge points and remove
    % outliers
   
    % preallocating 1xn array for storing values of distances of each point
    % to the sphere
    dists = zeros(1, num_points);
    
    for i = 1:num_points
        % add each distance to the 1xn array
        dists(1, i) = R_temp - norm(points(i,:) - C_temp);
    end
    
    % find standard deviation of distances
    st_dev = std(dists);
    % find average distance
    avg = mean(dists);
    k = 3; % choose medium constant for filtering out "bad apples"
    
    % initilize counter
    i = 1;
    % loop through points to look for outliers
    while (i ~= num_points)
        % evaluate point as an outlier using condition |Avg - di| > k * STD
        if (abs(avg - dists(i)) > k*st_dev)
            % point fails outlier condition; since not all points pass
            % another interation is needed
            done = false;
%              fprintf("Removing outlier (%g, %g, %g)", points(i,1), ...
%                      points(i,2), points(i,3))
            % remove point by setting its row to []
            points(i,:) = [];
            % recalculate number of points
            [num_points, ~] = size(points);
            % skip counter increment
            continue
        end
        % increase counter
        i = i + 1;
    end
    
    % loop has terminated on an iteration with no outliers, output
    % variables can now be assigned
    C = C_temp;
    R = R_temp;
end

end


% The following function was taken from MATLAB File Exchange with the
% following citation: 

% Alan Jennings (2020). Sphere Fit (least squared)
% (https://www.mathworks.com/matlabcentral/fileexchange/34129-sphere-fit-least-squared),
% MATLAB Central File Exchange. Retrieved October 12, 2020

function [Center,Radius] = sphereFit(X)
% this fits a sphere to a collection of data using a closed form for the
% solution (opposed to using an array the size of the data set). 
% Minimizes Sum((x-xc)^2+(y-yc)^2+(z-zc)^2-r^2)^2
% x,y,z are the data, xc,yc,zc are the sphere's center, and r is the radius
% 
% Input:
% X: n x 3 matrix of cartesian data
% Outputs:
% Center: Center of sphere 
% Radius: Radius of sphere
% Author:
% Alan Jennings, University of Dayton
A=[mean(X(:,1).*(X(:,1)-mean(X(:,1)))), ...
    2*mean(X(:,1).*(X(:,2)-mean(X(:,2)))), ...
    2*mean(X(:,1).*(X(:,3)-mean(X(:,3)))); ...
    0, ...
    mean(X(:,2).*(X(:,2)-mean(X(:,2)))), ...
    2*mean(X(:,2).*(X(:,3)-mean(X(:,3)))); ...
    0, ...
    0, ...
    mean(X(:,3).*(X(:,3)-mean(X(:,3))))];
A=A+A.';
B=[mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,1)-mean(X(:,1))));...
    mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,2)-mean(X(:,2))));...
    mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,3)-mean(X(:,3))))];
Center=(A\B).';
Radius=sqrt(mean(sum([X(:,1)-Center(1),X(:,2)-Center(2),X(:,3)-Center(3)].^2,2)));
end