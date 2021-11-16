%  Kalman�˲��ڴ���GPS������λϵͳ�е�Ӧ��
function LineKalmanFilterMain3
clc;clear;
T=1;%�״�ɨ������
N=80/T;%�ܵĲ�������
X=zeros(4,N);%Ŀ����ʵλ�á��ٶ�
X(:,1)=[-100,2,200,20];%Ŀ���ʼλ�á��ٶ�
Z=zeros(2,N);%��������λ�õĹ۲�
Z(:,1)=[X(1,1),X(3,1)];%�۲��ʼ��
delta_w=1e-2;%����������������Ŀ����ʵ�켣��������
Q=delta_w*diag([0.5,1,0.5,1]) ;%����������ֵ
R=100*eye(2);%�۲�������ֵ
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];%״̬ת�ƾ���
H=[1,0,0,0;0,0,1,0];%�۲����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=2:N
    X(:,t)=F*X(:,t-1)+sqrtm(Q)*randn(4,1);%Ŀ����ʵ�켣
    Z(:,t)=H*X(:,t)+sqrtm(R)*randn(2,1); %��Ŀ��۲�
end
%�������˲�
Xkf=zeros(4,N);
Xkf(:,1)=X(:,1);%�������˲�״̬��ʼ��
P0=eye(4);%Э�������ʼ��
for i=2:N
    Xn=F*Xkf(:,i-1);%Ԥ��
    P1=F*P0*F'+Q;%Ԥ�����Э����
    K=P1*H'*inv(H*P1*H'+R);%����
    Xkf(:,i)=Xn+K*(Z(:,i)-H*Xn);%״̬����
    P0=(eye(4)-K*H)*P1;%�˲����Э�������
end
%������
for i=1:N
    Err_Observation(i)=RMS(X(:,i),Z(:,i));%�˲�ǰ�����
    Err_KalmanFilter(i)=RMS(X(:,i),Xkf(:,i));%�˲�������
end
%��ͼ
figure
hold on;box on;
plot(X(1,:),X(3,:),'-k');%��ʵ�켣
plot(Z(1,:),Z(2,:),'-b.');%�۲�켣
plot(Xkf(1,:),Xkf(3,:),'-r+');%�������˲��켣
legend('��ʵ�켣','�۲�켣','�˲��켣')
figure
hold on; box on;
plot(Err_Observation,'-ko','MarkerFace','g')
plot(Err_KalmanFilter,'-ks','MarkerFace','r')
legend('�˲�ǰ���','�˲������')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����ŷʽ�����Ӻ���
function dist=RMS(X1,X2);
if length(X2)<=2
    dist=sqrt( (X1(1)-X2(1))^2 + (X1(3)-X2(2))^2 );
else
    dist=sqrt( (X1(1)-X2(1))^2 + (X1(3)-X2(3))^2 );
end
%%%%%%%%%%%%%%%%%%%%%%%%
????????????????
��Ȩ����������ΪCSDN������Joeyos����ԭ�����£���ѭCC 4.0 BY-SA��ȨЭ�飬ת���븽��ԭ�ĳ������Ӽ���������
ԭ�����ӣ�https://blog.csdn.net/zhangquan2015/article/details/79264540