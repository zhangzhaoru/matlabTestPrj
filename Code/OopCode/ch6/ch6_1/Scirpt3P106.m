% Using FaceBook_5_6
% At begining, the Class, FaceBook, is FaceBook5
clear classes;
obj=FaceBook;
obj.name='Xiao';

obj
%{
obj = 

  FaceBook with properties:

    name: 'Xiao'
%}
save('XiaoFaceBook.mat','obj');
clear classes;
% Then change the class, FaceBook, to FaceBook6.
% After that run the Script4P106
