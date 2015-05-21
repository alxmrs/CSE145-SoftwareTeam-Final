function [] = Classifier_subplot( f1_N, f2_N, f1_S, f2_S, channel )
%function [] = Classifier_subplot( f1_N, f2_N, f1_S, f2_S, channel )

assert(nargin >= 4);

if nargin == 4 || strcmp(channel,'all')

    scatter(f1_N(:,1), f2_N(:,1), 'green', '.');
    hold on
    scatter(f1_N(:,2), f2_N(:,2), 'green', 'o');
    scatter(f1_N(:,3), f2_N(:,3), 'green', '*');
    scatter(f1_N(:,4), f2_N(:,4), 'green', '+');
    scatter(f1_N(:,5), f2_N(:,5), 'green', 'x');
    scatter(f1_S(:,1), f2_S(:,1), 'red', '.');
    scatter(f1_S(:,2), f2_S(:,2), 'red', 'o');
    scatter(f1_S(:,3), f2_S(:,3), 'red', '*');
    scatter(f1_S(:,4), f2_S(:,4), 'red', '+');
    scatter(f1_S(:,5), f2_S(:,5), 'red', 'x');
    hold off

else
    
    if strcmp(channel,'delta')
        scatter(f1_N(:,1), f2_N(:,1), 'green', '.');
        hold on
        scatter(f1_S(:,1), f2_S(:,1), 'red', '.');
        hold off
    
    elseif strcmp(channel,'theta');
        scatter(f1_N(:,2), f2_N(:,2), 'green', 'o');
        hold on
        scatter(f1_S(:,2), f2_S(:,2), 'red', 'o');
        hold off
        
    elseif strcmp(channel,'alpha');
        scatter(f1_N(:,3), f2_N(:,3), 'green', '*');
        hold on
        scatter(f1_S(:,3), f2_S(:,3), 'red', '*');
        hold off
        
    elseif strcmp(channel,'beta');
        scatter(f1_N(:,4), f2_N(:,4), 'green', '+');
        hold on
        scatter(f1_S(:,4), f2_S(:,4), 'red', '+');
        hold off
        
    elseif strcmp(channel,'gamma');
        scatter(f1_N(:,5), f2_N(:,5), 'green', 'x');
        hold on
        scatter(f1_S(:,5), f2_S(:,5), 'red', 'x');
        hold off
        
    end
    
end

end

