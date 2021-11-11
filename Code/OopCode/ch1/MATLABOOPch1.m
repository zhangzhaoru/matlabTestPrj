%% 
t=timer;
%{
   Timer Object: timer-1

   Timer Settings
      ExecutionMode: singleShot
             Period: 1
           BusyMode: drop
            Running: off

   Callbacks
           TimerFcn: ''
           ErrorFcn: ''
           StartFcn: ''
            StopFcn: ''
%}
properties(t);
%{
Properties for class timer:

    AveragePeriod
    BusyMode
    ErrorFcn
    ExecutionMode
    InstantPeriod
    Name
    ObjectVisibility
    Period
    Running
    StartDelay
    StartFcn
    StopFcn
    Tag
    TasksExecuted
    TasksToExecute
    TimerFcn
    Type
    UserData
%}
methods(t)
%{
Methods for class timer:

ctranspose    end           horzcat       isvalid       properties    
startat       timer         vertcat       delete        eq            
inspect       length        set           stop          timercb       
wait          disp          fieldnames    isempty       ne            
size          subsasgn      timerfind     waitfor       display       
get           isequal       openvar       start         subsref       
timerfindall  

%}

%% 
clc;
N=Noddle;
properties(N)
methods(N)
%{
Properties for class Noddle:

    type
    state


Methods for class Noddle:

Noddle  boil    
%}
%% CALL FUNCTIONS CALL MEMBER METHOD
noodle=Noodle();%call function
noodle.boil();%call member method
fileobj=FileClass(filename,path);
a=fileobj.data;
%access member properties, data, and assigns it to external
%variable,a.
%% 

