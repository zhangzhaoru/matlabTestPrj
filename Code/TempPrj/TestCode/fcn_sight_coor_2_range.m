% ������Ŀ�������߽ǽ��㵯Ŀ���룬�趨�ο�Ŀ��A�ķ�λ���߽�Ϊ0��λ�ڵ�������ϵ��X����
function [range_b] = fcn_sight_coor_2_range(ele_a,azi_a,range_a,ele_b,azi_b)
% ele_a �� Ŀ��A������ϵ�µĸ������߽�
% azi_a :  Ŀ��A������ϵ�µķ�λ���߽�
% range_a: Ŀ��A������ϵ�µľ���
% ele_b  : Ŀ��B������ϵ�µĸ������߽�
% azi_b  : Ŀ��B������ϵ�µķ�λ���߽�

%�����
% range_b Ŀ����ʵ��ϵ��X���λ��

h = abs(range_a*sind(ele_a));
x_b = abs(h/tand(ele_b));
xz_b=  abs(x_b/cosd(azi_b));
range_b = sqrt(xz_b^2+h^2);
end
