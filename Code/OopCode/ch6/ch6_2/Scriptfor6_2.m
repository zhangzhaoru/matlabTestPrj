clear all;
obj=MyClass(5)
%{
obj = 

  MyClass with properties:

    x: 5
%}
s=saveobj(obj)
%{
s = 

    x: 5
%}
obj=MyClass(6)
%{
obj = 

  MyClass with properties:

    x: 6
%}
loadobj(s)
%{
ans = 

    x: 5
%}