function [  ] = HFcvglmnetPlot( hitRate, falseRate, difference )
%   This function plot the hit rate, false alarm rate, and their difference
    
    %% Set some parameters
    y_upper = 0.9;
    y_lower = -0.3;

    
    %% Ploting 
    subplot(1,3,1)
    x = mean(hitRate,1);
    se = std(hitRate) / sqrt(10);
    X_plot = [x;x+se;x-se];
    plot(X_plot');
    xlabel('lambda','FontSize',13);
    ylabel('%','FontSize',13);
    title('Hit rate','FontSize',13)
    ylim([y_lower,y_upper]);

    subplot(1,3,2)
    x = mean(falseRate,1);
    se = std(falseRate) / sqrt(10);
    X_plot = [x;x+se;x-se];
    plot(X_plot');
    xlabel('lambda','FontSize',13);
    title('False alarm rate','FontSize',13)
    ylim([y_lower,y_upper]);

    subplot(1,3,3)
    x = mean(difference,1);
    se = std(difference) / sqrt(10);
    X_plot = [x;x+se;x-se];
    plot(X_plot')
    xlabel('lambda','FontSize',13);
    title('Difference','FontSize',13)
    ylim([y_lower,y_upper]);

end

