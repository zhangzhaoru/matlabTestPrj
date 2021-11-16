%3维比例导引律
% 生成弹体轨迹数据
clear all
clc
clear
tt=0.1;
% 帧周期
sm=0.6*tt;
st=0.42*tt;
x(1)=0;y(1)=0;z(1)=0;
pmr(:,1)=[x(1);y(1);z(1)];%导弹起始位置
ptr(:,1)=[25;5;10];%目标起始位置
m=3;%比例导引系数
q(1)=0;
o(1)=0;
a(1)=0;
for(k=2:600)
    ptr(:,k)=[25-0.42*cos(pi/6)*tt*k;5;10+0.42*sin(pi/6)*k*tt];
    r(k-1)=sqrt((ptr(1,k-1)-pmr(1,k-1))^2+(ptr(2,k-1)-pmr(2,k-1))^2+(ptr(3,k-1)-pmr(3,k-1))^2); %目标和导弹相对距离
    c=sqrt((ptr(1,k)-pmr(1,k-1))^2+(ptr(2,k)-pmr(2,k-1))^2+(ptr(3,k)-pmr(3,k-1))^2);
    b=acos((r(k-1)^2+st^2-c^2)/(2*r(k-1)*st));
    dq=acos((r(k-1)^2-st^2+c^2)/(2*r(k-1)*c));
    if abs(imag(b))>0
        b=0.0000001;
    end
    if abs(imag(dq))>0
        dq=0.0000001;
    end
    q(k)=q(k-1)+dq;
    o(k)=o(k-1)+m*dq;
    a(k)=o(k)-q(k);
    c1=r(k-1)*sin(b)/sin(a(k)+b);
    c2=r(k-1)*sin(a(k))/sin(a(k)+b);
    c3=sqrt((c1-sm)^2+(c2-st)^2+2*(c1-sm)*(c2-st)*cos(a(k)+b));
    dq=a(k)-acos(((c1-sm)^2+c3^2-(c2-st)^2)/(2*(c1-sm)*c3));
    if abs(imag(dq))>0
        dq=0.0000001;
    end
    q(k)=q(k-1)+dq;
    o(k)=o(k-1)+m*dq;
    a(k)=o(k)-q(k);
    c1=r(k-1)*sin(b)/sin(a(k)+b);
    c2=r(k-1)*sin(a(k))/sin(a(k)+b);
    c3=sqrt((c1-sm)^2+(c2-st)^2+2*(c1-sm)*(c2-st)*cos(a(k)+b));
    dq=a(k)-acos(((c1-sm)^2+c3^2-(c2-st)^2)/(2*(c1-sm)*c3));
    if abs(imag(dq))>0
        dq=0.0000001;
    end
    q(k)=q(k-1)+dq;
    o(k)=o(k-1)+m*dq;
    a(k)=o(k)-q(k);
    c1=r(k-1)*sin(b)/sin(a(k)+b);
    c2=r(k-1)*sin(a(k))/sin(a(k)+b);
    c3=sqrt((c1-sm)^2+(c2-st)^2+2*(c1-sm)*(c2-st)*cos(a(k)+b));
    x1(k)=ptr(1,k-1)+c2/st*(ptr(1,k)-ptr(1,k-1));
    y1(k)=ptr(2,k-1)+c2/st*(ptr(2,k)-ptr(2,k-1));
    z1(k)=ptr(3,k-1)+c2/st*(ptr(3,k)-ptr(3,k-1));
    x(k)=pmr(1,k-1)+sm/c1*(x1(k)-pmr(1,k-1));
    y(k)=pmr(2,k-1)+sm/c1*(y1(k)-pmr(2,k-1));
    z(k)=pmr(3,k-1)+sm/c1*(z1(k)-pmr(3,k-1));
    pmr(:,k)=[x(k);y(k);z(k)];
    r(k)=sqrt((ptr(1,k)-pmr(1,k))^2+(ptr(2,k)-pmr(2,k))^2+(ptr(3,k)-pmr(3,k))^2);
    % 相距距离 小于6m即认为相遇
    if r(k)<0.06;
        break;
    end;
end
k1 = floor(0.6*k);

pmr(1,:)=fliplr(pmr(1,:)); 
pmr(2,:)=fliplr(pmr(2,:)); 
pmr(3,:)=fliplr(pmr(3,:)); 
% 轨迹反序
pmr(1,:)=pmr(1,:)-pmr(1,1);
pmr(2,:)=pmr(2,:)-pmr(2,1);
saveDataName = 'Missile_Trajectory.mat';
% 存储弹体前60%轨迹
trace_m = [pmr(1,1:k1);pmr(2,1:k1);pmr(3,1:k1)];
target = [pmr(1,k),pmr(2,k),pmr(3,k)];
save(saveDataName,'trace_m','target');
sprintf('遭遇时间：%3.1f',0.1*k)
figure(1);
title('弹体轨迹线')
plot3(pmr(1,1:k),pmr(2,1:k),pmr(3,1:k),'g');
hold on
plot3(pmr(1,1:k1),pmr(2,1:k1),pmr(3,1:k1),'r','LineWidth',2);
% axis([-10 10 0 5 0 25]);
text(-5,-5,15,strcat('Total time: ',num2str(0.1*k)));
grid on