%  ��չKalman�˲��ڴ���λĿ������е�Ӧ��ʵ��
function EKF_angle
clc;clear;
T=1;%�״�ɨ������
N=40/T;%�ܵĲ�������
X=zeros(4,N);%Ŀ����ʵλ�á��ٶ�
X(:,1)=[0,2,1400,-10];%Ŀ���ʼλ�á��ٶ�
Z=zeros(1,N); %��������λ�õĹ۲�
delta_w=1e-4;%����������������Ŀ����ʵ�켣����������
Q=delta_w*diag([1,1]) ;%����������ֵ
G=[T^2/2,0;T,0;0,T^2/2;0,T];%����������������
R=0.1*pi/180;%�۲���������
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];%״̬ת�ƾ���
x0=0;%�۲�վ��λ�ã�������Ϊ����ֵ
y0=1000; 
Xstation=[x0;y0];

w=sqrtm(R)*randn(1,N);%��ֵΪ0������Ϊ1�ĸ�˹����
for t=2:N
    X(:,t)=F*X(:,t-1)+G*sqrtm(Q)*randn(2,1);%Ŀ����ʵ�켣
end
for t=1:N
    Z(t)=hfun(X(:,t),Xstation)+w(t);%Ŀ��۲�
    %��sqrtm(R)*w(t)ת��Ϊ�Ƕ�sqrtm(R)*w(t)/pi*180���Կ��������Ĵ�С
end
%EKF�˲�
Xekf=zeros(4,N);
Xekf(:,1)=X(:,1);%�������˲�״̬��ʼ��
P0=eye(4);%Э�������ʼ��
for i=2:N
    Xn=F*Xekf(:,i-1);%Ԥ��
    P1=F*P0*F'+G*Q*G';%Ԥ�����Э����
    dd=hfun(Xn,Xstation);%�۲�Ԥ��
    %���ſ˱Ⱦ���H
    D=Dist(Xn,Xstation);
    H=[-(Xn(3,1)-y0)/D,0,(Xn(1,1)-x0)/D,0];%��Ϊ����һ�׽���
    K=P1*H'*inv(H*P1*H'+R);%����
    Xekf(:,i)=Xn+K*(Z(:,i)-dd);%״̬����
    P0=(eye(4)-K*H)*P1;%�˲����Э�������
end
%������
for i=1:N
  Err_KalmanFilter(i)=sqrt(Dist(X(:,i),Xekf(:,i)));
end
%��ͼ
figure
hold on;box on;
plot(X(1,:),X(3,:),'-k.');%��ʵ�켣
plot(Xekf(1,:),Xekf(3,:),'-r+');%��չ�������˲��켣
legend('��ʵ�켣','EKF�켣')
figure
hold on; box on;
plot(Err_KalmanFilter,'-ks','MarkerFace','r')
figure 
hold on;box on;
plot(Z/pi*180,'-r.','MarkerFace','r');%��ʵ�Ƕ�ֵ
plot(Z/pi*180+w/pi*180,'-ko','MarkerFace','g');%��������Ⱦ�Ĺ۲�ֵ
legend('��ʵ�Ƕ�','�۲�Ƕ�');
function cita=hfun(X1,X0) %��Ҫע��������޽Ƕȵı仯
if X1(3,1)-X0(2,1)>=0
    if X1(1,1)-X0(1,1)>0
        cita=atan(abs( (X1(3,1)-X0(2,1))/(X1(1,1)-X0(1,1)) ));
    elseif X1(1,1)-X0(1,1)==0
        cita=pi/2;
    else
        cita=pi/2+atan(abs( (X1(3,1)-X0(2,1))/(X1(1,1)-X0(1,1)) ));
    end
else
    if X1(1,1)-X0(1,1)>0
        cita=3*pi/2+atan(abs( (X1(3,1)-X0(2,1))/(X1(1,1)-X0(1,1)) ));
    elseif X1(1,1)-X0(1,1)==0
        cita=3*pi/2;
    else
        cita=pi+atan(abs( (X1(3,1)-X0(2,1))/(X1(1,1)-X0(1,1)) ));
    end
end
function d=Dist(X1,X2);
if length(X2)<=2
    d=( (X1(1)-X2(1))^2 + (X1(3)-X2(2))^2 );
else
    d=( (X1(1)-X2(1))^2 + (X1(3)-X2(3))^2 );
end
