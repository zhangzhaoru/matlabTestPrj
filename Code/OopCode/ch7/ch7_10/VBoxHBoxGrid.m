% P144-145
f= figure('Menubar','none','Toolbar','none','pos',[200 200 500 250]);

mainLayout=uiextras.HBox('Parent',f,'Spacing',10);

    leftLayout=uiextras.VBox('Parent',mainLayout,'Spacing',5,'Padding',5);
    
        lUpperLayout=uiextras.HBox('Parent',leftLayout);
        
            uicontrol('Style','text','String','Find what:','Parent',lUpperLayout,'fontSize',10)
            uicontrol('Style','popupmenu','String','prev1|prev2|prev3','Background','white','Parent',lUpperLayout);
            set(lUpperLayout,'Sizes',[80,-1],'Spacing',10)
            
        lLowerLayout=uiextras.Grid('Parent',leftLayout);
        
            uicontrol('Style','text','String','Replace With','Parent',lLowerLayout,'FontSize',10)
            uicontrol('Style','text','String','Look in','Parent',lLowerLayout,'FontSize',10)
            uiextras.Empty('Parent',lLowerLayout)
            uicontrol('Style','radio','String','Match case','Parent',lLowerLayout,'FontSize',10)
            
            uicontrol('Style','popupmenu','String','prev1|prev2|prev3','Background','white','Parent',lLowerLayout)
            uicontrol('Style','popupmenu','String','prev1|prev2|prev3','Background','white','Parent',lLowerLayout)
            uiextras.Empty('Parent',lLowerLayout)
            uicontrol('Style','radio','String','Whole word','Parent',lLowerLayout,'FontSize',10)
            set(lLowerLayout,'Rowsize',[25 25 25 25],'ColumnSizes',[100 120],'Spacing',10)
            
        set(leftLayout,'Sizes',[30 200],'Spacing',10)
            
%     columnEmpty1=uiextras.Empty('Parent',mainLayout)
        
    rightLayout=uiextras.VBox('Parent',mainLayout,'Spacing',10);
        uicontrol('style','pushbutton','string','Find Next','Parent',rightLayout)
        uicontrol('style','pushbutton','string','Find Previous','Parent',rightLayout)
        uicontrol('style','pushbutton','string','Replace','Parent',rightLayout)
        uicontrol('style','pushbutton','string','Replace All','Parent',rightLayout)
        uicontrol('style','pushbutton','string','Close','Parent',rightLayout)

        set(rightLayout, 'Sizes', [40 40 40 40 40], 'Spacing', 5)
    
%     columnEmpty2=uiextras.Empty('Parent',mainLayout)
    
%     set(mainLayout,'Sizes',[250,30,150,30],'Spacing',10)

set(mainLayout,'Sizes',[250,-1],'Spacing', 5)













