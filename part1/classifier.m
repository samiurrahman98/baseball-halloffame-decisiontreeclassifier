T = readtable('data/data.csv');
N = size(T,1);

T_A = table('Dataset number', 'Accuracy');

for i = 1:5
    tp = 0; tn = 0; fp = 0; fn = 0;

    tf = false(N,1);
    tf(1:round(N*0.8)) = true;
    tf = tf(randperm(N));

    DT = fitctree(T(tf,2:end-1), T(tf,end));
    predictions = predict(DT, T(~tf,2:end-1));

    M = size(predictions,1);
    for j = 1:M
        label = T(j,end);
        prediction = predictions(j);

        if label == 'Y' && prediction == 'Y'
            tp = tp+1;
        elseif label == 'N' && prediction == 'N'
            tn = tn+1;
        elseif label == 'N' && prediction == 'Y'
            fp = fp+1;
        elseif label == 'Y' && prediction == 'N'
            fn = fn+1;
        end
    end

    accuracy = (tp+tn)/(tp+tn+fp+fn)
end

writecsv(T_A,'g_4_DT_<metric>_accuracy.csv');