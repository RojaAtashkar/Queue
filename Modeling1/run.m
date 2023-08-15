 clc, clear all;
max_time = 10000;
busy_time_1= [];
busy_time_2= [];
rho_1 = [];
rho_2 = [];


expected_T_1 = [];
expected_n_1 = [];
expected_T_2 = [];
expected_n_2 = [];
for l = 1:0.1:1.4
    

    last_arrival_time = 0;
    n_in_queue_1 = [];
    n_in_queue_2 = [];
    q1 = ServiceQueue(LogInterval=10);
    q1.DepartureRate = l;
    q2 = ServiceQueue(LogInterval=10);
    q2.DepartureRate = 2;
    q1.dummy_q = q2;
    id = 0;
    while q1.Time < max_time 
      last_arrival_time = generator(q1.ArrivalRate, last_arrival_time, id, q1);
      q1.handle_next_event();
      q2.handle_next_event();
      id = id + 1;
    end
    id = 0;
    last_arrival_time  = 0;
%     n_in_queue_1 = [n_in_queue_1, q1.Log.NWaiting + q1.Log.NInService];
%     n_in_queue_2 = [n_in_queue_2, q2.Log.NWaiting + q2.Log.NInService];
    busy_time_1 = [busy_time_1, q1.busy_time];
    busy_time_2 = [busy_time_2, q2.busy_time];
%     
%     r = size(n_in_queue_1);
%     expected_n_1 = [expected_n_1, sum(n_in_queue_1)/r(1)];
%     r = size(q1.time_in_system);
%     expected_T_1 = [expected_T_1, sum(q1.time_in_system)/r(2)];
% 
%     r = size(n_in_queue_2);
%     expected_n_2 = [expected_n_2, sum(n_in_queue_2)/r(1)];
%     r = size(q1.time_in_system);
%     expected_T_2 = [expected_T_2, sum(q2.time_in_system)/r(2)];

%     stationary_dist(n_in_queue_1, n_in_queue_2);
    %figure;
    l
    %h = histogram(n_in_queue_1, Normalization="probability", BinMethod="integers");
    %figure;
    %h = histogram(n_in_queue_2, Normalization="probability", BinMethod="integers");
    %n_in_system = [n_in_queue_1, n_in_queue_2];
    %figure;
    %h = histogram(n_in_system, Normalization="probability", BinMethod="integers");

end


expected_n_1
expected_T_1
landa_1 = expected_n_1./expected_T_1
expected_n_2
expected_T_2
landa_2 = expected_n_2./expected_T_2
rho_1 = busy_time_1/(max_time)
rho_2 = busy_time_2/(max_time)
expected_T = expected_T_1 + expected_T_2
expected_n = expected_n_1 + expected_n_2
l2_l1 = landa_2./landa_1
l =  0.5:0.1:0.8;
figure;
plot(l, rho_1)
figure;
plot(l, expected_n_1);
figure;
plot(l, expected_T)