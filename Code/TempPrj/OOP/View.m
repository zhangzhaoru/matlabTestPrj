% 视图类
classdef View<handle
    properties
        viewSize;
        hfig;
        withdrawButton;
        depositButton;
        balanceBox;
        numBox;
        text;
        % view类需要包含model类与Control类的对应的对象
        modelObj;
        controlObj;
    end
    
    properties(Dependent)
        input;
    end
    
    
    methods
        % 构造函数 ，传入model对象
        % 出参为View类的对象
        function obj = View()
            obj.viewSize = [100 100 300 300];
            context = Context.getInstance();
            obj.modelObj = context.getData('model');
            obj.modelObj.addlistener('balanceChanged',@obj.updateBalance);
            % 注册监听器
            obj.buildUI();
            % 渲染界面
            obj.controlObj = obj.makeController();
            % 调用Controller层，传入Model对象
            obj.attachToController(obj.controlObj);
            
        end
        
        %% 获取界面输入数字
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
            % 获取Model中balance对象传入balanceBox对象r
        end
        
        % 置新界面
        function updateBalance(obj,scr,data)
            set(obj.balanceBox,'string',num2str(obj.modelObj.balance));
        end
        
        function controlObj = makeController(obj)
            controlObj = Controller(obj,obj.modelObj);
        end
        
        function attachToController(obj,ControlObj)
            funcH = @Controller.callback_withdrawbutton;
            set(obj.withdrawButton,'callback',funcH);
            % 绑定Controller回调函数
            funcH = @Controller.callback_depositbutton;
            set(obj.depositButton,'callback',funcH);
        end
        
        
    end
    
    
end

