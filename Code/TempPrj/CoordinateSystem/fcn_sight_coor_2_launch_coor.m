% 基于俯仰、方向视线角解算目标在发射系下的位置
function [tar_x,tar_y,tar_z] = fcn_sight_coor_2_launch_coor(mis_x,mis_y,mis_z,ele_sight_angle,azi_sight_angle,utrm)
% 输入:
% mis_x: 弹体在发射系下X向位置
% mis_y: 弹体在发射系下Y向位置
% mis_z：弹体在发射系下Z向位置
% ele_sight_angle 俯仰视线角
% azi_sight_angle: 方位视线角
% tar_y  弹目距离

% 输出
% tar_x 目标在发射系下x向位置
% tar_y 目标在发射系下Y向位置
% tar_z 目标在发射系下Z向位置

ele_sight_angle = deg2rad(ele_sight_angle);
azi_sight_angle = deg2rad(azi_sight_angle);

x = sqrt(utrm^2*cos(ele_sight_angle)^2*cos(azi_sight_angle)^2);
y = utrm*sin(ele_sight_angle);
z = -x*tan(azi_sight_angle);


tar_x = x + mis_x;
tar_y = y + mis_y;
tar_z = z + mis_z;


end