classdef View<handle
    properties
        hFig
        hEdit
    end
    methods
        function obj=View()
            obj.hFig=figure();
            obj.hEdit=uicontrol('style','edit','parent',obj.hFig);
        end
    end
end