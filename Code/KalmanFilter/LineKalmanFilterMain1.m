% ����˵��������-�¶Ȳ���

% X(k)=AX(k-1)+TW(k-1)
% Z(k)=H*X(k)+V(k)
% 
% �����¶���25���϶����ң��������Ϊ����0.5���϶ȣ�����0.25��R=0.25��Q=0.01,A=1,T=1,H=1��
% 
% �ٶ���ʱ�̵��¶�ֵ������ֵΪ23.9���϶ȣ�������ʵ�¶�Ϊ24���϶ȣ��¶ȼ��ڸ�ʱ�̲���ֵ
% Ϊ24.5���϶ȣ�ƫ��Ϊ0.4���϶ȡ�����k-1ʱ���¶�ֵ������kʱ�̵��¶ȣ���Ԥ��ƫ��Ϊ:
% P(k|k-1)=P(k-1)+Q=0.02
% ����������k=P(k|k-1) / (P(k|k-1) + R)=0.0741
% 
% X(k)=23.9+0.0741*(24.1-23.9)=23.915���϶ȡ�
% 
% kʱ�̵�ƫ��ΪP(k)=(1-K*H)P(k|k-1)=0.0186��
% �����X(k)��P(k)�ó�Z(k+1)��


function LineKalmanFilterMain1
N=120;
CON=25;%�����¶���25���϶�����
Xexpect=CON*ones(1,N);
X=zeros(1,N);  
Xkf=zeros(1,N);
Z=zeros(1,N);
P=zeros(1,N); 
X(1)=25.1;
P(1)=0.01;
Z(1)=24.9;
Xkf(1)=Z(1);
Q=0.01;%W(k)�ķ���
R=0.25;%V(k)�ķ���
W=sqrt(Q)*randn(1,N);
V=sqrt(R)*randn(1,N);
F=1;
G=1;
H=1;
I=eye(1); 
%%%%%%%%%%%%%%%%%%%%%%%
for k=2:N
    X(k)=F*X(k-1)+G*W(k-1);  
    Z(k)=H*X(k)+V(k);
    X_pre=F*Xkf(k-1);           
    P_pre=F*P(k-1)*F'+Q;        
    Kg=P_pre*inv(H*P_pre*H'+R); 
    e=Z(k)-H*X_pre;            
    Xkf(k)=X_pre+Kg*e;         
    P(k)=(I-Kg*H)*P_pre;
end
%%%%%%%%%%%%%%%%
Err_Messure=zeros(1,N);
Err_Kalman=zeros(1,N);
for k=1:N
    Err_Messure(k)=abs(Z(k)-X(k));
    Err_Kalman(k)=abs(Xkf(k)-X(k));
end
t=1:N;
figure('Name','Kalman Filter Simulation','NumberTitle','off');
plot(t,Xexpect,'-b',t,X,'-r',t,Z,'-k',t,Xkf,'-g');
legend('expected','real','measure','kalman extimate');         
xlabel('sample time');
ylabel('temperature');
title('Kalman Filter Simulation');
figure('Name','Error Analysis','NumberTitle','off');
plot(t,Err_Messure,'-b',t,Err_Kalman,'-k');
legend('messure error','kalman error');         
xlabel('sample time');
%%%%%%%%%%%%%%%%%%%%%%%%%
