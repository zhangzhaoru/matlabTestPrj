classdef ViewSmall<ViewBase
    properties
        hEdit
    end
    methods
        function obj=ViewSmall()
            obj=obj@ViewBase([50,50,250,250],'small');
            %obj.hEdit=uicontrol('style','edit','parent',obj.hFig)
        end
    end
end
