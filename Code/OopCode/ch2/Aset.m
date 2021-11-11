classdef Aset<handle
    properties
        a=-10;
    end
    methods
        function set.a(obj,val)
            if val>=0
                obj.a=val;
%                 obj.a=set.a(obj.a);
            else
                error('a must be positive');
            end
        end
    end
end