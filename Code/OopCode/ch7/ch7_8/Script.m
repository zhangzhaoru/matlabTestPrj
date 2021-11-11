% P134
% In the scripts below, we assum there are two hardware, camera and power.
% So we state two model objects and initial an unique ID to each hardware.
% And we use static method, "getInstance", to get the context object and
% use the method, "register", to register

obj1=ModelDevice('Camera');
obj2=ModelDevice('PowerSource');
contextObj=Context.getInstance();%get global context object
contextObj.register('Camera',obj1);%register Camera object
contextObj.register('PowerSource',obj2);%register PowerSource object