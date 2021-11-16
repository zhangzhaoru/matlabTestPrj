%% **************************************************************
%���ƣ�Opitiaml Based Alignment (GPS velocity aided) version 2.0
%���ܣ�
%________________________________________________________________________
%
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��10��22�� 
% ************************************************************************
%%
close all
clear all

% ȫ�ֱ���
gvar_earth;

% ��������
% ����avp_simData.(att, pos, vn) ��imu_simData.(acc, gry)
load('D:\data\simulate_data\trajectory_simulator_data.mat');

% ���ݲ���
ts_imu = 0.01;
% ���ö������㷨ʱʹ�õ�������
num_of_subsample = 2;
nts = num_of_subsample*ts_imu;

% ��msr=ref+errģ��imu���
imuerr = imuerrorset('selfdefine');
[imu_msr.vb, imu_msr.tb] = imuadderr(imu_simData.vb, imu_simData.tb, imuerr, ts_imu);

% ʱ�����
init_time = 0;
k_init = fix(init_time/ts_imu) + 1;
total_time = 100;

% ״̬������ֵ
init_pos_ref = avp_simData.pos(k_init, :)';
init_vn_ref = avp_simData.vn(k_init, :)';
init_att_ref = avp_simData.att(k_init, :)';
Cbn0_ref = a2mat(init_att_ref);

% ������ǰһʱ��ֵ,�ڶ�����δ�����ܻ����õĳ�ֵ���
prev_pos = init_pos_ref + [0, 0, 0]';
prev_vn = init_vn_ref + [0, 0, 0]';
init_vn = init_vn_ref + [0, 0, 0]';
prev_att = init_att_ref + [5, 5, 100]'*arcdeg;
prev_eth = earth(prev_pos, prev_vn);
prev_K = zeros(4, 4);

% ʱ����̬�����ֵ
prev_Cntn0 = eye(3);
prev_Cbtb0 = eye(3);
alpha_sigma_term = [0, 0, 0]';
prev_beta = [0, 0, 0]';
beta = [0, 0, 0]';
qbtb0 = [1, 0, 0, 0]';
% Ϊ��̬���������ڴ�
calc_att_stg = zeros(length(avp_simData.att), 3);
calc_init_att_stg = zeros(length(avp_simData.att), 3);
att_err_stg = zeros(length(avp_simData.att), 3);

% ����ѭ����һЩ��Ҫ�ļ�������
% ���imu������Ϣ�Ĵ���
Lp_msr = 0;
% ���и��µĴ���
Lp_update = 0;
% ��ǰʱ��(�Դӵ�����ʼʱ�̶���������ʼʱ��)
crt = ts_imu;
%%
% ���˼·�������ģ������У�ÿ��ts_imuʱ��imu�ͻ����һ����������ٶ�����
% ��Ϣ���ڲ��ö������㷨(�Զ�����Ϊ��)ʱ��ÿ���2��imu����ֵ���������������
% һ�ιߵ����¡�Lp�ĺ������imu�����Ϣ�Ĵ�����
while (crt + init_time) < total_time
    % ����ѭ����������+1
    Lp_msr = Lp_msr+1;
    
    % ��ǰʱ��������avp_simData��imu_simData�ж�Ӧ�ı�� 
    k = round(crt/ts_imu) + k_init;
    
    % ÿ����㹻������������ͽ���һ�ιߵ�����,����ʲôҲ����
    if mod(Lp_msr, num_of_subsample) == 0
        % ���йߵ����µĴ���
        Lp_update = Lp_update+1;
        
        % ����imu������Ϣ
        % ʵ������µ����������ÿ��⵽һ��imu����ͻᱣ��һ�Ρ�����Ϊ
        % ��̷��㣬�����Ϊ��ÿ��nts��������ƾ�һ���Ӷ���num_of_subsample
        % �β�����������һ�ζ��벢����һ������
        wm = imu_msr.tb(k-num_of_subsample+1 : k, :);
        vm = imu_msr.vb(k-num_of_subsample+1 : k, :);
        
        % ����Բ׶/�������
        [phim, dvbm] = cnscl(wm, vm);
        
        % Ŀǰ���˼�����̬֮��ó����ݲ����йߵ����£�pos��vn����GPS����
        % ģ��GPS����(��ʱ�������)
        gps.pos = avp_simData.pos(k, :)';
        gps.vn = avp_simData.vn(k, :)';
        pos = gps.pos;
        vn = gps.vn; 
        
        % ����Cbtb0��Cntn0
        Cbtb0 = prev_Cbtb0*rv2m(phim);
        Cntn0 = prev_Cntn0*rv2m(prev_eth.winn*nts);
        
        % *** ����alpha(n0)��beta(b0) ***
        % alpha(n0)
        % 1. Ŀǰ��vn0_ref����alpha, ��ʱ�����ǻ������ڡ�
        % 2. ��gps�����λ�ü���wien��gn
        alpha_sigma_term = alpha_sigma_term + ...
            prev_Cntn0*(cross(prev_eth.wien, prev_vn) - prev_eth.gn)*nts;
        alpha = Cntn0*vn - init_vn + alpha_sigma_term;
        % beta(b0)
        beta = prev_beta + prev_Cbtb0*dvbm;
        
        % QUEST����qbn0
        [ qbn0, prev_K ] = QUEST( beta, alpha, prev_K );
        
        % 
        Cbn0 = q2mat(qbn0); 
        Cbn = Cntn0'*Cbn0*Cbtb0;
        calc_att_stg(Lp_update, :) = m2att(Cbn)';
        att_err_stg(Lp_update, :) = attnorml(m2att(Cbn)' ...
                                        - avp_simData.att(k, :));
        calc_init_att_stg(Lp_update, :) = q2att(qbn0)';
        
        % ����һЩ��Ҫ���ٶ�
        eth = earth(pos, vn);
        
        % �����´�ѭ���ĳ�ֵ
        prev_Cbtb0 = Cbtb0;
        prev_Cntn0 = Cntn0;
        prev_beta = beta;
        prev_eth = eth;
        prev_pos = pos;
        prev_vn = vn;
    else
        % do noting
    end
        
    % ** �´ν���ѭ����ʱ�� **
    crt = crt + ts_imu;
