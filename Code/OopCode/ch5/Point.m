classdef Point<handle
    properties(Access = private)
        x
        y
    end
    
    methods
        function obj = Point(x,y)
            obj.x=x;
            obj.y=y;
        end
    end
end
