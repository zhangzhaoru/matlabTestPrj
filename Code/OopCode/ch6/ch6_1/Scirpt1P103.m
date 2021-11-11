% Using FaceBook_1_2
% At begining, the Class, FaceBook, is FaceBook1
clear classes;
obj=FaceBook;
obj.name='Xiao';
obj
save('XiaoFaceBook.mat','obj');
clear classes;
% Then change the class, FaceBook, to FaceBook2.
% After that run the Script2P103


% Result
%{
Scirpt1P103

obj = 

  FaceBook with properties:

       name: 'Xiao'
    address: 'Prime Parkway'
%}