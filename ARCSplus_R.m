function [R_hat, cost] = ARCSplus_R(Y, X, max_iter)
% X = Y*R + E
% R_hat = ARCSplus_R(Y, X, 40);
    
    % hyper-parameters
    mu = 0.01; mu_min = 1e-15; alpha = 1e-3; beta = 0.5; tol = 1e-10;    
    
    if nargin < 3
        max_iter = 100;
    end   

    [R_hat, cost_old] = Horn_R(Y, X);

    i = 0;
    while (mu > mu_min) && (i < max_iter)
        i = i + 1;
        
        % grad = normc(R_hat*P-Q);
        grad = R_hat*X-Y;
        grad_norm = vecnorm(grad);
        
        idx = grad_norm > tol;        
        grad = grad(:,idx) ./ grad_norm(idx);
        
        grad = grad*X(:,idx)';
        
        % grad = (grad - R_hat*grad'*R_hat)/2; % projection onto the tangent space        
        
        grad_norm = norm(grad).^2;
        
        % line search
        Rk = proj_SO3(R_hat - mu * grad);      
        cost = sum(vecnorm(Y-Rk*X));
        
        while cost > cost_old - alpha*mu*grad_norm && mu > mu_min
           mu = mu*beta;
           Rk = proj_SO3(R_hat - mu * grad);           
           cost = sum(vecnorm(Y-Rk*X));
        end     
        R_hat = Rk;    
        cost_old = cost;
    end
end

function R_hat = proj_SO3(R_hat)
    [U,~,V] = svd(R_hat);
    if det(U*V')< 0.0 % i.e. det(U*V') == -1
      U(:, 3) = -U(:, 3);
    end
    R_hat = U*V';
end