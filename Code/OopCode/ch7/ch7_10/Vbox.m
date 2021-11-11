f=figure('Menubar','none','Toolbar','none','Position',[500 500 80 250]);
mainLayout=uiextras.VBox('Parent',f,'Padding',10);

uicontrol('style','pushbutton','string','Find Next','Parent',mainLayout)
uicontrol('style','pushbutton','string','Find Previous','Parent',mainLayout)
uicontrol('style','pushbutton','string','Replace','Parent',mainLayout)
uicontrol('style','pushbutton','string','Replace All','Parent',mainLayout)
uicontrol('style','pushbutton','string','Close','Parent',mainLayout)

set(mainLayout, 'Sizes', [40 40 40 40 40], 'Spacing', 5);
%{
we cannot write the line above as below:
    set(mainLayout, 'Sizes', [40 -1], 'Spacing', 5);

Since there is a error as below:
%{
Error using uix.VBox/set.Heights (line 71)
Size of property 'Heights' must match size of contents.

Error in uiextras.VBox/set.Sizes (line 94)
            obj.Heights = value;

Error in Vbox (line 11)
set(mainLayout, 'Sizes', [40 -1], 'Spacing', 5);
%}


%}
