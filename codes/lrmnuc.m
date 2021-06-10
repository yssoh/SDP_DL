function [ X ] = lrmnuc( A, b, r, type, param )
% Obtain the optimal solution to the following
% argmin 0.5 * || A(X) - b ||^2 + l * ||X||_*

b_norm = norm(b);
b = b / b_norm;

[q,~,d] = size(A);

% Run the constrained version
if strcmp(type,'con') == 1
    % param will be the l2 norm bound
    thres = param^2;
    cvx_begin quiet
        variables X(q,q) v(d,1) t
        minimize(norm_nuc(X))
        subject to
        for i = 1 : d
            square(trace(A(:,:,i)' * X ) - b(i,1)) <= v(i,1)
        end
        sum(v) <= thres
    cvx_end
elseif strcmp(type,'reg') == 1
    % param will be the l2 norm bound
    cvx_begin quiet
        variables X(q,q) v(d,1) t
        minimize(0.5*t + param * norm_nuc(X))
        subject to
        for i = 1 : d
            square(trace(A(:,:,i)' * X ) - b(i,1)) <= v(i,1)
        end
        sum(v) <= t
    cvx_end
else
    fprintf('Error: Wrong usage\n');
end


X = lrmht(X,r);
X = X * b_norm;

end

