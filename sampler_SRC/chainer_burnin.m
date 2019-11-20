function chain = chainer_burnin( x, error, r_max, chain_init, opts, flag_sta )
% This function handles MCMC chains

% Calling syntaxes:
% (1) Init and expand
% chain = sampler_main(  x, r_max,         [], opts, flag_sta, flag_vis )
% (2) Just expand
% chain = sampler_main(  x, r_max, chain_init,   [], flag_sta, flag_vis )
%
%
% if iscolumn(x)
%     x = x';
% end

N = length(x);
x = double(x);



%% Initialize chain
% if chain_init is empty initialize the chain from scratch
if isempty(chain_init)
    
    % init parameters
    chain.params = chainer_init_params(x,opts);
    
    % allocate some space
    chain.s = zeros(r_max,N,'uint8');
    chain.K =   nan(r_max,1);
    chain.B =  cell(r_max,1);
    chain.O =  cell(r_max,1);
    chain.P =  cell(r_max,1);
    chain.F =  cell(r_max,1);
    
    chain.r_max = r_max;
    chain.dr_sk = opts.dr_sk;
    
    [ s_curr, K_curr, B_curr, O_curr, P_curr, F_curr, i_curr ] = ...
        sampler_init_sample( x, opts, chain.params );
    r = 1;
    chain.s(r,:) = s_curr;
    chain.K(r  ) = K_curr;
    chain.B{r  } = B_curr;
    chain.O{r  } = O_curr;
    chain.P{r  } = P_curr;
    chain.F{r  } = F_curr;
    chain.i      = i_curr;
    
    
    
else % otherwhise expand existing chain
    
    % copy from input
    chain.params = chain_init.params;
    
    % allocate some space
    chain.s = zeros(r_max+chain_init.r_max,N,'uint8');
    chain.K =   nan(r_max+chain_init.r_max,1);
    chain.B =  cell(r_max+chain_init.r_max,1);
    chain.O =  cell(r_max+chain_init.r_max,1);
    chain.P =  cell(r_max+chain_init.r_max,1);
    chain.F =  cell(r_max+chain_init.r_max,1);
    chain.i =  nan;
    
    % copy from input
    r = 1:chain_init.r_max;
    chain.s(r,:) = chain_init.s(r,:);
    chain.K(r  ) = chain_init.K(r  );
    chain.B(r  ) = chain_init.B(r  );
    chain.O(r  ) = chain_init.O(r  );
    chain.P(r  ) = chain_init.P(r  );
    chain.F(r  ) = chain_init.F(r  );
    chain.i      = chain_init.i;
    
    chain.r_max = chain_init.r_max + r_max;
    chain.dr_sk = chain_init.dr_sk;
    
    r = r(end);
    s_curr = chain.s(r,:);
    K_curr = chain.K(r  );
    B_curr = chain.B{r  };
    O_curr = chain.O{r  };
    P_curr = chain.P{r  };
    F_curr = chain.F{r  };
    i_curr = chain.i;
    
end

%% Step the chain
while r < chain.r_max
    
    [ s_curr, K_curr, B_curr, O_curr, P_curr, F_curr, i_curr ] = ...
        sampler_burnin( x,error, chain.params, s_curr, K_curr, B_curr, O_curr, P_curr, F_curr, i_curr, r );
    
    % Store sample
    r = r+1;
    chain.s(r,:) = s_curr;
    chain.K(r  ) = K_curr;
    chain.B{r  } = B_curr;
    chain.O{r  } = O_curr;
    chain.P{r  } = P_curr;
    chain.F{r  } = F_curr;
    chain.i      = i_curr;
    
    if flag_sta
        % Print some progress report
        disp(['iter: i = ', num2str(i_curr),...
            ' - r = ', num2str(r),...
            ' - K = ', num2str(chain.K(r),'%2d'),...
            ' - occup = ', num2str(chain.F{r}(:,3)','%3.4f ' ) ])
    end
    
end
