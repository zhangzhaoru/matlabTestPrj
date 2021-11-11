clear all;
clc;
memory
mValue=ImageValue(10000);
memory
mHandle=ImageHandle(10000);
memory
whos

%{
Maximum possible array:       10709 MB (1.123e+10 bytes) *
Memory available for all arrays:       10709 MB (1.123e+10 bytes) *
Memory used by MATLAB:         998 MB (1.047e+09 bytes)
Physical Memory (RAM):       12126 MB (1.272e+10 bytes)

*  Limited by System Memory (physical + swap file) available.
Maximum possible array:        9945 MB (1.043e+10 bytes) *
Memory available for all arrays:        9945 MB (1.043e+10 bytes) *
Memory used by MATLAB:        1761 MB (1.847e+09 bytes)
Physical Memory (RAM):       12126 MB (1.272e+10 bytes)

*  Limited by System Memory (physical + swap file) available.
Maximum possible array:        9180 MB (9.626e+09 bytes) *
Memory available for all arrays:        9180 MB (9.626e+09 bytes) *
Memory used by MATLAB:        2524 MB (2.647e+09 bytes)
Physical Memory (RAM):       12126 MB (1.272e+10 bytes)

whos mHandle
  Name         Size            Bytes  Class          Attributes

  mHandle      1x1               112  ImageHandle              

whos mValue
  Name        Size                Bytes  Class         Attributes

  mValue      1x1             800000104  ImageValue              

whos
  Name         Size                Bytes  Class          Attributes

  mHandle      1x1                   112  ImageHandle              
  mValue       1x1             800000104  ImageValue               

%}