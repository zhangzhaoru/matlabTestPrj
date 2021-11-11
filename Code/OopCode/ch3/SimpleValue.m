classdef SimpleValue
    properties
        var
    end
    methods
        function obj=SimpleValue(var)
            obj.var=var;
        end
        function assignVar(obj,var)
            obj.var=var;
        end
        function obj=assignVar1(obj,var)
            obj.var=var;
        end
		function newobj=assignVar2(obj,var)
            newobj.var=var;
        end
    end
end