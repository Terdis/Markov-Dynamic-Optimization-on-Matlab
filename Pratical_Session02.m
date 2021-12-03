clear all;
clc;

%%

n = 1000;
lambda = 0.99;
S = 2;                                      %N represents the number of state
n_sim = 1000;
rep = 400;
A = 4;                                      %A Number of policies

P1 = [0.7 0.3;
      0.4 0.6];
R1 = [6 -5;
      7 12];
P2 = [0.9 0.1;
      0.2 0.8];
R2 = [10 17;
      -14 13];


actions = [struct('transaction', P1, 'reward', R1), ... 
           struct('transaction', P2, 'reward', R2)];

policies = [1 1;
            1 2;
            2 1;
            2 2];

%For the selecting of the state use the multinomial mnrnd and find command,
%Look up to the solution in case.

%%    Allocation of the policies matrix and Calculus of the Average Reward

% We'll simulate the average reward for each k-policy
%The create_policies_matrix gets the P, R matricies associated with each
%policy in a struct vector of A elements

policies_v = create_policies_matrix(actions, policies, S);
reward_v = zeros(length(policies), 1);

for k = 1:A
    reward_v(k) = calculate_reward(policies_v(k), 2, lambda, ...
                    n_sim, rep);
end 

%%    Calculation of the Q-Factor and Finding of the Optimal Policy

%This section implements the Q-Factor Algorithm to find the best policy
%associated with each state in S.

k = 1;                                   %Iterator
eps = 0.01;

Q_old = zeros(S, A);                
Q_new = zeros(S, A);
J_old = zeros(S, 1);
J_new = zeros(S, 1);

max_iter = 1e5;                          %I'm setting an upper limit for the iterations
stop_val = eps*(1-lambda)/(2*lambda);

while k < max_iter
    for i = 1:S
        for a = 1:A
            Q_new(i, a) = q_calc(a, i, Q_old, lambda, ...
                                 policies_v(a), S);
        end

        J_old(i) = max(Q_old(i, :));
        J_new(i) = max(Q_new(i, :));
        Q_old = Q_new;

    end


    if norm(J_new - J_old, "inf") < stop_val
        break
    end

    k = k+1;   
end

policies_opt = zeros(S, 1);

for i = 1:S
    [~, policies_opt(i)] = max(Q_old(i, :));
end

%%           SIMULATE THE PROCESS WITH THE OPTIMAL POLICIES


avg_rew = sim_opt(rep, 2, n_sim, policies_v, policies_opt, lambda);

%%          REINFORCEMENT LEARNING  

policies_opt_rl = reinforce_learn(S, A, 2, n_sim, policies_v, lambda);

avg_rew_rl = sim_opt(rep, 2, n_sim, policies_v, policies_opt_rl, lambda);


%%          CONFRONTING DATA

fig = figure(1);
subplot(2, 2, 1)
bar(reward_v, 'red')
xlabel('Policies');
ylabel('Average Reward');
title('Average Reward Confronting Data');
legend('AVG reward per policy', 'Location', 'northwest');
fig.Children(2).FontSize = 10;
subplot(2, 2, 2)
bar(reward_v, 'red')
hold on
bar(A+1, avg_rew, 'blue')
hold off
xlabel('Policies');
ylabel('Average Reward');
title('Average Reward Confronting Data');
legend('AVG reward per policy', 'Q-Fact Optimal Policies',...
    'Location', 'northwest');
fig.Children(2).FontSize = 10;
subplot(2, 2, [3 4])
bar(reward_v, 'red')
hold on
bar(A+1, avg_rew, 'blue')
hold on
bar(A+2,avg_rew_rl, 'black')
hold off
xlabel('Policies');
ylabel('Average Reward');
title('Average Reward Confronting Data');
legend('AVG reward per policy', 'Q-Fact Optimal Policies', ...
    'RL Optimal Policies', 'Location','northwest');
fig.Children(1).FontSize = 10;
fig.Children(2).FontSize = 10;
fig.Children(3).FontSize = 10;