    % scriptP93
clear all;
clc;

p=DataSourcePublisher1();
o=Observer1();
p.addlistener('dataChanged',@updateViewSimpleFunc1)
p.addlistener('dataChanged',@Observer1.updateViewStatic)
p.addlistener('dataChanged',@o.updateView)

p.queryData();