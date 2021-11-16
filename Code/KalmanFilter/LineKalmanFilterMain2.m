
%%%%%%%%%%%%%
% �������˲��������������˶�Ŀ���������
%%%%%%%%%%%%%%
function LineKalmanFilterMain2
N=1000; %����ʱ�䣬ʱ����������
%����
Q=[0,0;0,0];%������������Ϊ0����������̺��Կ�������
R=1; %�۲���������
W=sqrt(Q)*randn(2,N);%��ȻQΪ0����W=0
V=sqrt(R)*randn(1,N);%��������V(k)
%ϵ������
A=[1,1;0,1];%״̬ת�ƾ���
B=[0.5;1];%������
U=-1;
H=[1,0];%�۲����
%��ʼ��
X=zeros(2,N);%������ʵ״̬
X(:,1)=[95;1];%��ʼλ�ƺ��ٶ�
P0=[10,0;0,1];%��ʼ���
Z=zeros(1,N);
Z(1)=H*X(:,1);%��ʼ�۲�ֵ
Xkf=zeros(2,N);%����������״̬��ʼ��
Xkf(:,1)=X(:,1);
err_P=zeros(N,2);
err_P(1,1)=P0(1,1);
err_P(1,2)=P0(2,2);
I=eye(2); %��άϵͳ
%%%%%%%%%%%%%
for k=2:N
    %�������䣬��״̬���̵�����
    X(:,k)=A*X(:,k-1)+B*U+W(k);
    %λ�ƴ�������Ŀ����й۲�
    Z(k)=H*X(:,k)+V(k);
    %�������˲�
    X_pre=A*Xkf(:,k-1)+B*U;%״̬Ԥ�� 
    P_pre=A*P0*A'+Q;%Э����Ԥ��
    Kg=P_pre*H'*inv(H*P_pre*H'+R);%���㿨��������
    Xkf(:,k)=X_pre+Kg*(Z(k)-H*X_pre);%״̬����
    P0=(I-Kg*H)*P_pre;%�������
    %������ֵ
    err_P(k,1)=P0(1,1);
    err_P(k,2)=P0(2,2);
end
%������
messure_err_x=zeros(1,N);%λ�ƵĲ������
kalman_err_x=zeros(1,N);%���������Ƶ�λ������ʵλ��֮���ƫ��
kalman_err_v=zeros(1,N);%���������Ƶ��ٶ�����ʵ�ٶ�֮���ƫ��
for k=1:N
    messure_err_x(k)=Z(k)-X(1,k);
    kalman_err_x(k)=Xkf(1,k)-X(1,k);
    kalman_err_v(k)=Xkf(2,k)-X(2,k);
end
%%%%%%%%%%%%%%%
%��ͼ���
%����ͼ
figure
plot(V);
title('messure noise')
%λ��ƫ��
figure
hold on,box on;
plot(messure_err_x,'-r.');%������λ�����
plot(kalman_err_x,'-g.');%����������λ�����
legend('�������','kalman�������')
figureplot(kalman_err_v);
title('�ٶ����')
figure
plot(err_P(:,1));
title('λ��������ֵ')
figure
plot(err_P(:,1));
title('�ٶ�������ֵ')
%%%%%%%%%%%%%%%%%%%%%%%
