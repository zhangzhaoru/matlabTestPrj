% P104
clear all;
oRef=ARef
%{
oRef = 

  ARef with properties:

    matrix: []
%}
isvalid(oRef)
%{
ans =

     1
%}
oRef.delete()
save
%{
Saving to: F:\MATLABOOP\ch6\matlab.mat
%}
isvalid(oRef)
%{
ans =

     1
%}
clear all;
% isvalid(oRef)
%{
Undefined function or variable 'oRef'.

Error in Scirpt1P104 (line 24)
isvalid(oRef)
%}
load;
%{
 Loading from: matlab.mat
%}
oRef
%{
oRef = 

  handle to deleted ARef
%}
isvalid(oRef)
%{
ans =

     0
%}