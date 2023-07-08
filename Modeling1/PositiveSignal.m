classdef PositiveSignal
    properties
        Time;
  
    end
    methods
        function obj = PositiveSignal(Time)
            arguments
                Time = 0.0;
             
            end
            obj.Time = Time;
        end
        function varargout = visit(obj, other)
            [varargout{1:nargout}] = handle_posSignal(other, obj);
        end
    end
end