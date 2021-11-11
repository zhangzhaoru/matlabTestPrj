clear all;
clc;

Marc=CustomerValue('Marc','Boston');
Steve=CustomerValue('Steve','Cambridge');

o1=OrderValue('O0001',Marc);
o2=OrderValue('O0002',Marc);
o3=OrderValue('O0003',Steve);

Marc.address='Natick';
o1.customer
o2.customer

Marc=CustomerHandle('Marc','Boston');
Steve=CustomerHandle('Steve','Cambridge');

o1=OrderValue('O0001',Marc);
o2=OrderValue('O0002',Marc);
o3=OrderValue('O0003',Steve);

Marc.address='Natick';
o1.customer
o2.customer

%{
ans = 
  CustomerValue with properties:
       name: 'Marc'
    address: 'Boston'
ans = 
  CustomerValue with properties:
       name: 'Marc'
    address: 'Boston'
ans = 
  CustomerHandle with properties:
       name: 'Marc'
    address: 'Natick'
ans = 
  CustomerHandle with properties:
       name: 'Marc'
    address: 'Natick'
%}