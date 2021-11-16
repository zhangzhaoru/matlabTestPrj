%���ܣ��켣ģ��������
%����@ �����ߵ�ϵͳ����ϵ���ԭ�� P229
%________________________________________________________________________
% �������ò�����Ľ����
% avp.(pos, vn, att): λ�á��ٶȡ���̬�ο�ֵ
% imu.(wb, fb): ���������ٶ�����
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��10��7��
% ************************************************************************
%%  �켣����
% ���ñ�������ʱ���ļ���
data_folder = 'D:\data\simulate_data\2020��12��';
data_name = 'simulation_data_2020��12��10��_1';

% ����ȫ�ֱ���
gvar_earth;
% imu�������֮���ʱ����
ts = 0.01;

% ��ʼ��̬���ٶȡ�λ��
att0 = [1, 1, 30]'*arcdeg;
vn0 = [0, 0, 0]';
pos0 = [34*arcdeg, 108*arcdeg, 100]';

% Ԥ��켣
wat = developing_wat_select( '20201210' );

% ����deg/s��ʾ�Ľ��ٶ�ת����rad/s
wat(:, 1:3) = wat(:, 1:3)*pi/180;

[avp.att, avp.vn, avp.pos] = trjprofile(att0, vn0, pos0, wat, ts);
% �����õ�avp2imu��Ϊ���ϵ�av2imu���� @P229
[imu.tb, imu.vb] = avp2imu(avp.att, avp.vn, avp.pos, ts);

% ��imu������"����" t=0ʱ��imu���,��(-ts,0]���ʱ���ڵĽ��������ٶ�������
% ������ʹ��imu��avpӵ����ͬ�ĳ��ȣ��������ݵĵ��á�
imu.tb = [[0, 0, 0]; imu.tb];
imu.vb = [[0, 0, 0]; imu.vb];

%%  ��ͼ
tt = (0 : length(avp.att)-1)'*ts;

msplot(221, tt, avp.att/arcdeg, 'Att/(\circ)');
legend('\it\theta', '\it\gamma', '\it\psi')

msplot(222, tt, avp.vn, 'Vel /m.s^{-1}');
legend('\itv\rm_E', '\itv\rm_N', 'itv\rm_U')

msplot(223, tt, deltapos(avp.pos), '\DeltaPos /m');
legend('\Delta\itL', '\Delta\it\lambda', '\Delta\ith')

% �����Ǿ��ȣ�������γ��
msplot(224, avp.pos(:, 2)/arcdeg, avp.pos(:, 1)/arcdeg, ...
    '\it\lambda\rm /(\circ)', '\itL\rm /(\circ)');    hold on
plot(avp.pos(1,2)/arcdeg, avp.pos(1, 1)/arcdeg, 'ro');

% imu�����Ϣ��ͼ
msplot(121, tt, imu.tb/ts/arcdeg, ...
    '\it\omega^b_{ib}\rm /(circ.s^{-1})');
legend('\it\omega^b_{ibx}', '\it\omega^b_{iby}', '\it\omega^b_{ibz}');

msplot(122, tt, imu.vb/ts, '\itf^b\rm_{sf}/(m.s^{-2})');
legend('\itf^b\rm_{sf\itx}', '\itf^b\rm_{sf\ity}', '\itf^b\rm_{sf\itz}');

%% ��������
dataInfo.name = data_name;
dataInfo.description = 'Long time random trajectory';
dataInfo.date = datestr(now);
dataInfo.type = 'simulation data';
dataInfo.ts = ts;
dataInfo.length = length(avp.pos);
dataInfo.imuerr = 'Only reference data';

cd(data_folder);
save(data_name, 'avp', 'imu', 'dataInfo');
cd('D:\inertial_navigation_basic');

clearvars -except avp imu dataInfo