classdef MySub<MySuper
    properties
        Z
    end
    
    methods
        function obj=MySub(x,y,z)
            obj=obj@MySuper(x,y);
            obj.Z=z;
        end
        
        function S=saveobj(obj)
            S=saveobj@MySupper(obj)
            S.PointZ=obj.Z;
        end
        
        function obj=reload(obj,S)
            obj.Z=S.PointZ;
        end
    end
    
    methods(Static)
        function obj=loadobj(S)
            obj=MySub;
            obj=reload@MySuper(obj,S);
            obj=reload(obj,S);
        end
    end
    
end
