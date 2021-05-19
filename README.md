# iHMMSPT

infinite hidden Markov model for Single-Particle trajectories: a nonparametrics Bayesian framework to estimate the number of states, the diffusivities and transition probabilities.

Code to run: main.m

Below is an example of how to run the iHMMSPT model (main.m). \
First line of the code adds the directory of the sampler.\

```
addpath( [pwd '\sampler_SRC']) % adding path to sampler
```

Next, we need to load the data, If the data is not on the same directory as the code, we need to specify the path.

```
%% directories
dirIN=pwd; %pwd local directory
%% Data Load
fname='Displacements-4.mat';
load(fullfile(dirIN,fname));
```

The data should be a vector where each value is the displacement for that time frame. 
If we have a 2-D or 3-D displacements, we treat each dimension as a new chain, and concatanate all data in one vector.
For example, let x=[...], y=[...], and z=[...] be column vectors, then the final data should be a column vector a swell. In MATLAB code: xyz=[x; y; z]
Once the data is loaded, and processed, we need to add it to the sampler input (handles):

```
handles.x=DataX(:,1)'; %data
```

After, we set the experimental errors. If no experimental error (simulated data), set it to 0:

```
error=0;  %experimental error
```

Next, we need to specify the number of iterations and the percentage of steps that is from the burn-in phase. This percentage of steps we do not use on the estimation of parameters. Here, we define 5000 steps, where 15% is burn-in.

```
%% Iteration steps % Number of iterations and percentage of burn-in steps
r_total=5000; % total number of steps
per=0.15; % percentage of steps on burn-in phase
r_burnin=per*r_total;
r_max=(1-per)*r_total;
```

After, we set the hypermarameters of the model, the initial number of states, and the number of burn-ins.

```
%% Hyperparameters and other variables for the algorithm\
opts.K_init = 10; %initial number of states\
opts.a = 1; %hyperparameter alpha of the Dirichlet Process (transition probabilities concentration)\
opts.g = 0.05; %hyperparameter gamma of the stick breaking process (base concentration)\
opts.Q = [0,0,1,0.1]; %hyperparameter of emission distribution (conjugacy model: the first two is for mean, where we set to 0 for SPT.)-->[0,0,2*a,b/a)](a and b from eq.2)\
opts.dr_sk = 1;\
number_of_burnins=5; %implementation parameters\
%burn-in\
best_burnin=burnin_main(handles.x,r_burnin,error,opts,number_of_burnins);\
%after burn-in\
chain_final = chainer_main(handles.x, r_max, best_burnin, opts, true);\
%% Saving Results\
save('results-4.mat','chain_final');
```



Code to create plots: somePlots.m


First we load the iHMMSPT results, input the number of burn-in setps, and set the data parameters (frame duration and pixel size).
TO DO: number of burn-in steps loaded from results instead of manually.
```
%% Script to plot some graphs of states and diffusion
%% load Results
load('results-3.mat')
%% the number of burn-in steps
burn_in=750;% burn-in steps
%% setting parameters of experimental data
tau=0.001; %tau = sampling time = 1/frame_rate (1/s)
pixel_size=1; % size of 1 pixel in microns (for simulated data is 1)

```
* Plot of number of states at each iteration.
```
%% Plot states chain
fig1=figure
plot(chain_final.K,'LineWidth', 2)
xlim([0 length(chain_final.K)])
ylim([0 10])
yticks([1 2 3 4 5 10])
yticklabels({'1','2','3','4','5','10','15'})
xlabel('Iterations')
ylabel('Number of States')
set(gca,'FontSize',20)
saveas(fig1,'statesGraph.png')
```

* Scatter Plot of diffusivities for each iteration.
```
%% Scatter Plot of diffusion values for every iteration
fig3=figure
for i=2:2:length(chain_final.F)
    scatter(repmat(i,[1,length(chain_final.F{i,1})]),1./(2*chain_final.F{i,1}(:,2)*0.001),repmat(10,[1,length(chain_final.F{i,1})]),'blue','filled')
    ylim([0 5])
    xlim([0 5000])
    hold on
end
xlabel('Iterations')
ylabel('Diffusion (\mum^2/s)')
set(gca,'Fontsize',18)
hold off
saveas(fig3,'DiffusionIterations.png')
```

* Boxplot of diffusivity distributions for each state.
```
%% Boxplot graph of diffusions
variance=[];
statesEstimated=mode(chain_final.K(burn_in:end));
for i=burn_in:length(chain_final.F)
    iteration=chain_final.F{i};
    if size(iteration,1)==statesEstimated
        variance=[variance iteration(:,2)];
    end
end
diffusivities=(1./(2*variance*tau))*pixel_size^2;
sorted_diffusivities=sortrows(diffusivities,1);
sorted_diffusivities=sorted_diffusivities';
fig2 = figure
boxplot(sorted_diffusivities,'whisker',1000)
hold on
xlabel('State')
ylabel('Diffusion [\mum^2/s]')
title('Results 3') %title of graph
set(gca,'FontSize',20)
hold off
saveas(fig2,'BoxplotDiffusionState.png')
```

References:
----------------------------------
Falcao, Rebeca Cardim, and Daniel Coombs. "Diffusion analysis of single particle trajectories in a Bayesian nonparametrics framework." Physical biology 17.2 (2020): 025001.

Sgouralis, Ioannis, and Steve Pressé. "An introduction to infinite HMMS for single-molecule data analysis." Biophysical journal 112.10 (2017): 2021-2029.
