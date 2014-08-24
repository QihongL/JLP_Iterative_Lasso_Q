%% Winer take all classifer for solvable subjects
% Combining three classifers.
clear; clc;


%% First, Find subjects that are solvable for all labels 
type = 'HF';

solvableSub = find(solvAll(type) == 1);
numSub = size(solvableSub,2);



%% Computs HIT / FALSE

% Get a solvable subject
for i = 1: numSub
    subNum = solvableSub(i);


textprogressbar(['Loop over 10 cv blocks...' ]);
    for cv = 1:10

        textprogressbar(cv * 10);

        [X,metadata] = loadMRIData('jlp',subNum);

        % Get holdout indices
        holdout = metadata(subNum).CVBLOCKS(:,cv);
        % Xtest = X(holdout,:);

        % Get response matrix
        responseMatrix = response(subNum, cv, 'HF');


    
        %% Compute the performance

        % Get the maxCol 
        [~,maxCol] = max(responseMatrix,[],2);

        
        %% Faces 
        
        % holdout test set
        prediction = maxCol == 1;        
        Y = metadata(subNum).TrueFaces;
        Ytest_faces = Y(holdout);
        
        % hit/false
        [hit_f(cv), false_f(cv)] = HFrate(prediction, Ytest_faces);
        

        
        
        %% Places

        % hold out test set
        prediction = maxCol == 2;
        Y = metadata(subNum).TruePlaces;
        Ytest_places = Y(holdout);

        
        % hit/false
        [hit_p(cv), false_p(cv)] = HFrate(prediction, Ytest_places);


        
        %% Things
        
        % hold out test set 
        prediction = maxCol == 3;
        Y = metadata(subNum).TrueThings;
        Ytest_things = Y(holdout);

        % hit/false
        [hit_t(cv), false_t(cv)] = HFrate(prediction, Ytest_things);
        

        truth = Ytest_faces + Ytest_places * 2 + Ytest_things * 3;

        accuracy(i,cv) = sum(maxCol == truth) / sum(holdout);
        
        if sum(holdout) ~= 45
            disp('sum (holdout) is not 45, bug? ')
        end     
        
    end
    textprogressbar('Done.\n') 

    % Store the results
    hit(i).faces = hit_f;
    hit(i).places = hit_p;
    hit(i).things = hit_t;
    false(i).faces = false_f;
    false(i).places = false_p;
    false(i).things = false_t;
    


end


%% Visualize the hit/false rate for every subject
subNum = 1

xx = 1:3;
yyhit =[ mean(hit(subNum).faces), mean(hit(subNum).places), mean(hit(subNum).things)];
yyfalse = [mean(false(subNum).faces), mean(false(subNum).places), mean(false(subNum).things)];


figure(1)
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
bar(1, mean(accuracy(1,:)));
ylim([0 1]);
set(gca,'XTickLabel', {' '},'FontSize',12);
xlabel('Classification accuracy','FontSize',13)

subplot(1,4,4)
bar(xx, norminv(yyhit)-norminv(yyfalse));
ylim([0 1.5]);
set(gca,'XTickLabel', {'Faces', 'Places', 'Things'},'FontSize',12);
xlabel('d-prime','FontSize',13)


