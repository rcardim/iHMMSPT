function [ s_new, K_new, B_new, O_new, P_new, F_new, i_new ] = sampler_burnin( x, error, params,s_old, K_old, B_old, O_old, P_old, F_old, i_old, iterations)
% this function performs one MCMC step

%%
N = length(x);

flag = true;
while flag
    
    % update slicer
    u_new = sampler_update_slicer(s_old, O_old, P_old);
    
    % expand statespace
    [K_old_ext, B_old_ext, O_old_ext, P_old_ext, F_old_ext] = ...
        sampler_stsp_expand( u_new, K_old, B_old, O_old, P_old, F_old, params);
    % filter forward
    A_forw_new = sampler_update_forward( u_new, x, K_old_ext, O_old_ext, P_old_ext, F_old_ext );
    test = sum( A_forw_new(:,N) ); % check for over/under-flows
    if ~isnan(test) && test>0
        flag = false;
        % sample new state trajectory (with extra states)
        s_new_ext = sampler_update_backward( u_new, A_forw_new, P_old_ext );
        
        % compress statespace
        [s_new1, K_new1, B_old_red1, F_old_red] = sampler_stsp_compress(s_new_ext, K_old_ext, B_old_ext, F_old_ext);
          
        % update emission distributions
        F_new1 = sampler_update_emission_model( F_old_red, x, s_new1, K_new1, params);
        
        % checking how similar states are to fast-forward convergence
        if iterations > 0 
            [s_new, K_new, B_old_red, F_new] = sampler_stsp_compress_SPT(s_new1, K_new1, B_old_red1, F_new1,error);
        else
            s_new=s_new1;
            K_new=K_new1;
            B_old_red=B_old_red1;
            F_new=F_new1;
        end
        % sample base
        [C_new, B_new] = sampler_update_base(s_new, K_new, B_old_red, params );
        
        % sample transitions
        [O_new, P_new] = sampler_update_transitions( K_new, C_new, B_new, params );
        
        % -------
        i_new = i_old + 1;
        
    else
        disp(['--- backward sampling failed --- test = ', num2str(test), ' --- K_old_ext = ',num2str(K_old_ext)] )
    end
    
end
