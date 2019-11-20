function [loggamma] = Segmentation_of_states_K(K,D,T,stationary,sq_dis,delta_t)
%% Determine the most likely individual state (free or bound) at each step of an observed 2-D displacement sequence. K is the number of states, D is the vector with the diffusion coefficient for each
%% state and T is the transition matrix.
%% Calculate logs of stationary probabilities and the transition matrix for the given transition probabilities
n = length(sq_dis);
logtrans = log(T);
logtransprime = logtrans';
logstat = log(stationary);
%% Calculate log-likelihood of Df and Db for the observed square displacements.
LLD(:,1:K) = -sq_dis./(4*D*delta_t) - log(D*delta_t);
%% Recursively calculate log of the forward variable alpha
logalpha = zeros(n, K);
logalpha(1, :) = logstat + LLD(1, :);
for i = 2:n
    A = (logalpha(i-1, :) + logtrans')';
    logalpha(i, :) = LLD(i, :) + logsumG(A);
    clear A
end

%% Recursively calculate log of the backward variable beta
logbeta = zeros(n, K);
for j = n-1:  -1: 1
    B=(logtransprime' + LLD(j+1,:) + logbeta(j+1, :))';
    logbeta(j, :) = logsumG(B);
    %     logbeta(j, :) = logsum( logtransprime(1, :) + LLD1(j+1) + logbeta(j+1, 1) ,  logtransprime(2, :) + LLD2(j+1) + logbeta(j+1, 2) );
   clear B
end

%% Determine the most likely individual states
loggamma = logalpha + logbeta;
% [frame,state]= find(loggamma==max(loggamma));
% best=[frame state];
% beststateguess=sortrows(best);
% beststateguess = 1+double( loggamma(:,2) > loggamma(:, 1) );
end
