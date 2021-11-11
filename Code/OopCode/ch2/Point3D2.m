classdef Point3D2<Point2D9
    properties
        z
    end
    methods
        function obj=Point3D2(x0,y0,z0)
            obj=obj@Point2D9(x0,y0);
            obj.z=z0;
        end
        function print(obj)
            print@Point2D9(obj);
            disp(['z=',num2str(obj.z)]);
        end
    end
end