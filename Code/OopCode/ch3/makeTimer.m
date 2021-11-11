function makeTimer()
    t=timer('TimerFunc',@mycallback,'period',...
        1.0,'ExecutionMode','fixedSpacing');
    start(obj.t)
end

        