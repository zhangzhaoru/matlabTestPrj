balance=500;
input=0;
hfig=figure('pos',[100,100,300,300]);
withdrawButton=uicontrol('parent',hfig,'string','withdraw',...
    'pos',[60 28 60 28]);
depositButton=uicontrol('parent',hfig,'string','deposit',...
    'pos',[180 28 60 28]);
inputBox=uicontrol('parent',hfig,'style','edit','pos',[60 85 180 28],...
    'string',num2str(input),'Tag','inputbox');
balanceBox=uicontrol('parent',hfig,'style','edit','pos',[180 142 60 28],...
    'string',num2str(balance),'Tag','balancebox');
textBox=uicontrol('parent',hfig,'style','text','string','Blance',...
    'pos',[60 142 60 28]);

% http://www.mathworks.com/matlabcentral/fileexchange/27758-gui-layout-toolbox

set(withdrawButton,'callback',@(o,e)withdraw_callback(o,e));
set(depositButton,'callback',@(o,e)deposit_callback(o,e));

