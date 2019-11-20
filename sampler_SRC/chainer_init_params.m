function params = chainer_init_params(x,opts)
% This function initializes chain parameters

%% Concentrations

params.a = opts.a;
params.g = opts.g;

%% priors for the emission parameters

params.Q = opts.Q;


%% other sampler's parameters

params.Brep =10;
params.Frep =10;

