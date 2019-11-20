function A_forw = sampler_update_forward( u, x, K, O, P, F )
% This function filters forward

N = length(x);

O = O';
P = P';
A_forw = 0.5*(repmat(log(F(:,2)),1,N) - repmat(F(:,2),1,N).*repmat(x,K,1).^2 );
A_forw = exp( A_forw - repmat(max(A_forw),K,1) );

A_forw(:,1) = A_forw(:,1) .* (O>=u(1));
A_forw(:,1) = A_forw(:,1) / sum(A_forw(:,1));
for n=2:N
    A_forw(:,n) = A_forw(:,n) .* ( (P>=u(n)) * A_forw(:,n-1) );
    A_forw(:,n) = A_forw(:,n) / sum(A_forw(:,n));
end

