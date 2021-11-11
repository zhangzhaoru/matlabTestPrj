% import whole package and then use class in the package
clear all;
clc;
addpath('F:\MATLABOOP\ch5\folder1');
import MyPointPackage.*;
p12=Point2Dch5(1,1);
p22=Point3Dch5(1,1,1);
p12.display();
fprintf('\n');
p22.display();