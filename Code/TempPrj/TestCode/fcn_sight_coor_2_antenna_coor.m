function [PointEle,PointAzi]=fcn_sight_coor_2_antenna_coor(utrm,Uqy,Uqz,roll,pitch,yaw)
% utrm: 弹目距离
% Uqy：  俯仰视线角
% Uqz：  方位视线角
% roll： 弹体滚转角
% pitch: 弹体俯仰角
% yaw:   弹体方位角

% 输出：
% ele_point_angle 俯仰视线角
% azi_point_angle 方位视线角

roll = deg2rad(roll);
pitch = deg2rad(pitch);
yaw = deg2rad(yaw);
Uqy = deg2rad(Uqy);
Uqz = deg2rad(Uqz);
tar_mis_x = utrm*cos(Uqy)*cos(Uqz);
tar_mis_y = utrm*sin(Uqy);
tar_mis_z = -utrm*cos(Uqy)*sin(Uqz);

K_roll = [1,0,0;0,cos(roll),sin(roll);0,-sin(roll),cos(roll)];
M_pitch = [cos(pitch),sin(pitch),0;-sin(pitch),cos(pitch),0;0,0,1];
L_yaw = [cos(yaw),0,-sin(yaw);0,1,0;sin(yaw),0,cos(yaw)];
C_im = K_roll*M_pitch*L_yaw;
tar_in_mis = C_im*[tar_mis_x;tar_mis_y;tar_mis_z];
tar_in_mis_x = tar_in_mis(1);
tar_in_mis_y = tar_in_mis(2);
tar_in_mis_z = tar_in_mis(3);

R = sqrt(tar_in_mis_x^2+tar_in_mis_y^2+tar_in_mis_z^2);
PointEle = rad2deg(asin(tar_in_mis_y/R));
PointAzi = rad2deg(atan(-tar_in_mis_z/tar_in_mis_x));
end

