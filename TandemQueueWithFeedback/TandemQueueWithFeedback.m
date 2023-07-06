clc, clear all;
ArrivalRate = 0.5;
ServiceRate  = 1/1.5;
last_arrival_time = 0;
id = 0;
q1 = ServiceQueue(LogInterval=10, DepartureRate = 1.4);
q2 = ServiceQueue(LogInterval=10);
Queues = {q1, q2};
n_samples = 1;
max_time = 10000;
busy_time= 0;
expected_T_1 = 0;
expected_n_1 = 0;

expected_T_2 = 0;
expected_n_2 = 0;
for sample_num = 1:n_samples
    n_in_queue_1 = [];
    n_in_queue_2 = [];
    q1 = ServiceQueue(LogInterval=10);
    q2 = ServiceQueue(LogInterval=10);
    q1.dest_q = q2;
    q2.source_q = q1;
    while q1.Time < max_time 
      last_arrival_time = generator(ArrivalRate, last_arrival_time, id, q1);
      q1.handle_next_event();
      q2.handle_next_event();
      id = id + 1;
    end
    id = 0;
    last_arrival_time  = 0;
    n_in_queue_1 = [n_in_queue_1, q1.Log.NWaiting + q1.Log.NInService];
    n_in_queue_2 = [n_in_queue_2, q2.Log.NWaiting + q2.Log.NInService];
    busy_time = busy_time + q2.busy_time + q1.busy_time;

    r = size(n_in_queue_1);
    expected_n_1 = sum(n_in_queue_1)/r(1) + expected_n_1;
    r = size(q1.time_in_system);
    expected_T_1 = sum(q1.time_in_system)/r(2) + expected_T_1;

    r = size(n_in_queue_2);
    expected_n_2 = sum(n_in_queue_2)/r(1) + expected_n_2;
    r = size(q1.time_in_system);
    expected_T_2 = sum(q2.time_in_system)/r(2) + expected_T_2;
    stationary_dist(n_in_queue_1, n_in_queue_2)
end

expected_T_1 = expected_T_1/n_samples
expected_n_1 = expected_n_1/n_samples
landa_1 = expected_n_1/expected_T_1


expected_T_2 = expected_T_2/n_samples
expected_n_2 = expected_n_2/n_samples
landa_2 = expected_n_2/expected_T_2
rho = busy_time/(n_samples * max_time*2);
