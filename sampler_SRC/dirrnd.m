function p = dirrnd(ab)
% Samples from the dirichlet distribution

p = randg(ab);
p = p/sum(p);

