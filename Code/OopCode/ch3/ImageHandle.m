classdef ImageHandle<handle
    properties
        matrix
    end
    methods
        function obj = ImageHandle(N)
            obj.matrix=zeros(N,N);
        end
    end
end
