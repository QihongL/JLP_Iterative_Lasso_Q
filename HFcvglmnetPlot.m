function [  ] = HFcvglmnetPlot( HF )
%   This function plot the hit rate, false alarm rate, and their difference
    
    %% Set some parameters
    y_upper = 0.7;
    y_lower = -0.1;

    
    %% Ploting 
    subplot(1,3,1)
    x = mean(HF.hitrate,1);
    se = std(HF.hitrate) / sqrt(10);
    X_plot = [x;x+se;x-se];
    plot(X_plot');
    xlabel('lambda','FontSize',13);
    ylabel('%','FontSize',13);
    title('Hit rate','FontSize',13)
    ylim([y_lower,y_upper]);

    subplot(1,3,2)
    x = mean(HF.falserate,1);
    se = std(HF.falserate) / sqrt(10);
    X_plot = [x;x+se;x-se];
    plot(X_plot');
    xlabel('lambda','FontSize',13);
    title('False alarm rate','FontSize',13)
    ylim([y_lower,y_upper]);

    subplot(1,3,3)
    x = mean(HF.difference,1);
    se = std(HF.difference) / sqrt(10);
    X_plot = [x;x+se;x-se];
    plot(X_plot')
    xlabel('lambda','FontSize',13);
    title('Difference','FontSize',13)
    ylim([y_lower,y_upper]);

end

