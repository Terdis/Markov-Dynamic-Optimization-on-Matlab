function [reward_mean] = calculate_reward(policy, state_beg, lambda,...
                                        n_sim, rep)


%We choose an initial state state_beg. In each iteration we simulate the
%new state state_new according to the probability of the row a of the
%transaction matrix of the policy [find(mnrnd(1, transpr))] 

tot_rew_v = zeros(rep, 1);
for k = 1:rep
    tot_rew = 0;
    state_old = state_beg;
    for i = 1:n_sim
        
        transpr = policy.transaction(state_old, :);
        state_new = find(mnrnd(1, transpr));
        tot_rew = tot_rew+(lambda^(k-1))*(policy.reward(state_old,state_new));
        state_old = state_new;
    
    end
    tot_rew_v(k) = tot_rew;
end

reward_mean = mean(tot_rew_v);

end