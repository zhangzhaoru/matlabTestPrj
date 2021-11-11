classdef Reader<handle
    properties
        filename
        path
    end
    methods
        function obj=Reader(filename,path)
            obj.filename=filename;
            obj.path=path;
        end
    end
end
