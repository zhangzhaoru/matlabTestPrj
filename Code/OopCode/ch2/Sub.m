classdef Sub<Super
    properties    
    end
    methods
        function foo(obj,argu1,argu2)
            
            disp('Sub foo called');
            foo@Super(obj,argu1);
        end
    end
end