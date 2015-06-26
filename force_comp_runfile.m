%---------------------------
% Plot force_comp figures
% TMohren 2015-06-25
%---------------------------

clc;clear all;close all;
location = 'D:\Mijn_documenten\Dropbox\Afstuderen\x. Matlab\TorsionWing-adaptedTMV3\';


% create figure for single axis of rotation 
n           = 500;
t           = linspace(0,1,n);
r           = 0.04;
f_flap      = 10;
f_vec       = t*f_flap;
f_rot       = 3;
[om_x,om_y,om_z, per ] = deal(0,0,1,1);

[phi,per_p,a_in,a_cent,a_cor,a_per,a_g ] = force_comp(t,n,r,f_flap,f_rot,om_x,om_y,om_z,per);


figure()
subplot(411)
    if per == 1
        plot(t,[phi*180/pi;per_p*180/pi])
    elseif per == 0
        plot(t,[phi*180/pi])
    end
    title(sprintf('Omega_x %d, Omega_y %d, Omega_z %d, Periodic %d',[om_x*f_rot,om_y*f_rot,om_z*f_rot,per]))
     xlabel('t [s]')
    ylabel('\phi [deg]','Rot',0)
    legend('\phi','\int \Omega')
subplot(412)
    plot(t,[a_in(1,:);a_cor(1,:); a_cent(1,:) ;a_per(1,:)])
    xlabel('t [s]')
    ylabel('a_x [ms^{-2}]','Rot',0)
subplot(413)
    plot(t,[a_in(2,:);a_cor(2,:);a_cent(2,:);a_per(2,:)])
    xlabel('t [s]')
    ylabel('a_y [ms^{-2}]','Rot',0)
subplot(414)
    plot(f_vec,[a_in(3,:);a_cor(3,:);a_cent(3,:);a_per(3,:)])
    xlabel('$\frac{f}{f_{flap}}$ [-]','interpreter','latex')
    ylabel('a_z [ms^{-2}]','Rotation',0)
    

legend('Flapping','Coriolis','Centrifugal', 'Euler');

figname = sprintf('forces_%d%d%d_periodic%d.svg',[om_x*f_rot,om_y*f_rot,om_z*f_rot,per]);
plot2svg(figname)  

