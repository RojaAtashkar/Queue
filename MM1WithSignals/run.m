clc, clear all;8765
ArrivalRate = 0.5;
ServiceRate  = 1/1.5;
id = 0;
q1 = ServiceQueue(LogInterval=10);
n_samples = 10;
max_time = 1000;
busy_time= 0;
expected_T_1 = 0;
expected_n_1 = 0;

for sample_num = 1:n_samples
    n_in_queue_1 = [];
    q1 = ServiceQueue(LogInterval=10);
    q1.source_q = q1;
    while q1.Time < max_time 
     q1.last_arrival_time = generator(ArrivalRate, q1.last_arrival_time, q1.id, q1);
      q1.handle_next_event();
      q1.id =q1.id + 1;
    end
    n_in_queue_1 = [n_in_queue_1, q1.Log.NWaiting + q1.Log.NInService];
    busy_time = busy_time + q1.busy_time;

    r = size(n_in_queue_1);
    expected_n_1 = sum(n_in_queue_1)/r(1) + expected_n_1;
    r = size(q1.time_in_system);
    expected_T_1 = sum(q1.time_in_system)/r(2) + expected_T_1;

  
end

expected_T_1 = expected_T_1/n_samples
expected_n_1 = expected_n_1/n_samples
landa_1 = expected_n_1/expected_T_1

rho = busy_time/(n_samples * max_time)
