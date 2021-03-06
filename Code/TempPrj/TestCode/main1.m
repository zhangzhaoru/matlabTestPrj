%% 无迹卡尔曼滤波器实现视线角解耦

clc
clear all
close all

% 参数设置
%% 参数设定
tEnd = 3.5;
dt = 0.01;
N_scan = tEnd/dt;
t = (0:N_scan-1)*dt;
% 弹体扰动频率
f_m = 1.5;
%% 弹体平飞速度
v_m = 340;
% 弹体高度
H = 2000;
% 飞行距离
Dis = 8000;
% 视线角初值
% 方位视线角初值
q_z0 = 0;
% 俯仰视线角初值
q_y0 = -atand(H/Dis);
% 初始弹目距离
R0 = sqrt(H^2+Dis^2);

% 弹体姿态角
Ele_m = zeros(1,N_scan);
Azi_m = zeros(1,N_scan);
Roll_m = zeros(1,N_scan);

Ele_m = sin(2*pi*f_m*t);
Azi_m = 1.5*sin(2*pi*f_m*t);
Roll_m = 2*sin(2*pi*f_m*t);



Dr = zeros(1,N_scan);

PointEle = zeros(1,N_scan);
PointAzi = zeros(1,N_scan);

% 视线角真值
% q_y = q_y0-10*sin(0.3*t);
% q_z = 10*sin(0.3*t);
% % 视线角速度真值
% Vqy = 3*cos(0.3*t);
% Vqz = 3*cos(0.3*t);

%% 计算波束指向角真值及失调角
epsilon_Ele = zeros(1,N_scan);
epsilon_Azi = zeros(1,N_scan);
PointEle = zeros(1,N_scan);
PointAzi = zeros(1,N_scan);
v_PointEle = zeros(1,N_scan);
v_PointAzi = zeros(1,N_scan);
Rmt = zeros(1,N_scan);
Rmt(1) = R0;
kk = zeros(N_scan);

% for i = 1:N_scan
%     [PointEle(i),PointAzi(i)]=fcn_sight_coor_2_antenna_coor(1.0,q_y(i),q_z(i),Roll_m(i),Ele_m(i),Azi_m(i));
%     %% 计算失调角测量值Azi
%     epsilon_Ele(i) = q_y(i)-PointEle(i);
%     epsilon_Azi(i) = q_z(i)-PointAzi(i);
%     % 计算各帧弹目距离真值
%     if i~=1
%         R(i) =  fcn_sight_coor_2_range(q_y(i-1),q_z(i-1),R(i-1),q_y(i),q_z(i));
%     end
%     % 计算导弹目标接近速度
%     kk(i) = -2*v_m/R(i);
% end



n=4;%状态维数
t=dt;%采用点数
Q=[0.04^2 0 0 0;
    0 0.04^2 0 0;
    0 0 0.04^2 0;
    0 0 0 0.04^2;];%过程噪声协方差阵
R = [0.02^2 0;
    0 0.02^2];%量测噪声协方差阵



s=[q_z0;3;q_y0;2;];
% 初值

P0 =[0.1 0 0 0;
    0 0.1 0 0;
    0 0 0.1 0;
    0 0 0 0.1;];%初始化协方差
N=N_scan;%总仿真时间步数，即总时间
Xukf = zeros(n,N);%UKF滤波状态初始化
X = zeros(n,N);%状态值（用于计算测量值）
Z = zeros(2,N);%测量值
X1 = zeros(n,N);
x0 = s+sqrtm(Q)*randn(n,1);%初始化状态
X(:,1) = x0;
X1(:,1) = s;
s1 = s;

