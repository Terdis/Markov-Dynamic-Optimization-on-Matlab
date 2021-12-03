function [avg_rew] = sim_opt(rep, state_beg, n_sim, policies, ...
                    policies_opt, lambda)

%After the Q-Fact algorithm and the Q-Fact with RL algorithm I get a vector
%that associate each i-state in S with his optimal policy a in A. This
%function simulate the avg reward where for each i-state and future
%(i+1)-state I use the proper policy to get the average reward

tot_rew_v = zeros(rep, 1);

for k = 1:rep
    tot_rew = 0;
    state_old = state_beg;
    for i = 1:n_sim
        transpr = policies(policies_opt(state_old)).transaction(state_old, :);
        state_new = find(mnrnd(1, transpr));
        tot_rew = tot_rew+(lambda^(k-1))*(policies(policies_opt(state_old)).reward(state_old,state_new));
        state_old = state_new;
    end
    tot_rew_v(k) = tot_rew;
end

avg_rew = mean(tot_rew_v);

end