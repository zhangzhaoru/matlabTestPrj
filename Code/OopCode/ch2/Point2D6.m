classdef Point2D6<handle
    properties
        x
        y
    end
    methods
        function obj=Point2D6(x0,y0)
            obj.x=x0;
            obj.y=y0;
        end
        normalize(obj)
    end
end
