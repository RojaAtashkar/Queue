classdef ServiceQueue < handle
    properties (SetAccess = public)
        ArrivalRate = 0.5;
        DepartureRate = 1.5;
        NumServers = 1;
        LogInterval = 1;
        busy_time = 0;
        dest_q;
        source_q;
        time_in_system = [];
        max_time = 8000;
        batch_size = 3;
        last_arrival_time = 0;
        dummy_q;
        id = 0;

    end
    properties (SetAccess = private)
        Time = 0;
        InterArrivalDist;
        ServiceDist;
        ServerAvailable;
        Servers;
        Events;
        Waiting;
        Served;
        Log;
    end
    methods
        function obj = ServiceQueue(KWArgs)
            arguments
                KWArgs.?ServiceQueue;
            end
            fnames = fieldnames(KWArgs);
            for ifield=1:length(fnames)
                s = fnames{ifield};
                obj.(s) = KWArgs.(s);
            end
          
            obj.ServiceDist = makedist("Exponential","mu",1/obj.DepartureRate);
            obj.ServerAvailable = repelem(true, obj.NumServers);
            obj.Servers = cell([1, obj.NumServers]);
            obj.Events = PriorityQueue({}, @(x) x.Time);
            obj.Waiting = {};
            obj.Served = {};
            obj.Log = table( ...
                Size=[0, 4], ...
                VariableNames={'Time', 'NWaiting', 'NInService', 'NServed'}, ...
                VariableTypes={'double', 'int64', 'int64', 'int64'});
            schedule_event(obj, RecordToLog(0));
        end
        function schedule_event(obj, event)
            if event.Time < obj.Time
                error('event happens in the past');
            end
            push(obj.Events, event);
        end

         function obj = run_until(obj, MaxTime)
            while obj.Time < MaxTime
                handle_next_event(obj);
            end
         end

        function handle_next_event(obj)
            if is_empty(obj.Events)
                error('no unhandled events');
            end
            event = pop_first(obj.Events);
            if obj.Time > event.Time
                error('event happened in the past');
            end
            obj.Time = event.Time;
            visit(event, obj);
        end
        function handle_arrival(obj, arrival)
            c = arrival.Customer;
            c.ArrivalTime = obj.Time;
            obj.Waiting{end+1} = c;
            % Schedule next arrival...
            advance(obj);
        end
      
         function handle_partial_departure(obj)
            x = 0;
            if length(obj.Waiting) >=obj.batch_size-1
                x=obj.batch_size-1;
            else
                x = length(obj.Waiting);
            end
            for i=1:x
               obj.Waiting(1) = [];
            end
            
             end

        function handle_departure(obj, departure)
            j = departure.ServerIndex;
            customer = obj.Servers{j};       
             customer.DepartureTime = departure.Time;
            obj.time_in_system = [obj.time_in_system, -customer.ArrivalTime + customer.DepartureTime];
            obj.Served{end+1} = customer;
            obj.Servers{j} = false;
            obj.ServerAvailable(j) = true;  
             if ~ isempty(obj.dummy_q)
             arrival = Arrival(obj.dummy_q.Time, customer);
             obj.dummy_q.schedule_event(arrival);

            end
            advance(obj)
        end



        function begin_serving(obj, j, customer)
            customer.BeginServiceTime = obj.Time;
            obj.Servers{j} = customer;
            obj.ServerAvailable(j) = false;
            service_time = random(obj.ServiceDist);
            if obj.Time < obj.max_time * 0.9 && obj.Time > obj.max_time * 0.1
            obj.busy_time = obj.busy_time + service_time;
            end
            obj.schedule_event(Departure(obj.Time + service_time, j));
        end
        function advance(obj)
            % If someone is waiting
            if length(obj.Waiting) > 0
                % If a server is available
                [x, j] = max(obj.ServerAvailable);
                if x
                    % Move the customer from Waiting list
                    customer = obj.Waiting{1};
                    obj.Waiting(1) = [];
                    % and begin serving
                    handle_partial_departure(obj);
                    begin_serving(obj, j, customer);
                end
            end
        end
        function handle_record_to_log(obj, record)
            %record_log(obj);
            %schedule_event(obj, RecordToLog(obj.Time + obj.LogInterval));
        end
        function record_log(obj)
            if obj.Time < obj.max_time * 0.9 && obj.Time > obj.max_time * 0.1
            NWaiting = length(obj.Waiting);
            NInService = obj.NumServers - sum(obj.ServerAvailable);
            NServed = length(obj.Served);
            obj.Log(end+1, :) = {obj.Time, NWaiting, NInService, NServed};
            end
        end
    end
end