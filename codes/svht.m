function [ X ] = svht( X, r )
% Vector Hard thresholding

% Pick up the size of the r-th largest element, set it as t
tvec = sort(abs(X));
[q,~] = size(X);
t = tvec(q-r+1,1);

% Threshold all elements smaller than t
for i = 1 : q
    if abs(X(i,1))<t
        X(i,1) = 0;
    end
end

end

