function [ X ] = svlasso( A, b, r, type, param )
% Obtain the optimal solution to the following
% argmin 0.5 * || A*X - b ||^2 + l * ||X||_1

b_norm = norm(b);
b = b / b_norm;

[~,q] = size(A);

% Run the constrained version
if strcmp(type,'con') == 1
    % param will be the l2 norm bound
    thres = param^2;
    cvx_begin quiet
        variable X(q,1)
        minimize(norm(X,1))
        subject to
        norm(A*X - b,2) <= thres
    cvx_end
elseif strcmp(type,'reg') == 1
    % param will be the l2 norm bound
    cvx_begin quiet
        variable X(q,1)
        minimize(0.5* (A*X - b)'*(A*X - b) + param * norm(X,1))
    cvx_end
else
    fprintf('Error: Wrong usage\n');
end

X = svht(X,r);
X = X * b_norm;

end

