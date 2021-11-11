classdef SomeClass<handle
    properties(Access=private)
        prop_private
    end
    properties(Access=protected)
        prop_protected
    end
    properties
        public
    end
    properties(SetAccess=private,GetAccess=private)
        var
    end
    methods(Access=private)
        function results1=somFunction1(obj)
            prop_private=1;
        end
    end
    methods(Access=protected)
        function results2=somFunction2(obj)
            prop_protected=1;
        end
    end
    methods
        function results3=somFunction3(obj)
            public=1;
        end
    end
end
    
    
    