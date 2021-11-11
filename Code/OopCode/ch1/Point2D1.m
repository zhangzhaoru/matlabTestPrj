classdef Point2D1 < handle
    properties
        x=0.0
        y=0.0
    end
    methods
        function obj=Point2D1(x0,y0)
            obj.x=x0;
            obj.y=y0;
        end
        function normalize(obj)
            r=sqrt(obj.x^2+obj.y^2);
            obj.x=obj.x/r;
            obj.y=obj.y/r;
        end
    end    
end