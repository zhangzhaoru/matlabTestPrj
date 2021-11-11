classdef TimeStamp<handle
    properties
        ts
    end
    methods
        function obj=TimeStamp()
            tempTime=clock;
            obj.ts=[ '(' num2str(tempTime(4),'%02.0f') ':' ...
                num2str(tempTime(5),'%02.0f') ':' ...
                num2str(tempTime(4),'%02.0f') ')'];
        end
    end
end
