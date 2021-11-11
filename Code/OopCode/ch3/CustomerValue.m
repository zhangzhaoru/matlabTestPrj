classdef CustomerValue
    properties
        name
        address
    end
    methods
        function obj=CustomerValue(name,address)
            obj.name=name;
            obj.address=address;
        end
    end
end
