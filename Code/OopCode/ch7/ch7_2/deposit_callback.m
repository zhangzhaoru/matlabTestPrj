function deposit_callback(o,e)
    hfig=get(o,'parent');
    inputBox=findobj(hfig,'Tag','inputbox');
    input=str2double(get(inputBox,'string'));
    balanceBox=findobj(hfig,'Tag','balancebox');
    balance=str2double(get(balanceBox,'string'));
    balance=balance+input;
    set(balanceBox,'string',num2str(balance));
end