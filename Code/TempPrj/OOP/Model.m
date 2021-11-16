% Model类用于实现具体功能函数
classdef Model<handle

    properties
        balance;
    end
    
    % 定义触发事件
    events
       balanceChanged; 
    end
    
    
    methods

        
        
        function obj = Model(balance)
            if nargin==0
                
                
            end
           obj.balance = balance; 
        end
        
        function deposit(obj,val)
           obj.balance = obj.balance+val;
           obj.notify('balanceChanged');
           % 唤醒事件，触发View层监听器
        end
        
        function withdraw(obj,val)
            obj.balance = obj.balance-val;
            obj.notify('balanceChanged');
        end
    end
end

