function [c] = complexity_svd(r,d,n)
    dict = ( r * d - (r * (r+1)) / 2)/ n;
    x = r ;
    c = dict + x ;
end