% º∆À„ ”œﬂΩ«
function [SightEle,SightAzi] = CalSightAngle(PlatEle,PlatAzi,PlatRoll,WavepointEle,WavepointAzi)

A = -cosd(PlatEle)*sind(PlatAzi)*cosd(WavepointAzi)+...
    tand(WavepointEle)*(sind(PlatEle)*sind(PlatAzi)*cosd(PlatRoll)+sind(PlatRoll)*cosd(PlatAzi))-...
    sind(WavepointAzi)*(cosd(PlatAzi)*cosd(PlatAzi)-sind(PlatEle)*sind(PlatRoll)*sind(PlatAzi));


B = cosd(PlatEle)*cosd(PlatAzi)*cosd(WavepointAzi)+...
    tand(WavepointEle)*(sind(PlatAzi)*sind(PlatRoll)-sind(PlatEle)*cosd(PlatAzi)*cosd(PlatRoll))-...
    sind(WavepointAzi)*(sind(PlatEle)*cosd(PlatAzi)*sind(PlatRoll)+cosd(PlatRoll)*sind(PlatAzi));

SightEle = asind(sind(PlatEle)*cosd(WavepointEle)*cosd(WavepointAzi)+...
    sind(WavepointEle)*cosd(PlatEle)*cosd(PlatRoll)+cosd(WavepointEle)*sind(WavepointAzi)*cosd(PlatEle)*sind(PlatRoll));
SightAzi = atand(-A/B);
end

