%% **************************************************************
%���ƣ�Opitiaml Based Alignment (GPS velocity aided) version 1.0
%���ܣ�
%________________________________________________________________________
% ��д�ĺ��壺
% msr: measurement; 
% ref: reference; ��ָ��ʵֵ
% sv: save; 
% prev: previous; ��Ӧ�������ϴν�����ֵ���ڱ��ν��㿪ʼʱ�̵�ֵ
% opt: optimal
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��10��14�� 
% ************************************************************************
%%
% ȫ�ֱ���
close all
gvar_earth;

% ** �������� **
% ���ݰ��� 
% 1. trajectory_ref.(pos, vn, att) 
% 2. imu.ref.(acc, gyr)
% �켣����������ɵ����ݣ�trajectory�ĳ��Ȼ��imu��1��trajectory�׸�����Ϊ
% t0ʱ�̵�avp_ref, imu�׸�����Ϊ����imu��t1ʱ�������(t0, t1]�ڽǶȺ���
% ��������
load('trj_and_imu.mat');

% ** �����������ص��� **
% imu���Ƶ�� (Hz)
f_imu = 100;
ts_imu = 1/f_imu;
% gps���Ƶ�� (Hz)
f_gps = f_imu;
ts_gps = 1/f_gps;
% �����ݳ��� (��)
num_imu_data = size(imu_ref.acc, 1);

% *** ��imu���������� ***
imuerr = imuerrorset('selfdefine');
% add imu error
[imu_msr.acc, imu_msr.gyr] = ...
                    imuadderr(imu_ref.acc, imu_ref.gyr, imuerr, ts_imu);

% ** ����ȫ�ֱ��� **
% ��һ��"����"����������Ӧ��ʱ���Լ���imu_ref��trajectory_ref�е�λ�� (s)
% ������Ϊ����ϵͳ���ڵ�start_time��������
start_time = 0;
first_data_index = round(start_time/ts_imu) + 1;
% ��׼ʱ�䳤�� (s)
total_alignment_time = 92;

% �����㷨������ (��)
num_subsample = 2;
nts = num_subsample*ts_imu;

% ��ʼλ�á��ٶȡ���̬
pos0 = trajectory_ref.pos(first_data_index, :)';
vn0 = trajectory_ref.vn(first_data_index, :)';
att0 = trajectory_ref.att(first_data_index, :)';

att0_ref = att0;
Cbn0_ref = a2mat(att0);
q0_ref = a2qua(att0);

% *** һЩ��������һʱ�̵�ֵ ***
% �ٶȡ�λ�á���̬ 
% Ŀǰ��û��׼���Գ�ʼʱ��ֵ������
pos_prev = pos0;
vn_prev = vn0;
att_prev = att0;

% eth����ߵ�������Ҫ�ı���������wien, winn�ȡ�
eth_prev = earth(pos_prev, vn_prev);

% btϵ��ntϵ��Թ��Կռ�仯��
Cntn0_prev = eye(3);
Cbtb0_prev = eye(3);
qbtb0 = [1, 0, 0, 0]';

% �ϴθ��¹����alpha��beta
alpha_prev = zeros(3, 1);
beta_prev = zeros(3, 1);
% alpha�г����ۼ����⻹����ʱ��仯�����˵�������alpha�е��ۼ�����ֵ��
% ��,�����ص�����һ������alpha���ۼ���ı�����
alpha_sigma = zeros(3, 1);
K_prev = zeros(4, 4);

% ���䶯̬�����洢�ռ�
phi_stg = zeros(round(total_alignment_time/ts_imu), 3);
phi0_stg = zeros(round(total_alignment_time/ts_imu), 3);

