%% �޼��������˲���ʵ�����߽ǽ���

clc
clear all
close all

% ��������
%% �����趨
tEnd = 3.5;
dt = 0.01;
N_scan = tEnd/dt;
t = (0:N_scan-1)*dt;
% �����Ŷ�Ƶ��
f_m = 1.5;
%% ����ƽ���ٶ�
v_m = 340;
% ����߶�
H = 2000;
% ���о���
Dis = 8000;
% ���߽ǳ�ֵ
% ��λ���߽ǳ�ֵ
q_z0 = 0;
% �������߽ǳ�ֵ
q_y0 = -atand(H/Dis);
% ��ʼ��Ŀ����
R0 = sqrt(H^2+Dis^2);

% ������̬��
Ele_m = zeros(1,N_scan);
Azi_m = zeros(1,N_scan);
Roll_m = zeros(1,N_scan);

Ele_m = sin(2*pi*f_m*t);
Azi_m = 1.5*sin(2*pi*f_m*t);
Roll_m = 2*sin(2*pi*f_m*t);



Dr = zeros(1,N_scan);

PointEle = zeros(1,N_scan);
PointAzi = zeros(1,N_scan);

% ���߽���ֵ
% q_y = q_y0-10*sin(0.3*t);
% q_z = 10*sin(0.3*t);
% % ���߽��ٶ���ֵ
% Vqy = 3*cos(0.3*t);
% Vqz = 3*cos(0.3*t);

%% ���㲨��ָ�����ֵ��ʧ����
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
%     %% ����ʧ���ǲ���ֵAzi
%     epsilon_Ele(i) = q_y(i)-PointEle(i);
%     epsilon_Azi(i) = q_z(i)-PointAzi(i);
%     % �����֡��Ŀ������ֵ
%     if i~=1
%         R(i) =  fcn_sight_coor_2_range(q_y(i-1),q_z(i-1),R(i-1),q_y(i),q_z(i));
%     end
%     % ���㵼��Ŀ��ӽ��ٶ�
%     kk(i) = -2*v_m/R(i);
% end



n=4;%״̬ά��
t=dt;%���õ���
Q=[0.04^2 0 0 0;
    0 0.04^2 0 0;
    0 0 0.04^2 0;
    0 0 0 0.04^2;];%��������Э������
R = [0.02^2 0;
    0 0.02^2];%��������Э������



s=[q_z0;3;q_y0;2;];
% ��ֵ

P0 =[0.1 0 0 0;
    0 0.1 0 0;
    0 0 0.1 0;
    0 0 0 0.1;];%��ʼ��Э����
N=N_scan;%�ܷ���ʱ�䲽��������ʱ��
Xukf = zeros(n,N);%UKF�˲�״̬��ʼ��
X = zeros(n,N);%״ֵ̬�����ڼ������ֵ��
Z = zeros(2,N);%����ֵ
X1 = zeros(n,N);
x0 = s+sqrtm(Q)*randn(n,1);%��ʼ��״̬
X(:,1) = x0;
X1(:,1) = s;
s1 = s;

for i=2:N_scan
%      ͨ��ʵ�ֽǼ��㵯Ŀ����
    if i~=1
        % �������߽�
        ele = X(3,i-1)+t*X(4,i-1);
        azi = X(1,i-1)+t*X(2,i-1);
        % ���㵯Ŀ����
        Rmt(i) =  fcn_sight_coor_2_range(X(3,i-1),X(1,i-1),Rmt(i-1),ele,azi);        
    end
    % ����ϵ��
    dR = Rmt(i) - Rmt(i-1);
    % ����ϵ��
    Vr = dR/dt;
    kk(i) = -2*Vr/Rmt(i);
    
    %״̬����
    f=@(x)[x(1)+x(2)*t;x(2)+t*(kk(i)*x(2)+2*x(2)*x(4)*tand(x(3)));...
        x(3)+t*x(4);x(4)+t*(-x(2)^2*sind(x(3))*cos(x(3))+kk(i)*x(4))];

    %x1Ϊ��λ���߽ǣ�x2Ϊ��λ���߽��ٶȣ�x3Ϊ�������߽ǡ�x4Ϊ�������߽��ٶ�
    X(:,i) = f(s)+sqrtm(Q)*randn(4,1);%ģ�⣬����Ŀ���˶���ʵ�켣
    X1(:,i) = f(s1);                  %������������������
    s = X(:,i);
    s1 = X1(:,i);
end

ux=x0;%uxΪ�м����
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
    
    %�۲ⷽ��
    h=@(x)[atand((R33*sind(x(1))-R21*cosd(x(3))-R32*tand(x(3)))/(R11*cosd(x(1))+R12*tand(x(3))-R13*sind(x(1))));...
        asind(R21*cosd(x(3))*cosd(x(1))+R22*sind(x(3))-R23*sind(x(1))*cosd(x(3)));];
            
    Z(:,k)= h(X(:,k)) + sqrtm(R)*randn(2,1);%����ֵ������۲�
    [Xukf(:,k), P0] = ukf(f,ux,P0,h,Z(:,k),Q,R);%����ukf�˲��㷨
    ux=Xukf(:,k);
    RMS(k)=sqrt((X(2,k)-Xukf(2,k))^2+(X(4,k)-Xukf(4,k))^2 );
    
        
end


figure('name','�޼��������˲����������߽��ٶ�')
plot(1:N_scan,Xukf)

hold on 
plot(1:N,X1(1,:),'g--','LineWidth',2)
hold on
plot(1:N,X1(3,:),'r--','LineWidth',2)
hold on 
plot(1:N,X1(2,:),'b--','LineWidth',2)
hold on
plot(1:N,X1(4,:),'y--','LineWidth',2)
legend({'��λ���߽�','��λ���߽��ٶ�','�������߽�','���߽��ٶ�','��λ���߽���ֵ','�������߽���ֵ','��λ���߽��ٶ���ֵ','�������߽��ٶ���ֵ'},'Location','southwest')





% figure('name','�������')
% plot(1:N,RMS)



