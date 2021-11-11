classdef XMLReader<Reader
    properties
        tags
    end
    methods
        function obj=XMLReader(filename,path,tags)
            obj=obj@Reader(filename,path);
            obj.tags=tags;
        end
    end
end
