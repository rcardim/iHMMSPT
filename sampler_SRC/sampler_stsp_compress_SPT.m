function [s, K, B, F] = sampler_stsp_compress_SPT(s_ext, K_ext, B_ext, F_ext,error)
% this function merges the states whose Battacharya distance are similar.
% there are two cases represented by DatatType (binary variable):
% DataType = 0: For data without noise.
% DataType = 1: For data with noise/experimental errors.
% error: it is the experimental error. it should have same units as the data.

idx = setdiff( 1:K_ext, unique(s_ext) );  % idx must be ordered
%
s = s_ext;
B = B_ext;
K = K_ext;
F = F_ext;

if error == 0
    ii=K;
    while ii>1
        for j=(ii-1):-1:1
            
            BC=sqrt(2*sqrt(F(ii,2)*F(j,2))/(F(ii,2)+F(j,2)));
            lowerBC=1-10^-6;
            
            if BC>=lowerBC
                s( s==ii )=j;
                
                s( s>ii ) = s( s>ii ) - 1;
                
                B(K+1) = B(K+1) + B(ii);
                
                B(ii) = [];
                
                if F(j,3)> F(ii,3)
                    
                    F(j,3)=F(j,3)+F(ii,3);
                    
                    F(ii,:) = [];
                    
                else
                    F(j,2)= F(ii,2);
                    
                    F(j,3)=F(j,3)+F(ii,3);
                    
                    F(ii,:)=[];
                end
                K = K - 1;
                
                ii=ii-1;
            end
        end
        ii=ii-1;
    end
else
    Bcacc=sqrt(2*sqrt(F(:,2).*(1./F(:,2)+2*error^2).^(-1))./(F(:,2)+(1./F(:,2)+2*error^2).^(-1)));
    ii=K;
    while ii>1
        for j=(ii-1):-1:1
            
            BC=sqrt(2*sqrt(F(ii,2)*F(j,2))/(F(ii,2)+F(j,2)));
            lowerBC = max(Bcacc(ii),Bcacc(j));
            
            if BC>=lowerBC
                s( s==ii )=j;
                
                s( s>ii ) = s( s>ii ) - 1;
                
                B(K+1) = B(K+1) + B(ii);
                
                B(ii) = [];
                
                if F(j,3)> F(ii,3)
                    
                    F(j,3)=F(j,3)+F(ii,3);
                    
                    F(ii,:) = [];
                    
                else
                    F(j,2)= F(ii,2);
                    
                    F(j,3)=F(j,3)+F(ii,3);
                    
                    F(ii,:)=[];
                end
                K = K - 1;
                
                ii=ii-1;
            end
        end
        ii=ii-1;
    end
      
end


