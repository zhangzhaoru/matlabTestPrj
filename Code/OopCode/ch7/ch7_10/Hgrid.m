% f=figure('Menubar','figure','Toolbar','auto')
f=figure('Menubar','none','Toolbar','none','Position',[500 500 300 100]);
mainLayout=uiextras.Grid('Parent',f,'Padding',10);

uicontrol('Style','text','String','Replace with','FontSize',9,'Parent',mainLayout);
uicontrol('Style','text','String','Look in','FontSize',9,'Parent',mainLayout);
uiextras.Empty('Parent',mainLayout);
uicontrol('Style','radio','string','match case','FontSize',9,'Parent',mainLayout);

uicontrol('Style','popupmenu','String','prev1|prev2|prev3','background','w',...
    'Parent',mainLayout);
uicontrol('Style','popupmenu','String','prev1|prev2|prev3','background','w',...
    'Parent',mainLayout);
uiextras.Empty('Parent',mainLayout);
uicontrol('Style','radio','string','whole word','FontSize',9,'Parent',mainLayout);

set(mainLayout, 'RowSizes',[25 25 25 25],'ColumnSizes',[120 150],'Spacing',5)
% set(mainLayout, 'RowSizes',[25 -1 -1 -1],'ColumnSizes',[120 -1],'Spacing',5)