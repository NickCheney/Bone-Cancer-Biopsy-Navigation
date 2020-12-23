% Nick Cheney
% SN 20063624 
% 2020/10/10 
% CISC 330 
% Computational Geometry Assignment 
% 
% Q8 Rotation_About_Frame_Axis: This script contains the function
% Rotation_About_Frame_Axis() that uses a specified axis and an angle to
% generate a rotation matrix that rotates any point around the given axis
% by the angle.

function [rot_mat, homo_rot_mat] = Rotation_About_Frame_Axis(axis, angle)
% Rotation_About_Frame_Axis() produces both a rotation matrix and a
% homogenous rotation matrix given an axis to rotate about and an angle.
% The function will validate that the axis value provided is a char, either
% "x","y" or "z", and the angle is numeric and of dimension 1x1, and will
% throw an error otherwise.
% INPUTS:
%       axis - the specified axis to rotate about (can be 'x', 'y', or 'z')
%       angle - the angle in degrees to rotate by
% OUTPUTS:
%       rot_mat - the 3x3 generated rotation matrix
%       homo_rot_mat - the 4x4 homogenous rotation matrix
% SIDE EFFECTS:
%       Input is validated to ensure axis has value "x", "y", or "z", and
%       angle is a single numerical value. An error is thrown otherwise.

% validate angle argument
classes = {'numeric'};
size = {'size',[1,1]};
validateattributes(angle, classes, size);

%begin generation
cosA = cosd(angle);
sinA = sind(angle);
if (axis == 'x')
    % generate x-axis Rotation matrix from class notes formulas
    rot_mat = [1, 0, 0; 0, cosA, sinA; 0, -sinA, cosA];
    % pad rotation matrix to get homo. rot. matrix
    homo_rot_mat = rot_mat;
    homo_rot_mat(4,:) = [0, 0, 0];
    homo_rot_mat(:,4) = [0; 0; 0; 1];
elseif (axis == 'y')
    % generate y-axis Rotation matrix from class notes formulas
    rot_mat = [cosA, 0, -sinA; 0, 1, 0; sinA, 0, cosA];
    % pad rotation matrix to get homo. rot. matrix
    homo_rot_mat = rot_mat;
    homo_rot_mat(4,:) = [0, 0, 0];
    homo_rot_mat(:,4) = [0; 0; 0; 1];
elseif (axis == 'z')
    % generate z-axis Rotation matrix from class notes formulas
    rot_mat = [cosA, -sinA, 0; sinA, cosA, 0; 0, 0, 1];
    % pad rotation matrix to get homo. rot. matrix
    homo_rot_mat = rot_mat;
    homo_rot_mat(4,:) = [0, 0, 0];
    homo_rot_mat(:,4) = [0; 0; 0; 1];
else
    % axis is not x, y, or z and is therefore invalid
    error("Invalid value for axis. Valid value is 'x', 'y', or 'z'")
end