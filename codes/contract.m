function [ y ] = contract( A,X )
% Compute A(X)

[~,~,d] = size(A);

y = zeros(d,1);

for i = 1 : d
    y(i,1) = trace(A(:,:,i)*(X'));
end

end

