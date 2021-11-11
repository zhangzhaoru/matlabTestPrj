classdef Point2D8<handle
    properties
        x
        y
    end
    methods
        function obj=Point2D8(x0,y0)
            if nargin==0
                obj.x=cos(pi/12);
                obj.y=sin(pi/12);
            elseif nargin==2
                obj.x=x0;
                obj.y=y0;
            else
                error('wrong input arguments')
            end
        end
    end
end
