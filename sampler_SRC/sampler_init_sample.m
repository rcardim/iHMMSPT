function [s_traj, K_scal, B_stsp, O_stsp, P_stsp, F_stsp,i] = sampler_init_sample( x, opts, params )
% this function initializes a MCMC chain

i = 0;
s_traj = discretize(x,linspace(min(x),max(x),opts.K_init+1));
K_scal = max(s_traj);
B_stsp = dirrnd( [ones(1,K_scal),params.g] );

P_stsp = repmat(params.a*B_stsp,K_scal,1) + eye(K_scal,K_scal+1);
for j=1:K_scal
    P_stsp(j,:) = dirrnd( P_stsp(j,:) );
end

O_stsp = ones(1,K_scal+1)/(K_scal+1);

F_stsp = sampler_update_emission_model( [], [], [], K_scal, params);

