import pandas as pd
from sklearn.model_selection import train_test_split


def main():
    data = pd.read_csv("data.csv", index_col=0)

    y = data.classification
    X = data.drop("classification", axis=1)

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

    X_train.to_csv("train_sample.csv")
    y_train.to_csv("train_sample_classification.csv", header=True)
    X_test.to_csv("test_sample.csv")
    y_test.to_csv("test_sample_classification.csv", header=True)


if __name__ == '__main__':
    main()
