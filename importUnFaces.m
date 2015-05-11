function [I,lastobjectid]=importUnFaces(path,numberofsubjects)
    numberofobjects=zeros(1,numberofsubjects);
    for(subject=1:numberofsubjects)
        subjectfolder=dir(strcat(path,'\s',num2str(subject),'\*.pgm'));
        subjectfoldersize=size(subjectfolder);
        numberofobjects(subject)=subjectfoldersize(1);
    end
    lastobjectid=cumsum(numberofobjects);
    totalnumberofobjects=lastobjectid(numberofsubjects);
    for(subject=1:numberofsubjects)
        subjectfolder=dir(strcat(path,'\s',num2str(subject),'\*.pgm'));
        objectindex=1;
        for(object=lastobjectid(subject-1+1*((subject-1)==0))-lastobjectid(1)*((subject-1)==0)+1:lastobjectid(subject))
            I(object).subjectname=strcat('s',num2str(subject));
            I(object).objectname=subjectfolder(objectindex).name;
            I(object).object=imread(strcat(path,'\s',num2str(subject),'\',subjectfolder(objectindex).name));
            I(object).processed=histeq(I(object).object);%skipped eye localisation and normalisation
            I(object).feature=reshape(I(object).processed(2:3:end,2:3:end),1,prod(round((size(I(object).object))/3)));
            objectindex=objectindex+1;
        end
    end
end