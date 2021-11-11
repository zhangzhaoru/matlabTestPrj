classdef Point2D3<handle
    properties
        x
        y
        r
    end
    methods
        function obj=Point2D3(x0,y0)
            obj.x=x0;
            obj.y=y0;
            obj.r=sqrt(obj.x^2+obj.y^2);
        end
    end
end
