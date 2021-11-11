clear all;
clc;

aValue=SimpleValue(10)
aValue.assignVar(20)
aValue.var
aValue.assignVar1(30)
ans.var
aValue.var
aValue.assignVar2(40)
ans.var
aValue.var

bHandle=SimpleHandle(10)
bHandle.assignVar(20)
bHandle.var

%{
aValue = 
  SimpleValue with properties:
    var: 10
ans =
    10
ans = 
  SimpleValue with properties:
    var: 30
ans =
    30
ans =
    10
bHandle = 
  SimpleHandle with properties:
    var: 10
ans =
    20
%}