function [ A, Xhat, errtab, outputstat ] = lrmam( Y, A_0, r, parmode, varargin )
% One step of the alternating minimization algorithm for recovering A

% Usage
% Y is data matrix. Data arranged in columns
% A_0 is the initial estimate
% r is rank of lifted represented
% parmode: Set to 1 to run the variety constrained optimization step in
% parallel, otherwise set to 0

% Tunable parameters
% Damp factor
l = 0.5; % 1 for no damping, Choose a value in (0,1]

% Begin algorithm
[d,n] = size(Y);
[q,~,~] = size(A_0);

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
Xhat = zeros(q,q,n);            % Optimal X
fail_count = zeros(1,n);        % Failed to converge
nostep_count = zeros(1,n);      % No suitable step size found

if nargin > 4
    ETA = varargin{1};
    % Run the main LRM SVP engine over all observations
    if parmode == 1 % Parallel mode
        parfor j = 1 : n
            [Xhat(:,:,j),flag] = lrmsvp(A,Y(:,j),r,ETA);
            
            % Calls convex backup if original heuristic fails
            if flag ~= 0
                if flag == 1
                    fail_count(1,j) = 1;
                elseif flag == 2
                    nostep_count(1,j) = 1;
                end
                Xhat(:,:,j) = lrmnuc(A,Y(:,j),r,'reg',0.5);
            end
        end
    else % Non parallel mode prints an output to screen
        for j = 1 : n
            [Xhat(:,:,j),flag] = lrmsvp(A,Y(:,j),r,ETA);
            
            % Calls convex backup if original heuristic fails
            if flag ~= 0
                if flag == 1
                    fail_count(1,j) = 1;
                elseif flag == 2
                    nostep_count(1,j) = 1;
                end
                Xhat(:,:,j) = lrmnuc(A,Y(:,j),r,'reg',0.5);
            end
            if mod(j,nints) == 0
                fprintf('.');
            end
        end
    end
else
    % Run the main LRM SVP engine over all observations
    if parmode == 1 % Parallel mode
        parfor j = 1 : n
            [Xhat(:,:,j),flag] = lrmsvp(A,Y(:,j),r);
            
            % Calls convex backup if original heuristic fails
            if flag ~= 0
                if flag == 1
                    fail_count(1,j) = 1;
                elseif flag == 2
                    nostep_count(1,j) = 1;
                end
                Xhat(:,:,j) = lrmnuc(A,Y(:,j),r,'reg',0.5);
            end
        end
    else % Non parallel mode prints an output to screen
        for j = 1 : n
            [Xhat(:,:,j),flag] = lrmsvp(A,Y(:,j),r);
            
            % Calls convex backup if original heuristic fails
            if flag ~= 0
                if flag == 1
                    fail_count(1,j) = 1;
                elseif flag == 2
                    nostep_count(1,j) = 1;
                end
                Xhat(:,:,j) = lrmnuc(A,Y(:,j),r,'reg',0.5);
            end
            if mod(j,nints) == 0
                fprintf('.');
            end
        end
    end
end

failstat = sum(fail_count);
nostepstat = sum(nostep_count);

% Pseudo-inverse + Damp + Normalize % % % % % % % % % % % % % % % % % % %
Xhattall = zeros(q*q,n);
for j = 1 : n
    vecX = Xhat(:,:,j);
    Xhattall(:,j) = vecX(:);
end
Aintfat = Y/Xhattall;
Aint = zeros(q,q,d);
for j = 1 : d
    for k = 1:q
        Aint(:,k,j) = Aintfat(j,(k-1)*q+1:k*q)';
    end
end
Anew = osi(l*Aint+(1-l)*A);
err = 0; % Report the change in successive iterations
for j = 1:d
    err = err + norm(Anew(:,:,j) - A(:,:,j));
end
A = Anew;

% Print to screen % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
fprintf('\nError between succ. estimates: %e', err)
fprintf('\nFailed to converge: %d / %d. No suitable step size: %d / %d.\n', failstat,n, nostepstat, n)

% Compute the compression errors % % % % % % % % % % % % % % % % % % % % %
for j = 1 : n
    errtab(1,j) = norm(contract(Aint,Xhat(:,:,j)) - Y(:,j),2)^2;
end
outputstat = [err, failstat, nostepstat];

end