classdef Aget<handle
    properties
        b=-10;
    end
    methods
        function val=get.b(obj)
            val=obj.b;
            disp('getter called');
        end
    end
end
