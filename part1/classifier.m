T = readtable('train_sample.csv');
T_C = readtable('train_sample_classification.csv');

DT = fitctree(T(:,2:), T_C(:,2));
view(DT, 'mode', 'graph')
// YP = predict(tc, data);
