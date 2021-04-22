addpath( [pwd '\sampler_SRC'])
%% directories
dirIN=pwd;
%% Data Load
%data has to be displacements (1-D); if 2-D or 3-D: use new dimensions as chains
%multiple chains for >1 dimension
fname='Displacements-4.mat';
load(fullfile(dirIN,fname));
handles.x=DataX(:,1)'; %DataX comes from 'Displacements-4.mat' 
error=0; %experimental error
%% Iteration steps
% Number of iterations and percentage of burn-in steps.
r_total=5000; % total number of steps 
per=0.15; % percentage of steps on burn-in phase
r_burnin=per*r_total;
r_max=(1-per)*r_total;
%% Hyperparameters and other variables for the algorithm
opts.K_init = 10; %initial number of states
opts.a = 1; %hyperparameter alpha of the Dirichlet Process (transition probabilities concentration)
opts.g = 0.05; %hyperparameter gamma of the stick breaking process (base concentration)
opts.Q = [0,0,1,0.1]; %hyperparameter of emission distribution (conjugacy model: the first two is for mean, where we set to 0 for SPT.)-->[0,0,2*a,b/a)](a and b from eq.2)
opts.dr_sk = 1;
number_of_burnins=5; %implementation parameters
%burn-in
best_burnin=burnin_main(handles.x,r_burnin,error,opts,number_of_burnins);
%after burn-in
chain_final = chainer_main(handles.x, r_max, best_burnin, opts, true);
%% Saving Results
save('results-4.mat','chain_final');


