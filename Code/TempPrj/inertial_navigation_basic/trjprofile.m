% �ɵ������̬�ٶȳ�ʼλ�����ɹ켣
function [ att, vn, pos ] = trjprofile( att0, vn0, pos0, wat, ts )
%% **************************************************************
%���ƣ�Trajectory Profile           %%% (Practice version)
% Practice version 0.1 ��ȫ�����Ϲ�����ʦ���ϸ��Ƶİ汾
% ��������ʱ�ϽǱ���ǰ
%���ܣ�����һ��켣
%________________________________________________________________________
% ���룺
%       att0�� vn0, pos0: ��̬���ٶȡ�λ�ó�ֵ�� 3��1 vector

%       wat:  w(omega) , a(accelerometer velocity), t(time) 
%       wat - 1:3 : pitch velocity, roll velocity, yaw velocity
%       wat - 4 : forward velocity  (Ĭ�Ϲ��ǺͲ໬��Ϊ0)
%       wat - 5 : timestamp

%       ts: ���� s
% �����
%       att: len��3 metrix 
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��9��28��
% ************************************************************************
%%
% ���ɵ�ʱ������Ŀ
len = fix(sum(wat(:, 5)/ts));

% Ԥ����洢�ռ�
att = zeros(len, 3);
vn = zeros(len, 3);
pos = zeros(len, 3);

% ��������
kk = 1;

% �����ֵ No.1 
att(1, :) = att0';
vn(1, :) = vn0';
pos(1, :) = pos0';

% ���㵼��ϵ�µ��ٶ�
vb = a2mat(att0)'*vn0;     % #ԭ��  & Cbn = a2mat(att)
% att  = euler2dcm(att0)'; % # myself

% ����(ǰ��)�ٶȴ�С
vby = vb(2);

%% ��ͨ�˲���
% firl : �����˲���
% @ �����ߵ��㷨����ϵ���ԭ�� P228
% �ֶ����÷��ж���ʱ�����ڽ׶ε��������֮�������ϴ��̨�������䣬ʹ�ù�
% ���⻬�Բ��ã�һ�ּ򵥵Ľ���취�ǣ������ŷ���ǡ��ٶȡ�λ�õĵ���ǰ��ͬʱ
% ��ŷ��������������ϵ�ٶ�vb��FIR��ͨ�˲��������������������켣�Ĺ⻬�ԡ�
b = fir1(20, 0.01, 'low');
b = b/sum(b);

% repmat: ��һ��������m*n�ݣ��������ƹ���Ľ��ƴ��һ������
x = repmat([att0; vby]', length(b), 1);

%%
for m = 1 : size(wat, 1)      % m���ӹ켣����Ŀ
    watk = wat(m, :);
    
    for tk = ts : ts : (watk(5)+ts/10)
        % update attitude and forward velocity 
        att0 = att0 + watk(1:3)'*ts;
        vby = vby + watk(4)*ts;
       
        % lowpass filter
        x = [x(2:end, :); [att0; vby]'];
        y = b*x;
        
        att(kk+1, :) = y(1:3);
        vn(kk+1, :) = (a2mat(att(kk+1, :)')*[0; y(4); 0])';
        vn01 = (vn(kk, :) + vn(kk+1, :))/2;
        
        % ���򵼺���������
        eth = earth(pos(kk, :)', vn01');
       
        % update position
        pos(kk+1, :) = pos(kk, :) + ...
                        [vn01(2)/eth.RMh; vn01(1)/eth.clRNh; vn01(3)]'*ts;
        
        kk = kk+1;
    end
    
end

att(kk:end, :) = [];
vn(kk:end, :) = [];
pos(kk:end, :) = [];
end