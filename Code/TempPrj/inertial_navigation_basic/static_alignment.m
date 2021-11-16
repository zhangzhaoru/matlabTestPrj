% ��̬��׼
%_________________________________________________________________________
%���ߣ����������̴�ѧ ���ܿ�ѧ�빤��ѧԺ ���
%���ڣ�2020��11��2��
% ************************************************************************
%%
close all
clear all

% ȫ�ֱ���
gvar_earth;

% imu����Ƶ��
ts_imu = 5*ms;
% ÿ����̬����ʹ�õ�������
num_of_subsample = 2;
% ��̬���²���
nts = num_of_subsample*ts_imu;

% *** ����imu��ת̨���� ***
% ��1�У�  �ߵ��ϵ�ʱ�䣬ÿ5ms����1��
% ��2�У�  �ߵ�״̬��0�������� 1~2 ��׼��3������
% ��3-5�У�XYZ���ݽ����ʣ���λrad/s������ϵΪ˳��Ϊ��ǰ���ҡ�
% ��6-8�У�XYZ�ӱ��������λm/s2������ϵΪ˳��Ϊ��ǰ���ҡ�
% ��9-15�У�XYZ�����¶ȣ�XYZ�ӱ��¶ȣ���·�¶ȣ���λ��
% ��16-17�У�ת̨�ڻ�λ�ã�ת̨�⻷λ�ã���λ��
data_folder = 'D:\data\N_201102\����1_\';
data_dir_info = dir(data_folder);

~isempty(strfind(data_dir_info(3).name, 'imu'));
data_name = '083815_testb_imuBoard';
data_path = strcat(data_folder, data_name, '.txt');
DT = load(data_path);

% ���������еĳɷ�
% ע�⣡ԭʼ������imu����˳��Ϊ��ǰ���ҡ��������Ϊ��ϰ��ʹ�õġ���ǰ�ϡ�
imu_msr.wb = [DT(:, 5), DT(:, 3:4)];
imu_msr.fb = [DT(:, 8), DT(:, 6:7)];
% �����ͽ��ٶ�ת��Ϊ�ٶ��������ٶ�����
imu_msr.tb = 0.5*ts_imu * (imu_msr.wb(1:end-1, :) + imu_msr.wb(2:end, :));
imu_msr.vb = 0.5*ts_imu * (imu_msr.fb(1:end-1, :) + imu_msr.fb(2:end, :));

for k = 1:length(imu_msr.fb)
    norm_of_msr_gn_stg(k) = norm(imu_msr.fb(k, :), 2);
end

if size(DT, 2) == 17   
    platform_ref = DT(:, 16:17);
end

% �����ܳ���
data_time = length(DT)*ts_imu;

% ʵ���λ����Ϣ
pos_ref = [39.8122*arcdeg, 116.1515*arcdeg, 44]';
pos = pos_ref;
vn_ref = [0, 0, 0]';
vn = vn_ref;

att_ref = [-0.0034, 0.0040, -1.5694]';
Cbn_ref = a2mat(att_ref);
qbn_ref = a2qua(att_ref);
% ������������
eth = earth(pos, vn);

% �������˲���ֵ
qbn = [1, 0, 0, 0]';
% kf.Qk = diag();
% kf.Rk = diag();

% ��ֵ
prev_alpha = [0, 0, 0]';
prev_beta = [0, 0, 0]';
prev_K = zeros(4, 4);
prev_Cbtb0 = eye(3);
prev_Cntn0 = eye(3);

% Ϊ��̬����Ԥ�����ڴ�
calc_att_stg = zeros(length(DT) + 10, 3);
calc_init_att_stg = zeros(length(DT) + 10, 3);
calc_pos_stg = zeros(length(DT) + 10, 2);
calc_vn_stg = zeros(length(DT) + 10, 3);
%% �ߵ����ºͶ�׼
% ѭ��������������
Lp_msr = 1;
Lp_update = 0;
crt = 0;
while crt < 305   
    Lp_msr = Lp_msr+1;
    k = Lp_msr; 
    
    % ÿ�����������һ�θ���
    if mod(Lp_msr, 2) == 1 && Lp_msr ~= 1
        Lp_update = Lp_update+1;
        
        % ��ȡ������Ϣ
        wm = imu_msr.tb(k-num_of_subsample:k-1, :);
        vm = imu_msr.vb(k-num_of_subsample:k-1, :);
        %����Բ׶�˶��ͻ����˶�
        [phim, dvbm] = cnscl(wm, vm);
        
        % ����Cbtb0��Cntn0
        Cbtb0 = prev_Cbtb0*rv2m(phim);
        Cntn0 = prev_Cntn0*rv2m(eth.winn*nts);       
        
        % *** �ߵ����� ***
        vn1 = vn + rv2m(-eth.winn*nts/2)*qmulv(qbn_ref, dvbm) + eth.gcc*nts;
        % ����λ��ʱ����[tm-1, tm]���ʱ���ڵ�ƽ���ٶ�
        vn = (vn + vn1)/2;
        
        % λ�ø���
        pos = pos + [vn(2)/eth.RMh, vn(1)/eth.clRNh, vn(3)]'*nts;
        % tm-1 ʱ�̵��ٶ�
        vn = vn1;

        % �ֶ�׼+����׼
        if round(Lp_msr*ts_imu) <= 100000
            % *** �ֶ�׼ ***
            % alpha and beta
            alpha = prev_alpha - prev_Cntn0*nts*eth.gn;
            beta = prev_beta + prev_Cbtb0*dvbm;
            % QUEST����qbn0
            [ qbn0, prev_K ] = QUEST( beta, alpha, prev_K );
            % �´θ��³�ֵ
            prev_alpha = alpha;
            prev_beta = beta;
            
            % OBA��������̬
            Cbn0 = q2mat(qbn0); 
            Cbn = Cntn0'*Cbn0*Cbtb0;            
        else
            % *** ����׼ ***
            [kf.Phikk_1, kf.Gammak, kf.Hk] = ...
                        model_static_fine_aligment(eth, Cbn, 12, nts);            
            kf = kfupdate( kf, vn ); 
        end
      
        % ���������
        calc_init_att_stg(Lp_update, :) = q2att(qbn0)';
        calc_att_stg(Lp_update, :) = m2att(Cbn)';
        calc_pos_stg(Lp_update, :) = pos(1:2)'*deg;
        calc_vn_stg(Lp_update, :) = vn';
        
        % �´γ�ֵ
        prev_Cbtb0 = Cbtb0;
        prev_Cntn0 = Cntn0;    
    end   
    
    if myequal(crt, 300)
        result_stg = m2att(Cbn)';
    end 
    
    progressTip(crt, ts_imu);
    % ��һ�����imu������Ϣ��ʱ��
    crt = crt + ts_imu;
