function u = sampler_update_slicer(s,O,P)
% This function draws a new slicer
% u(n) ~ Uniform( 0, P( s(n-1), s(n) ) )
% that is required for the implementation of the beam sampler of iHMM

N = length(s);
u = nan(1,N);

    u(1) = rand * O( s(1) );
for n = 2:N
    u(n) = rand * P( s(n-1), s(n) );
end
    
    
