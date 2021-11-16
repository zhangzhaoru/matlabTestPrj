% 基于俯仰、方向视线角解算目标在发射系下的位置
function [outputArg1,outputArg2] = fcn_sight_coor_2_launch_coor2(inputArg1,inputArg2)
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
azi_sight_angle = deg2rad(ai_sight_angle);



end