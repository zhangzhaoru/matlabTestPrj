% 由两两目标间的视线角解算弹目距离，设定参考目标A的方位视线角为0，位于弹体坐标系的X在轴
function [range_b] = fcn_sight_coor_2_range(ele_a,azi_a,range_a,ele_b,azi_b)
% ele_a ： 目标A在视线系下的俯仰视线角
% azi_a :  目标A在视线系下的方位视线角
% range_a: 目标A在视线系下的距离
% ele_b  : 目标B在视线系下的俯仰视线角
% azi_b  : 目标B在视线系下的方位视线角

%输出：
% range_b 目标在实现系下X向的位置

h = abs(range_a*sind(ele_a));
x_b = abs(h/tand(ele_b));
xz_b=  abs(x_b/cosd(azi_b));
range_b = sqrt(xz_b^2+h^2);
end
