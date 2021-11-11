classdef RMBHandle<handle
    properties(SetAccess=private)
        amount
    end
    methods
        function obj=RMBHandle(val)
            obj.amount=val
        end
        function times(obj,multiplier)
            obj.amount=obj.amount*multiplier
        end
    end
end
