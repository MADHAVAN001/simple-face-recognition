function features=simpleExtractHOGFeatures(I)
    [gradx,grady]=gradient(I);
    theta=atan2d(grady,gradx);
    theta(theta<0)=360+theta(theta<0);
    direction=100.^(floor(theta/45));%0 to 45 degrees is dimension 1, 45 to 90 degrees is dimenstion 100, ...10000,...1000000,...
    hog=conv2(direction,ones(3));%3x3 window histogram of gradients;
    threebythreesummary=conv2(hog,fspecial('gaussian',3));
    features=threebythreesummary(2:3:end,2:3:end);
end