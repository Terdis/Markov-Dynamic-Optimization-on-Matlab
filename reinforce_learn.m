function [policies_opt] = reinforce_learn(S, A, state_beg, k_max, policies, lambda)

%This Function implements the Q-Fact with RL Algorithm.

policies_opt = zeros(S, 1);

Q_old = zeros(S, A);
Q_new = zeros(S, A);
state_old = state_beg;
k = 0;

while k < k_max
    
    k = k+1;
    alpha = log(k)/k;
    a = unidrnd(A);
    transpr = policies(a).transaction(state_old, :);
    state_new = find(mnrnd(1, transpr));
    
    Q_new(state_old, a) = (1-alpha)*Q_old(state_old, a) + ...
                        alpha*(policies(a).reward(state_old, state_new) + ...
                        lambda*max(Q_old(state_new, :)));
    
    state_old = state_new;
    Q_old = Q_new;
end

for i = 1:S
    [~, index] = max(Q_new(i, :));
    policies_opt(i) = index;
end

end
