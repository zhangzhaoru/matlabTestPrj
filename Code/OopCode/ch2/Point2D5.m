classdef Point2D5<handle
    properties
        x
        y
    end
    methods
        function obj=Point2D5(x0,y0)
            obj.x=x0;
            obj.y=y0;
        end
        function normalize(obj)
            mag=sqrt(obj.x^2+obj.y^2);
            obj.x=obj.x/mag;
            obj.y=obj.y/mag;
        end
    end
end
