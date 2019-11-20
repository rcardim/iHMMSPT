function F_new = sampler_update_emission_model( F_old, x, s, K, params)
% This function initializes and updates the emission distributions

if isempty(x)   % init
    
    F_new = nan(K,3);
    for j=1:K
       F_new(j,:) = [ 0 , gamrnd( params.Q(3)/2, 2/(params.Q(4)*params.Q(3)) ), nan];
    end  
    
else % update
    
    N = length(x);
    
    F_new(:,2:3) = nan(K,2);
    
    for j=1:K
        
        ind = s==j;
        num = sum(ind);
        for rep = 1:params.Frep
            % precision
            F_new(j,2) = gamrnd( (num+params.Q(3))/2, 2/(params.Q(4)*params.Q(3)+sum( ( x(ind)).^2 )));
        end      
        % occup
        F_new(j,3) = num/N;
    end
end

