classdef BankAccount<handle
    properties(SetAccess=private)%by default: GetAccess=public
        balance
        accountNumber
    end
    methods
        function obj=BankAccount(balance,num)
            obj.balance=balance;
            obj.accountNumber=num;
        end
        function deposit(obj,val)
            obj.balance=obj.balance+val;
        end
        function withdraw(obj,val)
            obj.balance=obj.balance-val;
        end
    end
end
