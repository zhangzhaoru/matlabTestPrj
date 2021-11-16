%UT变换子函数
% 输入：fun为函数句柄，Xsigma为样本集，Wm和Wc为权值，n为状态维数（n=6）,COV为方差
% 输出：Xmeans为均值
function [Xmeans,Xsigma_pre,P,Xdiv]=ut(fun,Xsigma,Wm,Wc,n,COV)
LL=size(Xsigma,2);%得到Xsigma样本个数
Xmeans=zeros(n,1);%均值
Xsigma_pre=zeros(n,LL);
for k=1:LL
    Xsigma_pre(:,k)=fun(Xsigma(:,k));%一步预测
    Xmeans=Xmeans+Wm(k)*Xsigma_pre(:,k);
end
Xdiv=Xsigma_pre-Xmeans(:,ones(1,LL));%预测减去均值
P=Xdiv*diag(Wc)*Xdiv'+COV;%协方差
end

