% P93
classdef Observer1<handle
    methods(Static)
        function updateViewStatic(scr,data)
            disp(['data changed at ',data.ts])
        end
    end
    
    methods
        function updateView(obj,scr,data)
            disp(['data changed at ',data.ts])
        end
    end
end
