function [ X , flag ] = sviht( A, b, r )
% Returns X where X is r-sparse and X minimizes the L2-norm of
% b - A*X 
% Based on the Iterative Hard Thresholding heuristic algorithm

% Output is a vector X with the following possible flags indicating the
% status of the solver.

% Flag status
% 0 = Working. That is, the algorithm terminates as expected.
% 1 = Failed to converge. The algorithm fails to converge within a pre-set
% number of iterations.
% 2 = Failed to converge with any step size. The algorithm fails to find a
% step size for which there is any meaningful progess towards convergence.

flag = 0; 

% Parameters

TOL = 10^(-5);      % Successive difference
ETA = .1;           % Step size
MAX_SIZE = 10^5;    % Cut off before blow up
N_MAX_RDS = 10000;  % Maximum number of iterates before cut off
STEP_LB = 10^(-5);  % Lower bound for step size before declaring failure

[~,q] = size(A);
sq = sqrt(q);  

% Normalize b
b_norm = norm(b);
b = b / b_norm;

while (ETA > STEP_LB) 
    
    % Initial position is at origin
    X = zeros(q,1);
    
    err = 1;
    curr_counter = 0;

    while (err > TOL) && (curr_counter < N_MAX_RDS) && (norm(X) < MAX_SIZE) ;
        curr_counter = curr_counter + 1;

        % Gradient step
        GRADSTEP = A'*(A*X - b);
        
        Y = X - ETA * GRADSTEP;

        % Hard thresholding
        Xnew = svht(Y,r);

        % Update
        err = norm(X - Xnew)/sq;        
        X = Xnew;
        
    end
    
    % Examine break loop conditions
    
    if err <= TOL % Exit if converge
        X = X * b_norm;
        return
    elseif (norm(X) >= MAX_SIZE) % Reduce step size
        ETA = ETA * 0.5;
    else % Did not converge in 10 000 steps
        flag = 1;
        X = X * b_norm;
        return
    end
    
end

flag = 2;
X = X * b_norm;

end

