%P88
classdef DataSource2<handle
    events%The beginning of events block
        dataChanged
    end%The end of events block
    methods
        function internalDataChange(obj)
        obj.notify('dataChanged');
        end
    end
end
