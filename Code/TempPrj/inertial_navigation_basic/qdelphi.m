function [ qbn ] = qdelphi( qbp, phi )
%% **************************************************************
%���ƣ�Quaternion DELate PHI
%���ܣ���Ԫ����ʧ׼���������Ӻ���������̬��Ԫ�����޳����Ի����ֵ��
%________________________________________________________________________
% ��Ϊ����n'����ʾ���㵼������ϵ���ڹ��ɾ���ı�ʾ�����в������壬�����p��
% ����n'ϵ��
% ���룺
%       qbp: ��bϵ�����㵼��ϵ����̬��Ԫ����
%       phi: ��nϵ��pϵ���ת������Ӧ�ĵ�Ч��תʸ��
%       @ �����ߵ��㷨����ϵ���ԭ�� P234 ԭ�ģ�����ʵ����ϵn�����㵼��ϵp��
%         ��ʧ׼��Ϊphi����֮����pϵ��nϵ��ʧ׼��Ϊ-phi������-phi��Ϊ��Ч��
%         תʸ�����������Ӧ�ı任��Ԫ��ΪQnp��
%         �����˵�����н�ʧ׼��(312 ŷ����)��Ϊ��Ч��תʸ����
% �����
%       qbn: ��bϵ����ʵ����ϵ����̬��Ԫ��
%_________________________________________________________________________
%���ߣ����������̴�ѧ �Զ���ѧԺ ���
%���ڣ�2020��10��3��
% ************************************************************************
%%
qbn = qmul(rv2q(phi), qbp);

end
