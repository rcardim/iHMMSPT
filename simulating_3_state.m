clear all
number_of_states=5;
base=2;
minD_upperbound=0.05;
lowerbound=5*10^-3;
u=rand*minD_upperbound+lowerbound;
diff_coeff(1,:)=u;
for i=2:number_of_states
    u=rand*minD_upperbound+lowerbound;
    diff_coeff(i,:)=u+(base^(i-2));
end
% diff_coeff=[0.01 0.1];
for i=1:number_of_states
    t(i,:)=randfixedsum(number_of_states,1,1,0,1);
end
% t=[0.5 0.5;0.5 0.5];
trans_matrix=t;
Nt=eye(number_of_states)-t';
P=null(Nt);
P=abs(P);
P=P/sum(P);
particles=1;
tau=0.001;
stationary=cumsum(P);
frames=100001;
state_trans = zeros(particles,frames);
longTracks={};
for i = 1:particles
    u = rand();
    for l = 1:length(stationary)
        if u < stationary(l)
            % all particles begin in the state corresponding to the
            % stationary distribution
            state_trans(i,1) = l;
            break;
        end
    end
end

for i = 1:particles
    for j = 2:frames
        % extract the probability mass function from the transition matrix
        % given the current state (this is an array of probabilities)
        PMF = trans_matrix(state_trans(i,j-1),:);
        % construct the cumulative mass function
        CMF = cumsum(PMF);
        k = rand();
        for l = 1:length(CMF)
            if k < CMF(l)
                % determine the next state in the Markov Chain, randomly
                state_trans(i,j) = l;
                break;
            end
        end
    end
end

%% Simulate trajectories for each track

% the standard deviations of the Brownian motion
% given the diffusion coefficient of each state
DataX=[];
for ind=1:particles
    for i = 1:number_of_states
        sigma_value(i) = sqrt(2*diff_coeff(i)*tau);
    end
    X(1) = 0;% normrnd(0,sigma_value(state_trans(ind,1))); % initialize x-position
    Y(1) = 0;% normrnd(0,sigma_value(state_trans(ind,1))); % initialize y-position    
    for j = 2:frames
        X(j) = X(j-1) + normrnd(0,sigma_value(state_trans(ind,j-1))); % x-position
        Y(j) = Y(j-1) + normrnd(0,sigma_value(state_trans(ind,j-1))); % y-position
    end
    sf=[state_trans(ind,1:end)'];% state_trans(ind,end)];
    longTracks{ind}=[(1:frames)' X' sf];%[(1:frames)' X' Y' sf];
    Data=diff(X');%[diff(X') diff(Y')];
    DataX=[DataX; Data];
%     longTracks{ind}=[(1:frames)' X' Y' sf];
%     DataX=diff([X' Y']);
end
save(sprintf('longTracks-%d.mat',number_of_states),'longTracks','diff_coeff','trans_matrix','P','tau','frames','base')
save(sprintf('Displacements-%d.mat',number_of_states),'DataX');
% fileID = fopen(sprintf('2811_DataX%d_2d.txt',number_of_states),'w');
% fprintf(fileID,'%.4f \n',DataX);
% fclose(fileID);
