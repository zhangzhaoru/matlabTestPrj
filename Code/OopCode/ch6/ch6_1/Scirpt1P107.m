% Using FaceBook_7_8
% At begining, the Class, FaceBook, is FaceBook5
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
% Then change the class, FaceBook, to FaceBook6.
% After that run the Script4P106
