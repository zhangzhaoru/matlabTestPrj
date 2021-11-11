classdef OrderValue
    properties
        id
        customer
    end
    methods
        function obj=OrderValue(id,customer)
            obj.id=id;
            obj.customer=customer;
        end
    end
end