T = readtable('train_sample.csv');

tc = fitctree(T, Y)
YP = predict(tc, data)