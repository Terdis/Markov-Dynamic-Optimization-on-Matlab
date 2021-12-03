function [q] = q_calc(a, i, Q_old, lambda, policy, N)

%This function gets the Q_new(i, a). Was this function necessary? No. IDK Why I
%created it.

q = 0;

for j = 1:N
    q = q + policy.transaction(i, j)*(policy.reward(i, j) ...
                    + lambda*max(Q_old(j, :)));
end

end