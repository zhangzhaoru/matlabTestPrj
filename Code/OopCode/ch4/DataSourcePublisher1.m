% P92
classdef DataSourcePublisher1<handle
    events
        dataChanged
    end
    
    methods
        function queryData(obj)%query the hardware, data changed
            obj.notify('dataChanged',TimeStamp());
        end
    end
end
