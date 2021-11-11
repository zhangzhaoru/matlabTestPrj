classdef TextReader<Reader
    properties
        formats
    end
    methods
        function obj=TextReader(filename,path,format)
            obj=obj@Reader(filename,path);
            obj.format=format;
        end
    end
end
