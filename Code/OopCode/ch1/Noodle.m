% DEFINE A CLASS CALLED NOODLE.m
classdef Noodle<handle
    properties
        type
        state
    end
    methods
        function boil(obj)
            obj.state = 'done';
        end
    end
end
