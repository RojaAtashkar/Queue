classdef PositiveSignal
    properties
        Time;
        degree;
    end
    methods
        function obj = PositiveSignal(Time, degree)
            arguments
                Time = 0.0;
                degree = 1;
            end
            obj.Time = Time;
            obj.degree = degree;
        end
        function varargout = visit(obj, other)
            [varargout{1:nargout}] = handle_posSignal(other, obj);
        end
    end
end