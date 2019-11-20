function c = logsumG(A)
%% A is avector where each element is the likelihood for a state. Computes the logsum(A) = log( exp(A(1)) + exp(A(2))+...+exp(A(n))
M= max(A);
c= M + log(sum(exp(A-M)));
end