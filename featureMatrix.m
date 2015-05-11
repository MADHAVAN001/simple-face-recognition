function X=featureMatrix(I,indicator)
    X=zeros(sum(indicator),length(I(1).feature));
    index=1;
    for(id=1:length(I))
        if(indicator(id))
            X(index,:)=I(id).feature;
            index=index+1;
        end
    end
end