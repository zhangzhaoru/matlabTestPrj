% Point2 is a class as a example with a local function
classdef Point2<handle
    properties(Access=private)
        x
        y
    end
    methods
        function obj=Point2()
            [obj.x,obj.y]=localUtility();
        end
    end
end%end of classdef block

% local function
function [x y]=localUtility()

end

