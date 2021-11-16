% ��ͼ��
classdef View<handle
    properties
        viewSize;
        hfig;
        withdrawButton;
        depositButton;
        balanceBox;
        numBox;
        text;
        % view����Ҫ����model����Control��Ķ�Ӧ�Ķ���
        modelObj;
        controlObj;
    end
    
    properties(Dependent)
        input;
    end
    
    
    methods
        % ���캯�� ������model����
        % ����ΪView��Ķ���
        function obj = View()
            obj.viewSize = [100 100 300 300];
            context = Context.getInstance();
            obj.modelObj = context.getData('model');
            obj.modelObj.addlistener('balanceChanged',@obj.updateBalance);
            % ע�������
            obj.buildUI();
            % ��Ⱦ����
            obj.controlObj = obj.makeController();
            % ����Controller�㣬����Model����
            obj.attachToController(obj.controlObj);
            
        end
        
        %% ��ȡ������������
        function input = get.input(obj)
            input =  get(obj.NumBox,'string');
            input = str2double(input);
        end
        
        function buildUI(obj)
            obj.hfig =  figure('pos',obj.viewSize);
            obj.withdrawButton=uicontrol('parent',obj.hfig,'string','withdraw',...
                'pos',[60 28 60 28]);
            obj.depositButton=uicontrol('parent',obj.hfig,'string','deposit',...
                'pos',[180 28 60 28]);
            obj.numBox=uicontrol('parent',obj.hfig,'style','edit',...
                'pos',[60 85 180 28]);
            obj.text=uicontrol('parent',obj.hfig,'style','text','string',...
                'Balance','pos',[60 142 60 28]);
            obj.balanceBox=uicontrol('parent',obj.hfig,'style','edit',...
                'pos',[180 142 60 28],'tag','balanceBox');
            obj.updateBalance();
            % ��ȡModel��balance������balanceBox����r
        end
        
        % ���½���
        function updateBalance(obj,scr,data)
            set(obj.balanceBox,'string',num2str(obj.modelObj.balance));
        end
        
        function controlObj = makeController(obj)
            controlObj = Controller(obj,obj.modelObj);
        end
        
        function attachToController(obj,ControlObj)
            funcH = @Controller.callback_withdrawbutton;
            set(obj.withdrawButton,'callback',funcH);
            % ��Controller�ص�����
            funcH = @Controller.callback_depositbutton;
            set(obj.depositButton,'callback',funcH);
        end
        
        
    end
    
    
end

