function buildUI2(obj)
    obj.hfig=figure('po',obj.viewSize,'NumberTitle','off','Menubar','none',...
        'Toolbar','none');
    mainLayout=uiextras.VBox('Parent',obj.hfig,'Padding',5,'Spacing',10);
    topLayout=uiextras.HBox('Parent',mainLayout,'Spacing',5);
    middleLayout=uiextras.HBox('Parent',mainLayout,'Spacing',5);
    lowerLayout=uiextras.HBox('Parent',mainLayout,'Spacing',5);
    
%     topLayout
    obj.text=uicontrol('Parent',topLayout,'style','text','string','Balance');
    obj.balanceBox=uicontrol('Parent',topLayout,'style','edit','background','w');
    
%     middleLayout
    obj.numBox=uicontrol('Parent',middleLayout,'style','edit','background','w');
    
%     lowerLayout
    obj.drawButton=uicontrol('Parent',lowerLayout,'style','pushbutton',...
        'string','draw');
    obj.depositButton=uicontrol('Parent',lowerLayout,'style','pushbutton',...
        'string','deposit');
    
    set(topLayout,'Sizes',[-1,-1]);
    set(lowerLayout,'Sizes',[-1,-1]);
    obj.updateBalance();                    
end