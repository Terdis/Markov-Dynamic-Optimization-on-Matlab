function [policies_m] = create_policies_matrix(actions, policies, N)

%Now I am creating the matrix for the policies associated with the
%respective action and the respective reward.

 policies_m = [struct('transaction', {}, 'reward', {})];

for i = 1:length(policies)
    P = zeros(N);
    R = zeros(N);
    
    for j = 1:N
        P(j, :) = [actions(policies(i, j)).transaction(j, :)];
        R(j, :) = [actions(policies(i, j)).reward(j, :)];
    end

    policies_m(i) = struct('transaction', P, 'reward', R);
    
    if(i+1 < N)
        policies_m = [policies_m; struct('transaction', {}, 'reward', {})];
    end
end

%So in this cycle I created the matrices correlated with the policies mu(i)
%as a vector of struct policies_m.

end