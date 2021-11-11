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
            mainLayout=uiextras.VBox('Parent',obj.hfig,'Padding',5,'Spacing',10);
            topLayout=uiextras.HBox('Parent',mainLayout,'Spacing',5);
            middleLayout=uiextras.HBox('Parent',mainLayout,'Spacing',5);
            lowerLayout=uiextras.HBox('Parent',mainLayout,'Spacing',5);

        %     topLayout
            obj.text=uicontrol('Parent',topLayout,'style','text','string','Balance','fontSize',10);
            obj.balanceBox=uicontrol('Parent',topLayout,'style','edit','background','w');

        %     middleLayout
            obj.numBox=uicontrol('Parent',middleLayout,'style','edit','background','w');

        %     lowerLayout
            obj.withdrawButton=uicontrol('Parent',lowerLayout,'style','pushbutton',...
                'string','withdraw');
            obj.depositButton=uicontrol('Parent',lowerLayout,'style','pushbutton',...
                'string','deposit');

            set(topLayout,'Sizes',[80,-1]);
            set(lowerLayout,'Sizes',[-1,-1]);
            set(mainLayout,'Sizes',[30 30 50]);
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
