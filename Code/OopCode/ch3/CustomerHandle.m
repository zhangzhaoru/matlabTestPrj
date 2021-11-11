classdef CustomerHandle<handle
    properties
        name
        address
    end
    methods
        function obj=CustomerHandle(name,address)
            obj.name=name;
            obj.address=address;
        end
    end
end
