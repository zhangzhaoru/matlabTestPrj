%  kalman滤波用户检测视频中的目标，并对目标跟踪
function kalman_for_vedio_tracking
clear,clc
% 计算图像背景
Imzero = zeros(240,320,3);
for i = 1:5
Im{i} = double(imread(['DATA/',int2str(i),'.jpg']));
Imzero = Im{i}+Imzero;
end
Imback = Imzero/5;
[MR,MC,Dim] = size(Imback);

% Kalman 滤波器初始化
R=[[0.2845,0.0045]',[0.0045,0.0455]'];
H=[[1,0]',[0,1]',[0,0]',[0,0]'];
Q=0.01*eye(4);
P = 100*eye(4);
dt=1;  % 采样时间，也就是图像帧时间
A=[[1,0,0,0]',[0,1,0,0]',[dt,0,1,0]',[0,dt,0,1]'];
g = 6; % pixels^2/time step
Bu = [0,0,0,g]';
kfinit=0;           % kalman增益初始化
x=zeros(100,4);     % 目标状态初始化

% 检测视频中每一帧图像
for i = 1 : 60
  % 读取图像
  Im = (imread(['DATA/',int2str(i), '.jpg'])); 
  imshow(Im)
  imshow(Im)
  Imwork = double(Im);

  % 检测目标（目标是一个球）
  [cc(i),cr(i),radius,flag] = extractball(Imwork,Imback,i);
  if flag==0
    continue
  end

  hold on
    for c = -1*radius: radius/20 : 1*radius
      r = sqrt(radius^2-c^2);
      plot(cc(i)+c,cr(i)+r,'g.')
      plot(cc(i)+c,cr(i)-r,'g.')
    end
  % Kalman update
i
  if kfinit==0
    xp = [MC/2,MR/2,0,0]'
  else
    xp=A*x(i-1,:)' + Bu
  end
  kfinit=1;
  PP = A*P*A' + Q
  K = PP*H'*inv(H*PP*H'+R)
  x(i,:) = (xp + K*([cc(i),cr(i)]' - H*xp))';
  x(i,:)
  [cc(i),cr(i)]
  P = (eye(4)-K*H)*PP

  hold on
    for c = -1*radius: radius/20 : 1*radius
      r = sqrt(radius^2-c^2);
      plot(x(i,1)+c,x(i,2)+r,'r.')
      plot(x(i,1)+c,x(i,2)-r,'r.')
    end
      pause(0.3)
end

% show positions
  figure
  plot(cc,'r*')
  hold on
  plot(cr,'g*')
%end

%estimate image noise (R) from stationary ball
  posn = [cc(55:60)',cr(55:60)'];
  mp = mean(posn);
  diffp = posn - ones(6,1)*mp;
  Rnew = (diffp'*diffp)/5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 提取目标区域的中心和能包含目标的最大半径
function [cc,cr,radius,flag]=extractball(Imwork,Imback,index)
cc = 0;
cr = 0;
radius = 0;
flag = 0;
[MR,MC,Dim] = size(Imback);
fore = zeros(MR,MC);          
fore = (abs(Imwork(:,:,1)-Imback(:,:,1)) > 10) ...
    | (abs(Imwork(:,:,2) - Imback(:,:,2)) > 10) ...
    | (abs(Imwork(:,:,3) - Imback(:,:,3)) > 10);
foremm = bwmorph(fore,'erode',2);
labeled = bwlabel(foremm,4);
stats = regionprops(labeled,['basic']);
[N,W] = size(stats);
if N < 1
    return
end
id = zeros(N);
for i = 1 : N
    id(i) = i;
end
for i = 1 : N-1
    for j = i+1 : N
        if stats(i).Area < stats(j).Area
            tmp = stats(i);
            stats(i) = stats(j);
            stats(j) = tmp;
            tmp = id(i);
            id(i) = id(j);
            id(j) = tmp;
        end
    end
end
if stats(1).Area < 100
    return
end
selected = (labeled==id(1));
centroid = stats(1).Centroid;
radius = sqrt(stats(1).Area/pi);
cc = centroid(1);
cr = centroid(2);
flag = 1;
return
