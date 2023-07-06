function [last_arrival_time_out] = generator(ArrivalRate, last_arrival_time, id, queue)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
next_customer = Customer(id);
InterArrivalDist = makedist("Exponential","mu",1/ArrivalRate);
inter_arrival_time = random(InterArrivalDist);
arrival = Arrival(last_arrival_time + inter_arrival_time, next_customer);
queue.schedule_event(arrival);
last_arrival_time_out = last_arrival_time + inter_arrival_time;
end