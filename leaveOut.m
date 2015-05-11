function boolIsTraining=leaveOut(lastobjectid,leaveoutvector)
    boolIsTraining=true(1,lastobjectid(end));
    for(subject=1:length(lastobjectid))
        objectindex=1;
        for(object=lastobjectid(subject-1+1*((subject-1)==0))-lastobjectid(1)*((subject-1)==0)+1:lastobjectid(subject))
            if(any(objectindex==leaveoutvector))
                boolIsTraining(object)=false;
            end
            objectindex=objectindex+1;
        end
    end
end        