classdef SimpleHandle<handle
    properties
        var
    end
    methods
        function obj=SimpleHandle(var)
            obj.var=var;
        end
        function assignVar(obj,var)
            obj.var=var;
        end
    end
end
