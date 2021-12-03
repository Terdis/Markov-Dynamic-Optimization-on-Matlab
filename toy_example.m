%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       TOY PROBLEM on simulation, and brute force evaluation of J(i)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all;
P1=[0.9 0.1; 
     0.2 0.8];

R1=[10 17; 
    -14 13];

rep=400;
kmax=1000;
lambda=0.99;

tot_rew_vec=zeros(1,rep);

for r=1:rep
    state_old=2;
    tot_rew=0;
    for k=1:kmax
        % chose an action
        transpr=P1(state_old,:);
        state_new=find(mnrnd(1,transpr));
        tot_rew=tot_rew+(lambda^(k-1))*(R1(state_old,state_new));
        state_old=state_new;
    end
    tot_rew_vec(r)=tot_rew;
end
mean(tot_rew_vec)


    