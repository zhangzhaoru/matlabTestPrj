classdef Record1<handle
    properties(Dependent,Hidden)
        date
    end
    properties
        timeStamp
    end
    methods
        function set.date(obj,val)
            obj.timeStamp=date;
        end
        function val=get.date(obj)
            val=obj.timeStamp;
            disp('stupid disp');
        end
    end
end
