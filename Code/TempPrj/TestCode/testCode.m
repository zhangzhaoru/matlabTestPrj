%EKF UKF PF �������㷨

clear;

%tic;

x =0.1; %��ʼ״̬

x_estimate=1;%״̬�Ĺ���

e_x_estimate=x_estimate;%EKF�ĳ�ʼ����

u_x_estimate=x_estimate;%UKF�ĳ�ʼ����

p_x_estimate=x_estimate;%PF�ĳ�ʼ����

Q =10;%input('����������������� Q ��ֵ :'); %����״̬Э����

R =1;%input('����������������� R ��ֵ :'); %��������Э����

P =5;%��ʼ���Ʒ���

e_P=P; %UKF����

u_P=P;%UKF����

pf_P=P;%PF����

tf =50; %ģ�ⳤ��

x_array=[x];%��ʵֵ����

e_x_estimate_array=[e_x_estimate];%EKF���Ź���ֵ����

u_x_estimate_array=[u_x_estimate];%UKF���Ź���ֵ����

p_x_estimate_array=[p_x_estimate];%PF���Ź���ֵ����

u_k=1; %΢������

u_symmetry_number=4; %�ԳƵĵ�ĸ���

u_total_number=2*u_symmetry_number+1; %�ܵĲ�����ĸ���

linear =0.5;

N =500; %�����˲���������

close all;

%�����˲���ʼ N ������

for i =1:N

p_xpart(i)=p_x_estimate+sqrt(pf_P)*randn;

end

for k =1:tf

%ģ��ϵͳ

x =linear *x +(25*x /(1+x^2))+8*cos(1.2*(k-1))+sqrt(Q)*randn; %״ֵ̬

y =(x^2/20) +sqrt(R)*randn; %�۲�ֵ

%��չ�������˲���

%���й��� ��һ�׶εĹ���

e_x_estimate_1=linear *e_x_estimate+25*e_x_estimate/(1+e_x_estimate^2)+8*cos(1.2*(k-1));

e_y_estimate=(e_x_estimate_1)^2/20;%���Ǹ��� k=1ʱ����ֵΪ 1�õ��Ĺ۲�ֵ;ֻ������� �ҹ��Ƶõ��� �� 24�е� y Ҳ�ǹ۲�ֵ �������ɼ�����������ʵֵ�õ���

%��ؾ���

e_A=linear +25*(1-e_x_estimate^2)/((1+e_x_estimate^2)^2);%���ݾ���

e_H=e_x_estimate_1/10;%�۲����

%���Ƶ����

e_p_estimate=e_A*e_P*e_A'+Q;

%��չ����������

e_K=e_p_estimate*e_H'/(e_H*e_p_estimate*e_H'+R);

%���й���ֵ�ĸ��� �ڶ��׶�

e_x_estimate_2=e_x_estimate_1+e_K*(y-e_y_estimate);

%���º�Ĺ���ֵ�����

e_p_estimate_update=e_p_estimate-e_K*e_H*e_p_estimate;

%������һ�ε����Ĳ����仯

e_P=e_p_estimate_update;

e_x_estimate=e_x_estimate_2;

%�����˲���

%�����˲���

for i =1:N

p_xpartminus(i)=0.5*p_xpart(i)+25*p_xpart(i)/(1+p_xpart(i)^2)+8*cos(1.2*(k-1))+ sqrt(Q)*randn; %���ʽ�ӱ�����һ�е�Ч����

%xpartminus(i)=0.5*xpart(i)+25*xpart(i)/(1+xpart(i)^2)+8*cos(1.2*(k-1));

p_ypart=p_xpartminus(i)^2/20; %Ԥ��ֵ

p_vhat=y -p_ypart;%�۲��Ԥ��Ĳ�

p_q(i)=(1/sqrt(R)/sqrt(2*pi))*exp(-p_vhat^2/2/R); %�������ӵ�Ȩֵ

end

%ƽ��ÿһ�����ƵĿ�����

p_qsum=sum(p_q);

for i =1:N

p_q(i)=p_q(i)/p_qsum;%�������ӽ���Ȩֵ��һ��

end

%�ز��� Ȩ�ش�����Ӷ�ɵ�,Ȩ��С�������ٲɵ� , �൱��ÿһ�ζ������ز���;

for i =1:N

p_u=rand;

p_qtempsum=0;

for j =1:N

p_qtempsum=p_qtempsum+p_q(j);

if p_qtempsum>=p_u

p_xpart(i)=p_xpartminus(j);%������ xpart(i)ʵ��ѭ����ֵ;�����ҵ�������! ! ! break;

end

end

end

p_x_estimate=mean(p_xpart);

%p_x_estimate=0;

%for i =1:N

%p_x_estimate=p_x_estimate+p_q(i)*p_xpart(i);

%end

%�����������˲���

%�������ѡȡ ���� x(i)

u_x_par=u_x_estimate;

for i =2:(u_symmetry_number+1)

u_x_par(i,:)=u_x_estimate+sqrt((u_symmetry_number+u_k)*u_P);

end

for i =(u_symmetry_number+2):u_total_number

u_x_par(i,:)=u_x_estimate-sqrt((u_symmetry_number+u_k)*u_P);

end

%����Ȩֵ

u_w_1=u_k/(u_symmetry_number+u_k);

u_w_N1=1/(2*(u_symmetry_number+u_k));

%����Щ����ͨ�����ݷ��� �õ���һ��״̬

