function [ out_vec ] = rotate_euler( om_x,om_y,om_z , in_vec )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
R_x = [1,0,0;
    0, cos(om_x), -sin(om_x);
    0, sin(om_x), cos(om_x)];

R_y = [cos(om_y), 0, sin(om_y);
    0, 1, 0;
    -sin(om_y), 0, cos(om_y)];
    
    
R_z = [cos(om_z), -sin(om_z), 0;
    sin(om_z), cos(om_z), 0;
    0,0,1];


out_vec = R_x * R_y * R_z *in_vec' ;

end

