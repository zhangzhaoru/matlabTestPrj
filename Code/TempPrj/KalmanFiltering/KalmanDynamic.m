%% ¶¯Ì¬¿¨¶ûÂüÂË²¨Æ÷·ÂÕæ
% Range changes with time
% Adaptive dynamic kalman filter for seeker tracking system
clc
T=0.01;
N =600;
g =9.8; 
% Target escape maneuver (tao = 60, turn maneuver; tao = 1, atmosphere disturbance)
tao =20; 
Vm=800; 
Vt= -300; 
% Intercept attack 
Vc=Vm-Vt; 
R0 =6000; 
a=1/tao; 
At_max = 3 * g; % Target escape maximum acceleration 
G = [ 0 ; T^2/(2 * R0); T-a*T^2/2] ; 
X0 = zeros (3, 1) ; 
X = zeros (3, 1) ; % Initial condition on the state 
Rk =0.01^2; 
randn('seed',0) ; 
V = sqrt (Rk) * randn (1, N) ; 
P = [0.01^2 0 0 ;0 0.1^2 0;0 0 50^2];
% Initial error. covariance 
Z00 =0; 
i = 1; 
fid = fopen ('./ComData2.txt','at+') ;

while i <= N
    t=T*(i-1); 
    R = R0 -Vc * t; 
    Qk =2 *a* ((4 -pi)/pi) * (At_max -X(3))^2;
    Wt = sqrt(Qk) * randn(1, 1); 
    W = [0 0 Wt]';
    Wa =3.0*sin(2 * pi *0.25 * t)/57.3; 
    U = [Wa;50];
    if R>0
        Phi= [1 T 0;0 1-2*(Vc/R)*T -T/R;0 0 1-a*T]; 
        B=[-T T^2/(2* R);0 T/R-(Vc/(R^2))*T^2;0 0]; 
        G=[0;T^2/(2*R);T-a*T^2/2];
        G=[0;T^2/(2 * R) ; T-a*T^2/2] ; 
        H=[1 0 0]; 
        % Measured value 
        X0 = Phi * X0 + B * U + G * Wt; 
        Z0 =H * X0; 
        Z(i) =Z0 + V(i); 
        qdot = (Z (i) -Z00)/T; 
        % Time update 
        p = Phi * P * Phi' + G * Qk * G'; 
        X=Phi*X+B*U; 
        % compute Kalman gain'K'and covariance'P' 
        K=P*H'*inv(H*P*H'+Rk); 
        X = X + K * (Z(i) -H * X); 
        P = (eye (3) -K * H) * P; 
        % compute state estimation'X' 
        Ze=H*X; 
        errcov = H * P * H'; 
        Err = Z0 -X(1); 
        y = [ t;Z0*57.3;Z(i)*57.3;Ze*57.3;X(2)*57.3;qdot;X(3)]; 
        fprintf(fid,'%6.2f%12.8f%12.8f%12.8f%12.8f%12.8f%12.8f \n',y);
        Z00 =Z(i); 
        i=i+1;
    else
        error('Range is zero !') 
    end
end
fclose(fid);