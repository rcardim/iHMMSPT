%% Script to plot some graphs of states and diffusion
%% load Results
load('results-3.mat')
tau=0.001; %tau = sampling time = 1/frame_rate (1/s)
pixel_size=1; % size of 1 pixel in microns (for simulated data is 1)
burn_in=750;% burn-in steps
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
%% Boxplot graph of diffusions
variance=[];
prob=[];
count=0;
statesEstimated=mode(chain_final.K(burn_in:end));
Transitions=zeros(statesEstimated,statesEstimated);
for i=burn_in:length(chain_final.F)
    iteration=chain_final.F{i};
    iteration_P=chain_final.P{i};
    if size(iteration,1)==statesEstimated
        count=count+1;
        Transitions=Transitions+iteration_P(:,1:statesEstimated);
        variance=[variance iteration(:,2)];
        prob=[prob iteration(:,3)];
    end
end
T=Transitions./count;
D1=(1./(2*variance*tau))*pixel_size^2;
Dm=mean(D1,2);
pm=mean(prob,2);
res1=[Dm; pm]';
resf=sortrows(res1,1);
D2=sortrows(D1,1);
D2=D2';
fig2 = figure
boxplot(D2,'whisker',1000)
hold on
xlabel('State')
ylabel('Diffusion [\mum^2/s]')
title('Results 3') %title of graph
set(gca,'FontSize',20)
hold off
saveas(fig2,'BoxplotDiffusionState.png')
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

