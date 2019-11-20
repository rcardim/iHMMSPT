 function [s, K, B, F] = sampler_stsp_compress(s_ext, K_ext, B_ext, F_ext)
% this function compresses the state space (that is it removes redundant
% states)

idx = setdiff( 1:K_ext, unique(s_ext) );  % idx must be ordered

s = s_ext;
B = B_ext;
K = K_ext;
F = F_ext;

for i = idx(end:-1:1)
    
    s( s>i ) = s( s>i ) - 1;

    B(K+1) = B(K+1) + B(i);
    B(i) = [];
    
    F(i,:) = [];
    
    K = K - 1;
    
end



