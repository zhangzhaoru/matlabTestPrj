%% ����������
clear all;
close all;
clc;

Time=0;
TimeStep=0.005; %���沽��
%-------��ʼ���Ƶ�ϵͳ����---------
pi=3.141592653;
g=9.8;
Ma=340;
%---------��������--------------
Rmx=50;Rmy=0; %������ʼλ��
Vm=-3.24*Time^3+41.7*Time^2-248*Time+340; %�����ٶȣ�m/s)
AmMay=500*g; %��������������
HeadError=-0.001; %ָ������

%-------Ŀ�����------------
Rt=8000;  %Ŀ���ʼ���루��Ŀб�ࣩ
ThetaT=pi+8/180*pi; %Ŀ���ٶȷ���
Rtx=Rt*cos(8/180*pi); %Ŀ���ʼX��λ��
Rty=Rt*sin(8/180*pi); %Ŀ���ʼY��λ��
Vt=3*Ma; %Ŀ���ٶȣ�m/s)
AtMay=0*g; %Ŀ���������

%--------������Ŀ�꼸���˶�ѧ����--------
Rtmx=Rtx-Rmx; %��Ŀ��X�᷽�����Ծ���
Rtmy=Rty-Rmy; %��Ŀ��Y�᷽�����Ծ���
Rtm=sqrt(Rtmx^2+Rtmy^2); %���㵯Ŀ��Ծ���
SightAngle=atan(Rtmy/Rtmx); %���߽�
LeadAngle=asin(Vt*sin(SightAngle-ThetaT)/Vm); %ָ���
Vmx=Vm*cos(SightAngle-LeadAngle+HeadError); %������X�᷽����ٶȷ���
Vmy=Vm*sin(SightAngle-LeadAngle+HeadError); %������Y�᷽����ٶȷ���
Vtx=Vt*cos(ThetaT); %Ŀ����X�᷽����ٶȷ���
Vty=Vt*sin(ThetaT); %Ŀ����Y�᷽����ٶȷ���
Vtmx=Vtx-Vmx; %��Ŀ��X�᷽���ϵ�����ٶ�
Vtmy=Vty-Vmy; %��Ŀ��Y���ϵ�����ٶ�
Vc=-(Rtmx*Vtmx+Rtmy*Vtmy)/Rtm; %��Ŀ����ٶ�

q=1;
Am=0;

dSightAngle=0;
% b1(1,1)=Rtm;
while(1)
    rmx2(1,q)=Rmx;
    rmy2(1,q)=Rmy;
    rtx2(1,q)=Rtx;
    rty2(1,q)=Rty;
    
    a2(1,q)=Am;
    time2(1,q)=Time;
    
    dq1(1,q)=SightAngle;
    dq2(1,q)=dSightAngle;
    b1(1,q)=Rtm;
    t1(1,q)=ThetaT;
    vm1(1,q)=Vm;
    if(abs(Rtm)<1) %����Ŀ��
        break;
    end
   if(abs(Rtm)<500)
       TimeStep=0.00005;
   end
   
   dSightAngle=(Rtmx*Vtmy-Rtmy*Vtmx)/(Rtm^2);  %���߽�����
   kd=3;
   
   %----------�������ٶȣ��������ٶ�ʸ����ֱ�����߽��ٶȷ���-------
   Am=Vc*dSightAngle*kd; %����������
   if Am>AmMay %���ƻ�������
       Am=AmMay;
   end
   if Am<-AmMay
       Am=-AmMay;
   end
    Amx=-Am*sin(SightAngle); %��x��ļ��ٶȷ���
    Amy=Am*cos(SightAngle);  %��Y��ļ��ٶȷ���
    %---------״̬ˢ��-----------------
    Time=Time+TimeStep;
 
    Rmx=Rmx+TimeStep*Vmx; %���µ���X��λ��
    Rmy=Rmy+TimeStep*Vmy; %���µ���Y��λ��
    Vm0=Vm;
    Vm=-3.24*Time^3+41.7*Time^2-248*Time+888; %���µ����ٶȣ�m/s)
    AVmx=(Vm-Vm0)*cos(SightAngle)/TimeStep; %�����ٶ���x��ļ��ٶȷ���
    AVmy=(Vm-Vm0)*sin(SightAngle)/TimeStep;  %�����ٶ���Y��ļ��ٶȷ���
    Vmx=Vmx+TimeStep*(Amx+AVmx); %���µ�����X�᷽���ٶȷ���
    Vmy=Vmy+TimeStep*(Amy+AVmy); %���µ�����Y�᷽���ٶȷ���
    %Vm=sqrt(Vmy^2+Vmx^2); %�����ٶȷ����ϳɺ���ٶ�
    
    Rtx=Rtx+TimeStep*Vtx; %����Ŀ��X��λ��
    Rty=Rty+TimeStep*Vty; %����Ŀ��Y��λ��
    Vtx=Vt*cos(ThetaT); %Ŀ����X���ٶȷ���
    Vty=Vt*sin(ThetaT); %Ŀ����Y���ٶȷ���
    
    Rtmx=Rtx-Rmx; %��Ŀ��X�᷽�����Ծ���
    Rtmy=Rty-Rmy; %��Ŀ��Y�᷽�����Ծ��� 
    Rtm0=Rtm; %�洢��һ�ε��Ѱ���
    Rtm=sqrt(Rtmx^2+Rtmy^2); %���㵯Ŀ��Ծ���

    SightAngle=atan(Rtmy/Rtmx); %���߽�
    
    Vtmx=Vtx-Vmx; %��Ŀ��X�᷽���ϵ�����ٶ�
    Vtmy=Vty-Vmy; %��Ŀ��Y���ϵ�����ٶ�
    Vc=-(Rtmx*Vtmx+Rtmy*Vtmy)/Rtm; %��Ŀ����ٶ�
    
    q=q+1;
end
 disp('�Ѱ���');
 Rtm
 disp('����ʱ��');
 Time

 figure(1);
 hold on;
 plot(rmx2,rmy2,'b');
 plot(rtx2,rty2,'g-');
 plot(rtx2(end),rty2(end),'k+');
 xlabel('ˮƽ���루�ף�');
 ylabel('��ֱ���루�ף�');
 legend1=legend('����','Ŀ��','���ص�');
 set(legend1,'Position',[0.2 0.8 0.1 0.05]);
 title('������Ŀ����������');
 hold off;
 
 figure(6);
 plot(time2,rmx2,'b');
 xlabel('ʱ�䣨�룩');
 ylabel('����x��λ��');
 title('��������λ��'); 
 figure(7);
 plot(time2,rmy2,'b');
 xlabel('ʱ�䣨�룩');
 ylabel('����y��λ��');
 title('��������λ��');
 
 figure(2);
 plot(time2,a2/g,'b');
 xlabel('ʱ�䣨�룩');
 ylabel('���أ��������ٶ�g)');
 title('������Ŀ�귨����ٶ�����');
 
 figure(3)
 plot(time2,dq2*57.3,'b');
 xlabel('ʱ�䣨�룩');
 ylabel('���߽��ٶȣ���ÿ�룩');
 title('������Ŀ�����߽��ٶ�����');
 
 figure(4)
 plot(time2,dq1,'b');
 xlabel('ʱ�䣨�룩');
 ylabel('���߽ǣ��ȣ�');
 title('������Ŀ�����߽�����');
 figure(5)
 plot(time2,b1,'b');
 xlabel('ʱ�䣨�룩');
 ylabel('���루��/�룩');
 title('������Ŀ�����');   
      
   
    
       
