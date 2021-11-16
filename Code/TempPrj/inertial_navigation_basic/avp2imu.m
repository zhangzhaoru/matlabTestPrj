function [ wm, vm ] = avp2imu( att, vn, pos, ts )
%% **************************************************************
%���ƣ�using Attitude & Velocity inverse the IMU output  %%%(Practice version)
%���ܣ���������imu�������  ��ȫû�иĶ��İ汾
%________________________________________________________________________
% ���룺
%       att: pitch, roll, yaw   (rad)
%       vn: vE, vN, vU          (m/s)
%       pos: latitude, longitude, high       (deg, deg, m)
%       ts: step time 
% �����
%       wm: ������
%       vm: �ٶ�����
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��9��28��
% ************************************************************************
%%
wm0 = zeros(3, 1);
vm0 = zeros(3, 1);
I33 = eye(3); 

wm = att(2:end, :);
vm = att(2:end, :);

for k = 2 : length(att)
    
    % ��vn��p������򵼺�����
    eth = earth((pos(k-1,:) + pos(k, :))/2, (vn(k-1, :) + vn(k, :))/2);
    
    qbb = qmul( qmul( qconj( a2qua(att(k-1, :) ) ), rv2q(eth.winn*ts)), a2qua(att(k, :) ) );
    phim = q2rv(qbb);
    
    % Note: matlabִ�г���A/Bʱ,ʵ���ϻ���о��������A*inv(B), (A,BΪ����
    % ʱҲ������)��ͨ������˷� A*B �� B*A, ��˾��������Ϊ"���"��
    % "�ҳ�"����:A/B = A*inv(B), A\B = inv(A)*B
    wm1 = (I33 + skew(1/12*wm0))\phim;
    
    dvnsf = vn(k, :)' - vn(k-1, :)' - eth.gcc*ts;
    Cbn0 = a2mat(att(k-1, :)');
    
    vm1 = (I33 + 1/2*skew(1/6*wm0 + wm1))\...
        (Cbn0'*(I33 + skew(eth.winn*ts/2))*dvnsf - 1/12*cross(vm0, wm1));
    
    wm(k-1, :) = wm1';
    vm(k-1, :) = vm1;
    wm0 = wm1;
    vm0 = vm1;
    
end
