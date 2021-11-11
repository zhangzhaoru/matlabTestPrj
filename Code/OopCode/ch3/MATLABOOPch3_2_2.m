clear all;
clc;
memory
mValue=ImageValue(10000);
memory
mHandle=ImageHandle(10000);
memory
nValue=mValue;
nHandle=mHandle;
whos

%{
Maximum possible array:       10339 MB (1.084e+10 bytes) *
Memory available for all arrays:       10339 MB (1.084e+10 bytes) *
Memory used by MATLAB:         982 MB (1.030e+09 bytes)
Physical Memory (RAM):       12126 MB (1.272e+10 bytes)

*  Limited by System Memory (physical + swap file) available.
Maximum possible array:        9575 MB (1.004e+10 bytes) *
Memory available for all arrays:        9575 MB (1.004e+10 bytes) *
Memory used by MATLAB:        1745 MB (1.830e+09 bytes)
Physical Memory (RAM):       12126 MB (1.272e+10 bytes)

*  Limited by System Memory (physical + swap file) available.
Maximum possible array:        8810 MB (9.238e+09 bytes) *
Memory available for all arrays:        8810 MB (9.238e+09 bytes) *
Memory used by MATLAB:        2508 MB (2.630e+09 bytes)
Physical Memory (RAM):       12126 MB (1.272e+10 bytes)

*  Limited by System Memory (physical + swap file) available.
  Name         Size                Bytes  Class          Attributes

  mHandle      1x1                   112  ImageHandle              
  mValue       1x1             800000104  ImageValue               
  nHandle      1x1                   112  ImageHandle              
  nValue       1x1             800000104  ImageValue              
%}