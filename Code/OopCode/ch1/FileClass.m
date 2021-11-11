classdef FileClass<handle
    properties
        name
        path
        format
        data
        FID
    end
    methods
%         The constructor is used to initialize the file class
        function obj=FileClass(name,path)
            obj.name=name;
            obj.path=path;
            obj.open();
            obj.read();
        end
%         open member methods responsible for opening the file
        function open(obj)
            open member methods responsible for opening the
            file
            fullpath=strcat(obj.path,filesep,obj.name);
            obj.fID=fopen(fullpath);
        end
%         read member method 
        function read(obj)
            obj.data=textscan(obj.fID,'%s %s  %s');
%             assume there are two columns data in data file.
        end
        function delete(obj)
            fclose(obj.fID);
            disp('file closed');
        end
    end
end

    