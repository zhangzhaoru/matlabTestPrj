classdef Controller<handle
    properties
        viewObj;
        modelObj;
    end
    methods
        function obj=Controller(viewObj,modelObj)
            obj.viewObj=viewObj;
            obj.modelObj=modelObj;
        end
        function callback_withdrawbutton(obj,scr,event)
            obj.modelObj.withdraw(obj.viewObj.input);
        end
        function callback_depositbutton(obj,scr,event)
            obj.modelObj.deposit(obj.viewObj.input);
        end
    end
end
