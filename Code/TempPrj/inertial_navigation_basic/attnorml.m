function [ att_normalized ] = attnorml( att, condition )
%% **************************************************************
%���ƣ�Attitude Normalization (version 1.0)
%���ܣ���̬�Ǳ�׼�� (Ŀǰ��������������)
%________________________________________________________________________
% ���룺
%       att: δ��׼������̬�����
% �����
%       att_normalized: ��׼���������̬�����
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��10��14��
% ************************************************************************
%%
threshold = pi;

% ����������ݵ�λ��deg
if exist('condition', 'var') && strcmp(condition, 'deg')
    threshold = 180;
end


if length(att) ==3
    % ������̬��������������Ϊ������ͨ����̬��
    % �ֱ���ȡ������̬�����
    thresholdtch_err = att(1);
    roll_err = att(2);
    yaw_err = att(3);
    
    % thresholdtch �Ƕȷ�ΧΪ: [-threshold/2, threshold/2]
    % roll �Ƕȷ�ΧΪ: (-threshold, threshold]
    % yaw �Ƕȷ�ΧΪ: [0, 2*threshold)
    
    % ֱ�Ӽ�����ĺ��������(-2*threshold, 2*threshold),������ϣ�������
    % ����(-threshold, threshold]����������������ֵ����threshold��
    % �������׼��
    if norm(yaw_err) > threshold
        % �����������Ϊ��
        if sign(yaw_err) == 1
            yaw_err = yaw_err - 2*threshold;
        else
            % �����������threshold���ҷ���Ϊ��
            yaw_err = yaw_err + 2*threshold;
        end
    end    
    att_normalized = [thresholdtch_err, roll_err, yaw_err]';
    
else
    % ��Ϊ���������һ����̬����
    k = 0;
    while k < length(att)
        % ����ѭ�������+1
        k = k+1;
        
        if norm(att(k)) > threshold
            % �����������Ϊ��
            if sign(att(k)) == 1
                att(k) = att(k) - 2*threshold;
            else
                % �����������threshold���ҷ���Ϊ��
                att(k) = att(k) + 2*threshold;
            end
        end
       
    end
    att_normalized = att;
end
end
