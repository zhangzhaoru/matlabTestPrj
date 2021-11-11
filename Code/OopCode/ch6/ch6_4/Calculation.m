classdef Calculation < handle
    properties
        results
    end
    properties(Transient)
        intermediateVal
    end
    methods
        function obj = Calculation()
            disp('calculattor called');
            obj.intermediateVal = 'disposable';
        end
    end
end
