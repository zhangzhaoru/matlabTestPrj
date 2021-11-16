%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% created by: Donglin Zhang
% date: 2020/4
% 无迹卡尔曼滤波，目标跟踪  
% 三维目标跟踪问题
% 球坐标两侧
% 线性CV目标模型
% 单雷达
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;
%% initial parameter
n=6; %状态维数 ;
T=1; %采样时间
M=1; %雷达数目
N=200; %运行总时刻
MC=100; %蒙特卡洛次数
chan=1; %滤波器通道，这里只有一个滤波器
w_mu=[0,0,0]';% mean of process noise 
v_mu=[0,0,0]';% mean of measurement noise
%% target model
%covariance of process noise
q=0.01; %m/s^2
Qk=q^2*eye(3); 
% state matrix
% 状态转移矩阵
Fk=[1,T,0,0,0,0;
      0,1,0,0,0,0;
      0,0,1,T,0,0;
      0,0,0,1,0,0;
      0,0,0,0,1,T;
      0,0,0,0,0,1 ];
  % 过程噪声驱动矩阵
Gk=[  T^2/2,    0,    0;
          T,    0,    0;
          0,T^2/2,    0;
          0,    T,    0;
          0,    0,T^2/2;
          0,    0,    T ];
%量测模型
sigma_r(1)=130;  sigma_b(1)=90e-3; sigma_e(1)=70e-3; % covariance of measurement noise (radar)
Rk=diag([sigma_r(1)^2, sigma_b(1)^2,sigma_e(1)^2]);
xp=[0,0,0,0,0,0];%雷达位置
%% 定义存储空间
sV=zeros(n,N,MC); % 状态
eV=zeros(n,N,MC,chan); %估计
PV=zeros(n,n,N,MC,chan);%协方差
rV=zeros(3,N,MC,M); % %量测
for i=1:MC
    sprintf('rate of process:%3.1f%%',(2*i)/(4*MC)*100)
    % 初始状态的均值和方差
    x=[1200,31,1300,20,1100,21]';
    P_0=diag([1e5,10^2,1e5,10^2, 1e5,10^2]); 
    xk_ukf=x;    Pk_ukf=P_0;   % P0|0 x0|0 
    x0=mvnrnd(x,P_0); % 初始状态
    % 生成n维正态分布向量
    %x0=(x+normrnd(0,0.001)')';
    x=x0';
    for k=1:N
       %% %%%%%%% 目标模型和雷达量测模型%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 目标模型CV 
        w=mvnrnd(w_mu',Qk)';
        % 过程噪声向量
        x=Fk*x+Gk*w;
        sV(:,k,i)=x;
        
        % 雷达量测模型，M=1，表示一个雷达
        for m=1:M
            v=normrnd(v_mu,[sigma_r(m); sigma_b(m);sigma_e(m)]);
            [r,b,e] = measurements(x,xp);%r=距离，b=角度
            rm=r+v(1);
            bm=b+v(2);
            em=e+v(3);
            rV(:,k,i,m)=[rm,bm,em]';   
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
       %% %%%%%%%%% EKF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [xk_ukf,Pk_ukf] = fun_3UKF(xk_ukf,Pk_ukf,Fk,Gk,rV(:,k,i,1),Qk,Rk, xp); 
        PV(:,:,k,i,1)=Pk_ukf;
        eV(:,k,i,1)=xk_ukf;
        %%%%%%%%%%%%%% end filte %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end    
    
end
    
figure
plot3(sV(1,:,1),sV(3,:,1),sV(5,:,1),'--k',eV(1,:,1,1),eV(3,:,1,1),eV(5,:,1,1),'.-r')
xlabel('m');ylabel('m');
legend('State','UKF')
title('跟踪轨迹')
figure;
ii=1:N;
plot(ii,sV(1,:,1),'--k',ii,eV(1,:,1,1),'.-r');
xlabel('t/s');ylabel('m');%X轴的跟踪轨迹
legend('X-轴','UKF')
title('X轴的跟踪轨迹')

%P_real=cell(MC,chan);
P_r=0;
for i=1:MC
    sprintf('rate of process:%3.1f%%',(3*MC+i)/(4*MC)*100)
    for k=1:N
        for c=1:chan
            error(:,c)=sV(:,k,i,1)-eV(:,k,i,c); 
            % RMSE
            error2(:,c)=error(:,c).^2;               
            error2_dis(c)=error2(1,c)+error2(3,c);
            error2_vel(c)=error2(2,c)+error2(4,c);
            position(k,i,c)=error2_dis(c);     
            velocity(k,i,c)=error2_vel(c); 
            
        end
    end
end
%% RMSE
for c=1:chan
    rms_position(:,c)=sqrt(sum(position(:,:,c),2)./MC);  
    rms_velocity(:,c)=sqrt(sum(velocity(:,:,c),2)./MC);  
end
figure;%position
plot(ii,rms_position(ii,1),'.-r','LineWidth',0.7);
legend('UKF')
xlabel('t/s');ylabel('RMSE');
title('position-RMS analyze')
figure;%position
plot(ii,rms_velocity(ii,1),'.-r','LineWidth',0.7);
legend('UKF')
xlabel('t/s');ylabel('RMSE');
title('velocity-RMS analyze')    
