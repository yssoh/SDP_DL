function [c] = complexity_sv(s,q,d,n)
    dict = d * q / n;
    x = 2 * s;
    c = dict + x ;
end