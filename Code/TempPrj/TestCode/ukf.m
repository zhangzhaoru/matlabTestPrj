function [X,P]=ukf(ffun,X,P,hfun,Z,Q,R)
%非线性系统中UKF算法
L=numel(X);%状态维数
m=numel(Z);%观测维数
alpha=1e-2;%默认系数，参看UT变换，下同
ki=0;%默认系数
beta=2;%默认系数
lambda=alpha^2*(L+ki)-L;%默认系数
c=L+lambda;%默认系数
Wm=[lambda/c 0.5/c+zeros(1,2*L)];%权值
Wc=Wm;
Wc(1)=Wc(1)+(1-alpha^2+beta);%权值
c=sqrt(c);
%第一步，获取一组sigma点集
%sigma点集，在状态X附近的点集，X是6*13矩阵，每列为1样本
Xsigmaset=sigmas(X,P,c);
%第二、第三、四步，对sigma点集进行一步预测，得到均值XImeans和方差P1和新sigma点集X1
%对状态UT变换
[X1means,X1,P1,X2]=ut(ffun,Xsigmaset,Wm,Wc,L,Q);

%第五、六步，得到观测预测，Z1为X1集合的预测，Zpre为Z1的均值。
%Pzz为协方差
[Zpre,Z1,Pzz,Z2]=ut(hfun,X1,Wm,Wc,m,R);%对观测UT变换
Pxz=X2*diag(Wc)*Z2';%协方差Pxz
%第七步，计算卡尔曼增益
K=Pxz*inv(Pzz);
%第八步，状态和方差更新
X=X1means+K*(Z-Zpre);%状态更新
P=P1-K*Pxz';%协方差更新
end

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

%产生Sigma点集函数
function Xset=sigmas(X,P,c)

[P1,p]= chol(P);
if p==0
    A = c*P1';%Cholesky分解
else
    P(find(isnan(P)==1))=0;
%     A = c*chol(P)';%Cholesky分解
    A = c*nearestPSD(P)';%Cholesky分解
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
