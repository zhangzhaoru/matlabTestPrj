%% **************************************************************
%���ƣ�attitude update test
%���ܣ���̬�����㷨���Գ���
%________________________________________________________________________
% 
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��10��19��
% ************************************************************************
%%
clear all;close all;

% ��������
load('D:\data\simulate_data\angle_motion_data');

% ����ͱ���һЩȫ�ֱ���
gvar_earth;
pos = dataInfo.pos;
eth = earth(pos, [0, 0, 0]');
% ���ݳ���
[roll_data, column_data] = size(att);
% ��ʱ��
total_time_of_data = att(end, 4);
% �������㷨���õ�������
% ע�⣡����ʱ���֣�����"ǿ��"һ����Ϊ���Σ���õ���round(��������)������
% fix(�������)���������ʱ��������ݶ�Ӧ�쳣�����⡣
num_sample = round(2);
% imu�����Ӧ����
ts_imu = dataInfo.ts;
% ����imu���
imuerr = imuerrorset('zero');
[ imu_msr.fb, imu_msr.wb ] = imuadderr( imu_ref.fb, imu_ref.wb, imuerr);

gyrerr = imu_msr.fb - imu_ref.fb;
% ��ʼʱ��,e.g.����init_time=20s,���ö������㷨������׸���̬����t=20.02s
% ����̬
init_time = abs(0);
% init_timeʱ�̵�������att�е�index
k_init = round(init_time/ts_imu) + 1;

% ��ʼ��̬
Cbn0_ref = a2mat(att(k_init, 1:3));
q_RK4 = a2qua(att(k_init, 1:3));
Cbn0 = Cbn0_ref;
Cntn0 = eye(3);
Cbtb0 = eye(3);

% *** Ϊ��̬�����ֱ�洢�ռ� ***
% �������㷨
att_subsample_stg = zeros(roll_data, 3);
% ���������
att_RK4_stg = zeros(roll_data, 3);
att_ref_stg = zeros(roll_data, 3);
% �������㷨���
att_err_subsample_stg = zeros(roll_data, 3);
% ������������
att_err_RK4_stg = zeros(roll_data, 3);
idx_stg = zeros(roll_data, 3);
% ѭ������
Lp_msr = 0;
Lp_subsample = 0;
Lp_RK4 = 0;

% ��ǰʱ��
crt = ts_imu;
k = 0;
%% 
while round((crt + init_time)/ts_imu) <= round(120/ts_imu)
    % ��Lp��ѭ��
    Lp_msr = Lp_msr+1;
    
    % crtʱ����������Ӧ�ı��
    k = round(crt/ts_imu) + k_init;
    idx_stg(Lp_msr, :) = [crt + init_time, k, round((crt + init_time)/ts_imu) - k];
    
    % *** �ò�ͬ����������̬ 1.��������������Ԫ�� 2.�Ľ���������� ***
    % ** ������ **
    if mod(round(Lp_msr), num_sample) == 0  
        % i��num_sample����������������㹻�Ĳ��������и���
        Lp_subsample = Lp_subsample+1;
        % imu�����������ʱ������ȡƽ��������imu����
        vm = 0.5*ts_imu.*(imu_msr.fb(k-num_sample+1 : k, 1:3)...
            + imu_msr.fb(k-num_sample : k-1, 1:3));
        
        wm = 0.5*ts_imu.*(imu_msr.wb(k-num_sample+1 : k, 1:3)...
            + imu_msr.wb(k-num_sample : k-1, 1:3));
        
        % ����Բ׶/�������
        [ phim, dvbm ] = cnscl(wm, vm);
        
        % ������̬�仯��
        Cntn0 = Cntn0*rv2m(eth.winn*num_sample*ts_imu);
        Cbtb0 = Cbtb0*rv2m(phim);
        Cbn = Cntn0'*Cbn0*Cbtb0;
        
        att_subsample_stg(Lp_subsample, :) = m2att(Cbn)*deg;
        att_ref_stg(Lp_subsample, :) = att(k, 1:3)*deg;
        att_err_subsample_stg(Lp_subsample, :) = ...
           att_subsample_stg(Lp_subsample, :) - att_ref_stg(Lp_subsample, :);
            
    else
        % do nothing
    end
    
    % ** �Ľ���������� **
    % �Ľ�����������ڸ�������(tn, tn+1]�ϣ��������β�����tn,tn+0.5,
    % tn+1�������ŵ���һ�θ�������Ϊ(tn+1, tn+2]����Ҫ���β���tn+1,tn+1.5,
    % tn+2���൱��ÿ��������µ�����ͽ���һ�θ��¡�
    % �������ʱ����idx=3,5,7,9...
    if mod(round(Lp_msr+1), 2) == 1 && Lp_msr+1 ~= 1
        % RK4���´���
        Lp_RK4 = Lp_RK4+1;
        % wibb
        wm = imu_msr.wb(k-2:k, 1:3);
        % wnbb = wibb - winb
        Cbn_RK4 = q2mat(q_RK4);
        wm = wm - repmat((Cbn_RK4*eth.winn)', 3, 1);
        % ����RK4����
        [ q_RK4 ] = Runge_Kutta_att_update( q_RK4, wm, ts_imu*2 );
        att_RK4_stg(Lp_RK4, :) = q2att(q_RK4)*deg;
        att_err_RK4_stg(Lp_RK4, :) = ...
                            att_RK4_stg(Lp_RK4, :) - att(k, 1:3)*deg;
    end
    
    % �ϵ�λ��
    hereStop = 1;
    
    % �´θ��µ�ʱ��
    crt = crt + ts_imu;
    
end
% crt�������һ�θ��µ�ʱ��
crt = crt - ts_imu;

% ���δʹ�ÿռ�
idx_stg(Lp_msr+1:end, :) = [];
att_subsample_stg(Lp_subsample+1:end, :) = [];
att_RK4_stg(Lp_RK4+1:end, :) = [];
att_ref_stg(Lp_subsample+1:end, :) = [];
att_err_subsample_stg(Lp_subsample+1:end, :) = [];
att_err_RK4_stg(Lp_RK4+1:end, :) = [];
%% ��ͼ
Time_axis_subsample = (1:1:Lp_subsample)*num_sample*ts_imu;
Time_axis_RK4 = (1:1:Lp_RK4)*2*ts_imu;
Time_axis_data = (0: length(imu_ref.fb)-1)*ts_imu;

% ��̬����ֵ
figure;
subplot(311)
plot(Time_axis_subsample, att_subsample_stg(:, 1));
xlabel('ʱ�� /s'); ylabel('pitch /deg'); hold on; 
plot(Time_axis_subsample, att_ref_stg(:, 1));
legend('����ֵ','�ο�ֵ');
subplot(312)
plot(Time_axis_subsample, att_subsample_stg(:, 2));
xlabel('ʱ�� /s'); ylabel('pitch /deg'); hold on; 
plot(Time_axis_subsample, att_ref_stg(:, 2));
subplot(313)
plot(Time_axis_subsample, att_subsample_stg(:, 3));
xlabel('ʱ�� /s'); ylabel('pitch /deg'); hold on; 
plot(Time_axis_subsample, att_ref_stg(:, 3));


% ������ ��̬���
msplot(311, Time_axis_subsample, att_err_subsample_stg(:, 1), 'ʱ�� /s', 'pitch err');
title('Subsample algorithm');
msplot(312, Time_axis_subsample, att_err_subsample_stg(:, 2), 'ʱ�� /s', 'roll err');
msplot(313, Time_axis_subsample, att_err_subsample_stg(:, 3), 'ʱ�� /s', 'yaw err');

% RK4 ��̬���
msplot(311, Time_axis_RK4, att_err_RK4_stg(:, 1), 'ʱ�� /s', 'pitch err');
title('RK4 algorithm');
msplot(312, Time_axis_RK4, att_err_RK4_stg(:, 2), 'ʱ�� /s', 'roll err');
msplot(313, Time_axis_RK4, att_err_RK4_stg(:, 3), 'ʱ�� /s', 'yaw err');

% ���������
figure
subplot(321)
plot(Time_axis_data, imu_ref.fb(:, 1));xlabel('ʱ�� /s');ylabel('fbx / m/s^2');hold on;
title('�Ӽ�')
plot(Time_axis_data, imu_msr.fb(:, 1));
subplot(323)
plot(Time_axis_data, imu_ref.fb(:, 2));xlabel('ʱ�� /s');ylabel('fby / m/s^2');hold on;
plot(Time_axis_data, imu_msr.fb(:, 2));
subplot(325)
plot(Time_axis_data, imu_ref.fb(:, 3));xlabel('ʱ�� /s');ylabel('fbz / m/s^2');hold on;
plot(Time_axis_data, imu_msr.fb(:, 3));
subplot(322)
plot(Time_axis_data, imu_ref.wb(:, 1));xlabel('ʱ�� /s');ylabel('wx / rad/s');hold on;
title('����');
plot(Time_axis_data, imu_msr.wb(:, 1));
subplot(324)
plot(Time_axis_data, imu_ref.wb(:, 2));xlabel('ʱ�� /s');ylabel('wy / rad/s');hold on;
plot(Time_axis_data, imu_msr.wb(:, 2));
subplot(326)
plot(Time_axis_data, imu_ref.wb(:, 3));xlabel('ʱ�� /s');ylabel('wz / rad/s');hold on;
plot(Time_axis_data, imu_msr.wb(:, 3));
