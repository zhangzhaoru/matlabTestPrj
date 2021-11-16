%% 稳态卡尔曼滤波器仿真
% Range changes with time
% Steady kalman filter for seeker tracking system
clc
ts =0.1;
% 帧扫描周期
% Target escape maneuver(tao = 60, turn maneuver; tao = 1, atmosphere disturbance)
tao =20;
% 弹体速度
Vm = 1500;
% 目标速度
Vt =400;
% Intercept attack Vc=Vm-Vt;
% 弹目距离
R0= 15000;
Vc = Vm-Vt;
% 打击总时长
Tgo =R0/Vc;
a= 1/tao;
N=200;
X0 = zeros(3, 1) ;
Qk = 1.0;
Rk=1.0;
randn('seed',0) ;
Wt = sqrt(Qk) * randn(N, 1);
V = sqrt(Rk) * randn(N + 1, 1) ;
t =0:ts:N * ts;
Wa = sin (2 * pi * 0.1 * t) ;
U = [ Wa; zeros(1,N+1) ] ;
i = 1;
fid = fopen ('./ComData.txt','at+') ;

while i <= N
    
    t=ts*(i-1);
    R = R0 -Vc* t;
    W=[0 0 Wt(i)]';
    if R >0
        A=[0 1 0;0 -2*Vc/R -1/R;0 0 -a];
        B=[-1 0;0 1/R;0 0];
        C=[1 0 0];
        D = zeros(1,2);
        Plant= ss(A,B,C,D);
        % Use process noise w and measurement noise v generated out
        DPlant = c2d(Plant, ts,'z');
        Out = lsim (DPlant, U) ; % w = process noise
        yout0 = Out(length(Out), :) ;
        yout = yout0 + Wt(i);
        yv = yout + V(i) ; % v = measurement noise
        [ kalmf,L,P,M] = kalman(Plant,Qk,Rk);
        err= trace(P) ;
        y = [ yout0, yout, yv, err] ;
        fprintf(fid,'%12.8f%12.8f%12.8f%12.8f \n',y) ;
        i=i+1;
    else
        error('Range is zero!');
    end
end
fclose(fid);


