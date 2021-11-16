%% **************************************************************
%���ƣ�angle motion and imu output simulation (version 1.0)
%���ܣ��û�Ԥ����̬���ó���ģ�����̬��������Ӧimu���
%________________________________________________________________________
% ���룺
%       ang_motion: �û����õĽ��˶�
%  ang_motion.p(r,y)��ÿһ�б���һ�������˶���Ӧ�Ĳ���
%  theta = A*sin( w*t + phi) + k;
%  ang_motion.p = [A1(��ֵ), w1(���ٶ�), phi1(��ʼ��λ), k1(����ֵ)
%                 A2(��ֵ), w2(���ٶ�), phi2(��ʼ��λ), k2(����ֵ)]
%       Time: [total_time, ts, nn] 
% �����
%       att : �����õĽ��˶�����Ӧ����̬
%       imu : ���� imu.fb_ref, imu.wb_ref, imu.fb_msr, imu.wb_msr
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��10��19��
% ************************************************************************
%%
close all;
clear all;

% ���ô洢λ�ü�Ŀ���ļ���
saved_path = 'D:\data\simulate_data';
data_name = 'angle_motion_data';

% ȫ�ֱ�������
gvar_earth;
pos = [46*arcdeg, 126*arcdeg, 100]';
eth = earth(pos, [0, 0, 0]');

total_time = 3000;
ts = 0.01;

% ���ý��˶�1
ang_motion.p = [2.5*arcdeg, 10*arcdeg, 0*arcdeg, 0*arcdeg];
ang_motion.r = [1.5*arcdeg, 10*arcdeg, 0*arcdeg, 0*arcdeg];
ang_motion.y = [10*arcdeg, 12*arcdeg, 0*arcdeg, 0*arcdeg
                6*arcdeg, 10*arcdeg, 0*arcdeg, 0*arcdeg
                8*arcdeg, 5*arcdeg, 0*arcdeg, 0*arcdeg];

% % ���ý��˶�2
% ang_motion.p = [0*arcdeg, 0*arcdeg, 0*arcdeg, 0*arcdeg];
% ang_motion.r = [0*arcdeg, 0*arcdeg, 0*arcdeg, 0*arcdeg];
% ang_motion.y = [10*arcdeg, 5*arcdeg, 0*arcdeg, 0*arcdeg];

% ���ô��������
imuerr = imuerrorset('selfdefine');

% Ϊ��̬��������洢�ռ�
att = zeros(fix(total_time/ts) + 10, 4);
imu_ref.fb = zeros(fix(total_time/ts) + 10, 4);
imu_ref.wb = zeros(fix(total_time/ts) + 10, 4);
%% simulation
% ��ǰʱ��,ע��crt��0��ʼ��ʱ,att����Ԫ��Ϊt=0ʱ�̵�������̬
crt = 0;
% ѭ������
Lp = 0;
while crt < total_time
    
    % ѭ������+1
    Lp = Lp+1;
    
    % �ֱ���ȡ������̬���˶���Ϣ
    % ����pitch(crt), roll(crt), yaw(crt)
    [pitch, wnb_p] = calculate_theta( ang_motion.p, crt );
    [roll, wnb_r] = calculate_theta( ang_motion.r, crt );
    [yaw, wnb_y] = calculate_theta( ang_motion.y, crt );
    
    % ��̬
    Cbn = a2mat([pitch, roll, yaw]');
    
    % wnbnx, ע��ý��ٶȲ�����ȫͶӰ��nϵ������ֻ��Ϊ�˷����������ʾ
    wnbnx = [wnb_p, wnb_r, wnb_y]';
    
    % ����wibb, Cnxb�е�nx��ʾ(n1, n2, b)����������ϵ
    Cnxb = [ cos(roll), 0, -cos(pitch)*sin(roll)
                    0,  1,            sin(pitch)
            sin(roll),  0,  cos(pitch)*cos(roll)];
    wibb_ref = Cnxb*wnbnx + Cbn'*eth.winn;
    
    % ���������˶����Ӽ����ӦΪbϵ���������ٶ�
    fb_ref = Cbn'*eth.gn;
    
    % ������
    att(Lp, :) = [pitch, roll, yaw, crt];
    imu_ref.fb(Lp, :) = [fb_ref', crt];
    imu_ref.wb(Lp, :) = [wibb_ref', crt];
    
    % ����һ��������ʱ�䣬Ϊ�´μ�����׼��
    crt = crt + ts;
%     progressTip(crt);
end
% ɾ���洢�����еĿ�λ
att(Lp+1:end, :) = [];
imu_ref.fb(Lp+1:end, :) = [];
imu_ref.wb(Lp+1:end, :) = [];

% imu_ref��������imu_msr
[ imu_msr.fb, imu_msr.wb ] = imuadderr(imu_ref.fb, imu_ref.wb, imuerr, ts);
%% ��ͼ
% ʱ����
Time_axis = (1 : 1 : Lp)*ts;

% ��̬��
msplot(311, Time_axis, att(:, 1)*deg, 'ʱ�� /s', 'pitch /\circ');
title('��̬�Ǳ仯');
msplot(312, Time_axis, att(:, 2)*deg, 'ʱ�� /s', 'roll /\circ');
msplot(313, Time_axis, att(:, 3)*deg, 'ʱ�� /s', 'yaw /\circ');

% imu.fb_ref
msplot(321, Time_axis, imu_ref.fb(:, 1), 'ʱ�� /s', 'fbx m/s^2');
title('�ӼƱ�׼���');
msplot(323, Time_axis, imu_ref.fb(:, 2), 'ʱ�� /s', 'fby m/s^2');
msplot(325, Time_axis, imu_ref.fb(:, 3), 'ʱ�� /s', 'fbz m/s^2');
% imu.wb_ref
msplot(322, Time_axis, imu_ref.wb(:, 1)*deg, 'ʱ�� /s', 'wibb x rad/s');
title('���ݱ�׼���');
msplot(324, Time_axis, imu_ref.wb(:, 2)*deg, 'ʱ�� /s', 'wibb y rad/s');
msplot(326, Time_axis, imu_ref.wb(:, 3)*deg, 'ʱ�� /s', 'wibb z rad/s');

% imu fb_msr
msplot(321, Time_axis, imu_msr.fb(:, 1), 'ʱ�� /s', 'fbx m/s^2');
title('�ӼƲ���ֵ');
msplot(323, Time_axis, imu_msr.fb(:, 2), 'ʱ�� /s', 'fby m/s^2');
msplot(325, Time_axis, imu_msr.fb(:, 3), 'ʱ�� /s', 'fbz m/s^2');
% imu.wb_msr
msplot(322, Time_axis, imu_msr.wb(:, 1)*deg, 'ʱ�� /s', 'wibb x rad/s');
title('���ݲ���ֵ');
msplot(324, Time_axis, imu_msr.wb(:, 2)*deg, 'ʱ�� /s', 'wibb y rad/s');
msplot(326, Time_axis, imu_msr.wb(:, 3)*deg, 'ʱ�� /s', 'wibb z rad/s');

%% ��������
% �����Ϣ
dataInfo.descreption = ...
    'This attitude trajectory combination of sine angular montion';
dataInfo.name = data_name;
dataInfo.date = datestr(now);
dataInfo.type = 'simulation data';
dataInfo.ts = ts;
dataInfo.pos = pos;
dataInfo.imuerr = imuerr;
dataInfo.length = length(att);

% Ϊ���ڹ������켣���������������ݱ��浽ͬһ���ļ���
cd(saved_path);
save(data_name, 'att', 'imu_ref', 'imu_msr', 'dataInfo');
cd('D:\inertial_navigation_basic');
% �������Ҫ�ı���
clearvars -except att imu_ref imu_msr dataInfo
%% ר�ú���
function [ theta, omega ] = calculate_theta( ang_motion, crt )
%% **************************************************************
%���ƣ�Calculate theta(angule) form the seted angule motion 
%���ܣ�����Ԥ����˶���ʽ������currentʱ�̵ĽǶ�,ר���Ӻ���
%ע�⣺Ŀǰ��û����ӹ淶����̬�ǵĹ��ܣ���˾�����Ҫ��ҡ�ڷ�ֵ��Ĺ���
%________________________________________________________________________
% ���룺
%       ang_motion: Ԥ����˶���ÿһ�ж�Ӧ��һ�����磺
%                   theta = A*sin( w*t + phi) + k���˶���������˶������ɸ�
%                   �����˶����Ӷ���
%       crt: ��ǰʱ��
% �����
%       theta: ��Ԥ����˶�����Ӧ����̬ (rad)
%       omega: ��Ԥ����˶�����Ӧ�ĵ�ǰʱ�̽��ٶ� (rad/s)
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��10��19��
% ************************************************************************
%%
% i��ʾ ang_motion �еĵ�i��
i = 1;

% ���ang_motion�д��ڵ�i��
while i <= size(ang_motion, 1)
    
    if i == 1
        theta = 0;  % rad
        omega = 0;  % rad/s
    end
    
    % ang_motion.p = [A1(��ֵ), w1(���ٶ�), phi1(��ʼ��λ), k1(����ֵ)
    %                 A2(��ֵ), w2(���ٶ�), phi2(��ʼ��λ), k2(����ֵ)
    %                                    ...                         ]
    % ע��: ang_motion�б����ĵ�λΪrad��rad/s
    A = ang_motion(i, 1);
    w = ang_motion(i, 2);
    phi = ang_motion(i, 3);
    k = ang_motion(i, 4);
    
    % ��̬��
    theta = A*sin( w*crt + phi) + k + theta;
    
    % wnbnx    nx�ֱ���(n n1), (n1 n2), (n1 b)
    omega = w*A*cos(w*crt + phi) + omega;
    
    % i+1, ׼�����ang_motion�Ƿ������һ��
    i = i+1;
    
end

end
