function s = sampler_update_backward( u, A_forw, P )
% This function samples an state trajectory using the forward filter A_forw
         
N = length(u);

s = nan(1,N);

    s(N) = sample( A_forw(:,N) );
for n = N-1:-1:1
    B_back = A_forw(:,n).*( P(:,s(n+1)) >= u(n+1) );
    s(n) = sample( B_back );
end
