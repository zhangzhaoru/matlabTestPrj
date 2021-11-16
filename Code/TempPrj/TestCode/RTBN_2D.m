%% 比例导引律
clear all;
close all;
clc;

Time=0;
TimeStep=0.005; %仿真步长
%-------初始化制导系统参数---------
pi=3.141592653;
g=9.8;
Ma=340;
%---------导弹参数--------------
Rmx=50;Rmy=0; %导弹初始位置
Vm=-3.24*Time^3+41.7*Time^2-248*Time+340; %导弹速度（m/s)
AmMay=500*g; %导弹最大机动能力
HeadError=-0.001; %指向角误差

%-------目标参数------------
Rt=8000;  %目标初始距离（弹目斜距）
ThetaT=pi+8/180*pi; %目标速度方向
Rtx=Rt*cos(8/180*pi); %目标初始X轴位置
Rty=Rt*sin(8/180*pi); %目标初始Y轴位置
Vt=3*Ma; %目标速度（m/s)
AtMay=0*g; %目标机动能力

%--------导弹和目标几何运动学结算--------
Rtmx=Rtx-Rmx; %弹目在X轴方向的相对距离
Rtmy=Rty-Rmy; %弹目在Y轴方向的相对距离
Rtm=sqrt(Rtmx^2+Rtmy^2); %计算弹目相对距离
SightAngle=atan(Rtmy/Rtmx); %视线角
LeadAngle=asin(Vt*sin(SightAngle-ThetaT)/Vm); %指向角
Vmx=Vm*cos(SightAngle-LeadAngle+HeadError); %导弹沿X轴方向的速度分量
Vmy=Vm*sin(SightAngle-LeadAngle+HeadError); %导弹沿Y轴方向的速度分量
Vtx=Vt*cos(ThetaT); %目标沿X轴方向的速度分量
Vty=Vt*sin(ThetaT); %目标沿Y轴方向的速度分量
Vtmx=Vtx-Vmx; %弹目在X轴方向上的相对速度
Vtmy=Vty-Vmy; %弹目在Y轴上的相对速度
Vc=-(Rtmx*Vtmx+Rtmy*Vtmy)/Rtm; %弹目相对速度

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
    if(abs(Rtm)<1) %击中目标
        break;
    end
   if(abs(Rtm)<500)
       TimeStep=0.00005;
   end
   
   dSightAngle=(Rtmx*Vtmy-Rtmy*Vtmx)/(Rtm^2);  %视线角速率
   kd=3;
   
   %----------导弹加速度（导弹加速度矢量垂直于视线角速度方向）-------
   Am=Vc*dSightAngle*kd; %比例导引律
   if Am>AmMay %限制机动能力
       Am=AmMay;
   end
   if Am<-AmMay
       Am=-AmMay;
   end
    Amx=-Am*sin(SightAngle); %沿x轴的加速度分量
    Amy=Am*cos(SightAngle);  %沿Y轴的加速度分量
    %---------状态刷新-----------------
    Time=Time+TimeStep;
 
    Rmx=Rmx+TimeStep*Vmx; %更新导弹X轴位置
    Rmy=Rmy+TimeStep*Vmy; %更新导弹Y轴位置
    Vm0=Vm;
    Vm=-3.24*Time^3+41.7*Time^2-248*Time+888; %更新导弹速度（m/s)
    AVmx=(Vm-Vm0)*cos(SightAngle)/TimeStep; %轴向速度沿x轴的加速度分量
    AVmy=(Vm-Vm0)*sin(SightAngle)/TimeStep;  %轴向速度沿Y轴的加速度分量
    Vmx=Vmx+TimeStep*(Amx+AVmx); %更新导弹沿X轴方向速度分量
    Vmy=Vmy+TimeStep*(Amy+AVmy); %更新导弹沿Y轴方向速度分量
    %Vm=sqrt(Vmy^2+Vmx^2); %导弹速度分量合成后的速度
    
    Rtx=Rtx+TimeStep*Vtx; %更新目标X轴位置
    Rty=Rty+TimeStep*Vty; %更新目标Y轴位置
    Vtx=Vt*cos(ThetaT); %目标沿X轴速度分量
    Vty=Vt*sin(ThetaT); %目标沿Y轴速度分量
    
    Rtmx=Rtx-Rmx; %弹目在X轴方向的相对距离
    Rtmy=Rty-Rmy; %弹目在Y轴方向的相对距离 
    Rtm0=Rtm; %存储上一次的脱靶量
    Rtm=sqrt(Rtmx^2+Rtmy^2); %计算弹目相对距离

    SightAngle=atan(Rtmy/Rtmx); %视线角
    
    Vtmx=Vtx-Vmx; %弹目在X轴方向上的相对速度
    Vtmy=Vty-Vmy; %弹目在Y轴上的相对速度
    Vc=-(Rtmx*Vtmx+Rtmy*Vtmy)/Rtm; %弹目相对速度
    
    q=q+1;
end
 disp('脱靶量');
 Rtm
 disp('攻击时间');
 Time

 figure(1);
 hold on;
 plot(rmx2,rmy2,'b');
 plot(rtx2,rty2,'g-');
 plot(rtx2(end),rty2(end),'k+');
 xlabel('水平距离（米）');
 ylabel('垂直距离（米）');
 legend1=legend('导弹','目标','拦截点');
 set(legend1,'Position',[0.2 0.8 0.1 0.05]);
 title('导弹与目标拦截曲线');
 hold off;
 
 figure(6);
 plot(time2,rmx2,'b');
 xlabel('时间（秒）');
 ylabel('导弹x轴位置');
 title('导弹横向位置'); 
 figure(7);
 plot(time2,rmy2,'b');
 xlabel('时间（秒）');
 ylabel('导弹y轴位置');
 title('导弹纵向位置');
 
 figure(2);
 plot(time2,a2/g,'b');
 xlabel('时间（秒）');
 ylabel('过载（重力加速度g)');
 title('导弹与目标法向加速度曲线');
 
 figure(3)
 plot(time2,dq2*57.3,'b');
 xlabel('时间（秒）');
 ylabel('视线角速度（度每秒）');
 title('导弹与目标视线角速度曲线');
 
 figure(4)
 plot(time2,dq1,'b');
 xlabel('时间（秒）');
 ylabel('视线角（度）');
 title('导弹与目标视线角曲线');
 figure(5)
 plot(time2,b1,'b');
 xlabel('时间（秒）');
 ylabel('距离（米/秒）');
 title('导弹与目标距离');   
      
   
    
       
