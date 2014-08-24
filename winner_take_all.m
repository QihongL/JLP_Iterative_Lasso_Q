%% Winner take all analysis - Main Script
clear;

type = 'ERR';


% preallocate
accuracy = zeros(10,10);

% loop over 10 subjects
textprogressbar(['Winner take all analysis for ' type ': '  ])
for subNum = 1:10
    textprogressbar(subNum * 10);
    
    
    [acc, h, f] = winTakeAll( subNum, type ); 
    hit.faces(subNum, :) = h.TrueFaces;
    hit.places(subNum, :) = h.TruePlaces;
    hit.things(subNum, :) = h.TrueThings;
    false.faces(subNum, :) = f.TrueFaces;
    false.places(subNum, :) = f.TruePlaces;
    false.things(subNum, :) = f.TrueThings;    
    accuracy(subNum, :) = acc; 
end
textprogressbar('Done!')



% %% Visualize -SINGLE SUBJECT
% 
% subNum = 10
% 
% xx = 1:3;
% yyhit =[ mean(hit.faces(subNum,:)), mean(hit.places(subNum,:)), mean(hit.things(subNum,:))];
% yyfalse = [mean(false.faces(subNum,:)), mean(false.places(subNum,:)), mean(false.things(subNum,:))];
% 
% 
% figure(1)
% subplot(1,4,1)
% bar(xx, yyhit);
% xlabel('Hit Rate','FontSize',13)
% ylim([0 1]);
% set(gca,'XTickLabel', {'Faces', 'Places', 'Things'},'FontSize',12);
% 
% subplot(1,4,2)
% bar(xx, yyfalse);
% ylim([0 1]);
% set(gca,'XTickLabel', {'Faces', 'Places', 'Things'},'FontSize',12);
% xlabel('False Alarm Rate','FontSize',13)
% 
% subplot(1,4,3)
% bar(1, mean(accuracy(subNum,:)));
% ylim([0 1]);
% set(gca,'XTickLabel', {' '},'FontSize',12);
% xlabel('Classification accuracy','FontSize',13)
% 
% subplot(1,4,4)
% bar(xx, norminv(yyhit)-norminv(yyfalse));
% ylim([0 1.5]);
% set(gca,'XTickLabel', {'Faces', 'Places', 'Things'},'FontSize',12);
% xlabel('d-prime','FontSize',13)
% 
% 
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 
% 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% 
% text(0.5, 1,['\bf WTA analysis for subject ' num2str(subNum) ' using ' type ],...
%     'HorizontalAlignment', 'center','VerticalAlignment', 'top' ,'FontSize',15)


%% Visualize - Group 

hitfaceMean = mean(mean(hit.faces));
hitplaceMean = mean(mean(hit.places));
hitthingeMean = mean(mean(hit.things));

falsefaceMean = mean(mean(false.faces));
falseplaceMean = mean(mean(false.places));
falsethingMean = mean(mean(false.things));

accuracyMean = mean(mean(accuracy));

xx = 1:3;
yyhit = [hitfaceMean, hitplaceMean, hitthingeMean ];
yyfalse = [falsefaceMean, falseplaceMean, falsethingMean];



figure(2)
subplot(1,4,1)
bar(xx, yyhit);
xlabel('Hit Rate','FontSize',13)
ylim([0 1]);
set(gca,'XTickLabel', {'Faces', 'Places', 'Things'},'FontSize',12);

subplot(1,4,2)
bar(xx, yyfalse);
ylim([0 1]);
set(gca,'XTickLabel', {'Faces', 'Places', 'Things'},'FontSize',12);
xlabel('False Alarm Rate','FontSize',13)

subplot(1,4,3)
bar(1, accuracyMean );
ylim([0 1]);
set(gca,'XTickLabel', {' '},'FontSize',12);
xlabel('Classification accuracy','FontSize',13)

subplot(1,4,4)
bar(xx, norminv(yyhit)-norminv(yyfalse));
ylim([0 1.5]);
set(gca,'XTickLabel', {'Faces', 'Places', 'Things'},'FontSize',12);
xlabel('d-prime','FontSize',13)


ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 
1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

text(0.5, 1,['\bf WTA analysis for all subjects using ' type ],...
    'HorizontalAlignment', 'center','VerticalAlignment', 'top' ,'FontSize',15)
