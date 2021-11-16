% 上下文类，用于实例对象的管理
classdef Context < handle
    
    properties(Static)
        dataDictionary;
    end
    
    methods(Access=private)
        function obj = Context()
            Context.dataDictionary = containers.Map();
        end
    end
    
    methods(Static)
        function obj = getInstance()
            persistent localObj;
            if isempty(localObj)||~isvalid(localObj)
                localObj = Context();
            end
            obj = Context();
        end
    end
    
    methods
        function register(obj,ID,data)
            expr=sprintf(' Context.dataDictionary(\''%s\'')=data;',ID);
            Context.dataDictionary(ID) = data;
        end
        
        function data=getData(obj,ID)
            if isKey(obj.dataDictionary,ID)
                data=obj.dataDictionary(ID);
            else
                error('ID does not exist');
            end
        end
    end
end



