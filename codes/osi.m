function [ normA ] = osi( A )
% Normalizes a completely positive operator
% via Operator Sinkhorn Scaling

% Input A of dimensions (q,q,d)
% Output is normA with same dimensions
% normA = [A_1 ... A_d]
% sum A_i^2 = q I

[q,~,d] = size(A);

normA = A;

tol = 10^(-6);
err = 1;

while (err > tol)
    
    % Row scaling
    CRI = zeros(q,q);
    for j = 1:d
        CRI = CRI + normA(:,:,j)*normA(:,:,j)';
    end
    
    CRInv = inv(sqrtm(CRI)) * q^(1/2);
    for j = 1:d
        normA(:,:,j) = CRInv*normA(:,:,j);
    end

    % Column scaling
    CSI = zeros(q,q);
    for j = 1:d
        CSI = CSI + normA(:,:,j)'*normA(:,:,j);
    end
    CSInv = inv(sqrtm(CSI)) * q^(1/2);
    for j = 1:d
        normA(:,:,j) = normA(:,:,j) * CSInv;
    end
    err = norm(CRI - q * eye(q)) + norm(CSI - q * eye(q));
    
end

normA = normA * q;

end

