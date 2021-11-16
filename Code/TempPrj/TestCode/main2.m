% �������ͷ���߽�������ȡ
clc
clear all
close all

%% �����趨
tEnd = 10;
dt = 0.1;
N_scan = tEnd/dt;
t = (0:dt:N_scan)*dt;
% �����Ŷ�Ƶ��
f_m = 1.5;
% ������̬��
yaw = sin(2*pi*f_m*t);
pitch = 1.5*sin(2*pi*f_m*t);
roll = 2*sin(2*pi*f_m*t);

v_pitch = 1.5 * 2*pi*f_m * cos(2*pi*f_m*t);
% plot(t,yaw)
subChoice = 2;

% ���߽�Ϊ��ֵ
if subChoice == 1
    q_y = 10*ones(1,size(yaw,2));
    q_z = 10*ones(1,size(yaw,2));
elseif subChoice == 2
    q_y = 10*sin(0.3*t);
    q_z = 10*sin(0.3*t);
end



%% �������۲���ָ���
epsilon_Ele = zeros(1,size(yaw,2));
epsilon_Azi = zeros(1,size(yaw,2));
PointEle = zeros(1,size(yaw,2));
PointAzi = zeros(1,size(yaw,2));
v_PointEle = zeros(1,size(yaw,2));
v_PointAzi = zeros(1,size(yaw,2));

for i = 1:size(yaw,2)
    [PointEle(i),PointAzi(i)]=fcn_sight_coor_2_antenna_coor(1.0,q_y(i),q_z(i),roll(i),pitch(i),yaw(i));
    %% ����ʧ���ǲ���ֵAzi
    epsilon_Ele(i) = q_y(i)-PointEle(i);
    epsilon_Azi(i) = q_z(i)-PointAzi(i);
end



% ���߽��ٶȹ���ֵ
k = 0.1;
Vqy = k*epsilon_Ele;
Vqz = k*epsilon_Azi;


%% ʧ���������ʱ��仯����
% plot(t,epsilon_Azi);

K = 10;
K_B = 10;
% ����㷨���㵯����̬���ٶ�
% ���쵯����Ŷ������߽����ʵĴ��ݺ���
G1 = tf([-1.0/K_B],[1.0/(K_B*K),1]);
% �����������������������߽����ʵĴ��ݺ���
G2 = tf([1.0],[1.0/(K_B*K),1]);
% ���뵯�������������������ͬʱ���ڶ������߽�����Ӱ��Ĵ��ݺ���
G3 = tf([1.0-1.0/K_B],[1.0/(K_B*K),1]);
% �����߽ǲ���ֵ�������ֵ�Ĵ��ݺ���
G4 = tf([1],[1.0/(K),1]);


% �ɵ�������������߽��ٶ�
v_m = lsim(G1,v_pitch,t);
% ��������������ʵ�ֽ��ٶ�
v_top = lsim(G2,v_pitch,t);
% ��������ͬʱ����
v_mid = lsim(G3,v_pitch,t);
% �����߽���ֵ�������߽ǹ���ֵ
v_est = lsim(G3,Vqy,t);
v_err = v_est-Vqy';

figure('name','����ֵ���')
plot(t,v_err)





