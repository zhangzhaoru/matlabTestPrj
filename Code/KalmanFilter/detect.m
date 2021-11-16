% Ŀ���⺯�������������Ҫ��ɽ�Ŀ��ӱ�������ȡ����
function detect
clear,clc;
%���㱳��ͼƬ��Ŀ
Imzero = zeros(240,320,3);
for i = 1:5
    %��ͼ���ļ��������Im
    Im{i} = double(imread(['DATA/',int2str(i),'.jpg']));
    Imzero = Im{i}+Imzero;
end
Imback = Imzero/5;
[MR,MC,Dim] = size(Imback);
%��������ͼƬ
for i = 1 : 60
    %��ȡ����֡
    Im = (imread(['DATA/',int2str(i), '.jpg']));
    imshow(Im); %��ʾͼ��Im,ͼ��Աȶȵ�
    Imwork = double(Im);
    %���Ŀ��
    [cc(i),cr(i),radius,flag] = extractball(Imwork,Imback,i);
    if flag==0 %û��⵽Ŀ�꣬������һ֡ͼ��
        continue
    end
    hold on
    for c = -0.9*radius: radius/20 : 0.9*radius
        r = sqrt(radius^2-c^2);
        plot(cc(i)+c,cr(i)+r,'g.')
        plot(cc(i)+c,cr(i)-r,'g.')
    end
    pause(0.02)
end
%Ŀ�����ĵ�λ�ã�Ҳ����Ŀ���x��y����
figure
plot(cr,'-g*')
hold on
plot(cc,'-r*')

% ��ȡĿ����������ĺ��ܰ���Ŀ������뾶
function [cc,cr,radius,flag]=extractball(Imwork,Imback,index)
%��ʼ��Ŀ���������ĵ����꣬�뾶
cc = 0;
cr = 0;
radius = 0;
flag = 0;
[MR,MC,Dim] = size(Imback);
%��ȥ�������ҵ����Ĳ�ͬ���򣬼�Ŀ������
fore = zeros(MR,MC);    
%����������õ�Ŀ��      
fore = (abs(Imwork(:,:,1)-Imback(:,:,1)) > 10) ...
    | (abs(Imwork(:,:,2) - Imback(:,:,2)) > 10) ...
    | (abs(Imwork(:,:,3) - Imback(:,:,3)) > 10);
%ͼ��ʴ����ȥ΢С�İ�������
%bwmorph�ú����Ĺ����ǣ���ȡ������ͼ�������
foremm = bwmorph(fore,'erode',2);%��2��Ϊ����
%ѡȡ����Ŀ��
labeled = bwlabel(foremm,4);%�ڱ���������ж��ٰ׿�飬4-��ͨ
%labeled�Ǳ�Ǿ���ͼ��ָ��Բ�ͬ��������в�ͬ�ı��
stats = regionprops(labeled,['basic']);
[N,W] = size(stats);
if N < 1
    return%һ��Ŀ������Ҳû��⵽�ͷ���
end
%��N�������У�ð���㷨����
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
%ȷ��������һ���ϴ����������������Ҫ����100��
if stats(1).Area < 100
    return
end
selected = (labeled==id(1));
%���������������ĺͰ뾶
centroid = stats(1).Centroid;
radius = sqrt(stats(1).Area/pi);
cc = centroid(1);
cr = centroid(2);
flag = 1;
return