for i=2:N_scan
    %      通过实现角计算弹目距离
    if i~=1
        % 更新视线角
        ele = X(3,i-1)+t*X(4,i-1);
        azi = X(1,i-1)+t*X(2,i-1);
        % 计算弹目距离
        Rmt(i) =  fcn_sight_coor_2_range(X(3,i-1),X(1,i-1),Rmt(i-1),ele,azi);
    end
    % 更新系数
    dR = Rmt(i) - Rmt(i-1);
    % 更新系数
    Vr = dR/dt;
    kk(i) = -2*Vr/Rmt(i);
    
    %状态方程
    f=@(x)[x(1)+x(2)*t;x(2)+t*(kk(i)*x(2)+2*x(2)*x(4)*tand(x(3)));...
        x(3)+t*x(4);x(4)+t*(-x(2)^2*sind(x(3))*cos(x(3))+kk(i)*x(4))];
    
    %x1为方位视线角，x2为方位视线角速度，x3为俯仰视线角、x4为俯仰视线角速度
    X(:,i) = f(s)+sqrtm(Q)*randn(4,1);%模拟，产生目标运动真实轨迹
    X1(:,i) = f(s1);                  %不添加噪声项迭代计算
    s = X(:,i);
    s1 = X1(:,i);
end

ux=x0;%ux为中间变量
RMS = zeros(1,N_scan);
for k=1:N_scan
    
    PlatEle = Ele_m(k);
    PlatAzi = Azi_m(k);
    PlatRoll = Roll_m(k);
    
    
    R11 = cosd(PlatEle)*cosd(PlatAzi);
    R12 = sind(PlatEle);
    R13 = -cosd(PlatEle)*sind(PlatAzi);
    R21 = -sind(PlatEle)*cosd(PlatAzi)*cosd(PlatRoll)+sind(PlatAzi)*sind(PlatRoll);
    R22 = cosd(PlatEle)*cosd(PlatRoll);
    R23 = sind(PlatEle)*sind(PlatAzi)*cosd(PlatRoll)+cosd(PlatAzi)*sind(PlatRoll);
    R31 = sind(PlatEle)*cosd(PlatAzi)*sind(PlatRoll)+sind(PlatAzi)*cosd(PlatRoll);
    R32 = -cosd(PlatEle)*sind(PlatRoll);
    R33 = -sind(PlatEle)*sind(PlatAzi)*sind(PlatRoll)+cosd(PlatAzi)*cosd(PlatRoll);
    
    %观测方程
    h=@(x)[atand((R33*sind(x(1))-R21*cosd(x(3))-R32*tand(x(3)))/(R11*cosd(x(1))+R12*tand(x(3))-R13*sind(x(1))));...
        asind(R21*cosd(x(3))*cosd(x(1))+R22*sind(x(3))-R23*sind(x(1))*cosd(x(3)));];
    
    Z(:,k)= h(X(:,k)) + sqrtm(R)*randn(2,1);%测量值，保存观测
    [Xukf(:,k), P0] = ukf(f,ux,P0,h,Z(:,k),Q,R);%调用ukf滤波算法
    ux=Xukf(:,k);
    RMS(k)=CalNorm2(X(:,k),Xukf(:,k));
    
end


figure('name','无迹卡尔曼滤波器估计视线角速度')
plot(1:N_scan,Xukf)

hold on
plot(1:N,X1(1,:),'g--','LineWidth',2)
hold on
plot(1:N,X1(3,:),'r--','LineWidth',2)
hold on
plot(1:N,X1(2,:),'b--','LineWidth',2)
hold on
plot(1:N,X1(4,:),'y--','LineWidth',2)
legend({'方位视线角','方位视线角速度','俯仰视线角','视线角速度','方位视线角真值','俯仰视线角真值','方位视线角速度真值','俯仰视线角速度真值'},'Location','southwest')





% figure('name','均方误差')
% plot(1:N,RMS)


%% 计算向量二范数
function res = CalNorm2(X1,X2)

[m,n] = size(X1);
% 若传入向量为列向量，将其转换为行向量
if m~=1&&n==1
X1 = X1';
X2 = X2';    
end

sum = 0;
for i = 1:m*n
    sum = sum + (X1(i)-X2(i))^2;
end
res = sqrt(sum)/(m*n);
end





