% 由弹体的姿态速度初始位置生成轨迹
function [ att, vn, pos ] = trjprofile( att0, vn0, pos0, wat, ts )
%% **************************************************************
%名称：Trajectory Profile           %%% (Practice version)
% Practice version 0.1 完全按照严恭敏老师书上复制的版本
% 变量命名时上角标在前
%功能：生成一组轨迹
%________________________________________________________________________
% 输入：
%       att0， vn0, pos0: 姿态、速度、位置初值， 3×1 vector

%       wat:  w(omega) , a(accelerometer velocity), t(time) 
%       wat - 1:3 : pitch velocity, roll velocity, yaw velocity
%       wat - 4 : forward velocity  (默认攻角和侧滑角为0)
%       wat - 5 : timestamp

%       ts: 步长 s
% 输出：
%       att: len×3 metrix 
%_________________________________________________________________________
%作者：哈尔滨工程大学 自动化学院 张峥
%日期：2020年9月28日
% ************************************************************************
%%
% 生成的时刻总数目
len = fix(sum(wat(:, 5)/ts));

% 预分配存储空间
att = zeros(len, 3);
vn = zeros(len, 3);
pos = zeros(len, 3);

% 计数变量
kk = 1;

% 保存初值 No.1 
att(1, :) = att0';
vn(1, :) = vn0';
pos(1, :) = pos0';

% 计算导航系下的速度
vb = a2mat(att0)'*vn0;     % #原文  & Cbn = a2mat(att)
% att  = euler2dcm(att0)'; % # myself

% 纵向(前向)速度大小
vby = vb(2);

%% 低通滤波器
% firl : 数字滤波器
% @ 捷联惯导算法与组合导航原理 P228
% 分段设置飞行动作时，相邻阶段的输入参数之间会产生较大的台阶性跳变，使得轨
% 迹光滑性不好，一种简单的解决办法是：在求解欧拉角、速度、位置的导数前先同时
% 对欧拉角向量和载体系速度vb做FIR低通滤波处理，这有利于提升轨迹的光滑性。
b = fir1(20, 0.01, 'low');
b = b/sum(b);

% repmat: 将一个矩阵复制m*n份，并将复制过后的结果拼成一个矩阵
x = repmat([att0; vby]', length(b), 1);

%%
for m = 1 : size(wat, 1)      % m：子轨迹的数目
    watk = wat(m, :);
    
    for tk = ts : ts : (watk(5)+ts/10)
        % update attitude and forward velocity 
        att0 = att0 + watk(1:3)'*ts;
        vby = vby + watk(4)*ts;
       
        % lowpass filter
        x = [x(2:end, :); [att0; vby]'];
        y = b*x;
        
        att(kk+1, :) = y(1:3);
        vn(kk+1, :) = (a2mat(att(kk+1, :)')*[0; y(4); 0])';
        vn01 = (vn(kk, :) + vn(kk+1, :))/2;
        
        % 地球导航参数解算
        eth = earth(pos(kk, :)', vn01');
       
        % update position
        pos(kk+1, :) = pos(kk, :) + ...
                        [vn01(2)/eth.RMh; vn01(1)/eth.clRNh; vn01(3)]'*ts;
        
        kk = kk+1;
    end
    
end

att(kk:end, :) = [];
vn(kk:end, :) = [];
pos(kk:end, :) = [];
end
