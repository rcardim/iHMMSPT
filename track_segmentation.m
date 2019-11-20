clear all
dirIN=pwd;
st=5;
r_max=5000;
load(sprintf('2811_longTracks%d_2d.mat',st));
load(fullfile(pwd,sprintf('final_results5000_5burnins_%d_E-6BC_gammaE-2_both_20.mat',st)))
chain=chain_final;
burn_in=round(0.20*length(chain.F));
tau=0.001;
variance=[];
prob=[];
count=0;
Transitions=zeros(st,st);
for i=burn_in:length(chain.F)
    iteration=chain.F{i};
    iteration_P=chain.P{i};
    if size(iteration,1)==st
        count=count+1;
        variance=[variance iteration(:,2)];
        prob=[prob iteration(:,3)];
        Transitions=Transitions+iteration_P(:,1:st);
    end
end
sp=mean(prob,2);
T=Transitions./count;
MV=mean(variance,2);
D=1./(2*MV*tau);
% D1=1./(2*variance*tau);
% D=mean(D1');
% org1=[D T];
% org=sortrows(org1)
%%
[logg]=  Segmentation_of_states_K(st,D',T,sp',sq_dis,tau);
% sequence = 1+double( logg(:,2) > logg(:, 1) );
for i=1:length(logg)
    [v r]=max(logg(i,:));
    if  r==1
        sequence(i)=4;
    elseif r==2
        sequence(i)=3;
    elseif r==3
        sequence(i)=2;
    elseif r==4
        sequence(i)=1;
%     elseif r==5
%         sequence(i)=4;
    end
end
real_sequence=longTracks{1,1}(1:49999,4);
percorrect=sum(sequence==real_sequence')/49999

% save('segmentation2.mat','sequence','real_sequence','percorrect')