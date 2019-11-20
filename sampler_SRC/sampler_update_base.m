function [C, B_new] = sampler_update_base( s, K, B_old, params )
% Samples a new base measure and updates the state transition counts

%% Compute transition counts
C = zeros(K+1);
C(K+1,s(1)) = 1;
for i=2:length(s)
    C( s(i-1), s(i) ) = C( s(i-1), s(i) ) + 1;
end
clear i


%% Sample B

B_new = B_old;

for rep = 1:params.Brep

    M = zeros( K+1, K );
    Arm = repmat(params.a*B_new,K+1,1);
    for jk = find(C>0)'
        M(jk) = sum( rand(1,C(jk)) < Arm(jk)./( (0:C(jk)-1) + Arm(jk) ) );
    end
    clear jk

    B_new = dirrnd([sum(M,1), params.g]);

end
