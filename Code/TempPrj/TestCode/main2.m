% 相控阵导引头视线角速率提取
clc
clear all
close all

%% 参数设定
tEnd = 10;
dt = 0.1;
N_scan = tEnd/dt;
t = (0:dt:N_scan)*dt;
% 弹体扰动频率
f_m = 1.5;
% 弹体姿态角
yaw = sin(2*pi*f_m*t);
pitch = 1.5*sin(2*pi*f_m*t);
roll = 2*sin(2*pi*f_m*t);

v_pitch = 1.5 * 2*pi*f_m * cos(2*pi*f_m*t);
% plot(t,yaw)
subChoice = 2;

% 视线角为常值
if subChoice == 1
    q_y = 10*ones(1,size(yaw,2));
    q_z = 10*ones(1,size(yaw,2));
elseif subChoice == 2
    q_y = 10*sin(0.3*t);
    q_z = 10*sin(0.3*t);
end



%% 计算理论波束指向角
epsilon_Ele = zeros(1,size(yaw,2));
epsilon_Azi = zeros(1,size(yaw,2));
PointEle = zeros(1,size(yaw,2));
PointAzi = zeros(1,size(yaw,2));
v_PointEle = zeros(1,size(yaw,2));
v_PointAzi = zeros(1,size(yaw,2));

for i = 1:size(yaw,2)
    [PointEle(i),PointAzi(i)]=fcn_sight_coor_2_antenna_coor(1.0,q_y(i),q_z(i),roll(i),pitch(i),yaw(i));
    %% 计算失调角测量值Azi
    epsilon_Ele(i) = q_y(i)-PointEle(i);
    epsilon_Azi(i) = q_z(i)-PointAzi(i);
end



% 视线角速度估计值
k = 0.1;
Vqy = k*epsilon_Ele;
Vqz = k*epsilon_Azi;


%% 失调角误差随时间变化趋势
% plot(t,epsilon_Azi);

K = 10;
K_B = 10;
% 差分算法计算弹体姿态角速度
% 构造弹体干扰对于视线角速率的传递函数
G1 = tf([-1.0/K_B],[1.0/(K_B*K),1]);
% 构造角速率陀螺输出对于视线角速率的传递函数
G2 = tf([1.0],[1.0/(K_B*K),1]);
% 引入弹体干扰与角速率陀螺输出同时存在对于视线角速率影响的传递函数
G3 = tf([1.0-1.0/K_B],[1.0/(K_B*K),1]);
% 由视线角测量值计算估计值的传递函数
G4 = tf([1],[1.0/(K),1]);


% 由弹体干扰引起视线角速度
v_m = lsim(G1,v_pitch,t);
% 由速率陀螺引起实现角速度
v_top = lsim(G2,v_pitch,t);
% 两种因素同时存在
v_mid = lsim(G3,v_pitch,t);
% 由视线角真值计算视线角估计值
v_est = lsim(G3,Vqy,t);
v_err = v_est-Vqy';

figure('name','估计值误差')
plot(t,v_err)





