classdef SimpleValue1
    properties
        var
    end
    methods
        function obj=SimpleValue1(var)
            obj.var=var;
        end
        function obj=assignVar1(obj,var)
            obj.var=var;
        end
    end
end