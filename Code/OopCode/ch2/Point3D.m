classdef Point3D<handle
    properties
        x
        y
        z
    end
    methods
        function obj=Point3D(x0,y0,z0)
            obj.x=x0;
            obj.y=y0;
            obj.z=z0;
        end
        function normalize(obj)
            disp('Point3D normalize');
            mag=sqrt(obj.x^2+obj.y^2+obj.z^2);
            obj.x=obj.x/mag;
            obj.y=obj.y/mag;
            obj.z=obj.z/mag;
        end
    end
end
