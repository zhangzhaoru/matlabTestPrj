function funcBottom()
   objD=D336();
   expObj=MException('id:Test','msg');
   throw(expObj);
   disp('will not reach here')
end
