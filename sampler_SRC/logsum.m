function c = logsum(a, b)

% Computes the logsum(a, b) = log( exp(a) + exp(b) )
% c = (a > b).*(a + log(1 + exp(b - a))) + (a <= b).*(b + log(1+ exp(a - b)));
if a>b
    c = a + log(1 + exp(b - a));
else
    c = b + log(1+ exp(a - b));
end
