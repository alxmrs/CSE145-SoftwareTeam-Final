function [fv ] = Classifier_removeFeatures(fv, flist)
%function [fv ] = Classifier_removeFeatures(fv, flist)

flist = sort(flist,'descend');

for i = flist
    
    if i>1 && i<size(fv,2)
        fv = [fv(:,1:i-1) fv(:,i+1:end)];
    elseif i == 1
        fv = fv(:,2:end);
    else
        fv = fv(:,1:end-1);
    end
    
end
    
end

