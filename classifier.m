T = readtable('data.csv');
N = size(T,1);

F_gini_accuracy = fopen('output_files/g_4_DT_gini_accuracy.csv','w');
F_gini_predictions = fopen('output_files/g_4_DT_gini_predictions.csv','w');
fprintf(F_gini_accuracy,'"Dataset number","Accuracy"\n');
fprintf(F_gini_predictions,'"Iteration","Classification","Predictions"\n');

F_entropy_accuracy = fopen('output_files/g_4_DT_entropy_accuracy.csv','w');
F_entropy_predictions = fopen('output_files/g_4_DT_entropy_predictions.csv','w');
fprintf(F_entropy_accuracy,'"Dataset number","Accuracy"\n');
fprintf(F_entropy_predictions,'"Iteration","Classification","Predictions"\n');

% Gini
for i = 1:5
    tf = false(N,1);
    tf(1:round(N*0.8)) = true;
    tf = tf(randperm(N));

    DT = fitctree(T(tf,2:end-1),T(tf,end),'SplitCriterion','gdi');

    classifications = char(T(~tf,:).('classification'));
    predictions = char(predict(DT,T(~tf,2:end-1)));
    [c,a] = confusionmat(classifications,predictions);

    M = size(predictions,1);
    for j = 1:M
        fprintf(F_gini_predictions,'"%d","%c","%c"\n',i,classifications(j),predictions(j));
    end

    accuracy = (c(1,1) + c(2,2))/(c(1,1) + c(1,2) + c(2,1) + c(2,2));
    fprintf(F_gini_accuracy,'"%d","%.4f"\n',i,accuracy);
end

% Entropy
for i = 1:5
    tf = false(N,1);
    tf(1:round(N*0.8)) = true;
    tf = tf(randperm(N));

    DT = fitctree(T(tf,2:end-1),T(tf,end),'SplitCriterion','deviance');

    classifications = char(T(~tf,:).('classification'));
    predictions = char(predict(DT,T(~tf,2:end-1)));
    [c,a] = confusionmat(classifications,predictions);

    M = size(predictions,1);
    for j = 1:M
        fprintf(F_entropy_predictions,'"%d","%c","%c"\n',i,classifications(j),predictions(j));
    end

    accuracy = (c(1,1) + c(2,2))/(c(1,1) + c(1,2) + c(2,1) + c(2,2));
    fprintf(F_entropy_accuracy,'"%d","%.4f"\n',i,accuracy);
end

fclose(F_gini_accuracy);
fclose(F_gini_predictions);
fclose(F_entropy_accuracy);
fclose(F_entropy_predictions);
