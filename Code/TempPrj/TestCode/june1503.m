%******************本程序用来测试EKF的正确性*******************************
clc;
clear;
close all
T=1;%采样间隔
simtime=1000 %仿真步数
A=[1 T 0 0;0 1 0 0;0 0 1 T;0 0 0 1];;%实际模型CV 
r0=0;
Q=[r0 0 0 0;0 r0 0 0; 0 0 r0 0; 0 0 0 r0];%运动过程噪声协方差
wk=[sqrt(r0)*randn;sqrt(r0)*randn;sqrt(r0)*randn;sqrt(r0)*randn];%运动过程噪声
r1=40;
r2=0.001*pi/180;
R=[r1 0;0 r2];%雷达量测噪声协方差
vk(:,1)=[sqrt(r1)*randn;sqrt(r2)*randn];%雷达量测噪声
X0=[200;1;10000;-1];%初始状态
X(:,1)=X0;
Zk(:,1)=[sqrt(X(1,1)^2+X(3,1)^2); atan(X(3,1)/X(1,1))]+vk(:,1);
X0=[210;3;10100;-15];%初始估计状态
Pk=[400 0 0 0; 0 400 0 0; 0 0 400 0;0 0 0 400];%初始协方差
X_pre(:,1)=A*X0;
P_pre(:,:,1)=A*Pk*A'+Q;
rr=X_pre(1,1)^2+X_pre(3,1)^2;
H(:,:,1)=[X_pre(1,1)/sqrt(rr) 0 X_pre(3,1)/sqrt(rr) 0; -1.*X_pre(3,1)/rr 0 X_pre(1,1)/rr 0];
for i=2:simtime
    wk(:,i)=[sqrt(r0)*randn;sqrt(r0)*randn;sqrt(r0)*randn;sqrt(r0)*randn];%运动过程噪声
    X(:,i)=A*X(:,i-1)+wk(:,i);%真实状态
    vk(:,i)=[sqrt(r1)*randn;sqrt(r2)*randn];
   Zk(:,i)=[sqrt(X(1,i)^2+X(3,i)^2); atan(X(3,i)/X(1,i))]+vk(:,i);
   K(:,:,i)=P_pre(:,:,i-1)*H(:,:,i-1)'*inv(H(:,:,i-1)*P_pre(:,:,i-1)*H(:,:,i-1)'+R);
    re(:,i)=Zk(:,i)-[sqrt(X_pre(1,i-1)^2+X_pre(3,i-1)^2); atan(X_pre(3,i-1)/X_pre(1,i-1))];
    X_f(:,i)=X_pre(:,i-1)+K(:,:,i)*re(:,i);
   P_f(:,:,i)=P_pre(:,:,i-1)-K(:,:,i)*H(:,:,i-1)*P_pre(:,:,i-1);
   X_pre(:,i)=A*X_f(:,i);
   P_pre(:,:,i)=A*P_f(:,:,i)*A'+Q;
   rr=X_pre(1,i)^2+X_pre(3,i)^2;
  H(:,:,i)=[X_pre(1,i)/sqrt(rr) 0 X_pre(3,i)/sqrt(rr) 0;-1.*X_pre(3,i)/rr 0 X_pre(1,i)/rr 0];
end
%*******
%**************与真实位置的比较*******************************************
figure
plot(X(1,:),X(3,:))
hold on
plot(X_f(1,:),X(3,:),'r')
   for i=1:simtime
rmsep1(i)=sqrt((X(1,i)-X_f(1,i))^2+(X(3,i)-X_f(3,i))^2);

end
figure
t=50:100;
plot(t,rmsep1(50:100));

   
   
   