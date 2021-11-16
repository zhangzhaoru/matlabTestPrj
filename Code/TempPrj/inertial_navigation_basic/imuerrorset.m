function [ imuerr ] = imuerrorset( condition )
%% **************************************************************
%���ƣ�imu error
%���ܣ�����imu���
%________________________________________________________________________
% ���룺
%       condition: ��������
% �����
%       imuerr: imu����������ɵ�struct,������
%            eb: ������ƫ
%            web: �Ƕ��������
%            db: �Ӽ���ƫ
%            wdb: �ٶ��������
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��10��15��
% ************************************************************************
%%
gvar_earth;

% ��ʼ����Ĭ��imuerr.case = 'zero'
imuerr.case = 'zero';
imuerr.eb = [0, 0, 0]'*dph;
imuerr.web = [0, 0, 0]'*dpsh;
imuerr.db = [0, 0, 0]'*ug;
imuerr.wdb = [0, 0, 0]'*ugpsHz;

% �����û����õ�conditionѡ���Ӧ��imuerr���÷���
if exist('condition', 'var') 
    switch condition
        % *** selfdefine case ***
        case 'selfdefine'
            imuerr.case = 'selfdefine';
            imuerr.eb = [0.1, 0.1, 0.1]'*dph;
            imuerr.web = [0.1, 0.1, 0.1]'*dpsh;
            imuerr.db = [100, 100, 100]'*ug;
            imuerr.wdb = [1, 1, 1]'*ugpsHz;
            
        % *** specific case ***
        case '201029_1' 
            imuerr.case = '201029_1';
            imuerr.eb = [0.1, 0.1, 0.1]'*dph;
            imuerr.web = [0.1, 0.1, 0.1]'*dpsh;
            imuerr.db = [100, 100, 100]'*ug;
            imuerr.wdb = [1, 1, 1]'*ugpsHz;
            
        % *** big error
        case 'big'
            imuerr.case = 'big';
            imuerr.eb = [10, 10, 10]'*dph;
            imuerr.web = [1, 1, 1]'*dpsh;
            imuerr.db = [1000, 1000, 1000]'*ug;
            imuerr.wdb = [10, 10, 10]'*ugpsHz;
            
        % ** zero ***
        case 'zero'
            % do nothing
        
        % Yan @�����ߵ��㷨����ϵ���ԭ�� P239 ��ϵ��������е��������
        otherwise
            imuerr.case = 'Yan';
            imuerr.eb = [0.01, 0.015, 0.02]'*dph;
            imuerr.web = [0.001, 0.001, 0.001]'*dpsh;
            imuerr.db = [80, 90, 100]'*ug;
            imuerr.wdb = [1, 1, 1]'*ugpsHz;
    end
 
end

end
