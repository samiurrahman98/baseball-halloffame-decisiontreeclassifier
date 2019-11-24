T = readtable('data.csv');
N = size(T,1);

F_A = fopen('g4_DT_gini_accuracy.csv','w');
fprintf(F_A,'"Dataset number","Accuracy"\n');
F_P = fopen('g4_DT_gini_predictions.csv','w');
fprintf(F_P,'"Iteration","Classification","Predictions"\n');

for i = 1:5
    tp = 0; tn = 0; fp = 0; fn = 0;

    tf = false(N,1);
    tf(1:round(N*0.8)) = true;
    tf = tf(randperm(N));

    DT = fitctree(T(tf,2:end-1), T(tf,end));

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
        fprintf(F_P,'"%d","%c","%c"\n',i,classification,prediction);
    end

    accuracy = (tp+tn)/(tp+tn+fp+fn);
    fprintf(F_A,'"%d","%d"\n',i,accuracy);
end

fclose(F_A);
fclose(F_P);