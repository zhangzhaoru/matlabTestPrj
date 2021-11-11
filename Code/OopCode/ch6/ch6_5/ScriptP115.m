obj=Calculation1()
%{
calculator1 called

obj = 

  Calculation1 with properties:

            results1: []
    intermediateVal1: 'initialValue'
%}
obj.results1='essential'
%{
obj = 

  Calculation1 with properties:

            results1: 'essential'
    intermediateVal1: 'initialValue'
%}
save test.mat
load test.mat
%{
calculator1 called
%}
obj
%{
obj = 

  Calculation1 with properties:

            results1: 'essential'
    intermediateVal1: 'initialValue'
%}
% obj.intermediateVal='assignedValue'
% No public property intermediateVal exists for class Calculation1.
% 
% Error in ScriptP115 (line 35)
% obj.intermediateVal='assignedValue'