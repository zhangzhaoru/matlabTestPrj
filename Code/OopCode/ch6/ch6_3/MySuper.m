classdef MySuper
    properties
        X
        Y
    end
    
    methods
        function obj=MySuper(x,y)
            obj.X=x;
            obj.Y=y;
        end
        
        function S=saveobj(obj)
            S.PointX=obj.X;
            S.PointY=obj.Y;
        end
        
        function obj=reload(obj,S)
            obj.X=S.PointX;
            obj.Y=S.PointY;
        end
        
    end
    
    methods(Static)
        function obj=loadobj(S)
            obj=MySuper;
            obj=reload(obj,S);
        end
    end
    
end
