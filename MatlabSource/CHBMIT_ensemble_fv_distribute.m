function [fv, lv] = ...
    CHBMIT_ensemble_fv_distribute(fv_raw, lv_raw, params)
%function [fv, lv] = ...
%    CHBMIT_ensemble_fv_distribute(fv_raw, lv_raw, params)

numModules = params.numModules;
RP         = params.flags.randperm;

if RP
    
    numLabels = length(lv_raw);
    
    fprintf('Assigning random permutations of window to SVMs...\n');
    fprintf('\n');
    
    for l = (1:numLabels-numModules+1)
        
        thisRP = randperm(numModules);
        thisFV = fv_raw(l:l+numModules-1,:);
        thisLV = lv_raw(l:l+numModules-1,1);
        
        for m = (1:numModules)
            
            addFL_N = (rand(1) <= params.FLAddChance_N);
            addFL_S = (rand(1) <= params.FLAddChance_S);
            
            thisLabel = thisLV(thisRP(m),1);
            
            if (thisLabel && addFL_S) || (~thisLabel && addFL_N)
                lv(m).lv(l,1) = thisLabel;
                fv(m).fv(l,:) = thisFV(thisRP(m),:);
            end
            
        end
        
    end
    
    fprintf(' Done\n');
    
else
    
    numLabels = length(lv_raw);
    
    fprintf('Randomly sampling F-L vector pairs by module...\n');
    fprintf('\n');
    
    for m = (1:numModules)
        
        fprintf('    Module %d...', m);
        
        fv(m).fv = [];
        lv(m).lv = [];
        
        for l = (1:numLabels)
            
            thisRand = randi(numLabels);
            
            addFL_N = (rand(1) <= params.FLAddChance_N);
            addFL_S = (rand(1) <= params.FLAddChance_S);
            
            thisLabel = lv_raw(thisRand,1);
            
            if (thisLabel && addFL_S) || (~thisLabel && addFL_N)
                lv(m).lv(l,1) = thisLabel;
                fv(m).fv(l,:) = fv_raw(thisRand,:);
            end
            
        end
        
        fprintf(' Done\n');
        
    end
    
end

fprintf('\n');
fprintf('Done.\n');

end

