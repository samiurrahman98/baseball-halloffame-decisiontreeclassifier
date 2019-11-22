T = readtable('train_sample.csv');
T_C = readtable('train_sample_classification.csv');

DT = fitctree(T(:,2:end), T_C(:,2));

T = readtable('test_sample.csv');
T_C = predict(DT, T(:,2:end));

csvwrite('predictions.csv', T_C);