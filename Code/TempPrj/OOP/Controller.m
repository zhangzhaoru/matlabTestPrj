%% Controller类实现具体Model调用
classdef Controller<handle
    
    properties
        viewObj;
        modelObj;
        % Controller 绑定View与Model对象
    end
    
    methods
        % 定义构造函数 传入View与Model对象 传出Controller对象
        function obj = Controller(viewObj,modelObj)
            obj.viewObj = viewObj;
            obj.modelObj = modelObj;
        end
        
        function callback_withdrawbutton(obj,src,event)
            obj.modelObj.withdraw(obj.viewObj.input);
            %            调用Model对象对应函数
        end
        function callback_depositbutton(obj,scr,event)
            obj.modelObj.deposit(obj.viewObj.input);
        end
    end
end

