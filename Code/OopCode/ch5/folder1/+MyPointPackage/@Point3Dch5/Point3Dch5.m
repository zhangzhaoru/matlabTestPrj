classdef Point3Dch5<MyPointPackage.Point2Dch5
    properties
        z
    end
    methods
        function obj=Point3Dch5(x,y,z)
            obj=obj@MyPointPackage.Point2Dch5(x,y);
            obj.z=z;
        end
        function display(obj)
            display@MyPointPackage.Point2Dch5(obj);
            display(['z= ',num2str(obj.z)]);
        end
    end
end
