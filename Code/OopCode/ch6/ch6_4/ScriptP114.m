obj=Calculation()
%{
calculattor called

obj = 

  Calculation with properties:

            results: []
    intermediateVal: 'disposable'
%}
obj.results='essential'
%{
obj = 

  Calculation with properties:

            results: 'essential'
    intermediateVal: 'disposable'

%}
save test.mat
load test.mat
obj
%{
obj = 

  Calculation with properties:

            results: 'essential'
    intermediateVal: []
%}