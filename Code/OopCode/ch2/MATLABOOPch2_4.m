%% 
%{
methods
    function [returnValue]=functionName(arguments)
    end
end
%}

%% Two way to call class methods
% 1st way
% Using DOT syntax to call class methods
p1=Point2D5(1.0,1.0);
p1.normalize();
p1.x
p1.y
%{
ans =
    0.7071
ans =
    0.7071
%}
% 2nd way
% traditional methods to call class methods
p1=Point2D5(1.0,1.0)
normalize(p1)
%{
p1 = 
  Point2D5 with properties:
    x: 1
    y: 1
%}
%% The difference of two way above
% The first way is the OOP style, which has a high readability.
% And more clarity to know whether we use member methods or use 
% The second way has more compability with tradition POP code.
%% signature of methods
clear classes
p1=Point2D7(1.0,1.0);
p2=Point3D(1.0,1.0,1.0);
normalize(p1);
normalize(p2);
p1.x
p1.y
p2.x
p2.y
p2.z
%% 
obj=MyClass()
%% 


