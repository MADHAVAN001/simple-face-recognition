function K=kernel(X,strtype,para)

if strcmp(strtype,'simple')
    K=X*X';
end

if strcmp(strtype,'poly')
    K=X*X'+1;
    K=K.^para;
end

if strcmp(strtype,'gaussian')
    K=distanceMatrix(X).^2;
    K=exp(-K./(2*para.^2));
end