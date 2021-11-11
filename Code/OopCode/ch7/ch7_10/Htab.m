f=figure('Menubar','none','Toolbar','none');%,'Position',[500 500 500 500]);
mainLayout=uiextras.TabPanel('Parent',f,'Padding',5);

uitable('Data',magic(25),'Parent',mainLayout);
uitable('Data',magic(25),'Parent',mainLayout);
uitable('Data',magic(25),'Parent',mainLayout);

%{
    p.TabNames={'Sheet1','Sheet2','Sheet3'};
    p.SelectedChild=2;
%}
mainLayout.TabNames={'Sheet1','Sheet2','Sheet3'};
mainLayout.SelectedChild=2;