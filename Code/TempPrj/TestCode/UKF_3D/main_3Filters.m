%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% created by: Donglin Zhang
% date: 2020/4
% �޼��������˲���Ŀ�����  
% ��άĿ���������
% ����������
% ����CVĿ��ģ��
% ���״�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;
%% initial parameter
n=6; %״̬ά�� ;
T=1; %����ʱ��
M=1; %�״���Ŀ
N=200; %������ʱ��
MC=100; %���ؿ������
chan=1; %�˲���ͨ��������ֻ��һ���˲���
w_mu=[0,0,0]';% mean of process noise 
v_mu=[0,0,0]';% mean of measurement noise
%% target model
%covariance of process noise
q=0.01; %m/s^2
Qk=q^2*eye(3); 
% state matrix
% ״̬ת�ƾ���
Fk=[1,T,0,0,0,0;
      0,1,0,0,0,0;
      0,0,1,T,0,0;
      0,0,0,1,0,0;
      0,0,0,0,1,T;
      0,0,0,0,0,1 ];
  % ����������������
Gk=[  T^2/2,    0,    0;
          T,    0,    0;
          0,T^2/2,    0;
          0,    T,    0;
          0,    0,T^2/2;
          0,    0,    T ];
%����ģ��
sigma_r(1)=130;  sigma_b(1)=90e-3; sigma_e(1)=70e-3; % covariance of measurement noise (radar)
Rk=diag([sigma_r(1)^2, sigma_b(1)^2,sigma_e(1)^2]);
xp=[0,0,0,0,0,0];%�״�λ��
%% ����洢�ռ�
sV=zeros(n,N,MC); % ״̬
eV=zeros(n,N,MC,chan); %����
PV=zeros(n,n,N,MC,chan);%Э����
rV=zeros(3,N,MC,M); % %����
for i=1:MC
    sprintf('rate of process:%3.1f%%',(2*i)/(4*MC)*100)
    % ��ʼ״̬�ľ�ֵ�ͷ���
    x=[1200,31,1300,20,1100,21]';
    P_0=diag([1e5,10^2,1e5,10^2, 1e5,10^2]); 
    xk_ukf=x;    Pk_ukf=P_0;   % P0|0 x0|0 
    x0=mvnrnd(x,P_0); % ��ʼ״̬
    % ����nά��̬�ֲ�����
    %x0=(x+normrnd(0,0.001)')';
    x=x0';
    for k=1:N
       %% %%%%%%% Ŀ��ģ�ͺ��״�����ģ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Ŀ��ģ��CV 
        w=mvnrnd(w_mu',Qk)';
        % ������������
        x=Fk*x+Gk*w;
        sV(:,k,i)=x;
        
        % �״�����ģ�ͣ�M=1����ʾһ���״�
        for m=1:M
            v=normrnd(v_mu,[sigma_r(m); sigma_b(m);sigma_e(m)]);
            [r,b,e] = measurements(x,xp);%r=���룬b=�Ƕ�
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
title('���ٹ켣')
figure;
ii=1:N;
plot(ii,sV(1,:,1),'--k',ii,eV(1,:,1,1),'.-r');
xlabel('t/s');ylabel('m');%X��ĸ��ٹ켣
legend('X-��','UKF')
title('X��ĸ��ٹ켣')

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
