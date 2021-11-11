classdef Point2Dch5<handle
    properties
        x
        y
    end
    methods
        function obj= Point2Dch5(x,y)
            obj.x=x;
            obj.y=y;
        end
        [norm]=normalize(obj)
        display(obj);
    end
end
