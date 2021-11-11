%% 
p2=Point2D9(1,1)
p3=Point3D2(1,1,1)
isa(p2,'Point2D9')
isa(p3,'Point2D9')
isa(p2,'Point3D2')
isa(p3,'Point3D2')
%% 
obj=ViewBase([100,100,500,500],1)
obj1=ViewSmall()
%% The way to call methods in parent class with same name
%{
classdef Super
    properties
        ......
    end
    methods
        function foo(obj.argu)
            disp('Super foo called')
            ......
            ......
        end
    end
end

classdef Sub<Super
    properties
        ......
    end
    methods
        function foo(obj,argu1,argu2)
            disp('Sub foo called');
            foo@Super(obj,argu1);
            ......
        end
    end
end
%}

%% 
obj1=Point2D9(1,1)
obj1.print
obj2=Point3D2(1,1,1)
obj2.print
