function j = sample( p )
% This function returns a sample from 1:length(p) according to the weights
% in p. The weights in p need NOT be normalized.

p = cumsum(p);
j = find( p(end)*rand < p, 1 );

