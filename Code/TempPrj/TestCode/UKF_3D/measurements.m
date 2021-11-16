function [fz1,fz2,fz3] = measurements(fx,fxp)
%��������
fz1=sqrt((fx(1)-fxp(1))^2+((fx(3)-fxp(3))^2)+(fx(5)-fxp(5))^2);
%��λ��
fz2=atan2((fx(3)-fxp(3)),(fx(1)-fxp(1)));
%������
fz3=atan2((fx(5)-fxp(5)),sqrt((fx(1)-fxp(1))^2+((fx(3)-fxp(3))^2)));
end

