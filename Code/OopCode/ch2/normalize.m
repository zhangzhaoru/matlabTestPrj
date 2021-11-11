function normalize(obj)
    mag=sqrt(obj.x^2+obj.y^2);
    obj.x=obj.x/mag;
    obj.y=obj.y/mag;
end