%lh=addlistener(eventObj,'EventName',@functionName);
p=DataSourcePublisher()
lh=p.addlistener('dataChangedSimple',@updateViewSimpleFunc)
%{
lh = 

  listener with properties:

       Source: {[1x1 DataSourcePublisher]}
    EventName: 'dataChangedSimple'
     Callback: @updateViewSimpleFunc
      Enabled: 1
    Recursive: 0
%}
delete(lh);
lh
%{
lh = 

  handle to deleted listener
%}