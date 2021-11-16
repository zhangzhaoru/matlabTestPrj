function [ qbn ] = qnormlz( qbn )
%% **************************************************************
%名称：Quaternion Normlization
%功能：将四元数标准化
%________________________________________________________________________
% 输入：
%       qbn: 未标准化四元数
% 输出：
%       qbn: 标准化过后的四元数
%_________________________________________________________________________
%作者：哈尔滨工程大学 自动化学院 张峥
%日期：2020年10月2日
% ************************************************************************
%%
% 输入四元数的模方
nm2 = qbn'*qbn;

if nm2 < 1e-6
    qbn = [1, 0, 0, 0]';
else
    qbn = qbn/sqrt(nm2);
end

end
