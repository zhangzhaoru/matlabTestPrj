
%% 
clear
a=7;
b='some string';
c=rand(4,4);
whos;
%{
  Name      Size            Bytes  Class     Attributes

  a         1x1                 8  double              
  b         1x11               22  char                
  c         4x4               128  double              
%}
%% 
p1=Point2D(1.0,1.0)
p2=Point2D(2.0,2.5)
p1.x
p2.x
%% 
obj=View()
%% 
p1=Point2D1()
p2=Point2D1()
p1.x
p1.y
p1.x=10
p1.x
%% 
p1=Point2D4(1.0,1.0);
p1.r
p1.x=2.0
p1.r

%% 
obj=View1();
obj.text;
%% 
obj=A1()
%% 
obj=A2()




