function [ vm, wm ] = imuadderr( vm, wm, imuerr, ts )
%% **************************************************************
%���ƣ�imu add error
%���ܣ�����ʵimu��������ģ��ʵ���д�������������imu�����
%����@ �����ߵ��㷨����ϵ���ԭ�� P235
%________________________________________________________________________
% ���룺
%       wm: n��3 ����ÿһ�ж�Ӧһ����������[theta_x, theta_y, theta_z] rad
%       vm: n��3 ����ÿһ�ж�Ӧһ���ٶ����� m/s
%       ע�⣡wm��vm��������У����һ���Ƕ�Ӧ��ʱ��
%       eb: �����ǳ�ֵƯ�ƣ���������ƫ
%       web:�Ƕ�����������
%       db: ���ٶȼƳ�ֵƫ��
%       wdb: �ٶ�����������
%       ts: ���� s
% �����
%       wm: ��������Ľ�����
%       vm: ����������ٶ�����
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��10��7��
% ************************************************************************
%%
% ��������
[m, n] = size(wm);

% ���������Ϣ����ts����Ϊimu��Ϣ��������Ϣ��������Ϊ���ٶ���Ϣ
if exist('ts', 'var')
    condition = 'increment';
else
    condition = 'velocity';
end

switch condition
    % ** imu���Ϊ������ʽ **
    case 'increment'
        % ������ƽ��
        sts = sqrt(ts);
        
        wm(:, 1:3) = wm(:, 1:3) + ...
            [ts*imuerr.eb(1) + sts*imuerr.web(1)*randn(m, 1), ...
             ts*imuerr.eb(2) + sts*imuerr.web(2)*randn(m, 1), ...
             ts*imuerr.eb(3) + sts*imuerr.web(3)*randn(m, 1)];
        
        vm(:, 1:3) = vm(:, 1:3) + ...
            [ts*imuerr.db(1) + sts*imuerr.wdb(1)*randn(m, 1), ...
             ts*imuerr.db(2) + sts*imuerr.wdb(2)*randn(m, 1), ...
             ts*imuerr.db(3) + sts*imuerr.wdb(3)*randn(m, 1)];
       
    % ** imu���Ϊ�����ͽ��ٶ� **    
    case 'velocity'
        wm(:, 1:3) = wm(:, 1:3) + ...
            [imuerr.eb(1) + imuerr.web(1)*randn(m, 1), ...
             imuerr.eb(2) + imuerr.web(2)*randn(m, 1), ...
             imuerr.eb(3) + imuerr.web(3)*randn(m, 1)];
        
        vm(:, 1:3) = vm(:, 1:3) + ...
            [imuerr.db(1) + imuerr.wdb(1)*randn(m, 1), ...
             imuerr.db(2) + imuerr.wdb(2)*randn(m, 1), ...
             imuerr.db(3) + imuerr.wdb(3)*randn(m, 1)];
end
end
