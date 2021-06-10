function [ X, flag ] = lrmsvp( A, b, r, varargin )
% Returns X where X has rank-r and X minimizes the L2-norm of
% b - A(X) 
% Based on the Singular Value Projection heuristic algorithm

% Output is a matrix X with the following possible flags indicating the
% status of the solver.

% Flag status
% 0 = Working. That is, the algorithm terminates as expected.
% 1 = Failed to converge. The algorithm fails to converge within a pre-set
% number of iterations.
% 2 = Failed to converge with any step size. The algorithm fails to find a
% step size for which there is any meaningful progess towards convergence.

flag = 0; 

% Parameters

TOL = 10^(-5);          % Successive difference
if nargin > 3
    ETA = varargin{1};
else
    ETA = .01;                % Step size
end
MAX_SIZE = 10^5;        % Cut off before blow up
N_MAX_RDS = 10000;      % Maximum number of iterates before cut off
STEP_LB = 10^(-5);      % Lower bound for step size before declaring failure

[q,~,d] = size(A);

% Tracker
% n_rds = 0;

% Normalize b
b_norm = norm(b);
b = b / b_norm;

while (ETA > STEP_LB) 
    
    % Initial position is at origin
    X = zeros(q,q);
    
    err = 1;
    curr_counter = 0;

    while (err > TOL) && (curr_counter < N_MAX_RDS) && (norm(X) < MAX_SIZE) ;
        % Tracker
        % n_rds = n_rds + 1;
        
        curr_counter = curr_counter + 1;

        % Gradient step
        diff =  contract(A,X) - b;
        GRADSTEP = zeros(q,q);
        for j = 1 : d
            GRADSTEP = GRADSTEP + A(:,:,j) * diff(j,1);
        end
        
        Y = X - ETA * GRADSTEP;

        % Hard thresholding
        Xnew = lrmht(Y,r);

        % Update
        err = norm(X - Xnew)/q;
        X = Xnew;
    end
    
    % Examine break loop conditions
    
    if err <= TOL % Exit if converge
        % fprintf('Number of rounds: %d %d %e\n',n_rds,curr_counter,ETA);
        X = X * b_norm;
        return
    elseif (norm(X) >= MAX_SIZE) % Reduce step size
        ETA = ETA * 0.5;
    else % Did not converge in N_MAX_RDS steps
        % fprintf('Too many rounds');
        % fprintf('Number of rounds: %d %d %e\n',n_rds,curr_counter,ETA);
        flag = 1;
        X = X * b_norm;
        return
    end
    
end

flag = 2;
X = X * b_norm;
% fprintf('No step size');

end