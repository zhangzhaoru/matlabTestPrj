classdef View1<handle
    properties
        hFig
        hEdit
    end
    properties(Dependent)
        text
    end
    methods
        function obj=View1()
            obj.hFig=figure();
            obj.hEdit=uicontrol('style','edit','parent',obj.hFig);
        end
        function str=get.text(obj)
            str=get(obj.hEdit,'string');
        end
    end
end
