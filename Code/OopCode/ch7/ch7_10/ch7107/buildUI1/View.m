classdef View<handle
    properties
        viewSize;
        hfig;
        withdrawButton;
        depositButton;
        balanceBox;
        numBox;
        text;
        modelObj;
        controlObj;
    end
    properties(Dependent)
        input
    end
    methods
        function obj=View(modelObj)
            obj.viewSize=[100 100 300 300];
            obj.modelObj=modelObj;
            obj.modelObj.addlistener('balanceChanged',@obj.updateBalance);
            obj.buildUI();
            obj.controlObj=obj.makeController();
            obj.attachToController(obj.controlObj);
        end
        function input=get.input(obj)
            input=get(obj.numBox,'string');
            input=str2double(input);
        end
        function buildUI(obj)
            obj.hfig=figure('pos',obj.viewSize,'NumberTitle','off','Menubar','none',...
                'Toolbar','none');
            obj.withdrawButton=uicontrol('Parent',obj.hfig,'string','withdraw',...
                'pos',[60 28 60 28]);
            obj.depositButton=uicontrol('Parent',obj.hfig,'string','deposit',...
                'pos',[180 28 60 28]);
            obj.numBox=uicontrol('Parent',obj.hfig,'Style','edit',...
                'pos',[60 85 180 28]);
            obj.text=uicontrol('Parent',obj.hfig,'style','text','string','Balance',...
                'pos',[60 142 60 28]);
            obj.balanceBox=uicontrol('Parent',obj.hfig,'style','edit',...
                'pos',[180 142 60 28],'tag','balanceBox');
            obj.updateBalance();
        end
        function updateBalance(obj,scr,data)
            set(obj.balanceBox,'string',num2str(obj.modelObj.balance));
        end
        function controlObj=makeController(obj)
            controlObj=Controller(obj,obj.modelObj);
        end
        function attachToController(obj,Controller)
            funcH=@Controller.callback_withdrawbutton;
            set(obj.withdrawButton,'callback',funcH);
            funcH=@Controller.callback_depositbutton;
            set(obj.depositButton,'callback',funcH);
        end
    end
end
