function [c] = complexity_lrm(r,q,d,n)
    dict = d * q * q / n;
    x = 2 * q * r - r^2  ;
    c = dict + x;
end
