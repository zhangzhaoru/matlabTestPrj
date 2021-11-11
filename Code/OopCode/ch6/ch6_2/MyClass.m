classdef MyClass
    properties
        x
    end
    methods
        function obj=MyClass(x)
            obj.x=x;
        end
        function s=saveobj(obj)
            s.x=obj.x;
        end
    end
    methods(Static)
        function obj=loadobj(obj)
            if isstruct(obj)
                newobj=MyClass(obj.x);
            end
            obj=newobj;
        end
    end
end
