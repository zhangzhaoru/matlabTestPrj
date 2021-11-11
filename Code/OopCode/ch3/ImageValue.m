classdef ImageValue
    properties
        matrix
    end
    methods
        function obj= ImageValue(N)
            obj.matrix=zeros(N,N);
        end
    end
end
