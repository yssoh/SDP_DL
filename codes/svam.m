function [ A, Xhat, errtab, outputstat ] = svam( Y, A_0, r, parmode )
% One step of the alternating minimization algorithm for recovering A

% Usage
% Y is data matrix. Data arranged in columns
% A_0 is the initial estimate
% r is sparsity of lifted represented
% parmode: Set to 1 to run the variety constrained optimization step in
% parallel, otherwise set to 0

% Tunable parameters
% Damp factor
l = 0.5; % 1 for no damping, Choose a value in (0,1]

% Begin algorithm
[~,n] = size(Y);
[~,q] = size(A_0);

% Initialize
A = A_0;

% Status bar interval length
nints = floor(n/50);
errtab = zeros(1,n);

% Begin solving linear-inverse instances % % % % % % % % % % % % % % % % % 
if parmode == 0
    fprintf('Solving linear-inverse instances.\n')
end

% Solve optimization instance
Xhat = zeros(q,n);              % Optimal X
fail_count = zeros(1,n);        % Failed to converge
nostep_count = zeros(1,n);      % No suitable step size found

if parmode == 1
    % PARALLEL FOR LOOP % % % % % % % % % %
    parfor j = 1 : n
        [Xhat(:,j),flag] = sviht(A,Y(:,j),r);

        % Calls convex backup if original heuristic fails
        if flag ~= 0
            if flag == 1
                fail_count(1,j) = 1;
            elseif flag == 2
                nostep_count(1,j) = 1;
            end
            Xhat(:,j) = svlasso(A,Y(:,j),r,'reg',0.5);
        end
    end
    % % % % % % % % % % % % % % % % % % % %
else
    % SERIAL FOR LOOP % % % % % % % % % %
    for j = 1 : n
        [Xhat(:,j),flag] = sviht(A,Y(:,j),r);

        % Calls convex backup if original heuristic fails
        if flag ~= 0
            if flag == 1
                fail_count(1,j) = 1;
            elseif flag == 2
                nostep_count(1,j) = 1;
            end
            Xhat(:,j) = svlasso(A,Y(:,j),r,'reg',0.5);
        end
        if mod(j,nints) == 0
            fprintf('.');
        end
    end
    % % % % % % % % % % % % % % % % % % % %
end

failstat = sum(fail_count);
nostepstat = sum(nostep_count);
 
% Pseudo-inverse + Damp + Normalize % % % % % % % % % % % % % % % % % % %
Aint = Y/Xhat;
Anew = (1-l) * Aint + l * A;
for j = 1:q
    Anew(:,j) = Anew(:,j) / norm(Anew(:,j),2);
end
err = norm(A-Anew); % Report the change in successive iterations
A = Anew;

% Print to screen % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
fprintf('\nError between succ. estimates : %e', err)
fprintf('\nFailed to converge: %d / %d. No suitable step size: %d / %d.\n', failstat,n, nostepstat, n)

% Compute the compression errors % % % % % % % % % % % % % % % % % % % % %
for j = 1 : n
    errtab(1,j) = norm(Aint * Xhat(:,j) - Y(:,j),2)^2;
end
outputstat = [err, failstat, nostepstat];

end