function D=distanceMatrix(X)

N=size(X,1);

XX=sum(X.*X,2);
XX1=repmat(XX,1,N);
XX2=repmat(XX',N,1);

D=XX1+XX2-2*(X*X');
D(D<0)=0;
D=sqrt(D);