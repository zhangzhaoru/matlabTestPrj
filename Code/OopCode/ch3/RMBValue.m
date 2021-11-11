classdef RMBValue
    properties(SetAccess=private)
        amount
    end
    methods
        function obj=RMBValue(val)
            obj.amount=val;
        end
        function newobj=times(obj,multiplier)
            newobj=RMBValue(obj.amount*multiplier);
        end
        function newobj=plus(obj,obj2nd)
            newobj=RMBValue(obj.amount+obj2nd.amount);
        end
    end
end