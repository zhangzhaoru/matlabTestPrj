%UT�任�Ӻ���
% ���룺funΪ���������XsigmaΪ��������Wm��WcΪȨֵ��nΪ״̬ά����n=6��,COVΪ����
% �����XmeansΪ��ֵ
function [Xmeans,Xsigma_pre,P,Xdiv]=ut(fun,Xsigma,Wm,Wc,n,COV)
LL=size(Xsigma,2);%�õ�Xsigma��������
Xmeans=zeros(n,1);%��ֵ
Xsigma_pre=zeros(n,LL);
for k=1:LL
    Xsigma_pre(:,k)=fun(Xsigma(:,k));%һ��Ԥ��
    Xmeans=Xmeans+Wm(k)*Xsigma_pre(:,k);
end
Xdiv=Xsigma_pre-Xmeans(:,ones(1,LL));%Ԥ���ȥ��ֵ
P=Xdiv*diag(Wc)*Xdiv'+COV;%Э����
end

