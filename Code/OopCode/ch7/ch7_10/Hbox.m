f=figure('Menubar','none','Toolbar','none','Position',[500 500 200 45]);
mainLayout=uiextras.HBox('Parent',f,'Padding',10);

uicontrol('style','text','string','Find what:','Parent',mainLayout,'FontSize',10)
uicontrol('style','popupmenu','string','prev1|prev2|prev3','Background','white','Parent',mainLayout)

set(mainLayout,'Sizes',[80 -1],'Spacing', 10);