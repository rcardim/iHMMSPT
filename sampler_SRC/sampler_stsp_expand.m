function [K_ext, B_ext, O_ext, P_ext, F_ext] = sampler_stsp_expand( u, K, B, O, P, F, params)
% This function expands the state space (that is it adds new states that
% are drawn from the priors)

K_ext = K;
P_ext = P;
B_ext = B;
O_ext = O;
F_ext = F;

while ( (  max( P_ext(:,K_ext+1) ) > min( u(2:end) ) ) || (  max( O_ext(K_ext+1) ) > u(1) ) )

    % recruit a new state

    % (i) increase k by 1
    K_ext = K_ext+1;

    % (ii) add a new row in p
    P_ext(K_ext,:) = dirrnd( params.a*B_ext );

    % (iii) break b
    v_temp = betarnd( 1, params.g );
    B_ext(K_ext+1) = B_ext(K_ext)*(1-v_temp);
    B_ext(K_ext  ) = B_ext(K_ext)*v_temp;
    clear v_temp

    % (iv) break rows of o
    vA_temp = params.a * B_ext(K_ext);
    vB_temp = params.a * B_ext(K_ext+1);
    v_temp = betarnd( vA_temp, vB_temp );
    O_ext(K_ext+1) = O_ext(K_ext)*( 1-v_temp );
    O_ext(K_ext  ) = O_ext(K_ext)*v_temp;
    clear vA_temp vB_temp v_temp

    % (v) break rows of p
    vA_temp = params.a * B_ext(K_ext)*ones(K_ext,1);
    vB_temp = params.a * B_ext(K_ext+1);
    v_temp = betarnd( vA_temp, vB_temp );
    P_ext(:,K_ext+1) = P_ext(:,K_ext).*( 1-v_temp );
    P_ext(:,K_ext  ) = P_ext(:,K_ext).*v_temp;
    clear vA_temp vB_temp v_temp

    % (vi) recruit a new f
    F_ext(K_ext,:) = sampler_update_emission_model( [], [], [], 1, params);

end

% to simplify book-keeping remove additional rows
P_ext(:,K_ext+1) = [];
O_ext(  K_ext+1) = [];

