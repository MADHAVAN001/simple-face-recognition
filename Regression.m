function meanrecallRegression=Regression(I,numberofsubjects,lastobjectid,width,downsample)
numberofobjects=diff([0,lastobjectid]);
totalnumberofobjects=lastobjectid(end);

meanrecallRegression=zeros(length(width),1);%one row for each partition width

partitionwidthindex=0;
for(partitionwidth=width)%for each partitionwidth
    partitionwidthindex=partitionwidthindex+1;
    recallRegression=zeros(1,min(numberofobjects));
    for(ind=1:min(numberofobjects))%for each object to be left out

        %initialise downsampled data
        for(i=1:totalnumberofobjects)
            I(i).downsampledimage=double(imresize(I(i).object,downsample/100));
            if(min(size(I(i).downsampledimage))<partitionwidth)
                meanrecallRegression(partitionwidthindex)=-1;
            else
                numberofpartitions=floor(size(I(i).downsampledimage)/partitionwidth);
            end
        end

        %if partitioning can be done
        if(meanrecallRegression(partitionwidthindex)~=-1)

            %partition test images
            for(testsubject=1:numberofsubjects)
                %initialise test image
                testimage=I(lastobjectid(testsubject)-numberofobjects(testsubject)+ind).downsampledimage;
                test=zeros(partitionwidth*partitionwidth,prod(numberofpartitions));%each column is one partition
                partition=1;
                for(partitionrowindex=0:numberofpartitions(1)-1)
                    for(partitioncolumnindex=0:numberofpartitions(2)-1)
                        test(:,partition)=reshape(testimage((partitionrowindex*partitionwidth+1):((partitionrowindex+1)*partitionwidth),(partitioncolumnindex*partitionwidth+1):((partitioncolumnindex+1)*partitionwidth)),partitionwidth*partitionwidth,1);
                        partition=partition+1;
                    end
                end
                testcollection(testsubject).columnsaspartitions=test;
            end

            %for each subject
            minerrorwithsubjectasrows=zeros(numberofsubjects,numberofsubjects);%columns of error (with one row for each subject) for each testsubject
            for(subject=1:numberofsubjects)
                isTraining=leaveOut(numberofobjects(subject),ind);
                X=zeros(partitionwidth*partitionwidth,sum(isTraining)*prod(numberofpartitions));%contiguous columns of partitions
                objind=0;
                for(objectindex=1:numberofobjects(subject))
                    if(isTraining(objectindex))
                        trainingimage=I(lastobjectid(subject)-numberofobjects(subject)+objectindex).downsampledimage;
                        partition=1;
                        for(partitionrowindex=0:numberofpartitions(1)-1)
                            for(partitioncolumnindex=0:numberofpartitions(2)-1)
                                X(:,objind*prod(numberofpartitions)+partition)=reshape(trainingimage((partitionrowindex*partitionwidth+1):((partitionrowindex+1)*partitionwidth),(partitioncolumnindex*partitionwidth+1):((partitioncolumnindex+1)*partitionwidth)),partitionwidth*partitionwidth,1);
                                partition=partition+1;
                            end
                        end
                        objind=objind+1;
                    end
                end

                testpartitionerror=Inf(1,numberofsubjects);
                for(partition=0:prod(numberofpartitions)-1)
                    Xpartition=X(:,partition+1:partition+sum(isTraining));
                    for(testsubject=1:numberofsubjects)
                        test=testcollection(testsubject).columnsaspartitions;
                        testpartitionerror(testsubject)=min(testpartitionerror(testsubject),sqrt(sum((test(:,partition+1)-Xpartition*(Xpartition\test(:,partition+1))).^2)));
                    end
                end
                minerrorwithsubjectasrows(subject,:)=testpartitionerror;
            end
            [minerror,predictedsubject]=min(minerrorwithsubjectasrows);
            recallRegression(ind)=sum(predictedsubject==(1:numberofsubjects))/numberofsubjects;%shorthcut comparison for exactly one testsubject from each subject
        end
    end
    meanrecallRegression(partitionwidthindex)=mean(recallRegression);
end
end