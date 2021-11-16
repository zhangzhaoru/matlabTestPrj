function [X,P]=ukf(ffun,X,P,hfun,Z,Q,R)
%������ϵͳ��UKF�㷨
L=numel(X);%״̬ά��
m=numel(Z);%�۲�ά��
alpha=1e-2;%Ĭ��ϵ�����ο�UT�任����ͬ
ki=0;%Ĭ��ϵ��
beta=2;%Ĭ��ϵ��
lambda=alpha^2*(L+ki)-L;%Ĭ��ϵ��
c=L+lambda;%Ĭ��ϵ��
Wm=[lambda/c 0.5/c+zeros(1,2*L)];%Ȩֵ
Wc=Wm;
Wc(1)=Wc(1)+(1-alpha^2+beta);%Ȩֵ
c=sqrt(c);
%��һ������ȡһ��sigma�㼯
%sigma�㼯����״̬X�����ĵ㼯��X��6*13����ÿ��Ϊ1����
Xsigmaset=sigmas(X,P,c);
%�ڶ����������Ĳ�����sigma�㼯����һ��Ԥ�⣬�õ���ֵXImeans�ͷ���P1����sigma�㼯X1
%��״̬UT�任
[X1means,X1,P1,X2]=ut(ffun,Xsigmaset,Wm,Wc,L,Q);

%���塢�������õ��۲�Ԥ�⣬Z1ΪX1���ϵ�Ԥ�⣬ZpreΪZ1�ľ�ֵ��
%PzzΪЭ����
[Zpre,Z1,Pzz,Z2]=ut(hfun,X1,Wm,Wc,m,R);%�Թ۲�UT�任
Pxz=X2*diag(Wc)*Z2';%Э����Pxz
%���߲������㿨��������
K=Pxz*inv(Pzz);
%�ڰ˲���״̬�ͷ������
X=X1means+K*(Z-Zpre);%״̬����
P=P1-K*Pxz';%Э�������
end

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

%����Sigma�㼯����
function Xset=sigmas(X,P,c)

[P1,p]= chol(P);
if p==0
    A = c*P1';%Cholesky�ֽ�
else
    P(find(isnan(P)==1))=0;
%     A = c*chol(P)';%Cholesky�ֽ�
    A = c*nearestPSD(P)';%Cholesky�ֽ�
end


Y = X(:,ones(1,numel(X)));
Xset = [X Y+A Y-A];
end


function flag = isPositiveDefinite(A)
[V,D]=eig(A);
flag = true;
for i=1:size(D,2)
    if D(i,i)<=0
        flag = false;
        break;
    end
end
end
