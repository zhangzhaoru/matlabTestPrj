% Model������ʵ�־��幦�ܺ���
classdef Model<handle

    properties
        balance;
    end
    
    % ���崥���¼�
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
           % �����¼�������View�������
        end
        
        function withdraw(obj,val)
            obj.balance = obj.balance-val;
            obj.notify('balanceChanged');
        end
    end
end

