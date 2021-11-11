%P89
classdef DataSource3<handle
    methods
        function broadcastDataChanged(obj,observerObj1,observer2)
%             dataChange
            someFunction();
            observerObj1.response();
            observerObj2.update();
        end
    end
end

            