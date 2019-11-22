T = readtable('data/train_sample.csv');
T_C = readtable('data/train_sample_classifications.csv');

DT = fitctree(T(:,2:end), T_C(:,2));

T = readtable('data/test_sample.csv');
T_C = predict(DT, T(:,2:end));

csvwrite('data/predictions.csv', T_C);