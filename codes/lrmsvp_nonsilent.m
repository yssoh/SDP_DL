function [ X, flag ] = lrmsvp( A, b, r, varargin )
% Applies the Singular Value Projection algorithm to recover X

% Flag status
% 0 = Working
% 1 = Failed to converge
% 2 = Failed to converge with any step size

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
n_rds = 0;

% Normalization
b_norm = norm(b);
b = b / b_norm;

while (ETA > STEP_LB) 
    
    % Initial position is at origin
    X = zeros(q,q);
    
    err = 1;
    curr_counter = 0;

    while (err > TOL) && (curr_counter < N_MAX_RDS) && (norm(X) < MAX_SIZE) ;
        % Tracker
        n_rds = n_rds + 1;
        
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
        err = norm(contract(A,X - Xnew));
        X = Xnew;
    end
    
    % Examine break loop conditions
    
    if err <= TOL % Exit if converge
        fprintf('Number of rounds: %d %d %e\n',n_rds,curr_counter,ETA);
        X = X * b_norm;
        return
    elseif (norm(X) >= MAX_SIZE) % Reduce step size
        ETA = ETA * 0.5;
    else % Did not converge in N_MAX_RDS steps
        fprintf('Too many rounds');
        fprintf('Number of rounds: %d %d %e\n',n_rds,curr_counter,ETA);
        flag = 1;
        X = X * b_norm;
        return
    end
    
end

flag = 2;
X = X * b_norm;
fprintf('No step size');

end