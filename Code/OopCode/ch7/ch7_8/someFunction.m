% below is a example of assuming we want to get the camera object in a
% function
function someFunction()
    contextObj = Context.getInstance();
    hCamera = contextObj.getData('Camera');
end