end
calc_att_stg(Lp_update+1:end, :) = [];
calc_init_att_stg(Lp_update+1:end, :) = [];
calc_pos_stg(Lp_update+1:end, :) = [];
calc_vn_stg(Lp_update+1:end, :) = [];
%% ��ͼ
timeAxis_msr = (0:1:length(DT)-1)*ts_imu;
timeAxis_update = (0:1:Lp_update-1)*nts;

% ������̬(Cbn)
msplot(311, timeAxis_update, calc_att_stg(:, 1)*deg, 'ʱ�� /s', 'pitch /deg');
title(strcat(data_name, '   esitmated attitude curve'), 'Interpreter', 'none');
msplot(312, timeAxis_update, calc_att_stg(:, 2)*deg, 'ʱ�� /s', 'roll /deg');
msplot(313, timeAxis_update, calc_att_stg(:, 3)*deg, 'ʱ�� /s', 'yaw /deg');

% ������̬init
msplot(311, timeAxis_update, calc_init_att_stg(:, 1)*deg, 'ʱ�� /s', 'pitch /deg');
title(strcat(data_name,'    esitmated initial attitude '), 'Interpreter', 'none');
msplot(312, timeAxis_update, calc_init_att_stg(:, 2)*deg, 'ʱ�� /s', 'roll /deg');
msplot(313, timeAxis_update, calc_init_att_stg(:, 3)*deg, 'ʱ�� /s', 'yaw /deg');

msplot(111, timeAxis_update, calc_init_att_stg(:, 3)*deg, 'ʱ�� /s', 'yaw /deg');
% % ת̨��̬
% if size(DT, 2) == 17
% msplot(211, timeAxis_msr, attnorml(DT(:, 16), 'deg'), 'ʱ��/s', '�ڻ�λ�� /deg');
% title('ת̨��̬');
% msplot(212, timeAxis_msr, attnorml(DT(:, 17), 'deg'), 'ʱ��/s', '�⻷λ�� /deg');
% end
% 
% % ����λ�ü���̬
% msplot(211, timeAxis_update, calc_pos_stg(:, 1), 'ʱ�� /s ', 'γ�� /deg');
% title('�ߵ���������λ��');
% msplot(212, timeAxis_update, calc_pos_stg(:, 2), 'ʱ�� /s ', '���� /deg');
% 
msplot(311, timeAxis_update, calc_vn_stg(:, 1), 'ʱ�� /s', 've /m/s');
title('���ߵ������ٶ�');
msplot(312, timeAxis_update, calc_vn_stg(:, 2), 'ʱ�� /s', 'vn /m/s');
msplot(313, timeAxis_update, calc_vn_stg(:, 3), 'ʱ�� /s', 'vu /m/s');

% imu���
figure
subplot(321)
plot(timeAxis_msr, imu_msr.fb(:, 1));xlabel('ʱ�� /s');ylabel('fbx / m/s^2');
title('�Ӽ����')
subplot(323)
plot(timeAxis_msr, imu_msr.fb(:, 2));xlabel('ʱ�� /s');ylabel('fby / m/s^2');
subplot(325)
plot(timeAxis_msr, imu_msr.fb(:, 3));xlabel('ʱ�� /s');ylabel('fbz / m/s^2');
subplot(322)
plot(timeAxis_msr, imu_msr.wb(:, 1));xlabel('ʱ�� /s');ylabel('wx / rad/s');
title('�������');
subplot(324)
plot(timeAxis_msr, imu_msr.wb(:, 2));xlabel('ʱ�� /s');ylabel('wy / rad/s');
subplot(326)
plot(timeAxis_msr, imu_msr.wb(:, 3));xlabel('ʱ�� /s');ylabel('wz / rad/s');

%%
% ���ۺ��򾫶�
gyro_accuracy = 1e-3;   % deg/h
theoretical_azimuth_accuracy = gyro_accuracy/(15*cos(pos(1)))*deg;
%% ������
% cd('D:\result\N_201102\����2_�ֶ�׼�Ӿ���׼');
% saveas(1, strcat(data_name, '   esitmated attitude curve'), 'fig');
% saveas(2, strcat(data_name, '   esitmated initial attitude'), 'fig');
% cd('D:\inertial_navigation_basic');
