%����Sigma�㼯����
function Xset=sigmas(X,P,c)
A = c*chol(P)';%Cholesky�ֽ�
Y = X(:,ones(1,numel(X)));
Xset = [X Y+A Y-A];
end