% ��������
% ��ǰʱ�� s
current = 0;
% ��ǰѭ��ʱ��i��ѭ��
i = 0;
% index
k = 0;
%%
% ���ǵ��ռ�Ŀ�������㷨�ܹ���ʵ�������У�ʵ�����������������ģ�
% 1. t=0���ߵ�����
% 2. t=ts_imu��imu�ڴ�ʱ�����һ���ٶ�����vm(1)�ͽ�����wm(1)
% 3. t=nts,imu���������ִ��һ�ιߵ���������Ҫ�����������������������ִ��
%    �ߵ����³�������������p(t),vn(t),att(t)
% 4. ��������������ȴ�imu���n�������Ϣ�ٽ��йߵ�����
while current < total_alignment_time  
    % ÿ��nts�룬imu�ͻ������num_subsample��������������㹻imu�������
    % ����currentʱ�̣���ƣ���ǰʱ�̣����е�������
    current = current + nts;
    
    % ��ǰʱ��(current)��trajectory_ref�ж�Ӧ�����ݱ��
    k = round(current/ts_imu) + first_data_index;
    % �ߵ�����ѭ������
    i = i+1;
    
    % currentʱ�̣������λ�á��ٶȡ���̬�ο�ֵ
    pos_ref = trajectory_ref.pos(k, :)';
    vn_ref = trajectory_ref.vn(k, :)';
    att_ref = trajectory_ref.att(k, :)';
    qbn_ref = a2qua(att_ref);
    
    % �òο��ٶ�ģ�⵱ǰʱ��GPS�ٶ�,����λ����Ϣ��ʱ�������
    vn_gps = vn_ref + 0.*randn(3, 1);
    pos_gps = pos_ref;
    
    vn_gps_stg(i, :) = vn_gps;
    % ��gps������ٶ���Ϊ��ϵ���ϵͳ�������ٶ�
    vn = vn_gps;
    pos = pos_gps;
    
    % ��imu_ref�ж���(current - nts, current]���ʱ����imu�����n��������Ϣ
    wm = imu_msr.gyr(k-num_subsample+1 : k, :);
    vm = imu_msr.acc(k-num_subsample+1 : k, :);
    
    wm_stg(2*i-1:2*i, :) = wm;
    vm_stg(2*i-1:2*i, :) = vm;
    % ����Բ׶/�������
    [phim, dvbm] = cnscl(wm, vm);
    
    % ����Cbtb0��Cntn0
    % ��winn(tm-1)����Cntmntm-1
    Cntn0 = Cntn0_prev*rv2m(eth_prev.winn*nts);
    % �þ��������õ���(current - nts, current]���ʱ���ڵĽ�������Cbtb0
    % Cbtb0 = Cbtb0_prev*rv2m(phim);
    qbtb0 = qmul(qbtb0, rv2q(phim));
    qbtb0 = qnormlz(qbtb0);
    Cbtb0 = q2mat(qbtb0);
    
    % *** ����alpha(n0)��beta(b0) ***
    % alpha(n0)
    % 1. Ŀǰ��vn0_ref����alpha, ��ʱ�����ǻ������ڡ�
    % 2. ��gps�����λ�ü���wien��gn
    alpha_sigma = alpha_sigma + ... 
                  Cntn0_prev*(cross(eth_prev.wien, vn_prev) - eth_prev.gn)*nts;
    alpha = Cntn0*vn - vn0 + alpha_sigma;
    % beta(b0)
    beta = beta_prev + Cbtb0_prev*dvbm;
    
    % QUEST ��������qbn0
    [ qbn0, K ] = QUEST( beta, alpha, K_prev );
    
    % ��̬����
    Cbn0 = q2mat(qbn0);
    Cbn = Cntn0'*Cbn0*Cbtb0;
    att = m2att(Cbn);
    phi0_stg(i, :) = attnorml(q2att(qbn0) - att0_ref)*deg;
    phi_stg(i, :) = attnorml(att - att_ref)*deg;
    
    % ���㵼������ʱ����Ҫ����ز���
    eth = earth(pos, vn);
    
    % �����θ��º�ĵ���������Ϊ�´θ��³�ֵ
    pos_prev = pos;
    vn_prev = vn;
    att_prev = att;
    eth_prev = eth;
    Cntn0_prev = Cntn0;
    Cbtb0_prev = Cbtb0;
    alpha_prev = alpha;
    beta_prev = beta;
    K_prev = K;
    
end

% ע�⣺���endǰ����˿ո�ͻ����!
phi_stg(i+1:end, :) = [];
phi0_stg(i+1:end, :) = [];
%% ��ͼ
time_axis = (1:1:i)*nts;
time_axis_imu = (1:1:2*i)*ts_imu;

% Cbn���
msplot(311, time_axis, phi_stg(:, 1), 'pitch error / \circ');
msplot(312, time_axis, phi_stg(:, 2), 'roll error / \circ');
msplot(313, time_axis, phi_stg(:, 3), 'yaw error / \circ');

%Cbn0 ���
msplot(311, time_axis, phi0_stg(:, 1), 'pitch error / \circ');
msplot(312, time_axis, phi0_stg(:, 2), 'roll error / \circ');
msplot(313, time_axis, phi0_stg(:, 3), 'yaw error / \circ');

%imu���
msplot(311, time_axis_imu, wm_stg(:, 1), 'wibbx / rad/s');
msplot(312, time_axis_imu, wm_stg(:, 2), 'wibby / rad/s');
msplot(313, time_axis_imu, wm_stg(:, 3), 'wibbz / rad/s');

%imu���
msplot(311, time_axis_imu, vm_stg(:, 1), 'fbx / m/s^2');
msplot(312, time_axis_imu, vm_stg(:, 2), 'fby / m/s^2');
msplot(313, time_axis_imu, vm_stg(:, 3), 'fbz / m/s^2');
