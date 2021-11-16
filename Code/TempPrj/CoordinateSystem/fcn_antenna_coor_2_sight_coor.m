% 目标在天线系下指向角解其视线角
function [outputArg1,outputArg2] = fcn_antenna_coor_2_sight_coor(inputArg1,inputArg2)
% 输入： 弹目距离
% ele_point_angle 俯仰波束指向角
% azi_point_angle 方位波束指向角
% yaw 平台偏航角
% pitch 平台俯仰角
% roll 平台滚转角
% 输出：
% ele_sight_angle 俯仰视线角
% azi_sight_angle 方位视线角

yaw = deg2rad(yaw);
pitch = deg2rad(pitch);
roll = deg2rad(roll);

ele_point_angle = deg2rad(ele_point_angle);
azi_point_angle = deg2rad(azi_point_angle);

% 目标在天线西转为弹体系位置
M_ele = [cos(-ele_point_angle),sin(-ele_point_angle),0;-sin(-ele_point_angle),cos(-ele_point_angle),0;0,0,1];
L_azi = [cos(-azi_point_angle),0,-sin(-azi_point_angle);0,1,0;sin(-azi_point_angle),0,cos(-azi_point_angle)];
C_am = L_azi*M_ele;
tar_m = C_am*[utrm;0;0];

% 目标在弹体系位置转为发射系
K_roll = [1,0,0;0,cos(-roll),sin(-roll);0,-sin(-roll),cos(-roll)];
M_pitch = [cos(-pitch),sin(-pitch),0;-sin(-pitch),cos(-pitch),0;0,0,1];
L_yaw = [cos(-yaw),0,-sin(-yaw);0,1,0;sin(-yaw),0,cos(-yaw)];
C_mi = L_yaw*M_pitch*K_roll;
tar_m = C_mi*tar_m;

% 计算目标在体视线系下的视线角
ele_sight_angle = asin(tar_m(2)/utrm);
azi_sight_angle = -atan(tar_m(3)/tar_m(1));

ele_sight_angle = rad2deg(ele_sight_angle);
azi_sight_angle = rad2deg(azi_sight_angle);


end

