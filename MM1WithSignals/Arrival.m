classdef Arrival
    properties
        Time;
        Customer;
    end
    methods
        function obj = Arrival(Time, Customer, q_index)
            arguments
                Time = 0.0;
                Customer = [];
                q_index = 1;
            end
            obj.Time = Time;
            obj.Customer = Customer;
        end
        function varargout = visit(obj, other)
            [varargout{1:nargout}] = handle_arrival(other, obj);
        end
    end
end