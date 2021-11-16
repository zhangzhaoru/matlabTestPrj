%  �޼�Kalman�˲���Ŀ������е�Ӧ��
function UKF_main1
clc;clear;
T=1; %�״�ɨ������
N=60/T; %�ܵĲ�������
X=zeros(4,N);%Ŀ����ʵλ�ã��ٶ�
X(:,1)=[-100,2,200,20]; %Ŀ���ʼλ�á��ٶ�
Z=zeros(1,N);  %��������λ�õĹ۲�
delta_w=1e-3; %����������������Ŀ����ʵ�켣��������
Q=delta_w*diag([0.5,1]) ;%����������ֵ
G=[T^2/2,0;T,0;0,T^2/2;0,T];%����������������
R=5;%�۲���������
F=[1,T,0,0;0,1,0,0;0,0,1,T;0,0,0,1];%״̬ת�ƾ���
x0=200; %�۲�վ��λ�ã�������Ϊ����ֵ
y0=300;
Xstation=[x0,y0]; %�״�վ��λ��

w=sqrtm(R)*randn(1,N);
for t=2:N
    X(:,t)=F*X(:,t-1)+G*sqrtm(Q)*randn(2,1);%Ŀ��۲�
end
%UKF�˲���UT�任
for t=1:N
    Z(t)=Dist(X(:,t),Xstation)+w(t);
end
L=4;
alpha=1;
kalpha=0;
belta=2;
ramda=3-L;
for j=1:2*L+1
    Wm(j)=1/(2*(L+ramda));
    Wc(j)=1/(2*(L+ramda));
end
Wm(1)=ramda/(L+ramda);
Wc(1)=ramda/(L+ramda)+1-alpha^2+belta;%Ȩֵ����

Xukf=zeros(4,N);
Xukf(:,1)=X(:,1);%�޼��������˲�״̬��ʼ��
P0=eye(4);%Э�������ʼ��
for t=2:N
    xestimate= Xukf(:,t-1);
    P=P0;
    %��һ�������һ��Sigma�㼯
    cho=(chol(P*(L+ramda)))';
    for k=1:L
        xgamaP1(:,k)=xestimate+cho(:,k);
        xgamaP2(:,k)=xestimate-cho(:,k);
    end
    Xsigma=[xestimate,xgamaP1,xgamaP2];
    %�ڶ�������Sigma�㼯����һ��Ԥ��
    Xsigmapre=F*Xsigma;
    %�����������õڶ����Ľ�������ֵ��Э����
    Xpred=zeros(4,1);%��ֵ
    for k=1:2*L+1
        Xpred=Xpred+Wm(k)*Xsigmapre(:,k);
    end
    Ppred=zeros(4,4);%Э������Ԥ��
    for k=1:2*L+1
        Ppred=Ppred+Wc(k)*(Xsigmapre(:,k)-Xpred)*(Xsigmapre(:,k)-Xpred)';
    end
    Ppred=Ppred+G*Q*G';
    %���Ĳ�������Ԥ��ֵ����һ��ʹ��UT�任���õ��µ�sigma�㼯
    chor=(chol((L+ramda)*Ppred))';
    for k=1:L
        XaugsigmaP1(:,k)=Xpred+chor(:,k);
        XaugsigmaP2(:,k)=Xpred-chor(:,k);
    end
    Xaugsigma=[Xpred XaugsigmaP1 XaugsigmaP2];
    %���岽���۲�Ԥ��
    for k=1:2*L+1%�۲�Ԥ��
        Zsigmapre(1,k)=hfun(Xaugsigma(:,k),Xstation);
    end
    %������������۲�Ԥ���ֵ��Э����
    Zpred=0;%�۲�Ԥ��ľ�ֵ
    for k=1:2*L+1
        Zpred=Zpred+Wm(k)*Zsigmapre(1,k);
    end
    Pzz=0;
    for k=1:2*L+1
        Pzz=Pzz+Wc(k)*(Zsigmapre(1,k)-Zpred)*(Zsigmapre(1,k)-Zpred)';
    end
    Pzz=Pzz+R;%�õ�Э����Pzz

    Pxz=zeros(4,1);
    for k=1:2*L+1
        Pxz=Pxz+Wc(k)*(Xaugsigma(:,k)-Xpred)*(Zsigmapre(1,k)-Zpred)';
    end
    %���߲������㿨��������
    K=Pxz*inv(Pzz);
    %�ڰ˲���״̬�ͷ������
    xestimate=Xpred+K*(Z(t)-Zpred);%״̬����
    P=Ppred-K*Pzz*K';%�������
    P0=P;
    Xukf(:,t)=xestimate;
end
%������
for i=1:N
    Err_KalmanFilter(i)=Dist(X(:,i),Xukf(:,i));%�˲�������
end
%��ͼ
figure
hold on;box on;
plot(X(1,:),X(3,:),'-k.');%��ʵ�켣
plot(Xukf(1,:),Xukf(3,:),'-r+');%�޼��������˲��켣
legend('��ʵ�켣','UKF�켣')
figure
hold on; box on;
plot(Err_KalmanFilter,'-ks','MarkerFace','r')

%�Ӻ������������ľ���
function d=Dist(X1,X2)
if length(X2)<=2
    d=sqrt( (X1(1)-X2(1))^2 + (X1(3)-X2(2))^2 );
else
    d=sqrt( (X1(1)-X2(1))^2 + (X1(3)-X2(3))^2 );
end
%�۲��Ӻ������۲����
function [y]=hfun(x,xx)
y=sqrt((x(1)-xx(1))^2+(x(3)-xx(2))^2);