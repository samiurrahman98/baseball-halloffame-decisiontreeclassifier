T = readtable('data/data.csv');

N = size(T, 1);
tf = false(N, 1);
tf(1:round(N * 0.8)) = true;
tf = tf(randperm(N));

DT = fitctree(T(tf,2:end-1), T_C(tf,end));
T_C = predict(DT, T(~tf,2:end-1));

csvwrite('data/predictions.csv', T_C);