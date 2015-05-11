function recall=varyingk(I,lastobjectid,maxeigenvector,isTraining,lnormpower,numberofneighbours,dimension)%,ind,numberofsubjects,numberofobjects,maxind,svmRecall)
%function res=knearestrecall(I,lastobjectid,maxeigenvector,isTraining,lnormpower,numberofneighbours,ind,numberofsubjects,numberofobjects,maxind,svmRecall)
    totalnumberofobjects=lastobjectid(end);
    numberoffeatures=length(I(1).feature);
    for(obj=1:totalnumberofobjects)
        I(obj).dimensiondimensionalreal=[];
        I(obj).predicteddimensiondimensionalreal=[];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%recall=zeros(1,numberoffeatures);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%for dimension=1:numberoffeatures;
        for(obj=1:totalnumberofobjects)
            I(obj).dimensiondimensionalreal=[I(obj).dimensiondimensionalreal,double(I(obj).feature)*maxeigenvector(:,dimension)];
        end
        positive=0;
        totalpositive=0;
        for(testcase=1:totalnumberofobjects)%for each test case
            if(~isTraining(testcase))
                I(testcase).predicteddimensiondimensionalreal=[I(testcase).predicteddimensiondimensionalreal,double(I(testcase).feature)*maxeigenvector(:,dimension)];
                lnorm=zeros(1,totalnumberofobjects);
                for(index=1:totalnumberofobjects)
                    lnorm(index)=sum((abs(I(testcase).predicteddimensiondimensionalreal-I(index).dimensiondimensionalreal)).^lnormpower).^(1/lnormpower);
                end
                lnorm(testcase)=Inf;%nearest neighbour is not a test case
                [mindistance,predictedsubject]=sort(lnorm);
                mostoccuring=mode(predictedsubject(1:numberofneighbours));
                I(testcase).predictedsubject=I(mostoccuring).subjectname;
                if(all(size(I(testcase).subjectname)==size(I(testcase).predictedsubject)))
                    positive=positive+1;
                end
                totalpositive=totalpositive+1;
            end
        %%%%%%%%%%%%%%%%%%%%%end
        recall=positive/totalpositive;%%%%%%%%%%%%%%%%%%%%%%%%%%%recall(dimension)=positive/totalpositive;
        %%%%
        %
%        isSvmTraining=leaveOut(lastobjectid,ind);
%        svmX=zeros(sum(isSvmTraining),length(I(1).dimensiondimensionalreal));
%        index=1;
%        for(id=1:length(I))
%            if(isSvmTraining(id))
%                svmX(index,:)=I(id).dimensiondimensionalreal;
%                index=index+1;
%            end
%        end
%        test=zeros(numberofsubjects,numberoffeatures);
%        testindex=1;
%        for(testcase=1:totalnumberofobjects)
%            if(~isTraining(testcase))
%                test(testindex,:)=I(testcase).predicteddimensiondimensionalreal;
%                testindex=testindex+1;
%            end
%        end
%        for(subject=1:numberofsubjects)
%            y=zeros(totalnumberofobjects-numberofsubjects,1);
%            y((lastobjectid(subject)-subject*numberofobjects(subject)+1):(lastobjectid(subject)-subject*numberofobjects(subject)+maxind))=1;
%            svm=fitcsvm(svmX,y);
%            prediction=predict(svm,test);
%            expectedsubject=zeros(numberofsubjects,1);
%            expectedsubject(subject)=1;
%            svmRecall(ind,subject)=sum(prediction==expectedsubject)/numberofsubjects;
%        end
%        res(1).recall=recall;
%        res(1).svmRecall=svmRecall;
        %
        %%%%
    end
end