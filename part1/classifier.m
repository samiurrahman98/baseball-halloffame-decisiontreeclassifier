T = readtable('data.csv');
N = size(T,1);

F_gini_accuracy = fopen('g_4_DT_gini_accuracy.csv','w');
F_gini_predictions = fopen('g_4_DT_gini_predictions.csv','w');
fprintf(F_gini_accuracy,'"Dataset number","Accuracy"\n');
fprintf(F_gini_predictions,'"Iteration","Classification","Predictions"\n');

F_entropy_accuracy = fopen('g_4_DT_entropy_accuracy.csv','w');
F_entropy_predictions = fopen('g_4_DT_entropy_predictions.csv','w');
fprintf(F_entropy_accuracy,'"Dataset number","Accuracy"\n');
fprintf(F_entropy_predictions,'"Iteration","Classification","Predictions"\n');

// Gini
for i = 1:5
    tp = 0; tn = 0; fp = 0; fn = 0;

    tf = false(N,1);
    tf(1:round(N*0.8)) = true;
    tf = tf(randperm(N));

    DT = fitctree(T(tf,2:end-1), T(tf,end), 'SplitCriterion', 'gdi');

    classifications = T.('classification');
    predictions = predict(DT, T(~tf,2:end-1));

    M = size(predictions,1);
    for j = 1:M
        classification = char(classifications(j));
        prediction = char(predictions(j));

        if classification == 'Y' && prediction == 'Y'
            tp = tp+1;
        elseif classification == 'N' && prediction == 'N'
            tn = tn+1;
        elseif classification == 'N' && prediction == 'Y'
            fp = fp+1;
        elseif classification == 'Y' && prediction == 'N'
            fn = fn+1;
        end
        fprintf(F_gini_predictions,'"%d","%c","%c"\n',i,classification,prediction);
    end

    accuracy = (tp+tn)/(tp+tn+fp+fn);
    fprintf(F_gini_accuracy,'"%d","%.4f"\n',i,accuracy);
end

// Entropy
for i = 1:5
    tp = 0; tn = 0; fp = 0; fn = 0;

    tf = false(N,1);
    tf(1:round(N*0.8)) = true;
    tf = tf(randperm(N));

    DT = fitctree(T(tf,2:end-1), T(tf,end), 'SplitCriterion', 'deviance');

    classifications = T.('classification');
    predictions = predict(DT, T(~tf,2:end-1));

    M = size(predictions,1);
    for j = 1:M
        classification = char(classifications(j));
        prediction = char(predictions(j));

        if classification == 'Y' && prediction == 'Y'
            tp = tp+1;
        elseif classification == 'N' && prediction == 'N'
            tn = tn+1;
        elseif classification == 'N' && prediction == 'Y'
            fp = fp+1;
        elseif classification == 'Y' && prediction == 'N'
            fn = fn+1;
        end
        fprintf(F_entropy_predictions,'"%d","%c","%c"\n',i,classification,prediction);
    end

    accuracy = (tp+tn)/(tp+tn+fp+fn);
    fprintf(F_entropy_accuracy,'"%d","%.4f"\n',i,accuracy);
end

fclose(F_gini_accuracy);
fclose(F_gini_predictions);
fclose(F_entropy_accuracy);
fclose(F_entropy_predictions);