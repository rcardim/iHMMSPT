function best_burnin = burnin_main(x, r, error,opts,n)
%% function that does the burn-in steps n times, and chooses the best burn-in.
number_of_burnins=n;
handles.chain = chainer_burnin(x,error, 1, [], opts, true);
chain_burnin = chainer_burnin(x,error, r, handles.chain, [], true);
states.chains(1)=chain_burnin;
Kst(1)= chain_burnin.K(end);
for b=2:number_of_burnins
    handles.chain = chainer_burnin(x,error, 1, [], opts, true );
    chain_burnin = chainer_burnin(x,error, r, handles.chain, [], true);
    states.chains(b)=chain_burnin;
    Kst(b)= chain_burnin.K(end);
end
[M F C]=mode(Kst(:));
state_final=M;
indexs=find(state_final==Kst(:));
best_burnin=states.chains(indexs(end));