classdef Point1<handle
    properties(Access = private)
        x
        y
    end
    methods
        function obj = Point1(x,y)
            obj.x=x;
            obj.y=y;
        end
        
%         declaration of methods
        [norm] =normalize(obj);
        display(obj);
    end
end    