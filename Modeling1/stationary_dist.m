function [p_1, p_2, p] = stationary_dist(n_1, n_2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
n_t = [n_1, n_2];
u = unique(n_t);
p = [];
p_1 = [];
p_2 = [];
for k = 1:length(u)
    x = u(k);
    p =[p, sum(n_t==x,'all')];
    p_1 =[p_1, sum(n_1==x,'all')];
    p_2 =[p_2, sum(n_2==x,'all')];
end
p
p_1
p_2
end