%% Controller��ʵ�־���Model����
classdef Controller<handle
    
    properties
        viewObj;
        modelObj;
        % Controller ��View��Model����
    end
    
    methods
        % ���幹�캯�� ����View��Model���� ����Controller����
        function obj = Controller(viewObj,modelObj)
            obj.viewObj = viewObj;
            obj.modelObj = modelObj;
        end
        
        function callback_withdrawbutton(obj,src,event)
            obj.modelObj.withdraw(obj.viewObj.input);
            %            ����Model�����Ӧ����
        end
        function callback_depositbutton(obj,scr,event)
            obj.modelObj.deposit(obj.viewObj.input);
        end
    end
end
