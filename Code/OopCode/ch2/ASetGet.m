classdef ASetGet<handle
    properties
        a
    end
    methods
        function set.a(obj,v)
            obj.a=v
        end
        function v=get.a(obj)
            v=obj.a
        end
    end
end