for i =1:u_total_number
u_x_par(i)=0.5*u_x_par(i)+25*u_x_par(i)/(1+u_x_par(i)^2)+8*cos(1.2*(k-1));

end

%���ݺ�ľ�ֵ�ͷ���

u_x_next=u_w_1*u_x_par(1);

for i =2:u_total_number

u_x_next=u_x_next+u_w_N1*u_x_par(i);

end

u_p_next=Q +u_w_1*(u_x_par(1)-u_x_next)*(u_x_par(1)-u_x_next)';

for i =2:u_total_number

u_p_next=u_p_next+u_w_N1*(u_x_par(i)-u_x_next)*(u_x_par(i)-u_x_next)';

end

%%�Դ��ݺ�ľ�ֵ�ͷ�����в��� �������� ���� y(i)

%u_y_2obser(1)=u_x_next;

%for i =2:(u_symmetry_number+1)

%u_y_2obser(i,:)=u_x_next+sqrt((u_symmetry_number+k)*u_p_next); %end

%for i =(u_symmetry_number+2) :u_total_number

%u_y_2obser(i,:)=u_x_next-sqrt((u_symmetry_number+u_k)*u_p_next); %end

%������� y_2obser(i)��;

for i =1:u_total_number

u_y_2obser(i,:)=u_x_par(i);

end

%ͨ���۲ⷽ�� �õ�һϵ�е�����

for i =1:u_total_number

u_y_2obser(i)=u_y_2obser(i)^2/20;

end

%ͨ���۲ⷽ�̺�ľ�ֵ y_obse

u_y_obse=u_w_1*u_y_2obser(1);

for i =2:u_total_number

u_y_obse=u_y_obse+u_w_N1*u_y_2obser(i);

end

%Pzz�����������

u_pzz=R +u_w_1*(u_y_2obser(1)-u_y_obse)*(u_y_2obser(1)-u_y_obse)';

for i =2:u_total_number

u_pzz=u_pzz+u_w_N1*(u_y_2obser(i)-u_y_obse)*(u_y_2obser(i)-u_y_obse)';

end

%Pxz״̬���������ֵ��Э�������

u_pxz=u_w_1*(u_x_par(1)-u_x_next)*(u_y_2obser(1)-u_y_obse)';

for i =2:u_total_number

u_pxz=u_pxz+u_w_N1*(u_x_par(i)-u_x_next)*(u_y_2obser(i)-u_y_obse)';

end

%����������

u_K=u_pxz/u_pzz;

%�������ĸ���

u_x_next_optimal=u_x_next+u_K*(y-u_y_obse);%��һ���Ĺ���ֵ +����ֵ; u_x_estimate=u_x_next_optimal;

%����ĸ���

u_p_next_update=u_p_next-u_K*u_pzz*u_K';

u_P=u_p_next_update;

%���л�ͼ����

x_array=[x_array,x];

e_x_estimate_array=[e_x_estimate_array,e_x_estimate];

p_x_estimate_array=[p_x_estimate_array,p_x_estimate];

u_x_estimate_array=[u_x_estimate_array,u_x_estimate];

e_error(k,:)=abs(x_array(k)-e_x_estimate_array(k));

p_error(k,:)=abs(x_array(k)-p_x_estimate_array(k));

u_error(k,:)=abs(x_array(k)-u_x_estimate_array(k));

end

t =0:tf;

figure;

plot(t,x_array,'k.',t,e_x_estimate_array,'r-',t,p_x_estimate_array,'g--',t,u_x_estimate_array,'b:');

set(gca,'FontSize',10);

set(gcf,'color','White');

xlabel('ʱ�䲽�� ');%lable --->label�ҵ���

ylabel('״̬ ');

legend('��ʵֵ ','EKF ����ֵ ','PF ����ֵ ','UKF ����ֵ ');

figure;

plot(t,x_array,'k.',t,p_x_estimate_array,'g--',t, p_x_estimate_array-1.96*sqrt(P),'r:',t, p_x_estimate_array+1.96*sqrt(P),'r:');

set(gca,'FontSize',10);

set(gcf,'color','White');

xlabel('ʱ�䲽�� ');%lable --->label�ҵ���

ylabel('״̬ ');

legend('��ʵֵ ','PF ����ֵ ', '95%�������� ');

%rootmean square ƽ��ֵ��ƽ����

e_xrms=sqrt((norm(x_array-e_x_estimate_array)^2)/tf);

disp(['EKF����������ֵ =',num2str(e_xrms)]);

p_xrms=sqrt((norm(x_array-p_x_estimate_array)^2)/tf);

disp(['PF����������ֵ =',num2str(p_xrms)]);

u_xrms=sqrt((norm(x_array-u_x_estimate_array)^2)/tf);

disp(['UKF����������ֵ =',num2str(u_xrms)]);

%plot(t,e_error,'r-',t,p_error,'g--',t,u_error,'b:');

%legend('EKF����ֵ��� ','PF ����ֵ��� ','UKF ����ֵ��� ');

t =1:tf;

figure;

plot(t,e_error,'r-',t,p_error,'g--',t,u_error,'b:');

set(gca,'FontSize',10);

set(gcf,'color','White');

xlabel('ʱ�䲽�� ');%lable --->label�ҵ���

ylabel('״̬ ');

legend('EKF����ֵ��� ','PF ����ֵ��� ','UKF ����ֵ��� ');

%toc;