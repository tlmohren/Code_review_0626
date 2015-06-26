function [phi,per_p,a_in,a_cent,a_cor,a_per,a_g ] = force_comp( t,n,r,f_flap,f_rot,om_x,om_y,om_z,per )
%FORCE_COMP Computes forces on an oscillating point mass at distance r during inertial
%frame rotations
%   Created for the bendy wings project (2015-06-25)

rot_vec     = [om_x,om_y,om_z];
flap_amp    = 15;
table_amp   = 30;

% flapping angles, 
phi     = flap_amp/180*pi*cos(2*pi*f_flap*t);
phi_d1  = flap_amp/180*pi* -sin(2*pi*f_flap*t)*2*pi*f_flap;
phi_d2  = flap_amp/180*pi* -cos(2*pi*f_flap*t)*(2*pi*f_flap)^2;

% rotation angles
const       = f_rot*2*pi*ones(1,n);

if per == 0
    theta_p(1,:)     = t*f_rot*2*pi*rot_vec(1);
    theta_p(2,:)     = t*f_rot*2*pi*rot_vec(2);
    theta_p(3,:)     = t*f_rot*2*pi*rot_vec(3);
elseif per == 1
    theta_p(1,:)     = table_amp/180*pi*sin(2*pi*f_rot*t)*rot_vec(1);
    theta_p(2,:)     = table_amp/180*pi*sin(2*pi*f_rot*t)*rot_vec(2);
    theta_p(3,:)     = table_amp/180*pi*sin(2*pi*f_rot*t)*rot_vec(3);
end

per_p       = table_amp/180*pi*sin(2*pi*f_rot*t);
per_v       = table_amp/180*pi*cos(2*pi*f_rot*t)*2*pi*f_rot ;
per_a       = -table_amp/180*pi*cos(2*pi*f_rot*t)*(2*pi*f_rot)^2; 
z_vec       = zeros(1,n);

if per == 1
    omega = rot_vec'*per_v;
    omega_d1 = rot_vec'*per_a;
elseif per == 0
    omega = rot_vec'*const;
    omega_d1 = zeros(3,n);
end

x = r*sin(phi);
y = r*cos(phi);
z = zeros(1,n);
p = [x;y;z];

vx = r * cos(phi).*phi_d1;
vy = r * -sin(phi).*phi_d1;
vz = zeros(1,n);
v = [vx;vy;vz];

ax = r * ( -sin(phi).*phi_d1.^2 + cos(phi).*phi_d2);
ay = r * (-cos(phi).*phi_d1.^2 + -sin(phi).*phi_d2);
az = zeros(1,n);
a_in = [ax;ay;az];

F_g = [-9.81,0,0];
for i=1:n
    a_cor(1:3,i) = cross(omega(:,i),v(:,i))';
    a_cent(1:3,i) = cross(omega(:,i),cross(omega(:,1),p(:,i)))';
    a_per(1:3,i) = cross(omega_d1(:,i),p(:,i))';
%     a_g(1:3,i) = 9.81 * [cos(theta_p(2,i));1;sin(theta_p(2,i))] .*   [cos(theta_p(3,i));sin(theta_p(3,i));1]   
    a_g(1:3,i) = rotate_euler(theta_p(1,i),theta_p(2,i),theta_p(3,i),[F_g])';
end

end