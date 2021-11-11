classdef ViewBase<handle
    properties
        hFig
        viewsize
        ID
        menubar
    end
    methods
        function obj=ViewBase(viewsize,ID)
            obj.viewsize=viewsize;
            obj.ID=ID;
            obj.hFig=figure('pos',viewsize);
            set(obj.hFig,'resize','off',...
                'numbertitle','off',...
				'menubar','none',...
                'name','Demo');
        end
    end
end
%                 'memubar','none',...