%P90
classdef Observer<handle
    % a static method as a callback function of observer
    methods(Static)
        function updateViewStatic(scr,data)
            disp('updateViewStatic notified');
        end
    end
    
    % an ordinary member method as a callback function of observer
    methods
        function updateView(obj,scr,data)
            disp('updateView notified');
        end
    end
end
