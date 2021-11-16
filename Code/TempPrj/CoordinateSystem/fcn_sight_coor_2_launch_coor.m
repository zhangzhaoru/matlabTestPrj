% ���ڸ������������߽ǽ���Ŀ���ڷ���ϵ�µ�λ��
function [tar_x,tar_y,tar_z] = fcn_sight_coor_2_launch_coor(mis_x,mis_y,mis_z,ele_sight_angle,azi_sight_angle,utrm)
% ����:
% mis_x: �����ڷ���ϵ��X��λ��
% mis_y: �����ڷ���ϵ��Y��λ��
% mis_z�������ڷ���ϵ��Z��λ��
% ele_sight_angle �������߽�
% azi_sight_angle: ��λ���߽�
% tar_y  ��Ŀ����

% ���
% tar_x Ŀ���ڷ���ϵ��x��λ��
% tar_y Ŀ���ڷ���ϵ��Y��λ��
% tar_z Ŀ���ڷ���ϵ��Z��λ��

ele_sight_angle = deg2rad(ele_sight_angle);
azi_sight_angle = deg2rad(azi_sight_angle);

x = sqrt(utrm^2*cos(ele_sight_angle)^2*cos(azi_sight_angle)^2);
y = utrm*sin(ele_sight_angle);
z = -x*tan(azi_sight_angle);


tar_x = x + mis_x;
tar_y = y + mis_y;
tar_z = z + mis_z;


end