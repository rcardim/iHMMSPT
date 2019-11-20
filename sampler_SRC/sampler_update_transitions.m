function [O,P] = sampler_update_transitions( K, C, B, params )
% sample a new transitons matrix

O = dirrnd( C(K+1,:) + params.a*B );
    
P = nan(K,K+1);
for j=1:K
    P(j,:) = dirrnd( C(j,:) + params.a*B );
end

