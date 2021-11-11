classdef(ConstructOnLoad) Calculation1<handle
    properties
        results1
    end
    properties(Transient)
        intermediateVal1
    end
    methods
        function obj=Calculation1()
            disp('calculator1 called');
            obj.intermediateVal1='initialValue';
        end
    end
end
