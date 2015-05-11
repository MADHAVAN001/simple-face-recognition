function leadingEigen=computeLeadingEig(matrix,k)
%To compute the k leading eigenvectors of the given matrix, with 
%eigenvalues appended at the last row
    [EigenVector,EigenValues] = eig(matrix);
    [I,sorted] = sort(diag(EigenValues),'descend');
    leadingEigen = zeros(length(EigenVector)+1,k);
    for i = 1:k
        leadingEigen(1:length(EigenVector),i) = EigenVector(:,sorted(i));
        leadingEigen(length(EigenVector)+1,i) = EigenValues(sorted(i),sorted(i));
    end
end