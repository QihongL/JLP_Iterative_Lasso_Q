opts = glmnetSet();opts.alpha = 1;
temp = glmnet(Xtrain,Ytrain,'binomial',opts);
pred = (Xtest * temp.beta) + repmat(temp.a0,[test.size, 1]) > 0;
response = repmat(Ytest,[1,100]);


hitRate = sum(pred  & response,1) / sum(Ytest);
falseRate = sum(~pred  & response, 1) / sum(~Ytest);
diff = hitRate - falseRate;
bestLambda = temp.lambda(find(diff == max(diff)));
        