end

% ɾ������ռ�
calc_att_stg(Lp_update+1 : end, :) = [];
calc_init_att_stg(Lp_update+1 : end, :) = [];
att_err_stg(Lp_update+1 : end, :) = [];
%% ��ͼ
Time_axis_of_update = (1:1:Lp_update)*nts;
length_of_imu = (1:1:length(imu_simData.vb))*ts_imu;

% ������̬(Cbn0)
msplot(311, Time_axis_of_update, calc_init_att_stg(:, 1)*deg, 'ʱ�� /s', 'pitch /rad');
title('Cbn0');
msplot(312, Time_axis_of_update, calc_init_att_stg(:, 2)*deg, 'ʱ�� /s', 'roll /rad');
msplot(313, Time_axis_of_update, calc_init_att_stg(:, 3)*deg, 'ʱ�� /s', 'yaw /rad');

% ������̬(Cbn)
msplot(311, Time_axis_of_update, calc_att_stg(:, 1)*deg, 'ʱ�� /s', 'pitch /rad');
title('change of Cbn');
msplot(312, Time_axis_of_update, calc_att_stg(:, 2)*deg, 'ʱ�� /s', 'roll /rad');
msplot(313, Time_axis_of_update, calc_att_stg(:, 3)*deg, 'ʱ�� /s', 'yaw /rad');

% ��̬���
msplot(311, Time_axis_of_update, att_err_stg(:, 1)*deg, 'ʱ�� /s', 'pitch /rad');
title('attitude error');
msplot(312, Time_axis_of_update, att_err_stg(:, 2)*deg, 'ʱ�� /s', 'roll /rad');
msplot(313, Time_axis_of_update, att_err_stg(:, 3)*deg, 'ʱ�� /s', 'yaw /rad');

% imu���ģ��ֵ
msplot(311, length_of_imu, imu_simData.vb(:, 1), 'ʱ�� /s', 'fb(1) m/s^2');
title('accelerometer outpute');
msplot(312, length_of_imu, imu_simData.vb(:, 2), 'ʱ�� /s', 'fb(2) m/s^2');
msplot(313, length_of_imu, imu_simData.vb(:, 3), 'ʱ�� /s', 'fb(3) m/s^2');

% imu���ģ��ֵ
msplot(311, length_of_imu, imu_simData.tb(:, 1), 'ʱ�� /s', 'wb(1) rad/s');
title('gyroscope outpute');
msplot(312, length_of_imu, imu_simData.tb(:, 2), 'ʱ�� /s', 'wb(2) rad/s');
msplot(313, length_of_imu, imu_simData.tb(:, 3), 'ʱ�� /s', 'wb(3) rad/s');
