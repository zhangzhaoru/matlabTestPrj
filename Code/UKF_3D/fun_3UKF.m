function [xk,Pk] = fun_3UKFfusion(xk,Pk,Fk,Gk,Zm,Qk,Rk, xp); 
%UKF Fusion
%%
zk=Zm(:,:); %measurement:rm bm em
% xkk=Fk*xk;
% Pkk=Fk*Pk*Fk'+Gk*Qk*Gk';
%UT transformation
alpha=0.01;
kk=0;
beta=2; 
n=6; %dimension of state x
lambda=alpha^2*(n+kk)-n;
Wm=[lambda/(lambda+n),  (0.5/(lambda+n))+zeros(1,2*n)];%权值确定
Wc=[lambda/(lambda+n)+1-alpha^2+beta,   (0.5/(lambda+n))+zeros(1,2*n)];
%产生xk的Sigma点
SPk=sqrt(n+lambda)*(chol(Pk))';
Xsigma0=xk;
for i=1:n 
    Xsigma1(:,i)=xk+SPk(:,i);
    Xsigma2(:,i)=xk-SPk(:,i); 
end
Xsigma=[Xsigma0,Xsigma1,Xsigma2];
%产生xkk的Gama点
for i=1:2*n+1
    Xgama(:,i)=Fk*Xsigma(:,i);
end
xkk=Xgama*Wm';
Pkk=zeros(6,6);for i=1:2*n+1; Pkk=Pkk+Wc(i)*((Xgama(:,i)-xkk)*(Xgama(:,i)-xkk)');end; 
Pkk=Pkk+Gk*Qk*Gk';

%产生xkk的Sigma点
SPkk=sqrt(n+lambda)*(chol(Pkk))';
Zsigma0=xkk;
for i=1:n 
    Zsigma1(:,i)=xkk+SPkk(:,i);
    Zsigma2(:,i)=xkk-SPkk(:,i);
end
Zsigma=[Zsigma0,Zsigma1,Zsigma2];
% zkk
for i=1:2*n+1
    [z1,z2,z3] = measurements(Zsigma(:,i), xp); Zgama(:,i)=[z1,z2,z3]';
end

zkk=Zgama*Wm';
Sk=zeros(3,3);for i=1:2*n+1; Sk=Sk+Wc(i)*((Zgama(:,i)-zkk)*(Zgama(:,i)-zkk)');end; 
Sk=Sk+Rk;
Ck=zeros(6,3);for i=1:2*n+1; Ck=Ck+Wc(i)*((Zsigma(:,i)-xkk)*(Zgama(:,i)-zkk)');end;
%
xk=xkk+Ck*inv(Sk)*(zk-zkk);
Pk=Pkk-Ck*inv(Sk)*Ck';










end