% Using FaceBook_3_4
% At begining, the Class, FaceBook, is FaceBook3
clear classes;
obj=FaceBook;
obj.name='Xiao';
obj.address='Prime Parkway';
obj
%{
obj = 

  FaceBook with properties:

       name: 'Xiao'
    address: 'Prime Parkway'
%}
save('XiaoFaceBook.mat','obj');
clear classes;
% Then change the class, FaceBook, to FaceBook4.
% After that run the Script2P106

