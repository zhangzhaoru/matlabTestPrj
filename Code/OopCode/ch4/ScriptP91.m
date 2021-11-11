% ScriptP91
%{
%P90
classdef Observer<handle
    % a static method as a callback function of observer
    methods(Static)
        function updateViewStatic(scr,data)
            disp('updateViewStatic notified');
        end
    end
    
    % an ordinary member method as a callback function of observer
    methods
        function updateView(obj,scr,data)
            disp('updateView notified');
        end
    end
end

%}
p=DataSourcePublisher();
o=Observer();
% a function, updateViewSimpleFunc, as a callback function of observer
p.addlistener('dataChangedSimple',@updateViewSimpleFunc)
% a static method, updateViewStatic, as a callback function of observer
p.addlistener('dataChangedSimple',@Observer.updateViewStatic)
% an ordinary member method as a callback function of observer
p.addlistener('dataChangedSimple',@o.updateView)
% notification after a period of data changing.
p.notify('dataChangedSimple')

%{
ScriptP91

ans = 

  listener with properties:

       Source: {[1x1 DataSourcePublisher]}
    EventName: 'dataChangedSimple'
     Callback: @updateViewSimpleFunc
      Enabled: 1
    Recursive: 0


ans = 

  listener with properties:

       Source: {[1x1 DataSourcePublisher]}
    EventName: 'dataChangedSimple'
     Callback: @Observer.updateViewStatic
      Enabled: 1
    Recursive: 0


ans = 

  listener with properties:

       Source: {[1x1 DataSourcePublisher]}
    EventName: 'dataChangedSimple'
     Callback: [function_handle]
      Enabled: 1
    Recursive: 0

updateView notified
updateViewStatic notified
updateViewSimpleFunc notified
%}