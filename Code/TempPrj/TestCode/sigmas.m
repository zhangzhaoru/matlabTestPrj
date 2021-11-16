%产生Sigma点集函数
function Xset=sigmas(X,P,c)
A = c*chol(P)';%Cholesky分解
Y = X(:,ones(1,numel(X)));
Xset = [X Y+A Y-A];
end