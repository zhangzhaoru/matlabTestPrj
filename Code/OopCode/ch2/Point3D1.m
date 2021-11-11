classdef Point3D1<handle
    properties
        x
        y
        z
    end
    methods
        function obj=Point3D1(x0,y0,z0)
            obj.x=x0;
            obj.y=y0;
            obj.z=z0;
        end
        function print(obj)
            disp(['x=',num2str(obj.x)]);
            disp(['y=',num2str(obj.y)]);
            disp(['z=',num2str(obj.z)]);
        end
    end
end
