fiveHandle=RMBHandle(5)
fiveHandle.times(2)

fiveValue=RMBValue(5)
ten1=fiveValue.times(2)
ten2=fiveValue.plus(RMBValue(5))

%{
obj = 
  RMBHandle with properties:
    amount: 5
fiveHandle = 
  RMBHandle with properties:
    amount: 5
obj = 
  RMBHandle with properties:
    amount: 10
fiveValue = 
  RMBValue with properties:
    amount: 5
ten1 = 
  RMBValue with properties:
    amount: 10
ten2 = 
  RMBValue with properties:
    amount: 10
%}