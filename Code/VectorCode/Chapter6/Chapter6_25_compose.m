function ans = Chapter6_25_compose(varargin)
kMain=nargin                % �������е���������
ans=@fcn;
    function ans = fcn(ans)
    kSub=nargin             % �Ӻ�������������
        for i = fliplr(1:numel(varargin))
            ans=varargin{i}(ans);
        end
    end
end

